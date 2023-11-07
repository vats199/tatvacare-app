package com.mytatva.patient.ui.auth.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.gson.Gson
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.CatSurveyData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.databinding.AuthFragmentSetupGoalsReadingsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.auth.adapter.SetupGoalsAdapter
import com.mytatva.patient.ui.auth.adapter.SetupReadingsAdapter
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingsMainFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.SafeClickListener
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.surveysparrow.ss_android_sdk.SurveySparrow
import org.json.JSONArray
import java.util.*
import java.util.concurrent.TimeUnit


class SetupGoalsReadingsFragment : BaseFragment<AuthFragmentSetupGoalsReadingsBinding>() {

    private var isToRefreshReadingsAfterAddLog = false

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    var resumedTime = Calendar.getInstance().timeInMillis

    private val goalsList = arrayListOf<GoalReadingData>()

    private val setupGoalsAdapter by lazy {
        SetupGoalsAdapter((requireActivity() as BaseActivity),
            goalsList,
            adapterListener = object : SetupGoalsAdapter.AdapterListener {
                override fun onClick(position: Int) {

                    /*if (isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs,
                            goalsList[position].goal_master_id ?: "")
                    ) {

                        navigator.loadActivity(TransparentActivity::class.java,
                            UpdateGoalLogsFragment::class.java)
                            .addBundle(bundleOf(
                                Pair(Common.BundleKey.POSITION, position),
                                Pair(Common.BundleKey.GOAL_LIST, goalsList)
                            )).start()

                    }*/
                }

                override fun showMessage(message: String) {
                    this@SetupGoalsReadingsFragment.showMessage(message)
                }

                override fun hideKeyboard() {
                    try {
                        this@SetupGoalsReadingsFragment.hideKeyBoard()
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            })
    }

    private val readingList = arrayListOf<GoalReadingData>()/*.apply {
        add(TempDataModel(name = "Heart rate"))
        add(TempDataModel(name = "Lung function"))
    }*/

    private val setupReadingsAdapter by lazy {
        SetupReadingsAdapter((requireActivity() as BaseActivity),
            readingList,
            object : SetupReadingsAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    navigateToLogReading(position)
                }
            })
    }

