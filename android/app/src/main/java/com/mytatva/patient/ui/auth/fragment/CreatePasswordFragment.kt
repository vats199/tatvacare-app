package com.mytatva.patient.ui.auth.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthFragmentCreatePasswordBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class CreatePasswordFragment : BaseFragment<AuthFragmentCreatePasswordBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextPassword)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_password))
                        .checkMinDigits(8)
                        .errorMessage(getString(R.string.common_validation_min_password))
                        .matchPatter(Common.PASSWORD_PATTERN)
                        .errorMessage(getString(R.string.common_validation_invalid_password_pattern))
                        .check()

                    validator.submit(editTextConfirmPassword)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_confirm_password))
                        .matchString(editTextPassword.text.toString().trim())
                        .errorMessage(getString(R.string.common_validation_password_mismatch))
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

    private val phoneNo by lazy {
        arguments?.getString(Common.BundleKey.PHONE)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.CreatePassword)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentCreatePasswordBinding {
        return AuthFragmentCreatePasswordBinding.inflate(inflater, container, attachToRoot)
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
            buttonCreate.setOnClickListener { onViewClick(it) }
            imageViewBack.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonCreate -> {
                if (isValid) {
                    forgotPassword()
                }
            }

            R.id.imageViewBack -> {
                navigator.goBack()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun forgotPassword() {
        val apiRequest = ApiRequest().apply {
            contact_no = phoneNo
            password = binding.editTextPassword.text.toString().trim()
            conf_password = binding.editTextConfirmPassword.text.toString().trim()
        }
        showLoader()
        authViewModel.forgotPassword(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.forgotPasswordLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(
                    analytics.PASSWORD_CHANGE,
                    screenName = AnalyticsScreenNames.CreatePassword
                )
                navigator.showAlertDialog(responseBody.message,
                    dialogOkListener = object : BaseActivity.DialogOkListener {
                        override fun onClick() {
                            navigator.finish()
                        }
                    })
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}