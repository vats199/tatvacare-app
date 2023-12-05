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
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.gson.Gson
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.UpdateBcaVitalsApiRequest
import com.mytatva.patient.data.pojo.response.GetBcaReadingsMainData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.MydeviceFragmentMeasureBcaReadingsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.mydevices.adapter.BcaMyReadingsAdapter
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.lifetron.LSBleManager
import com.mytatva.patient.utils.lifetron.MyBluetoothManager
import javax.inject.Inject

class MeasureBcaReadingFragment : BaseFragment<MydeviceFragmentMeasureBcaReadingsBinding>() {

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
            if (isMeasuring) {
                with(binding) {
                    buttonMeasure.isEnabled = true
                    textViewSyncingData.text =
                        getString(R.string.measure_bca_reading_default_state_message)
                    showTurnOnBluetoothDialog()
                }
            }
        }
    }

    private val goalReadingViewModel: GoalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    private val isToShowMeasure: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_TO_SHOW_MEASURE) ?: false
    }

    @Inject
    lateinit var lsBleManager: LSBleManager

    @Inject
    lateinit var myBluetoothManager: MyBluetoothManager

    private val readingList = ArrayList<GoalReadingData>()

    private val bcaMyReadingsAdapter by lazy {
        BcaMyReadingsAdapter(readingList,
            adapterListener = object : BcaMyReadingsAdapter.AdapterListener {
                override fun onItemClick(position: Int) {

                    analytics.logEvent(
                        analytics.USER_CLICKED_ON_DEVICE_READINGS, Bundle().apply {
                            putString(
                                analytics.PARAM_READING_ID, readingList[position].readings_master_id
                            )
                            putString(
                                analytics.PARAM_READING_NAME, readingList[position].reading_name
                            )
                            putString(
                                analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.BCA
                            )
                        }, screenName = AnalyticsScreenNames.MeasureSmartScaleReadings
                    )

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BcaReadingDataAnalysisMainFragment::class.java
                    ).addBundle(Bundle().apply {
                        putString(Common.BundleKey.KEY, readingList[position].keys)
                    }).start()
                }
            })
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        requireActivity().registerReceiver(mReceiver, filter)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MydeviceFragmentMeasureBcaReadingsBinding {
        return MydeviceFragmentMeasureBcaReadingsBinding.inflate(layoutInflater)
    }

    override fun onDestroy() {
        lsBleManager.destroy()
        requireActivity().unregisterReceiver(mReceiver)
        super.onDestroy()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.MeasureSmartScaleReadings)
    }

    override fun bindData() {
        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()

        if (isToShowMeasure) {
            binding.groupMeasure.isVisible = true
            //measureData()
            binding.lotteeAnimationSyncData.pauseAnimation()
        } else {
            binding.groupMeasure.isVisible = false
        }
        if (session.user?.lastBcaSyncDate.isNullOrBlank().not()) {
            getBcaVitals()
            binding.layoutHeader.imageViewDownload.visibility = View.VISIBLE
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "Measure Health Markers"
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.visibility = View.GONE
            imageViewToolbarCart.visibility = View.GONE
            imageViewDownload.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonMeasure.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonMeasure -> {

                analytics.logEvent(
                    analytics.USER_CLICKS_MEASURE, Bundle().apply {
                        putString(
                            analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.BCA
                        )
                    }, screenName = AnalyticsScreenNames.MeasureSmartScaleReadings
                )

                if (myBluetoothManager.isBluetoothEnabled()) {
                    //(requireActivity() as BaseActivity).showToast("bluetooth on")
                    measureData()
                } else {
                    showTurnOnBluetoothDialog()
                }
            }

            R.id.imageViewDownload -> {
                generateBcaReport()
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

    private var isMeasuring = false
    private var isDateFetched = false
    private fun measureData() {
        isMeasuring = true
        binding.buttonMeasure.isEnabled = false
        binding.lotteeAnimationSyncData.resumeAnimation()
        isDateFetched = false
        lsBleManager.connectAndMeasure(requireActivity() as BaseActivity,
            measureCallback = { status, data ->
                if (isAdded) {
                    when (status) {
                        LSBleManager.BleApiStatus.GET_UNSTEADY_WEIGHT -> {
                            updateStatusUI(status.message)
                        }

                        LSBleManager.BleApiStatus.DETECTING -> {
                            updateStatusUI(status.message)
                        }

                        LSBleManager.BleApiStatus.CONNECTING -> {
                            updateStatusUI(status.message)
                        }

                        LSBleManager.BleApiStatus.CONNECTION_FAILED -> {
                            updateStatusUI(status.message)
                        }

                        LSBleManager.BleApiStatus.CONNECTED -> {
                            updateStatusUI(status.message)
                        }

                        LSBleManager.BleApiStatus.DATA_RECEIVED -> {
                            //(requireActivity() as BaseActivity).showToast("data fetched")
                            isDateFetched = true
                            updateStatusUI(status.message)
                            Log.d("BCA_Data", ":: $data")
                            data?.let { updateBcaReadings(it) }
                        }

                        LSBleManager.BleApiStatus.DISCONNECTING -> {}
                        LSBleManager.BleApiStatus.DISCONNECTED -> {
                            if (isDateFetched.not()) {
                                updateStatusUI("The device has been disconnected. Please reconnect the device and try again.")
                            }
                            binding.lotteeAnimationSyncData.pauseAnimation()
                            binding.buttonMeasure.isEnabled = true
                            isMeasuring = false
                        }

                        LSBleManager.BleApiStatus.WRONG_SCALE_DETECTED -> {

                        }
                    }
                }
            })
    }

    private fun updateStatusUI(msg: String) {
        binding.textViewSyncingData.text = msg
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewBcaVitals.apply {
            layoutManager = GridLayoutManager(requireContext(), 2, RecyclerView.VERTICAL, false)
            adapter = bcaMyReadingsAdapter
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getBcaVitals() {
        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.getBcaVitals(apiRequest)
    }

    private fun updateBcaReadings(jsonData: String) {
        try {
            val gson = Gson()
            val data = gson.fromJson(jsonData, UpdateBcaVitalsApiRequest::class.java)
            showLoader()
            goalReadingViewModel.updateBcaReadings(data)
            // (requireActivity() as BaseActivity).showToast("update bca vital API call")
        } catch (e: Exception) {
            //(requireActivity() as BaseActivity).showToast("update bca vital API call exception ${e.message}")
            e.printStackTrace()
        }
    }

    private fun generateBcaReport() {
        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.generateBcaReport(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //exercisePlanListLiveData
        goalReadingViewModel.getBcaVitalsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            //(requireActivity() as BaseActivity).showToast("getBcaVitals API success")
            setData(responseBody.data)
        }, onError = { throwable ->
            hideLoader()
            //(requireActivity() as BaseActivity).showToast("getBcaVitals API fail")
            setData(null, throwable.message ?: "")
            false
        })

        //updateBcaReadingsLiveData
        goalReadingViewModel.updateBcaReadingsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()

            analytics.logEvent(
                analytics.HEALTH_MARKERS_POPULATED, Bundle().apply {
                    putString(
                        analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.BCA
                    )
                }, screenName = AnalyticsScreenNames.MeasureSmartScaleReadings
            )

            getBcaVitals()
            //(requireActivity() as BaseActivity).showToast("updateBcaReadings API success")
        }, onError = { throwable ->
            hideLoader()
            //(requireActivity() as BaseActivity).showToast("updateBcaReadings API fail ${throwable.message}")
            true
        })

        //generateBcaReportLiveData
        goalReadingViewModel.generateBcaReportLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            if (responseBody.data.isNullOrBlank()) {
                showMessage(responseBody.message)
            } else {
                analytics.logEvent(
                    analytics.USER_DOWNLOADS_REPORT, Bundle().apply {
                        putString(
                            analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.BCA
                        )
                    }, screenName = AnalyticsScreenNames.MeasureSmartScaleReadings
                )
                downloadHelper.startDownload(
                    downloadUrl = responseBody.data,
                    downloadFileName = downloadHelper.getFileNameForBcaReport().plus(".pdf"),
                    downloadDirName = downloadHelper.DIR_REPORTS
                )
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setData(bcaReadingsMainData: GetBcaReadingsMainData?, message: String = "") {
        if (isAdded) {
            binding.layoutHeader.imageViewDownload.visibility = View.VISIBLE

            readingList.clear()
            bcaReadingsMainData?.let {
                it.readings?.let { it1 -> readingList.addAll(it1) }
            }
            bcaMyReadingsAdapter.notifyDataSetChanged()

            with(binding) {
                if (bcaReadingsMainData?.last_sync_date.isNullOrBlank()) {
                    groupLastSyncDateMyVitals.isVisible = false
                } else {
                    groupLastSyncDateMyVitals.isVisible = true

                    try {
                        val dateStr = DateTimeFormatter.date(
                            bcaReadingsMainData?.last_sync_date,
                            DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                        )
                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_dd_MMM_yyyy_hmm_a)
                        textViewLastSynced.text = "Last measured on $dateStr"
                    } catch (e: Exception) {

                    }
                }

                if (readingList.isEmpty()) {

                } else {

                }
            }
        }
    }
}