package com.mytatva.patient.ui.home.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.Editable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.Fragment
import androidx.viewpager.widget.ViewPager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.HomeFragmentSearchBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.fragment.EngageAskAnExpertFragment
import com.mytatva.patient.ui.engage.fragment.EngageDiscoverFragment
import com.mytatva.patient.ui.exercise.ExerciseMoreFragment
import com.mytatva.patient.ui.exercise.ExerciseMyPlansNewFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.menu.fragment.HistoryRecordFragment
import com.mytatva.patient.ui.menu.fragment.HistoryTestsFragment
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.setAdjustPan
import com.mytatva.patient.utils.setAdjustResize
import kotlinx.coroutines.*

class SearchFragment : BaseFragment<HomeFragmentSearchBinding>() {

    private var viewPagerAdapter: ViewPagerAdapter? = null

    private val currentFragment: Fragment
        get() = viewPagerAdapter?.mFragmentList!![binding.viewPagerSearch.currentItem]

    private val engageDiscoverFragment = EngageDiscoverFragment().apply {
        isInsideSearch = true
    }
    private val engageAskAnExpertFragment = EngageAskAnExpertFragment().apply {
        isInsideSearch = true
    }
    private val exerciseMyPlansFragment = ExerciseMyPlansNewFragment().apply {
        isInsideSearch = true
    }
    private val exerciseMoreFragment = ExerciseMoreFragment().apply {
        isInsideSearch = true
    }


    //private val paymentsFragment = HistoryPaymentFragment()
    //private val appointmentsFragment = HistoryAppointmentFragment()
    //private val incidentFragment = HistoryIncidentFragment()
    private val recordsFragment = HistoryRecordFragment().apply {
        isInsideSearch = true
    }
    private val testsFragment = HistoryTestsFragment().apply {
        isInsideSearch = true
    }

    private val isShowRecord: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_SHOW_RECORD) ?: false
    }

    private val isShowIncident: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_SHOW_INCIDENT) ?: false
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
    ): HomeFragmentSearchBinding {
        return HomeFragmentSearchBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onStart() {
        super.onStart()
        setAdjustPan()
    }

    override fun onStop() {
        super.onStop()
        setAdjustResize()
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
        setUpSearch()

        Handler(Looper.getMainLooper()).postDelayed({
            binding.editTextSearch.requestFocus()
            showKeyBoard()
        }, 200)

        // set viewpager current item as per required navigation
        /*viewPagerAdapter?.mFragmentList?.forEachIndexed { index, fragment ->
            if (fragment is HistoryIncidentFragment && isShowIncident) {
                binding.viewPagerSearch.currentItem = index
            } else if (fragment is HistoryRecordFragment && isShowRecord) {
                binding.viewPagerSearch.currentItem = index
            }
        }*/
    }

    var callApiJob: Job? = null
    private fun setUpSearch() {
        with(binding) {
            editTextSearch.addTextChangedListener { text: Editable? ->
                callApiJob?.cancel()
                callApiJob = GlobalScope.launch(Dispatchers.Main) {
                    delay(300)

                    val searchText = editTextSearch.text.toString().trim()

                    //set search text to all screens
                    engageDiscoverFragment.searchText = searchText
                    engageAskAnExpertFragment.searchText = searchText
                    exerciseMyPlansFragment.searchText = searchText
                    exerciseMoreFragment.searchText = searchText
                    recordsFragment.searchText = searchText
                    testsFragment.searchText = searchText

                    when (currentFragment) {
                        is EngageDiscoverFragment -> {
                            (currentFragment as EngageDiscoverFragment).doSearch(searchText)
                        }
                        is EngageAskAnExpertFragment -> {
                            (currentFragment as EngageAskAnExpertFragment).doSearch(searchText)
                        }
                        is ExerciseMyPlansNewFragment -> {
                            (currentFragment as ExerciseMyPlansNewFragment).doSearch(searchText)
                        }
                        is ExerciseMoreFragment -> {
                            (currentFragment as ExerciseMoreFragment).doSearch(searchText)
                        }
                        is HistoryRecordFragment -> {
                            (currentFragment as HistoryRecordFragment).doSearch(searchText)
                        }
                        is HistoryTestsFragment -> {
                            (currentFragment as HistoryTestsFragment).doSearch(searchText)
                        }
                    }

                }
            }
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)

            if (AppFlagHandler.isToHideEngagePage(session.user, firebaseConfigUtil).not()) {
                viewPagerAdapter?.addFrag(engageDiscoverFragment, "Discover")

                if (AppFlagHandler.isToHideAskAnExpertPage(firebaseConfigUtil).not()) {
                    viewPagerAdapter?.addFrag(engageAskAnExpertFragment, "Ask An Expert")
                }

            }
            viewPagerAdapter?.addFrag(exerciseMyPlansFragment, "My Routine")
            viewPagerAdapter?.addFrag(exerciseMoreFragment, "Explore")

            /*if (isFeatureAllowedAsPerPlan(PlanFeatures.history_payments,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(paymentsFragment,
                    getString(R.string.history_tab_payments))
            }

            viewPagerAdapter?.addFrag(appointmentsFragment,
                getString(R.string.history_tab_appointments))

            if (session.user?.isNaflOrNashPatient != true
                && isFeatureAllowedAsPerPlan(PlanFeatures.incident_records_history,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(incidentFragment,
                    getString(R.string.history_tab_incident))
            }*/

            if (isFeatureAllowedAsPerPlan(PlanFeatures.add_records_history_records,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(recordsFragment, getString(R.string.history_tab_records))
            }

            //tests
            if (AppFlagHandler.isToHideDiagnosticTest(firebaseConfigUtil).not()) {
                viewPagerAdapter?.addFrag(testsFragment, getString(R.string.history_tab_tests))
            }

            viewPagerSearch.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPagerSearch)

            if (viewPagerAdapter?.count == 0) {
                (requireActivity() as BaseActivity).showFeatureNotAllowedDialog {
                    navigator.goBack()
                }
            }

            viewPagerSearch.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
                override fun onPageScrolled(
                    position: Int,
                    positionOffset: Float,
                    positionOffsetPixels: Int,
                ) {

                }

                override fun onPageSelected(position: Int) {
                    if (currentFragment is EngageAskAnExpertFragment) {
                        isFeatureAllowedAsPerPlan(PlanFeatures.ask_an_expert,
                            okCallback = {
                                if (position == 0) {
                                    // if EngageAskAnExpertFragment is at 0 position
                                    // then set currentItem to next position
                                    if ((viewPagerAdapter?.mFragmentList?.lastIndex
                                            ?: 0) > viewPagerSearch.currentItem
                                    ) {
                                        // if next position is there, then move next
                                        viewPagerSearch.currentItem =
                                            viewPagerSearch.currentItem + 1
                                    } else {
                                        // else go back
                                        navigator.goBack()
                                    }

                                } else {
                                    // else set currentItem to 0
                                    viewPagerSearch.currentItem = 0
                                }
                            })
                    }
                }

                override fun onPageScrollStateChanged(state: Int) {

                }
            })

            //viewPagerSearch.offscreenPageLimit = viewPagerSearch.childCount
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = "Search"
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