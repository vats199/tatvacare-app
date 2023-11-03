package com.mytatva.patient.ui.goal.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.transition.TransitionManager
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.MonthlyCalData
import com.mytatva.patient.databinding.GoalFragmentFoodDiaryMonthBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.convertToDate
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.materialcalendar.CurrentDayDecorator
import com.mytatva.patient.utils.materialcalendar.ExcessCalorieDayDecorator
import com.mytatva.patient.utils.materialcalendar.LessCalorieDayDecorator
import com.mytatva.patient.utils.materialcalendar.LimitCalorieDayDecorator
import com.prolificinteractive.materialcalendarview.CalendarDay
import com.prolificinteractive.materialcalendarview.DayViewDecorator
import com.prolificinteractive.materialcalendarview.DayViewFacade
import com.prolificinteractive.materialcalendarview.MaterialCalendarView
import java.util.*
import java.util.concurrent.TimeUnit

class FoodDiaryMonthFragment : BaseFragment<GoalFragmentFoodDiaryMonthBinding>() {

    val monthlyCalDataList = arrayListOf<MonthlyCalData>()

    var selectedMonth = 0
    var selectedYear = 0

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
    ): GoalFragmentFoodDiaryMonthBinding {
        return GoalFragmentFoodDiaryMonthBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.FoodDiaryMonth)
        if (selectedMonth == 0 && selectedYear == 0) {
            val cal = Calendar.getInstance()
            selectedYear = cal.get(Calendar.YEAR)
            selectedMonth = cal.get(Calendar.MONTH) + 1
            getMonthlyDietCal()
        }

        resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_FOOD_DIARY_MONTH, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.FoodDiaryMonth)
    }

    override fun bindData() {
        setViewListeners()
        setUpRecyclerView()
        setUpMaterialCalendar()
        binding.materialCalender.state().edit().setMaximumDate(CalendarDay.today()).commit()
        toggleInfo(false)
    }

    private fun setUpMaterialCalendar() {
        with(binding) {
//        materialCalender.tileHeight = materialCalender.tileWidth
            //materialCalender.state().edit().setMaximumDate(CalendarDay.today()).commit()
            materialCalender.selectionMode = MaterialCalendarView.SELECTION_MODE_SINGLE

            materialCalender.addDecorator(object : DayViewDecorator {
                override fun shouldDecorate(day: CalendarDay?): Boolean {
                    return true
                }

                override fun decorate(view: DayViewFacade?) {
                    view?.setSelectionDrawable(resources.getDrawable(R.drawable.date_day_selector,
                        null))
                }
            })

            materialCalender.setOnMonthChangedListener { widget, date ->
                selectedMonth = date.month
                selectedYear = date.year
                getMonthlyDietCal()
            }

            materialCalender.addDecorator(CurrentDayDecorator(requireActivity(),
                isBlueTheme = true))

            setUpCalorieDecorators()

            materialCalender.setOnDateChangedListener { widget, date, selected ->
                val selectedDate = date.date.convertToDate()

                /*navigator.loadActivity(IsolatedFullActivity::class.java,
                    FoodDayInsightFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.DATE, date.date.convertToDate())
                    )).start()*/

                if ((requireActivity() as BaseActivity).getCurrentFragment<BaseFragment<*>>() != null &&
                    (requireActivity() as BaseActivity).getCurrentFragment<BaseFragment<*>>() is FoodDiaryMainFragment
                ) {
                    ((requireActivity() as BaseActivity).getCurrentFragment<BaseFragment<*>>() as FoodDiaryMainFragment)
                        .showFoodDiaryDayWithDate(selectedDate)
                }
            }
            materialCalender.selectedDate = CalendarDay.today()
        }
    }

    private fun setUpCalorieDecorators() {
        with(binding) {
            val lessDates = arrayListOf<CalendarDay>()
            val perfectDates = arrayListOf<CalendarDay>()
            val exceedDates = arrayListOf<CalendarDay>()

            monthlyCalDataList.forEachIndexed { index, monthlyCalData ->
                when (monthlyCalData.calories_limit) {
                    "less" -> {
                        monthlyCalData.getAsCalendarDay?.let { lessDates.add(it) }
                    }
                    "perfect" -> {
                        monthlyCalData.getAsCalendarDay?.let { perfectDates.add(it) }
                    }
                    "exceed" -> {
                        monthlyCalData.getAsCalendarDay?.let { exceedDates.add(it) }
                    }
                }
            }

            if (exceedDates.isNotEmpty()) {
                materialCalender.addDecorator(ExcessCalorieDayDecorator(requireActivity(),
                    exceedDates))
            }
            if (perfectDates.isNotEmpty()) {
                materialCalender.addDecorator(LimitCalorieDayDecorator(requireActivity(),
                    perfectDates))
            }
            if (lessDates.isNotEmpty()) {
                materialCalender.addDecorator(LessCalorieDayDecorator(requireActivity(),
                    lessDates))
            }
        }
    }

    private fun setUpRecyclerView() {
        with(binding) {

        }
    }

    private fun setViewListeners() {
        with(binding) {
            layoutInfoQuestion.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.layoutInfoQuestion -> {
                toggleInfo(true)
            }
        }
    }

    private fun toggleInfo(isToAnimate: Boolean) {
        with(binding) {
            if (isToAnimate)
                TransitionManager.beginDelayedTransition(root)
            if (layoutInfoQuestion.isSelected) {
                layoutInfoQuestion.isSelected = false
                imageViewUpDown.rotation = 0F
                layoutCalendarInfoData.visibility = View.GONE
            } else {
                layoutInfoQuestion.isSelected = true
                imageViewUpDown.rotation = 180F
                layoutCalendarInfoData.visibility = View.VISIBLE
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getMonthlyDietCal() {
        val apiRequest = ApiRequest().apply {
            month = selectedMonth.toString()
            year = selectedYear.toString()
        }
        goalReadingViewModel.getMonthlyDietCal(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.getMonthlyDietCalLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                monthlyCalDataList.clear()
                responseBody.data?.let { monthlyCalDataList.addAll(it) }
                setUpMaterialCalendar()
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

}