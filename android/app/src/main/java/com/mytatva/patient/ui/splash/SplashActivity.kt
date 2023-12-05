package com.mytatva.patient.ui.splash

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import com.freshchat.consumer.sdk.Freshchat
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks
import com.google.firebase.dynamiclinks.PendingDynamicLinkData
import com.google.firebase.installations.FirebaseInstallations
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.SplashActivityBinding
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.auth.fragment.v2.ChooseYourConditionV2Fragment
import com.mytatva.patient.ui.auth.fragment.v2.LetsBeginV2Fragment
import com.mytatva.patient.ui.auth.fragment.v2.SetUpYourProfileV2Fragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import com.webengage.sdk.android.WebEngage

/**
 * Created by Hlink 44.
 */
class SplashActivity : BaseActivity() {
    //Data store on after user login
    lateinit var splashActivityBinding: SplashActivityBinding

    val handler = Handler(Looper.getMainLooper())
    lateinit var runnable: Runnable

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    override fun findFragmentPlaceHolder(): Int {
        return 0
    }

    override fun createViewBinding(): View {
        splashActivityBinding = SplashActivityBinding.inflate(layoutInflater)
        return splashActivityBinding.root
    }

    override fun inject(activityComponent: ActivityComponent) {
        activityComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
        handleForClearSessionOnAppUpdate()
        onBoardingSignUp()
        if (MyTatvaApp.IS_TO_USE_FIREBASE_FLAGS.not()) {
            getNoLoginSettingFlags()
        }

        runnable = Runnable {
            if (appPreferences.getBoolean(Common.IS_LOGIN)) {

                if (appPreferences.isBiometricEnabled()) {

                    showBiometricPrompt { isSuccess, message ->
                        if (isSuccess) {
                            handleNavigation()
                        } else {
                            if (message.isNotBlank()) {
                                showToast(message)
                            }
                            finish()
                        }
                    }

                } else {
                    handleNavigation()
                }

            } else if (session.authUserSession.isNotBlank()) {

                /*if (session.user?.step == Common.AuthStep.SELECT_ROLE) {
                    loadActivity(
                        AuthActivity::class.java,
                        SelectRoleFragment::class.java
                    ).byFinishingCurrent().start()
                } else if (session.user?.step == Common.AuthStep.VERIFY_LINK_DOCTOR) {
                    loadActivity(
                        AuthActivity::class.java,
                        VerifyLinkDoctorFragment::class.java
                    ).byFinishingCurrent().start()
                } else if (session.user?.step == Common.AuthStep.ADD_ACCOUNT_DETAILS) {
                    loadActivity(
                        AuthActivity::class.java,
                        AddAccountDetailsNewFragment::class.java
                    ).byFinishingCurrent().start()
                } else {
                    loadActivity(AuthActivity::class.java).shouldAnimate(false).start()
                    Handler(Looper.getMainLooper()).postDelayed({
                        finish()
                    }, 100)
                }*/

                // UJ 3 changes flow
                when (session.user?.step) {
                    Common.AuthStep.LETS_BEGIN -> {
                        loadActivity(
                            AuthActivity::class.java,
                            LetsBeginV2Fragment::class.java
                        ).byFinishingCurrent().start()
                    }

                    Common.AuthStep.SETUP_YOUR_PROFILE -> {
                        loadActivity(
                            AuthActivity::class.java,
                            SetUpYourProfileV2Fragment::class.java
                        ).byFinishingCurrent().start()
                    }

                    Common.AuthStep.CHOOSE_CONDITION -> {
                        loadActivity(
                            AuthActivity::class.java,
                            ChooseYourConditionV2Fragment::class.java
                        ).byFinishingCurrent().start()
                    }

                    else -> {
                        loadActivity(AuthActivity::class.java).shouldAnimate(false).start()
                        Handler(Looper.getMainLooper()).postDelayed({
                            finish()
                        }, 100)
                    }
                }

            } else {
                getDeepLink { ->
                    // normal default flow
                    loadActivity(AuthActivity::class.java).shouldAnimate(false).start()
                    Handler(Looper.getMainLooper()).postDelayed({
                        finish()
                    }, 100)
                }
            }

            /*loadActivity(AuthActivity::class.java,LoginOtpVerificationFragment::class.java).start()*/
        }
    }

    private fun handleForClearSessionOnAppUpdate() {
        if (appPreferences.getCurrentAppVersionCode() != BuildConfig.VERSION_CODE
            && appPreferences.getBoolean(Common.IS_LOGIN).not()
        ) {
            //when app version changed/updated and if user is not completely logged in,
            //clear all user session preferences if any stored
            appPreferences.clearAll()
        }
        appPreferences.setCurrentAppVersionCode()
    }

