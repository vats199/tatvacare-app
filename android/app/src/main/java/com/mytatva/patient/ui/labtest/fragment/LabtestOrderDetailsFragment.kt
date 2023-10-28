package com.mytatva.patient.ui.labtest.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.TestOrderSummaryResData
import com.mytatva.patient.databinding.LabtestFragmentLabtetsOrderDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class LabtestOrderDetailsFragment : BaseFragment<LabtestFragmentLabtetsOrderDetailsBinding>() {

    private var orderSummaryResData: TestOrderSummaryResData? = null

    private val isToOpenHomeOnBack: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_TO_OPEN_HOME_ON_BACK) ?: false
    }

    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val orderDetailsOrderSummaryFragment = OrderDetailsOrderSummaryFragment().apply {
        callbackToNext = {
            if (isAdded) {
                this@LabtestOrderDetailsFragment.binding.viewPager.currentItem = 1
            }
        }
    }
    private val orderDetailsTestFragment = OrderDetailsTestFragment()

    private val orderMasterId: String? by lazy {
        arguments?.getString(Common.BundleKey.ORDER_MASTER_ID)
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestFragmentLabtetsOrderDetailsBinding {
        return LabtestFragmentLabtetsOrderDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LabtestOrderDetails)

        analytics.logEvent(analytics.USER_VIEWED_LABTEST_ORDER_DETAILS, Bundle().apply {
            putString(analytics.PARAM_ORDER_MASTER_ID, orderMasterId)
        }, screenName = AnalyticsScreenNames.LabtestOrderDetails)
    }

    override fun bindData() {
        setViewListeners()
        setUpToolbar()
        setUpViewPager()

        orderSummary()
    }

    override fun onBackActionPerform(): Boolean {
        if (isToOpenHomeOnBack) {
            navigator.loadActivity(HomeActivity::class.java)
                .byFinishingAll()
                .start()
            return false
        } else {
            return super.onBackActionPerform()
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)
            viewPagerAdapter?.addFrag(orderDetailsOrderSummaryFragment, getString(R.string.labtest_order_details_tab_order_summary))
            viewPagerAdapter?.addFrag(orderDetailsTestFragment, getString(R.string.labtest_order_details_tab_tests))
            viewPager.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPager)
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.labtest_order_details_title)
            imageViewNotification.visibility = View.GONE
            imageViewSearch.visibility = View.GONE
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        with(binding) {
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
    private fun orderSummary() {
        val apiRequest = ApiRequest().apply {
            order_master_id = orderMasterId
        }
        showLoader()
        doctorViewModel.orderSummary(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //orderSummaryLiveData
        doctorViewModel.orderSummaryLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                handleOnOrderSummaryResponse(responseBody.data)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    private fun handleOnOrderSummaryResponse(orderSummaryResData: TestOrderSummaryResData?) {
        this.orderSummaryResData = orderSummaryResData
        orderDetailsOrderSummaryFragment.setDetails(orderSummaryResData)
        orderDetailsTestFragment.setDetails(orderSummaryResData)
    }
}