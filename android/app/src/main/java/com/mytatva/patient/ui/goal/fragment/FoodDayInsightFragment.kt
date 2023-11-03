package com.mytatva.patient.ui.goal.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.FoodInsightResData
import com.mytatva.patient.data.pojo.response.MacronutritionAnalysis
import com.mytatva.patient.data.pojo.response.MealEnergyDistribution
import com.mytatva.patient.databinding.GoalFragmentFoodDiaryDayInsightsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.DayInsightDailyAnalysisAdapter
import com.mytatva.patient.ui.goal.adapter.DayInsightMealDistributionAdapter
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit

class FoodDayInsightFragment : BaseFragment<GoalFragmentFoodDiaryDayInsightsBinding>() {

    private var foodInsightResData: FoodInsightResData? = null

    private val dailyAnalysisList = arrayListOf<MacronutritionAnalysis>()
    private val dailyAnalysisAdapter by lazy {
        DayInsightDailyAnalysisAdapter(dailyAnalysisList)
    }

    private val mealDistributionList = arrayListOf<MealEnergyDistribution>()
    private val mealDistributionAdapter by lazy {
        DayInsightMealDistributionAdapter(mealDistributionList)
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
    ): GoalFragmentFoodDiaryDayInsightsBinding {
        return GoalFragmentFoodDiaryDayInsightsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis
    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.FoodDiaryDayInsight)
        resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_FOOD_INSIGHT, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.FoodDiaryDayInsight)
    }

    override fun bindData() {
        try {
            selectedDate =
                (arguments?.getSerializable(Common.BundleKey.DATE) as Date?) ?: selectedDate
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }

        setUpToolbar()
        setUpRecyclerView()
        setUpViewListeners()

        foodInsight()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            val formattedDate = try {
                DateTimeFormatter.date(selectedDate)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_MMMdd)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            textViewToolbarTitle.text = formattedDate.toString().plus(" ").plus(getString(R.string.food_day_insight_title_food_insights))
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            imageViewInfo.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewDailyAnalysis.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = dailyAnalysisAdapter
        }

        binding.recyclerViewMealDistribution.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = mealDistributionAdapter
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.imageViewInfo -> {

            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun foodInsight() {
        val apiRequest = ApiRequest().apply {
            insight_date = DateTimeFormatter.date(selectedDate)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
        }
        showLoader()
        goalReadingViewModel.foodInsight(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.foodInsightLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.USER_VIEWED_DAILY_INSIGHT, screenName = AnalyticsScreenNames.FoodDiaryDayInsight)
                responseBody.data?.let { setData(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setData(foodInsightResData: FoodInsightResData) {
        this.foodInsightResData = foodInsightResData
        foodInsightResData.let {
            mealDistributionList.clear()
            it.meal_energy_distribution?.let { it1 -> mealDistributionList.addAll(it1) }
            mealDistributionAdapter.notifyDataSetChanged()

            dailyAnalysisList.clear()
            it.macronutrition_analysis?.let { it1 -> dailyAnalysisList.addAll(it1) }
            dailyAnalysisAdapter.notifyDataSetChanged()
        }
    }
}