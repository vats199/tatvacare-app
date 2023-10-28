package com.mytatva.patient.ui.auth.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.TempDataModel
import com.mytatva.patient.databinding.AuthBottomsheetDaysSelectionBinding
import com.mytatva.patient.databinding.AuthDialogAccountCreatedBinding
import com.mytatva.patient.databinding.AuthDialogProfileSetupBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.auth.adapter.SelectDaysAdapter
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.base.BaseDialogFragment

class AccountSetupProfileDialog(
    val onCreateProfile: () -> Unit
) : BaseDialogFragment<AuthDialogProfileSetupBinding>() {


    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthDialogProfileSetupBinding {
        return AuthDialogProfileSetupBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        setViewListener()
    }

    private fun setViewListener() {
        binding.apply {
            buttonCustomizeProfile.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonCustomizeProfile -> {
                onCreateProfile.invoke()
                dismiss()
            }
            R.id.imageViewClose -> {
                dismiss()
            }
        }
    }
}