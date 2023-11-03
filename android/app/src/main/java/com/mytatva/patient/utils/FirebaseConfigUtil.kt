package com.mytatva.patient.utils

import android.annotation.SuppressLint
import android.util.Log
import com.google.firebase.ktx.Firebase
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.ktx.remoteConfig
import com.google.firebase.remoteconfig.ktx.remoteConfigSettings
import com.mytatva.patient.R
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.ui.base.BaseActivity

class FirebaseConfigUtil private constructor(val activity: BaseActivity) {

    @SuppressLint("StaticFieldLeak")
    private val remoteConfig: FirebaseRemoteConfig = Firebase.remoteConfig
    private val configSettings = remoteConfigSettings {
        minimumFetchIntervalInSeconds = 5//3600
    }

    init {
        remoteConfig.setConfigSettingsAsync(configSettings)
        remoteConfig.setDefaultsAsync(R.xml.default_config_local)

        /*remoteConfig.fetchAndActivate()
            .addOnCompleteListener { task ->//

            }*/
        remoteConfig.fetchAndActivate()
            .addOnCompleteListener(activity) { task ->
                if (task.isSuccessful) {
                    val updated = task.result
                    Log.d(TAG, "Config params updated: $updated")
                } else {
                    Log.d(TAG, "Config params failed")
                }
            }
    }

    fun getString(key: String): String {
        return remoteConfig.getString(key)
    }


    fun getRazorPayKey(): String {
        val value = if (MyTatvaApp.IS_RAZORPAY_LIVE)
            remoteConfig.getString(razorpay_key_id_live)
        else
            remoteConfig.getString(razorpay_key_id_test)

        Log.d(TAG, "getRazorPayKey: $value")
        return value
    }

    fun getRazorPaySecret(): String {
        val value = if (MyTatvaApp.IS_RAZORPAY_LIVE)
            remoteConfig.getString(razorpay_secret_live)
        else
            remoteConfig.getString(razorpay_secret_test)

        Log.d(TAG, "getRazorPaySecret: $value")
        return value
    }

    fun getAzureAccessKey(): String {
        /*val value = if (URLFactory.IS_PRODUCTION)
            remoteConfig.getString(azure_access_key_live)
        else
            remoteConfig.getString(azure_access_key_dev)*/

        val value = if (URLFactory.ENVIRONMENT == URLFactory.Env.PRODUCTION)
            remoteConfig.getString(azure_access_key_live)
        else if (URLFactory.ENVIRONMENT == URLFactory.Env.UAT)
            remoteConfig.getString(azure_access_key_prod)
        else
            remoteConfig.getString(azure_access_key_dev)

        Log.d(TAG, "getAzureAccessKey: $value")
        return value
    }

    fun getAzureAccountName(): String {
        /*val value = if (URLFactory.IS_PRODUCTION)
            remoteConfig.getString(azure_account_name_live)
        else
            remoteConfig.getString(azure_account_name_dev)*/

        val value = if (URLFactory.ENVIRONMENT == URLFactory.Env.PRODUCTION)
            remoteConfig.getString(azure_account_name_live)
        else if (URLFactory.ENVIRONMENT == URLFactory.Env.UAT)
            remoteConfig.getString(azure_account_name_prod)
        else
            remoteConfig.getString(azure_account_name_dev)

        Log.d(TAG, "getAzureAccountName: $value")
        return value
    }

    // app flags to hide show features
    fun getIsToHideChatBot(): Boolean {
        return remoteConfig.getBoolean(hide_chatbot)
    }

    fun getIsToHideLanguagePage(): Boolean {
        return remoteConfig.getBoolean(hide_language_page)
    }

    fun getIsToHideEngagePage(): Boolean {
        return remoteConfig.getBoolean(hide_engage_page)
    }

    fun getIsToHideLeaveAQuery(): Boolean {
        return remoteConfig.getBoolean(hide_leave_query)
    }

    fun getIsToHideEmailAt(): Boolean {
        return remoteConfig.getBoolean(hide_email_at)
    }

    fun getIsToHideAskAnExpertPage(): Boolean {
        return remoteConfig.getBoolean(hide_ask_an_expert_page)
    }

    fun getIsToHideDoctorSays(): Boolean {
        return remoteConfig.getBoolean(hide_doctor_says)
    }

    fun getIsToHideDiagnosticTest(): Boolean {
        return remoteConfig.getBoolean(hide_diagnostic_test)
    }

    fun getIsToHideEngageDiscoverComments(): Boolean {
        return remoteConfig.getBoolean(hide_engage_discover_comments)
    }

