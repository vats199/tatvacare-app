package com.mytatva.patient.ui.exercise

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.ExercisePlanDayData
import com.mytatva.patient.databinding.ExerciseFragmentPlanDetailsNewBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.adapter.ExerciseMyPlansSubAdapter
import com.mytatva.patient.ui.exercise.adapter.ExercisePlanDetailSubNewAdapter
import com.mytatva.patient.ui.exercise.adapter.ExercisePlanDetailsAdapter
import com.mytatva.patient.ui.exercise.adapter.ExercisePlanDetailsNewAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit

class ExercisePlanDetailsNewFragment : BaseFragment<ExerciseFragmentPlanDetailsNewBinding>() {

    val planType by lazy {
        arguments?.getString(Common.BundleKey.PLAN_TYPE)
    }

    val contentMasterId by lazy {
        arguments?.getString(Common.BundleKey.CONTENT_ID)
    }

    val title by lazy {
        arguments?.getString(Common.BundleKey.TITLE)
    }

    private val exerciseAddedByType by lazy {
        // set to fix "A" - Admin, when this screen open from deeplink,
        // because deeplink is not there, when exercise added by HealthCoach
        arguments?.getString(Common.BundleKey.EXERCISE_ADDED_BY) ?: "A"
    }

    // for normal plans
    private val planList = arrayListOf<ExercisePlanDayData>()
    private val exercisePlanDetailsAdapter by lazy {
        ExercisePlanDetailsAdapter(planList,
            object : ExercisePlanDetailsAdapter.AdapterListener {
                override fun onItemClick(position: Int) {

                    if (planList[position].is_rest_day != "1") {
                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            PlanDayDetailsNewFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.EXERCISE_PLAN_DAY_ID,
                                    planList[position].exercise_plan_day_id),
                                Pair(Common.BundleKey.PLAN_TYPE, planType)
                            )).start()
                    }

                }
            }, object : ExerciseMyPlansSubAdapter.AdapterListener {
                override fun onItemClick(mainPosition: Int, position: Int) {
                    /*navigator.loadActivity(IsolatedFullActivity::class.java,
                        PlanDayDetailsFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.EXERCISE_PLAN_DAY_ID,
                                planList[mainPosition].exercise_plan_day_id)
                        )).start()*/

                    if (planList[mainPosition].is_rest_day != "1") {
                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            PlanDayDetailsNewFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.EXERCISE_PLAN_DAY_ID,
                                    planList[mainPosition].exercise_plan_day_id),
                                Pair(Common.BundleKey.PLAN_TYPE, planType)
                            )).start()
                    }

                }
            })
    }

    // for customized plans
    private val customizedPlanList = arrayListOf<ExercisePlanDayData>()
    private val exercisePlanDetailsCustomizedAdapter by lazy {
        ExercisePlanDetailsNewAdapter(customizedPlanList,
            object : ExercisePlanDetailSubNewAdapter.AdapterListener {
                override fun onItemClick(mainPosition: Int, position: Int) {
                    if (customizedPlanList.isNotEmpty()) {
                        // need to pass routine & exercise_added_by also for customized plan
                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            PlanDayDetailsNewFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.EXERCISE_PLAN_DAY_ID,
                                    customizedPlanList[mainPosition].exercise_plan_day_id),
                                Pair(Common.BundleKey.PLAN_TYPE, planType),
                                Pair(Common.BundleKey.ROUTINE,
                                    customizedPlanList[mainPosition].routine_data?.get(position)?.routine),
                                Pair(Common.BundleKey.EXERCISE_ADDED_BY, exerciseAddedByType)
                            )).start()
                    }
                }
            })

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
    ): ExerciseFragmentPlanDetailsNewBinding {
        return ExerciseFragmentPlanDetailsNewBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis
    override fun onResume() {
        super.onResume()
        if (planType == Common.ExercisePlanType.NORMAL) {
            planDaysList()
        } else {
            planDaysListCustomised()
        }
        resumedTime = Calendar.getInstance().timeInMillis
        analytics.setScreenName(AnalyticsScreenNames.ExercisePlanDetail)
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_PLAN_DETAIL, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        },screenName = AnalyticsScreenNames.ExercisePlanDetail)
    }

    override fun bindData() {
        setUpToolbar()
        setViewListeners()
        setUpRecyclerView()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = title ?: ""
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewPlanDetail.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = if (planType == Common.ExercisePlanType.NORMAL)
                    exercisePlanDetailsAdapter
                else
                    exercisePlanDetailsCustomizedAdapter
            }
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
    private fun planDaysList() {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
        }
        showLoader()
        engageContentViewModel.planDaysList(apiRequest)
    }

    private fun planDaysListCustomised() {
        val apiRequest = ApiRequest().apply {
            content_master_id = contentMasterId
            type = exerciseAddedByType // [A,H] - Admin or HealthCoach
        }
        showLoader()
        engageContentViewModel.planDaysListCustomised(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        //planDaysListLiveData
        engageContentViewModel.planDaysListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                planList.clear()
                responseBody.data?.let { planList.addAll(it) }
                exercisePlanDetailsAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //planDaysListCustomisedLiveData
        engageContentViewModel.planDaysListCustomisedLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                customizedPlanList.clear()
                responseBody.data?.let { customizedPlanList.addAll(it) }
                exercisePlanDetailsCustomizedAdapter.notifyDataSetChanged()
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

}