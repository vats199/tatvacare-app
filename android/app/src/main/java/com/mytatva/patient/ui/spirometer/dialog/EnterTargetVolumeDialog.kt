package com.mytatva.patient.ui.spirometer.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.core.Session
import com.mytatva.patient.databinding.SpirometerDialogEnterTargetVolumeBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import javax.inject.Inject

class EnterTargetVolumeDialog : BaseDialogFragment<SpirometerDialogEnterTargetVolumeBinding>() {

    private var callbackSetVolume: (volume: Int) -> Unit = {}
    fun setCallback(callbackSetVolume: (volume: Int) -> Unit): EnterTargetVolumeDialog {
        this.callbackSetVolume = callbackSetVolume
        return this
    }

    @Inject
    lateinit var session: Session

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextVolume)
                        .checkEmpty()
                        .errorMessage("Please enter volume")
                        .check()

                    val volume = editTextVolume.text.toString().trim().toIntOrNull() ?: 0
                    if (volume > 5000) {
                        throw ApplicationException("Please enter volume up to 5000")
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): SpirometerDialogEnterTargetVolumeBinding {
        return SpirometerDialogEnterTargetVolumeBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.FaqQuery)
    }

    override fun bindData() {
        setDefaultTargetVolume()
        setViewListener()
    }

    private fun setDefaultTargetVolume() {
        if (session.user?.spirometer_target_vol.isNullOrBlank().not()) {
            binding.editTextVolume.setText(session.user?.spirometer_target_vol)
        } else {
            binding.editTextVolume.setText("1000")
        }
        binding.editTextVolume.setSelection(binding.editTextVolume.text.toString().trim().length)
    }

    private fun setViewListener() {
        binding.apply {
            buttonCancel.setOnClickListener { onViewClick(it) }
            buttonSet.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonCancel -> {
                dismiss()
            }

            R.id.buttonSet -> {
                if (isValid) {
                    callbackSetVolume.invoke(
                        binding.editTextVolume.text.toString().trim().toIntOrNull() ?: 0
                    )
                    dismiss()
                }
            }

            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }

}