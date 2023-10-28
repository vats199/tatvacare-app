package com.mytatva.patient.ui.home.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.data.model.CoachMarkPage
import com.mytatva.patient.databinding.HomeDialogStartCoachmarkBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.ui.home.HomeActivity

class StartCoachMarkDialog(val callback: (isSkip: Boolean) -> Unit) :
    BaseDialogFragment<HomeDialogStartCoachmarkBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): HomeDialogStartCoachmarkBinding {
        return HomeDialogStartCoachmarkBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun bindData() {
        with(binding) {
            textViewTitle.text = HomeActivity.getCoachMarkDesc(CoachMarkPage.WELCOME.pageKey)
        }
        setViewListener()
    }

    private fun setViewListener() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonBeginTour.setOnClickListener { onViewClick(it) }
            textViewSkip.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewClose -> {
                callback.invoke(true)
                dismiss()
            }
            R.id.buttonBeginTour -> {
                callback.invoke(false)
                dismiss()
            }
            R.id.textViewSkip -> {
                callback.invoke(true)
                dismiss()
            }
        }
    }
}