package com.mytatva.patient.ui.auth.fragment.v1

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.core.widget.addTextChangedListener
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthNewFragmentLoginOrSignUpPhoneNumberBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class LoginOrSignupNewFragment : BaseFragment<AuthNewFragmentLoginOrSignUpPhoneNumberBinding>() {

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
    ): AuthNewFragmentLoginOrSignUpPhoneNumberBinding {
        return AuthNewFragmentLoginOrSignUpPhoneNumberBinding.inflate(
            inflater,
            container,
            attachToRoot
        )
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LoginSignup)

        //clear tokens if user comes back to this screen
        session.userSession = ""
        session.authUserSession = ""
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }


    override fun bindData() {

        analytics.logEvent(
            analytics.NEW_USER_SIGNUP_ATTEMPT,
            screenName = AnalyticsScreenNames.LoginSignup
        )
        /*analytics.logEvent(analytics.LOGIN_ATTEMPT,
            screenName = AnalyticsScreenNames.LoginWithPhone)*/
        setViewListeners()
    }

    private fun setViewListeners() {
        binding.apply {
            buttonContinue.setOnClickListener { onViewClick(it) }

            editTextMobileNumber.addTextChangedListener {
                buttonContinue.isEnabled = it.toString().trim().length == 10
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonContinue -> {
                if (isValid) {
                    sendOtpSignup()
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun sendOtpSignup() {
        val apiRequest = ApiRequest()
        apiRequest.contact_no = binding.editTextMobileNumber.text.toString().trim()
        showLoader()
        authViewModel.sendOtpSignup(apiRequest)
    }

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
        authViewModel.sendOtpSignupLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.NEW_USER_MOBILE_CAPTURE, Bundle().apply {
                    putString(
                        analytics.PARAM_PHONE_NO,
                        binding.editTextMobileNumber.text.toString()
                    )
                }, screenName = AnalyticsScreenNames.LoginSignup)

                analytics.logEvent(analytics.SIGNUP_OTP_SENT_SUCCESS, Bundle().apply {
                    putString(
                        analytics.PARAM_PHONE_NO,
                        binding.editTextMobileNumber.text.toString()
                    )
                }, screenName = AnalyticsScreenNames.LoginSignup)

                //analytics.logEvent(analytics.NEW_USER_MOBILE_CAPTURE)

                navigator.loadActivity(
                    AuthActivity::class.java,
                    LoginSignupOtpVerificationNewFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(
                                Common.BundleKey.PHONE,
                                binding.editTextMobileNumber.text.toString()
                            ),
                            Pair(Common.BundleKey.IS_FOR_LOGIN, false)
                        )
                    ).start()

            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException && throwable.code == Common.ResponseCode.USER_ALREADY_REGISTERED) {
                    //user already registered

                    //call send login otp API and go to otp verification for login directly
                    loginSendOtp()

                    // below flow commented to show already registered msg
                    // and redirection to login screen, as it's removed and flow changed for this case
                    /*navigator.showAlertDialog(throwable.message ?: "",
                        dialogOkListener = object : BaseActivity.DialogOkListener {
                            override fun onClick() {
                                navigator.loadActivity(AuthActivity::class.java,
                                    LoginWithOtpFragment::class.java)
                                    .byFinishingAll()
                                    .start()
                            }
                        })*/
                    false
                } else {
                    true
                }
            })

        authViewModel.loginSendOtpLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(
                    analytics.LOGIN_SMS_SENT,
                    screenName = AnalyticsScreenNames.LoginSignup
                )

                navigator.loadActivity(
                    AuthActivity::class.java,
                    LoginSignupOtpVerificationNewFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(
                                Common.BundleKey.PHONE,
                                binding.editTextMobileNumber.text.toString()
                            ),
                            Pair(Common.BundleKey.IS_FOR_LOGIN, true)
                        )
                    ).start()

            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}