package com.mytatva.patient.ui.spirometer.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.SpirometerTestResData
import com.mytatva.patient.databinding.SpirometerFragmentAllReadingsBinding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.spirometer.adapter.SpirometerReadingsAdapter
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.PaginationScrollListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.spirometer.SpirometerManager
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.spirometer.fragment.v1.SpirometerEnterDetailsV1Fragment
import com.mytatva.patient.ui.spirometer.fragment.v1.SpirometerSubAllReadingFragment

class SpirometerAllReadingsFragment : BaseFragment<SpirometerFragmentAllReadingsBinding>() {

    private var viewPagerAdapter: ViewPagerAdapter? = null

    private val healthInsights by lazy {
        SpirometerSubAllReadingFragment().apply {
            typeOfReadings = "S"
        }
    }
    private val exerciseInsights by lazy {
        SpirometerSubAllReadingFragment().apply {
            typeOfReadings = "I"
        }
    }

    val isToUpdateSpiroReadings: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_TO_UPDATE_SPIRO_READINGS) ?: false
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): SpirometerFragmentAllReadingsBinding {
        return SpirometerFragmentAllReadingsBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SpirometerAllReadings)
        analytics.logEvent(
            analytics.USER_VIEWS_ALL_READINGS, Bundle().apply {
                putString(
                    analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.SPIROMETER
                )
            }, screenName = AnalyticsScreenNames.SpirometerAllReadings
        )
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        setUpViewPager()

        if (isToUpdateSpiroReadings) {
            callUpdateSpirometerVitalsAPI()
        }
    }

    private fun setUpViewPager() {
        viewPagerAdapter = ViewPagerAdapter(childFragmentManager).apply {
            addFrag(healthInsights,getString(R.string.spirometer_tab_label_health_insights))
            addFrag(exerciseInsights,getString(R.string.spirometer_tab_label_exercise_insights))
        }

        with(binding) {
            viewPagerReadingPage.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPagerReadingPage)
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "Lung Function Analyser"
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            binding.buttonConnectTest.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonConnectTest -> {
                analytics.logEvent(
                    analytics.USER_CLICKS_ON_CONNECT, Bundle().apply {
                        putString(
                            analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.SPIROMETER
                        )
                    }, screenName = AnalyticsScreenNames.SpirometerAllReadings
                )

                navigator.loadActivity(IsolatedFullActivity::class.java, SpirometerEnterDetailsV1Fragment::class.java)
                    .addBundle(Bundle().apply {
                        putBoolean(Common.BundleKey.IS_OPEN_FROM_ALL_READINGS, true)
                    }).forResult(Common.RequestCode.REQUEST_SPIROMETER_REAINGS).start()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            Common.RequestCode.REQUEST_SPIROMETER_REAINGS -> {
                if (resultCode == Activity.RESULT_OK) {
                    callUpdateSpirometerVitalsAPI()
                }
            }
        }
    }
    companion object{
        var isUpdateAPICalled = false
    }

    /**
     * callUpdateSpirometerVitalsAPI
     * fun to update spirometer data after test finished for both flow,
     * flow 1 -> when open this screen after finish test
     * flow 2 -> when get result in this screen after finish test
     */
    private fun callUpdateSpirometerVitalsAPI() {
        isUpdateAPICalled = true
        if (SpirometerManager.isIncentive) {
            updateIncentiveSpirometerData()
        } else {
            updateSpirometerData()
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateSpirometerData() {
        val apiRequest = ApiRequest().apply {
            parent_event_id = SpirometerManager.spiroMeterTestUUID
            if (MyTatvaApp.IS_SPIRO_PROD.not()) {
                dev = "true"
            }
        }
        showLoader()
        goalReadingViewModel.updateSpirometerData(apiRequest)
    }

    private fun updateIncentiveSpirometerData() {
        val apiRequest = ApiRequest().apply {
            parent_event_id = SpirometerManager.spiroMeterTestUUID
            if (MyTatvaApp.IS_SPIRO_PROD.not()) {
                dev = "true"
            }
        }
        showLoader()
        goalReadingViewModel.updateIncentiveSpirometerData(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //updateSpirometerDataLiveData
        goalReadingViewModel.updateSpirometerDataLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            isUpdateAPICalled = false
            analytics.logEvent(
                analytics.HEALTH_MARKERS_POPULATED, Bundle().apply {
                    putString(analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.SPIROMETER)
                    putString(analytics.PARAM_TEST_TYPE, "Standard")
                }, screenName = AnalyticsScreenNames.SpirometerAllReadings
            )
            SpirometerManager.spiroMeterTestUUID = ""

            if (isAdded) {
                if (binding.viewPagerReadingPage.currentItem!=0){
                    binding.viewPagerReadingPage.currentItem = 0
                } else {
                    healthInsights.onResume()
                }
            }

            /*resetPagingData()
            spirometerTestList()*/
        }, onError = { throwable ->
            hideLoader()
            isUpdateAPICalled = false
            SpirometerManager.spiroMeterTestUUID = ""
            true
        })

        //updateIncentiveSpirometerDataLiveData
        goalReadingViewModel.updateIncentiveSpirometerDataLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            isUpdateAPICalled = false
            analytics.logEvent(
                analytics.HEALTH_MARKERS_POPULATED, Bundle().apply {
                    putString(analytics.PARAM_MEDICAL_DEVICE, Common.MedicalDevice.SPIROMETER)
                    putString(analytics.PARAM_TEST_TYPE, "Incentive")
                }, screenName = AnalyticsScreenNames.SpirometerAllReadings
            )
            SpirometerManager.spiroMeterTestUUID = ""

            if (isAdded) {
                if (binding.viewPagerReadingPage.currentItem != 1){
                    binding.viewPagerReadingPage.currentItem = 1
                } else {
                    exerciseInsights.onResume()
                }
            }

            /*resetPagingData()
            spirometerTestList()*/
        }, onError = { throwable ->
            hideLoader()
            isUpdateAPICalled = false
            SpirometerManager.spiroMeterTestUUID = ""
            true
        })
    }
}