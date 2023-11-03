package com.mytatva.patient.ui.goal.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.AppConstants
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.GoalFragmentLogWaterIntakeBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*

class LogWaterIntakeFragment :
    BaseFragment<GoalFragmentLogWaterIntakeBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    var goalReadingData: GoalReadingData? = null
    var isLastIndex: Boolean = false

    private var noOfGlass = 1

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(textViewDate)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_date))
                        .check()

                    validator.submit(textViewTime)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_time))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    private val cal = Calendar.getInstance()
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
    ): GoalFragmentLogWaterIntakeBinding {
        return GoalFragmentLogWaterIntakeBinding.inflate(inflater, container, attachToRoot)/*.apply {
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

                updateDate()
                updateTime()

                // if need to show last logged value as default
                // then open below comment
                /*if (it.achieved_value.isNullOrBlank().not()
                    && it.achieved_value?.toIntOrNull() != 0
                ) {
                    noOfGlass = it.achieved_value?.toIntOrNull() ?: noOfGlass
                }*/
                updateCount()
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
        updateCount()

        binding.buttonAddNext.visibility = if (isLastIndex) View.GONE else View.VISIBLE
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonAdd.setOnClickListener { onViewClick(it) }
            buttonAddNext.setOnClickListener { onViewClick(it) }
            imageViewPlus.setOnClickListener { onViewClick(it) }
            imageViewMinus.setOnClickListener { onViewClick(it) }
            editTextContainer.setOnClickListener { onViewClick(it) }
            textViewDate.setOnClickListener { onViewClick(it) }
            textViewTime.setOnClickListener { onViewClick(it) }
        }
    }

    private fun updateDate() {
        binding.textViewDate.text = try {
            DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
        } catch (e: Exception) {
            ""
        }
    }

    private fun updateTime() {
        binding.textViewTime.text = try {
            DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
        } catch (e: Exception) {
            ""
        }
    }


    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewDate -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->
                    cal.set(year, month, dayOfMonth)

                    //set current time when on date change
                    val calCurrentTime = Calendar.getInstance()
                    cal.set(Calendar.HOUR_OF_DAY, calCurrentTime.get(Calendar.HOUR_OF_DAY))
                    cal.set(Calendar.MINUTE, calCurrentTime.get(Calendar.MINUTE))
                    cal.set(Calendar.SECOND, 0)

                    updateDate()
                    updateTime()

                }, 0L, Calendar.getInstance().timeInMillis)
            }
            R.id.textViewTime -> {
                navigator.pickTime({ _, hourOfDay, minute ->

                    val calTemp = Calendar.getInstance()
                    calTemp.timeInMillis = cal.timeInMillis
                    calTemp.set(Calendar.HOUR_OF_DAY, hourOfDay)
                    calTemp.set(Calendar.MINUTE, minute)
                    calTemp.set(Calendar.SECOND, 0)

                    if (Calendar.getInstance().before(calTemp)) {
                        showMessage(getString(R.string.validation_valid_time))
                    } else {
                        cal.set(Calendar.HOUR_OF_DAY, hourOfDay)
                        cal.set(Calendar.MINUTE, minute)
                        cal.set(Calendar.SECOND, 0)
                        updateTime()
                    }

                }, false)
            }
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
            R.id.imageViewPlus -> {
                noOfGlass++
                updateCount()
            }
            R.id.imageViewMinus -> {
                if (noOfGlass > 1) {
                    noOfGlass--
                    updateCount()
                }
            }
            R.id.editTextContainer -> {
            }
        }
    }

    private fun updateCount() {
        binding.editTextQuantity.setText(noOfGlass.toString())
        binding.editTextContainer.setText("Glass - ${/*noOfGlass **/ AppConstants.WATER_ML_PER_GLASS} ml")
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateGoalLogs() {
        val apiRequest = ApiRequest().apply {
            goal_id = goalReadingData?.goal_master_id
            achieved_value = binding.editTextQuantity.text.toString().trim()
            achieved_datetime = DateTimeFormatter.date(cal.time)
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

                writeToGoogleFit()
                analytics.logEvent(analytics.USER_UPDATED_ACTIVITY, Bundle().apply {
                    putString(analytics.PARAM_GOAL_NAME, goalReadingData?.goal_name)
                    putString(analytics.PARAM_GOAL_ID, goalReadingData?.goal_master_id)
                    putString(analytics.PARAM_GOAL_VALUE, binding.editTextQuantity.text.toString().trim())
                }, screenName = AnalyticsScreenNames.LogGoal)

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
        if (googleFit.hasAllPermissions && noOfGlass > 0) {
            googleFit.writeWaterIntake(noOfGlass, cal)
        }
    }
}