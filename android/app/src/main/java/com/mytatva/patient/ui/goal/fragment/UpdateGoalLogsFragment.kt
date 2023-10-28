package com.mytatva.patient.ui.goal.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.GoalCommonLayoutHeaderBinding
import com.mytatva.patient.databinding.GoalFragmentUpdateLogsBinding
import com.mytatva.patient.databinding.ReadingCommonLayoutSyncDataBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.fragment.SetupGoalsReadingsFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.fragment.BlankFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.ui.profile.fragment.MyDeviceDetailsFragment
import com.mytatva.patient.utils.googlefit.GoogleFit
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class UpdateGoalLogsFragment : BaseFragment<GoalFragmentUpdateLogsBinding>() {

    companion object {
        /**
         * setUpHeader - to set data in all popup screens header
         * @param goalReadingData - specific goal data
         * @param layoutHeader - header view reference
         */
        fun setUpHeader(
            goalReadingData: GoalReadingData,
            layoutHeader: GoalCommonLayoutHeaderBinding,
            navigator: Navigator,
        ) {

            layoutHeader.apply {

                buttonEditGoal.setOnClickListener {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        SetupGoalsReadingsFragment::class.java)
                        .byFinishingCurrent()
                        .start()
                }

                goalReadingData.let {

                    val color =
                        if (it.color_code.isNullOrBlank().not())
                            it.color_code.parseAsColor()
                        else progressIndicator.context.resources
                            .getColor(R.color.colorPrimary, null)

                    progressIndicator.setIndicatorColor(color)
                    /*imageViewIcon.imageTintList = ColorStateList.valueOf(color)*/

                    imageViewIcon.loadUrlIcon(it.image_url ?: "", false)
                    textViewTitle.text = "Log ${it.goal_name}"

                    val achievedValue = it.todays_achieved_value?.toDoubleOrNull() ?: 0.0
                    val goalValue = it.goal_value?.toDoubleOrNull() ?: 0.0


                    if (goalValue == 0.0 && goalReadingData.keys == Goals.Medication.goalKey) {
                        progressIndicator.max = goalValue.toInt()
                        progressIndicator.progress = goalValue.toInt()
                        textViewValue.text = "Add medicine"
                    } else {

                        /*if (achievedValue >= goalValue) {
                        progressIndicator.max = goalValue.toInt()
                        progressIndicator.progress = goalValue.toInt()

                        textViewValue.text = "Completed"

                        if (goalValue == 0.0 && goalReadingData?.keys == Goals.Medication.goalKey) {
                            *//*progressIndicator.max = 10
                            progressIndicator.progress = 10*//*
                            textViewValue.text = "Add medicine"
                        } else {
                            textViewValue.text = "Completed"
                        }

                    } else {*/

                        when (it.keys) {
                            Goals.Sleep.goalKey -> {
                                progressIndicator.max = (goalValue * 100).toInt()
                                progressIndicator.progress = (achievedValue * 100).toInt()

                                textViewValue.text = achievedValue.toString()
                                    .plus(" of ").plus(goalValue.toInt().toString())
                                    .plus(" ").plus(it.goal_measurement)
                            }
                            else -> {
                                progressIndicator.max = goalValue.toInt()
                                progressIndicator.progress = achievedValue.toInt()

                                textViewValue.text = achievedValue.toInt().toString()
                                    .plus(" of ").plus(goalValue.toInt().toString())
                                    .plus(" ").plus(it.goal_measurement)
                            }
                        }
                        /*}*/
                    }

                }
            }
        }

        fun setUpSyncDataLayout(
            layout: ReadingCommonLayoutSyncDataBinding,
            hasAllPermissions: Boolean,
            googleFit: GoogleFit,
            baseActivity: BaseActivity,
        ) {
            layout.apply {
                if (hasAllPermissions) {
                    textViewConnectMsg.text = "Connected"
                } else {
                    textViewConnectMsg.text = "Connect to Google Fit to start syncing data"
                }

                textViewConnectMsg.setOnClickListener {
                    /*if (googleFit.hasAllPermissions.not()) {
                        googleFit.initializeFit {
                            baseActivity.updateReadingsGoals(isCalledOnPermissionApproved = true)
                        }
                    } else {
                        googleFit.disconnectWithAlert {
                            if (it) {
                                textViewConnectMsg.text = "Connect to Google Fit to start syncing data"
                            }
                        }
                    }*/
                    baseActivity.loadActivity(IsolatedFullActivity::class.java,
                        MyDeviceDetailsFragment::class.java)
                        .start()
                }
            }
        }

    }

    var currentPosition = 0
    private val goalsList = arrayListOf<GoalReadingData>()

    private val callback: ((shouldGoNext: Boolean) -> Unit) = { shouldGoNext ->
        if (shouldGoNext) {
            // if shouldGoNext is true then open next popup else exit
            if (binding.viewPager.currentItem < viewPagerAdapter?.count!! - 1) {

                if (viewPagerAdapter?.getItem(binding.viewPager.currentItem + 1) is BlankFragment) {
                    // if next position is diet
                    if (binding.viewPager.currentItem < viewPagerAdapter?.count!! - 2) {
                        binding.viewPager.currentItem = binding.viewPager.currentItem + 2
                    } else {
                        navigator.goBack()
                    }

                } else {
                    binding.viewPager.currentItem = binding.viewPager.currentItem + 1
                }

            } else {
                navigator.goBack()
            }
        } else {
            navigator.goBack()
        }
    }

    private var viewPagerAdapter: ViewPagerAdapter? = null
    private val logMedicationFragment = LogMedicationFragment().apply {
        callbackOnClose = callback
    }
    private val logExerciseFragment = LogExerciseFragment().apply {
        callbackOnClose = callback
    }
    private val logPranayamFragment = LogPranayamFragment().apply {
        callbackOnClose = callback
    }
    private val logStepsFragment = LogStepsFragment().apply {
        callbackOnClose = callback
    }
    private val logWaterIntakeFragment = LogWaterIntakeFragment().apply {
        callbackOnClose = callback
    }
    private val logSleepFragment = LogSleepFragment().apply {
        callbackOnClose = callback
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): GoalFragmentUpdateLogsBinding {
        return GoalFragmentUpdateLogsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        getArgumentsData()
        if (goalsList.isNotEmpty()) {
            setUpViewPager()
        }
        setViewListeners()
    }

    private fun getArgumentsData() {
        arguments?.let {
            currentPosition = it.getInt(Common.BundleKey.POSITION)
            goalsList.clear()
            it.getParcelableArrayList<GoalReadingData>(Common.BundleKey.GOAL_LIST)?.let { it1 ->
                goalsList.addAll(it1)
            }
        }
    }

    private fun setUpViewPager() {
        with(binding) {
            viewPagerAdapter = ViewPagerAdapter(childFragmentManager)
            addFragmentsAsPerGoalsList()
            viewPager.adapter = viewPagerAdapter
            viewPager.offscreenPageLimit = 2
            viewPager.pageMargin = resources.getDimension(R.dimen.dp_30).toInt()

            // set popup as per clicked position from list
            viewPager.currentItem = currentPosition
        }
    }

    private fun addFragmentsAsPerGoalsList() {
        // add popup screens as per goals list and set goal data to specific page
        goalsList.forEachIndexed { index, it ->
            when (it.keys) {
                Goals.Medication.goalKey -> {
                    logMedicationFragment.goalReadingData = it
                    logMedicationFragment.isLastIndex = index == goalsList.lastIndex
                    viewPagerAdapter?.addFrag(logMedicationFragment)
                }
                Goals.Exercise.goalKey -> {
                    logExerciseFragment.goalReadingData = it
                    logExerciseFragment.isLastIndex = index == goalsList.lastIndex
                    viewPagerAdapter?.addFrag(logExerciseFragment)
                }
                Goals.Pranayam.goalKey -> {
                    logPranayamFragment.goalReadingData = it
                    logPranayamFragment.isLastIndex = index == goalsList.lastIndex
                    viewPagerAdapter?.addFrag(logPranayamFragment)
                }
                Goals.Steps.goalKey -> {
                    logStepsFragment.goalReadingData = it
                    logStepsFragment.isLastIndex = index == goalsList.lastIndex
                    viewPagerAdapter?.addFrag(logStepsFragment)
                }
                Goals.WaterIntake.goalKey -> {
                    logWaterIntakeFragment.goalReadingData = it
                    logWaterIntakeFragment.isLastIndex = index == goalsList.lastIndex
                    viewPagerAdapter?.addFrag(logWaterIntakeFragment)
                }
                Goals.Sleep.goalKey -> {
                    logSleepFragment.goalReadingData = it
                    logSleepFragment.isLastIndex = index == goalsList.lastIndex
                    viewPagerAdapter?.addFrag(logSleepFragment)
                }
                Goals.Diet.goalKey -> {
                    viewPagerAdapter?.addFrag(BlankFragment())
                }
            }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewPrev.setOnClickListener { onViewClick(it) }
            imageViewNext.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewPrev -> {
                with(binding) {
                    if (viewPager.currentItem > 0) {
                        viewPager.currentItem = viewPager.currentItem - 1
                    }
                }
            }
            R.id.imageViewNext -> {
                with(binding) {
                    if (viewPager.currentItem < viewPagerAdapter?.count?.minus(1) ?: 0) {
                        viewPager.currentItem = viewPager.currentItem + 1
                    } else {
                        navigator.goBack()
                    }
                }
            }
        }
    }


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {

    }


}