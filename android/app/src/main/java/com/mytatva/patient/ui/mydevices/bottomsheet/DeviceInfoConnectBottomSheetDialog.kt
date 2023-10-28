package com.mytatva.patient.ui.mydevices.bottomsheet

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Device
import com.mytatva.patient.data.pojo.response.MyDevicesData
import com.mytatva.patient.databinding.MydeviceBottomsheetDeviceInfoConnectBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentCarePlanListingFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.ui.spirometer.fragment.v1.SpirometerEnterDetailsV1Fragment

class DeviceInfoConnectBottomSheetDialog : BaseBottomSheetDialogFragment<MydeviceBottomsheetDeviceInfoConnectBinding>() {

    var myDevicesData: MyDevicesData? = null

    var isFromHome = false

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MydeviceBottomsheetDeviceInfoConnectBinding {
        return MydeviceBottomsheetDeviceInfoConnectBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        if (isFromHome) {
            analytics.setScreenName(AnalyticsScreenNames.DoYouHaveDevice)
        } else {
            analytics.setScreenName(AnalyticsScreenNames.ConnectDeviceInfo)
        }
    }

    override fun bindData() = with(binding) {
        setUpUI()
        setDeviceData()
        setUpViewListeners()
    }

    private fun setUpUI() = with(binding) {
        if (isFromHome) {
            buttonClose.text = "No, Purchase"
            buttonConnect.text = "Yes, Connect"
        } else {
            buttonClose.text = "Close"
            buttonConnect.text = "Connect"
        }
    }

    private fun setDeviceData() = with(binding) {
        myDevicesData?.let {
            val image = when (it.key) {
                Device.BcaScale.deviceKey -> {
                    R.drawable.ic_bca_big
                }

                Device.Spirometer.deviceKey -> {
                    R.drawable.ic_spiro_big
                }

                else -> {
                    Device.BcaScale.deviceIcon
                }
            }
            imageViewDevice.setImageResource(image)
            textViewDeviceName.text = it.title

            //set smart analyser text only as, spirometer branch is different
            textViewDeviceInfo.text = if (it.key == Device.BcaScale.deviceKey)
                "The Smart Analyzer helps you safeguard your health with precision. By monitoring your body's vital data, you can take charge of your well-being, and make informed decisions. \n" +
                        "\n" +
                        "Do you have the device to monitor your overall vitals?"
            else "This portable medical device can assist you in monitoring your lung health. By keeping track of your condition, it can help prevent attacks and minimise the need for hospital visits.\n" +
                    "\n" +
                    "Do you have the device to monitor your lung health?"
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonClose.setOnClickListener { onViewClick(it) }
            buttonConnect.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonClose -> {
                logAvailabilityEvent(false)
                if (isFromHome) {
                    (requireActivity() as BaseActivity).loadActivity(
                        IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
                    ).start()
                    dismiss()
                } else {
                    dismiss()
                }
            }

            R.id.buttonConnect -> {
                logAvailabilityEvent(true)
                when (myDevicesData?.key) {
                    Device.BcaScale.deviceKey -> {
                        setUpConnectDeviceBottomSheet()
                        dismiss()
                    }

                    Device.Spirometer.deviceKey -> {
                        /*(requireActivity() as BaseActivity).loadActivity(
                            IsolatedFullActivity::class.java, SpirometerEnterDetailsFragment::class.java
                        ).start()*/
                        (requireActivity() as BaseActivity).loadActivity(
                            IsolatedFullActivity::class.java, SpirometerEnterDetailsV1Fragment::class.java
                        ).start()
                        dismiss()
                    }
                }

            }
        }
    }

    private fun logAvailabilityEvent(isAvailable: Boolean) {
        analytics.logEvent(
            analytics.MEDICAL_DEVICE_AVAILABILITY, Bundle().apply {
                putString(
                    analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.getDeviceNameFromKey(myDevicesData?.key ?: "")
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