package com.mytatva.patient.ui.exercise

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.databinding.ExerciseDialogDescriptionInfoBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment

class ExerciseDescriptionInfoFragment : BaseFragment<ExerciseDialogDescriptionInfoBinding>() {

    val title: String by lazy {
        arguments?.getString(Common.BundleKey.TITLE) ?: ""
    }

    val description: String by lazy {
        arguments?.getString(Common.BundleKey.DESCRIPTION) ?: ""
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
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
                navigator.goBack()
            }
            R.id.imageViewClose -> {
                navigator.goBack()
            }
        }
    }
}