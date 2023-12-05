package com.mytatva.patient.ui.auth.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthFragmentLoginWithPasswordBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.textdecorator.TextDecorator

class LoginWithPasswordFragment : BaseFragment<AuthFragmentLoginWithPasswordBinding>() {

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

                    validator.submit(editTextPassword)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_password))
                        /*.checkMinDigits(8)
                        .errorMessage("Please enter password more then 8 characters")
                        .matchPatter("^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d)[a-zA-Z\\d|#@$!%*?&.]{6,}$")
                        .errorMessage("Please enter password with with at least one uppercase letter, one lowercase letter, one number and one special character")*/
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
    ): AuthFragmentLoginWithPasswordBinding {
        return AuthFragmentLoginWithPasswordBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LoginWithPassword)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        analytics.logEvent(
            analytics.LOGIN_PASSWORD_ATTEMPT,
            screenName = AnalyticsScreenNames.LoginWithPassword
        )
        setViewListeners()
        setUpUI()
    }

    private fun setUpUI() {
        TextDecorator.decorate(binding.checkBoxAgreeTerms, "I agree to the terms and conditions")
            .underline("Terms & Conditions")
            .makeTextClickableWithSecondaryColor(
                requireContext().getColor(R.color.colorPrimary), View.OnClickListener {
                    binding.checkBoxAgreeTerms.isChecked = !binding.checkBoxAgreeTerms.isChecked
                }, false, "terms and conditions"
            ).build()
    }

    private fun setViewListeners() {
        binding.apply {
            buttonSubmit.setOnClickListener { onViewClick(it) }
            textViewForgotPassword.setOnClickListener { onViewClick(it) }
            textViewSignUp.setOnClickListener { onViewClick(it) }
            textViewLoginWithOTP.setOnClickListener { onViewClick(it) }

            /*binding.checkBoxAgreeTerms.setOnCheckedChangeListener { buttonView, isChecked ->
                binding.buttonSubmit.isEnabled=isChecked
            }*/
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSubmit -> {
                if (isValid) {
                    callLogin()
                }
            }

            R.id.textViewForgotPassword -> {
                navigator.loadActivity(
                    AuthActivity::class.java,
                    ForgotPasswordPhoneNumberFragment::class.java
                ).start()
            }

            R.id.textViewSignUp -> {
                navigator.loadActivity(AuthActivity::class.java, SignUpPhoneFragment::class.java)
                    .start()
                /*navigator.loadActivity(AuthActivity::class.java, SelectLanguageFragment::class.java)
                    .start()*/
            }

            R.id.textViewLoginWithOTP -> {
                navigator.goBack()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun callLogin() {
        val apiRequest = ApiRequest().apply {
            contact_no = binding.editTextMobileNumber.text.toString().trim()
            password = binding.editTextPassword.text.toString().trim()
        }
        showLoader()
        authViewModel.login(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.loginLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(
                    analytics.LOGIN_PASSWORD_SUCCESS,
                    screenName = AnalyticsScreenNames.LoginWithPassword
                )
                openHome(screenName = AnalyticsScreenNames.LoginWithPassword)
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException && throwable.code == 0) {
                    analytics.logEvent(analytics.LOGIN_PASSWORD_INCORRECT, Bundle().apply {
                        putString(
                            analytics.PARAM_PHONE_NO,
                            binding.editTextMobileNumber.text.toString()
                        )
                    }, screenName = AnalyticsScreenNames.LoginWithPassword)
                }
                true
            })
    }
}