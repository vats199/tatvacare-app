package com.mytatva.patient.ui.exercise.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.ExerciseDialogAreYouDoneBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment

class ExerciseAreYouDoneDialog(
    val callback: () -> Unit,
) : BaseDialogFragment<ExerciseDialogAreYouDoneBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ExerciseDialogAreYouDoneBinding {
        return ExerciseDialogAreYouDoneBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        setViewListener()
    }

    private fun setViewListener() {
        binding.apply {
            buttonDone.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonDone -> {
                callback.invoke()
                dismiss()
            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}