    fun getIsToHideIncidentSurvey(): Boolean {
        return remoteConfig.getBoolean(hide_incident_survey)
    }

    fun getIsToHideHomeChatBubble(): Boolean {
        return remoteConfig.getBoolean(hide_home_chat_bubble)
    }

    fun getIsToHideHomeChatBubbleHC(): Boolean {
        return remoteConfig.getBoolean(hide_home_chat_bubble_hc)
    }

    fun getIsToHideHomeMyDevice(): Boolean {
        return remoteConfig.getBoolean(hide_home_my_device)
    }

    fun getIsToHideHomeBca(): Boolean {
        return remoteConfig.getBoolean(hide_home_bca)
    }

    fun getIsToHideHomeSpirometer(): Boolean {
        return remoteConfig.getBoolean(hide_home_spirometer)
    }

    fun getIsToHideDiscountOnLabtest(): Boolean {
        return remoteConfig.getBoolean(hide_discount_on_labtest)
    }

    fun getIsToHideDiscountOnPlan(): Boolean {
        return remoteConfig.getBoolean(hide_discount_on_plan)
    }

    fun getIsHomeFromReactNative(): Boolean {
        return remoteConfig.getBoolean(home_from_react_native)
    }

    companion object {

        val TAG = FirebaseConfigUtil::class.java.simpleName.toString()

        /*Azure UAT Key Names ==> This is actual UAT keys now as domain swapped*/
        const val azure_access_key_prod = "azure_access_key_prod"
        const val azure_account_name_prod = "azure_account_name_prod"

        /*Azure PROD Key Names ==> This is actual Production keys now as domain swapped*/
        const val azure_access_key_live = "azure_access_key_live"
        const val azure_account_name_live = "azure_account_name_live"

        /*Azure Dev Key Names*/
        const val azure_access_key_dev = "azure_access_key_dev"
        const val azure_account_name_dev = "azure_account_name_dev"

        /*Razorpay Payment Live Key Names*/
        const val razorpay_key_id_live = "razorpay_key_id_live"
        const val razorpay_secret_live = "razorpay_secret_live"

        /*Razorpay Payment Dev(Sandbox) Key Names*/
        const val razorpay_key_id_test = "razorpay_key_id_test"
        const val razorpay_secret_test = "razorpay_secret_test"


        /*Firebase Flags*/
        const val hide_chatbot = "hide_chatbot" // FAQs, chat dialog
        const val hide_language_page = "hide_language_page" // main, my profile
        const val hide_engage_page = "hide_engage_page" // main, coach-mark, search
        const val hide_leave_query = "hide_leave_query" // FAQs
        const val hide_email_at = "hide_email_at" // FAQs

        /*New Added Firebase Flags*/
        const val hide_ask_an_expert_page = "hide_ask_an_expert_page" // main, coach-mark, search
        const val hide_doctor_says = "hide_doctor_says" // home
        const val hide_diagnostic_test = "hide_diagnostic_test" // home, menu, history, search
        const val hide_engage_discover_comments =
            "hide_engage_discover_comments" // list, details

        const val hide_incident_survey = "hide_incident_survey"//care-plan, history

        /* New Added Firebase Flags - Sprint April1 */
        const val hide_home_chat_bubble = "hide_home_chat_bubble"//for ChatBoat Icon in home
        const val hide_home_chat_bubble_hc = "hide_home_chat_bubble_hc"//ChatBoat Header


        /* New Added Firebase Flags - Sprint May3 for my devices */
        const val hide_home_my_device = "hide_home_my_device"//Home my device full section
        const val hide_home_bca = "hide_home_bca"//Home BCA device
        const val hide_home_spirometer = "hide_home_spirometer"//Home Spirometer device

        /* New Added Firebase Flags - Sprint 2023 Sep1 for discounts */
        const val hide_discount_on_labtest = "hide_discount_on_labtest"//Lab-test booking discount
        const val hide_discount_on_plan = "hide_discount_on_plan"//Plan purchase discount

        /* New Added Firebase Flags - For Toggle UJ 4 Home - if true, redirection will be done by RN team, else native home for false */
        const val home_from_react_native = "home_from_react_native"

        var instance: FirebaseConfigUtil? = null
        fun getInstance(activity: BaseActivity): FirebaseConfigUtil {
            if (instance == null) {
                synchronized(FirebaseConfigUtil::class.java) {
                    if (instance == null) {
                        instance = FirebaseConfigUtil(activity)
                    }
                }
            }
            return instance!!
        }
    }

}