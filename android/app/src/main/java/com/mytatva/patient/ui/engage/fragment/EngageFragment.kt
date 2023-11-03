package com.mytatva.patient.ui.engage.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.viewpager.widget.ViewPager
import com.mytatva.patient.R
import com.mytatva.patient.data.model.CoachMarkPage
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.ContentTypeData
import com.mytatva.patient.databinding.EngageFragmentEngageBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.engage.bottomsheet.AskAnExpertFilterBottomSheetDialog
import com.mytatva.patient.ui.engage.bottomsheet.FilterBottomSheetDialog
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.copyList
import smartdevelop.ir.eram.showcaseviewlib.GuideView
import smartdevelop.ir.eram.showcaseviewlib.config.Gravity
import smartdevelop.ir.eram.showcaseviewlib.listener.GuideListener

class EngageFragment : BaseFragment<EngageFragmentEngageBinding>() {

    /*private var viewPagerAdapter: CommonViewPager2Adapter? = null*/
    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val engageDiscoverFragment = EngageDiscoverFragment()
    private val engageAskExpertFragment = EngageAskAnExpertFragment()

    private val filterBottomSheetDialog by lazy {
        FilterBottomSheetDialog { languageList, genresList, topicsList, contentTypeList, isShowRecommendedByDoctor ->
            engageDiscoverFragment.updateFilters(languageList,
                genresList,
                topicsList,
                contentTypeList, isShowRecommendedByDoctor)
        }
    }

    private val askAnExpertFilterBottomSheetDialog by lazy {
        AskAnExpertFilterBottomSheetDialog { topicsList, questionList, isShowRecommendedByDoctor ->
            engageAskExpertFragment.updateFilters(
                topicsList,
                questionList,
                isShowRecommendedByDoctor)
        }
    }

