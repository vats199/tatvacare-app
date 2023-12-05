package com.mytatva.patient.ui.spirometer.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.SpirometerBottomsheetTestTypeBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class TestTypeBottomSheetDialog :
    BaseBottomSheetDialogFragment<SpirometerBottomsheetTestTypeBinding>() {

    private var callback: (isIncentive: Boolean) -> Unit = {}

    fun setCallback(callback: (isIncentive: Boolean) -> Unit): TestTypeBottomSheetDialog {
        this.callback = callback
        return this
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): SpirometerBottomsheetTestTypeBinding {
        return SpirometerBottomsheetTestTypeBinding.inflate(layoutInflater)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SelectTestType)
    }

    override fun bindData() {
        setUpViewListeners()
    }

    private fun setUpViewListeners() {
        with(binding) {
            textViewStandard.setOnClickListener { onViewClick(it) }
            textViewIncentive.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewStandard -> {
                callback.invoke(false)
                dismiss()
            }

            R.id.textViewIncentive -> {
                callback.invoke(true)
                dismiss()
            }
        }
    }
}