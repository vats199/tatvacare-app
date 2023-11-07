package com.mytatva.patient.ui.exercise

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.viewpager.widget.ViewPager
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.ExerciseBreathingDayData
import com.mytatva.patient.data.pojo.response.ExercisePlanDayData
import com.mytatva.patient.databinding.ExerciseFragmentPlanDayDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class PlanDayDetailsFragment : BaseFragment<ExerciseFragmentPlanDayDetailsBinding>() {

    private val exercisePlanDayId by lazy {
        arguments?.getString(Common.BundleKey.EXERCISE_PLAN_DAY_ID)
    }
    private var exercisePlanDayData: ExercisePlanDayData? = null

    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val dayDetailsBreathingFragment = DayDetailsBreathingExerciseCommonFragment()
    private val dayDetailsExerciseFragment = DayDetailsBreathingExerciseCommonFragment()

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
    ): ExerciseFragmentPlanDayDetailsBinding {
        return ExerciseFragmentPlanDayDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ExercisePlanDayDetail)
    }

    override fun bindData() {
        dayDetailsBreathingFragment.exerciseType = Common.ExerciseType.BREATHING
        dayDetailsExerciseFragment.exerciseType = Common.ExerciseType.EXERCISE

        setViewListeners()
        setUpToolbar()
        setUpViewPager()

        if (viewPagerAdapter?.count == 0) {
            // when breathing and exercise both are not allowed then count will be 0
            // as no fragment added, then show dialog and go back. else call details API
            (requireActivity() as BaseActivity).showFeatureNotAllowedDialog {
                navigator.goBack()
            }
        } else {
            planDaysDetailsById()
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)

            if (isFeatureAllowedAsPerPlan(PlanFeatures.exercise_my_routine_breathing,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(dayDetailsBreathingFragment, "Breathing")
            }

            if (isFeatureAllowedAsPerPlan(PlanFeatures.exercise_my_routine_exercise,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(dayDetailsExerciseFragment, "Exercises")
            }

            viewPagerExercise.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPagerExercise)

            viewPagerExercise.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
                override fun onPageScrolled(
                    position: Int,
                    positionOffset: Float,
                    positionOffsetPixels: Int,
                ) {

                }

                override fun onPageSelected(position: Int) {
                    updateMarkDoneVisibility()
                }

                override fun onPageScrollStateChanged(state: Int) {

                }
            })
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = ""
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        with(binding) {
            buttonMarkDone.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonMarkDone -> {
                updateBreathingExerciseLog()
            }
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
    private fun updateBreathingExerciseLog() {
        val apiRequest = ApiRequest().apply {
            exercise_plan_day_id = exercisePlanDayId
            type = if (binding.viewPagerExercise.currentItem == 0) "B" else "E"
        }
        showLoader()
        engageContentViewModel.updateBreathingExerciseLog(apiRequest)
    }

    private fun planDaysDetailsById() {
        val apiRequest = ApiRequest().apply {
            exercise_plan_day_id = exercisePlanDayId
        }
        showLoader()
        engageContentViewModel.planDaysDetailsById(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //updateBreathingExerciseLogLiveData
        engageContentViewModel.updateBreathingExerciseLogLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                with(binding) {

                    analytics.logEvent(analytics.USER_MARKED_VIDEO_DONE_EXERCISE,
                        Bundle().apply {
                            putString(analytics.PARAM_EXERCISE_PLAN_DAY_ID, exercisePlanDayId)
                            putString(analytics.PARAM_TYPE,
                                if (viewPagerExercise.currentItem == 0) "B" else "E")
                        },screenName = AnalyticsScreenNames.ExercisePlanDayDetail)

                    if (viewPagerExercise.currentItem == 0) {
                        exercisePlanDayData?.breathing_done = "Y"
                    } else {
                        exercisePlanDayData?.exercise_done = "Y"
                    }
                    updateMarkDoneVisibility()
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //planDaysDetailsByIdLiveData
        engageContentViewModel.planDaysDetailsByIdLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { setData(it) }
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
    private fun setData(exercisePlanDayData: ExercisePlanDayData) {
        this.exercisePlanDayData = exercisePlanDayData

        exercisePlanDayData.let {
            with(binding) {
                textViewDate.text = it.getDayTitleLabel
                textViewBreathingValue.text = it.breathing_counts.plus(" Exercises")
                textViewExerciseValue.text = it.exercise_counts.plus(" Exercises")
                textViewBreathingDuration.text = it.breathing_duration.plus(" mins")
                textViewExerciseDuration.text = it.exercise_duration.plus(" mins")
                updateMarkDoneVisibility()
            }

            //breathing
            val breathingList = arrayListOf<ExerciseBreathingDayData>()
            if (it.breathing_description.isNullOrBlank().not()) {
                breathingList.add(ExerciseBreathingDayData().apply {
                    isDescriptionType = true
                    description = it.breathing_description ?: ""
                })
            }
            it.breathing_data?.let { it1 -> breathingList.addAll(it1) }
            dayDetailsBreathingFragment.setData(breathingList)

            //exercise
            val exerciseList = arrayListOf<ExerciseBreathingDayData>()
            if (it.exercise_description.isNullOrBlank().not()) {
                exerciseList.add(ExerciseBreathingDayData().apply {
                    isDescriptionType = true
                    description = it.exercise_description ?: ""
                })
            }
            it.exercise_data?.let { it1 -> exerciseList.addAll(it1) }
            dayDetailsExerciseFragment.setData(exerciseList)
        }
    }

    private fun updateMarkDoneVisibility() {
        with(binding) {
            if (viewPagerExercise.currentItem == 0) {
                buttonMarkDone.visibility = if (exercisePlanDayData?.breathing_done == "Y")
                    View.GONE else View.VISIBLE
            } else {
                buttonMarkDone.visibility = if (exercisePlanDayData?.exercise_done == "Y")
                    View.GONE else View.VISIBLE
            }
        }
    }
}