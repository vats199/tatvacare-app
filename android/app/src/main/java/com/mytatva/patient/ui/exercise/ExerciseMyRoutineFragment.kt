package com.mytatva.patient.ui.exercise

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.viewpager.widget.ViewPager
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.MyRoutineMainData
import com.mytatva.patient.data.pojo.response.RoutinesData
import com.mytatva.patient.databinding.ExerciseFragmentMyRoutineBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.ViewPagerAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*

class ExerciseMyRoutineFragment : BaseFragment<ExerciseFragmentMyRoutineBinding>() {

    private var planDate = Calendar.getInstance()
    private var myRoutineMainData: MyRoutineMainData? = null
    private var viewPagerAdapter: ViewPagerAdapter? = null
    private lateinit var engageContentViewModel: EngageContentViewModel

    private var currentPagerPosition = 0

    companion object {
        var isFutureDateSelected = false
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ExerciseFragmentMyRoutineBinding {
        return ExerciseFragmentMyRoutineBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        isFutureDateSelected = false
        engageContentViewModel =
            ViewModelProvider(this, viewModelFactory)[EngageContentViewModel::class.java]
        observeLiveData()
    }

    override fun onShow() {
        super.onShow()
        if (isAdded && isVisible) {
            updateDateAndCallAPI()
        }
    }

    override fun bindData() {
        updateDateAndCallAPI()
        setUpViewPager()
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            textViewDate.setOnClickListener { onViewClick(it) }
        }
    }

    private fun updateDateAndCallAPI() {
        with(binding) {
            textViewDate.text = DateTimeFormatter.date(planDate.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            exercisePlanDetails()
        }
    }

    private fun setUpViewPager() {
        viewPagerAdapter = ViewPagerAdapter(childFragmentManager)

        myRoutineMainData?.exercise_details?.forEachIndexed { index, routineData ->
            viewPagerAdapter?.addFrag(ExerciseMyRoutineListFragment().apply {
                this.routinesData = routineData
            }, "Routine ${routineData.routine_no}")
        }

        with(binding) {
            viewPagerRoutine.adapter = viewPagerAdapter
            tabLayout.setupWithViewPager(viewPagerRoutine)

            viewPagerRoutine.currentItem = currentPagerPosition

            viewPagerRoutine.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
                override fun onPageScrolled(
                    position: Int,
                    positionOffset: Float,
                    positionOffsetPixels: Int,
                ) {

                }

                override fun onPageSelected(position: Int) {
                    currentPagerPosition = position

                    analytics.logEvent(analytics.USER_TAPS_ON_ROUTINE,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_ROUTINE_NO,
                                myRoutineMainData?.exercise_details?.get(position)?.routine_no
                            )
                            putString(
                                analytics.PARAM_PATIENT_EXERCISE_PLANS_ID,
                                myRoutineMainData?.plan_details?.patient_exercise_plans_id
                            )
                            putString(
                                analytics.PARAM_EXERCISE_PLAN_NAME,
                                myRoutineMainData?.plan_details?.exercise_plan_name
                            )
                            putString(
                                analytics.PARAM_START_DATE,
                                myRoutineMainData?.plan_details?.start_date
                            )
                            putString(
                                analytics.PARAM_END_DATE,
                                myRoutineMainData?.plan_details?.end_date
                            )
                        }
                        , screenName = AnalyticsScreenNames.ExerciseMyRoutine)
                }

                override fun onPageScrollStateChanged(state: Int) {

                }
            })
        }
    }


    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewDate -> {
                navigator.pickDate({ view, year, month, dayOfMonth ->
                    planDate = Calendar.getInstance()
                    planDate.set(year, month, dayOfMonth, 0, 0)

                    // update flag for if selected date is future date or not
                    isFutureDateSelected = planDate.after(Calendar.getInstance())
                    //reset pager position on date change
                    currentPagerPosition = 0
                    updateDateAndCallAPI()

                    analytics.logEvent(analytics.USER_CHANGES_DATE
                        , screenName = AnalyticsScreenNames.ExerciseMyRoutine)
                }, minimumDate = 0L, maximumDate = Calendar.getInstance().apply {
                    add(Calendar.YEAR, 5)
                }.timeInMillis)
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun exercisePlanDetails() {
        val apiRequest = ApiRequest().apply {
            plan_date = DateTimeFormatter.date(planDate.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
        }
        //binding.swipeRefreshLayout.isRefreshing = true
        showLoader()
        engageContentViewModel.exercisePlanDetails(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //exercisePlanListLiveData
        engageContentViewModel.exercisePlanDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                //binding.swipeRefreshLayout.isRefreshing = false
                with(binding) {
                    textViewNoData.isVisible = false
                }
                responseBody.data?.let { setData(it) }
            },
            onError = { throwable ->
                hideLoader()
                //binding.swipeRefreshLayout.isRefreshing = false
                handleNoData(throwable.message)
                false
            })
    }

    private fun handleNoData(message: String?) {
        with(binding) {
            groupPlanData.isVisible = false
            groupOfRestDay.isVisible = false
            textViewNoData.isVisible = true
            textViewExerciseTitle.text = ""
            textViewExerciseValidDate.text = ""
            textViewNoData.text = message ?: ""
        }
    }

    private fun setData(myRoutineMainData: MyRoutineMainData) {
        this.myRoutineMainData = myRoutineMainData
        myRoutineMainData.let {
            with(binding) {
                it.plan_details?.let { planDetails ->
                    textViewExerciseTitle.text = planDetails.exercise_plan_name

                    val startDate = try {
                        DateTimeFormatter.date(planDetails.start_date,
                            DateTimeFormatter.FORMAT_yyyyMMdd)
                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
                    } catch (e: Exception) {
                        ""
                    }
                    val endDate = try {
                        DateTimeFormatter.date(planDetails.end_date,
                            DateTimeFormatter.FORMAT_yyyyMMdd)
                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
                    } catch (e: Exception) {
                        ""
                    }

                    textViewExerciseValidDate.text = "Valid from $startDate to $endDate"
                }

                if (myRoutineMainData.is_rest_day == "Y") {
                    groupOfRestDay.isVisible = true
                    groupPlanData.isVisible = false
                } else {
                    groupOfRestDay.isVisible = false
                    groupPlanData.isVisible = true
                    setUpViewPager()
                }
            }
        }


    }
}