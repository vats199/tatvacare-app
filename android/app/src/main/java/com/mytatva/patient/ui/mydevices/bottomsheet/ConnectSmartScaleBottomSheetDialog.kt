package com.mytatva.patient.ui.mydevices.bottomsheet

import android.bluetooth.BluetoothAdapter
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Device
import com.mytatva.patient.databinding.HomeBottomsheetConnectSmartScaleBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.mydevices.fragment.MyDeviceSelectSmartScaleFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.lifetron.MyBluetoothManager
import javax.inject.Inject

class ConnectSmartScaleBottomSheetDialog :
    BaseBottomSheetDialogFragment<HomeBottomsheetConnectSmartScaleBinding>() {

    @Inject
    lateinit var myBluetoothManager: MyBluetoothManager

    var deviceKey = Device.BcaScale.deviceKey
    var spiroProceedCallback:()->Unit={}

    private val mReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent) {
            val action: String? = intent.action
            if (action == BluetoothAdapter.ACTION_STATE_CHANGED) {
                val state: Int =
                    intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR)
                when (state) {
                    BluetoothAdapter.STATE_OFF -> {
                        Log.d("Bluetooth", "onReceive: STATE_OFF")
                        binding.switchBluetooth.isChecked = false
                        logToggleBluetoothEvent(false)
                    }

                    BluetoothAdapter.STATE_TURNING_OFF -> {

                    }

                    BluetoothAdapter.STATE_ON -> {
                        Log.d("Bluetooth", "onReceive: STATE_ON")
                        binding.switchBluetooth.isChecked = true
                        logToggleBluetoothEvent(true)
                    }

                    BluetoothAdapter.STATE_TURNING_ON -> {

                    }
                }
            }
        }
    }

    private fun logToggleBluetoothEvent(isOn: Boolean) {
        analytics.logEvent(
            analytics.USER_TOGGLES_BLUETOOTH, Bundle().apply {
                putString(
                    analytics.PARAM_TOGGLE, if (isOn) "Yes" else "No"
                )
                putString(
                    analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.BCA
                )
            }, screenName = AnalyticsScreenNames.ConnectDevice
        )
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): HomeBottomsheetConnectSmartScaleBinding {
        return HomeBottomsheetConnectSmartScaleBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        requireActivity().registerReceiver(mReceiver, filter)
    }

    override fun onDestroy() {
        super.onDestroy()
        requireActivity().unregisterReceiver(mReceiver)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ConnectDevice)
        updateSwitchAsPerBluetoothStatus()
    }

    override fun bindData() = with(binding) {
        setUpViewListeners()
        setUpUIAsPerDevice()
        locationManager.startLocationUpdates { location, exception ->
            locationManager.stopFetchLocationUpdates()
        }
    }

    private fun setUpUIAsPerDevice() = with(binding) {
        when (deviceKey) {
            Device.BcaScale.deviceKey -> {
                textViewConnectSmartScale.text = getString(R.string.connect_smart_scale_label_connect_device)
                textViewLearnHowToConnect.isVisible = true
                imageViewStepUp.setImageResource(R.drawable.ic_stepup)
                textViewStepUpOnscale.text = getString(R.string.connect_smart_scale_label_step_up)
                buttonSearchDevice.text = getString(R.string.connect_smart_scale_button_search)
            }

            Device.Spirometer.deviceKey -> {
                textViewConnectSmartScale.text = "Connect Lung Function Analyser"
                textViewLearnHowToConnect.isVisible = false
                imageViewStepUp.setImageResource(R.drawable.ic_bluetooth_spiro)
                textViewStepUpOnscale.text = "Turn on Bluetooth to connect\nyour device"
                buttonSearchDevice.text = "Proceed"
            }
        }
    }

    private fun updateSwitchAsPerBluetoothStatus() {
        if (myBluetoothManager.isRequiredPermissionGranted(requireContext())) {
            binding.switchBluetooth.isChecked = myBluetoothManager.isBluetoothEnabled()
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            switchBluetooth.setOnCheckedChangeListener { buttonView, isChecked ->
                buttonSearchDevice.isEnabled = isChecked
            }
            switchBluetooth.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonSearchDevice.setOnClickListener { onViewClick(it) }
            textViewLearnHowToConnect.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.switchBluetooth -> {
                with(binding) {
                    switchBluetooth.isChecked = switchBluetooth.isChecked.not()
                    if (switchBluetooth.isChecked) {
                        showMessage("You can turn off bluetooth from device settings")
                    } else {
                        myBluetoothManager.turnOnBluetooth(requireActivity() as BaseActivity)
                    }
                }
            }

            R.id.imageViewClose -> {
                dismiss()
            }

            R.id.buttonSearchDevice -> {
                if (deviceKey == Device.Spirometer.deviceKey) {
                    spiroProceedCallback.invoke()
                    dismiss()
                } else {
                    (requireActivity() as BaseActivity).loadActivity(
                        IsolatedFullActivity::class.java,
                        MyDeviceSelectSmartScaleFragment::class.java
                    ).start()
                    dismiss()
                }
            }

            R.id.textViewLearnHowToConnect -> {
                analytics.logEvent(
                    analytics.USER_TAPS_ON_LEARN_TO_CONNECT, Bundle().apply {
                        putString(
                            analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.BCA
                        )
                    }, screenName = AnalyticsScreenNames.ConnectDevice
                )
                setUpHowToConnectBottomSheet()
            }
        }
    }

    private fun setUpHowToConnectBottomSheet() {
        LearnHowToConnectBottomSheetDialog().show(childFragmentManager, null)
    }
}