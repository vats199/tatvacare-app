package com.mytatva.patient.utils.apputils

import com.mytatva.patient.core.AppPreferences
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.di.MyTatvaApp
import com.mytatva.patient.utils.FirebaseConfigUtil


/**
 * AppFlagHandler
 * to handle the flags,
 * that needs to use from firebase config values or from API data
 */
object AppFlagHandler {

    /**
     * isToHideEngagePage
     */
    fun isToHideEngagePage(
        user: User?,
        firebaseConfigUtil: FirebaseConfigUtil,
    ): Boolean {
        return if (MyTatvaApp.IS_TO_USE_FIREBASE_FLAGS) {
            firebaseConfigUtil.getIsToHideEngagePage()
        } else {
            user?.isToHideEngagePage ?: false
        }
    }

    /**
     * isToHideLanguagePage
     */
    fun isToHideLanguagePage(
        appPreferences: AppPreferences,
        firebaseConfigUtil: FirebaseConfigUtil,
    ): Boolean {
        return if (MyTatvaApp.IS_TO_USE_FIREBASE_FLAGS) {
            firebaseConfigUtil.getIsToHideLanguagePage()
        } else {
            appPreferences.isToHideLanguagePage()
        }
    }

    /**
     * isToHideChatBot
     */
    fun isToHideChatBot(
        user: User?,
        firebaseConfigUtil: FirebaseConfigUtil,
    ): Boolean {
        return if (MyTatvaApp.IS_TO_USE_FIREBASE_FLAGS) {
            firebaseConfigUtil.getIsToHideChatBot()
        } else {
            user?.isToHideChatBot ?: false
        }
    }

    /**
     * isToHideLeaveAQuery
     */
    fun isToHideLeaveAQuery(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideLeaveAQuery()
    }

    /**
     * isToHideEmailAt
     */
    fun isToHideEmailAt(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideEmailAt()
    }

    /**
     * isToHideAskAnExpertPage
     */
    fun isToHideAskAnExpertPage(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideAskAnExpertPage()
    }

    /**
     * isToHideDoctorSays
     */
    fun isToHideDoctorSays(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideDoctorSays()
    }

    /**
     * isToHideDiagnosticTest
     */
    fun isToHideDiagnosticTest(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideDiagnosticTest()
    }

    /**
     * isToHideEngageDiscoverComments
     */
    fun isToHideEngageDiscoverComments(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideEngageDiscoverComments()
    }

    /**
     * isToHideIncidentSurvey
     */
    fun isToHideIncidentSurvey(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideIncidentSurvey()
    }

    /**
     * isToHideHomeChatBubble
     */
    fun isToHideHomeChatBubble(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideHomeChatBubble()
    }

    /**
     * isToHideHomeChatBubbleHC
     */
    fun isToHideHomeChatBubbleHC(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideHomeChatBubbleHC()
    }

    /**
     * isToHideHomeChatBubble
     */
    fun getIsToHideHomeMyDevice(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideHomeMyDevice()
    }

    /**
     * isToHideHomeChatBubbleHC
     */
    fun getIsToHideHomeBca(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideHomeBca()
    }

    /**
     * getIsToHideHomeSpirometer
     */
    fun getIsToHideHomeSpirometer(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideHomeSpirometer()
    }

    /**
     * getIsToHideDiscountOnLabtest()
     */
    fun getIsToHideDiscountOnLabtest(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideDiscountOnLabtest()
    }

    /**
     * getIsToHideDiscountOnPlan()
     */
    fun getIsToHideDiscountOnPlan(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsToHideDiscountOnPlan()
    }

    /**
     * getIsToHideDiscountOnPlan()
     */
    fun getIsHomeFromReactNative(firebaseConfigUtil: FirebaseConfigUtil): Boolean {
        return firebaseConfigUtil.getIsHomeFromReactNative()
    }
}