    private fun handleNavigation() {
        getDeepLink { ->
            // normal default flow
            session.user?.let { analytics.login(it) }//
            loadActivity(HomeActivity::class.java).byFinishingCurrent().start()
        }
    }

    override fun onResume() {
        super.onResume()
        session.getFirebaseDeviceId { deviceId ->
            if (deviceId.isNotBlank()) {
                WebEngage.get().setRegistrationID(deviceId)
                Freshchat.getInstance(applicationContext).setPushRegistrationToken(deviceId)
            }
            session.deviceId = deviceId
            Log.d("DEVICE_ID", "deviceId: $deviceId")
            handler.postDelayed(runnable, 2000)
        }
        // store device unique id//
        FirebaseInstallations.getInstance().id.addOnCompleteListener {
            if (it.isSuccessful) {
                session.deviceFID = it.result
                Log.d("deviceFID", ":: ${it.result}")
            }
        }
    }

    override fun onPause() {
        super.onPause()
        handler.removeCallbacks(runnable)
    }

    private fun getDeepLink(callbackToDefaultFlow: () -> Unit) {
        // ATTENTION: This was auto-generated to handle app links.
        val appLinkIntent: Intent = intent
        val appLinkAction: String? = appLinkIntent.action
        val appLink: Uri? = appLinkIntent.data
        Log.d("MyTAppLink", "getDeepLink: ${appLink.toString()}")

        if (appLink?.toString()?.startsWith("mytatva://") == true
            && appLink.queryParameterNames?.contains(FirebaseLink.Params.OPERATION) == true
            && appLink.getQueryParameter(FirebaseLink.Params.OPERATION) == FirebaseLink.Operation.SIGNUP_LINK_DOCTOR
        ) {

            /* **************************************************************************
             * app link for google ads campaign flow to handle
             * **************************************************************************/
            FirebaseLink.handleSignUpLinkDoctorOperationDeepLinkWithResult(appLink)
            Log.d(
                "MyTAppLink",
                "getDeepLink: ${FirebaseLink.Values.accessFrom} :: ${FirebaseLink.Values.accessCode}"
            )
            callbackToDefaultFlow.invoke()

        } else {
            /* *************************************
             * normal app deeplink flow
             * *************************************/
            FirebaseDynamicLinks.getInstance().getDynamicLink(intent)
                .addOnSuccessListener(this) { pendingDynamicLinkData: PendingDynamicLinkData? ->
                    // Get deep link from result (may be null if no link is found)
                    var deepLink: Uri? = null
                    if (pendingDynamicLinkData != null) {
                        deepLink = pendingDynamicLinkData.link
                        Log.d("DeepLink", "Link: $deepLink")
                        if (deepLink?.queryParameterNames?.contains(FirebaseLink.Params.OPERATION) == true) {

                            when (deepLink.getQueryParameter(FirebaseLink.Params.OPERATION)) {

                                FirebaseLink.Operation.SIGNUP_LINK_DOCTOR -> {
                                    FirebaseLink.handleSignUpLinkDoctorOperationDeepLinkWithResult(
                                        deepLink
                                    )
                                    callbackToDefaultFlow.invoke()
                                }

                                FirebaseLink.Operation.CONTENT -> {


                                }

                                FirebaseLink.Operation.SCREEN_NAV -> {
                                    if (appPreferences.getBoolean(Common.IS_LOGIN)) {
                                        //handleScreenNavigation(deepLink, callbackToDefaultFlow)

                                        loadActivity(HomeActivity::class.java).addBundle(
                                            bundleOf(
                                                Pair(
                                                    Common.BundleKey.DEEP_LINK, deepLink.toString()
                                                )
                                            )
                                        ).byFinishingCurrent().start()

                                    } else {
                                        callbackToDefaultFlow.invoke()
                                    }
                                }

                                else -> {
                                    callbackToDefaultFlow.invoke()
                                }
                            }

                        } else {
                            callbackToDefaultFlow.invoke()
                        }

                    } else {
                        callbackToDefaultFlow.invoke()
                    }

                }.addOnFailureListener(this) { e: Exception? ->
                    Log.w("addOnFailureListener", "getDynamicLink:onFailure")
                    callbackToDefaultFlow.invoke()
                }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getNoLoginSettingFlags() {
        val apiRequest = ApiRequest()
        authViewModel.getNoLoginSettingFlags(apiRequest)
    }

    private fun onBoardingSignUp() {
        appPreferences.onBoardingList = null
        authViewModel.onBordingSignUp()
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.getNoLoginSettingFlagsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                appPreferences.setIsToHideLanguagePage(it.language_page == "N")
            }
        }, onError = { throwable ->
            hideLoader()
            false
        })

        authViewModel.onBordingSignUpLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                appPreferences.onBoardingList = it
            }
        }, onError = { throwable ->
            hideLoader()
            false
        })
    }
}