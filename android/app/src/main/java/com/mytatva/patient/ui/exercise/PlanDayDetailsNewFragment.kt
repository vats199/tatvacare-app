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
import com.mytatva.patient.databinding.ExerciseFragmentPlanDayDetailsNewBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class PlanDayDetailsNewFragment : BaseFragment<ExerciseFragmentPlanDayDetailsNewBinding>() {

    private val planType by lazy {
        arguments?.getString(Common.BundleKey.PLAN_TYPE)
    }
    private val exercisePlanDayId by lazy {
        arguments?.getString(Common.BundleKey.EXERCISE_PLAN_DAY_ID)
    }
    private val routine by lazy {
        arguments?.getString(Common.BundleKey.ROUTINE)
    }

    private val exerciseAddedByType by lazy {
        // set to fix "A" - Admin, when this screen open from deeplink,
        // because deeplink is not there, when exercise added by HealthCoach
        arguments?.getString(Common.BundleKey.EXERCISE_ADDED_BY) ?: "A"
    }

    private var exercisePlanDayData: ExercisePlanDayData? = null

    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val dayDetailsBreathingFragment = DayDetailsBreathingExerciseCommonNewFragment()
    private val dayDetailsExerciseFragment = DayDetailsBreathingExerciseCommonNewFragment()

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
    ): ExerciseFragmentPlanDayDetailsNewBinding {
        return ExerciseFragmentPlanDayDetailsNewBinding.inflate(inflater, container, attachToRoot)
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
            if (planType == Common.ExercisePlanType.NORMAL) {
                planDaysDetailsById()
                with(binding) {
                    textViewRestPostSet.visibility = View.GONE
                    textViewRestPostExercise.visibility = View.GONE
                }
            } else {
                planDaysDetailsByIdCustomised()
                with(binding) {
                    textViewRestPostSet.visibility = View.VISIBLE
                    textViewRestPostExercise.visibility = View.VISIBLE
                }
            }
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)

            if (isFeatureAllowedAsPerPlan(PlanFeatures.exercise_my_routine_breathing,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(dayDetailsBreathingFragment,
                    getString(R.string.plan_day_details_tab_breathing))
            }

            if (isFeatureAllowedAsPerPlan(PlanFeatures.exercise_my_routine_exercise,
                    needToShowDialog = false)
            ) {
                viewPagerAdapter?.addFrag(dayDetailsExerciseFragment,
                    getString(R.string.plan_day_details_tab_exercises))
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
                if (planType == Common.ExercisePlanType.NORMAL) {
                    updateBreathingExerciseLog()
                } else {
                    updateBreathingExerciseLogCustomised()
                }
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

    private fun updateBreathingExerciseLogCustomised() {
        val apiRequest = ApiRequest().apply {
            exercise_plan_day_id = exercisePlanDayId
            type = if (binding.viewPagerExercise.currentItem == 0) "B" else "E"
            routine = this@PlanDayDetailsNewFragment.routine
            add_type = exerciseAddedByType
        }
        showLoader()
        engageContentViewModel.updateBreathingExerciseLogCustomised(apiRequest)
    }

    private fun planDaysDetailsByIdCustomised() {
        val apiRequest = ApiRequest().apply {
            exercise_plan_day_id = exercisePlanDayId
            routine = this@PlanDayDetailsNewFragment.routine
            type = exerciseAddedByType
        }
        showLoader()
        engageContentViewModel.planDaysDetailsByIdCustomised(apiRequest)
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
                handleOnUpdateBreathingExerciseLogSuccess()
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

        //updateBreathingExerciseLogCustomisedLiveData
        engageContentViewModel.updateBreathingExerciseLogCustomisedLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                handleOnUpdateBreathingExerciseLogSuccess()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //planDaysDetailsByIdCustomisedLiveData
        engageContentViewModel.planDaysDetailsByIdCustomisedLiveData.observe(this,
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
                textViewBreathingValue.text = it.breathing_counts.plus(" exercise")
                textViewExerciseValue.text = it.exercise_counts.plus(" exercise")
                textViewBreathingDuration.text = it.breathing_duration.plus(" ${it.breathing_duration_unit}")
                textViewExerciseDuration.text = it.exercise_duration.plus(" ${it.exercise_duration_unit}")

                if (planType == Common.ExercisePlanType.CUSTOM) {
                    textViewDate.text = it.getDayTitleLabelNew
                    textViewRestPostSet.text = "Rest (Post Set) : ${it.exercise_restpost_set} ${it.exercise_restpost_set_unit}"
                    textViewRestPostExercise.text =
                        "Rest (Post Exercise) : ${it.exercise_rest_post} ${it.exercise_rest_post_unit}"
                } else {
                    textViewDate.text = it.getDayTitleLabel
                }

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
            dayDetailsBreathingFragment.setData(breathingList, planType ?: "")

            //exercise
            val exerciseList = arrayListOf<ExerciseBreathingDayData>()
            if (it.exercise_description.isNullOrBlank().not()) {
                exerciseList.add(ExerciseBreathingDayData().apply {
                    isDescriptionType = true
                    description = it.exercise_description ?: ""
                })
            }
            it.exercise_data?.let { it1 -> exerciseList.addAll(it1) }
            dayDetailsExerciseFragment.setData(exerciseList, planType ?: "")
        }
    }

    private fun handleOnUpdateBreathingExerciseLogSuccess() {
        with(binding) {
            analytics.logEvent(analytics.USER_MARKED_VIDEO_DONE_EXERCISE,
                Bundle().apply {
                    putString(analytics.PARAM_EXERCISE_PLAN_DAY_ID, exercisePlanDayId)
                    putString(analytics.PARAM_TYPE,
                        if (viewPagerExercise.currentItem == 0) "B" else "E")
                }, screenName = AnalyticsScreenNames.ExercisePlanDayDetail)

            if (viewPagerExercise.currentItem == 0) {
                exercisePlanDayData?.breathing_done = "Y"
            } else {
                exercisePlanDayData?.exercise_done = "Y"
            }
            updateMarkDoneVisibility()
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