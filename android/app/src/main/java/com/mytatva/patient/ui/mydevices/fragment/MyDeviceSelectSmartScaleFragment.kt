package com.mytatva.patient.ui.mydevices.fragment

import android.annotation.SuppressLint
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
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.response.MyDeviceSelectSmartScaleData
import com.mytatva.patient.databinding.MydeviceFragmentSelectSmartScaleBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.mydevices.adapter.MyDeviceSelectSmartScaleAdapter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.lifetron.LSBleManager
import com.mytatva.patient.utils.lifetron.MyBluetoothManager
import com.qn.device.out.QNBleDevice
import javax.inject.Inject

class MyDeviceSelectSmartScaleFragment : BaseFragment<MydeviceFragmentSelectSmartScaleBinding>() {

    enum class DeviceState {
        SEARCHING, NOT_FOUND, FOUND
    }

    private var deviceState = DeviceState.SEARCHING

    private val mReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent) {
            val action: String? = intent.action
            if (action == BluetoothAdapter.ACTION_STATE_CHANGED) {
                val state: Int =
                    intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR)
                when (state) {
                    BluetoothAdapter.STATE_OFF -> {
                        Log.d("Bluetooth", "onReceive: STATE_OFF")
                        handleOnBluetoothOff()
                    }

                    BluetoothAdapter.STATE_TURNING_OFF -> {

                    }

                    BluetoothAdapter.STATE_ON -> {
                        Log.d("Bluetooth", "onReceive: STATE_ON")
                    }

                    BluetoothAdapter.STATE_TURNING_ON -> {

                    }
                }
            }
        }
    }

    private fun handleOnBluetoothOff() {
        if (isAdded) {
            with(binding) {
                deviceState = DeviceState.NOT_FOUND
                updateDeviceUI()
                showTurnOnBluetoothDialog()
            }
        }
    }

    private fun showTurnOnBluetoothDialog() {
        navigator.showAlertDialog(getString(R.string.common_msg_turn_on_bluetooth),
            dialogOkListener = object : BaseActivity.DialogOkListener {
                override fun onClick() {
                    myBluetoothManager.turnOnBluetooth(requireActivity() as BaseActivity)
                }
            })
    }

    @Inject
    lateinit var lsBleManager: LSBleManager

    @Inject
    lateinit var myBluetoothManager: MyBluetoothManager

    private val list = arrayListOf<MyDeviceSelectSmartScaleData>()
    private val myDeviceSelectSmartScaleAdapter by lazy {
        MyDeviceSelectSmartScaleAdapter(list,
            adapterListener = object : MyDeviceSelectSmartScaleAdapter.AdapterListener {
                override fun onItemClick(position: Int) {

                    analytics.logEvent(
                        analytics.USER_SELECTS_MEDICAL_DEVICE, Bundle().apply {
                            putString(
                                analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.BCA
                            )
                        }, screenName = AnalyticsScreenNames.SearchSelectSmartScale
                    )

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        MeasureBcaReadingFragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.IS_TO_SHOW_MEASURE, true)
                        )
                    ).byFinishingCurrent().start()
                }
            })
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MydeviceFragmentSelectSmartScaleBinding {
        return MydeviceFragmentSelectSmartScaleBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        requireActivity().registerReceiver(mReceiver, filter)
    }

    override fun onDestroy() {
        lsBleManager.destroy()
        requireActivity().unregisterReceiver(mReceiver)
        super.onDestroy()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SearchSelectSmartScale)
    }

    override fun bindData() {
        setUpRecyclerView()
        setUpToolbar()
        setUpViewListeners()

        startSearching()
    }

    private var searchAttempt = 0
    private fun logSearchActionEvent() {
        searchAttempt++
        analytics.logEvent(
            analytics.MEDICAL_DEVICE_SEARCH_ACTION, Bundle().apply {
                putInt(
                    analytics.PARAM_ATTEMPT, searchAttempt
                )
                putString(
                    analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.BCA
                )
            }, screenName = AnalyticsScreenNames.SearchSelectSmartScale
        )
    }

    private fun startSearching() {
        logSearchActionEvent()
        lsBleManager.searchDevice(
            requireActivity() as BaseActivity,
            searchCallback = { device, success ->
                if (isAdded) {
                    if (success) {
                        deviceState = DeviceState.FOUND
                        addDevice(device)
                    } else {
                        deviceState = DeviceState.NOT_FOUND
                    }
                    updateDeviceUI()
                }
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun addDevice(device: QNBleDevice?) {
        if (isAdded) {
            binding.layoutHeader.textViewToolbarTitle.text =
                getString(R.string.select_smart_scale_list_title_select)
            list.clear()
            list.add(MyDeviceSelectSmartScaleData(device?.name ?: "BCA Device"))
            myDeviceSelectSmartScaleAdapter.notifyDataSetChanged()
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.select_smart_scale_list_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.visibility = View.GONE
            imageViewToolbarCart.visibility = View.GONE
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSearchAgain.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonSearchAgain -> {
                if (myBluetoothManager.isBluetoothEnabled()) {
                    deviceState = DeviceState.SEARCHING
                    updateDeviceUI()
                    startSearching()
                } else {
                    myBluetoothManager.turnOnBluetooth(requireActivity() as BaseActivity)
                }
            }
        }
    }

    private fun updateDeviceUI() {
        with(binding) {
            when (deviceState) {
                DeviceState.SEARCHING -> {
                    layoutScaleNotFound.isVisible = false
                    layoutDevices.isVisible = false
                    layoutSearchingDevice.isVisible = true
                }

                DeviceState.FOUND -> {
                    layoutSearchingDevice.isVisible = false
                    layoutScaleNotFound.isVisible = false
                    layoutDevices.isVisible = true
                }

                DeviceState.NOT_FOUND -> {
                    layoutSearchingDevice.isVisible = false
                    layoutDevices.isVisible = false
                    layoutScaleNotFound.isVisible = true
                }
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewAllDevices.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = myDeviceSelectSmartScaleAdapter
        }
    }
}