    private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): EngageFragmentEngageBinding {
        return EngageFragmentEngageBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onShow() {
        super.onShow()
    }

    override fun onResume() {
        super.onResume()
        /*if (isAdded && isVisible) {
            if (requireActivity() is HomeActivity) {
                (requireActivity() as HomeActivity).getPatientDetails()
            }
        }*/
    }

    override fun onStart() {
        super.onStart()
    }

    override fun bindData() {
        setViewListeners()
        setUpToolbar()
        setUpViewPager()
        topicList()
    }

    fun handleFilterFromDeeplinkData(contentType: String) {
        engageDiscoverFragment.updateFilters(languageList = arrayListOf(),
            genresList = arrayListOf(),
            topicsList = arrayListOf(),
            contentTypeList = arrayListOf(ContentTypeData().apply {
                keys = contentType
            }), false)
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)
            viewPagerAdapter?.addFrag(engageDiscoverFragment, getString(R.string.engage_discover_label_discover))
            if (AppFlagHandler.isToHideAskAnExpertPage(firebaseConfigUtil)) {
                tabLayout.isVisible = false
            } else {
                viewPagerAdapter?.addFrag(engageAskExpertFragment,
                    getString(R.string.engage_ask_expert_label_ask_an_expert))
                tabLayout.isVisible = true
            }
            viewPagerEngage.adapter = viewPagerAdapter
            //viewPagerEngage.isUserInputEnabled=false

            tabLayout.setupWithViewPager(viewPagerEngage)
            //
            viewPagerEngage.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
                override fun onPageScrolled(
                    position: Int,
                    positionOffset: Float,
                    positionOffsetPixels: Int,
                ) {

                }

                override fun onPageSelected(position: Int) {
                    if (viewPagerEngage.currentItem == 1) {
                        isFeatureAllowedAsPerPlan(PlanFeatures.ask_an_expert,
                            okCallback = {
                                viewPagerEngage.currentItem = 0
                            })
                    }
                }

                override fun onPageScrollStateChanged(state: Int) {

                }
            })
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.home_label_learn)
            imageViewNotification.visibility = View.GONE
            imageViewToolbarBack.visibility = View.GONE
            imageViewFilter.visibility = View.VISIBLE
            imageViewFilter.setOnClickListener { onViewClick(it) }
            imageViewSearch.visibility = View.GONE
            imageViewSearch.setOnClickListener { onViewClick(it) }
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
                if (binding.viewPagerEngage.currentItem == 0) {
                    activity?.supportFragmentManager?.let {
                        if (filterBottomSheetDialog.isAdded.not())
                            filterBottomSheetDialog.show(it,
                                FilterBottomSheetDialog::class.java.simpleName)
                    }
                } else {
                    activity?.supportFragmentManager?.let {
                        if (askAnExpertFilterBottomSheetDialog.isAdded.not())
                            askAnExpertFilterBottomSheetDialog.show(it,
                                AskAnExpertFilterBottomSheetDialog::class.java.simpleName)
                    }
                }
            }
            R.id.imageViewSearch -> {

            }
            R.id.imageViewToolbarBack -> {
                //navigator.goBack()
            }
        }
    }

    fun showCoachMark(onFinish: () -> Unit) {
        binding.viewPagerEngage.currentItem = 0

        engageDiscoverFragment.showCoachMark {

            var mGuideView: GuideView? = null
            var builder: GuideView.Builder? = null

            if (isFeatureAllowedAsPerPlan(PlanFeatures.ask_an_expert, needToShowDialog = false)
                && AppFlagHandler.isToHideAskAnExpertPage(firebaseConfigUtil).not()
            ) {
                // if ask an expert is allowed in plan && also not to hide as per flag
                // then show it's coachMark

                binding.viewPagerEngage.currentItem = 1
                val tabViewAskAnExpert = binding.tabLayout.getTabAt(1)?.view

                builder = GuideView.Builder(requireActivity())
                    .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.ENGAGE_EXPERT.pageKey))
                    .setButtonText("Next")
                    .setGravity(Gravity.auto)
                    /*.setDismissType(DismissType.outside)*/
                    .setTargetView(tabViewAskAnExpert)
                    .setGuideListener(object : GuideListener {
                        override fun onDismiss(view: View?) {
                        }

                        override fun onSkip() {
                            showSkipCoachMarkMessage()
                        }

                        override fun onNext(view: View) {
                            when (view.id) {
                                R.id.layoutExercise -> {
                                    onFinish.invoke()
                                }
                                tabViewAskAnExpert?.id -> {
                                    with(binding) {
                                        builder
                                            ?.setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.ENGAGE_EXERCISE.pageKey))
                                            ?.setButtonText("Go To Exercise")
                                            ?.setTargetView((requireActivity() as HomeActivity).binding.layoutExercise)
                                        mGuideView = builder?.build()
                                        mGuideView?.show()
                                    }
                                }
                            }
                        }
                    })
                mGuideView = builder?.build()
                mGuideView?.show()

            } else {
                // else move to next directly

                builder = GuideView.Builder(requireActivity())
                    .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.ENGAGE_EXERCISE.pageKey))
                    .setButtonText("Go To Exercise")
                    .setGravity(Gravity.auto)
                    /*.setDismissType(DismissType.outside)*/
                    .setTargetView((requireActivity() as HomeActivity).binding.layoutExercise)
                    .setGuideListener(object : GuideListener {
                        override fun onDismiss(view: View?) {
                        }

                        override fun onSkip() {
                            showSkipCoachMarkMessage()
                        }

                        override fun onNext(view: View) {
                            when (view.id) {
                                R.id.layoutExercise -> {
                                    onFinish.invoke()
                                }
                            }
                        }
                    })
                mGuideView = builder?.build()
                mGuideView?.show()

            }

        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun topicList() {
        val apiRequest = ApiRequest()
        engageContentViewModel.topicList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private var retryTopicListCounter = 0

    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //topicListLiveData
        engageContentViewModel.topicListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    engageDiscoverFragment.topicList.clear()
                    engageDiscoverFragment.topicList.addAll(ArrayList(it).copyList())
                    engageAskExpertFragment.topicList.clear()
                    engageAskExpertFragment.topicList.addAll(ArrayList(it).copyList())
                    /*it.forEach { topicsData ->
                        engageDiscoverFragment.topicList.add(topicsData.doCopy())
                        engageAskExpertFragment.topicList.add(topicsData.doCopy())
                    }*/
                    engageDiscoverFragment.engageDiscoverTopicAdapter.notifyDataSetChanged()
                    engageAskExpertFragment.engageDiscoverTopicAdapter.notifyDataSetChanged()
                }
            },
            onError = { throwable ->
                hideLoader()
                if (retryTopicListCounter < 3) {
                    Handler(Looper.getMainLooper()).postDelayed({
                        topicList()
                    }, 100)
                    retryTopicListCounter++
                    //topicList()
                }
                false
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/

}