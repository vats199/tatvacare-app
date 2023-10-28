package com.mytatva.patient.ui.reading.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.transition.AutoTransition
import androidx.transition.TransitionManager
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.ReadingFragmentUpdateReadingWalkTestBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.ReadingMinMax.MAX_6MINWALK
import com.mytatva.patient.ui.reading.ReadingMinMax.MIN_6MINWALK
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.disableFocus
import com.mytatva.patient.utils.enableFocus
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*
import kotlin.math.roundToInt

class UpdateReadingWalkTestFragment :
    BaseFragment<ReadingFragmentUpdateReadingWalkTestBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    /*
     * Timer Params
     */
    // Timer params
    var handler: Handler? = null
    var resumedTime = Calendar.getInstance().timeInMillis

    // Is the timer running?
    private var running = false
    private var wasRunning = false
    private var maxMinutes = 6 // for 6 minute walk, start from 6 then decreasing order
    private val maxSecondsForProgress: Int
        get() = maxMinutes * 60

    /*var seconds: Int = 0*/
    var seconds: Int = maxMinutes * 60
    var isPaused = false
    var timerHours: Int = seconds / 3600
    var timerMinutes: Int = seconds % 3600 / 60
    var timerSecs: Int = seconds % 60

    private val runnable = object : Runnable {
        override fun run() {
            timerHours = seconds / 3600
            timerMinutes = seconds % 3600 / 60
            timerSecs = seconds % 60

            // Format the seconds into hours, minutes,
            // and seconds.
            val time = if (timerHours > 0) java.lang.String
                .format(Locale.getDefault(),
                    "%d:%02d:%02d", timerHours,
                    timerMinutes, timerSecs)
            else java.lang.String
                .format(Locale.getDefault(),
                    "%02d:%02d",
                    timerMinutes, timerSecs)

            if (isAdded) {
                // If running is true, increment the seconds variable.
                if (running) {
                    // Set the text view text.
                    if (seconds < 0) {
                        binding.textViewTime.text = "00:00"
                    } else {
                        binding.textViewTime.text = time
                    }
                    val progress = /*seconds.toFloat()*/ maxSecondsForProgress - seconds
                    binding.progressIndicator.setProgress(progress.toFloat(), true, 1000)

                    /*seconds++*/

                }

                // when max minutes achieved
                if (timerMinutes == /*maxMinutes*/ 0 && timerSecs == 0) {
                    finishTimer()
                } else {
                    seconds--
                    // Post the code again with a delay of 1 second.
                    handler?.postDelayed(this, 1000)
                }
            }
        }
    }

    private fun startTimer() {
        running = true
        handler?.post(runnable)

        with(binding) {
            /*imageViewPlayPause.isSelected = true
            textViewPlayPause.text = "Pause"
            toggleBreathingImage()*/
        }
    }

    private fun finishTimer() {
        running = false
        with(binding) {
            /*imageViewPlayPause.isSelected = false
            textViewPlayPause.text = "Play"
            toggleBreathingImage()*/
        }
        handleOnStopWalkTimer()
    }

    private fun pauseTimer() {
        isPaused = true
        running = false
        with(binding) {
            /*imageViewPlayPause.isSelected = false
            textViewPlayPause.text = "Play"
            toggleBreathingImage()*/
        }
    }

    private fun resumeTimer() {
        running = true
        with(binding) {
            /*imageViewPlayPause.isSelected = true
            textViewPlayPause.text = "Pause"
            toggleBreathingImage()*/
        }
    }

    private fun setUpTimer() {
        handler = Handler(Looper.getMainLooper())
        with(binding) {
            progressIndicator.max = maxSecondsForProgress
        }
    }
    /*
     * *************************************************
     */

    val getTimerDurationSeconds: Int
        get() {
            return maxSecondsForProgress - seconds
        }

    var goalReadingData: GoalReadingData? = null
    //var calStartDateTime: Calendar = Calendar.getInstance()

    var calWalkTimerStartTime: Calendar = Calendar.getInstance()
    var calWalkTimerEndTime: Calendar = Calendar.getInstance()



    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextDate)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_date))
                        .check()

                    validator.submit(editTextTime)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_time))
                        .check()

                    if (layoutSubmit.visibility == View.VISIBLE) {
                        validator.submit(editTextDistance)
                            .checkEmpty()
                            .errorMessage(getString(R.string.validation_enter_distance))
                            .check()

                        if (binding.editTextDistance.text.toString().trim()
                                .toIntOrNull() ?: 0 <= 0
                        ) {
                            throw ApplicationException(getString(R.string.validation_enter_distance))
                        }

                        val distance =
                            binding.editTextDistance.text.toString().trim().toIntOrNull() ?: 0
                        if (distance < MIN_6MINWALK || distance > MAX_6MINWALK) {
                            throw ApplicationException("Please enter value in the range of $MIN_6MINWALK - $MAX_6MINWALK")
                        }
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

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
    ): ReadingFragmentUpdateReadingWalkTestBinding {
        return ReadingFragmentUpdateReadingWalkTestBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onDestroy() {
        handler?.removeCallbacks(runnable)
        super.onDestroy()
    }

    override fun onResume() {
        super.onResume()
        setUpHeader()
        analytics.setScreenName(AnalyticsScreenNames.LogReading.plus(goalReadingData?.keys))
    }

    override fun bindData() {
        setViewListeners()
        setDefaultValues()
    }

    private fun setDefaultValues() {
        updateDate()
        updateTime()

        //binding.editTextDistance.setText(goalReadingData?.measurements ?: "")
        binding.textViewUnit.setText(goalReadingData?.measurements ?: "")
    }

    private fun updateDate() {
        binding.editTextDate.setText(try {
            DateTimeFormatter.date(calWalkTimerStartTime.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
        } catch (e: Exception) {
            ""
        })
    }

    private fun updateTime() {
        binding.editTextTime.setText(try {
            DateTimeFormatter.date(calWalkTimerStartTime.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
        } catch (e: Exception) {
            ""
        })
    }

    private fun setUpHeader() {
        goalReadingData?.let {
            UpdateReadingsMainFragment.setUpHeaderAndCommonUI(it, binding.layoutHeader,binding.textViewStandardValue)
        }

        UpdateReadingsMainFragment.setUpSyncDataLayout(binding.layoutSyncData,
            googleFit.hasAllPermissions,
            googleFit,
            (requireActivity() as BaseActivity))

        with(binding) {
            if (googleFit.hasAllPermissions) {
                textViewLabelInfo.text = "We would be using the above device for measuring distance"

                //if fit connected then update current date time and disable click
                calWalkTimerStartTime = Calendar.getInstance()
                updateDate()
                updateTime()
                editTextDate.disableFocus()
                editTextTime.disableFocus()

            } else {
                editTextDate.enableFocus()
                editTextTime.enableFocus()

                textViewLabelInfo.text =
                    "Since no device is connected, distance will have to be entered manually"
            }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            editTextDate.setOnClickListener { onViewClick(it) }
            editTextTime.setOnClickListener { onViewClick(it) }
            buttonStart.setOnClickListener { onViewClick(it) }
            buttonStop.setOnClickListener { onViewClick(it) }
            buttonSubmit.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewClose -> {
                callbackOnClose.invoke(false)
            }
            R.id.editTextDate -> {
                /*navigator.pickDate({ _, year, month, dayOfMonth ->
                    calStartDateTime.set(year, month, dayOfMonth)
                    updateDate()
                }, 0L, Calendar.getInstance().timeInMillis)*/
            }
            R.id.editTextTime -> {
                /*navigator.pickTime({ _, hourOfDay, minute ->

                     val calTemp = Calendar.getInstance()
                     calTemp.timeInMillis = calStartDateTime.timeInMillis
                     calTemp.set(Calendar.HOUR_OF_DAY, hourOfDay)
                     calTemp.set(Calendar.MINUTE, minute)
                     calTemp.set(Calendar.SECOND, 0)

                     if (Calendar.getInstance().before(calTemp)) {
                         showMessage("Please select valid time")
                     } else {
                         calStartDateTime.set(Calendar.HOUR_OF_DAY, hourOfDay)
                         calStartDateTime.set(Calendar.MINUTE, minute)
                         calStartDateTime.set(Calendar.SECOND, 0)
                         updateTime()
                     }

                 }, false)*/
            }
            R.id.buttonStart -> {
                with(binding) {
                    TransitionManager.beginDelayedTransition(root,
                        AutoTransition().setDuration(150))
                    layoutStart.visibility = View.GONE

                    layoutTimer.visibility = View.VISIBLE
                    setUpTimer()
                    startTimer()

                    //set timer start time
                    calWalkTimerStartTime = Calendar.getInstance()
                    updateTime()

                    /*if (googleFit.hasAllPermissions) {
                        layoutTimer.visibility = View.VISIBLE
                        setUpTimer()
                        startTimer()

                        //set timer start time
                        calWalkTimerStartTime = Calendar.getInstance()
                    } else {
                        layoutSubmit.visibility = View.VISIBLE
                    }*/

                }
            }
            R.id.buttonStop -> {
                //handleOnStopWalkTimer()
                finishTimer()
            }
            R.id.buttonSubmit -> {
                //callbackOnClose.invoke(false)
                if (isValid) {
                    updatePatientReadings()
                }
            }
        }
    }

    private fun handleOnStopWalkTimer() {
        with(binding) {
            TransitionManager.beginDelayedTransition(root,
                AutoTransition().setDuration(150))
            layoutTimer.visibility = View.GONE
            layoutSubmit.visibility = View.VISIBLE

            //set timer end time
            calWalkTimerEndTime = Calendar.getInstance()

            //showMessage(getTimerDurationSeconds.toString())

            if (googleFit.hasAllPermissions) {

                showLoader()
                googleFit.getWalkDistanceRecords(calWalkTimerStartTime.timeInMillis,
                    calWalkTimerEndTime.timeInMillis) { distance ->
                    hideLoader()

                    editTextDistance.setText(distance.roundToInt().toString())

                    if (distance > 0) {
                        /*editTextDistance.setTextColor(requireContext().resources.getColor(R.color.gray4,
                            null))
                        editTextDistance.setBackgroundResource(R.drawable.bg_textview_solid_lightgray_stroke_gray)*/
                        editTextDistance.disableFocus()
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
    private fun updatePatientReadings() {
        val apiRequest = ApiRequest().apply {
            reading_id = goalReadingData?.readings_master_id
            reading_datetime = DateTimeFormatter.date(calWalkTimerStartTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
            reading_value = binding.editTextDistance.text.toString().trim()
            duration = getTimerDurationSeconds.toString()
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
        goalReadingViewModel.updatePatientReadingsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"updatedGoalReadingSuccess","") }

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
        /*if (googleFit.hasAllPermissions) {
            val bpDiastolic =
                binding.editTextDiastolic.text.toString().trim().toFloatOrNull() ?: 0f
            val bpSystolic = binding.editTextSystolic.text.toString().trim().toFloatOrNull() ?: 0f
            if (bpDiastolic > 0 && bpSystolic > 0) {
                googleFit.writeBloodPressure(bpDiastolic, bpSystolic, calDateTime)
            }
        }*/
    }
}