package com.mytatva.patient.utils.firebaselink

import android.net.Uri
import com.mytatva.patient.utils.URLEncodeDecode
import com.mytatva.patient.utils.firebaselink.FirebaseLink.Values.accessCode
import com.mytatva.patient.utils.firebaselink.FirebaseLink.Values.accessFrom
import com.mytatva.patient.utils.firebaselink.FirebaseLink.Values.doctorAccessCode

object FirebaseLink {

    object Params {
        /*
        https://mytatva.page.link/?link=https://mytatva.com/&operation=signup_link_doctor&doctor_access_code=A1B2C3&access_code=924924330&apn=com.mytatva.patient&ibi=com.hyperlink.mytatva&d=1
         */

        const val LINK = "link"
        const val OPERATION = "operation"
        const val DOCTOR_ACCESS_CODE = "doctor_access_code"
        const val ACCESS_CODE = "access_code"
        const val CONTENT_MASTER_ID = "content_master_id"
        const val LAB_TEST_ID = "lab_test_id"
        const val ORDER_MASTER_ID = "order_master_id"
        const val PLAN_MASTER_ID = "plan_master_id"

        const val APN = "apn"
        const val IBI = "ibi"
        const val D = "d"

        const val SCREEN_NAME = "screen_name"
        const val SCREEN_SECTION = "screen_section"
        const val GOAL_KEY = "goal_key"

        const val PLAN_NAME = "plan_name"
        const val PLAN_TYPE = "plan_type"
        const val EXERCISE_PLAN_DAY_ID = "exercise_plan_day_id"
        const val SELECTION = "selection"
        //const val EXERCISE_ADDED_BY = "exercise_added_by"

        const val CONTENT_TYPE = "content_type"


        const val CONTACT_NO = "contact_no"


    }

    object Operation {
        /**
         * Operation - SIGNUP_LINK_DOCTOR
         * @params - access_code,doctor_access_code
         * @description - to sign up with adding this doctor in patient registration automatically and patient is present in the Link Patient Module
         */
        const val SIGNUP_LINK_DOCTOR = "signup_link_doctor"

        /**
         * Operation - CONTENT
         * @params - content_master_id
         * @description - to open content details
         */
        const val CONTENT = "content"

        /**
         * Operation - SCREEN_NAV
         * @params - screen_name refer
         * @description - to open specific screen
         */
        const val SCREEN_NAV = "screen_nav"
    }

    object AccessFrom {
        // AccessFrom - It's Patient registration types, default will be Doctor
        const val LinkPatient = "LinkPatient"
        const val Doctor = "Doctor"
    }

    object Values {
        var accessCode: String? = null
        var doctorAccessCode: String? = null

        // param to pass in registration API to check registered by link patient or by doctor code only
        var accessFrom: String = AccessFrom.Doctor
    }


    fun clearValues() {
        accessCode = null
        doctorAccessCode = null
        accessFrom = AccessFrom.Doctor
    }

    /*fun handleSignUpLinkDoctorOperationDeepLink(deepLink: Uri) {

        if (deepLink.queryParameterNames?.contains(FirebaseLink.Params.CONTACT_NO) == true) {

            // deep link of doctor
            FirebaseLink.Values.accessFrom = AccessFrom.Doctor
            FirebaseLink.Values.accessCode = deepLink.getQueryParameter(Params.ACCESS_CODE)

        } else {

            // deep link of link patient
            if (deepLink.queryParameterNames?.contains(Params.ACCESS_CODE) == true
                && deepLink.queryParameterNames?.contains(Params.DOCTOR_ACCESS_CODE) == true
            ) {
                FirebaseLink.Values.accessFrom = AccessFrom.LinkPatient
                FirebaseLink.Values.accessCode =
                    deepLink.getQueryParameter(Params.ACCESS_CODE)
                FirebaseLink.Values.doctorAccessCode =
                    deepLink.getQueryParameter(Params.DOCTOR_ACCESS_CODE)
            }

        }

    }*/


    fun handleSignUpLinkDoctorOperationDeepLinkWithResult(deepLink: Uri): Boolean {

        if (deepLink.queryParameterNames?.contains(Params.ACCESS_CODE) == true
            && deepLink.queryParameterNames?.contains(Params.DOCTOR_ACCESS_CODE) == true
        ) {

            // deep link of link patient
            FirebaseLink.Values.accessFrom = AccessFrom.LinkPatient
            FirebaseLink.Values.accessCode =
                deepLink.getQueryParameter(Params.ACCESS_CODE)
            FirebaseLink.Values.doctorAccessCode =
                deepLink.getQueryParameter(Params.DOCTOR_ACCESS_CODE)
            return true

        } else if (deepLink.queryParameterNames?.contains(FirebaseLink.Params.ACCESS_CODE) == true) {

            // deep link of doctor
            FirebaseLink.Values.accessFrom = AccessFrom.Doctor
            FirebaseLink.Values.accessCode = deepLink.getQueryParameter(Params.ACCESS_CODE)
            return true

        } else {
            return false
        }

        /*if (deepLink.queryParameterNames?.contains(FirebaseLink.Params.CONTACT_NO) == true
            && deepLink.queryParameterNames?.contains(FirebaseLink.Params.ACCESS_CODE) == true
        ) {
            
            // deep link of doctor
            FirebaseLink.Values.accessFrom = AccessFrom.Doctor
            FirebaseLink.Values.accessCode = deepLink.getQueryParameter(Params.ACCESS_CODE)
            return true

        } else if (deepLink.queryParameterNames?.contains(Params.ACCESS_CODE) == true
            && deepLink.queryParameterNames?.contains(Params.DOCTOR_ACCESS_CODE) == true
        ) {

            // deep link of link patient
            FirebaseLink.Values.accessFrom = AccessFrom.LinkPatient
            FirebaseLink.Values.accessCode =
                deepLink.getQueryParameter(Params.ACCESS_CODE)
            FirebaseLink.Values.doctorAccessCode =
                deepLink.getQueryParameter(Params.DOCTOR_ACCESS_CODE)
            return true

        } else {
            return false
        }*/

    }

    fun getDeepLinkFromWEActionLink(actionLink: String): String? {
        val ACTION_LINK_PREFIX = "w://p/open_url_in_browser/"
        try {
            if (actionLink.contains(ACTION_LINK_PREFIX)) {
                val encodedDeepLink = actionLink.substring(ACTION_LINK_PREFIX.length)
                return URLEncodeDecode.decode(encodedDeepLink)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }

}