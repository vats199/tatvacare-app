package com.mytatva.patient.utils.surveysparrow

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import com.mytatva.patient.R
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.ui.base.BaseActivity
import com.surveysparrow.ss_android_sdk.SsSurvey
import com.surveysparrow.ss_android_sdk.SurveySparrow
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class SurveyUtil @Inject constructor(val context: Context, val session: Session) {

    //test
    //val ssDomainTest = "hisystem.surveysparrow.com"
    //val ssTokenIncident = "tt-54aa86"
    //val ssTokenQuiz = "tt-584709"

    //hyperlink given by parth sir
    //val ssDomain = "hyperlink.surveysparrow.com"
    //val ssTokenCAT = "tt-763c79"
    //val ssTokenPolls = "tt-b24d3663f8" /*"tt-e86161"*/
    //val incidentToken = "tt-f66473"

    companion object {
        // common SS domain for all Env
        val SS_DOMAIN =
            if (URLFactory.ENVIRONMENT == URLFactory.Env.PRODUCTION
                || URLFactory.ENVIRONMENT == URLFactory.Env.UAT
            )
                "mytatva.surveysparrow.com"
            else
                "mytatva.surveysparrow.com"


        const val REQUEST_SURVEY = 105
    }

    var activity: BaseActivity? = null
    private val TAG = SurveyUtil::class.java.simpleName

    var callback: ((isSuccess: Boolean, data: Intent?, message: String) -> Unit)? = null

    fun initSurvey(
        surveyToken: String,
        callback: (isSuccess: Boolean, data: Intent?, message: String) -> Unit,
    ) {
        this.callback = callback

        val survey = SsSurvey(SS_DOMAIN, surveyToken)
            .addCustomParam("patient_id", session.userId)
            .addCustomParam("patient_name", session.user?.name)
        val surveySparrow = SurveySparrow(activity, survey)
            .setActivityTheme(R.style.AppTheme)
            .setAppBarTitle(R.string.app_name)
            .enableBackButton(true)
            .setWaitTime(20000)

        // Schedule specific config
//            .setStartAfter(TimeUnit.DAYS.toMillis(3L))
//            .setRepeatInterval(TimeUnit.DAYS.toMillis(5L))
//            .setRepeatType(SurveySparrow.REPEAT_TYPE_CONSTANT)
//            .setFeedbackType(SurveySparrow.SINGLE_FEEDBACK)

        surveySparrow.startSurveyForResult(REQUEST_SURVEY)
    }

    /**
     * Handles the result from the survey sparrow
     */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_SURVEY) {
            if (resultCode == Activity.RESULT_OK) {
                Handler(Looper.getMainLooper()).postDelayed({
                    callback?.invoke(true, data, "")
                }, 500)
            } else {
                Handler(Looper.getMainLooper()).postDelayed({
                    callback?.invoke(false, null, "")
                }, 500)
            }
        }
    }

}