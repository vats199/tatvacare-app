package com.mytatva.patient.core


import android.content.Context
import com.google.firebase.messaging.FirebaseMessaging
import com.google.gson.Gson
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.ui.reading.ReadingMinMax
import javax.inject.Inject
import javax.inject.Named
import javax.inject.Singleton

/**
 * Created by hlink21 on 11/7/16.
 */
@Singleton
class AppSession @Inject
constructor(
    private val appPreferences: AppPreferences,
    private val context: Context,
    @param:Named("api-key") override var apiKey: String,
) : Session {

    private val gson: Gson = Gson()

    override var user: User? = null
        get() {
            if (field == null) {
                val userJSON = appPreferences.getString(USER_JSON)
                field = gson.fromJson(userJSON, User::class.java)
            }
            return field
        }
        set(value) {
            field = value
            val userJson = gson.toJson(value)
            value?.let {
                ReadingMinMax.updateMinMaxValues(it)
            }
            if (userJson != null)
                appPreferences.putString(USER_JSON, userJson)
        }

//    override var authUser: AuthUser? = null
//        get() {
//            if (field == null) {
//                val userJSON = appPreferences.getString(AUTH_USER_JSON)
//                field = gson.fromJson(userJSON, AuthUser::class.java)
//            }
//            return field
//        }
//        set(value) {
//            field = value
//            val userJson = gson.toJson(value)
//            if (userJson != null)
//                appPreferences.putString(AUTH_USER_JSON, userJson)
//        }


    /*override var updateDeviceInfoResData: UpdateDeviceInfoResData? = null
         get() {
             if (field == null) {
                 val updateDeviceInfoDataJson = appPreferences.getStringCommon(UPDATE_DEVICE_INFO_DATA_JSON)
                 field = gson.fromJson(updateDeviceInfoDataJson, UpdateDeviceInfoResData::class.java)
             }
             return field
         }
         set(value) {
             field = value
             val updateDeviceInfoDataJson = gson.toJson(value)
             if (updateDeviceInfoDataJson != null)
                 appPreferences.putStringCommon(UPDATE_DEVICE_INFO_DATA_JSON, updateDeviceInfoDataJson)
         }*/

    override var userSession: String
        get() = appPreferences.getString(Session.USER_SESSION)
        set(userSession) {
            // clear authUserSession, when get main user session
            authUserSession = ""

            appPreferences.putString(Session.USER_SESSION, userSession)
        }

    override var authUserSession: String
        get() = appPreferences.getString(Session.AUTH_USER_SESSION)
        set(userSession) = appPreferences.putString(Session.AUTH_USER_SESSION, userSession)

    override var userId: String
        get() = appPreferences.getString(Session.USER_ID)
        set(userId) = appPreferences.putString(Session.USER_ID, userId)

    override/* open below comment after Firebase integration */
    var deviceId: String
        get() = appPreferences.getString(Session.DEVICE_ID)
        set(deviceId) = appPreferences.putString(Session.DEVICE_ID, deviceId)
    /*get() {
        val token: String? = Settings.Secure.getString(context.contentResolver,
                Settings.Secure.ANDROID_ID)
        return token ?: ""
    }*/

    override var imageURL: String?
        get() = appPreferences.getString(Session.IMAGE_URL)
        set(value) {
            appPreferences.putString(Session.IMAGE_URL, value ?: "")
        }

    override fun getFirebaseDeviceId(callback: (deviceID: String) -> Unit) {
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                deviceId = task.result
                callback.invoke(task.result)
            } else {
                callback.invoke("")
            }
        }
    }

    //firebase instance id - device wise unique
    override var deviceFID: String
        get() = appPreferences.getString(Session.DEVICE_FID)
        set(deviceId) = appPreferences.putString(Session.DEVICE_FID, deviceId)

    override//  return StringUtils.equalsIgnoreCase(appPreferences.getString(Common.LANGUAGE), "ar") ? LANGUAGE_ARABIC : LANGUAGE_ENGLISH;
    val language: String
        get() = "en"

    override var selectedLanguageId: String
        get() = appPreferences.getString(Session.LANGUAGE_ID)
        set(userId) = appPreferences.putString(Session.LANGUAGE_ID, userId)

    override fun clearSession() {
        appPreferences.clearAll()
    }

    companion object {
        const val CART_JSON = "cart_json"
        const val USER_JSON = "user_json"
        const val AUTH_USER_JSON = "auth_user_json"
        const val UPDATE_DEVICE_INFO_DATA_JSON = "updateDeviceInfoDataJson"
        const val ONBOARDING_DATA = "onboardingData"
    }
}