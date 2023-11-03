package com.mytatva.patient.ui.payment.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.PaymentDialogCancelAlertBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment

class CancelPlanAlertDialog(
    val callback: () -> Unit,
) : BaseDialogFragment<PaymentDialogCancelAlertBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentDialogCancelAlertBinding {
        return PaymentDialogCancelAlertBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        setViewListener()
    }

    private fun setViewListener() {
        binding.apply {
            buttonYes.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
            textViewNo.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonYes -> {
                callback.invoke()
                dismiss()
            }
            R.id.imageViewClose -> {
                dismiss()
            }
            R.id.textViewNo -> {
                dismiss()
            }
        }
    }
}