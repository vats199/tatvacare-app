package com.mytatva.patient.ui.auth.fragment

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
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Common.SMS_SENDER_PHONE_NUMBER
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthFragmentSignUpWithOtpBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.textdecorator.TextDecorator
import java.util.concurrent.TimeUnit

class SignUpWithOtpFragment : BaseFragment<AuthFragmentSignUpWithOtpBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding.layoutOTP) {

                    val otpValue =
                        editText1.text.toString() + editText2.text.toString() + editText3.text.toString() + editText4.text.toString()

                    if (otpValue.trim().isBlank()) {
                        throw ApplicationException(getString(R.string.common_validation_empty_otp))
                    }
                    if (otpValue.trim().length < 4) {
                        throw ApplicationException(getString(R.string.common_validation_invalid_otp))
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

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


    private var timer: CountDownTimer? = null

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val phoneNo by lazy {
        arguments?.getString(Common.BundleKey.PHONE)
    }


    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSignUpWithOtpBinding {
        return AuthFragmentSignUpWithOtpBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SignUpOtp)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        binding.editTextMobileNumber.setText(phoneNo)
        binding.editTextMobileNumber.postDelayed({
            if (isAdded) {
                hideKeyboardFrom(binding.editTextMobileNumber)
            }
        }, 100)

        setViewListeners()
        startTimer()
        setUpUI()

        initOneTapSMSVerification()

        setPasteCallbackForOTPViews(binding.layoutOTP)
    }

    private fun initOneTapSMSVerification() {
        // Start listening for SMS User Consent broadcasts from senderPhoneNumber
        // The Task<Void> will be successful if SmsRetriever was able to start
        // SMS User Consent, and will error if there was an error starting.
        val task =
            SmsRetriever.getClient(requireContext())
                .startSmsUserConsent(SMS_SENDER_PHONE_NUMBER)
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
                        //showMessage(it)
                        setOTP(binding.layoutOTP, fetchOTPfromMessage(it))
                    }
                } else {
                    // Consent denied. User can type OTC manually.
                }
        }
    }

    private fun setUpUI() {
        TextDecorator.decorate(binding.checkBoxAgreeTerms, "I agree to the terms and conditions")
            .underline("Terms & Conditions")
            .makeTextClickableWithSecondaryColor(
                requireContext().getColor(R.color.colorPrimary), View.OnClickListener {
                    binding.checkBoxAgreeTerms.isChecked = !binding.checkBoxAgreeTerms.isChecked
                }, false, "terms and conditions"
            ).build()

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
                    null,
                    requireActivity() as BaseActivity
                )
            )

            //GenericKeyEvent here works for deleting the element and to switch back to previous EditText
            //first parameter is the current EditText and second parameter is previous EditText
            editText1.setOnKeyListener(GenericKeyEvent(editText1, null, requireActivity()))
            editText2.setOnKeyListener(GenericKeyEvent(editText2, editText1, requireActivity()))
            editText3.setOnKeyListener(GenericKeyEvent(editText3, editText2, requireActivity()))
            editText4.setOnKeyListener(GenericKeyEvent(editText4, editText3, requireActivity()))
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

    private fun setViewListeners() {
        binding.apply {
            textViewResend.setOnClickListener { onViewClick(it) }
            buttonVerify.setOnClickListener { onViewClick(it) }
            textViewSignIn.setOnClickListener { onViewClick(it) }
            imageViewBack.setOnClickListener { onViewClick(it) }
            checkBoxAgreeTerms.setOnCheckedChangeListener { buttonView, isChecked ->
                buttonVerify.isEnabled = isChecked
            }
        }
    }

    override fun onDestroy() {
        requireContext().unregisterReceiver(smsVerificationReceiver)
        super.onDestroy()
        timer?.cancel()
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewBack -> {
                navigator.goBack()
            }

            R.id.textViewResend -> {
                sendOtpSignup()
            }

            R.id.buttonVerify -> {
                if (isValid) {
                    verifyOtpSignup()
                }
            }

            R.id.textViewSignIn -> {
                navigator.load(LoginWithOtpFragment::class.java).replace(false)
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun verifyOtpSignup() {
        val otpValue = with(binding.layoutOTP) {
            editText1.text.toString() + editText2.text.toString() + editText3.text.toString() + editText4.text.toString()
        }

        val apiRequest = ApiRequest().apply {
            contact_no = binding.editTextMobileNumber.text.toString().trim()
            otp = otpValue
        }
        showLoader()
        authViewModel.verifyOtpSignup(apiRequest)
    }

    private fun sendOtpSignup() {
        val apiRequest = ApiRequest().apply {
            contact_no = binding.editTextMobileNumber.text.toString().trim()
        }
        showLoader()
        authViewModel.sendOtpSignup(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.verifyOtpSignupLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.NEW_USER_OTP_VERIFY, Bundle().apply {
                    putString(analytics.PARAM_PHONE_NO, phoneNo)
                }, screenName = AnalyticsScreenNames.SignUpOtp)
                navigator.load(AddAccountDetailsFragment::class.java).setBundle(
                    bundleOf(
                        Pair(Common.BundleKey.PHONE, phoneNo),
                        Pair(Common.BundleKey.VERIFY_OTP_SIGNUP_RES_DATA, responseBody.data)
                    )
                ).replace(false)
                /*navigator.loadActivity(AuthActivity::class.java,AddAccountDetailsFragment::class.java).addBundle(
                    bundleOf(
                        Pair(Common.BundleKey.PHONE, phoneNo)
                    )
                ).start()*/
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.sendOtpSignupLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(analytics.SIGNUP_OTP_SENT_SUCCESS, Bundle().apply {
                    putString(
                        analytics.PARAM_PHONE_NO,
                        binding.editTextMobileNumber.text.toString().trim()
                    )
                }, screenName = AnalyticsScreenNames.SignUpOtp)

                showMessage(responseBody.message)
                startTimer()
                initOneTapSMSVerification()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}