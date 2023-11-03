package com.mytatva.patient.ui.home.dialog

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.HomeDialogReadingInfoBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.utils.imagepicker.loadUrlIcon
import com.mytatva.patient.utils.parseAsColor

class ReadingInfoDialog(val goalReadingData: GoalReadingData?, val callback: () -> Unit) :
    BaseDialogFragment<HomeDialogReadingInfoBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun onResume() {
        super.onResume()
        dialog?.setCancelable(true)
        dialog?.setCanceledOnTouchOutside(true)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): HomeDialogReadingInfoBinding {
        return HomeDialogReadingInfoBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun bindData() {
        /*val animation = AnimationUtils.loadAnimation(requireContext(), R.anim.bounce)
        binding.rootBg.startAnimation(animation)*/
        goalReadingData?.let {
            with(binding) {
                imageViewIcon.backgroundTintList = ColorStateList.valueOf(it.background_color.parseAsColor())
                imageViewIcon.loadUrlIcon(it.image_url ?: "",false)
                imageViewIcon.imageTintList = ColorStateList.valueOf(it.color_code.parseAsColor())
                textViewTitle.text = it.reading_name
                textViewInfo.text = it.information
                buttonLog.text = "Log ${it.reading_name}"
            }
        }
        setViewListener()
    }

    private fun setViewListener() {
        binding.apply {
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonLog.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonLog -> {
                callback.invoke()
                dismiss()
            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}