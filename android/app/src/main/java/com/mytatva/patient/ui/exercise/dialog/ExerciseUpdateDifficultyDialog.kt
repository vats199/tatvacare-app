package com.mytatva.patient.ui.exercise.dialog

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.data.model.DifficultyLevel
import com.mytatva.patient.data.pojo.response.RoutineExerciseData
import com.mytatva.patient.databinding.ExerciseDialogUpdateDifficultyBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class ExerciseUpdateDifficultyDialog : BaseDialogFragment<ExerciseDialogUpdateDifficultyBinding>() {

    var routineExerciseData: RoutineExerciseData?=null
    var callback: (difficultyLevel: DifficultyLevel) -> Unit = {}

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ExerciseDialogUpdateDifficultyBinding {
        return ExerciseDialogUpdateDifficultyBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        setViewListener()

        with(binding) {
            textViewTitle.text = routineExerciseData?.title
        }
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ExerciseFeedback)
    }

    private fun setViewListener() {
        binding.apply {
            buttonOkay.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonOkay -> {
                analytics.logEvent(analytics.USER_SUBMIT_FEEDBACK,
                    Bundle().apply {
                        putString(
                            analytics.PARAM_CONTENT_MASTER_ID,
                            routineExerciseData?.content_master_id
                        )
                        putString(
                            analytics.PARAM_EXERCISE_NAME,
                            routineExerciseData?.title
                        )
                        putString(
                            analytics.PARAM_TYPE,
                            routineExerciseData?.breathing_exercise
                        )
                        putString(
                            analytics.PARAM_CONTENT_TYPE,
                            routineExerciseData?.content_type
                        )
                        putString(analytics.PARAM_VALUE,
                            if (binding.radioDifficult.isChecked) DifficultyLevel.Difficult.title else DifficultyLevel.Easy.title)
                    }
                    , screenName = AnalyticsScreenNames.ExerciseFeedback)

                callback.invoke(if (binding.radioDifficult.isChecked) DifficultyLevel.Difficult else DifficultyLevel.Easy)
                dismiss()
            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}