package com.mytatva.patient.ui.home.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.HomeDialogCorrectAnswerResultBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment

class CorrectAnswerResultDialog : BaseDialogFragment<HomeDialogCorrectAnswerResultBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): HomeDialogCorrectAnswerResultBinding {
        return HomeDialogCorrectAnswerResultBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        setViewListener()
    }

    private fun setViewListener() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}