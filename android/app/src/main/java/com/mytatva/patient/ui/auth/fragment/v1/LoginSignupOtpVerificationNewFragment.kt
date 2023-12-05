package com.mytatva.patient.ui.auth.fragment.v1

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.CountDownTimer
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthNewFragmentLoginSignupOtpVerificationBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import java.util.concurrent.TimeUnit


class LoginSignupOtpVerificationNewFragment :
    BaseFragment<AuthNewFragmentLoginSignupOtpVerificationBinding>() {

    // argument parameters =====
    private val isForLogin: Boolean by lazy {
        arguments?.getBoolean(Common.BundleKey.IS_FOR_LOGIN) ?: false
    }
    private val phoneNo by lazy {
        arguments?.getString(Common.BundleKey.PHONE)
    }
    //===========================

    private val isValid: Boolean
        get() {
            return try {
                with(binding.layoutOTP) {

                    val otpValue =
                        editText1.text.toString() + editText2.text.toString() + editText3.text.toString() + editText4.text.toString() + editText5.text.toString() + editText6.text.toString()

                    if (otpValue.trim().isBlank()) {
                        throw ApplicationException(getString(R.string.common_validation_empty_otp))
                    }
                    if (otpValue.trim().length < 6) {
                        throw ApplicationException(getString(R.string.common_validation_invalid_otp))
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    private var timer: CountDownTimer? = null

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    //private val SMS_CONSENT_REQUEST = 2  // Set to an unused request code
    private val smsVerificationReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
                val extras = intent.extras
                val smsRetrieverStatus = extras?.get(SmsRetriever.EXTRA_STATUS) as Status

                when (smsRetrieverStatus.statusCode) {
                    CommonStatusCodes.SUCCESS -> {
                        // Get consent intent
                        val consentIntent =
                            extras.getParcelable<Intent>(SmsRetriever.EXTRA_CONSENT_INTENT)
                        try {
                            // Start activity to show consent dialog to user, activity must be started in
                            // 5 minutes, otherwise you'll receive another TIMEOUT intent
                            startActivityForResult(
                                consentIntent,
                                Common.RequestCode.REQUEST_SMS_CONSENT
                            )
                        } catch (e: ActivityNotFoundException) {
                            // Handle the exception ...
                        }
                    }

                    CommonStatusCodes.TIMEOUT -> {
                        // Time out occurred, handle the error.
                    }
                }
            }
        }
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthNewFragmentLoginSignupOtpVerificationBinding {
        return AuthNewFragmentLoginSignupOtpVerificationBinding.inflate(
            inflater,
            container,
            attachToRoot
        )
    }

    override fun onResume() {
        super.onResume()
        if (isForLogin) {
            analytics.setScreenName(AnalyticsScreenNames.LoginOtp)
        } else {
            analytics.setScreenName(AnalyticsScreenNames.SignUpOtp)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        with(binding) {
            textViewMessage.text =
                "Please enter the OTP, we have sent to your phone number +91 - $phoneNo"
        }
        setViewListeners()
        startTimer()
        setUpUI()
        initOneTapSMSVerification()
        setPasteCallbackForOTPViews(binding.layoutOTP)
    }

    private fun setUpUI() {
        with(binding.layoutOTP) {
            //GenericTextWatcher here works only for moving to next EditText when a number is entered
            //first parameter is the current EditText and second parameter is next EditText
            editText1.addTextChangedListener(
                GenericTextWatcher(
                    editText1,
                    editText2,
                    requireActivity() as BaseActivity
                )
            )
            editText2.addTextChangedListener(
                GenericTextWatcher(
                    editText2,
                    editText3,
                    requireActivity() as BaseActivity
                )
            )
            editText3.addTextChangedListener(
                GenericTextWatcher(
                    editText3,
                    editText4,
                    requireActivity() as BaseActivity
                )
            )
            editText4.addTextChangedListener(
                GenericTextWatcher(
                    editText4,
                    editText5,
                    requireActivity() as BaseActivity
                )
            )
            editText5.addTextChangedListener(
                GenericTextWatcher(
                    editText5,
                    editText6,
                    requireActivity() as BaseActivity
                )
            )
            editText6.addTextChangedListener(
                GenericTextWatcher(
                    editText6,
                    null,
                    requireActivity() as BaseActivity
                )
            )


            //GenericKeyEvent here works for deleting the element and to switch back to previous EditText
            //first parameter is the current EditText and second parameter is previous EditText
            editText1.setOnKeyListener(
                GenericKeyEvent(
                    editText1,
                    null,
                    requireActivity()
                )
            )
            editText2.setOnKeyListener(
                GenericKeyEvent(
                    editText2,
                    editText1,
                    requireActivity()
                )
            )
            editText3.setOnKeyListener(
                GenericKeyEvent(
                    editText3,
                    editText2,
                    requireActivity()
                )
            )
            editText4.setOnKeyListener(
                GenericKeyEvent(
                    editText4,
                    editText3,
                    requireActivity()
                )
            )
            editText5.setOnKeyListener(
                GenericKeyEvent(
                    editText5,
                    editText4,
                    requireActivity()
                )
            )
            editText6.setOnKeyListener(
                GenericKeyEvent(
                    editText6,
                    editText5,
                    requireActivity()
                )
            )
        }
    }

    private fun startTimer() {
        timer?.cancel()
        timer = object : CountDownTimer(60L * 1000, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                if (isAdded) {
                    binding.textViewTimer.text = String.format(
                        "%02d:%02d",
                        TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished),
                        TimeUnit.MILLISECONDS.toSeconds(millisUntilFinished) -
                                TimeUnit.MINUTES.toSeconds(
                                    TimeUnit.MILLISECONDS.toMinutes(
                                        millisUntilFinished
                                    )
                                )
                    )
                }
            }

            override fun onFinish() {
                if (isAdded) {
                    binding.textViewTimer.text = ""
                    binding.textViewResend.isEnabled = true
                    binding.textViewResend.alpha = 1f
                }
            }
        }
        timer?.start()
        binding.textViewResend.isEnabled = false
        binding.textViewResend.alpha = 0.5f
    }

    private fun initOneTapSMSVerification() {
        // Start listening for SMS User Consent broadcasts from senderPhoneNumber
        // The Task<Void> will be successful if SmsRetriever was able to start
        // SMS User Consent, and will error if there was an error starting.
        val task =
            SmsRetriever.getClient(requireContext())
                .startSmsUserConsent(Common.SMS_SENDER_PHONE_NUMBER)
        task.addOnSuccessListener {
            Log.d("SmsRetriever", ":: success")
        }
        task.addOnFailureListener {
            Log.d("SmsRetriever", ":: ${it.message}")
        }
        val intentFilter = IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION)
        requireContext().registerReceiver(
            smsVerificationReceiver,
            intentFilter,
            SmsRetriever.SEND_PERMISSION,
            null
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            // ...
            Common.RequestCode.REQUEST_SMS_CONSENT ->
                // Obtain the phone number from the result
                if (resultCode == Activity.RESULT_OK && data != null) {
                    // Get SMS message content
                    val message = data.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)
                    // Extract one-time code from the message and complete verification
                    // `message` contains the entire text of the SMS message, so you will need
                    // to parse the string.
                    message?.let {
                        setOTP(binding.layoutOTP, fetchOTPfromMessage(it))
                    }
                } else {
                    // Consent denied. User can type OTC manually.
                }
        }

    }

    override fun onDestroy() {
        requireContext().unregisterReceiver(smsVerificationReceiver)
        super.onDestroy()
        timer?.cancel()
    }

    private fun setViewListeners() {
        binding.apply {
            layoutHeader.imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            buttonVerify.setOnClickListener { onViewClick(it) }
            textViewResend.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonVerify -> {
                if (isValid) {
                    if (isForLogin) {
                        loginVerifyOtp()
                    } else {
                        verifyOtpSignup()
                    }
                }
            }

            R.id.textViewResend -> {
                if (isForLogin) {
                    loginSendOtp()
                } else {
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
    private fun loginSendOtp() {
        val apiRequest = ApiRequest().apply {
            contact_no = phoneNo
        }
        showLoader()
        authViewModel.loginSendOtp(apiRequest)
    }

    private fun loginVerifyOtp() {
        val otpValue = with(binding.layoutOTP) {
            editText1.text.toString() + editText2.text.toString() + editText3.text.toString() +
                    editText4.text.toString() + editText5.text.toString() + editText6.text.toString()
        }
        val apiRequest = ApiRequest().apply {
            contact_no = phoneNo
            otp = otpValue
        }
        showLoader()
        authViewModel.loginVerifyOtp(apiRequest)
    }

    private fun sendOtpSignup() {
        val apiRequest = ApiRequest()
        apiRequest.contact_no = phoneNo
        showLoader()
        authViewModel.sendOtpSignup(apiRequest)
    }

    private fun verifyOtpSignup() {
        val otpValue = with(binding.layoutOTP) {
            editText1.text.toString() + editText2.text.toString() + editText3.text.toString() +
                    editText4.text.toString() + editText5.text.toString() + editText6.text.toString()
        }

        val apiRequest = ApiRequest().apply {
            contact_no = phoneNo
            otp = otpValue

            if (FirebaseLink.Values.accessCode.isNullOrBlank().not()) {
                access_code = FirebaseLink.Values.accessCode
            }
        }
        showLoader()
        authViewModel.verifyOtpSignup(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.loginVerifyOtpLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.LOGIN_OTP_SUCCESS, Bundle().apply {
                    putString(analytics.PARAM_PHONE_NO, phoneNo)
                }, screenName = AnalyticsScreenNames.LoginOtp)
                openHome(screenName = AnalyticsScreenNames.LoginOtp)
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException && throwable.code == 0) {
                    analytics.logEvent(analytics.LOGIN_OTP_INCORRECT, Bundle().apply {
                        putString(analytics.PARAM_PHONE_NO, phoneNo)
                    }, screenName = AnalyticsScreenNames.LoginOtp)
                }
                true
            })

        authViewModel.loginSendOtpLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(
                    analytics.LOGIN_SMS_SENT,
                    screenName = AnalyticsScreenNames.LoginOtp
                )
                showMessage(responseBody.message)
                startTimer()
                initOneTapSMSVerification()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.verifyOtpSignupLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()

                analytics.logEvent(analytics.NEW_USER_OTP_VERIFY, Bundle().apply {
                    putString(analytics.PARAM_PHONE_NO, phoneNo)
                }, screenName = AnalyticsScreenNames.SignUpOtp)

                /**
                 * commented below as removed and this fragment will no longer open from Auth UJ 3 changes
                 */
                /*if (session.user?.step == Common.AuthStep.SELECT_ROLE) {
                    navigator.load(SelectRoleFragment::class.java).replace(false)
                } else if (session.user?.step == Common.AuthStep.VERIFY_LINK_DOCTOR) {
                    navigator.load(VerifyLinkDoctorFragment::class.java).replace(false)
                } else if (session.user?.step == Common.AuthStep.ADD_ACCOUNT_DETAILS) {
                    navigator.load(AddAccountDetailsNewFragment::class.java).replace(false)
                } else {
                    navigator.load(SelectRoleFragment::class.java).replace(false)
                }*/

            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.sendOtpSignupLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                showMessage(responseBody.message)

                analytics.logEvent(analytics.SIGNUP_OTP_SENT_SUCCESS, Bundle().apply {
                    putString(analytics.PARAM_PHONE_NO, phoneNo)
                }, screenName = AnalyticsScreenNames.SignUpOtp)

                startTimer()
                initOneTapSMSVerification()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}