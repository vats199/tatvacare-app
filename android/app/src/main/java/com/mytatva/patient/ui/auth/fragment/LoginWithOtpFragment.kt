package com.mytatva.patient.ui.auth.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthFragmentLoginWithOtpBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class LoginWithOtpFragment : BaseFragment<AuthFragmentLoginWithOtpBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextMobileNumber)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_mobile_number))
                        .checkMinDigits(10)
                        .errorMessage(getString(R.string.common_validation_invalid_mobile_number))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentLoginWithOtpBinding {
        return AuthFragmentLoginWithOtpBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LoginWithPhone)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        analytics.logEvent(
            analytics.LOGIN_ATTEMPT,
            screenName = AnalyticsScreenNames.LoginWithPhone
        )
        setViewListeners()
    }

    private fun setViewListeners() {
        binding.apply {
            buttonNext.setOnClickListener { onViewClick(it) }
            buttonLoginWithPassword.setOnClickListener { onViewClick(it) }
            textViewSignUp.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonNext -> {
                if (isValid) {
                    loginSendOtp()
                }
            }

            R.id.buttonLoginWithPassword -> {
                navigator.load(LoginWithPasswordFragment::class.java).replace(true)
            }

            R.id.textViewSignUp -> {
                navigator.loadActivity(
                    AuthActivity::class.java,/*SelectLanguageFragment::class.java*/
                    SignUpPhoneFragment::class.java
                )
                    .start()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun loginSendOtp() {
        val apiRequest = ApiRequest().apply {
            contact_no = binding.editTextMobileNumber.text.toString().trim()
        }
        showLoader()
        authViewModel.loginSendOtp(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.loginSendOtpLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(
                    analytics.LOGIN_SMS_SENT,
                    screenName = AnalyticsScreenNames.LoginWithPhone
                )
                navigator.load(LoginOtpVerificationFragment::class.java).setBundle(
                    bundleOf(
                        Pair(Common.BundleKey.PHONE, binding.editTextMobileNumber.text.toString())
                    )
                ).replace(true)
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}