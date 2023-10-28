package com.mytatva.patient.ui.exercise

import android.os.Bundle
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
import com.mytatva.patient.utils.apputils.PlanFeatureHandler
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import java.util.*

class ExerciseMyRoutineListFragment : BaseFragment<ExerciseFragmentMyRoutineListBinding>() {

    private lateinit var engageContentViewModel: EngageContentViewModel

    var routinesData: RoutinesData? = null
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
                    navigator.loadActivity(TransparentActivity::class.java,
                        ExerciseDescriptionInfoFragment::class.java).addBundle(Bundle().apply {
                        putString(Common.BundleKey.TITLE, item.title ?: "")
                        putString(Common.BundleKey.DESCRIPTION, item.description ?: "")
                    }).start()

                    analytics.logEvent(analytics.USER_TAPS_ON_READ_MORE,
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
                        }
                        , screenName = AnalyticsScreenNames.ExerciseMyRoutine)

                }

                override fun onPlayClick(position: Int) {
                    currentClickPosition = position
                    val item = exerciseList[position]

                    analytics.logEvent(analytics.USER_CLICKED_ON_PLAN_EXERCISE, Bundle().apply {
                        putString(analytics.PARAM_CONTENT_MASTER_ID,
                            item.content_master_id)
                        putString(analytics.PARAM_EXERCISE_NAME,
                            item.title)
                        putString(analytics.PARAM_TYPE,
                            item.breathing_exercise)
                        putString(analytics.PARAM_CONTENT_TYPE,
                            item.content_type)
                    }, screenName = AnalyticsScreenNames.ExerciseMyRoutine)

                    if (item.media?.media_url.isNullOrBlank().not()) {
                        navigator.loadActivity(VideoPlayerActivity::class.java)
                            .addBundle(bundleOf(Pair(Common.BundleKey.CONTENT_ID,
                                item.content_master_id),
                                Pair(Common.BundleKey.CONTENT_TYPE, item.content_type),
                                Pair(Common.BundleKey.MEDIA_URL, item.media?.media_url),
                                Pair(Common.BundleKey.IS_EXERCISE_VIDEO, true))).start()
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
        analytics.logEvent(analytics.USER_MARKED_VIDEO_DONE_EXERCISE,
            Bundle().apply {
                putString(analytics.PARAM_CONTENT_MASTER_ID,
                    exerciseList[currentClickPosition].content_master_id)
                putString(analytics.PARAM_EXERCISE_NAME,
                    exerciseList[currentClickPosition].title)
                putString(analytics.PARAM_TYPE,
                    exerciseList[currentClickPosition].breathing_exercise)
                putString(analytics.PARAM_CONTENT_TYPE,
                    exerciseList[currentClickPosition].content_type)
                putString(analytics.PARAM_FLAG,
                    if (exerciseList[currentClickPosition].done == "Y") "off" else "on")
            }, screenName = AnalyticsScreenNames.ExerciseMyRoutine)

        val apiRequest = ApiRequest().apply {
            patient_exercise_plans_list_rel_id =
                exerciseList[currentClickPosition].patient_exercise_plans_list_rel_id
            done = if (exerciseList[currentClickPosition].done == "Y") "N" else "Y"
            reading_time = DateTimeFormatter.date(Calendar.getInstance().time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
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
                    } else {
                        exerciseList[currentClickPosition].done = "Y"
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
}