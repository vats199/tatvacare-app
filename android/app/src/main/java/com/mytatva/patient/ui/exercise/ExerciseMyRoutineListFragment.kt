package com.mytatva.patient.ui.exercise

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.DifficultyLevel
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.RoutinesData
import com.mytatva.patient.databinding.ExerciseFragmentMyRoutineListBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.activity.VideoPlayerActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.adapter.ExerciseMyRoutineListAdapter
import com.mytatva.patient.ui.exercise.dialog.ExerciseUpdateDifficultyDialog
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*

class ExerciseMyRoutineListFragment : BaseFragment<ExerciseFragmentMyRoutineListBinding>() {

    private lateinit var engageContentViewModel: EngageContentViewModel

    var routinesData: RoutinesData? = null
    var calSelectedDate: Calendar = Calendar.getInstance()
    private var calFitStartTime = Calendar.getInstance()
    private var calFitEndTime = Calendar.getInstance()

    private val exerciseList by lazy {
        routinesData?.exercise_details ?: arrayListOf()
    }
    private var currentClickPosition = -1
    private val exerciseMyRoutineListAdapter by lazy {
        ExerciseMyRoutineListAdapter(exerciseList,
            object : ExerciseMyRoutineListAdapter.AdapterListener {
                override fun onDoneClick(position: Int) {
                    currentClickPosition = position
                    exercisePlanMarkAsDone()
                }

                override fun onDifficultyClick(position: Int) {
                    currentClickPosition = position
                    showUpdateDifficultyDialog()
                }

                override fun onReadMoreClick(position: Int) {
                    currentClickPosition = position
                    val item = exerciseList[position]
                    navigator.loadActivity(
                        TransparentActivity::class.java,
                        ExerciseDescriptionInfoFragment::class.java
                    ).addBundle(Bundle().apply {
                        putString(Common.BundleKey.TITLE, item.title ?: "")
                        putString(Common.BundleKey.DESCRIPTION, item.description ?: "")
                    }).start()

                    analytics.logEvent(
                        analytics.USER_TAPS_ON_READ_MORE,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_CONTENT_MASTER_ID,
                                exerciseList[currentClickPosition].content_master_id
                            )
                            putString(
                                analytics.PARAM_EXERCISE_NAME,
                                exerciseList[currentClickPosition].title
                            )
                            putString(
                                analytics.PARAM_TYPE,
                                exerciseList[currentClickPosition].breathing_exercise
                            )
                            putString(
                                analytics.PARAM_CONTENT_TYPE,
                                exerciseList[currentClickPosition].content_type
                            )
                        }, screenName = AnalyticsScreenNames.ExerciseMyRoutine
                    )

                }

                override fun onPlayClick(position: Int) {
                    currentClickPosition = position
                    val item = exerciseList[position]

                    analytics.logEvent(analytics.USER_CLICKED_ON_PLAN_EXERCISE, Bundle().apply {
                        putString(
                            analytics.PARAM_CONTENT_MASTER_ID,
                            item.content_master_id
                        )
                        putString(
                            analytics.PARAM_EXERCISE_NAME,
                            item.title
                        )
                        putString(
                            analytics.PARAM_TYPE,
                            item.breathing_exercise
                        )
                        putString(
                            analytics.PARAM_CONTENT_TYPE,
                            item.content_type
                        )
                    }, screenName = AnalyticsScreenNames.ExerciseMyRoutine)

                    if (item.media?.media_url.isNullOrBlank().not()) {
                        navigator.loadActivity(VideoPlayerActivity::class.java)
                            .addBundle(
                                bundleOf(
                                    Pair(
                                        Common.BundleKey.CONTENT_ID,
                                        item.content_master_id
                                    ),
                                    Pair(Common.BundleKey.CONTENT_TYPE, item.content_type),
                                    Pair(Common.BundleKey.MEDIA_URL, item.media?.media_url),
                                    Pair(Common.BundleKey.IS_EXERCISE_VIDEO, true)
                                )
                            ).start()
                    }
                }
            })
    }

    private var currentUpdatedDifficultyLevel: DifficultyLevel? = null
    private fun showUpdateDifficultyDialog() {
        if (exerciseList.isNotEmpty()) {
            ExerciseUpdateDifficultyDialog().apply {
                routineExerciseData = exerciseList[currentClickPosition]
                callback = { difficultyLevel ->
                    currentUpdatedDifficultyLevel = difficultyLevel
                    exercisePlanUpdateDifficulty()
                }
            }.show(childFragmentManager, ExerciseUpdateDifficultyDialog::class.java.simpleName)
        }
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        engageContentViewModel =
            ViewModelProvider(this, viewModelFactory)[EngageContentViewModel::class.java]
        observeLiveData()
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ExerciseFragmentMyRoutineListBinding {
        return ExerciseFragmentMyRoutineListBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        with(binding) {
            recyclerViewRoutines.layoutManager =
                LinearLayoutManager(requireContext(), LinearLayoutManager.VERTICAL, false)
            recyclerViewRoutines.adapter = exerciseMyRoutineListAdapter
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {

        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun exercisePlanMarkAsDone() {
        analytics.logEvent(
            analytics.USER_MARKED_VIDEO_DONE_EXERCISE,
            Bundle().apply {
                putString(
                    analytics.PARAM_CONTENT_MASTER_ID,
                    exerciseList[currentClickPosition].content_master_id
                )
                putString(
                    analytics.PARAM_EXERCISE_NAME,
                    exerciseList[currentClickPosition].title
                )
                putString(
                    analytics.PARAM_TYPE,
                    exerciseList[currentClickPosition].breathing_exercise
                )
                putString(
                    analytics.PARAM_CONTENT_TYPE,
                    exerciseList[currentClickPosition].content_type
                )
                putString(
                    analytics.PARAM_FLAG,
                    if (exerciseList[currentClickPosition].done == "Y") "off" else "on"
                )
            }, screenName = AnalyticsScreenNames.ExerciseMyRoutine
        )

        val apiRequest = ApiRequest().apply {
            patient_exercise_plans_list_rel_id =
                exerciseList[currentClickPosition].patient_exercise_plans_list_rel_id
            done = if (exerciseList[currentClickPosition].done == "Y") "N" else "Y"
            reading_time = DateTimeFormatter.date(Calendar.getInstance().time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
        }
        val exerciseDurationMin = exerciseList[currentClickPosition].getTimeDuration
        if (apiRequest.done == "Y" && googleFit.hasAllPermissions && exerciseDurationMin > 0) {
            // when mark as done & google fit is connected, then pass start & end time in API
            // which to be stored in google fit, which will be be used to delete the entry from google fit,
            // if the user mark same as undone in future
            calFitStartTime = Calendar.getInstance()
            calFitStartTime.timeInMillis = calSelectedDate.timeInMillis
            calFitEndTime = Calendar.getInstance()
            calFitEndTime.timeInMillis = calSelectedDate.timeInMillis
            calFitEndTime.add(Calendar.MINUTE, exerciseDurationMin)

            apiRequest.fit_start_time = DateTimeFormatter.date(calFitStartTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
            apiRequest.fit_end_time = DateTimeFormatter.date(calFitEndTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
        }
        showLoader()
        engageContentViewModel.exercisePlanMarkAsDone(apiRequest)
    }

    private fun exercisePlanUpdateDifficulty() {
        val apiRequest = ApiRequest().apply {
            patient_exercise_plans_list_rel_id =
                exerciseList[currentClickPosition].patient_exercise_plans_list_rel_id
            difficulty = currentUpdatedDifficultyLevel?.title
        }
        showLoader()
        engageContentViewModel.exercisePlanUpdateDifficulty(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //exercisePlanMarkAsDoneLiveData
        engageContentViewModel.exercisePlanMarkAsDoneLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (currentClickPosition != -1 && exerciseList.isNotEmpty()) {
                    if (exerciseList[currentClickPosition].done == "Y") {
                        exerciseList[currentClickPosition].done = "N"
                        exerciseList[currentClickPosition].difficulty_level = null
                        exerciseMyRoutineListAdapter.notifyItemChanged(currentClickPosition)
                        deleteFromGoogleFitOnExerciseMarkUndone()
                    } else {
                        exerciseList[currentClickPosition].done = "Y"
                        writeToGoogleFitOnExerciseMarkDone()
                        // show difficulty dialog when mark as done
                        showUpdateDifficultyDialog()
                    }
                    exerciseMyRoutineListAdapter.notifyItemChanged(currentClickPosition)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //exercisePlanUpdateDifficultyLiveData
        engageContentViewModel.exercisePlanUpdateDifficultyLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (currentClickPosition != -1 && exerciseList.isNotEmpty()) {
                    exerciseList[currentClickPosition].difficulty_level =
                        currentUpdatedDifficultyLevel?.title
                    exerciseMyRoutineListAdapter.notifyItemChanged(currentClickPosition)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun writeToGoogleFitOnExerciseMarkDone() {
        if (googleFit.hasAllPermissions) {
            //Other (unclassified fitness activity) - 108 (Int value for other activity type)
            googleFit.writePhysicalActivity(activityType = 108, calFitStartTime, calFitEndTime)
        }
    }

    private fun deleteFromGoogleFitOnExerciseMarkUndone() {
        val firStartTime = exerciseList[currentClickPosition].fit_start_time
        val fitEndTime = exerciseList[currentClickPosition].fit_end_time

        /*val firStartTime = "2023-10-27 18:47:00"
        val fitEndTime = "2023-10-27 20:37:00"*/
        Log.d(
            "GoogleFit",
            "deleteFromGoogleFitOnExerciseMarkUndone: start time: $firStartTime, end time: $fitEndTime"
        )

        if (googleFit.hasAllPermissions && firStartTime.isNullOrBlank()
                .not() && fitEndTime.isNullOrBlank().not()
        ) {

            try {
                val calStart = Calendar.getInstance()
                calStart.timeInMillis = DateTimeFormatter.date(
                    firStartTime,
                    DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                ).date!!.time

                val calEnd = Calendar.getInstance()
                calEnd.timeInMillis = DateTimeFormatter.date(
                    fitEndTime,
                    DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                ).date!!.time

                googleFit.deletePhysicalActivity(calStart, calEnd)
                Log.d(
                    "GoogleFit",
                    "deleteFromGoogleFitOnExerciseMarkUndone: cal start time: ${calStart.time}, cal end time: ${calEnd.time}"
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }
}