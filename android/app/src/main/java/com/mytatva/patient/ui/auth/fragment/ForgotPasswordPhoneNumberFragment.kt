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
import com.mytatva.patient.databinding.AuthFragmentForgotPasswordPhoneNumberBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class ForgotPasswordPhoneNumberFragment :
    BaseFragment<AuthFragmentForgotPasswordPhoneNumberBinding>() {
    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextMobileNumber)
                        .checkEmpty().errorMessage(getString(R.string.common_validation_empty_mobile_number))
                        .checkMinDigits(10).errorMessage(getString(R.string.common_validation_invalid_mobile_number))
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
    ): AuthFragmentForgotPasswordPhoneNumberBinding {
        return AuthFragmentForgotPasswordPhoneNumberBinding.inflate(
            inflater,
            container,
            attachToRoot
        )
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ForgotPasswordPhone)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        analytics.logEvent(analytics.FORGOT_PASSWORD_ATTEMPT, screenName = AnalyticsScreenNames.ForgotPasswordPhone)
        setViewListeners()
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewBack.setOnClickListener { onViewClick(it) }
            buttonNext.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewBack -> {
                navigator.goBack()
            }
            R.id.buttonNext -> {
                if (isValid) {
                    forgotPasswordSendOtp()
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun forgotPasswordSendOtp() {
        val apiRequest = ApiRequest().apply {
            contact_no = binding.editTextMobileNumber.text.toString().trim()
        }
        showLoader()
        authViewModel.forgotPasswordSendOtp(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.forgotPasswordSendOtpLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                navigator.load(ForgotPasswordFragment::class.java).setBundle(
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