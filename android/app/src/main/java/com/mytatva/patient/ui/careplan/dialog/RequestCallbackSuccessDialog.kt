package com.mytatva.patient.ui.careplan.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.CarePlanDialogRequestCallbackSuccessBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment

class RequestCallbackSuccessDialog(val callback: () -> Unit) :
    BaseDialogFragment<CarePlanDialogRequestCallbackSuccessBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanDialogRequestCallbackSuccessBinding {
        return CarePlanDialogRequestCallbackSuccessBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun bindData() {
        setViewListener()
    }

    private fun setViewListener() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonBackToCarePlan.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonBackToCarePlan -> {
                callback.invoke()
                dismiss()
            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}