    private fun navigateToLogReading(position: Int) {
        if (readingList[position].not_configured.isNullOrBlank().not()) {
            showMessage(readingList[position].not_configured ?: "")
        } else {
            if (isFeatureAllowedAsPerPlan(
                    PlanFeatures.reading_logs,
                    readingList[position].keys ?: ""
                )
            ) {//

                if (readingList[position].keys == Readings.CAT.readingKey) {
                    getCatSurvey()
                } else {
                    isToRefreshReadingsAfterAddLog = true
                    navigator.loadActivity(
                        TransparentActivity::class.java,
                        UpdateReadingsMainFragment::class.java
                    )
                        .addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.POSITION, position),
                                Pair(Common.BundleKey.READING_LIST, readingList)
                            )
                        ).start()
                }

            }
        }
    }

    var catSurveyData: CatSurveyData? = null
    var catReadingName = ""
    var catReadingMasterId = ""

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_SET_GOALS, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.SetUpGoalsReadings)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSetupGoalsReadingsBinding {
        return AuthFragmentSetupGoalsReadingsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SetUpGoalsReadings)
        resumedTime = Calendar.getInstance().timeInMillis

        if (isToRefreshReadingsAfterAddLog) {
            isToRefreshReadingsAfterAddLog = false
            medicalConditionReadingPatientRelList()
        }
    }

    override fun onBackActionPerform(): Boolean {
        if (activity is AuthActivity) {
            // go back without saving on signup flow
            return true
        } else {
            callAPIAndHandleNavigation(true)
            return false
        }
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListeners()
        medialConditionGoalPatientRelList()
        setUpUI()
        /*medicalConditionReadingPatientRelList()*/
    }

    private fun setUpUI() {
        binding.apply {
            if (activity is AuthActivity) {
                buttonCompleteSetUp.text =
                    getString(R.string.setup_goal_reading_button_complete_setup)
            } else {
                buttonCompleteSetUp.text = getString(R.string.setup_goal_reading_button_submit)
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewGoals.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = setupGoalsAdapter
        }

        binding.recyclerViewReadings.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = setupReadingsAdapter
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewBack.setOnClickListener { onViewClick(it) }
            textViewAddMoreGoal.setOnClickListener { onViewClick(it) }
            textViewAddMoreReadings.setOnClickListener { onViewClick(it) }
            buttonCompleteSetUp.setOnClickListener(SafeClickListener { onViewClick(it) })
            imageViewInfo.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewInfo -> {
                navigator.showAlertDialog(getString(R.string.message_goal_info))
            }

            R.id.imageViewBack -> {
                navigator.goBack()
            }

            R.id.textViewAddMoreGoal -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    SelectGoalsReadingsFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.IS_GOAL, true),
                            Pair(Common.BundleKey.SELECTED_GOAL, goalsList)
                        )
                    )
                    .forResult(Common.RequestCode.REQUEST_SELECT_GOAL).start()
            }

            R.id.textViewAddMoreReadings -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    SelectGoalsReadingsFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.IS_GOAL, false),
                            Pair(Common.BundleKey.SELECTED_READING, readingList)
                        )
                    )
                    .forResult(Common.RequestCode.REQUEST_SELECT_READING).start()
            }

            R.id.buttonCompleteSetUp -> {
                callAPIAndHandleNavigation()
            }
        }
    }

    private fun callAPIAndHandleNavigation(isFromBack: Boolean = false) {
        if (isFromBack) {
            if (goalsList.isNotEmpty() && readingList.isNotEmpty()) {
                addReadingGoal()
            } else {
                requireActivity().finish()
            }
        } else {
            if (goalsList.isEmpty()) {
                showMessage(getString(R.string.validation_add_goal))
            } else if (readingList.isEmpty()) {
                showMessage(getString(R.string.validation_add_reading))
            } else {
                addReadingGoal()
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (data != null && resultCode == Activity.RESULT_OK) {
            if (requestCode == Common.RequestCode.REQUEST_SELECT_GOAL) {
                //single selection
                /*val goalReadingData =
                    data.getParcelableExtra<GoalReadingData>(Common.BundleKey.SELECTED_GOAL)
                if (goalsList.any { it.goal_master_id == goalReadingData?.goal_master_id }.not()) {
                    goalReadingData?.let { goalsList.add(it) }
                    setupGoalsAdapter.notifyItemInserted(goalsList.lastIndex)
                }*/

                // multi selection
                val goalReadingDataList =
                    data.getParcelableArrayListExtra<GoalReadingData>(Common.BundleKey.SELECTED_GOAL)
                goalsList.clear()
                goalReadingDataList?.let { goalsList.addAll(it) }
                setupGoalsAdapter.notifyDataSetChanged()

            } else if (requestCode == Common.RequestCode.REQUEST_SELECT_READING) {
                //single selection
                /*val goalReadingData =
                    data.getParcelableExtra<GoalReadingData>(Common.BundleKey.SELECTED_READING)
                if (readingList.any { it.readings_master_id == goalReadingData?.readings_master_id }
                        .not()) {
                    goalReadingData?.let { readingList.add(it) }
                    setupReadingsAdapter.notifyItemInserted(readingList.lastIndex)
                }*/

                // multi selection
                val goalReadingDataList =
                    data.getParcelableArrayListExtra<GoalReadingData>(Common.BundleKey.SELECTED_READING)
                readingList.clear()
                goalReadingDataList?.let { readingList.addAll(it) }
                setupReadingsAdapter.notifyDataSetChanged()

                //to save readings and after save need to refresh readings
                addReadingGoal(isToRefreshData = true)
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun medialConditionGoalPatientRelList() {
        showLoader()
        val apiRequest = ApiRequest()
        authViewModel.medialConditionGoalPatientRelList(apiRequest)
    }

    private fun medicalConditionReadingPatientRelList() {
        showLoader()
        val apiRequest = ApiRequest()
        authViewModel.medicalConditionReadingPatientRelList(apiRequest)
    }

    var isToRefreshData: Boolean = false
    private fun addReadingGoal(isToRefreshData: Boolean = false) {
        this.isToRefreshData = isToRefreshData

        val apiRequest = ApiRequest()
        //goals
        val goals = arrayListOf<ApiRequestSubData>()
        goalsList.forEach {
            val apiRequestSubData = ApiRequestSubData().apply {
                goal_id = it.goal_master_id
                goal_value = it.goal_value
                /*start_date = "2021-09-22"
                end_date = "2021-09-22"*/
                mandatory = it.mandatory
            }
            goals.add(apiRequestSubData)
        }
        apiRequest.goals = goals


        //readings
        val readings = arrayListOf<ApiRequestSubData>()
        readingList.forEach {
            val apiRequestSubData = ApiRequestSubData().apply {
                reading_id = it.readings_master_id
                /*reading_datetime = "2021-09-22 15:15:15"*/
                /*reading_value = it.reading_value*/
                mandatory = it.mandatory
            }
            readings.add(apiRequestSubData)
        }
        apiRequest.readings = readings

        showLoader()
        authViewModel.addReadingGoal(apiRequest)
    }

    private fun getCatSurvey() {
        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.getCatSurvey(apiRequest)
    }

    private fun addCatSurvey(surveyResponse: JSONArray, score: String) {
        val list = arrayListOf<ApiRequestSubData>()
        list.addAll(
            Gson().fromJson(surveyResponse.toString(), Array<ApiRequestSubData>::class.java)
                .toList()
        )

        val apiRequest = ApiRequest().apply {
            survey_id = catSurveyData?.survey_id
            response = list
            this.score = score
            cat_survey_master_id = catSurveyData?.cat_survey_master_id
        }
        showLoader()
        goalReadingViewModel.addCatSurvey(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.medialConditionGoalPatientRelListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                goalsList.clear()
                responseBody.data?.let { goalsList.addAll(it) }
                setupGoalsAdapter.notifyDataSetChanged()

                medicalConditionReadingPatientRelList()
            },
            onError = { throwable ->
                hideLoader()
                medicalConditionReadingPatientRelList()
                throwable is ServerException
            })

        authViewModel.medicalConditionReadingPatientRelListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                readingList.clear()
                responseBody.data?.let { readingList.addAll(it) }
                setupReadingsAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.addReadingGoalLiveData.observe(this, onChange = { responseBody ->

            if (isToRefreshData) {

                medicalConditionReadingPatientRelList()

            } else {
                hideLoader()

                goalsList.forEach {
                    analytics.logEvent(analytics.GOAL_TARGET_VALUE_UPDATED, Bundle().apply {
                        putString(analytics.PARAM_GOAL_ID, it.goal_master_id)
                        putString(analytics.PARAM_GOAL_NAME, it.goal_name)
                        putString(analytics.PARAM_GOAL_VALUE, it.goal_value)
                    }, screenName = AnalyticsScreenNames.SetUpGoalsReadings)
                }

                if (activity is AuthActivity) {
                    analytics.logEvent(
                        analytics.NEW_USER_GOALS_READINGS,
                        screenName = AnalyticsScreenNames.SetUpGoalsReadings
                    )
                    //analytics.logEvent(analytics.NEW_USER_READING)
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        ProfileSetupSuccessFragment::class.java
                    ).byFinishingAll().start()
                } else {
                    analytics.logEvent(
                        analytics.USER_CHANGED_GOALS_READINGS,
                        screenName = AnalyticsScreenNames.SetUpGoalsReadings
                    )
                    //analytics.logEvent(analytics.USER_CHANGED_MARKER)
                    requireActivity().finish()
                }

            }
        }, onError = { throwable ->
            hideLoader()
            true
        })


        goalReadingViewModel.getCatSurveyLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                it.survey_id?.let { it1 ->
                    catReadingMasterId = it.readings_master_id ?: ""
                    catReadingName = it.reading_name ?: ""
                    catSurveyData = it
                    requireActivity().runOnUiThread {
                        initSurvey(it1)
                    }
                }
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        goalReadingViewModel.addCatSurveyLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                putString(analytics.PARAM_READING_NAME, catReadingName)
                putString(analytics.PARAM_READING_ID, catReadingMasterId)
            }, screenName = AnalyticsScreenNames.LogReading)
        }, onError = { throwable ->
            hideLoader()
            true
        })
    }


    /**
     * *****************************************************
     * Response handling methods
     * *****************************************************
     */
    private fun initSurvey(surveyToken: String) {
        surveyUtil.initSurvey(surveyToken) { isSuccess: Boolean, data: Intent?, message: String ->
            if (isSuccess && data != null) {

                val response = SurveySparrow.toJSON(data.data.toString())
                try {
                    val responseData: JSONArray? =
                        if (response.has("response")) response.getJSONArray("response")
                        else null

                    val type = if (response.has("type")) {
                        response.getString("type")
                    } else ""

                    val score = if (response.has("score")) {
                        response.getString("score")
                    } else "0"

                    if (catSurveyData != null) {
                        // add cat survey data
                        Log.e("catData", "::$responseData")
                        responseData?.let { addCatSurvey(it, score) }
                    }

                } catch (e: Exception) {
                    e.printStackTrace()
                }
            } else {
                Log.e("Response", "::$message")
            }
        }
    }
}