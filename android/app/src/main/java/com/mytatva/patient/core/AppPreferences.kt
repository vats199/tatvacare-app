package com.mytatva.patient.core

import android.annotation.SuppressLint
import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.data.pojo.response.SignUpOnboardingData
import com.mytatva.patient.data.pojo.response.UpdateDeviceInfoResData

import javax.inject.Inject
import javax.inject.Singleton

/**
 * Created by hlink21 on 31/5/16.
 */
@Singleton
class AppPreferences @Inject
constructor(context: Context) {

    companion object {
        const val SHARED_PREF_NAME_USER = "my_tatva_app_user_preference"
        const val SHARED_PREF_NAME_COMMON = "my_tatva_app_common_preference"
    }

    private val sharedPreferencesUserSession: SharedPreferences =
        context.getSharedPreferences(SHARED_PREF_NAME_USER, Context.MODE_PRIVATE)
    private val sharedPreferencesCommon: SharedPreferences =
        context.getSharedPreferences(SHARED_PREF_NAME_COMMON, Context.MODE_PRIVATE)

    @SuppressLint("CommitPrefEdits")
    fun putString(name: String, value: String) {
        val editor = sharedPreferencesUserSession.edit()
        editor!!.putString(name, value)
        editor.apply()
    }

    @SuppressLint("CommitPrefEdits")
    fun putBoolean(name: String, value: Boolean) {
        val editor = sharedPreferencesUserSession.edit()
        editor!!.putBoolean(name, value)
        editor.apply()
    }

    fun getBoolean(name: String): Boolean {
        return sharedPreferencesUserSession.getBoolean(name, false)
    }

    fun getString(name: String): String {
        return sharedPreferencesUserSession.getString(name, "") ?: ""
    }

    fun getInt(name: String): Int {
        return sharedPreferencesUserSession.getInt(name, 0)
    }


    fun clearAll() {
        sharedPreferencesUserSession.edit()
            .clear()
            .apply()
    }

    fun putFloat(name: String, value: Float) {
        val editor = sharedPreferencesUserSession.edit()
        editor!!.putFloat(name, value)
        editor.apply()
    }

    fun getFloat(name: String): Float {
        return sharedPreferencesUserSession.getFloat(name, 0f)
    }

    /**
     * common pref methods
     */
    fun setIsToHideLanguagePage(isEnable: Boolean) {
        val editor = sharedPreferencesCommon.edit()
        editor!!.putBoolean(Common.IS_TO_HIDE_LANGUAGE_PAGE, isEnable)
        editor.apply()
    }

    fun isToHideLanguagePage(): Boolean {
        return sharedPreferencesCommon.getBoolean(Common.IS_TO_HIDE_LANGUAGE_PAGE, false)
    }

    fun setBiometricEnabled(isEnable: Boolean) {
        val editor = sharedPreferencesCommon.edit()
        editor!!.putBoolean(Common.IS_BIOMETRIC_ENABLED, isEnable)
        editor.apply()
    }

    fun isBiometricEnabled(): Boolean {
        return sharedPreferencesCommon.getBoolean(Common.IS_BIOMETRIC_ENABLED, false)
    }

    fun setToOpenLoginStep(isEnable: Boolean) {
        val editor = sharedPreferencesCommon.edit()
        editor!!.putBoolean(Common.IS_TO_OPEN_LOGIN_STEP, isEnable)
        editor.apply()
    }

    fun isToOpenLoginStep(): Boolean {
        return sharedPreferencesCommon.getBoolean(Common.IS_TO_OPEN_LOGIN_STEP, false)
    }

    fun setCoachMarksCompleted(isCompleted: Boolean) {
        val editor = sharedPreferencesCommon.edit()
        editor!!.putBoolean(Common.IS_COACHMARKS_COMPLETED, isCompleted)
        editor.apply()
    }

    fun isCoachMarksCompleted(): Boolean {
        return sharedPreferencesCommon.getBoolean(Common.IS_COACHMARKS_COMPLETED, false)
    }

    @SuppressLint("CommitPrefEdits")
    fun putStringCommon(name: String, value: String) {
        val editor = sharedPreferencesCommon.edit()
        editor!!.putString(name, value)
        editor.apply()
    }

    fun getStringCommon(name: String): String {
        return sharedPreferencesCommon.getString(name, "") ?: ""
    }

    fun setAppUnderMaintenance(isCompleted: Boolean) {
        val editor = sharedPreferencesCommon.edit()
        editor!!.putBoolean(Common.IS_APP_UNDER_MAINTENANCE, isCompleted)
        editor.apply()
    }

    fun isAppUnderMaintenance(): Boolean {
        return sharedPreferencesCommon.getBoolean(Common.IS_APP_UNDER_MAINTENANCE, false)
    }

    private val gson: Gson = Gson()
    var updateDeviceInfoResData: UpdateDeviceInfoResData? = null
        get() {
            if (field == null) {
                val updateDeviceInfoDataJson =
                    getStringCommon(AppSession.UPDATE_DEVICE_INFO_DATA_JSON)
                field = gson.fromJson(updateDeviceInfoDataJson, UpdateDeviceInfoResData::class.java)
            }
            return field
        }
        set(value) {
            field = value
            val updateDeviceInfoDataJson = gson.toJson(value)
            if (updateDeviceInfoDataJson != null)
                putStringCommon(AppSession.UPDATE_DEVICE_INFO_DATA_JSON, updateDeviceInfoDataJson)
        }

    var onBoardingList: ArrayList<SignUpOnboardingData>? = null
        get() {
            if (field == null) {
                val myType = object : TypeToken<List<SignUpOnboardingData>>() {}.type
                val onBoardingListDataJson =
                    getStringCommon(AppSession.ONBOARDING_DATA)
                field = gson.fromJson(onBoardingListDataJson, myType)
            }
            return field
        }
        set(value) {
            field = value
            val onBoardingListDataJson = gson.toJson(value)
            if (onBoardingListDataJson != null)
                putStringCommon(AppSession.ONBOARDING_DATA, onBoardingListDataJson)
        }

    fun setCurrentAppVersionCode() {
        val editor = sharedPreferencesCommon.edit()
        editor!!.putInt(Common.APP_VERSION_CODE, BuildConfig.VERSION_CODE)
        editor.apply()
    }

    fun getCurrentAppVersionCode(): Int {
        return sharedPreferencesCommon.getInt(Common.APP_VERSION_CODE, 0)
    }
}
