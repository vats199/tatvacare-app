package com.mytatva.patient.core


import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.response.Cart


/**
 * Created by hlink21 on 11/7/16.
 */
public interface Session {

    var apiKey: String

    var userSession: String
    var authUserSession: String

    var userId: String

    var deviceId: String

    var imageURL: String?

    fun getFirebaseDeviceId(callback: (deviceID: String) -> Unit)

    var deviceFID: String

    var user: User?
    //var authUser: AuthUser?

    var cart: Cart?

    //var updateDeviceInfoResData: UpdateDeviceInfoResData?

    val language: String

    var selectedLanguageId: String

    fun clearSession()

    companion object {
        const val API_KEY = "api-key"
        const val USER_SESSION = "TOKEN"
        const val AUTH_USER_SESSION = "signup_token"
        const val LANGUAGE = "accept-language"
        const val CONTENT_TYPE = "content-type"
        const val USER_ID = "USER_ID"
        const val DEVICE_TYPE = "A"
        const val CURRENT_DATETIME = "current_datetime"

        // "accept-language" : "en",
//  "content-type" : "text\/plain"
        const val LANGUAGE_ID = "language_id"

        const val DEVICE_ID = "device_id"

        //firebase instance id - device wise unique
        const val DEVICE_FID = "fid"

        const val IMAGE_URL = "imageUrl"
    }
}
