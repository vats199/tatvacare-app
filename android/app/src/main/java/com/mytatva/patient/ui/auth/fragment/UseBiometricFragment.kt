package com.mytatva.patient.ui.auth.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.AuthFragmentUseBiometricBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.auth.dialog.AccountCreateSuccessDialog
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class UseBiometricFragment : BaseFragment<AuthFragmentUseBiometricBinding>() {

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentUseBiometricBinding {
        return AuthFragmentUseBiometricBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.UseBiometric)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setViewListeners()
    }

    private fun setViewListeners() {
        binding.apply {
            buttonEnable.setOnClickListener { onViewClick(it) }
            textViewSkipForNow.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonEnable -> {
                appPreferences.setBiometricEnabled(true)
                handleNavigation()
            }

            R.id.textViewSkipForNow -> {
                handleNavigation()
            }
        }
    }

    private fun handleNavigation() {
        activity?.supportFragmentManager?.let {
            AccountCreateSuccessDialog().apply {
                onCreateProfile = {
                    openHome()
                    navigator.loadActivity(
                        AuthActivity::class.java,
                        SelectYourLocationFragment::class.java
                    ).start()
                }
                onGoToHome = {
                    openHome()
                }
            }.show(it, AccountCreateSuccessDialog::class.java.simpleName)
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {

    }
}