package com.mytatva.patient.ui.careplan.fragment

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.google.gson.Gson
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Common.RequestCode.REQUEST_INCIDENT_SURVEY
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.IncidentSurveyData
import com.mytatva.patient.databinding.CarePlanFragmentAddIncidentBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.surveysparrow.ss_android_sdk.SurveySparrow
import org.json.JSONArray

class AddIncidentFragment : BaseFragment<CarePlanFragmentAddIncidentBinding>() {

    //var incidentSurveyData: IncidentSurveyData? = null

    private val incidentSurveyData: IncidentSurveyData? by lazy {
        arguments?.getParcelable(Common.BundleKey.INCIDENT_SURVEY_DATA)
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanFragmentAddIncidentBinding {
        return CarePlanFragmentAddIncidentBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AddIncident)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpViewListeners()
        //getIncidentSurvey()
    }

    private fun setUpViewListeners() {
        with(binding) {
            imageViewClose.setOnClickListener { onViewClick(it) }
            buttonYes.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewClose -> {
                navigator.goBack()
            }
            R.id.buttonYes -> {
                initSurvey()
            }
        }
    }

    /*
     *
     */
    private fun initSurvey() {
        if (incidentSurveyData?.survey_id.isNullOrBlank().not()) {

            surveyUtil.initSurvey(incidentSurveyData?.survey_id!!) { isSuccess: Boolean, data: Intent?, message: String ->
                if (isSuccess && data != null) {

                    val response = SurveySparrow.toJSON(data?.data.toString())
                    try {
                        val responseData = response.getJSONArray("response")
                        addIncidentDetails(responseData)
                        Handler(Looper.getMainLooper())
                            .postDelayed({
                                navigator.goBack()
                            }, 10)

                        Log.d("Response", "::$responseData")
                    } catch (e: Exception) {

                    }

                } else {
                    Log.d("Response", "::$message")
                }
            }

            /*val survey = SsSurvey(Common.SS_DOMAIN, incidentSurveyData?.survey_id)
            val surveySparrow = SurveySparrow(requireActivity(), survey)
                .setActivityTheme(R.style.AppTheme)
                .setAppBarTitle(R.string.app_name)
                .enableBackButton(true)
                .setWaitTime(2000)
            // Schedule specific config
            //.setStartAfter(TimeUnit.DAYS.toMillis(3L))
            //.setRepeatInterval(TimeUnit.DAYS.toMillis(5L))
            //.setRepeatType(SurveySparrow.REPEAT_TYPE_CONSTANT)
            //.setFeedbackType(SurveySparrow.SINGLE_FEEDBACK)

            surveySparrow.startSurveyForResult(REQUEST_INCIDENT_SURVEY)*/
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_INCIDENT_SURVEY && resultCode == Activity.RESULT_OK) {
            val response = SurveySparrow.toJSON(data?.data.toString())
            try {
                val responseData = response.getJSONArray("response")
                addIncidentDetails(responseData)
                Log.d("Response", "::$responseData")
            } catch (e: Exception) {

            }
        }
    }


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getIncidentSurvey() {
        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.getIncidentSurvey(apiRequest)
    }

    private fun addIncidentDetails(surveyResponse: JSONArray) {
        val list = arrayListOf<ApiRequestSubData>()
        list.addAll(Gson().fromJson(surveyResponse.toString(), Array<ApiRequestSubData>::class.java)
            .toList())

        val apiRequest = ApiRequest().apply {
            survey_id = incidentSurveyData?.survey_id
            response = list
            incident_tracking_master_id = incidentSurveyData?.incident_tracking_master_id
        }
        goalReadingViewModel.addIncidentDetails(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        /*goalReadingViewModel.getIncidentSurveyLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                incidentSurveyData = responseBody.data
            },
            onError = { throwable ->
                hideLoader()
                false
            })*/

        goalReadingViewModel.addIncidentDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                /*navigator.goBack()*/
            },
            onError = { throwable ->
                hideLoader()
                false
            })
    }
}