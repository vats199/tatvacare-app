package com.mytatva.patient.ui.menu.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.MenuDialogThankyouMessageBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment

class ThankYouMessageDialog : BaseDialogFragment<MenuDialogThankyouMessageBinding>() {

    var message: String? = null

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): MenuDialogThankyouMessageBinding {
        return MenuDialogThankyouMessageBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
    }

    override fun bindData() {
        setViewListener()
        message?.let {
            binding.textViewLabelSuccess.text = it
        }
    }

    private fun setViewListener() {
        binding.apply {
            buttonContinue.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonContinue -> {
                dismiss()
            }

            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }

}