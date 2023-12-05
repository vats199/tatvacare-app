package com.mytatva.patient.utils.rnbridge

import android.os.Bundle
import android.view.View
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.fragment.SelectYourLocationFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.home.fragment.DevicesFragment
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.openAppInStore
import com.mytatva.patient.utils.shareApp
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch


class AndroidBridgeModule(var reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(
    reactContext
) {

    init {
        ContextHolder.reactContext = reactContext
    }

    override fun getName(): String {
        return "AndroidBridge"
    }


    @ReactMethod
    fun openNotificationScreen() {

    }

    @ReactMethod
    fun openMyProfileScreen() {

    }

    @ReactMethod
    fun openSearchScreen() {

    }

    @ReactMethod
    fun openAllPlanScreen(showPlanType: String) {

    }

    @ReactMethod
    fun openConsultNutritionistScreen() {

    }

    @ReactMethod
    fun openConsultPhysioScreen() {

    }

    @ReactMethod
    fun openLabTestScreen() {

    }

    @ReactMethod
    fun openBookDiagnosticScreen() {

    }

    @ReactMethod
    fun openDeviceScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_HEALTH_DIARY,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DIARY_ITEM,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_DEVICES
                )
            }
        )

        /*if ((currentActivity as BaseActivity?)!!.session.user!!.patient_plans.isEmpty()) {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
            ).start()
        } else if (!(currentActivity as BaseActivity?)!!.session.user!!.patient_plans.isEmpty() && (currentActivity as BaseActivity?)!!.session.user!!.patient_plans[0].plan_type == "Free") {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
            ).start()
        } else {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, DevicesFragment::class.java
            ).start()
        }*/

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, DevicesFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openBookDeviceScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.CLICKED_BOOK_DEVICES,
            Bundle()
        )

        /*if ((currentActivity as BaseActivity?)!!.session.user!!.patient_plans.isEmpty()) {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
            ).start()
        } else if (!(currentActivity as BaseActivity?)!!.session.user!!.patient_plans.isEmpty() && (currentActivity as BaseActivity?)!!.session.user!!.patient_plans[0].plan_type == "Free") {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
            ).start()
        } else {
            (currentActivity as BaseActivity?)!!.loadActivity(
                IsolatedFullActivity::class.java, DevicesFragment::class.java
            ).start()
        }*/

        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, DevicesFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openAccountSettingScreen() {

    }

    @ReactMethod
    fun openHelpSupportScreen() {

    }

    @ReactMethod
    fun openHealthGoalScreen() {

    }

    @ReactMethod
    fun openAllAppointmentScreen() {

    }

    @ReactMethod
    fun openBookmarkScreen() {

    }

    @ReactMethod
    fun openHealthRecordScreen() {

    }

    @ReactMethod
    fun openLocationSelectionScreen() {
        (currentActivity as BaseActivity?)!!.loadActivity(
            IsolatedFullActivity::class.java, SelectYourLocationFragment::class.java
        ).start()
    }

    @ReactMethod
    fun openDietScreen(percentage: Int) {

    }

    @ReactMethod
    fun openIncidentScreen(incidentData: String) {

    }

    @ReactMethod
    fun openLearnScreen() {

    }

    @ReactMethod
    fun openLearnDetailsScreen(contentId: String, contentType: String) {

    }

    @ReactMethod
    fun openExerciseDetailsScreen(exerciseList: String, index: Int, percentage: Int) {

    }

    @ReactMethod
    fun openMedicationScreen(exerciseList: String, index: Int, percentage: Int) {

    }

    @ReactMethod
    fun openCheckAllPlanScreen() {

    }

    @ReactMethod
    fun openFreePlanDetailScreen(planDetails: String) {

    }

    @ReactMethod
    fun openPurchasedPlanDetailScreen(planDetails: String) {

    }


    @ReactMethod
    fun openGoalItemDetailScreen(goalList: String, keys: String, index: Int) {

    }

    @ReactMethod
    fun openReadingsItemDetailScreen(goalList: String, keys: String, index: Int) {

    }


    @ReactMethod
    fun openBMIScreen() {

    }

    @ReactMethod
    fun openShareAppScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_SHARE_APP
                )
            })

        (currentActivity as BaseActivity?)!!.shareApp()
    }

    @ReactMethod
    fun openRateAppScreen() {
        (currentActivity as BaseActivity?)!!.analytics.logEvent(
            AnalyticsClient.MENU_NAVIGATION,
            Bundle().apply {
                putString(
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_MENU,
                    (currentActivity as BaseActivity?)!!.analytics.PARAM_RATE_APP
                )
            })

        (currentActivity as BaseActivity?)!!.openAppInStore()
    }

    @ReactMethod
    fun triggerUserToken() {
        if ((currentActivity as BaseActivity?)!!.session != null && (currentActivity as BaseActivity?)!!.session.user != null) {
            val map = Arguments.createMap()
            map.putString(
                "Token",
                (currentActivity as BaseActivity?)!!.session.user?.token.toString()
            )
            map.putBoolean(
                "IsHideIncident",
                AppFlagHandler.isToHideIncidentSurvey((currentActivity as BaseActivity?)!!.firebaseConfigUtil)
            )

            ContextHolder.reactContext?.let {
                (currentActivity as BaseActivity?)!!.sendEventToRN(
                    it,
                    "UserToken",
                    map
                )
            }
        }

        GlobalScope.launch(Dispatchers.Main) {
            if (currentActivity is HomeActivity) {
                (currentActivity as HomeActivity).hideLoader()

                /*val deepLink = Uri.parse((currentActivity as HomeActivity).deepLink)
                val screenName = deepLink.getQueryParameter(FirebaseLink.Params.SCREEN_NAME)
                if (screenName == AnalyticsScreenNames.GenAI) {
                    (currentActivity as HomeActivity).loadActivity(GenAIActivity::class.java)
                        .start()
                }*/
            }
        }
    }

    @ReactMethod
    fun onBackPressed() {

    }

    @ReactMethod
    fun hideBottomNavFromHome() {
        if (currentActivity is HomeActivity) {
            runOnUiThread {
                (currentActivity as HomeActivity?)!!.binding.layoutBottomMenu.visibility = View.GONE
            }
        }
    }

    @ReactMethod
    fun showBottomNavFromHome() {
        if (currentActivity is HomeActivity) {
            runOnUiThread {
                (currentActivity as HomeActivity?)!!.binding.layoutBottomMenu.visibility =
                    View.VISIBLE
            }
        }
    }

    @ReactMethod
    fun openLabTestDetailScreen(diagnosticId: String) {

    }


}