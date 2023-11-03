package com.mytatva.patient.utils.lifetron

import android.Manifest
import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.mytatva.patient.core.Session
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.PermissionUtil
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class MyBluetoothManager @Inject constructor(val context: Context, val session: Session) {

    companion object {
        private const val REQUEST_CHECK_PERMISSION_BLUETOOTH = 105
        private const val REQUEST_CHECK_PERMISSION_LOCATION = 106
    }

    private var activity: BaseActivity? = null

    private fun log(msg: String) {
        Log.d(this::class.java.simpleName, ":: $msg")
    }

    @SuppressLint("MissingPermission")
    fun turnOnBluetooth(activity: BaseActivity) {
        this.activity = activity
        if (isRequiredPermissionGranted(activity)) {
            /*if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                val bluetoothManager =
                    context.getSystemService(Context.BLUETOOTH_SERVICE) as android.bluetooth.BluetoothManager
                val bluetoothAdapter = bluetoothManager.adapter
                @Suppress("DEPRECATION")
                bluetoothAdapter.enable()
            } else {*/
            //need to check
            val turnOn = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            activity.startActivityForResult(turnOn, 0)
            /*}*/
        } else {
            requestBluetoothPermissions()
        }
    }

    fun requestBluetoothPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {

            ActivityCompat.requestPermissions(
                activity!!, arrayOf(
                    Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ), REQUEST_CHECK_PERMISSION_BLUETOOTH
            )

            /*if (ActivityCompat.shouldShowRequestPermissionRationale(activity!!, Manifest.permission.ACCESS_COARSE_LOCATION)
                && ActivityCompat.shouldShowRequestPermissionRationale(activity!!, Manifest.permission.ACCESS_FINE_LOCATION)
            ) {
                ActivityCompat.requestPermissions(
                    activity!!, arrayOf(
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ), REQUEST_CHECK_PERMISSION_BLUETOOTH
                )
            } else {
                activity?.showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location))
            }*/

            //location permission asked
            //this.showMessageOnUI(getString(R.string.android_6_req_location_permission))
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {

            ActivityCompat.requestPermissions(
                activity!!, arrayOf(
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_ADVERTISE,
                    Manifest.permission.BLUETOOTH_CONNECT
                ), REQUEST_CHECK_PERMISSION_BLUETOOTH
            )

            /*if (ActivityCompat.shouldShowRequestPermissionRationale(activity!!, Manifest.permission.BLUETOOTH_SCAN)
                && ActivityCompat.shouldShowRequestPermissionRationale(activity!!, Manifest.permission.BLUETOOTH_ADVERTISE)
                && ActivityCompat.shouldShowRequestPermissionRationale(activity!!, Manifest.permission.BLUETOOTH_CONNECT)
            ) {
                ActivityCompat.requestPermissions(
                    activity!!, arrayOf(
                        Manifest.permission.BLUETOOTH_SCAN,
                        Manifest.permission.BLUETOOTH_ADVERTISE,
                        Manifest.permission.BLUETOOTH_CONNECT
                    ), REQUEST_CHECK_PERMISSION_BLUETOOTH
                )
            } else {
                activity?.showOpenPermissionSettingDialog()
            }*/
            //bluetooth permission asked
        }
    }

    @SuppressLint("MissingPermission")
    fun isBluetoothEnabled(): Boolean {
        val myBluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter = myBluetoothManager.adapter
        return myBluetoothManager.adapter.isEnabled
    }


    fun isRequiredPermissionGranted(context: Context?): Boolean {
        /*return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
                && (ContextCompat.checkSelfPermission(context!!,
            Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(context,
            Manifest.permission.BLUETOOTH_ADVERTISE) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(context,
            Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED))*/

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
            && (ContextCompat.checkSelfPermission(
                context!!,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
                    || ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_ADVERTISE
            ) != PackageManager.PERMISSION_GRANTED
                    || ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_CONNECT
            ) != PackageManager.PERMISSION_GRANTED)
        ) {
            false
        } else !(Build.VERSION.SDK_INT < Build.VERSION_CODES.S
                && (ContextCompat.checkSelfPermission(
            context!!,
            Manifest.permission.ACCESS_COARSE_LOCATION
        ) != PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(
            context,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) != PackageManager.PERMISSION_GRANTED))

    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        when (requestCode) {
            REQUEST_CHECK_PERMISSION_BLUETOOTH -> {
                if (PermissionUtil.verifyPermissions(grantResults)) {
                    turnOnBluetooth(activity!!)
                } else {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                        //locations
                        activity?.showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location))
                    } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        //bluetooth
                        activity?.showOpenPermissionSettingDialog(
                            arrayListOf(
                                BaseActivity.AndroidPermissions.Location,
                                BaseActivity.AndroidPermissions.Bluetooth
                            )
                        )
                    }
                }
            }

            else -> {

            }
        }
    }

}
