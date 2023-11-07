package com.mytatva.patient.ui.menu.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.MenuFragmentHistoryBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.utils.apputils.AppFlagHandler

class HistoryFragment : BaseFragment<MenuFragmentHistoryBinding>() {

    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val paymentsFragment = HistoryPaymentFragment()
    private val appointmentsFragment = HistoryAppointmentFragment()
    private val incidentFragment = HistoryIncidentFragment()
    private val recordsFragment = HistoryRecordFragment()
    private val testsFragment = HistoryTestsFragment()

    private val isShowRecord: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_SHOW_RECORD) ?: false
    }

    private val isShowIncident: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_SHOW_INCIDENT) ?: false
    }

    private val isShowTest: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_SHOW_TEST) ?: false
    }

    /*private val filterBottomSheetDialog =
        FilterBottomSheetDialog { languageList, genresList, topicsList, contentTypeList ->

        }*/

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MenuFragmentHistoryBinding {
        return MenuFragmentHistoryBinding.inflate(inflater, container, attachToRoot)
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

        /*if (isShowRecord && viewPagerAdapter?.count ?: 0 > 0) {
            binding.viewPagerHistory.currentItem = viewPagerAdapter?.count!! - 1
        }*/

        // set viewpager current item as per required navigation
        viewPagerAdapter?.mFragmentList?.forEachIndexed { index, fragment ->
            if (fragment is HistoryIncidentFragment && isShowIncident) {
                binding.viewPagerHistory.currentItem = index
            } else if (fragment is HistoryRecordFragment && isShowRecord) {
                binding.viewPagerHistory.currentItem = index
                // to handle for records only and hide tabs
                /*binding.layoutHeader.textViewToolbarTitle.text = "Records"
                binding.tabLayout.isVisible = false*/
            } else if (fragment is HistoryTestsFragment && isShowTest) {
                binding.viewPagerHistory.currentItem = index
            }
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)

            if (isFeatureAllowedAsPerPlan(PlanFeatures.history_payments,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(paymentsFragment,
                    getString(R.string.history_tab_payments))
            }

            /*if (session.user?.isToShowAppointmentModule == true) {*/
            viewPagerAdapter?.addFrag(appointmentsFragment,
                getString(R.string.history_tab_appointments))
            /*}*/

            if (AppFlagHandler.isToHideIncidentSurvey(firebaseConfigUtil).not()
                && HomeActivity.incidentSurveyData != null
            ) {
                if (/*session.user?.isNaflOrNashPatient != true &&*/
                    isFeatureAllowedAsPerPlan(PlanFeatures.incident_records_history,
                        needToShowDialog = false)
                ) {
                    viewPagerAdapter?.addFrag(incidentFragment,
                        getString(R.string.history_tab_incident))
                }
            }

            if (isFeatureAllowedAsPerPlan(PlanFeatures.add_records_history_records,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(recordsFragment, getString(R.string.history_tab_records))
            }

            //tests
            if (AppFlagHandler.isToHideDiagnosticTest(firebaseConfigUtil).not()) {
                viewPagerAdapter?.addFrag(testsFragment, getString(R.string.history_tab_tests))
            }

            viewPagerHistory.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPagerHistory)

            if (viewPagerAdapter?.count == 0) {
                (requireActivity() as BaseActivity).showFeatureNotAllowedDialog {
                    navigator.goBack()
                }
            }

            //viewPagerHistory.offscreenPageLimit = viewPagerHistory.childCount
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "History"
            imageViewNotification.visibility = View.GONE
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewFilter.visibility = View.GONE
            imageViewFilter.setOnClickListener { onViewClick(it) }
            imageViewSearch.visibility = View.GONE
            imageViewSearch.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        with(binding) {

        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewFilter -> {
                /*activity?.supportFragmentManager?.let {
                    filterBottomSheetDialog.show(it, FilterBottomSheetDialog::class.java.simpleName)
                }*/
            }
            R.id.imageViewSearch -> {

            }
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
        val apiRequest = ApiRequest()
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