package com.mytatva.patient.ui.home.fragment

import android.annotation.SuppressLint
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.transition.TransitionManager
import com.google.common.primitives.Doubles
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks
import com.google.firebase.dynamiclinks.PendingDynamicLinkData
import com.google.gson.Gson
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.*
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.*
import com.mytatva.patient.databinding.HomeFragmentHomeNewBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.fcm.Notification
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.appointment.fragment.AllAppointmentsFragment
import com.mytatva.patient.ui.appointment.fragment.BookAppointmentsFragment
import com.mytatva.patient.ui.auth.fragment.SelectYourLocationFragment
import com.mytatva.patient.ui.auth.fragment.SetupDrugsFragment
import com.mytatva.patient.ui.auth.fragment.SetupGoalsReadingsFragment
import com.mytatva.patient.ui.auth.fragment.SetupHeightWeightFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.careplan.fragment.AddIncidentFragment
import com.mytatva.patient.ui.chat.dialog.ChatListFragment
import com.mytatva.patient.ui.engage.fragment.EngageFeedDetailsFragment
import com.mytatva.patient.ui.engage.fragment.QuestionDetailsFragment
import com.mytatva.patient.ui.exercise.ExercisePlanDetailsNewFragment
import com.mytatva.patient.ui.exercise.PlanDayDetailsNewFragment
import com.mytatva.patient.ui.goal.fragment.FoodDayInsightFragment
import com.mytatva.patient.ui.goal.fragment.FoodDiaryMainFragment
import com.mytatva.patient.ui.goal.fragment.LogFoodFragment
import com.mytatva.patient.ui.goal.fragment.UpdateGoalLogsFragment
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.home.adapter.*
import com.mytatva.patient.ui.home.dialog.ReadingInfoDialog
import com.mytatva.patient.ui.labtest.fragment.LabTestDetailsFragment
import com.mytatva.patient.ui.labtest.fragment.LabTestListFragment
import com.mytatva.patient.ui.menu.dialog.HelpDialog
import com.mytatva.patient.ui.menu.fragment.BookmarksFragment
import com.mytatva.patient.ui.menu.fragment.HelpSupportFAQFragment
import com.mytatva.patient.ui.menu.fragment.HistoryFragment
import com.mytatva.patient.ui.menu.fragment.UploadRecordFragment
import com.mytatva.patient.ui.mydevices.bottomsheet.DeviceInfoConnectBottomSheetDialog
import com.mytatva.patient.ui.mydevices.fragment.MeasureBcaReadingFragment
import com.mytatva.patient.ui.payment.fragment.v1.BcpPurchasedDetailsFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentCarePlanListingFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentPlanDetailsV1Fragment
import com.mytatva.patient.ui.profile.fragment.EditProfileFragment
import com.mytatva.patient.ui.profile.fragment.MyDevicesFragment
import com.mytatva.patient.ui.profile.fragment.MyProfileFragment
import com.mytatva.patient.ui.profile.fragment.NotificationsFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingsMainFragment
import com.mytatva.patient.ui.spirometer.fragment.SpirometerAllReadingsFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import com.mytatva.patient.utils.imagepicker.loadDrawable
import com.mytatva.patient.utils.imagepicker.loadUrl
import com.mytatva.patient.utils.shareText
import com.surveysparrow.ss_android_sdk.SurveySparrow
import kotlinx.coroutines.*
import org.json.JSONArray
import smartdevelop.ir.eram.showcaseviewlib.GuideView
import smartdevelop.ir.eram.showcaseviewlib.config.Gravity
import smartdevelop.ir.eram.showcaseviewlib.listener.GuideListener
import java.util.*
import kotlin.math.roundToInt


class HomeFragment : BaseFragment<HomeFragmentHomeNewBinding>() {
    private val allDailySummaryList = arrayListOf<GoalReadingData>()
    private val dailySummaryList = arrayListOf<GoalReadingData>()
    var notification: Notification? = null
    var hcDevicePlan: HcDevicePlan? = null

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    private val engageContentViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[EngageContentViewModel::class.java]
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    private val devicesList = arrayListOf<MyDevicesData>()
    //MyDevicesData(title = "Spirometer", description = "Last synced on Date & Time",R.drawable.ic_home_smart_scale),)

    private val homeMyDevicesAdapter by lazy {
        HomeMyDeviceAdapter(devicesList, object : HomeMyDeviceAdapter.AdapterListener {
            override fun onLayoutClick(position: Int) {

                analytics.logEvent(
                    analytics.TAP_DEVICE_CARD,
                    Bundle().apply {
                        putString(
                            analytics.PARAM_MEDICAL_DEVICE,
                            Common.MedicalDevice.getDeviceNameFromKey(
                                devicesList[position].key
                                    ?: ""
                            )
                        )
                        putString(
                            analytics.PARAM_SYNC_STATUS,
                            if (devicesList[position].lastSyncDate.isNullOrBlank()) "N" else "Y"
                        )
                    },
                    screenName = AnalyticsScreenNames.Home
                )

                if (devicesList[position].lastSyncDate.isNullOrBlank()) {
                    handleOnConnectClick(position)
                } else {
                    when (devicesList[position].key) {
                        Device.BcaScale.deviceKey -> {
                            navigator.loadActivity(
                                IsolatedFullActivity::class.java,
                                MeasureBcaReadingFragment::class.java
                            ).start()
                        }

                        Device.Spirometer.deviceKey -> {
                            navigator.loadActivity(
                                IsolatedFullActivity::class.java,
                                SpirometerAllReadingsFragment::class.java
                            ).start()
                        }
                    }
                }

            }

            override fun onConnectClick(position: Int) {
                handleOnConnectClick(position)
            }
        })
    }

