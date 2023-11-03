package com.mytatva.patient.ui.exercise

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import androidx.transition.AutoTransition
import androidx.transition.TransitionManager
import com.bumptech.glide.Glide
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.ExerciseFragmentPlanBreathingPlayerBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.dialog.ExerciseAreYouDoneDialog
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*
import java.util.concurrent.TimeUnit

class PlanBreathingPlayerFragment : BaseFragment<ExerciseFragmentPlanBreathingPlayerBinding>() {

    // Timer params
    var handler: Handler? = null
    var resumedTime = Calendar.getInstance().timeInMillis

    // Is the timer running?
    private var running = false
    private var wasRunning = false
    private var maxMinutes = 1
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
                    seconds--
                }

                // when max minutes achieved
                if (timerMinutes == /*maxMinutes*/ 0 && timerSecs == 0) {
                    finishTimer()
                } else {
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
            imageViewPlayPause.isSelected = true
            textViewPlayPause.text = getString(R.string.exercise_player_label_pause)
            toggleBreathingImage()
        }
    }

    private fun finishTimer() {
        with(binding) {
            imageViewPlayPause.isSelected = false
            textViewPlayPause.text = getString(R.string.exercise_player_label_play)
            toggleBreathingImage()

            //reset seconds on finish
            //seconds = 0

            // if wants to continue, then need to check on below logic
            //seconds--
            //handler?.postDelayed(runnable, 1000)
        }
    }

    private fun pauseTimer() {
        isPaused = true
        running = false
        with(binding) {
            imageViewPlayPause.isSelected = false
            textViewPlayPause.text = getString(R.string.exercise_player_label_play)
            toggleBreathingImage()
        }
    }

    private fun resumeTimer() {
        running = true
        with(binding) {
            imageViewPlayPause.isSelected = true
            textViewPlayPause.text = getString(R.string.exercise_player_label_pause)
            toggleBreathingImage()
        }
    }

    private val goalMasterId: String by lazy {
        arguments?.getString(Common.BundleKey.GOAL_MASTER_ID) ?: ""
    }
    val achievedValue: Int by lazy {
        arguments?.getInt(Common.BundleKey.TODAYS_ACHIEVED_VALUE) ?: 0
    }
    val goalValue: Int by lazy {
        arguments?.getInt(Common.BundleKey.GOAL_VALUE) ?: 0
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    val getCurrentSessionMinutes: Int
        get() {
            return maxMinutes - achievedValue - timerMinutes
        }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
        /*wasRunning = running;
        running = false;*/
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BreathingVideo)
        resumedTime = Calendar.getInstance().timeInMillis
        /*if (wasRunning) {
            running = true;
        }*/
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ExerciseFragmentPlanBreathingPlayerBinding {
        return ExerciseFragmentPlanBreathingPlayerBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onDestroy() {
        handler?.removeCallbacks(runnable)
        super.onDestroy()
    }

    override fun bindData() {
        maxMinutes = goalValue
        seconds = maxSecondsForProgress - (achievedValue * 60)

        setUpTimer()
        setUpToolbar()
        setViewListeners()

        Glide.with(requireActivity())
            .asGif()
            .load(R.drawable.breathing)
            .into(binding.imageViewBreathingAnimation)

        toggleBreathingImage()
    }

    private fun toggleBreathingImage() {
        TransitionManager.beginDelayedTransition(binding.root, AutoTransition().setDuration(100))
        if (binding.imageViewPlayPause.isSelected) {
            binding.imageViewBreathingAnimation.visibility = View.VISIBLE
            binding.imageViewBreathing.visibility = View.INVISIBLE

        } else {
            binding.imageViewBreathingAnimation.visibility = View.INVISIBLE
            binding.imageViewBreathing.visibility = View.VISIBLE
        }
    }

    private fun setUpTimer() {
        handler = Handler(Looper.getMainLooper())
        with(binding) {
            progressIndicator.max = maxSecondsForProgress
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = ""
            imageViewToolbarBack.visibility = View.VISIBLE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        with(binding) {
            imageViewPlayPause.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.imageViewPlayPause -> {
                if (binding.imageViewPlayPause.isSelected) {
                    pauseTimer()
                } else {
                    analytics.logEvent(analytics.USER_PLAYED_GIF_IN_EXERCISE,
                    screenName = AnalyticsScreenNames.BreathingVideo)
                    if (isPaused) {
                        resumeTimer()
                    } else {
                        startTimer()
                    }
                    /*if (seconds == 0) {
                        startTimer()
                    } else {
                        resumeTimer()
                    }*/
                }
            }
        }
    }

    override fun onBackActionPerform(): Boolean {
        showAreYouDoneDialog()
        return false
    }

    private fun showAreYouDoneDialog() {
        ExerciseAreYouDoneDialog {
            if (getCurrentSessionMinutes > 0) {
                updateGoalLogs()
            } else {
                requireActivity().finish()
            }
        }.show(requireActivity().supportFragmentManager,
            ExerciseAreYouDoneDialog::class.java.simpleName)
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateGoalLogs() {
        val apiRequest = ApiRequest().apply {
            goal_id = goalMasterId
            achieved_value = getCurrentSessionMinutes.toString()
            achieved_datetime = DateTimeFormatter.date(Calendar.getInstance().time)
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
                requireActivity().finish()
                /*analytics.logEvent(analytics.USER_UPDATED_ACTIVITY,
                    eventNamePostFix = goalReadingData?.goal_name)*/
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


    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_BREATHING_TIME, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.BreathingVideo)
    }
}