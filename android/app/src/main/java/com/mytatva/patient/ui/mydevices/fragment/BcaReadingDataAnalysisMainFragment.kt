package com.mytatva.patient.ui.mydevices.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.GetBcaReadingsMainData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.MydeviceFragmentBcaReadingDataAnalysisMainBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class BcaReadingDataAnalysisMainFragment :
    BaseFragment<MydeviceFragmentBcaReadingDataAnalysisMainBinding>() {

    private val readingKey: String? by lazy {
        arguments?.getString(Common.BundleKey.KEY)
    }

    private val goalReadingViewModel: GoalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    private val readingList = ArrayList<GoalReadingData>()
    private var viewPagerAdapter: ViewPagerAdapter? = null

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MydeviceFragmentBcaReadingDataAnalysisMainBinding {
        return MydeviceFragmentBcaReadingDataAnalysisMainBinding.inflate(
            inflater,
            container,
            attachToRoot
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SmartScaleReadingAnalysis)
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        getBcaVitals()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "My Health Markers"
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
        }
    }

    private fun setUpViewPager() {
        viewPagerAdapter = ViewPagerAdapter(childFragmentManager)
        readingList.forEachIndexed { index, readingData ->
            viewPagerAdapter?.addFrag(BcaReadingDataAnalysisSubFragment().apply {
                goalReadingData = readingData
            }, readingData.reading_name?.plus(" ")?.plus("(${readingData.measurements})") ?: "")
        }
        with(binding) {
            viewPagerRoutine.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPagerRoutine)
        }
    }


    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
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

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //exercisePlanListLiveData
        goalReadingViewModel.getBcaVitalsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                setData(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }

    private fun setData(bcaReadingsMainData: GetBcaReadingsMainData?) {
        readingList.clear()
        bcaReadingsMainData?.let {
            it.readings?.let { it1 -> readingList.addAll(it1) }
        }
        setUpViewPager()
        binding.viewPagerRoutine.currentItem = readingList.indexOfFirst { it.keys == readingKey }
    }
}