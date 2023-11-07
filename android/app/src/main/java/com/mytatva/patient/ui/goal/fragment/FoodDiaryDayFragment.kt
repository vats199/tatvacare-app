package com.mytatva.patient.ui.goal.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.FoodLogMainData
import com.mytatva.patient.data.pojo.response.FoodLogResData
import com.mytatva.patient.databinding.GoalFragmentFoodDiaryDayBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.FoodDiaryDayMainAdapter
import com.mytatva.patient.ui.goal.adapter.FoodDiaryDaySubAdapter
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*
import java.util.concurrent.TimeUnit

class FoodDiaryDayFragment : BaseFragment<GoalFragmentFoodDiaryDayBinding>() {

    private val foodDiaryList = arrayListOf<FoodLogMainData>()/*.apply {
        add(TempDataModel(name = "Plan 1", subList = arrayListOf(TempDataModel(), TempDataModel())))
        add(TempDataModel(name = "Plan 2", subList = arrayListOf(TempDataModel(), TempDataModel())))
        add(TempDataModel(name = "Plan 3", subList = arrayListOf(TempDataModel(), TempDataModel())))
        add(TempDataModel(name = "Plan 4", subList = arrayListOf(TempDataModel(), TempDataModel())))
        add(TempDataModel(name = "Plan 5", subList = arrayListOf(TempDataModel(), TempDataModel())))
    }*/

    private val foodDiaryDayMainAdapter by lazy {
        FoodDiaryDayMainAdapter(foodDiaryList,
            object : FoodDiaryDayMainAdapter.AdapterListener {
                override fun onItemClick(position: Int) {

                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        LogFoodFragment::class.java)
                        .addBundle(bundleOf(
                            // pass key to show selected meal type while adding new log
                            Pair(Common.BundleKey.MEAL_TYPE_KEY, foodDiaryList[position].keys),
                            Pair(Common.BundleKey.DATE, selectedDate)
                        )).start()

                }
            }, object : FoodDiaryDaySubAdapter.AdapterListener {
                override fun onEditClick(mainPosition: Int, position: Int) {

                    if (foodDiaryList[mainPosition].patient_meal_rel_id.isNullOrBlank().not()) {
                        analytics.logEvent(analytics.USER_CLICKED_ON_EDIT_MEAL, Bundle().apply {
                            putString(analytics.PARAM_MEAL_TYPES_ID,
                                foodDiaryList[mainPosition].meal_types_id)
                        }, screenName = AnalyticsScreenNames.FoodDiaryDay)

                        navigator.loadActivity(IsolatedFullActivity::class.java,
                            LogFoodFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.PATIENT_MEAL_REL_ID,
                                    foodDiaryList[mainPosition].patient_meal_rel_id)
                            )).start()

                    }

                }
            })
    }

    var selectedDate = Date()

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): GoalFragmentFoodDiaryDayBinding {
        return GoalFragmentFoodDiaryDayBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.FoodDiaryDay)
        Handler(Looper.getMainLooper()).postDelayed({
            updateDateLabel()
            foodLogs()
        }, 100)

        resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onPause() {
        super.onPause()

        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        /*analytics.logEvent(analytics.TIME_SPENT_FOOD_DIARY_DAY, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.FoodDiaryDay)*/
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()

        updateDateLabel()
    }

    private fun updateDateLabel() {
        binding.textViewDate.text = DateTimeFormatter.date(selectedDate)
            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_MMMMdd)
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewFoodDiaryDay.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = foodDiaryDayMainAdapter
            }
        }
    }

    private fun setViewListeners() {
        with(binding) {
            buttonViewInsight.setOnClickListener { onViewClick(it) }
            textViewDate.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonViewInsight -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs, Goals.Diet.goalKey)) {
                    analytics.logEvent(analytics.USER_CLICKED_ON_INSIGHT,
                        Bundle().apply {
                            putString(analytics.PARAM_DATE_OF_INSIGHT,
                                DateTimeFormatter.date(selectedDate)
                                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd))
                        },
                        screenName = AnalyticsScreenNames.FoodDiaryDay)
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        FoodDayInsightFragment::class.java).addBundle(bundleOf(
                        Pair(Common.BundleKey.DATE, selectedDate)
                    )).start()
                }
            }
            R.id.textViewDate -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->
                    val cal = Calendar.getInstance()
                    cal.set(year, month, dayOfMonth)
                    selectedDate = cal.time
                    updateDateLabel()
                    foodLogs()
                }, 0L, Calendar.getInstance().timeInMillis)
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun foodLogs() {
        val apiRequest = ApiRequest().apply {
            insight_date = DateTimeFormatter.date(selectedDate)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
        }
        showLoader()
        goalReadingViewModel.foodLogs(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.foodLogsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"updatedGoalReadingSuccess","") }

                setData(responseBody.data!!)
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun setData(foodLogResData: FoodLogResData) {
        foodLogResData.let {
            with(binding) {

                val goalValue = it.goal_value?.toDoubleOrNull()?.toInt() ?: 0
                val consumed = it.total_calories_consumed?.toDoubleOrNull()?.toInt() ?: 0
                val available = goalValue - consumed
                if (available <= 0) {
                    textViewCaloriesValue.text = getString(R.string.food_diary_label_completed)
                } else {
                    textViewCaloriesValue.text =
                        available.toString()/*.formatToDecimalPoint(2)*/
                            .plus(getString(R.string.food_diary_label_available))
                }

                textViewTotalIntake.text = it.total_calories_consumed
                progressIndicator.max = it.goal_value?.toDoubleOrNull()?.toInt() ?: 0
                progressIndicator.progress = it.total_calories_consumed?.toDoubleOrNull()?.toInt()
                    ?: 0
            }

            foodDiaryList.clear()
            it.data?.let { it1 -> foodDiaryList.addAll(it1) }
            foodDiaryDayMainAdapter.notifyDataSetChanged()
        }
    }

}