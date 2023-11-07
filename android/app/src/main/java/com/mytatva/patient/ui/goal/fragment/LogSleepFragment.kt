package com.mytatva.patient.ui.goal.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.GoalFragmentLogSleepBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.formatToDecimalPoint
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*

class LogSleepFragment :
    BaseFragment<GoalFragmentLogSleepBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    var goalReadingData: GoalReadingData? = null
    var isLastIndex: Boolean = false

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    /*validator.submit(textViewDate)
                        .checkEmpty().errorMessage("Please select date")
                        .check()

                    validator.submit(textViewTime)
                        .checkEmpty().errorMessage("Please select time")
                        .check()*/

                    validator.submit(editTextStartTime)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_select_start_date_time))
                        .check()

                    validator.submit(editTextEndTime)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_select_end_date_time))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    val calStartTime: Calendar = Calendar.getInstance()
    val calEndTime: Calendar = Calendar.getInstance()

    //    private val cal = Calendar.getInstance()
    var isGoToNext = false
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
    ): GoalFragmentLogSleepBinding {
        return GoalFragmentLogSleepBinding.inflate(inflater, container, attachToRoot)/*.apply {
            rootBg.transitionName = goalReadingData?.keys
            (requireActivity() as TransparentActivity).scheduleStartPostponedTransition(rootBg)
        }*/
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LogGoal.plus(goalReadingData?.keys))
        setData()
    }

    private fun setData() {
        goalReadingData?.let {
            with(binding) {
                UpdateGoalLogsFragment.setUpHeader(it, layoutHeader, navigator)

                UpdateGoalLogsFragment.setUpSyncDataLayout(binding.layoutSyncData,
                    googleFit.hasAllPermissions, googleFit, (requireActivity() as BaseActivity))

                /*textViewDate.text = try {
                    DateTimeFormatter.date(cal.time)
                        .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
                } catch (e: Exception) {
                    ""
                }
                textViewTime.text = try {
                    DateTimeFormatter.date(cal.time)
                        .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
                } catch (e: Exception) {
                    ""
                }*/

                editTextStartTime
                editTextEndTime
            }
            analytics.logEvent(
                AnalyticsClient.CLICKED_HEALTH_INSIGHTS,
                Bundle().apply {
                    putString(
                        analytics.PARAM_HEALTH_MARKER_NAME,
                        it.goal_name
                    )
                    putString(
                        analytics.PARAM_HEALTH_MARKER_COLOUR,
                        it.color_code
                    )
                    putString(
                        analytics.PARAM_HEALTH_MARKER_VALUE,
                        it.todays_achieved_value
                    )
                }
            )
        }
    }

    override fun bindData() {
        setViewListeners()
        binding.buttonAddNext.visibility = if (isLastIndex) View.GONE else View.VISIBLE
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonAdd.setOnClickListener { onViewClick(it) }
            buttonAddNext.setOnClickListener { onViewClick(it) }
            editTextStartTime.setOnClickListener { onViewClick(it) }
            editTextEndTime.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonAdd -> {
                if (isValid) {
                    isGoToNext = false
                    updateGoalLogs()
                }
            }
            R.id.imageViewClose -> {
                callbackOnClose.invoke(false)
            }
            R.id.buttonAddNext -> {
                if (isValid) {
                    isGoToNext = true
                    updateGoalLogs()
                }
            }
            R.id.editTextStartTime -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->

                    navigator.pickTime({ _, hourOfDay, minute ->

                        val calTemp = Calendar.getInstance()
                        calTemp.set(year, month, dayOfMonth)
                        calTemp.set(Calendar.HOUR_OF_DAY, hourOfDay)
                        calTemp.set(Calendar.MINUTE, minute)
                        calTemp.set(Calendar.SECOND, 0)

                        if (Calendar.getInstance().before(calTemp)) {
                            showMessage(getString(R.string.validation_valid_time))
                        } else {
                            calStartTime.set(year, month, dayOfMonth)
                            calStartTime.set(Calendar.HOUR_OF_DAY, hourOfDay)
                            calStartTime.set(Calendar.MINUTE, minute)
                            calStartTime.set(Calendar.SECOND, 0)

                            binding.editTextStartTime.setText(DateTimeFormatter.date(calStartTime.time)
                                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE_TIME))
                            binding.editTextEndTime.setText("")
                        }

                    }, false)

                }, 0L, Calendar.getInstance().timeInMillis)

            }
            R.id.editTextEndTime -> {
                if (binding.editTextStartTime.text.toString().isBlank()) {
                    //showMessage("Please select start date and time")
                    getString(R.string.validation_select_start_date_time)
                } else {

                    val calMaxEndDateTime = Calendar.getInstance()
                    calMaxEndDateTime.timeInMillis = calStartTime.timeInMillis
                    calMaxEndDateTime.add(Calendar.DAY_OF_MONTH, 1)

                    if (calMaxEndDateTime.after(Calendar.getInstance())) {
                        // if max time is of future then set to current time
                        calMaxEndDateTime.timeInMillis = Calendar.getInstance().timeInMillis
                    }

                    navigator.pickDate({ _, year, month, dayOfMonth ->

                        navigator.pickTime({ _, hourOfDay, minute ->

                            val calTemp = Calendar.getInstance()
                            calTemp.set(year, month, dayOfMonth)
                            calTemp.set(Calendar.HOUR_OF_DAY, hourOfDay)
                            calTemp.set(Calendar.MINUTE, minute)
                            calTemp.set(Calendar.SECOND, 0)

                            val calMinValidEndTime = Calendar.getInstance()
                            calMinValidEndTime.timeInMillis = calStartTime.timeInMillis
                            calMinValidEndTime.add(Calendar.MINUTE, 1)
                            // at least 1 minute diff between start & end time
                            if (calTemp.before(calMinValidEndTime)) {
                                showMessage(getString(R.string.validation_valid_end_date_time))
                            } else if (calMaxEndDateTime.before(calTemp)) {
                                showMessage(getString(R.string.validation_valid_time))
                            } else {

                                calEndTime.set(year, month, dayOfMonth)
                                calEndTime.set(Calendar.HOUR_OF_DAY, hourOfDay)
                                calEndTime.set(Calendar.MINUTE, minute)
                                calEndTime.set(Calendar.SECOND, 0)

                                binding.editTextEndTime.setText(DateTimeFormatter.date(calEndTime.time)
                                    .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE_TIME))
                            }

                        }, false)

                    }, calStartTime.timeInMillis, calMaxEndDateTime.timeInMillis)
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateGoalLogs() {
        val apiRequest = ApiRequest().apply {
            goal_id = goalReadingData?.goal_master_id
            achieved_value =
                DateTimeFormatter.getDiffInHours(calStartTime, calEndTime).formatToDecimalPoint(2)
            achieved_datetime = DateTimeFormatter.date(calEndTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)

            // again start_time & end_time params added for resolve time conflict issue in API side
            start_time = DateTimeFormatter.date(calStartTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
            end_time = DateTimeFormatter.date(calEndTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
        }
        showLoader()
        goalReadingViewModel.updateGoalLogs(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.updateGoalLogsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"updatedGoalReadingSuccess","") }

                analytics.logEvent(analytics.USER_UPDATED_ACTIVITY, Bundle().apply {
                    putString(analytics.PARAM_GOAL_NAME, goalReadingData?.goal_name)
                    putString(analytics.PARAM_GOAL_ID, goalReadingData?.goal_master_id)
                    putString(analytics.PARAM_GOAL_VALUE,
                        DateTimeFormatter.getDiffInHours(calStartTime, calEndTime)
                            .formatToDecimalPoint(2))
                }, screenName = AnalyticsScreenNames.LogGoal)
                writeToGoogleFit()

                showMessage(responseBody.message)
                Handler(Looper.getMainLooper()).postDelayed({
                    if (isAdded)
                        callbackOnClose.invoke(isGoToNext)
                }, 1000)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun writeToGoogleFit() {
        if (googleFit.hasAllPermissions) {
            googleFit.writeSleep(calStartTime, calEndTime)
            //googleFit.writeSleepV2(calStartTime, calEndTime)
        }
    }
}