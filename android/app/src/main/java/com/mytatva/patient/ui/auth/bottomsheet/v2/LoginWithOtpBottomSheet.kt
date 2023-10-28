package com.mytatva.patient.ui.auth.bottomsheet.v2

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Dialog
import android.content.DialogInterface
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import androidx.annotation.RequiresApi
import androidx.core.os.bundleOf
import androidx.core.widget.addTextChangedListener
import androidx.fragment.app.DialogFragment
import androidx.lifecycle.ViewModelProvider
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthV2BottomsheetLoginWithOtpBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.auth.fragment.v2.OTPVerificationFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.openBrowserTest

class LoginWithOtpBottomSheet :
    BaseBottomSheetDialogFragment<AuthV2BottomsheetLoginWithOtpBinding>() {

    private var onClick: (Bundle) -> Unit = {}
    private var onDismiss: () -> Unit = {}
    private var onShow: () -> Unit = {}
    fun setCallback(
        onClick: (Bundle) -> Unit,
        onShow: () -> Unit,
        onDismiss: () -> Unit,
    ): LoginWithOtpBottomSheet {
        this.onClick = onClick
        this.onShow = onShow
        this.onDismiss = onDismiss
        return this
    }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

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

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthV2BottomsheetLoginWithOtpBinding {
        return AuthV2BottomsheetLoginWithOtpBinding.inflate(inflater)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun bindData() {

        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
        }
//        setView()
        setViewListeners()
    }

    private fun triggerCloseEvent() {
        try {
            analytics.logEvent(
                analytics.CLOSE_BOTTOM_SHEET,
                Bundle().apply {
                    putString(
                        analytics.PARAM_BOTTOM_SHEET_NAME,
                        binding.editTextMobileNumber.text.toString().trim()
                    )
                },
                screenName = AnalyticsScreenNames.LoginSignup
            )
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.e("onDestroy", "onDestroy:false")
    }

    override fun onDismiss(dialog: DialogInterface) {
        triggerCloseEvent()
        super.onDismiss(dialog)
        Log.e("onDismiss", "onDismiss:false")
        onDismiss.invoke()
    }

    override fun onCancel(dialog: DialogInterface) {
        Log.e("onCancel", "onCancel:false")
        binding.editTextMobileNumber.clearFocus()
        hideKeyboardFrom(binding.editTextMobileNumber)
        appPreferences.setToOpenLoginStep(false)
        super.onCancel(dialog)
    }

    override fun onResume() {
        super.onResume()
        Log.e("onResume", "onResume:true")
        analytics.setScreenName(AnalyticsScreenNames.LoginSignup)
        appPreferences.setToOpenLoginStep(true)
        //clear tokens if user comes back to this screen
        session.userSession = ""
        session.authUserSession = ""
        setView()
        onShow.invoke()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        setStyle(DialogFragment.STYLE_NORMAL, R.style.myBottomSheetDialog)
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
    }

//    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
//        return BottomSheetDialog(requireContext(),R.style.myBottomSheetDialog)//super.onCreateDialog(savedInstanceState)
//    }

    private fun setView() {
        with(binding) {
            editTextMobileNumber.requestFocus()
        }
    }

    private fun setViewListeners() {
        binding.apply {
            layoutLinearMobileNumber.setOnClickListener { onViewClick(it) }
            buttonContinue.setOnClickListener { onViewClick(it) }

            editTextMobileNumber.addTextChangedListener {
                buttonContinue.isEnabled = it.toString().trim().length == 10
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.layoutLinearMobileNumber -> {
                setView()
            }

            R.id.buttonContinue -> {
                if (isValid) {
                    sendOtpSignup()
                }
                //requireContext().openBrowserTest()
            }
        }
    }

    @SuppressLint("RestrictedApi")
    override fun setupDialog(dialog: Dialog, style: Int) {
        super.setupDialog(dialog, style)
        /*dialog.window?.setSoftInputMode(
            WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE or WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE
        );*/
        //dialog.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
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
                /* navigator.loadActivity(
                     AuthActivity::class.java,
                     OTPVerificationFragment::class.java)
                     .addBundle(
                         bundleOf(
                             Pair(Common.BundleKey.PHONE, binding.editTextMobileNumber.text.toString()),
                             Pair(Common.BundleKey.IS_FOR_LOGIN, false)
                         )
                     ).start()*/

                /*onClick.invoke(
                    bundleOf(
                        Pair(Common.BundleKey.PHONE, binding.editTextMobileNumber.text.toString()),
                        Pair(Common.BundleKey.IS_FOR_LOGIN, false)
                    )
                )*/

                appPreferences.setToOpenLoginStep(false)
                (requireActivity() as BaseActivity).loadActivity(
                    AuthActivity::class.java,
                    OTPVerificationFragment::class.java
                ).addBundle(bundleOf(
                    Pair(Common.BundleKey.PHONE, binding.editTextMobileNumber.text.toString()),
                    Pair(Common.BundleKey.IS_FOR_LOGIN, false)
                )).start()

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

                /*navigator.loadActivity(
                    AuthActivity::class.java,
                    OTPVerificationFragment::class.java)
                    .addBundle(
                        bundleOf(
                            Pair(
                                Common.BundleKey.PHONE,
                                binding.editTextMobileNumber.text.toString()),
                            Pair(Common.BundleKey.IS_FOR_LOGIN, true)
                        )
                    ).start()*/

                /*onClick.invoke(
                    bundleOf(
                        Pair(
                            Common.BundleKey.PHONE,
                            binding.editTextMobileNumber.text.toString()
                        ),
                        Pair(Common.BundleKey.IS_FOR_LOGIN, true)
                    )
                )*/

                appPreferences.setToOpenLoginStep(false)
                (requireActivity() as BaseActivity).loadActivity(
                    AuthActivity::class.java,
                    OTPVerificationFragment::class.java
                ).addBundle(bundleOf(
                    Pair(
                        Common.BundleKey.PHONE,
                        binding.editTextMobileNumber.text.toString()
                    ),
                    Pair(Common.BundleKey.IS_FOR_LOGIN, true)
                )).start()

            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

}