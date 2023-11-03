package com.mytatva.patient.ui.reading.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.format.DateUtils
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.ExerciseData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.ReadingFragmentUpdateReadingSedentaryTimeBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.formatToDecimalPoint
import java.util.*

class UpdateReadingSedentaryTimeFragment :
    BaseFragment<ReadingFragmentUpdateReadingSedentaryTimeBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    var goalReadingData: GoalReadingData? = null
    var calDateTime: Calendar = Calendar.getInstance()


    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextStartTimeSleep)
                        .checkEmpty().errorMessage("Please select sleep start date & time")
                        .check()

                    validator.submit(editTextEndTimeSleep)
                        .checkEmpty().errorMessage("Please select sleep end date & time")
                        .check()

                    validator.submit(editTextActivityType)
                        .checkEmpty().errorMessage("Please select physical activity")
                        .check()

                    validator.submit(editTextStartTimeActivity)
                        .checkEmpty()
                        .errorMessage("Please select physical activity start date & time")
                        .check()

                    /*validator.submit(editTextEndTimeActivity)
                        .checkEmpty().errorMessage("Please select physical activity end date & time")
                        .check()*/

                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    private var isGoToNext = false

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    private val calStartTimeSleep: Calendar = Calendar.getInstance()
    private val calEndTimeSleep: Calendar = Calendar.getInstance()

    private val calStartTimeActivity: Calendar = Calendar.getInstance()
    private val calEndTimeActivity: Calendar = Calendar.getInstance()

    private var maxDuration = 120
    private var durationCount = 5

    //private var selectedExerciseId: String? = null
    private var selectedExerciseValue: Int = -1
    private val exerciseList = arrayListOf<ExerciseData>()

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ReadingFragmentUpdateReadingSedentaryTimeBinding {
        return ReadingFragmentUpdateReadingSedentaryTimeBinding.inflate(
            inflater,
            container,
            attachToRoot
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LogReading.plus(goalReadingData?.keys))
    }

    override fun bindData() {
        getExerciseList()
        setViewListeners()
        setUpHeader()
        //setDefaultValues()
    }

    /*private fun setDefaultValues() {
        updateDate()
        updateTime()
    }

    private fun updateDate() {
        binding.editTextDate.setText(
            try {
                DateTimeFormatter.date(calDateTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
            } catch (e: Exception) {
                ""
            }
        )
    }

    private fun updateTime() {
        binding.editTextTime.setText(
            try {
                DateTimeFormatter.date(calDateTime.time)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            } catch (e: Exception) {
                ""
            }
        )
    }*/

    private fun setUpHeader() {
        goalReadingData?.let {
            UpdateReadingsMainFragment.setUpHeaderAndCommonUI(
                it,
                binding.layoutHeader,
                binding.textViewStandardValue
            )
        }

        UpdateReadingsMainFragment.setUpSyncDataLayout(
            binding.layoutSyncData,
            googleFit.hasAllPermissions,
            googleFit,
            (requireActivity() as BaseActivity)
        )
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            /*editTextDate.setOnClickListener { onViewClick(it) }
            editTextTime.setOnClickListener { onViewClick(it) }*/
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonUpdate.setOnClickListener { onViewClick(it) }

            editTextStartTimeSleep.setOnClickListener { onViewClick(it) }
            editTextEndTimeSleep.setOnClickListener { onViewClick(it) }
            editTextStartTimeActivity.setOnClickListener { onViewClick(it) }
            //editTextEndTimeActivity.setOnClickListener { onViewClick(it) }
            editTextActivityType.setOnClickListener { onViewClick(it) }

            imageViewPlus.setOnClickListener { onViewClick(it) }
            imageViewMinus.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewClose -> {
                callbackOnClose.invoke(false)
            }

            /*R.id.editTextDate -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->
                    calDateTime.set(year, month, dayOfMonth)
                    updateDate()
                    binding.editTextTime.setText("")
                }, 0L, Calendar.getInstance().timeInMillis)
            }

            R.id.editTextTime -> {
                navigator.pickTime({ _, hourOfDay, minute ->
                    val calTemp = Calendar.getInstance()
                    calTemp.timeInMillis = calDateTime.timeInMillis
                    calTemp.set(Calendar.HOUR_OF_DAY, hourOfDay)
                    calTemp.set(Calendar.MINUTE, minute)
                    calTemp.set(Calendar.SECOND, 0)

                    if (Calendar.getInstance().before(calTemp)) {
                        showMessage(getString(R.string.validation_valid_time))
                    } else {
                        calDateTime.set(Calendar.HOUR_OF_DAY, hourOfDay)
                        calDateTime.set(Calendar.MINUTE, minute)
                        calDateTime.set(Calendar.SECOND, 0)
                        updateTime()
                    }
                }, false)
            }*/

            R.id.buttonCancel -> {
                callbackOnClose.invoke(false)
            }

            R.id.buttonUpdate -> {
                if (isValid) {
                    updatePatientReadings()
                }
            }

            R.id.editTextStartTimeSleep -> {
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
                            calStartTimeSleep.set(year, month, dayOfMonth)
                            calStartTimeSleep.set(Calendar.HOUR_OF_DAY, hourOfDay)
                            calStartTimeSleep.set(Calendar.MINUTE, minute)
                            calStartTimeSleep.set(Calendar.SECOND, 0)

                            binding.editTextStartTimeSleep.setText(
                                DateTimeFormatter.date(calStartTimeSleep.time)
                                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE_TIME)
                            )
                            binding.editTextEndTimeSleep.setText("")
                            binding.editTextStartTimeActivity.setText("")
                            //binding.editTextEndTimeActivity.setText("")
                        }

                    }, false)

                }, 0L, Calendar.getInstance().timeInMillis)
            }

            R.id.editTextEndTimeSleep -> {
                if (binding.editTextStartTimeSleep.text.toString().isBlank()) {
                    showMessage("Please select sleep start date & time first")
                } else {

                    val calMaxEndDateTime = Calendar.getInstance()
                    calMaxEndDateTime.timeInMillis = calStartTimeSleep.timeInMillis
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
                            calMinValidEndTime.timeInMillis = calStartTimeSleep.timeInMillis
                            calMinValidEndTime.add(Calendar.MINUTE, 1)
                            // at least 1 minute diff between start & end time
                            if (calTemp.before(calMinValidEndTime)) {
                                showMessage(getString(R.string.validation_valid_end_date_time))
                            } else if (calMaxEndDateTime.before(calTemp)) {
                                showMessage(getString(R.string.validation_valid_time))
                            } else {

                                calEndTimeSleep.set(year, month, dayOfMonth)
                                calEndTimeSleep.set(Calendar.HOUR_OF_DAY, hourOfDay)
                                calEndTimeSleep.set(Calendar.MINUTE, minute)
                                calEndTimeSleep.set(Calendar.SECOND, 0)

                                binding.editTextEndTimeSleep.setText(
                                    DateTimeFormatter.date(calEndTimeSleep.time)
                                        .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE_TIME)
                                )
                                binding.editTextStartTimeActivity.setText("")
                                //binding.editTextEndTimeActivity.setText("")
                            }

                        }, false)

                    }, calStartTimeSleep.timeInMillis, calMaxEndDateTime.timeInMillis)
                }
            }

            R.id.editTextStartTimeActivity -> {
                if (binding.editTextStartTimeSleep.text.toString().trim().isEmpty()
                    || binding.editTextEndTimeSleep.text.toString().trim().isEmpty()
                ) {
                    showMessage("Please select sleep start & end time first")
                } else {

                    val calMinDateTimeForActivityStart = Calendar.getInstance()
                    calMinDateTimeForActivityStart.timeInMillis = calEndTimeSleep.timeInMillis

                    val calMaxDateTimeForActivityStart = Calendar.getInstance()
                    calMaxDateTimeForActivityStart.timeInMillis = calEndTimeSleep.timeInMillis

                    navigator.pickDate(
                        { _, year, month, dayOfMonth ->

                            navigator.pickTime({ _, hourOfDay, minute ->

                                val calSelected = Calendar.getInstance()
                                calSelected.set(year, month, dayOfMonth)
                                calSelected.set(Calendar.HOUR_OF_DAY, hourOfDay)
                                calSelected.set(Calendar.MINUTE, minute)
                                calSelected.set(Calendar.SECOND, 0)

                                /*if (calSelected.before(calMinDateTimeForActivityStart)) {
                                    //"Physical activity start time should be greater than sleep end time"
                                    showMessage(getString(R.string.validation_valid_time))
                                } else if (Calendar.getInstance().before(calSelected)) {
                                    //Physical activity start time can not be greater than current time
                                    showMessage(getString(R.string.validation_valid_time))
                                }*/

                                val calMax = Calendar.getInstance()
                                calMax.timeInMillis = calEndTimeSleep.timeInMillis
                                calMax.set(Calendar.HOUR_OF_DAY, 23)
                                calMax.set(Calendar.MINUTE, 59)
                                calMax.set(Calendar.SECOND, 0)
                                calMax.set(Calendar.MILLISECOND, 0)

                                //check max duration minutes for today's date as per selected activity start time
                                val durationDiffInMinutes =
                                    DateTimeFormatter.getDiffInMinutes(calSelected, calMax) + 1

                                if (calMax.before(calSelected)
                                    || (DateUtils.isToday(calEndTimeSleep.timeInMillis) && durationDiffInMinutes < 5)
                                ) {
                                    //Physical activity start time can not be greater than sleep end date and time till 11:59 PM,
                                    //or if date is today's date then duration difference should me greater than 5.
                                    showMessage(getString(R.string.validation_valid_time))
                                } else {
                                    calStartTimeActivity.set(year, month, dayOfMonth)
                                    calStartTimeActivity.set(Calendar.HOUR_OF_DAY, hourOfDay)
                                    calStartTimeActivity.set(Calendar.MINUTE, minute)
                                    calStartTimeActivity.set(Calendar.SECOND, 0)

                                    binding.editTextStartTimeActivity.setText(
                                        DateTimeFormatter.date(calStartTimeActivity.time)
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE_TIME)
                                    )
                                    //binding.editTextEndTimeActivity.setText("")

                                    // update maxDuration as per selected start time
                                    if (DateUtils.isToday(calEndTimeSleep.timeInMillis)) {
                                        // for today's date, till 11:59, -1 as max can be till 11:59 for today's time and we have logic of +-5
                                        maxDuration = durationDiffInMinutes.toInt() /*- 1*/

                                        // if selected duration(durationCount) is greater than max, reset to 5
                                        /*if (durationCount > maxDuration) {
                                            durationCount = 5
                                            updateDuration()
                                        }*/

                                        // always reset duration to 5 if it's valid or not, as discussed with team
                                        durationCount = 5
                                        updateDuration()

                                    } else {
                                        // for past date, it's 23:59
                                        maxDuration = 1439
                                    }

                                }

                            }, false)

                        },
                        calMinDateTimeForActivityStart.timeInMillis,
                        calMaxDateTimeForActivityStart.timeInMillis
                    )
                }
            }

            /*R.id.editTextEndTimeActivity -> {
                if (binding.editTextStartTimeSleep.text.toString().trim().isEmpty()
                    || binding.editTextEndTimeSleep.text.toString().trim().isEmpty()
                ) {
                    showMessage("Please select sleep start & end time first")
                } else if (binding.editTextStartTimeActivity.text.toString().isBlank()) {
                    //showMessage("Please select start date and time")
                    showMessage("Please select physical activity start date & time first")
                } else {

                    val calMaxEndDateTime = Calendar.getInstance()
                    calMaxEndDateTime.timeInMillis = calStartTimeActivity.timeInMillis

                    // to set max up to next 24 hours same as sleep end time, use below code
                    //calMaxEndDateTime.add(Calendar.DAY_OF_MONTH, 1)
                    //====

                    // to set max up to 11:59:59 PM for same day as selected start physical activity date-time, use below code
                    calMaxEndDateTime.set(Calendar.HOUR_OF_DAY, 23)
                    calMaxEndDateTime.set(Calendar.MINUTE, 59)
                    calMaxEndDateTime.set(Calendar.SECOND, 59)
                    //====

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
                            calMinValidEndTime.timeInMillis = calStartTimeActivity.timeInMillis
                            calMinValidEndTime.add(Calendar.MINUTE, 1)
                            // at least 1 minute diff between start & end time
                            if (calTemp.before(calMinValidEndTime)) {
                                showMessage(getString(R.string.validation_valid_end_date_time))
                            } else if (calMaxEndDateTime.before(calTemp)) {
                                showMessage(getString(R.string.validation_valid_time))
                            } else {

                                calEndTimeActivity.set(year, month, dayOfMonth)
                                calEndTimeActivity.set(Calendar.HOUR_OF_DAY, hourOfDay)
                                calEndTimeActivity.set(Calendar.MINUTE, minute)
                                calEndTimeActivity.set(Calendar.SECOND, 0)

                                binding.editTextEndTimeActivity.setText(
                                    DateTimeFormatter.date(calEndTimeActivity.time)
                                        .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE_TIME)
                                )
                            }

                        }, false)

                    }, calStartTimeActivity.timeInMillis, calMaxEndDateTime.timeInMillis)
                }
            }*/

            R.id.imageViewPlus -> {
                if ((durationCount + 5) <= maxDuration) {
                    durationCount += 5
                    updateDuration()
                }
            }

            R.id.imageViewMinus -> {
                if (durationCount > 5) {
                    durationCount -= 5
                    updateDuration()
                }
            }

            R.id.editTextActivityType -> {
                showExerciseDialog()
            }
        }
    }

    private fun updateDuration() {
        binding.editTextActivityDuration.setText(durationCount.toString())
    }

    private fun showExerciseDialog() {
        BottomSheet<ExerciseData>().showBottomSheetDialog(requireActivity(),
            exerciseList,
            "Physical Activity",
            object : BottomSheetAdapter.ItemListener<ExerciseData> {
                override fun onItemClick(item: ExerciseData, position: Int) {
                    //selectedExerciseId = item.exercise_master_id
                    selectedExerciseValue =
                        item.exercise_value?.toIntOrNull() ?: selectedExerciseValue
                    binding.editTextActivityType.setText(item.exercise_name)
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<ExerciseData>.MyViewHolder,
                    position: Int,
                    item: ExerciseData,
                ) {
                    holder.textView.text = item.exercise_name
                }
            })
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getExerciseList() {
        val apiRequest = ApiRequest()
        //showLoader()
        goalReadingViewModel.getExerciseList(apiRequest)
    }

    private fun updatePatientReadings() {
        val apiRequest = ApiRequest().apply {
            reading_id = goalReadingData?.readings_master_id

            reading_value_data = ApiRequestSubData().apply {
                sleep_start_time = DateTimeFormatter.date(calStartTimeSleep.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                sleep_end_time = DateTimeFormatter.date(calEndTimeSleep.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                sleep_achieved_value =
                    DateTimeFormatter.getDiffInHours(calStartTimeSleep, calEndTimeSleep)
                        .formatToDecimalPoint(2)

                patient_sub_goal_id = selectedExerciseValue.toString()

                //add duration minutes to end time calendar as per selected start time
                calEndTimeActivity.timeInMillis = calStartTimeActivity.timeInMillis
                calEndTimeActivity.add(Calendar.MINUTE, durationCount)

                exercise_start_time = DateTimeFormatter.date(calStartTimeActivity.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                exercise_end_time = DateTimeFormatter.date(calEndTimeActivity.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                /*physical_time_difference =
                    DateTimeFormatter.getDiffInHours(calStartTimeActivity, calEndTimeActivity).formatToDecimalPoint(2)*/
            }

            // pass activity end time on reading_datetime
            reading_datetime = DateTimeFormatter.date(calEndTimeActivity.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
        }
        showLoader()
        goalReadingViewModel.updatePatientReadings(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.getExerciseListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            exerciseList.clear()
            responseBody.data?.let { exerciseList.addAll(it) }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        goalReadingViewModel.updatePatientReadingsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                writeToGoogleFit()
                analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                    putString(analytics.PARAM_READING_NAME, goalReadingData?.reading_name)
                    putString(analytics.PARAM_READING_ID, goalReadingData?.readings_master_id)
                }, screenName = AnalyticsScreenNames.LogReading)
                showMessage(responseBody.message)
                Handler(Looper.getMainLooper())
                    .postDelayed({
                        if (isAdded)
                            callbackOnClose.invoke(false)
                    }, 1000)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun writeToGoogleFit() {
        if (googleFit.hasAllPermissions) {
            googleFit.writeSleep(calStartTimeSleep, calEndTimeSleep)

            if (selectedExerciseValue != -1) {

                val calStart = Calendar.getInstance()
                calStart.timeInMillis = calStartTimeActivity.timeInMillis

                val calEnd = Calendar.getInstance()
                calEnd.timeInMillis = calStartTimeActivity.timeInMillis
                calEnd.add(Calendar.MINUTE, durationCount)

                googleFit.writePhysicalActivity(
                    activityType = selectedExerciseValue/*32*/,
                    calStart,
                    calEnd
                ) //golf

            }
        }
    }
}