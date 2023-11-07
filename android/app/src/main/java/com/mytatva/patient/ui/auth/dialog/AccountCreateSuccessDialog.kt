package com.mytatva.patient.ui.auth.dialog

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.AuthDialogAccountCreatedBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class AccountCreateSuccessDialog : BaseDialogFragment<AuthDialogAccountCreatedBinding>() {

    var onCreateProfile: () -> Unit = {}
    var onGoToHome: () -> Unit = {}


    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthDialogAccountCreatedBinding {
        return AuthDialogAccountCreatedBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() {
        setViewListener()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.RegisterSuccess)
    }

    private fun setViewListener() {
        binding.apply {
            buttonCreateProfile.setOnClickListener { onViewClick(it) }
            textViewGoToHome.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonCreateProfile -> {
                analytics.logEvent(analytics.USER_CONTINUE_PROFILE, screenName = AnalyticsScreenNames.RegisterSuccess)
                onCreateProfile.invoke()
                dismiss()
            }
            R.id.textViewGoToHome -> {
                analytics.logEvent(analytics.USER_SKIP_PROFILE, screenName = AnalyticsScreenNames.RegisterSuccess)
                onGoToHome.invoke()
                dismiss()
            }
        }
    }
}