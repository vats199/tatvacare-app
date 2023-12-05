package com.mytatva.patient.ui.mydevices.bottomsheet

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Device
import com.mytatva.patient.data.pojo.response.MyDevicesData
import com.mytatva.patient.databinding.HomeBottomsheetDoYouAlreadyHaveDeviceBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.spirometer.fragment.v1.SpirometerEnterDetailsV1Fragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class DoYouHaveDeviceBottomSheetDialog :
    BaseBottomSheetDialogFragment<HomeBottomsheetDoYouAlreadyHaveDeviceBinding>() {

    var myDevicesData: MyDevicesData? = null

    var callback: (isHaveDevice: Boolean) -> Unit = {}

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): HomeBottomsheetDoYouAlreadyHaveDeviceBinding {
        return HomeBottomsheetDoYouAlreadyHaveDeviceBinding.inflate(layoutInflater)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.DoYouHaveDevice)
    }

    override fun bindData() {
        setUpViewListeners()
        setData()
    }

    private fun setData() = with(binding) {
        when (myDevicesData?.key) {
            Device.BcaScale.deviceKey -> {
                textViewDoYouHaveDevice.text =
                    getString(R.string.connect_smart_scale_label_do_you_have_device)
            }

            Device.Spirometer.deviceKey -> {
                textViewDoYouHaveDevice.text =
                    getString(R.string.connect_label_do_you_have_spirometer_device)
            }

            else -> {

            }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            textViewYes.setOnClickListener { onViewClick(it) }
            textViewNoWantToPurchase.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewYes -> {
                logAvailabilityEvent(true)
                when (myDevicesData?.key) {
                    Device.BcaScale.deviceKey -> {
                        setUpConnectDeviceBottomSheet()
                    }

                    Device.Spirometer.deviceKey -> {
                        (requireActivity() as BaseActivity).loadActivity(
                            IsolatedFullActivity::class.java,
                            SpirometerEnterDetailsV1Fragment::class.java
                        ).start()
                    }
                }
                dismiss()
            }

            R.id.textViewNoWantToPurchase -> {
                logAvailabilityEvent(false)
                dismiss()
            }
        }
    }

    private fun logAvailabilityEvent(isAvailable: Boolean) {
        analytics.logEvent(
            analytics.MEDICAL_DEVICE_AVAILABILITY, Bundle().apply {
                putString(
                    analytics.PARAM_MEDICAL_DEVICE,
                    Common.MedicalDevice.getDeviceNameFromKey(myDevicesData?.key ?: "")
                )
                putString(
                    analytics.PARAM_DEVICE_AVAILABILITY, if (isAvailable) "Yes" else "No"
                )
            }, screenName = AnalyticsScreenNames.DoYouHaveDevice
        )
    }

    private fun setUpConnectDeviceBottomSheet() {
        ConnectSmartScaleBottomSheetDialog().show(
            requireActivity().supportFragmentManager,
            ConnectSmartScaleBottomSheetDialog::class.java.simpleName
        )
    }
}