package com.mytatva.patient.ui.payment.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.PaymentFragmentPaymentPlanServiceMainBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter

class PaymentPlanServiceMainFragment :
    BaseFragment<PaymentFragmentPaymentPlanServiceMainBinding>() {

    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val paymentPlansFragment = PaymentPlansFragment()
    private val individualServiceFragment = IndividualServicesFragment()

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentPaymentPlanServiceMainBinding {
        return PaymentFragmentPaymentPlanServiceMainBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
    }

    override fun bindData() {
        setViewListeners()
        setUpToolbar()
        setUpViewPager()
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)
            viewPagerAdapter?.addFrag(paymentPlansFragment,
                getString(R.string.payment_plan_tab_plans))
            viewPagerAdapter?.addFrag(individualServiceFragment,
                getString(R.string.payment_plan_tab_individual_services))
            viewPagerHistory.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPagerHistory)
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.payment_plan_title)
            imageViewNotification.visibility = View.GONE
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewFilter.visibility = View.GONE
            imageViewFilter.setOnClickListener { onViewClick(it) }
            imageViewSearch.visibility = View.GONE
            imageViewSearch.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.VISIBLE
            imageViewNotification.setOnClickListener { onViewClick(it) }

            imageViewUnreadNotificationIndicator.visibility =
                if (session.user?.unread_notifications?.toIntOrNull() ?: 0 > 0) View.VISIBLE else View.GONE
            imageViewUnreadNotificationIndicator.text =
                session.user?.unread_notifications?.toIntOrNull()?.toString() ?: ""
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
            R.id.imageViewNotification -> {
                openNotificationScreen()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun dailySummary() {

    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        /*goalReadingViewModel.dailySummaryCarePlanLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setGoalReadingData(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })*/
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

}