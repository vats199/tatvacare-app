package com.mytatva.patient.ui.exercise.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.ExerciseDialogDescriptionInfoBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment

class ExerciseDescriptionInfoDialog(
    val title: String,
    val description: String,
) : BaseDialogFragment<ExerciseDialogDescriptionInfoBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ExerciseDialogDescriptionInfoBinding {
        return ExerciseDialogDescriptionInfoBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        setViewListener()

        with(binding) {
            textViewTitle.text = title
            /*textViewMessage.text = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                Html.fromHtml(description, Html.FROM_HTML_MODE_COMPACT)
            } else {
                Html.fromHtml(description)
            }*/
            webView.loadDataWithBaseURL(null,
                description,
                "text/html", //; charset=utf-8
                "UTF-8",
                null)
        }
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
                dismiss()
            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}