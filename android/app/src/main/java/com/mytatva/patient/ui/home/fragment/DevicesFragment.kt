package com.mytatva.patient.ui.home.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Device
import com.mytatva.patient.data.pojo.response.MyDevicesData
import com.mytatva.patient.databinding.FragmentDevicesBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.fragment.SetupHeightWeightFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.home.adapter.HomeMyDeviceAdapter
import com.mytatva.patient.ui.mydevices.bottomsheet.DeviceInfoConnectBottomSheetDialog
import com.mytatva.patient.ui.mydevices.fragment.MeasureBcaReadingFragment
import com.mytatva.patient.ui.spirometer.fragment.SpirometerAllReadingsFragment
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class DevicesFragment : BaseFragment<FragmentDevicesBinding>() {
    private val devicesList = arrayListOf<MyDevicesData>()

    private val homeMyDevicesAdapter by lazy {
        HomeMyDeviceAdapter(devicesList, object : HomeMyDeviceAdapter.AdapterListener {
            override fun onLayoutClick(position: Int) {
                analytics.logEvent(
                        analytics.TAP_DEVICE_CARD,
                        Bundle().apply {
                            putString(analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.getDeviceNameFromKey(devicesList[position].key
                                    ?: ""))
                            putString(analytics.PARAM_SYNC_STATUS, if (devicesList[position].lastSyncDate.isNullOrBlank()) "N" else "Y")
                        },
                        screenName = AnalyticsScreenNames.Home
                )

                if (devicesList[position].lastSyncDate.isNullOrBlank()) {
                    handleOnConnectClick(position)
                } else {
                    when (devicesList[position].key) {
                        Device.BcaScale.deviceKey -> {
                            navigator.loadActivity(
                                    IsolatedFullActivity::class.java,
                                    MeasureBcaReadingFragment::class.java
                            ).start()
                        }

                        Device.Spirometer.deviceKey -> {
                            navigator.loadActivity(
                                    IsolatedFullActivity::class.java,
                                    SpirometerAllReadingsFragment::class.java
                            ).start()
                        }
                    }
                }

            }

            override fun onConnectClick(position: Int) {
                handleOnConnectClick(position)
            }
        })
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(inflater: LayoutInflater, container: ViewGroup?, attachToRoot: Boolean): FragmentDevicesBinding {
        return FragmentDevicesBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        binding.recyclerViewMyDevices.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = homeMyDevicesAdapter
        }
        updateMyDeviceList()
        setUpToolbar()
    }


    private fun setUpToolbar() {
        binding.apply {
            textViewToolbarTitle.text = getString(R.string.home_label_my_devices)
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { navigator.goBack() }
        }
    }

    private fun updateMyDeviceList() {
        session.user?.let { user ->
            devicesList.clear()

            user.devices?.let { it1 -> devicesList.addAll(it1) }
            if (AppFlagHandler.getIsToHideHomeBca(firebaseConfigUtil)) {
                devicesList.removeIf { it.key == Device.BcaScale.deviceKey }
            }
            if (session.user?.isCopdorAshthmaAPatient?.not() == true || AppFlagHandler.getIsToHideHomeSpirometer(firebaseConfigUtil)) {
                devicesList.removeIf { it.key == Device.Spirometer.deviceKey }
            }
            homeMyDevicesAdapter.notifyDataSetChanged()
        }
    }

    private fun handleOnConnectClick(position: Int) {
        analytics.logEvent(
                analytics.USER_CLICKS_ON_CONNECT,
                Bundle().apply {
                    putString(
                            analytics.PARAM_MEDICAL_DEVICE,
                            Common.MedicalDevice.getDeviceNameFromKey(devicesList[position].key
                                    ?: "")
                    )
                }, screenName = AnalyticsScreenNames.Home
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
            this.isFromHome = true
            this.myDevicesData = myDevicesData
        }.show(requireActivity().supportFragmentManager, DeviceInfoConnectBottomSheetDialog::class.java.simpleName)
    }


}