    private fun handleOnConnectClick(position: Int) {
        analytics.logEvent(
            analytics.USER_CLICKS_ON_CONNECT,
            Bundle().apply {
                putString(
                    analytics.PARAM_MEDICAL_DEVICE,
                    Common.MedicalDevice.getDeviceNameFromKey(
                        devicesList[position].key
                            ?: ""
                    )
                )
            }, screenName = AnalyticsScreenNames.Home
        )

        when (devicesList[position].key) {
            Device.BcaScale.deviceKey -> {

                if ((session.user?.getHeightValue ?: 0) > 0) {
                    initConnectDeviceFlow(devicesList[position])
                } else {
                    navigator.showAlertDialogWithOptions(getString(R.string.validation_add_height_to_connect_device),
                        positiveText = "Add",
                        negativeText = "Cancel",
                        dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                            override fun onYesClick() {
                                navigator.loadActivity(
                                    IsolatedFullActivity::class.java,
                                    SetupHeightWeightFragment::class.java
                                ).start()
                            }

                            override fun onNoClick() {

                            }
                        })
                }

            }

            Device.Spirometer.deviceKey -> {
                initConnectDeviceFlow(devicesList[position])
            }
        }

    }

    private val homeDailySummaryAdapter by lazy {
        HomeDailySummaryAdapter(dailySummaryList,
            object : HomeDailySummaryAdapter.AdapterListener {
                override fun onClick(position: Int, view: View) {

                    analytics.logEvent(
                        analytics.USER_CLICKED_ON_HOME,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_GOAL_NAME,
                                allDailySummaryList[position].goal_name
                            )
                            putString(
                                analytics.PARAM_GOAL_ID,
                                allDailySummaryList[position].goal_master_id
                            )
                        }, screenName = AnalyticsScreenNames.Home
                    )

                    handleGoalLogsNavigation(position, view)

                }
            })
    }

    private fun handleGoalLogsNavigation(position: Int, view: View? = null) {
        if (allDailySummaryList.size > position && isFeatureAllowedAsPerPlan(
                PlanFeatures.activity_logs,
                allDailySummaryList[position].keys ?: ""
            )
        ) {

            if (allDailySummaryList[position].keys == Goals.Diet.goalKey) {

                if (isFeatureAllowedAsPerPlan(
                        PlanFeatures.activity_logs,
                        Goals.Diet.goalKey
                    )
                ) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        FoodDiaryMainFragment::class.java
                    )
                        .start()
                }
            } else {
                navigator.loadActivity(
                    TransparentActivity::class.java,
                    UpdateGoalLogsFragment::class.java
                )
                    /*.apply {
                        if (view != null) {
                            addSharedElements(listOf(
                                androidx.core.util.Pair(view, view.transitionName)
                            ))
                        }
                    }*/.addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.POSITION, position),
                            Pair(Common.BundleKey.GOAL_LIST, allDailySummaryList)
                        )
                    ).start()
            }

        }
    }

    private val recommendedList = arrayListOf<ContentData>()
    private val homeRecommendedAdapter by lazy {
        HomeRecommendedAdapter(recommendedList, object : HomeRecommendedAdapter.AdapterListener {
            override fun onClick(position: Int) {

                /*navigator.loadActivity(IsolatedFullActivity::class.java,
                    EngageFeedDetailsFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.CONTENT_TYPE, recommendedList[position].content_type),
                        Pair(Common.BundleKey.CONTENT_ID,
                            recommendedList[position].content_master_id)
                    )).start()*/

                analytics.logEvent(analytics.USER_CLICKED_ON_RECOMMENDED, Bundle().apply {
                    putString(
                        analytics.PARAM_CONTENT_MASTER_ID,
                        recommendedList[position].content_master_id
                    )
                    putString(
                        analytics.PARAM_CONTENT_TYPE,
                        recommendedList[position].content_type
                    )
                }, screenName = AnalyticsScreenNames.Home)

                if (recommendedList[position].deep_link.isNullOrBlank().not()) {
                    handleRecommendedDeepLink(Uri.parse(recommendedList[position].deep_link))
                }

            }
        })
    }

    private val homePlanList = arrayListOf<BcpPlanData>()
    private val homePlanAdapter by lazy {
        HomePlansAdapter(homePlanList, object : HomePlansAdapter.AdapterListener {
            override fun onClick(position: Int) {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    PaymentPlanDetailsV1Fragment::class.java
                ).addBundle(
                    bundleOf(
                        Pair(Common.BundleKey.PLAN_ID, homePlanList[position].plan_master_id),
                        Pair(Common.BundleKey.PLAN_TYPE, homePlanList[position].plan_type),
                        Pair(
                            Common.BundleKey.PATIENT_PLAN_REL_ID,
                            homePlanList[position].patient_plan_rel_id
                        ),
                        Pair(
                            Common.BundleKey.ENABLE_RENT_BUY,
                            homePlanList[position].enable_rent_buy
                        ),
                    )
                ).start()
            }

            override fun onKnowMoreClick(position: Int) {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
                ).start()
            }
        })
    }

    private var homePurchasedPlanList = arrayListOf<PatientPlanData>()
    private val homePurchasedPlanAdapter by lazy {
        HomePurchasedPlansAdapter(
            homePurchasedPlanList,
            object : HomePurchasedPlansAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BcpPurchasedDetailsFragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(
                                Common.BundleKey.PATIENT_PLAN_REL_ID,
                                homePurchasedPlanList[position].patient_plan_rel_id
                            ),
                        )
                    ).start()
                }

                override fun onRenewClick(position: Int) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        PaymentPlanDetailsV1Fragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(
                                Common.BundleKey.PLAN_ID,
                                homePurchasedPlanList[position].plan_master_id
                            ),
                            Pair(
                                Common.BundleKey.PLAN_TYPE,
                                homePurchasedPlanList[position].plan_type
                            ),
                            Pair(
                                Common.BundleKey.PATIENT_PLAN_REL_ID,
                                homePurchasedPlanList[position].patient_plan_rel_id
                            ),
                            Pair(Common.BundleKey.ENABLE_RENT_BUY, "Y")
                        )
                    ).start()

                }
            })
    }

    private val readingList = arrayListOf<GoalReadingData>()
    private var currentClickReadingPos = -1
    private val homeUpdateReadingAdapter by lazy {
        HomeUpdateReadingAdapter(readingList,
            object : HomeUpdateReadingAdapter.AdapterListener {
                override fun onClick(position: Int) {

                    analytics.logEvent(
                        analytics.USER_CLICKED_ON_HOME,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_READING_NAME,
                                readingList[position].reading_name
                            )
                            putString(
                                analytics.PARAM_READING_ID,
                                readingList[position].readings_master_id
                            )
                        }, screenName = AnalyticsScreenNames.Home
                    )

                    navigateToLogReadings(position)

                }

                override fun onInfoClick(position: Int) {
                    if (position < readingList.size) {

                        analytics.logEvent(
                            analytics.USER_CLICKED_READING_INFO,
                            Bundle().apply {
                                putString(
                                    analytics.PARAM_READING_NAME,
                                    readingList[position].reading_name
                                )
                                putString(
                                    analytics.PARAM_READING_ID,
                                    readingList[position].readings_master_id
                                )
                            }, screenName = AnalyticsScreenNames.Home
                        )

                        ReadingInfoDialog(readingList[position]) {
                            navigateToLogReadings(position)
                        }.show(
                            requireActivity().supportFragmentManager,
                            ReadingInfoDialog::class.java.simpleName
                        )
                    }
                }
            })
    }

    private val goalList = arrayListOf<GoalReadingData>()
    private val homeGoalAdapter by lazy {
        HomeGoalAdapter(goalList,
            object : HomeGoalAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    analytics.logEvent(
                        analytics.USER_CLICKED_ON_HOME,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_GOAL_NAME,
                                goalList[position].goal_name
                            )
                            putString(
                                analytics.PARAM_GOAL_ID,
                                goalList[position].goal_master_id
                            )
                        }, screenName = AnalyticsScreenNames.Home
                    )

                    if (goalList.size > position && isFeatureAllowedAsPerPlan(
                            PlanFeatures.activity_logs,
                            goalList[position].keys ?: ""
                        )
                    ) {

                        navigator.loadActivity(
                            TransparentActivity::class.java,
                            UpdateGoalLogsFragment::class.java
                        )
                            /*.apply {
                                if (view != null) {
                                    addSharedElements(listOf(
                                        androidx.core.util.Pair(view, view.transitionName)
                                    ))
                                }
                            }*/.addBundle(
                                bundleOf(
                                    Pair(Common.BundleKey.POSITION, position),
                                    Pair(Common.BundleKey.GOAL_LIST, goalList)
                                )
                            ).start()

                    }
                }

                override fun onInfoClick(position: Int) {

                }
            })
    }

    private fun navigateToLogReadings(position: Int) {
        if (readingList[position].not_configured.isNullOrBlank().not()) {
            showMessage(readingList[position].not_configured ?: "")
        } else {
            if (isFeatureAllowedAsPerPlan(
                    PlanFeatures.reading_logs,
                    readingList[position].keys ?: ""
                )
            ) {
                currentClickReadingPos = position

                if (readingList[position].keys == Readings.CAT.readingKey) {
                    getCatSurvey()
                } else {
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

    //book your test
    private val bookTestList = arrayListOf<TestPackageData>()
    private val homeBookTestAdapter by lazy {
        HomeBookTestAdapter(bookTestList,
            object : HomeBookTestAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    analytics.logEvent(
                        analytics.HOME_LABTEST_CARD_CLICKED,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_LAB_TEST_ID,
                                bookTestList[position].lab_test_id
                            )
                        }, screenName = AnalyticsScreenNames.Home
                    )

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        LabTestDetailsFragment::class.java
                    )
                        .addBundle(
                            bundleOf(
                                Pair(
                                    Common.BundleKey.LAB_TEST_ID,
                                    bookTestList[position].lab_test_id
                                )
                            )
                        ).start()
                }
            })
    }

    //stay informed
    var currentClickStayInformedPosition = -1
    private val stayInformedList = arrayListOf<ContentData>()
    private val homeStayInformedAdapter by lazy {
        HomeStayInformedAdapter(requireActivity() as BaseActivity,
            stayInformedList,
            object : HomeStayInformedAdapter.AdapterListener {
                override fun onBookmarkClick(position: Int) {
                    currentClickStayInformedPosition = position
                    updateBookmarks()
                }

                override fun onShareClick(position: Int) {
                    stayInformedList[position].getShareText.let {
                        analytics.logEvent(analytics.USER_SHARED_CONTENT,
                            Bundle().apply {
                                putString(
                                    analytics.PARAM_CONTENT_MASTER_ID,
                                    stayInformedList[position].content_master_id
                                )
                                putString(
                                    analytics.PARAM_CONTENT_TYPE,
                                    stayInformedList[position].content_type
                                )
                            })
                        requireActivity().shareText(it)
                    }
                }

                override fun onClick(position: Int) {
                    analytics.logEvent(analytics.USER_CLICKED_ON_STAY_INFORMED, Bundle().apply {
                        putString(
                            analytics.PARAM_CONTENT_MASTER_ID,
                            stayInformedList[position].content_master_id
                        )
                        putString(
                            analytics.PARAM_CONTENT_TYPE,
                            stayInformedList[position].content_type
                        )
                    }, screenName = AnalyticsScreenNames.Home)

                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        EngageFeedDetailsFragment::class.java
                    )
                        .addBundle(
                            bundleOf(
                                Pair(
                                    Common.BundleKey.CONTENT_TYPE,
                                    stayInformedList[position].content_type
                                ),
                                Pair(
                                    Common.BundleKey.CONTENT_ID,
                                    stayInformedList[position].content_master_id
                                ),
                                Pair(
                                    Common.BundleKey.POSITION,
                                    position
                                )
                            )
                        ).start()
                }
            })
    }

    private val quizPoleList = arrayListOf<QuizPoleData>()
    private val homeQuizPolePagerAdapter by lazy {
        HomeQuizPolePagerAdapter(quizPoleList,
            object : HomeQuizPolePagerAdapter.AdapterListener {
                override fun onClick(position: Int) {
                    // for poll only as of now
                    quizPoleList[position].survey_id?.let {
                        currentQuizPollPosition = position
                        isQuizPoleSurvey = true
                        initSurvey(it)

                        if (quizPoleList[position].quiz_master_id.isNullOrBlank().not()) {
                            //quiz
                            analytics.logEvent(
                                analytics.USER_STARTED_QUIZ,
                                screenName = AnalyticsScreenNames.Home
                            )
                        } else {
                            //poll
                        }
                    }
                }
            })
    }

    var catSurveyData: CatSurveyData? = null
    var currentQuizPollPosition = -1
    var isQuizPoleSurvey = false

    private fun initSurvey(surveyToken: String) {
        surveyUtil.initSurvey(surveyToken) { isSuccess: Boolean, data: Intent?, message: String ->
            if (isSuccess && data != null) {

                val response = SurveySparrow.toJSON(data.data.toString())
                try {
                    val responseData: JSONArray? =
                        if (response.has("response"))
                            response.getJSONArray("response")
                        else
                            null

                    val type = if (response.has("type")) {
                        response.getString("type")
                    } else ""

                    val score = if (response.has("score")) {
                        response.getString("score")
                    } else "0"

                    if (responseData != null) {

                        if (isQuizPoleSurvey) {
                            if (currentQuizPollPosition >= 0 && currentQuizPollPosition < quizPoleList.size) {
                                if (quizPoleList[currentQuizPollPosition].quiz_master_id != null) {
                                    //add quiz data
                                    Log.d("quizData", "::$responseData")
                                    addQuizAnswers(responseData, score)
                                } else if (quizPoleList[currentQuizPollPosition].poll_master_id != null) {
                                    //add poll data
                                    Log.d("pollData", "::$responseData")
                                    addPollAnswers(responseData)
                                }
                            }
                        } else if (catSurveyData != null) {
                            // add cat survey data
                            Log.d("catData", "::$responseData")
                            addCatSurvey(responseData, score)
                        }

                    } else {
                        val error = if (response.has("error"))
                            response.getString("error")
                        else
                            null

                        Log.d("SurveySparrow", "initSurvey: Response not found $error")

                        if (error.isNullOrBlank().not()) {
                            showMessage(error!!)
                        }
                    }

                } catch (e: Exception) {

                }
            } else {
                Log.d("Response", "::$message")
            }
        }

    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): HomeFragmentHomeNewBinding {
        return HomeFragmentHomeNewBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    //val callApiJob:Job
    var callApiJob: Job? = null
    override fun onShow() {
        super.onShow()
        callApiJob?.cancel()
        callApiJob = GlobalScope.launch(Dispatchers.Main) {
            delay(300)
            if (isAdded && isVisible) {
                callApisOnShow()
            }
        }
    }

    private fun callApisOnShow() {
        updateMyDeviceList()
        dailySummary()
        myHealthInsights()
        hcDevicePlan()

        Handler(Looper.getMainLooper()).postDelayed({
            if (isAdded) {
                recommendedContent()
                if (requireActivity() is HomeActivity) {
                    (requireActivity() as HomeActivity).getPatientDetails()
                }
            }
        }, 200)

        setPatientPlanList()
    }

    private fun setPatientPlanList() {
        session.user?.let {
            if (checkUserPlanFree(it.patient_plans)) {
                plansList()
            } else {
                binding.rvPlans.apply {
                    layoutManager =
                        LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
                    adapter = homePurchasedPlanAdapter
                }

                binding.textViewLabelCarePlanForYourNeeds.isVisible = false
                binding.textViewLabelExplorePlan.isVisible = false
                binding.imageViewCarePlan.isVisible = false

                if (it.patient_plans.isNotEmpty()) {
                    homePurchasedPlanList.clear()
                    homePurchasedPlanList = it.patient_plans
                    homePurchasedPlanAdapter.doRefresh(homePurchasedPlanList)
                }
            }
        }
    }

    private fun checkUserPlanFree(patientPlans: ArrayList<PatientPlanData>): Boolean {
        if (patientPlans.isEmpty()) {
            return true
        } else if (patientPlans[0].plan_type == "Free") {
            return true
        }
        return false
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun updateMyDeviceList() {
        session.user?.let {
            devicesList.clear()
            /*devicesList.add(
                MyDevicesData(
                    key = Device.BcaScale.deviceKey,
                    title = "Smart Analyser",
                    lastSyncDate = it.lastBcaSyncDate,
                )
            )
            if(session.user?.isCopdorAshthmaAPatient == true) {
                devicesList.add(
                    MyDevicesData(
                        key = Device.Spirometer.deviceKey,
                        title = "Lung Function Analyser",
                        lastSyncDate = it.lastSpirometerSyncDate,
                    )
                )
            }*/
            it.devices?.let { it1 -> devicesList.addAll(it1) }
            if (AppFlagHandler.getIsToHideHomeBca(firebaseConfigUtil)) {
                devicesList.removeIf { it.key == Device.BcaScale.deviceKey }
            }
            if (session.user?.isCopdorAshthmaAPatient?.not() == true || AppFlagHandler.getIsToHideHomeSpirometer(
                    firebaseConfigUtil
                )
            ) {
                devicesList.removeIf { it.key == Device.Spirometer.deviceKey }
            }
            homeMyDevicesAdapter.notifyDataSetChanged()
        }
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.Home)
        session.user?.let {
            homeUpdateReadingAdapter.user = it
            homeGoalAdapter.user = it

            binding.layoutHeader.ivProfile.loadUrl(
                it.profile_pic.toString(), R.drawable.place_holder, false
            )

            binding.tvGreetings.text = "${getCurrentGreetingStatus()} ${it.name ?: ""}!"

            binding.clDoctorAppointment.isVisible = it.patient_guid != null
        }

        /*Handler(Looper.getMainLooper()).postDelayed({
            (requireActivity() as BaseActivity).showAccountSetupDialog()
        }, 500)*/

        Handler(Looper.getMainLooper()).postDelayed({
            if (isAdded && isVisible) {
                onShow()
            }
        }, 200)
        updateUserData()
    }

    private fun getCurrentGreetingStatus(): String {
        return when (Calendar.getInstance().get(Calendar.HOUR_OF_DAY)) {
            in 6..11 -> {
                getString(R.string.txt_good_morning)
            }

            in 12..15 -> {
                getString(R.string.txt_good_afternoon)
            }

            in 16..20 -> {
                getString(R.string.txt_good_evening)
            }

            else -> {
                getString(R.string.txt_good_evening)
            }
        }
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListeners()
        setUpToolbar()
        setUpQuizPollPager()
        getPollQuiz()
        setUpNestedScrollListener()
        setUpUI()

//
        /*Handler(Looper.getMainLooper()).postDelayed({
            recommendedContent()
        }, 500)*/
        /*dailySummary()*/
    }

    private fun setUpUI() {
        with(binding) {
            imageViewChat.isVisible = !AppFlagHandler.isToHideHomeChatBubble(firebaseConfigUtil)

            //todo Change done by Ankit
            layoutMyDevices.isVisible = false
            /*layoutMyDevices.isVisible =
                        !AppFlagHandler.getIsToHideHomeMyDevice(firebaseConfigUtil)*/

            /*appbarLayout.addOnOffsetChangedListener(object : AppBarLayout.OnOffsetChangedListener {
                var isShow = false
                var scrollRange = -1
                override fun onOffsetChanged(appBarLayout: AppBarLayout, verticalOffset: Int) {
                    if (scrollRange == -1) {
                        scrollRange = appBarLayout.totalScrollRange
                    }
                    if (scrollRange + verticalOffset == 0) {
                        isShow = true
                        layoutHeader.root.isVisible = true
                    } else if (isShow) {
                        isShow = false
                        layoutHeader.root.isVisible = false
                    }
                }
            })*/
        }

        if (AppFlagHandler.isToHideIncidentSurvey(firebaseConfigUtil)) {
            binding.clIncident.isVisible = HomeActivity.incidentSurveyData != null
        } else {
            binding.clIncident.isVisible = false
        }
    }

    private fun setUpNestedScrollListener() {
        binding.nestedScrollView.viewTreeObserver.addOnScrollChangedListener {
            if (isAdded && isVisible) {
                val view: View =
                    binding.nestedScrollView.getChildAt(binding.nestedScrollView.childCount - 1) as View

                val diff: Int =
                    view.bottom - (binding.nestedScrollView.height + binding.nestedScrollView.scrollY)

                if (diff == 0 && isAdded && isVisible /*&& isMoreDataAvailable*/) {
                    //page reached end
                    analytics.logEvent(
                        analytics.USER_SCROLL_DEPTH_HOME,
                        screenName = AnalyticsScreenNames.Home
                    )
                }
            }
        }
    }

    private fun setUpQuizPollPager() {
        with(binding) {
            viewPagerQuizPoll.setPaddingRelative(
                resources.getDimension(R.dimen.dp_12)
                    .toInt(),
                0,
                resources.getDimension(R.dimen.dp_12).toInt(),
                0
            )
            viewPagerQuizPoll.clipToPadding = false
            viewPagerQuizPoll.clipChildren = false
            viewPagerQuizPoll.offscreenPageLimit = 2
            viewPagerQuizPoll.adapter = homeQuizPolePagerAdapter
            dotsIndicator.setViewPager2(viewPagerQuizPoll)
        }
    }

    fun updateUserData(isToCheckEmailVerifiedFlag: Boolean = false) {
        if (isAdded && isVisible) {
            session.user?.let {
                with(binding) {
//                if (isToCheckEmailVerifiedFlag) {
                    if (it.email_verified == "N") {
                        //todo Ankit
                        //textViewVerifyEmail.visibility = View.VISIBLE
                        textViewVerifyEmail.visibility = View.GONE
                    } else {
                        textViewVerifyEmail.visibility = View.GONE
                    }
//                }

                    layoutHeader.apply {
                        imageViewUnreadNotificationIndicator.visibility =
                            if ((it.unread_notifications?.toIntOrNull()
                                    ?: 0) > 0
                            ) View.VISIBLE else View.GONE
                        imageViewUnreadNotificationIndicator.text =
                            it.unread_notifications?.toIntOrNull()?.toString() ?: ""

                        if (!it.city.isNullOrEmpty() && !it.state.isNullOrEmpty()) {
                            tvLocation.text = "${it.city.trim()}, ${it.state.trim()}"
                        } else if (!it.city.isNullOrEmpty()) {
                            tvLocation.text = it.city
                        } else if (!it.state.isNullOrEmpty()) {
                            tvLocation.text = it.state
                        } else {
                            tvLocation.text = "Select Location"
                        }

                    }
                }

                updateMyDeviceList()
            }
        }
    }

    var deepLinkScreenSection: String? = null
    private fun handleScrollAsPerDeepLinkScreenSection() {
        deepLinkScreenSection?.let {
            Handler(Looper.getMainLooper()).postDelayed({
                if (isAdded && isVisible) {
                    when (it) {
                        "DiagnosticTest" -> {
                            binding.nestedScrollView.smoothScrollTo(
                                0,
                                binding.layoutBookYourTest.bottom + 50
                            )
                        }

                        "QuizPoll" -> {
                            binding.nestedScrollView.smoothScrollTo(
                                0,
                                binding.layoutQuizPoll.bottom + 50
                            )
                        }
                    }
                }
                deepLinkScreenSection = null
            }, 0)
        }
    }

    private fun setUpRecyclerView() {
        dailySummaryList.clear()
        dailySummaryList.addAll(allDailySummaryList.take(4))
        binding.recyclerViewDailySummary.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = homeDailySummaryAdapter
        }

        binding.recyclerViewRecommended.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = homeRecommendedAdapter
        }

        binding.recyclerViewUpdateReadings.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = homeUpdateReadingAdapter
        }

        binding.rvGoals.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = homeGoalAdapter
        }

        binding.recyclerViewStayInformed.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = homeStayInformedAdapter
        }

        binding.recyclerViewBookTest.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = homeBookTestAdapter
        }

        binding.recyclerViewMyDevices.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
            adapter = homeMyDevicesAdapter
        }
    }

    private fun initConnectDeviceFlow(myDevicesData: MyDevicesData) {
        /*DoYouHaveDeviceBottomSheetDialog().apply {
            this.myDevicesData = myDevicesData
        }.show(childFragmentManager, null)*/
        DeviceInfoConnectBottomSheetDialog().apply {
            this.isFromHome = true
            this.myDevicesData = myDevicesData
        }.show(
            requireActivity().supportFragmentManager,
            DeviceInfoConnectBottomSheetDialog::class.java.simpleName
        )
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //imageViewToolbarMenu.setOnClickListener { onViewClick(it) }
            imageViewNotification.setOnClickListener { onViewClick(it) }
            ivProfile.setOnClickListener { onViewClick(it) }
            tvLocation.setOnClickListener { onViewClick(it) }
            ivDown.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            textViewVerifyEmail.setOnClickListener { onViewClick(it) }
            textViewDailySummaryMoreLess.setOnClickListener { onViewClick(it) }
            clHealthTips.setOnClickListener { onViewClick(it) }
            imageViewChat.setOnClickListener { onViewClick(it) }
            imageViewInfo.setOnClickListener { onViewClick(it) }
            textViewViewMoreTest.setOnClickListener { onViewClick(it) }
            layoutExploreCarePlans.setOnClickListener { onViewClick(it) }
            clSearch.setOnClickListener { onViewClick(it) }
            clMedicine.setOnClickListener { onViewClick(it) }
            clDiet.setOnClickListener { onViewClick(it) }
            clExercise.setOnClickListener { onViewClick(it) }
            clDevice.setOnClickListener { onViewClick(it) }
            clIncident.setOnClickListener { onViewClick(it) }
            tvViewAll.setOnClickListener { onViewClick(it) }


            clNutritionist.setOnClickListener { onViewClick(it) }
            clPhysio.setOnClickListener { onViewClick(it) }
            clBookDiagnostic.setOnClickListener { onViewClick(it) }
            clBookDevice.setOnClickListener { onViewClick(it) }
            clDoctorAppointment.setOnClickListener { onViewClick(it) }
        }
    }


    private fun checkPatientPlanContainsKey(key: String): Boolean {
        val featuresList = arrayListOf<FeatureRes>()
        session.user?.patient_plans?.forEachIndexed { index, patientPlanData ->
            patientPlanData.features_res?.let { featuresList.addAll(it) }
        }

        return featuresList.any { featureRes ->
            featureRes.sub_features_keys?.contains(
                key,
                true
            ) == true
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.tvLocation, R.id.ivDown -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    SelectYourLocationFragment::class.java
                ).start()
            }

            R.id.imageViewInfo -> {
                navigator.showAlertDialog(getString(R.string.message_goal_info))
            }

            R.id.imageViewChat -> {
                /*ChatListDialog()
                    .show(requireActivity().supportFragmentManager,
                        ChatListDialog::class.java.simpleName)*/

                navigator.loadActivity(
                    TransparentActivity::class.java,
                    ChatListFragment::class.java
                ).addSharedElements(
                    arrayListOf(
                        androidx.core.util.Pair(
                            binding.imageViewChat,
                            binding.imageViewChat.transitionName
                        )
                    )
                ).start()

                // requireActivity().openWhatsApp()
            }

            R.id.imageViewToolbarMenu -> {
                analytics.logEvent(
                    analytics.USER_CLICKED_ON_MENU,
                    screenName = AnalyticsScreenNames.Home
                )
                analytics.logEvent(analytics.USER_TAPS_ON_BOTTOM_NAV, Bundle().apply {
                    putString(analytics.PARAM_MODULE, "More")
                }, screenName = AnalyticsScreenNames.Home)

                (requireActivity() as HomeActivity).toggleDrawer()
            }

            R.id.textViewVerifyEmail -> {
                sendEmailVerificationLink()
            }

            R.id.textViewDailySummaryMoreLess -> {
                binding.textViewDailySummaryMoreLess.isChecked =
                    binding.textViewDailySummaryMoreLess.isChecked.not()
                toggleDailySummaryData(true)
            }

            R.id.imageViewNotification -> {
                //CalendarUtil.writeEventToCalendar(requireActivity())
                openNotificationScreen()
            }

            R.id.ivProfile -> {
                //todo Change done by Ankit
                (requireActivity() as HomeActivity).toggleDrawer()
                /*navigator.loadActivity(IsolatedFullActivity::class.java, SearchFragment::class.java)
                        .start()*/
                /*activity?.supportFragmentManager?.let {
                    CorrectAnswerResultDialog().show(it,
                        CorrectAnswerResultDialog::class.java.simpleName)
                }*/
            }

            R.id.layoutDoctorSays -> {
                if (session.user?.doctor_says?.deep_link.isNullOrBlank().not()) {
                    handleRecommendedDeepLink(Uri.parse(session.user?.doctor_says?.deep_link))
                }

                /*session.user?.doctor_says?.description?.let {
                    navigator.showAlertDialog(it,
                        dialogOkListener = object : BaseActivity.DialogOkListener {
                            override fun onClick() {
                            }
                        })
                }*/
            }

            R.id.textViewViewMoreTest -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    LabTestListFragment::class.java
                )
                    .start()
            }

            R.id.layoutExploreCarePlans -> {
                analytics.logEvent(
                    analytics.HOME_CARE_PLAN_CARD_CLICKED,
                    screenName = AnalyticsScreenNames.Home
                )

                if (session.user?.currentPlan?.plan_master_id.isNullOrBlank().not()) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BcpPurchasedDetailsFragment::class.java
                    ).addBundle(Bundle().apply {
                        putString(
                            Common.BundleKey.PATIENT_PLAN_REL_ID,
                            session.user?.currentPlan?.patient_plan_rel_id
                        )
                    }).start()
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        PaymentCarePlanListingFragment::class.java
                    ).start()
                }
            }

            R.id.clSearch -> {
                navigator.loadActivity(IsolatedFullActivity::class.java, SearchFragment::class.java)
                    .start()
            }

            R.id.clDevice -> {
                if (checkUserPlanFree(session.user!!.patient_plans)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        PaymentCarePlanListingFragment::class.java
                    ).start()
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        DevicesFragment::class.java
                    ).start()
                }
            }

            R.id.clDiet -> {
                if (isFeatureAllowedAsPerPlan(
                        PlanFeatures.activity_logs,
                        Goals.Diet.goalKey
                    )
                ) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        FoodDiaryMainFragment::class.java
                    ).start()
                }
            }

            R.id.clMedicine -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    UpdateGoalLogsFragment::class.java
                ).addBundle(
                    bundleOf(
                        Pair(
                            Common.BundleKey.POSITION,
                            allDailySummaryList.indexOfFirst { it.keys == Goals.Medication.goalKey }),
                        Pair(Common.BundleKey.GOAL_LIST, allDailySummaryList)
                    )
                ).start()
            }

            R.id.clExercise -> {
                if (isFeatureAllowedAsPerPlan(
                        PlanFeatures.activity_logs,
                        Goals.Exercise.goalKey
                    )
                ) {
                    (requireActivity() as HomeActivity).navigateToExercise()
                } else {
                    navigator.loadActivity(
                        TransparentActivity::class.java,
                        UpdateGoalLogsFragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(
                                Common.BundleKey.POSITION,
                                allDailySummaryList.indexOfFirst { it.keys == Goals.Exercise.goalKey }),
                            Pair(Common.BundleKey.GOAL_LIST, allDailySummaryList)
                        )
                    ).start()
                }
            }

            R.id.clIncident -> {
                if (HomeActivity.incidentSurveyData != null) {
                    navigator.loadActivity(
                        TransparentActivity::class.java,
                        AddIncidentFragment::class.java
                    )
                        .addBundle(
                            bundleOf(
                                Pair(
                                    Common.BundleKey.INCIDENT_SURVEY_DATA,
                                    HomeActivity.incidentSurveyData
                                )
                            )
                        ).start()
                }
                //(requireActivity() as HomeActivity).navigateToCarePlan()
            }

            R.id.tvViewAll -> {
                (requireActivity() as HomeActivity).navigateToDiscover()
            }

            R.id.clNutritionist -> {
                /*if (hcDevicePlan?.nutritionist?.isActive.isNullOrEmpty()) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
                    ).start()
                } else {
                    if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                        navigator.loadActivity(
                            IsolatedFullActivity::class.java,
                            BookAppointmentsFragment::class.java
                        ).start()
                    }
                }*/


                if (checkPatientPlanContainsKey(PlanFeatures.book_appointments_hc)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BookAppointmentsFragment::class.java
                    ).start()
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
                    ).addBundle(Bundle().apply {
                        putString(Common.BundleKey.SHOW_PLAN_TYPE, "show_nutritionist")
                    }).start()
                }

            }

            R.id.clPhysio -> {
                /*if (hcDevicePlan?.physiotherapist?.isActive.isNullOrEmpty()) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
                    ).start()
                } else {
                    if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                        navigator.loadActivity(
                            IsolatedFullActivity::class.java,
                            BookAppointmentsFragment::class.java
                        ).start()
                    }
                }*/

                if (checkPatientPlanContainsKey(PlanFeatures.book_appointments_hc)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BookAppointmentsFragment::class.java
                    ).start()
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
                    ).addBundle(Bundle().apply {
                        putString(Common.BundleKey.SHOW_PLAN_TYPE, "show_physio")
                    }).start()
                }
            }

            R.id.clBookDiagnostic -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    LabTestListFragment::class.java
                )
                    .start()
            }

            R.id.clBookDevice -> {
                if (hcDevicePlan?.devices?.isActive.isNullOrEmpty()) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
                    ).addBundle(Bundle().apply {
                        putString(Common.BundleKey.SHOW_PLAN_TYPE, "show_book_device")
                    }).start()
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        DevicesFragment::class.java
                    )
                        .start()
                }

                /*if (hcDevicePlan?.physiotherapist?.isActive.isNullOrEmpty()) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java, PaymentCarePlanListingFragment::class.java
                    ).start()
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        DevicesFragment::class.java
                    )
                        .start()
                }*/
            }

            R.id.clDoctorAppointment -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BookAppointmentsFragment::class.java
                    ).start()
                }
            }
        }
    }

    fun showCoachMark(onFinish: () -> Unit) {
        var mGuideView: GuideView? = null
        var builder: GuideView.Builder? = null

        if (binding.textViewDailySummaryMoreLess.isChecked) {
            binding.textViewDailySummaryMoreLess.isChecked = false
            toggleDailySummaryData()
        }

        binding.nestedScrollView.scrollTo(0, 0)
        builder = GuideView.Builder(requireActivity())
            .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.HOME_GOAL.pageKey))
            .setButtonText("Next")
            .setGravity(Gravity.center)
            /*.setDismissType(DismissType.outside)
            .setPointerType(PointerType.circle)*/
            .setTargetView(binding.layoutDailySummary)
            .setGuideListener(object : GuideListener {
                override fun onDismiss(view: View?) {
                }

                override fun onSkip() {
                    showSkipCoachMarkMessage()
                }

                override fun onNext(view: View) {
                    when (view.id) {
                        R.id.layoutDailySummary -> {
                            with(binding) {
                                nestedScrollView.scrollTo(0, layoutUpdateYourReading.top)
                                builder
                                    ?.setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.HOME_READING.pageKey))
                                    ?.setButtonText("Next")
                                    ?.setTargetView(binding.layoutUpdateYourReading)
                                mGuideView = builder?.build()
                                mGuideView?.show()
                            }
                        }

                        R.id.layoutUpdateYourReading -> {
                            //onFinish.invoke()
                            builder
                                ?.setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.HOME_CAREPLAN.pageKey))
                                ?.setButtonText("Go To Care Plan")
                                ?.setTargetView((requireActivity() as HomeActivity).binding.layoutCarePlan)
                            mGuideView = builder?.build()
                            mGuideView?.show()
                        }

                        R.id.layoutCarePlan -> {
                            onFinish.invoke()
                        }
                    }

                }
            })

        mGuideView = builder?.build()
        mGuideView?.show()
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun toggleDailySummaryData(isNeedToAnimate: Boolean = false) {
        with(binding) {
            if (isNeedToAnimate) {
                TransitionManager.beginDelayedTransition(root)
            }
            if (textViewDailySummaryMoreLess.isChecked) {
                dailySummaryList.clear()
                dailySummaryList.addAll(allDailySummaryList)
                textViewDailySummaryMoreLess.text =
                    getString(R.string.home_label_view_less_daily_summary)
                homeDailySummaryAdapter.notifyItemRangeInserted(4, dailySummaryList.size)
            } else {
                dailySummaryList.clear()
                dailySummaryList.addAll(allDailySummaryList.take(4))
                textViewDailySummaryMoreLess.text =
                    getString(R.string.home_label_view_more_daily_summary)
                homeDailySummaryAdapter.notifyItemRangeRemoved(4, dailySummaryList.size)
            }
            /*homeDailySummaryAdapter.notifyDataSetChanged()*/
        }
    }

    private fun handleRecommendedDeepLink(uri: Uri) {
        showLoader()
        FirebaseDynamicLinks.getInstance()
            .getDynamicLink(uri)
            .addOnSuccessListener(requireActivity()) { pendingDynamicLinkData: PendingDynamicLinkData? ->
                hideLoader()
                // Get deep link from result (may be null if no link is found)
                var deepLink: Uri? = null
                if (pendingDynamicLinkData != null) {
                    deepLink = pendingDynamicLinkData.link
                    if (deepLink?.queryParameterNames?.contains(FirebaseLink.Params.OPERATION) == true) {
                        when (deepLink.getQueryParameter(FirebaseLink.Params.OPERATION)) {
                            FirebaseLink.Operation.SCREEN_NAV -> {
                                handleScreenNavigation(deepLink)
                            }

                            FirebaseLink.Operation.CONTENT -> {
                                val contentMasterId =
                                    deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_MASTER_ID)
                                if (contentMasterId?.isNotBlank() == true) {
                                    navigator.loadActivity(
                                        IsolatedFullActivity::class.java,
                                        EngageFeedDetailsFragment::class.java
                                    )
                                        .addBundle(Bundle().apply {
                                            putString(Common.BundleKey.CONTENT_ID, contentMasterId)
                                        }).start()
                                }
                            }
                        }
                    }
                }
            }.addOnFailureListener(requireActivity()) { e: Exception? ->
                hideLoader()
                Log.w("addOnFailureListener", "getDynamicLink:onFailure")
            }
    }

    private fun handleScreenNavigation(deepLink: Uri) {
        val screenName = deepLink.getQueryParameter(FirebaseLink.Params.SCREEN_NAME)

        when (screenName) {
            /*AnalyticsScreenNames.Home -> {
                loadActivity(HomeActivity::class.java)
                    .byFinishingCurrent().start()
            }*/
            AnalyticsScreenNames.Home,
            AnalyticsScreenNames.CarePlan,
            AnalyticsScreenNames.DiscoverEngage,
            AnalyticsScreenNames.ExerciseMyRoutine,/*ExercisePlan*/
            AnalyticsScreenNames.ExerciseMore,
            -> {
                (requireActivity() as HomeActivity).handleHomeNavigation(deepLink)
                /*navigator.loadActivity(HomeActivity::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.SCREEN_NAME, screenName)
                    )).byFinishingCurrent().start()*/
            }

            AnalyticsScreenNames.ContentDetailPhotoGallery,
            AnalyticsScreenNames.ContentDetailNormalVideo,
            AnalyticsScreenNames.ContentDetailKolVideo,
            AnalyticsScreenNames.ContentDetailBlog,
            AnalyticsScreenNames.ContentDetailWebinar,
            -> {
                val contentMasterId =
                    deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_MASTER_ID)
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    EngageFeedDetailsFragment::class.java
                )
                    .addBundle(Bundle().apply {
                        putString(Common.BundleKey.CONTENT_ID, contentMasterId)
                    }).start()
            }

            AnalyticsScreenNames.ExercisePlanDetail -> {
                val contentMasterId =
                    deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_MASTER_ID)
                val planName =
                    deepLink.getQueryParameter(FirebaseLink.Params.PLAN_NAME)
                val planType =
                    deepLink.getQueryParameter(FirebaseLink.Params.PLAN_TYPE)

                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    ExercisePlanDetailsNewFragment::class.java
                )
                    .addBundle(Bundle().apply {
                        putString(Common.BundleKey.CONTENT_ID, contentMasterId)
                        putString(Common.BundleKey.TITLE, planName)
                        putString(Common.BundleKey.PLAN_TYPE, planType)
                    }).start()
            }

            AnalyticsScreenNames.ExercisePlanDayDetail -> {
                val exercisePlanDayId =
                    deepLink.getQueryParameter(FirebaseLink.Params.EXERCISE_PLAN_DAY_ID)
                val planType =
                    deepLink.getQueryParameter(FirebaseLink.Params.PLAN_TYPE)

                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    PlanDayDetailsNewFragment::class.java
                )
                    .addBundle(Bundle().apply {
                        putString(Common.BundleKey.EXERCISE_PLAN_DAY_ID, exercisePlanDayId)
                        putString(Common.BundleKey.PLAN_TYPE, planType)
                    }).start()
            }

            AnalyticsScreenNames.FoodDiaryDay -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs, Goals.Diet.goalKey)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        FoodDiaryMainFragment::class.java
                    ).start()
                }
            }

            AnalyticsScreenNames.FoodDiaryMonth -> {//
                if (isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs, Goals.Diet.goalKey)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        FoodDiaryMainFragment::class.java
                    )
                        .addBundle(Bundle().apply {
                            putInt(Common.BundleKey.POSITION, 1)
                        }).start()
                }
            }

            AnalyticsScreenNames.FoodDiaryDayInsight -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs, Goals.Diet.goalKey)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        FoodDayInsightFragment::class.java
                    ).start()
                }
            }

            AnalyticsScreenNames.LogFood -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    LogFoodFragment::class.java
                ).start()
            }

            AnalyticsScreenNames.HelpSupportFaq -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    HelpSupportFAQFragment::class.java
                ).start()
            }

            AnalyticsScreenNames.NotificationList -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    NotificationsFragment::class.java
                ).start()
            }

            AnalyticsScreenNames.HistoryIncident -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    HistoryFragment::class.java
                ).addBundle(Bundle().apply {
                    putBoolean(Common.BundleKey.IS_SHOW_INCIDENT, true)
                }).start()
            }

            AnalyticsScreenNames.HistoryRecord -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_records_history_records)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        HistoryFragment::class.java
                    )
                        .addBundle(Bundle().apply {
                            putBoolean(Common.BundleKey.IS_SHOW_RECORD, true)
                        }).start()
                }
            }

            AnalyticsScreenNames.HistoryTest -> {
                if (AppFlagHandler.isToHideDiagnosticTest(firebaseConfigUtil).not()) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        HistoryFragment::class.java
                    )
                        .addBundle(Bundle().apply {
                            putBoolean(Common.BundleKey.IS_SHOW_TEST, true)
                        }).start()
                }
            }

            AnalyticsScreenNames.HistoryPayment -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.history_payments)) {
                    //default first tab is payment tab in history
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        HistoryFragment::class.java
                    )
                        .start()
                }
            }

            AnalyticsScreenNames.UploadRecord -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_records_history_records)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        UploadRecordFragment::class.java
                    )
                        .start()
                }
            }

            AnalyticsScreenNames.AddIncident -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.incident_records_history)) {
                    navigator.loadActivity(
                        TransparentActivity::class.java,
                        AddIncidentFragment::class.java
                    )
                        .start()
                }
            }

            AnalyticsScreenNames.MyProfile -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    MyProfileFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.EditProfile -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    EditProfileFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.MyDevices -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    MyDevicesFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.SetUpDrugs -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_medication)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        SetupDrugsFragment::class.java
                    )
                        .start()
                }
            }

            AnalyticsScreenNames.SetUpGoalsReadings -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    SetupGoalsReadingsFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.SelectLocation -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    SelectYourLocationFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.CreateProfileFlow -> {
                // open auth flow to complete profile
                navigator.loadActivity(
                    AuthActivity::class.java,
                    SelectYourLocationFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.BookmarkList -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BookmarksFragment::class.java
                    )
                        .start()
                }
            }

            AnalyticsScreenNames.FaqQuery -> {
                requireActivity().supportFragmentManager.let {
                    HelpDialog().show(it, HelpDialog::class.java.simpleName)
                }
            }

            AnalyticsScreenNames.CatSurvey -> {
                getCatSurvey()
            }

            AnalyticsScreenNames.RequestCallBack -> {
                if (requireActivity() is HomeActivity) {
                    (requireActivity() as HomeActivity).openCarePlanAndShowRequestCallbackDialog()
                }
            }

            AnalyticsScreenNames.QuestionDetails -> {
                val contentMasterId =
                    deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_MASTER_ID)
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    QuestionDetailsFragment::class.java
                )
                    .addBundle(Bundle().apply {
                        putString(Common.BundleKey.CONTENT_ID, contentMasterId)
                    }).start()
            }

            AnalyticsScreenNames.BookAppointment -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                    val selection = deepLink.getQueryParameter(FirebaseLink.Params.SELECTION)
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BookAppointmentsFragment::class.java
                    )
                        .addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.SELECTION, selection)
                            )
                        ).start()
                }
            }

            AnalyticsScreenNames.AppointmentList -> {
                val selection = deepLink.getQueryParameter(FirebaseLink.Params.SELECTION)
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    AllAppointmentsFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.SELECTION, selection)
                        )
                    ).start()
            }

            AnalyticsScreenNames.MyTatvaPlans -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    /*PaymentPlanServiceMainFragment*/PaymentCarePlanListingFragment::class.java
                ).start()
            }
        }

        /*if (appPreferences.getBoolean(Common.IS_LOGIN)) {

        } else {

        }*/
    }

    fun handleForCatSurveyNavigation() {
        getCatSurvey()
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun sendEmailVerificationLink() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.sendEmailVerificationLink(apiRequest)
    }

    private fun dailySummary() {
        val apiRequest = ApiRequest()

        goalReadingViewModel.dailySummary(apiRequest)
    }

    private fun myHealthInsights() {
        val apiRequest = ApiRequest()

        if (dailySummaryList.isEmpty())
            showLoader()

        goalReadingViewModel.myHealthInsights(apiRequest)
    }

    private fun hcDevicePlan() {
        val apiRequest = ApiRequest()

        patientPlansViewModel.hcDevicePlan(apiRequest)
    }

    private fun getPollQuiz() {
        val apiRequest = ApiRequest()
        /*apiRequest.page = "1"*/
        goalReadingViewModel.getPollQuiz(apiRequest)
    }

    private fun stayInformed() {
        val apiRequest = ApiRequest()
        //showLoader()
        engageContentViewModel.stayInformed(apiRequest)
    }

    private fun recommendedContent() {
        val apiRequest = ApiRequest()
        //showLoader()
        engageContentViewModel.recommendedContent(apiRequest)
    }

    private fun plansList() {
        val apiRequest = ApiRequest().apply {
            page = "0"
        }
        patientPlansViewModel.homePlansList(apiRequest)
    }

    private fun addQuizAnswers(surveyResponse: JSONArray, score: String) {
        val list = arrayListOf<ApiRequestSubData>()
        list.addAll(
            Gson().fromJson(surveyResponse.toString(), Array<ApiRequestSubData>::class.java)
                .toList()
        )

        val apiRequest = ApiRequest().apply {
            quiz_master_id = quizPoleList[currentQuizPollPosition].quiz_master_id
            survey_id = quizPoleList[currentQuizPollPosition].survey_id
            this.score = score
            quiz_data = list
        }
        showLoader()
        goalReadingViewModel.addQuizAnswers(apiRequest)
    }

    private fun addPollAnswers(surveyResponse: JSONArray) {
        val list = arrayListOf<ApiRequestSubData>()
        list.addAll(
            Gson().fromJson(surveyResponse.toString(), Array<ApiRequestSubData>::class.java)
                .toList()
        )

        val apiRequest = ApiRequest().apply {
            survey_id = quizPoleList[currentQuizPollPosition].survey_id
            poll_data = list
            poll_master_id = quizPoleList[currentQuizPollPosition].poll_master_id
        }
        showLoader()
        goalReadingViewModel.addPollAnswers(apiRequest)
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

    private fun updateBookmarks() {
        val apiRequest = ApiRequest().apply {
            content_master_id = stayInformedList[currentClickStayInformedPosition].content_master_id
            is_active =
                if (stayInformedList[currentClickStayInformedPosition].bookmarked == "Y") "N" else "Y"
        }
        engageContentViewModel.updateBookmarks(
            apiRequest,
            analytics,
            stayInformedList[currentClickStayInformedPosition].content_type,
            screenName = AnalyticsScreenNames.Home
        )
    }

    private fun testsListHome() {
        if (AppFlagHandler.isToHideDiagnosticTest(firebaseConfigUtil)) {
            handleTestListHomeResponse(null)
            // if diagnostic test hidden, then continue to call next API
            stayInformed()
        } else {
            val apiRequest = ApiRequest().apply {
                separate = "No"
            }
            doctorViewModel.testsListHome(apiRequest)
        }
    }

    var catReadingName = ""
    var catReadingMasterId = ""

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.sendEmailVerificationLinkLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                analytics.logEvent(
                    analytics.USER_CLICKED_ON_EMAIL_VERIFICATION /*NEW_USER_EMAIL_VERIFICATION*/,
                    screenName = AnalyticsScreenNames.Home
                )
                showMessage(responseBody.message)
                /*binding.textViewVerifyEmail.text = responseBody.message*/
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        goalReadingViewModel.dailySummaryLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setGoalReadingData(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                false
            })

        goalReadingViewModel.getPollQuizLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data.let {
                    setQuizPollData(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                setQuizPollData(null)
                true
            })

        goalReadingViewModel.getCatSurveyLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    it.survey_id?.let { it1 ->
                        catReadingMasterId = it.readings_master_id ?: ""
                        catReadingName = it.reading_name ?: ""

                        catSurveyData = it
                        isQuizPoleSurvey = false
                        currentQuizPollPosition = -1
                        requireActivity().runOnUiThread {
                            initSurvey(it1)
                        }
                    }
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        goalReadingViewModel.addCatSurveyLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()

                /*if (currentClickReadingPos != -1 && currentClickReadingPos < readingList.size) {
                    val goalReadingData = readingList[currentClickReadingPos]
                    analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                        putString(analytics.PARAM_READING_NAME, goalReadingData.reading_name)
                        putString(analytics.PARAM_READING_ID, goalReadingData.readings_master_id)
                    })
                }*/

                analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                    putString(analytics.PARAM_READING_NAME, catReadingName)
                    putString(analytics.PARAM_READING_ID, catReadingMasterId)
                }, screenName = AnalyticsScreenNames.LogReading)

                //todo Ankit - Instead of this used myHealthInsights API
                dailySummary()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        engageContentViewModel.stayInformedLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                stayInformedList.clear()
                responseBody.data?.let { stayInformedList.addAll(it) }
                homeStayInformedAdapter.notifyDataSetChanged()
                if (stayInformedList.isEmpty()) {
                    binding.textViewLabelStayInformed.visibility = View.VISIBLE
                    binding.tvViewAll.visibility = View.VISIBLE
                }
                handleScrollAsPerDeepLinkScreenSection()
            },
            onError = { throwable ->
                hideLoader()
                if (stayInformedList.isEmpty()) {
                    binding.textViewLabelStayInformed.visibility = View.GONE
                    binding.tvViewAll.visibility = View.GONE
                }
                handleScrollAsPerDeepLinkScreenSection()
                false
            })

        engageContentViewModel.recommendedContentLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                recommendedList.clear()
                responseBody.data?.let { recommendedList.addAll(it) }
                homeRecommendedAdapter.notifyDataSetChanged()

                if (recommendedList.isEmpty()) {
                    binding.textViewLabelRecommendedForYou.visibility = View.GONE
                } else {
                    binding.textViewLabelRecommendedForYou.visibility = View.VISIBLE
                }

                testsListHome()
            },
            onError = { throwable ->
                hideLoader()
                if (recommendedList.isEmpty()) {
                    binding.textViewLabelRecommendedForYou.visibility = View.GONE
                } else {
                    binding.textViewLabelRecommendedForYou.visibility = View.VISIBLE
                }

                testsListHome()
                false
            })

        //updateBookmarksLiveData
        engageContentViewModel.updateBookmarksLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (currentClickStayInformedPosition != -1 && stayInformedList.size > currentClickStayInformedPosition) {
                    if (stayInformedList[currentClickStayInformedPosition].bookmarked == "Y")
                        stayInformedList[currentClickStayInformedPosition].bookmarked = "N"
                    else
                        stayInformedList[currentClickStayInformedPosition].bookmarked = "Y"

                    //homeStayInformedAdapter.notifyItemChanged(currentClickStayInformedPosition)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //testsListHomeLiveData
        doctorViewModel.testsListHomeLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                handleTestListHomeResponse(responseBody.data)
                stayInformed()
            },
            onError = { throwable ->
                hideLoader()
                handleTestListHomeResponse(null)
                stayInformed()
                false
            })

        patientPlansViewModel.homePlansListLiveData.observe(this,
            onChange = { responseBody ->
                binding.rvPlans.apply {
                    layoutManager =
                        LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
                    adapter = homePlanAdapter
                }

                hideLoader()
                homePlanList.clear()
                responseBody.data?.let { homePlanList.addAll(it) }
                homePlanAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                hideLoader()
                false
            })



        goalReadingViewModel.myHealthInsightsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    setMyInsightData(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                binding.layoutUpdateYourReading.isVisible = false
                true
            })

        patientPlansViewModel.hcDevicePlanLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                hcDevicePlan = responseBody.data
            },
            onError = { throwable ->
                hideLoader()
                hcDevicePlan = HcDevicePlan()
                true
            })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun handleTestListHomeResponse(arrayList: ArrayList<TestPackageData>?) {
        if (isAdded) {
            with(binding) {
                bookTestList.clear()
                arrayList?.let { bookTestList.addAll(it) }
                homeBookTestAdapter.notifyDataSetChanged()
                //todo Change done by Ankit
                layoutBookYourTest.isVisible = false
                //layoutBookYourTest.isVisible = bookTestList.isEmpty().not()
            }
        }
    }

    var deepLinkGoalKey = ""
    //private var deepLinkReadingKey = ""

    @SuppressLint("NotifyDataSetChanged")
    private fun setGoalReadingData(dailySummaryData: DailySummaryData) {
        // goals
        allDailySummaryList.clear()
        dailySummaryData.goals.let { it1 -> allDailySummaryList.addAll(it1!!) }

        if (allDailySummaryList.any { it.keys == Goals.Medication.goalKey }) {
            try {
                val medicationPercentageRatio =
                    (allDailySummaryList.single { it.keys == Goals.Medication.goalKey }.achieved_value?.toDouble()
                        ?: 0.0) / (allDailySummaryList.single { it.keys == Goals.Medication.goalKey }.goal_value?.toDouble()
                        ?: 0.0)

                if (Doubles.isFinite(medicationPercentageRatio)) {
                    if (medicationPercentageRatio == 0.0) {
                        binding.ivMedicine.loadDrawable(R.drawable.ic_medicine)
                    } else if (medicationPercentageRatio > 0.75) {
                        binding.tvMedicineValue.text = "${
                            (allDailySummaryList.single { it.keys == Goals.Medication.goalKey }.achieved_value?.toDouble()
                                ?: 0.0).toInt()
                        }/${
                            (allDailySummaryList.single { it.keys == Goals.Medication.goalKey }.goal_value?.toDouble()
                                ?: 0.0).toInt()
                        } doses"

                        binding.ivMedicine.loadDrawable(R.drawable.ic_medicinegreen)
                        binding.pbMedicine.isVisible = true
                        binding.pbMedicine.progress = (medicationPercentageRatio * 100).roundToInt()
                        binding.pbMedicine.trackColor =
                            requireContext().getColor(R.color.colorLightGreen)
                        binding.pbMedicine.setIndicatorColor(requireContext().getColor(R.color.colorDarkGreen1))
                    } else if (medicationPercentageRatio < 0.75) {
                        binding.tvMedicineValue.text = "${
                            (allDailySummaryList.single { it.keys == Goals.Medication.goalKey }.achieved_value?.toDouble()
                                ?: 0.0).toInt()
                        }/${
                            (allDailySummaryList.single { it.keys == Goals.Medication.goalKey }.goal_value?.toDouble()
                                ?: 0.0).toInt()
                        } doses"

                        binding.ivMedicine.loadDrawable(R.drawable.ic_medicinorange)
                        binding.pbMedicine.isVisible = true
                        binding.pbMedicine.progress = (medicationPercentageRatio * 100).roundToInt()
                        binding.pbMedicine.trackColor =
                            requireContext().getColor(R.color.progress_light_orange)
                        binding.pbMedicine.setIndicatorColor(requireContext().getColor(R.color.progress_orange))
                    }
                }
            } catch (e: Exception) {
                binding.ivMedicine.loadDrawable(R.drawable.ic_medicine)
            }

            binding.clMedicine.isVisible = true
        } else {
            binding.clMedicine.isVisible = false
        }


        if (allDailySummaryList.any { it.keys == Goals.Diet.goalKey }) {
            try {
                val dietPercentageRatio =
                    (allDailySummaryList.single { it.keys == Goals.Diet.goalKey }.achieved_value?.toDouble()
                        ?: 0.0) / (allDailySummaryList.single { it.keys == Goals.Diet.goalKey }.goal_value?.toDouble()
                        ?: 0.0)

                if (Doubles.isFinite(dietPercentageRatio)) {
                    if (dietPercentageRatio == 0.0) {
                        binding.ivDiet.loadDrawable(R.drawable.ic_diet)
                    } else if (dietPercentageRatio > 0.75) {
                        binding.tvDietValue.text = "${
                            (allDailySummaryList.single { it.keys == Goals.Diet.goalKey }.achieved_value?.toDouble()
                                ?: 0.0).toInt()
                        }/${
                            (allDailySummaryList.single { it.keys == Goals.Diet.goalKey }.goal_value?.toDouble()
                                ?: 0.0).toInt()
                        } cal"
                        binding.ivDiet.loadDrawable(R.drawable.ic_dietgreen)

                        binding.pbDiet.isVisible = true
                        binding.pbDiet.progress = (dietPercentageRatio * 100).roundToInt()
                        binding.pbDiet.trackColor =
                            requireContext().getColor(R.color.colorLightGreen)
                        binding.pbDiet.setIndicatorColor(requireContext().getColor(R.color.colorDarkGreen1))

                    } else if (dietPercentageRatio < 0.75) {
                        binding.tvDietValue.text = "${
                            (allDailySummaryList.single { it.keys == Goals.Diet.goalKey }.achieved_value?.toDouble()
                                ?: 0.0).toInt()
                        }/${
                            (allDailySummaryList.single { it.keys == Goals.Diet.goalKey }.goal_value?.toDouble()
                                ?: 0.0).toInt()
                        } cal"
                        binding.ivDiet.loadDrawable(R.drawable.ic_dietorange)

                        binding.pbDiet.isVisible = true
                        binding.pbDiet.progress = (dietPercentageRatio * 100).roundToInt()
                        binding.pbDiet.trackColor =
                            requireContext().getColor(R.color.progress_light_orange)
                        binding.pbDiet.setIndicatorColor(requireContext().getColor(R.color.progress_orange))
                    }
                }
            } catch (e: Exception) {
                binding.ivDiet.loadDrawable(R.drawable.ic_diet)
            }
            binding.clDiet.isVisible = true
        } else {
            binding.clDiet.isVisible = false
        }

        if (allDailySummaryList.any { it.keys == Goals.Exercise.goalKey }) {
            try {
                val exercisePercentageRatio =
                    (allDailySummaryList.single { it.keys == Goals.Exercise.goalKey }.achieved_value?.toDouble()
                        ?: 0.0) / (allDailySummaryList.single { it.keys == Goals.Exercise.goalKey }.goal_value?.toDouble()
                        ?: 0.0)

                if (Doubles.isFinite(exercisePercentageRatio)) {
                    if (exercisePercentageRatio == 0.0) {
                        binding.ivExercise.loadDrawable(R.drawable.ic_exercise_black)
                    } else if (exercisePercentageRatio > 0.75) {
                        binding.tvExerciseValue.text = "${
                            (allDailySummaryList.single { it.keys == Goals.Exercise.goalKey }.achieved_value?.toDouble()
                                ?: 0.0)
                        }/${
                            (allDailySummaryList.single { it.keys == Goals.Exercise.goalKey }.goal_value?.toDouble()
                                ?: 0.0)
                        } minutes"
                        binding.ivExercise.loadDrawable(R.drawable.ic_exercisegreen)

                        binding.pbExercise.isVisible = true
                        binding.pbExercise.progress = (exercisePercentageRatio * 100).roundToInt()
                        binding.pbExercise.trackColor =
                            requireContext().getColor(R.color.colorLightGreen)
                        binding.pbExercise.setIndicatorColor(requireContext().getColor(R.color.colorDarkGreen1))

                    } else if (exercisePercentageRatio < 0.75) {
                        binding.tvExerciseValue.text = "${
                            (allDailySummaryList.single { it.keys == Goals.Exercise.goalKey }.achieved_value?.toDouble()
                                ?: 0.0)
                        }/${
                            (allDailySummaryList.single { it.keys == Goals.Exercise.goalKey }.goal_value?.toDouble()
                                ?: 0.0)
                        } minutes"
                        binding.ivExercise.loadDrawable(R.drawable.ic_exerciseorange)

                        binding.pbExercise.isVisible = true
                        binding.pbExercise.progress = (exercisePercentageRatio * 100).roundToInt()
                        binding.pbExercise.trackColor =
                            requireContext().getColor(R.color.progress_light_orange)
                        binding.pbExercise.setIndicatorColor(requireContext().getColor(R.color.progress_orange))
                    }
                }
            } catch (e: Exception) {
                binding.ivExercise.loadDrawable(R.drawable.ic_exercise_black)
            }
            binding.clExercise.isVisible = true
        } else {
            binding.clExercise.isVisible = false
        }


        /** ****************************************************************
         * below logic to completed full exercise or breathing from
         * exercise plan is again removed as per sprint of december 2022,
         * hence commented
         *******************************************************************/
        /*allDailySummaryList.forEachIndexed { index, goalReadingData ->
            //update achieved value as goal in goals list, if breathing is done from today's plan
            //to show as completed
            if (dailySummaryData.mark_as_today?.breathing_done == "Y"
                && goalReadingData.keys == Goals.Pranayam.goalKey
            ) {
                allDailySummaryList[index].isBreathingOrExerciseDone = true
                allDailySummaryList[index].todays_achieved_value =
                    allDailySummaryList[index].goal_value
            }

            //update achieved value as goal in goals list, if exercise is done from today's plan
            //to show as completed
            if (dailySummaryData.mark_as_today?.exercise_done == "Y"
                && goalReadingData.keys == Goals.Exercise.goalKey
            ) {
                allDailySummaryList[index].isBreathingOrExerciseDone = true
                allDailySummaryList[index].todays_achieved_value =
                    allDailySummaryList[index].goal_value
            }
        }*/

        dailySummaryList.clear()
        dailySummaryList.addAll(allDailySummaryList.take(4))
        homeDailySummaryAdapter.notifyDataSetChanged()

        if (allDailySummaryList.size > 4) {
            binding.textViewDailySummaryMoreLess.visibility = View.VISIBLE
        } else {
            binding.textViewDailySummaryMoreLess.visibility = View.GONE
        }

        toggleDailySummaryData()

        //readings
        val readList = dailySummaryData.readings


        //handle navigation for notification data
        if (notification != null) {
            when (notification?.flag) {
                Common.NotificationTag.LogGoal -> {
                    val index = allDailySummaryList
                        .indexOfFirst { it.keys == notification?.other_details?.key }
                    if (index != -1) {

                        analytics.logEvent(analytics.USER_CLICKED_REMINDER_NOTIFICATION,
                            Bundle().apply {
                                putString(
                                    analytics.PARAM_GOAL_NAME,
                                    allDailySummaryList[index].goal_name
                                )
                                putString(
                                    analytics.PARAM_GOAL_ID,
                                    allDailySummaryList[index].goal_master_id
                                )
                            })

                        handleGoalLogsNavigation(index)
                    }
                }

                Common.NotificationTag.LogReading -> {
                    val index = readList
                        ?.indexOfFirst { it.keys == notification?.other_details?.key }
                    if (index != -1) {

                        analytics.logEvent(analytics.USER_CLICKED_REMINDER_NOTIFICATION,
                            Bundle().apply {
                                putString(
                                    analytics.PARAM_READING_NAME,
                                    index?.let { readList[it].reading_name }
                                )
                                putString(
                                    analytics.PARAM_READING_ID,
                                    index?.let { readList[it].readings_master_id }
                                )
                            })

                        index?.let { navigateToLogReadings(it) }
                    }
                }
            }
            // set notification as null after handling navigation
            notification = null
        }

        //handle navigation for LogGoal deeplink
        if (deepLinkGoalKey.isNotBlank()) {
            val index = allDailySummaryList.indexOfFirst { it.keys == deepLinkGoalKey }
            if (index != -1) {
                handleGoalLogsNavigation(index)
            }
            deepLinkGoalKey = ""
        }

        //start coachmarks for first time
        /*if (appPreferences.isCoachMarksCompleted().not()) {
            appPreferences.setCoachMarksCompleted(true)
            (requireActivity() as HomeActivity).initCoachMarks()
        }*/
    }

    private fun setMyInsightData(dailySummaryData: MyHealthInsightData) {
        readingList.clear()
        goalList.clear()
        dailySummaryData.readings.let {
            if (it != null) {
                readingList.addAll(it)
            }
        }
        dailySummaryData.goals.let {
            if (it != null) {
                for (d in it) {
                    if (d.goal_name == "Diet" || d.goal_name == "Medication" || d.goal_name == "Exercise") {
                    } else {
                        goalList.add(d)
                    }
                }
            }
        }

        homeUpdateReadingAdapter.notifyDataSetChanged()
        homeGoalAdapter.notifyDataSetChanged()
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setQuizPollData(quizPoleMainData: QuizPoleMainData?) {
        if (quizPoleMainData != null
            && (quizPoleMainData.poll_data.isNullOrEmpty()
                .not() || quizPoleMainData.quiz_data.isNullOrEmpty().not())
        ) {
            quizPoleList.clear()
            quizPoleMainData.poll_data?.let { quizPoleList.addAll(it) }
            quizPoleMainData.quiz_data?.let { quizPoleList.addAll(it) }
            homeQuizPolePagerAdapter.notifyDataSetChanged()

        } else {
            session.user?.let {
                with(binding) {
                    if (AppFlagHandler.isToHideDoctorSays(firebaseConfigUtil)
                        || it.doctor_says?.description.isNullOrBlank()
                    ) {
                        clHealthTips.visibility = View.GONE
                    } else {
                        clHealthTips.visibility = View.VISIBLE
                        textViewDoctorQuote.text = it.doctor_says?.description
                    }
                }
            }
        }
        //temp to check
        /*session.user?.let {
            binding.layoutDoctorSays.visibility = View.VISIBLE
            binding.textViewLabelDoctorSays.text = it.doctor_says?.title
            binding.textViewDoctorQuote.text = it.doctor_says?.description
        }*/
    }

}