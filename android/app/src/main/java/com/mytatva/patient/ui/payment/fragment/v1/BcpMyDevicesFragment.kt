package com.mytatva.patient.ui.payment.fragment.v1

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Device
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcpMyDevicesData
import com.mytatva.patient.data.pojo.response.MyDevicesData
import com.mytatva.patient.databinding.PaymentFragmentBcpMyDevicesBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.fragment.SetupHeightWeightFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.home.adapter.HomeMyDeviceAdapter
import com.mytatva.patient.ui.menu.dialog.HelpDialog
import com.mytatva.patient.ui.mydevices.bottomsheet.DeviceInfoConnectBottomSheetDialog
import com.mytatva.patient.ui.mydevices.fragment.MeasureBcaReadingFragment
import com.mytatva.patient.ui.spirometer.fragment.SpirometerAllReadingsFragment
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.enableShadow
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class BcpMyDevicesFragment : BaseFragment<PaymentFragmentBcpMyDevicesBinding>() {

    private var bcpMyDevicesData: BcpMyDevicesData? = null

    private val patientPlanRelId by lazy {
        arguments?.getString(Common.BundleKey.PATIENT_PLAN_REL_ID)
    }

    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    private val devicesList = arrayListOf<MyDevicesData>()
    private val homeMyDevicesAdapter by lazy {
        HomeMyDeviceAdapter(devicesList, object : HomeMyDeviceAdapter.AdapterListener {
            override fun onLayoutClick(position: Int) {

                analytics.logEvent(
                    analytics.TAP_DEVICE_CARD,
                    Bundle().apply {
                        putString(analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.getDeviceNameFromKey(devicesList[position].key?:""))
                        putString(analytics.PARAM_SYNC_STATUS, if(devicesList[position].lastSyncDate.isNullOrBlank()) "N" else "Y")
                    },
                    screenName = AnalyticsScreenNames.BcpDeviceDetails
                )

                if (devicesList[position].lastSyncDate.isNullOrBlank()) {
                    handleOnConnectClick(position)
                } else {
                    when (devicesList[position].key) {
                        Device.BcaScale.deviceKey -> {
                            navigator.loadActivity(IsolatedFullActivity::class.java, MeasureBcaReadingFragment::class.java).start()
                        }

                        Device.Spirometer.deviceKey -> {
                            navigator.loadActivity(IsolatedFullActivity::class.java, SpirometerAllReadingsFragment::class.java).start()
                        }
                    }
                }
            }

            override fun onConnectClick(position: Int) {
                handleOnConnectClick(position)
            }
        })
    }

    private fun handleOnConnectClick(position: Int) {

        analytics.logEvent(
            analytics.USER_CLICKS_ON_CONNECT,
            Bundle().apply {
                putString(
                    analytics.PARAM_MEDICAL_DEVICE,
                    Common.MedicalDevice.getDeviceNameFromKey(devicesList[position].key ?: "")
                )
            }, screenName = AnalyticsScreenNames.BcpDeviceDetails
        )

        when (devicesList[position].key) {
            Device.BcaScale.deviceKey -> {

                if ((session.user?.getHeightValue ?: 0) > 0) {
                    initConnectDeviceFlow(devicesList[position])
                } else {
                    navigator.showAlertDialogWithOptions(getString(R.string.validation_add_height_to_connect_device),
                        positiveText = "Add",
                        negativeText = "Cancel",
                        dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                            override fun onYesClick() {
                                navigator.loadActivity(
                                    IsolatedFullActivity::class.java,
                                    SetupHeightWeightFragment::class.java
                                ).start()
                            }

                            override fun onNoClick() {

                            }
                        })
                }

            }

            Device.Spirometer.deviceKey -> {
                initConnectDeviceFlow(devicesList[position])
            }
        }

    }

    private fun initConnectDeviceFlow(myDevicesData: MyDevicesData) {
        DeviceInfoConnectBottomSheetDialog().apply {
            this.myDevicesData = myDevicesData
        }.show(requireActivity().supportFragmentManager, DeviceInfoConnectBottomSheetDialog::class.java.simpleName)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentBcpMyDevicesBinding {
        return PaymentFragmentBcpMyDevicesBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun bindData() {
        setUpRecyclerView()
        setUpToolbar()
        setUpViewListeners()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BcpDeviceDetails)
        myDevices()
    }

    private fun setUpViewListeners() {
        with(binding) {
            layoutContactUs.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //root.enableShadow()
            textViewToolbarTitle.text = getString(R.string.payment_bcp_my_device_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewHelp.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.layoutContactUs -> {
                analytics.logEvent(
                    analytics.TAP_CONTACT_US,
                    /*Bundle().apply {
                        putString(analytics.PARAM_PLAN_ID, bcpMyDevicesData)
                    },*/
                    screenName = AnalyticsScreenNames.BcpDeviceDetails
                )

                requireActivity().supportFragmentManager.let {
                    HelpDialog().show(it, HelpDialog::class.java.simpleName)
                }
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewMyDevices.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = homeMyDevicesAdapter
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun myDevices() {
        val apiRequest = ApiRequest().apply {
            patient_plan_rel_id = patientPlanRelId
        }
        showLoader()
        patientPlansViewModel.myDevices(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        patientPlansViewModel.myDevicesLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                bcpMyDevicesData = responseBody.data
                setDetails()
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException){
                    throwable.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun setDetails() {
        if (isAdded) {
            with(binding) {
                textViewName.text = session.user?.name
                textViewEmail.text = session.user?.email
                textViewContact.text = session.user?.country_code + " " + session.user?.contact_no
                textViewPickupFromAddress.text = bcpMyDevicesData?.address_data?.addressLabel
                textViewValueOrderId.text = bcpMyDevicesData?.transaction_id
                textViewValueStatus.text = bcpMyDevicesData?.status

                devicesList.clear()
                bcpMyDevicesData?.devices?.let { devicesList.addAll(it) }
                //devicesList.removeIf { it.key == Device.Spirometer.deviceKey }
                homeMyDevicesAdapter.notifyDataSetChanged()
            }
        }
    }
}