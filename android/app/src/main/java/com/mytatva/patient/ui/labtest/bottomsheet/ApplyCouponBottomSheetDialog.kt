package com.mytatva.patient.ui.labtest.bottomsheet

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.databinding.LabtestBottomsheetApplyCouponBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment

class ApplyCouponBottomSheetDialog(
    val callback: () -> Unit,
) : BaseBottomSheetDialogFragment<LabtestBottomsheetApplyCouponBinding>() {

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestBottomsheetApplyCouponBinding {
        return LabtestBottomsheetApplyCouponBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
        }
        setViewListener()
    }


    private fun setViewListener() {
        binding.apply {
            textViewCancel.setOnClickListener { onViewClick(it) }
            buttonApply.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewCancel -> {
                dismiss()
            }
            R.id.buttonApply -> {
                if (binding.editTextCouponCode.toString().trim().isBlank()) {
                    showMessage("Please enter coupon code")
                } else {
                    callback.invoke()
                    dismiss()
                }
            }
        }
    }
}