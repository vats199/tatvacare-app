package com.mytatva.patient.utils.lifetron

import android.Manifest
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.CountDownTimer
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.lifetrons.liblifetronssdk.ILSBleApiDiscoveryListener
import com.lifetrons.liblifetronssdk.LSBleApi
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.core.Session
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.qn.device.listener.QNResultCallback
import com.qn.device.out.QNBleDevice
import java.util.Calendar
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class LSBleManager @Inject constructor(val context: Context, val session: Session) {

    companion object {
        private const val REQUEST_CHECK_PERMISSION_BLUETOOTH = 105
    }

    var lsBleApi: LSBleApi? = null
    var connectionTimer: CountDownTimer? = null
    private var activity: BaseActivity? = null

    val height: Int by lazy {
        session.user?.getHeightValue ?: 0
    }
    val weightUnit: Int = 0

    private fun log(msg: String) {
        //activity?.showToast(msg)
        Log.d(this::class.java.simpleName, ":: $msg")
    }

    private val lsBleAPiListener = object : ILSBleApiDiscoveryListener {
        override fun onGetUnsteadyWeight(value: Double) {
            log("onGetUnsteadyWeight $value")
            if (value == 0.0) {

            }
            measureCallback?.invoke(BleApiStatus.GET_UNSTEADY_WEIGHT, null)
        }

        override fun onDetecting() {
            log("onDetecting")
            measureCallback?.invoke(BleApiStatus.DETECTING, null)
        }

        override fun onConnecting() {
            log("onConnecting")
            measureCallback?.invoke(BleApiStatus.CONNECTING, null)
        }

        override fun onConnectionFailed(p0: QNBleDevice?, p1: Int) {
            log("onConnectionFailed $p0 $p1")
            measureCallback?.invoke(BleApiStatus.CONNECTION_FAILED, null)
        }

        override fun onConnected(p0: QNBleDevice?) {
            log("onConnected $p0")
            if (searchCallback != null) {
                searchCallback?.invoke(p0, true)
                destroy()
            } else {
                measureCallback?.invoke(BleApiStatus.CONNECTED, null)
            }
        }

        override fun onDataReceived(p0: String?, p1: String?) {
            log("onDataReceived $p0 $p1")
            measureCallback?.invoke(BleApiStatus.DATA_RECEIVED, p0)
        }

        override fun onDisconnecting() {
            log("onDisconnecting")
            measureCallback?.invoke(BleApiStatus.DISCONNECTING, null)
        }

        override fun onDisconnected(p0: QNBleDevice?) {
            log("onDisconnected $p0")
            measureCallback?.invoke(BleApiStatus.DISCONNECTED, null)
        }

        override fun onWrongScaleDetected(p0: String?) {
            log("onWrongScaleDetected $p0")
            measureCallback?.invoke(BleApiStatus.WRONG_SCALE_DETECTED, null)
        }
    }

    /**
     * BleApiStatus
     * enum class for device connection status with message
     */
    enum class BleApiStatus(val message: String) {
        GET_UNSTEADY_WEIGHT("Syncing data. Do not step down"),
        DETECTING("Searching for the device"),
        CONNECTING("Connecting to the device"),
        CONNECTION_FAILED("The device has been disconnected. Please reconnect the device and try again."),
        CONNECTED("Syncing data. Do not step down"),
        DATA_RECEIVED("Data fetched"),
        DISCONNECTING("Device disconnecting"),
        DISCONNECTED("Device disconnected"),
        WRONG_SCALE_DETECTED("Wrong scale detected"),
    }

    /**
     * searchDevice
     * public fun to init the flow for searching the device
     * @param searchCallback
     */
    var searchCallback: ((device: QNBleDevice?, success: Boolean) -> Unit)? = null
    fun searchDevice(
        activity: BaseActivity,
        searchCallback: (device: QNBleDevice?, success: Boolean) -> Unit,
    ) {
        this.activity = activity
        this.searchCallback = searchCallback
        measureCallback = null // null measure callback if it's for measure
        checkAndConnectToBLE()
    }

    /**
     * connectAndMeasure
     * public fun to init the flow for measuring the readings
     * @param measureCallback
     */
    var measureCallback: ((status: BleApiStatus, data: String?) -> Unit)? = null
    fun connectAndMeasure(
        activity: BaseActivity,
        measureCallback: (status: BleApiStatus, data: String?) -> Unit,
    ) {
        this.activity = activity
        this.measureCallback = measureCallback
        searchCallback = null // null search callback if it's for measure
        checkAndConnectToBLE()
    }

    /**
     * initSDK
     * initialize SDK on app start
     */
    fun initSDK() {
        LSBleApi.getInstance(context)
            .initSdk(BuildConfig.LIFETRON_APP_ID, BuildConfig.LIFETRON_SDK_CONFIG) { code, msg ->
                log("code = $code :: msg = $msg")
            }
    }

    /**
     * isBluetoothEnabled
     * checks bluetooth status
     */
    private fun isBluetoothEnabled(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
            && ActivityCompat.checkSelfPermission(
                activity!!,
                Manifest.permission.BLUETOOTH_CONNECT
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return false
        }

        val bluetoothManager =
            context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter = bluetoothManager.adapter
        return bluetoothManager.adapter.isEnabled
    }

    /**
     * isRequiredPermissionGranted
     * checked weather permissions granted or not
     */
    private fun isRequiredPermissionGranted(context: Context?): Boolean {
        return !(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
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
        ) != PackageManager.PERMISSION_GRANTED))

        /*if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S
                && (ContextCompat.checkSelfPermission(context!!,
                    Manifest.permission.BLUETOOTH_SCAN) != PackageManager.PERMISSION_GRANTED
                        || ContextCompat.checkSelfPermission(context,
                    Manifest.permission.BLUETOOTH_ADVERTISE) != PackageManager.PERMISSION_GRANTED
                        || ContextCompat.checkSelfPermission(context,
                    Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED)
            ) {
                false
            } else !(Build.VERSION.SDK_INT < Build.VERSION_CODES.S
                    && (ContextCompat.checkSelfPermission(context!!,
                Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED
                    || ContextCompat.checkSelfPermission(context,
                Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED))*/
    }

    /**
     * checkAndConnectToBLE
     * handle permissions
     */
    private fun checkAndConnectToBLE() {
        if (isRequiredPermissionGranted(activity)) {
            if (isBluetoothEnabled()) {
                connectToSmartScale()
            } else {
                //this.showMessageOnUI(getString(R.string.turn_on_ble))
                // bluetooth is off
            }
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
                ActivityCompat.requestPermissions(
                    activity!!, arrayOf(
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    ), REQUEST_CHECK_PERMISSION_BLUETOOTH
                )

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

                //bluetooth permission asked
            }
        }
    }

    /**
     * connectToSmartScale
     * init, connect to scale and start scanning
     */
    private fun connectToSmartScale() {
        // init lsBleApi instance
        lsBleApi = LSBleApi.getInstance(activity)

        // init and start timer
        this.connectionTimer = object : CountDownTimer(20000, 1000) {
            override fun onTick(l: Long) {}
            override fun onFinish() {
                log("Not able to connect")
                destroy()
                if (searchCallback != null) {
                    searchCallback?.invoke(null, false)
                } else {
                    measureCallback?.invoke(BleApiStatus.DISCONNECTED, null)
                }
            }
        }
        this.connectionTimer?.start()

        // setup listener
        this.lsBleApi?.lsBleApiListener = lsBleAPiListener

        // get user dob
        val calDob = Calendar.getInstance()
        try {
            calDob.timeInMillis = DateTimeFormatter.date(
                session.user?.dob,
                DateTimeFormatter.FORMAT_yyyyMMdd
            ).date?.time!!
        } catch (e: Exception) {
            e.printStackTrace()
        }

        // build user
        this.lsBleApi?.buildUser(
            session.userId, // userId
            this.height, // height CM
            if (session.user?.gender == "M") "male" else "female", // gender
            calDob.time, // user dob
            QNResultCallback { code, msg ->
                log("buildUser $code, $msg")
            })

        // start scanning
        this.lsBleApi?.startLSScanDevice(
            this.weightUnit,
            QNResultCallback { code, msg ->
                log("startLSScanDevice $code, $msg")
            })
    }

    /**
     * onRequestPermissionsResult
     * handle permission result
     */
    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        when (requestCode) {
            REQUEST_CHECK_PERMISSION_BLUETOOTH -> {
                if (PermissionUtil.verifyPermissions(grantResults)) {
                    checkAndConnectToBLE()
                }
            }


            else -> {

            }
        }
    }

    /**
     * destroy
     * cancel timer and stop scanning
     */
    fun destroy() {
        lsBleApi?.stopLSScanDevice()
        connectionTimer?.cancel()
    }
}