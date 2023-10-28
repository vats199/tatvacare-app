package com.mytatva.patient.ui.careplan.fragment

import android.annotation.SuppressLint
import android.content.Intent
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
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.transition.AutoTransition
import androidx.transition.TransitionManager
import androidx.viewpager.widget.ViewPager
import com.google.gson.Gson
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.*
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.*
import com.mytatva.patient.databinding.CarePlanFragmentCarePlanBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.activity.VideoActivity
import com.mytatva.patient.ui.appointment.fragment.AllAppointmentsFragment
import com.mytatva.patient.ui.appointment.fragment.BookAppointmentsFragment
import com.mytatva.patient.ui.auth.fragment.SetupDrugsFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.careplan.adapter.*
import com.mytatva.patient.ui.careplan.dialog.RequestCallbackDialog
import com.mytatva.patient.ui.careplan.dialog.RequestCallbackSuccessDialog
import com.mytatva.patient.ui.goal.fragment.LogFoodFragment
import com.mytatva.patient.ui.goal.fragment.UpdateGoalLogsFragment
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.home.adapter.HomeBookTestAdapter
import com.mytatva.patient.ui.labtest.fragment.LabTestDetailsFragment
import com.mytatva.patient.ui.labtest.fragment.LabTestListFragment
import com.mytatva.patient.ui.menu.adapter.CarePlanHistoryRecordAdapter
import com.mytatva.patient.ui.menu.fragment.HistoryFragment
import com.mytatva.patient.ui.menu.fragment.UploadRecordFragment
import com.mytatva.patient.ui.reading.fragment.UpdateReadingsMainFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.apputils.PlanFeatureHandler
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.surveysparrow.ss_android_sdk.SurveySparrow
import kotlinx.coroutines.*
import org.json.JSONArray
import smartdevelop.ir.eram.showcaseviewlib.GuideView
import smartdevelop.ir.eram.showcaseviewlib.config.Gravity
import smartdevelop.ir.eram.showcaseviewlib.listener.GuideListener

class CarePlanFragment : BaseFragment<CarePlanFragmentCarePlanBinding>() {

    /*private val downloadHelper: DownloadHelper by lazy {
        DownloadHelper(requireActivity())
    }*/

    //private var incidentSurveyData: IncidentSurveyData? = null

    private var catReadingName = ""
    private var catReadingMasterId = ""

    private var diet: Diet? = null

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[DoctorViewModel::class.java]
    }

    // reading history params
    private val allReadingHistoryList = arrayListOf<GoalReadingData>()
    private val readingHistoryList1 = arrayListOf<GoalReadingData>()
    private val readingHistoryLargeAdapter by lazy {
        ReadingHistoryLargeAdapter(readingHistoryList1,
            object : ReadingHistoryLargeAdapter.AdapterListener {
                override fun onClick(position: Int, view: View) {
                    //openReadingSummary(position)
                    handleOnReadingItemClick(position, view)
                }
            })
    }

    private fun handleOnReadingItemClick(position: Int, view: View) {
        currentClickReadingPos = position

        if (allReadingHistoryList[position].not_configured.isNullOrBlank().not()) {
            //if not configured, then show message, else default flow
            showMessage(allReadingHistoryList[position].not_configured ?: "")
        } else {
            if (allReadingHistoryList[position].graph == "Y") {
                openReadingSummary(position, view)
            } else {
                navigateToLogReadings(position, view)
            }
        }
    }

    private fun openReadingSummary(position: Int, view: View) {
        /*if (allReadingHistoryList[position].getReadingLabel.isNotBlank()
            && allReadingHistoryList[position].updated_at.isNullOrBlank().not()
        ) {*/

        if (position >= 0 && position < allReadingHistoryList.size) {
            analytics.logEvent(analytics.USER_TAP_ON_CAREPLAN_READING, Bundle().apply {
                putString(analytics.PARAM_READING_ID,
                    allReadingHistoryList[position].readings_master_id)
                putString(analytics.PARAM_READING_NAME,
                    allReadingHistoryList[position].reading_name)
            }, screenName = AnalyticsScreenNames.CarePlan)

            navigator.loadActivity(TransparentActivity::class.java,
                ReadingSummaryCommonFragment::class.java)
                /*.addSharedElements(listOf(
                    androidx.core.util.Pair(view, view.transitionName)
                ))*/.addBundle(bundleOf(Pair(Common.BundleKey.POSITION, position),
                    Pair(Common.BundleKey.READING_LIST, allReadingHistoryList))).start()
        }

        /*}*/
    }

    private var currentClickReadingPos = -1
    private fun navigateToLogReadings(position: Int, view: View) {
        if (isFeatureAllowedAsPerPlan(PlanFeatures.reading_logs,
                allReadingHistoryList[position].keys ?: "")
        ) {

            if (allReadingHistoryList[position].keys == Readings.CAT.readingKey) {
                getCatSurvey()
            } else {
                navigator.loadActivity(TransparentActivity::class.java,
                    UpdateReadingsMainFragment::class.java)
                    /*.addSharedElements(listOf(
                        androidx.core.util.Pair(view, view.transitionName)
                    ))*/.addBundle(bundleOf(Pair(Common.BundleKey.POSITION, position),
                        Pair(Common.BundleKey.READING_LIST, allReadingHistoryList))).start()
            }
        }
    }

    private val readingHistoryList2 = arrayListOf<GoalReadingData>()
    private val readingHistorySmallAdapter by lazy {
        ReadingHistorySmallAdapter(readingHistoryList2,
            object : ReadingHistorySmallAdapter.AdapterListener {
                override fun onClick(position: Int, view: View) {
                    // pass with adding 2 here for all reading list
                    //openReadingSummary(position + 2)
                    handleOnReadingItemClick(position + 2, view)
                }
            })
    }

    //appointments
    private val appointmentList = arrayListOf<AppointmentData>()
    private val carePlanAppointmentAdapter by lazy {
        CarePlanAppointmentAdapter(appointmentList,
            navigator,
            object : CarePlanAppointmentAdapter.AdapterListener {
                override fun onCancelClick(position: Int) {
                    currentClickAppointmentPosition = position
                    navigator.showAlertDialogWithOptions(getString(R.string.alert_msg_cancel_appointment),
                        dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                            override fun onYesClick() {
                                cancelAppointment(appointmentList[position])
                            }

                            override fun onNoClick() {

                            }
                        })
                }

                override fun onJoinVideoClick(position: Int) {
                    if (VideoActivity.isPictureInPictureModeActive) {
                        //just re-launch the activity to open activity again to view in full mode

                        navigator.loadActivity(VideoActivity::class.java).start()

                    } else {

                        currentClickAppointmentPosition = position
                        getVoiceToken(appointmentList[position])

                        analytics.logEvent(analytics.CAREPLAN_APPOINTMENT_JOIN_VIDEO,
                            Bundle().apply {
                                putString(analytics.PARAM_APPOINTMENT_ID,
                                    appointmentList[currentClickAppointmentPosition].appointment_id)
                                putString(analytics.PARAM_TYPE,
                                    appointmentList[currentClickAppointmentPosition].type)
                            },
                            screenName = AnalyticsScreenNames.CarePlan)

                    }
                }
            })
    }
    private var currentClickAppointmentPosition = -1

    //diet plans
    private val dietPlanList = arrayListOf<Diet>()
    private val carePlanDietPlanAdapter by lazy {
        CarePlanDietPlanAdapter(dietPlanList, object : CarePlanDietPlanAdapter.AdapterListener {
            override fun onDownloadClick(position: Int, diet: Diet) {
                analytics.logEvent(analytics.USER_CLICKED_ON_DIET_PLAN_CARD,
                    Bundle().apply {
                        putString(analytics.PARAM_DIET_START_DATE, diet.start_date)
                        putString(analytics.PARAM_DIET_END_DATE, diet.valid_till)
                        putString(analytics.PARAM_FEATURE_STATUS,
                            PlanFeatureHandler.FeatureStatus.ACTIVE)
                    }, screenName = AnalyticsScreenNames.CarePlan)


                analytics.logEvent(analytics.DIET_PLAN_DOWNLOAD,
                    Bundle().apply {
                        putString(analytics.PARAM_DIET_START_DATE, diet.start_date)
                        putString(analytics.PARAM_DIET_END_DATE, diet.valid_till)
                    }, screenName = AnalyticsScreenNames.CarePlan)

                if (diet.document_url.isNullOrBlank().not()
                    && diet.document_name.isNullOrBlank().not()
                ) {

                    val fileName = if (diet.file_name.isNullOrBlank())
                        diet.document_title + diet.document_name
                    else
                        diet.file_name

                    downloadHelper.startDownload(diet.document_url!!, fileName, downloadHelper.DIR_DIET_PLAN)


                }
            }
        })
    }

    //prescriptions
    private val prescriptionMedicationList = arrayListOf<PrescriptionMedicationData>()
    private val prescriptionMedicationAdapter by lazy {
        PrescriptionMedicationAdapter(prescriptionMedicationList,
            object : PrescriptionMedicationAdapter.AdapterListener {
                override fun onOrderMedicineClick(position: Int) {
                    activity?.supportFragmentManager?.let {
                        RequestCallbackDialog {
                            prescriptionMedicationList[position].patient_dose_rel_id?.let { it1 ->
                                requestPrescriptionCardCallback(it1, "P")
                            }
                        }.show(it, RequestCallbackDialog::class.java.simpleName)
                    }
                }

                override fun onOrderTestClick(position: Int) {

                }
            })
    }

    //records
    private val recordList = arrayListOf<RecordData>()
    private val recordAdapter by lazy {
        CarePlanHistoryRecordAdapter(recordList,
            object : CarePlanHistoryRecordAdapter.AdapterListener {
                override fun onPDFClick(position: Int) {
                    analytics.logEvent(analytics.USER_CLICKED_ON_RECORD, Bundle().apply {
                        putString(analytics.PARAM_PATIENT_RECORDS_ID,
                            recordList[position].patient_records_id)
                    }, screenName = AnalyticsScreenNames.CarePlan)
                    recordList[position].document_url?.firstOrNull()?.let {
                        openPdfViewer(it)
                        // Load the PDF file into the PDFView
                    }
                }

                override fun onImageClick(position: Int) {
                    analytics.logEvent(analytics.USER_CLICKED_ON_RECORD, Bundle().apply {
                        putString(analytics.PARAM_PATIENT_RECORDS_ID,
                            recordList[position].patient_records_id)
                    }, screenName = AnalyticsScreenNames.CarePlan)
                    recordList[position].document_url?.firstOrNull()?.let {
                        navigator.showImageViewerDialog(arrayListOf(it))
                    }
                }
            })
    }

    //book your test
    private val bookTestList = arrayListOf<TestPackageData>()
    private val homeBookTestAdapter by lazy {
        HomeBookTestAdapter(bookTestList, object : HomeBookTestAdapter.AdapterListener {
            override fun onClick(position: Int) {

                analytics.logEvent(analytics.CAREPLAN_LABTEST_CARD_CLICKED, Bundle().apply {
                    putString(analytics.PARAM_LAB_TEST_ID, bookTestList[position].lab_test_id)
                }, screenName = AnalyticsScreenNames.CarePlan)

                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LabTestDetailsFragment::class.java)
                    .addBundle(bundleOf(Pair(Common.BundleKey.LAB_TEST_ID,
                        bookTestList[position].lab_test_id))).start()
            }
        })
    }

    // goal summary params
    private var chartDuration = ChartDurations.SEVEN_DAYS
    private val goalsList = arrayListOf<GoalReadingData>()

    private val callbackUpdateGoal: (() -> Unit) = {

        if (isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs,
                goalsList[currentGoalsPosition].keys ?: "")
        ) {

            if (goalsList[currentGoalsPosition].keys == Goals.Diet.goalKey) {

                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LogFoodFragment::class.java).start()

                /*navigator.loadActivity(IsolatedFullActivity::class.java,
                    FoodDiaryMainFragment::class.java)
                    .start()*/

            } else {
                navigator.loadActivity(TransparentActivity::class.java,
                    UpdateGoalLogsFragment::class.java)
                    .addBundle(bundleOf(Pair(Common.BundleKey.POSITION, currentGoalsPosition),
                        Pair(Common.BundleKey.GOAL_LIST, goalsList))).start()
            }

        }
    }

    private var viewPagerAdapter: CarePlanViewPagerAdapter? = null
    private val goalSummaryMedicationFragment by lazy {
        GoalSummaryMedicationFragment().apply {
            callbackOnUpdate = callbackUpdateGoal
        }
    }
    private val goalSummaryMedicationChartFragment by lazy {
        GoalSummaryCommonFragment().apply {
            callbackOnUpdate = callbackUpdateGoal
        }
    }
    private val goalSummaryPranayamFragment by lazy {
        GoalSummaryCommonFragment().apply {
            callbackOnUpdate = callbackUpdateGoal
        }
    }
    private val goalSummaryStepsFragment by lazy {
        GoalSummaryCommonFragment().apply {
            callbackOnUpdate = callbackUpdateGoal
        }
    }
    private val goalSummaryExerciseFragment by lazy {
        GoalSummaryCommonFragment().apply {
            callbackOnUpdate = callbackUpdateGoal
        }
    }
    private val goalSummarySleepFragment by lazy {
        GoalSummaryCommonFragment().apply {
            callbackOnUpdate = callbackUpdateGoal
        }
    }
    private val goalSummaryWaterFragment by lazy {
        GoalSummaryCommonFragment().apply {
            callbackOnUpdate = callbackUpdateGoal
        }
    }
    private val goalSummaryDietFragment by lazy {
        GoalSummaryCommonFragment().apply {
            callbackOnUpdate = callbackUpdateGoal
        }
    }
    //========================

    var currentGoalsPosition = 0
    val goalsSequenceListAsPerPager = arrayListOf<Goals>()

    val currentPagerGoal: Goals
        get() {
            return goalsSequenceListAsPerPager[currentGoalsPosition]
        }

    var catSurveyData: CatSurveyData? = null

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): CarePlanFragmentCarePlanBinding {
        return CarePlanFragmentCarePlanBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
        //downloadHelper.registerReceiver()
    }

    override fun onDestroy() {
        super.onDestroy()
        //activity?.unregisterReceiver(onComplete)
        //downloadHelper.unregisterReceiver()
    }

    //val callApiJob:Job
    var callApiJob: Job? = null

    override fun onShow() {
        super.onShow()
        setUpToolbar()
        setUpInitialData()
        clearGoalsChartsData()
        callApiJob?.cancel()
        callApiJob = GlobalScope.launch(Dispatchers.Main) {
            delay(500)
            callAPIS()
            updateNotificationCountBadge()
        }
    }

    private fun setUpInitialData() {
        with(binding) {
            if (session.user?.getNutritionistHCName.isNullOrBlank().not()) {
                textViewLabelDietPlanBy.text =
                    "${getString(R.string.care_plan_label_diet_plan_by)} ${session.user?.getNutritionistHCName ?: ""}"
            }

            PlanFeatureHandler.handleFeatureAccess(
                layoutDietLocked, navigator,
                isFeatureAllowedAsPerPlan(PlanFeatures.diet_plan, needToShowDialog = false),
                analytics = analytics,
                eventName = analytics.USER_CLICKED_ON_DIET_PLAN_CARD,
                screenName = AnalyticsScreenNames.CarePlan
            )
        }
    }

    override fun onResume() {
        super.onResume()
        session.user?.let {
            readingHistorySmallAdapter.user = it
            readingHistoryLargeAdapter.user = it
        }
        Handler(Looper.getMainLooper()).postDelayed({
            if (isAdded && isVisible) {
                onShow()
            }
        }, 100)

        //updateNotificationCountBadge()
    }

    private fun callAPIS() {
        Log.e("callApisOnShow", "callApisOnShow: CAREPLAN")
        dailySummary()
        Handler(Looper.getMainLooper()).postDelayed({
            if (isAdded) {

                // if incident is there to show then call API and
                // show the incident layout
                if (AppFlagHandler.isToHideIncidentSurvey(firebaseConfigUtil).not()) {
                    if (HomeActivity.incidentSurveyData != null) {
                        binding.layoutIncident.isVisible = true
                        getIncidentFreeDays()
                    } else {
                        binding.layoutIncident.isVisible = false
                    }
                }
                //getIncidentSurvey()

                prescriptionMedicineList()

                if (requireActivity() is HomeActivity) {
                    (requireActivity() as HomeActivity).getPatientDetails()
                }
                with(binding) {
                    layoutAppointment.isVisible = true
                    todaysAppointment()

                    /*if (session.user?.isToShowAppointmentModule == true) {
                        layoutAppointment.isVisible = true
                        todaysAppointment()
                    } else {
                        layoutAppointment.isVisible = false
                        getRecords()
                    }*/
                }
            }
        }, 100)
    }

    override fun bindData() {
        setUpRecyclerView()
        setViewListeners()
        //setUpToolbar()
        setUpPrescriptionMedication()
        setUpNestedScrollListener()
        //getIncidentFreeDays()

        /*if (session.user?.isNaflOrNashPatient == true) {
            with(binding) {
                layoutIncident.visibility = View.GONE
            }
        }*/
    }

    private fun setUpNestedScrollListener() {
        binding.nestedScrollView.viewTreeObserver.addOnScrollChangedListener {
            if (isAdded && isVisible) {
                val view: View =
                    binding.nestedScrollView.getChildAt(binding.nestedScrollView.childCount - 1) as View
                val diff: Int =
                    view.bottom - (binding.nestedScrollView.height + binding.nestedScrollView.scrollY)
                if (diff == 0 /*&& isMoreDataAvailable*/) {
                    //page reached end
                    analytics.logEvent(analytics.USER_SCROLL_DEPTH_CARE_PLAN,
                        screenName = AnalyticsScreenNames.CarePlan)
                }
            }
        }
    }

    var deepLinkScreenSection: String? = null
    private fun handleScrollAsPerDeepLinkScreenSection() {
        deepLinkScreenSection?.let {
            Handler(Looper.getMainLooper()).postDelayed({
                if (isAdded && isVisible) {
                    when (it) {
                        "Records" -> {
                            binding.nestedScrollView.smoothScrollTo(0, binding.layoutRecords.bottom)
                        }
                        "Prescription" -> {
                            binding.nestedScrollView.smoothScrollTo(0,
                                binding.layoutPrescriptions.top)
                        }
                    }
                }
                deepLinkScreenSection = null
            }, 0)
        }
    }

    private fun setUpPrescriptionMedication() {
        with(binding) {
            recyclerViewAppointment.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = carePlanAppointmentAdapter
            }

            recyclerViewDietPlan.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = carePlanDietPlanAdapter
            }

            recyclerViewPrescriptionMedication.apply {
                layoutManager = LinearLayoutManager(requireActivity(), RecyclerView.VERTICAL, false)
                adapter = prescriptionMedicationAdapter
            }

            recyclerViewRecords.apply {
                layoutManager =
                    LinearLayoutManager(requireActivity(), RecyclerView.HORIZONTAL, false)
                adapter = recordAdapter
            }
        }
    }

    private fun setUpGoalSummary() {
        with(binding) {
            if (viewPagerAdapter == null) {
                viewPagerAdapter = CarePlanViewPagerAdapter(childFragmentManager)
                viewPagerGoalSummary.adapter = viewPagerAdapter
                viewPagerGoalSummary.offscreenPageLimit = 2
                viewPagerGoalSummary.setPaddingRelative(resources.getDimension(R.dimen.dp_20)
                    .toInt(), 0, resources.getDimension(R.dimen.dp_20).toInt(), 0)
                viewPagerGoalSummary.clipToPadding = false

                viewPagerGoalSummary.addOnPageChangeListener(object :
                    ViewPager.OnPageChangeListener {
                    override fun onPageScrolled(
                        position: Int,
                        positionOffset: Float,
                        positionOffsetPixels: Int,
                    ) {

                    }

                    override fun onPageSelected(position: Int) {
                        currentGoalsPosition = position
                        Handler(Looper.getMainLooper()).postDelayed({
                            if (isAdded) {
                                reloadCurrentPageData()
                            }
                        }, 0)
                    }

                    override fun onPageScrollStateChanged(state: Int) {

                    }
                })
            }

            addFragmentsForGoalSummary()
            viewPagerGoalSummary.currentItem = currentGoalsPosition
            dotsIndicator.setViewPager(viewPagerGoalSummary)
            viewPagerAdapter?.notifyDataSetChanged()

            Handler(Looper.getMainLooper()).postDelayed({
                if (isAdded) {
                    reloadCurrentPageData()
                }
            }, 50)
        }
    }

    var callGoalRecordApiJob: Job? = null
    private fun reloadCurrentPageData() {
        callGoalRecordApiJob?.cancel()
        callGoalRecordApiJob = GlobalScope.launch(Dispatchers.Main) {
            delay(400)
            if (isAdded) {
                if (goalsSequenceListAsPerPager.isNotEmpty()) {
                    when (currentPagerGoal) {
                        Goals.Medication -> {
                            if (chartDuration == ChartDurations.SEVEN_DAYS) {
                                lastSevenDaysMedication()
                            } else {
                                if (goalSummaryMedicationChartFragment.chartRecordData != null && goalSummaryMedicationChartFragment.isAdded) {
                                    goalSummaryMedicationChartFragment.setChartData(
                                        goalSummaryMedicationChartFragment.chartRecordData,
                                        null)
                                } else {
                                    getGoalRecords()
                                }
                            }
                        }
                        Goals.Exercise -> {
                            if (goalSummaryExerciseFragment.chartRecordData != null && goalSummaryExerciseFragment.isAdded) {
                                goalSummaryExerciseFragment.setChartData(goalSummaryExerciseFragment.chartRecordData,
                                    null)
                            } else {
                                getGoalRecords()
                            }
                        }
                        Goals.Pranayam -> {
                            if (goalSummaryPranayamFragment.chartRecordData != null && goalSummaryPranayamFragment.isAdded) {
                                goalSummaryPranayamFragment.setChartData(goalSummaryPranayamFragment.chartRecordData,
                                    null)
                            } else {
                                getGoalRecords()
                            }
                        }
                        Goals.Steps -> {
                            if (goalSummaryStepsFragment.chartRecordData != null && goalSummaryStepsFragment.isAdded) {
                                goalSummaryStepsFragment.setChartData(goalSummaryStepsFragment.chartRecordData,
                                    null)
                            } else {
                                getGoalRecords()
                            }
                        }
                        Goals.WaterIntake -> {
                            if (goalSummaryWaterFragment.chartRecordData != null && goalSummaryWaterFragment.isAdded) {
                                goalSummaryWaterFragment.setChartData(goalSummaryWaterFragment.chartRecordData,
                                    null)
                            } else {
                                getGoalRecords()
                            }
                        }
                        Goals.Sleep -> {
                            if (goalSummarySleepFragment.chartRecordData != null && goalSummarySleepFragment.isAdded) {
                                goalSummarySleepFragment.setChartData(goalSummarySleepFragment.chartRecordData,
                                    null)
                            } else {
                                getGoalRecords()
                            }
                        }
                        Goals.Diet -> {
                            if (goalSummaryDietFragment.chartRecordData != null && goalSummaryDietFragment.isAdded) {
                                goalSummaryDietFragment.setChartData(goalSummaryDietFragment.chartRecordData,
                                    null)
                            } else {
                                getGoalRecords()
                            }
                        }
                    }
                }
            }
        }
    }

    private fun clearGoalsChartsData() {
        goalSummaryMedicationChartFragment.chartRecordData = null
        goalSummaryExerciseFragment.chartRecordData = null
        goalSummaryPranayamFragment.chartRecordData = null
        goalSummaryStepsFragment.chartRecordData = null
        goalSummaryWaterFragment.chartRecordData = null
        goalSummarySleepFragment.chartRecordData = null
        goalSummaryDietFragment.chartRecordData = null
    }

    private fun addFragmentsForGoalSummary() {
        viewPagerAdapter?.clear()
        goalsSequenceListAsPerPager.clear()
        goalsList.forEachIndexed { index, goalReadingData ->
            when (goalReadingData.keys) {
                Goals.Medication.goalKey -> {
                    // show dosage data for 7 days, else chart record for other durations
                    if (chartDuration == ChartDurations.SEVEN_DAYS) {
                        goalSummaryMedicationFragment.chartDuration = chartDuration
                        goalSummaryMedicationFragment.goalReadingData = goalReadingData
                        viewPagerAdapter?.addFrag(goalSummaryMedicationFragment)
                    } else {
                        goalSummaryMedicationChartFragment.chartDuration = chartDuration
                        goalSummaryMedicationChartFragment.goalReadingData = goalReadingData
                        goalSummaryMedicationChartFragment.parentViewPager =
                            binding.viewPagerGoalSummary
                        viewPagerAdapter?.addFrag(goalSummaryMedicationChartFragment)
                    }
                    goalsSequenceListAsPerPager.add(Goals.Medication)
                }
                Goals.Exercise.goalKey -> {
                    goalSummaryExerciseFragment.chartDuration = chartDuration
                    goalSummaryExerciseFragment.goalReadingData = goalReadingData
                    goalSummaryExerciseFragment.parentViewPager = binding.viewPagerGoalSummary
                    viewPagerAdapter?.addFrag(goalSummaryExerciseFragment)
                    goalsSequenceListAsPerPager.add(Goals.Exercise)
                }
                Goals.Pranayam.goalKey -> {
                    goalSummaryPranayamFragment.chartDuration = chartDuration
                    goalSummaryPranayamFragment.goalReadingData = goalReadingData
                    goalSummaryPranayamFragment.parentViewPager = binding.viewPagerGoalSummary
                    viewPagerAdapter?.addFrag(goalSummaryPranayamFragment)
                    goalsSequenceListAsPerPager.add(Goals.Pranayam)
                }
                Goals.Steps.goalKey -> {
                    goalSummaryStepsFragment.chartDuration = chartDuration
                    goalSummaryStepsFragment.goalReadingData = goalReadingData
                    goalSummaryStepsFragment.parentViewPager = binding.viewPagerGoalSummary
                    viewPagerAdapter?.addFrag(goalSummaryStepsFragment)
                    goalsSequenceListAsPerPager.add(Goals.Steps)
                }
                Goals.WaterIntake.goalKey -> {
                    goalSummaryWaterFragment.chartDuration = chartDuration
                    goalSummaryWaterFragment.goalReadingData = goalReadingData
                    goalSummaryWaterFragment.parentViewPager = binding.viewPagerGoalSummary
                    viewPagerAdapter?.addFrag(goalSummaryWaterFragment)
                    goalsSequenceListAsPerPager.add(Goals.WaterIntake)
                }
                Goals.Sleep.goalKey -> {
                    goalSummarySleepFragment.chartDuration = chartDuration
                    goalSummarySleepFragment.goalReadingData = goalReadingData
                    goalSummarySleepFragment.parentViewPager = binding.viewPagerGoalSummary
                    viewPagerAdapter?.addFrag(goalSummarySleepFragment)
                    goalsSequenceListAsPerPager.add(Goals.Sleep)
                }
                Goals.Diet.goalKey -> {
                    goalSummaryDietFragment.chartDuration = chartDuration
                    goalSummaryDietFragment.goalReadingData = goalReadingData
                    goalSummaryDietFragment.parentViewPager = binding.viewPagerGoalSummary
                    viewPagerAdapter?.addFrag(goalSummaryDietFragment)
                    goalsSequenceListAsPerPager.add(Goals.Diet)
                }
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewReadingHistoryLarge.apply {
            layoutManager = GridLayoutManager(requireContext(), 2, RecyclerView.VERTICAL, false)
            adapter = readingHistoryLargeAdapter
        }

        binding.recyclerViewReadingHistorySmall.apply {
            layoutManager = GridLayoutManager(requireContext(), 3, RecyclerView.VERTICAL, false)
            adapter = readingHistorySmallAdapter
        }

        binding.recyclerViewBookTest.apply {
            layoutManager = LinearLayoutManager(requireContext(), RecyclerView.HORIZONTAL, false)
            adapter = homeBookTestAdapter
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setUpRecyclerViewData() {
        // set first 2 in list 1 for large and else others in list 2 for small item view
        readingHistoryList1.clear()
        readingHistoryList1.addAll(allReadingHistoryList.take(2))
        readingHistoryLargeAdapter.notifyDataSetChanged()

        readingHistoryList2.clear()
        if (allReadingHistoryList.size > 5) {
            readingHistoryList2.addAll(allReadingHistoryList.takeLast(allReadingHistoryList.size - 2)
                .take(3))
        } else if (allReadingHistoryList.size > 2) {
            readingHistoryList2.addAll(allReadingHistoryList.takeLast(allReadingHistoryList.size - 2))
        }
        readingHistorySmallAdapter.notifyDataSetChanged()
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            /*textViewToolbarTitle.text =
                if (session.user?.currentPlanName.isNullOrBlank()) "Care Plan"
                else "Care Plan (${session.user?.currentPlanName})"*/

            textViewToolbarTitle.text = getString(R.string.txt_program)

            imageViewNotification.visibility = View.VISIBLE
            imageViewToolbarBack.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }

            updateNotificationCountBadge()
        }
    }

    fun updateNotificationCountBadge() {
        session.user?.let {
            binding.layoutHeader.apply {
                imageViewUnreadNotificationIndicator.visibility =
                    if ((it.unread_notifications?.toIntOrNull() ?: 0) > 0) View.VISIBLE
                    else View.GONE
                imageViewUnreadNotificationIndicator.text =
                    it.unread_notifications?.toIntOrNull()?.toString() ?: ""
            }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            /*layoutIncident*/buttonViewAllIncident.setOnClickListener { onViewClick(it) }
            textViewSummaryDuration.setOnClickListener { onViewClick(it) }
            textViewReadingHistoryMoreLess.setOnClickListener { onViewClick(it) }
            buttonAddIncident.setOnClickListener { onViewClick(it) }
            buttonViewAddRecord.setOnClickListener { onViewClick(it) }
            buttonViewAllRecord.setOnClickListener { onViewClick(it) }
            buttonUpdate.setOnClickListener { onViewClick(it) }
            buttonOrderTest.setOnClickListener { onViewClick(it) }
            buttonBookAppointment.setOnClickListener { onViewClick(it) }
            buttonViewAllAppointment.setOnClickListener { onViewClick(it) }
            //buttonDownload.setOnClickListener { onViewClick(it) }
            imageViewDropDown.setOnClickListener { onViewClick(it) }
            textViewViewMoreTest.setOnClickListener { onViewClick(it) }
            imageViewDropDownDietPlan.setOnClickListener { onViewClick(it) }
            buttonViewAllDietPlan.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonViewAllIncident -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    HistoryFragment::class.java).addBundle(Bundle().apply {
                    putBoolean(Common.BundleKey.IS_SHOW_INCIDENT, true)
                }).start()
            }
            R.id.imageViewDropDown -> {
                toggleAppointments()
            }
            R.id.imageViewDropDownDietPlan -> {
                toggleDietPlans()
            }
            R.id.buttonDownload -> {
                //startDownload()
                if (diet?.document_url.isNullOrBlank().not()
                    && diet?.document_name.isNullOrBlank().not()
                ) {
                    downloadHelper.startDownload(diet?.document_url!!,
                        diet?.document_name!!,
                        downloadHelper.DIR_DIET_PLAN)
                }
            }
            R.id.buttonOrderTest -> {
                showRequestCallbackDialogForOrderTest()
            }
            R.id.buttonUpdate -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_medication)) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        SetupDrugsFragment::class.java).start()
                }
            }
            R.id.buttonViewAllRecord -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_records_history_records)) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        HistoryFragment::class.java)
                        .addBundle(bundleOf(Pair(Common.BundleKey.IS_SHOW_RECORD, true))).start()
                }
            }
            R.id.buttonViewAddRecord -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_records_history_records)) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        UploadRecordFragment::class.java).start()
                }
            }
            R.id.buttonAddIncident -> {
                analytics.logEvent(analytics.USER_CLICKED_ON_REPORT_INCIDENT,
                    screenName = AnalyticsScreenNames.CarePlan)
                if (isFeatureAllowedAsPerPlan(PlanFeatures.incident_records_history)) {
                    //getIncidentSurvey()

                    if (HomeActivity.incidentSurveyData != null) {
                        navigator.loadActivity(TransparentActivity::class.java,
                            AddIncidentFragment::class.java)
                            .addBundle(bundleOf(Pair(Common.BundleKey.INCIDENT_SURVEY_DATA,
                                HomeActivity.incidentSurveyData))).start()
                    }
                }
            }
            R.id.imageViewNotification -> {
                openNotificationScreen()
                /*val decode = URLEncodeDecode.decode("https%3A%2F%2Fmytatva.page.link%2FTqvv")
                showMessage(decode)*/
            }
            R.id.textViewReadingHistoryMoreLess -> {
                binding.textViewReadingHistoryMoreLess.isChecked =
                    binding.textViewReadingHistoryMoreLess.isChecked.not()
                toggleReadingHistoryData(true)
            }
            R.id.textViewSummaryDuration -> {
                val durationList = ChartDurations.values().toList() as ArrayList<ChartDurations>
                durationList.remove(ChartDurations.FIFTEEN_DAYS)
                BottomSheet<ChartDurations>().showBottomSheetDialog(requireActivity(),
                    durationList,
                    "",
                    object : BottomSheetAdapter.ItemListener<ChartDurations> {
                        override fun onItemClick(item: ChartDurations, position: Int) {
                            if (chartDuration.durationKey != item.durationKey) {
                                clearGoalsChartsData()
                                chartDuration = item
                                binding.textViewSummaryDuration.text = item.durationTitle
                                setUpGoalSummary()
                                //reloadCurrentPageData()
                            }

                            /*Handler(Looper.getMainLooper()).postDelayed({
                                reloadCurrentPageData()
                            }, 100)*/
                        }

                        override fun onBindViewHolder(
                            holder: BottomSheetAdapter<ChartDurations>.MyViewHolder,
                            position: Int,
                            item: ChartDurations,
                        ) {
                            holder.textView.text = item.durationTitle
                        }
                    })
            }
            R.id.buttonBookAppointment -> {
                analytics.logEvent(analytics.USER_CLICK_BOOK_APPOINTMENT,
                    screenName = AnalyticsScreenNames.CarePlan)
                if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        BookAppointmentsFragment::class.java).start()
                }
            }
            R.id.buttonViewAllAppointment -> {
                analytics.logEvent(analytics.CAREPLAN_APPOINTMENT_VIEW_ALL,
                    screenName = AnalyticsScreenNames.CarePlan)
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    AllAppointmentsFragment::class.java).start()
            }
            R.id.textViewViewMoreTest -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    LabTestListFragment::class.java).start()
            }

            R.id.buttonViewAllDietPlan -> {
                navigator.loadActivity(IsolatedFullActivity::class.java,
                    DietPlanListFragment::class.java).start()
            }
        }
    }

    private fun toggleAppointments() {
        with(binding) {
            TransitionManager.beginDelayedTransition(root, AutoTransition().setDuration(100))
            if (recyclerViewAppointment.isVisible) {
                recyclerViewAppointment.isVisible = false
                imageViewDropDown.rotation = 0F
            } else {
                recyclerViewAppointment.isVisible = true
                imageViewDropDown.rotation = 180F
            }
        }
    }

    private fun toggleDietPlans() {
        with(binding) {
            TransitionManager.beginDelayedTransition(root, AutoTransition().setDuration(100))
            if (layoutDietPlanData.isVisible) {
                layoutDietPlanData.isVisible = false
                imageViewDropDownDietPlan.rotation = 0F
            } else {
                layoutDietPlanData.isVisible = true
                imageViewDropDownDietPlan.rotation = 180F
            }
        }
    }

    fun showRequestCallbackDialogForOrderTest() {
        if (isFeatureAllowedAsPerPlan(PlanFeatures.prescription_book_test)) {
            activity?.supportFragmentManager?.let {
                RequestCallbackDialog {
                    requestPrescriptionCardCallback(null, "T")
                }.show(it, RequestCallbackDialog::class.java.simpleName)
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun toggleReadingHistoryData(isNeedToAnimate: Boolean = false) {
        with(binding) {

            if (isNeedToAnimate) {
                //TransitionManager.beginDelayedTransition(root)
            }
            if (textViewReadingHistoryMoreLess.isChecked) {
                readingHistoryList2.clear()
                if (allReadingHistoryList.isNotEmpty()) {
                    readingHistoryList2.addAll(allReadingHistoryList.takeLast(allReadingHistoryList.size - 2))
                }
                textViewReadingHistoryMoreLess.text = "View less"
                /*readingHistorySmallAdapter.notifyItemRangeInserted(3, readingHistoryList2.size)*/
            } else {
                readingHistoryList2.clear()
                val prevSize = readingHistoryList2.size
                if (allReadingHistoryList.isNotEmpty()) {
                    readingHistoryList2.addAll(allReadingHistoryList.takeLast(allReadingHistoryList.size - 2)
                        .take(3))
                }
                textViewReadingHistoryMoreLess.text = "View more"
                /*readingHistorySmallAdapter.notifyItemRangeRemoved(3, prevSize)*/
            }
            readingHistorySmallAdapter.notifyDataSetChanged()

            /*readingHistoryList2.forEachIndexed { index, goalReadingData ->
                readingHistorySmallAdapter.notifyItemChanged(index,"data")
            }*/
        }
    }

    var onCoachMarkFinish: (() -> Unit)? = null
    fun showCoachMark(onFinish: () -> Unit) {

        if (allReadingHistoryList.isNotEmpty()) {

            if (binding.textViewReadingHistoryMoreLess.isChecked) {
                binding.textViewReadingHistoryMoreLess.isChecked = false
                toggleReadingHistoryData()
            }

            onCoachMarkFinish = null

            var mGuideView: GuideView? = null
            var builder: GuideView.Builder? = null

            binding.nestedScrollView.scrollTo(0, binding.layoutReadings.top)
            builder = GuideView.Builder(requireActivity())
                .setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.CARE_PLAN_READING.pageKey))
                .setButtonText("Next").setGravity(Gravity.auto)
                /*.setDismissType(DismissType.outside)
                .setPointerType(PointerType.circle)*/.setTargetView(binding.layoutReadings)
                .setGuideListener(object : GuideListener {
                    override fun onDismiss(view: View?) {
                    }

                    override fun onSkip() {
                        showSkipCoachMarkMessage()
                    }

                    override fun onNext(view: View) {
                        when (view.id) {
                            R.id.layoutReadings -> {
                                with(binding) {
                                    nestedScrollView.scrollTo(0, layoutRecords.top)
                                    builder?.setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.CARE_PLAN_GOAL.pageKey))
                                        ?.setButtonText("Next")
                                        ?.setTargetView(binding.layoutRecords)
                                    mGuideView = builder?.build()
                                    mGuideView?.show()
                                }
                            }
                            R.id.layoutRecords -> {
                                if (AppFlagHandler.isToHideEngagePage(session.user,
                                        firebaseConfigUtil)
                                ) {
                                    //if engage is hidden directly move coachMark to exercise
                                    builder?.setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.ENGAGE_EXERCISE.pageKey))
                                        ?.setButtonText("Go To Exercise")
                                        ?.setTargetView((requireActivity() as HomeActivity).binding.layoutExercise)
                                    mGuideView = builder?.build()
                                    mGuideView?.show()
                                } else {
                                    // else continue to engage tab
                                    builder?.setTitle(HomeActivity.getCoachMarkDesc(CoachMarkPage.CARE_PLAN_ENGAGE.pageKey))
                                        ?.setButtonText("Go To Engage")
                                        ?.setTargetView((requireActivity() as HomeActivity).binding.layoutMyCircle)
                                    mGuideView = builder?.build()
                                    mGuideView?.show()
                                }
                            }
                            R.id.layoutExercise,
                            R.id.layoutMyCircle,
                            -> {
                                onFinish.invoke()
                            }
                        }
                    }
                })

            mGuideView = builder?.build()
            mGuideView?.show()

        } else {
            onCoachMarkFinish = onFinish
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun dailySummary() {
        val apiRequest = ApiRequest()

        if (allReadingHistoryList.isEmpty()) showLoader()
        goalReadingViewModel.dailySummaryCarePlan(apiRequest)
    }

    private fun getGoalRecords() {
        if (goalsList.isNotEmpty()) {
            val apiRequest = ApiRequest()
            apiRequest.goal_id = goalsList[currentGoalsPosition].goal_master_id
            apiRequest.goal_time = chartDuration.durationKey
            goalReadingViewModel.getGoalRecords(apiRequest)
        }
    }

    private fun lastSevenDaysMedication() {
        if (goalsList.isNotEmpty()) {
            val apiRequest = ApiRequest()
            apiRequest.goal_id = goalsList[currentGoalsPosition].goal_master_id
            apiRequest.goal_time = chartDuration.durationKey
            goalReadingViewModel.lastSevenDaysMedication(apiRequest)
            goalSummaryMedicationFragment.toggleLoader(true)
        }
    }

    private fun requestPrescriptionCardCallback(patientDoseRelId: String?, callbackFor: String) {
        val apiRequest = ApiRequest().apply {
            callback_for = callbackFor
            patient_dose_rel_id = patientDoseRelId
        }
        showLoader()
        authViewModel.requestPrescriptionCardCallback(apiRequest)
    }

    private fun getIncidentFreeDays() {
        val apiRequest = ApiRequest()
        goalReadingViewModel.getIncidentFreeDays(apiRequest)
    }

    private fun prescriptionMedicineList() {
        val apiRequest = ApiRequest()
        authViewModel.prescriptionMedicineList(apiRequest)
    }

    private fun getRecords() {
        val apiRequest = ApiRequest().apply {
            page = "1"
        }
        authViewModel.getRecords(apiRequest)
    }

    private fun todaysAppointment() {
        val apiRequest = ApiRequest()
        doctorViewModel.todaysAppointment(apiRequest)
    }

    private fun dietPlanList() {
        val apiRequest = ApiRequest().apply {
            home = true
        }
        goalReadingViewModel.dietPlanList(apiRequest)
    }

    private fun cancelAppointment(appointmentData: AppointmentData) {
        val apiRequest = ApiRequest().apply {
            appointment_id = appointmentData.appointment_id
            type = appointmentData.type
            if (type == Common.AppointmentForType.DOCTOR) {
                clinic_id = appointmentData.clinic_id
                doctor_id = appointmentData.doctor_id
                type_consult =
                    if (appointmentData.appointment_type?.contains(AppointmentTypes.CLINIC.typeKey) == true) AppointmentTypes.CLINIC.typeKey
                    else AppointmentTypes.VIDEO.typeKey
                appointment_date = DateTimeFormatter.date(appointmentData.appointment_date,
                    DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_dd_MM_yyyy_dash)
                appointment_slot = appointmentData.appointment_time
            }
        }
        doctorViewModel.cancelAppointment(apiRequest)
    }

    private fun getVoiceToken(appointmentData: AppointmentData) {
        val apiRequest = ApiRequest().apply {
            appointment_id = appointmentData.appointment_id
            room_id = appointmentData.room_id
            room_name = appointmentData.room_name
            type = appointmentData.type
        }
        showLoader()
        doctorViewModel.getVoiceToken(apiRequest)
    }

    private fun testsListCarePlan() {
        val apiRequest = ApiRequest().apply {
            separate = "No"
        }
        doctorViewModel.testsListCarePlan(apiRequest)
    }

    /*private fun getIncidentSurvey() {
        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.getIncidentSurvey(apiRequest)
    }*/

    private fun getCatSurvey() {
        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.getCatSurvey(apiRequest)
    }

    private fun addCatSurvey(surveyResponse: JSONArray, score: String) {
        val list = arrayListOf<ApiRequestSubData>()
        list.addAll(Gson().fromJson(surveyResponse.toString(), Array<ApiRequestSubData>::class.java)
            .toList())

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
        goalReadingViewModel.dailySummaryCarePlanLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                setGoalReadingData(it)
            }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        goalReadingViewModel.getGoalRecordsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data.let {
                if (isAdded) {
                    if (goalsList[currentGoalsPosition].goal_master_id == responseBody.goalId && chartDuration.durationKey == responseBody.chartDurationKey) {
                        setGoalRecordData(it)
                    }
                }
            }
        }, onError = { throwable ->
            hideLoader()
            if (isAdded) {
                if (throwable is ServerException && goalsList[currentGoalsPosition].goal_master_id == throwable.goalId && chartDuration.durationKey == throwable.chartDurationKey) {
                    setGoalRecordData(null, throwable)
                }
            }
            false
        })

        goalReadingViewModel.lastSevenDaysMedicationLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data.let {
                    goalSummaryMedicationFragment.setMedicationSummaryData(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                goalSummaryMedicationFragment.setMedicationSummaryData(null, throwable)
                false
            })

        authViewModel.requestPrescriptionCardCallbackLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                activity?.supportFragmentManager?.let {
                    RequestCallbackSuccessDialog {

                    }.show(it, RequestCallbackSuccessDialog::class.java.simpleName)
                }
            },
            onError = { throwable ->
                hideLoader()
                false
            })

        //getIncidentSurveyLiveData
        /*goalReadingViewModel.getIncidentSurveyLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                binding.layoutIncident.isVisible = true
                HomeActivity.incidentSurveyData = responseBody.data
                getIncidentFreeDays()

                *//*navigator.loadActivity(TransparentActivity::class.java,
                    AddIncidentFragment::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.INCIDENT_SURVEY_DATA, incidentSurveyData)
                    )).start()*//*
            },
            onError = { throwable ->
                hideLoader()
                binding.layoutIncident.isVisible = false
                HomeActivity.incidentSurveyData = null
                true
            })*/

        goalReadingViewModel.getIncidentFreeDaysLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            with(binding) {
                textViewLabelDidYouFaceIncident.visibility = View.GONE
                layoutIncidentDuration.visibility = View.VISIBLE

                textViewIncidentFreeDays.text = responseBody.data?.days
                textViewLastIncidentRecordedDate.text =
                    responseBody.data?.getFormattedLastDate ?: ""

                // old design code
                /*layoutIncidentDuration.visibility = View.VISIBLE
                textViewLabelIncidentRecorded.visibility = View.VISIBLE
                textViewDays.text = responseBody.data?.days.plus(" ")
                    .plus(getString(R.string.care_plan_label_days))
                textViewIncidentRecordedDate.text =
                    responseBody.data?.getFormattedLastDate ?: ""*/
            }
        }, onError = { throwable ->
            hideLoader()
            with(binding) {
                textViewLabelDidYouFaceIncident.visibility = View.VISIBLE
                layoutIncidentDuration.visibility = View.GONE

                if (throwable is ServerException) {
                    binding.textViewLabelDidYouFaceIncident.text = throwable.message
                    false
                } else {
                    true
                }

                // old design code
                /*layoutIncidentDuration.visibility = View.GONE
                textViewLabelIncidentRecorded.visibility = View.GONE
                if (throwable is ServerException) {
                    binding.textViewIncidentRecordedDate.text = throwable.message
                    false
                } else {
                    true
                }*/
            }
        })

        authViewModel.prescriptionMedicineListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let { setPrescriptionMedicationData(it) }
            //testsListCarePlan()
        }, onError = { throwable ->
            hideLoader()
            //testsListCarePlan()
            false
        })

        authViewModel.getRecordsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            recordList.clear()
            responseBody.data?.let { recordList.addAll(it) }
            recordAdapter.notifyDataSetChanged()

            handleScrollAsPerDeepLinkScreenSection()

            /*if (recordList.isEmpty()) {
                binding.layoutRecords.visibility = View.GONE
            } else {
                binding.layoutRecords.visibility = View.VISIBLE
            }*/


        }, onError = { throwable ->
            hideLoader()
            handleScrollAsPerDeepLinkScreenSection()

            /*if (recordList.isEmpty()) {
                binding.layoutRecords.visibility = View.GONE
            } else {
                binding.layoutRecords.visibility = View.VISIBLE
            }*/
            false
        })

        //todaysAppointmentLiveData
        doctorViewModel.todaysAppointmentLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            appointmentList.clear()
            responseBody.data?.let { appointmentList.addAll(it) }
            carePlanAppointmentAdapter.notifyDataSetChanged()
            binding.imageViewDropDown.isVisible = appointmentList.isNotEmpty()
            dietPlanList()
        }, onError = { throwable ->
            hideLoader()
            appointmentList.clear()
            carePlanAppointmentAdapter.notifyDataSetChanged()
            binding.imageViewDropDown.isVisible = appointmentList.isNotEmpty()
            dietPlanList()
            false
        })

        //dietPlanListLiveData
        goalReadingViewModel.dietPlanListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            setDietPlanData(responseBody.data ?: arrayListOf())
            getRecords()
        }, onError = { throwable ->
            hideLoader()
            setDietPlanData(arrayListOf(), throwable.message ?: "")
            getRecords()
            false
        })

        //cancelAppointmentLiveData
        doctorViewModel.cancelAppointmentLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            analytics.logEvent(analytics.CAREPLAN_APPOINTMENT_REQ_CANCEL, Bundle().apply {
                putString(analytics.PARAM_APPOINTMENT_ID,
                    appointmentList[currentClickAppointmentPosition].appointment_id)
                putString(analytics.PARAM_TYPE,
                    appointmentList[currentClickAppointmentPosition].type)
            }, screenName = AnalyticsScreenNames.CarePlan)
            todaysAppointment()
        }, onError = { throwable ->
            hideLoader()
            false
        })

        //getVoiceTokenLiveData
        doctorViewModel.getVoiceTokenLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.token?.let {
                navigator.loadActivity(VideoActivity::class.java)
                    .addBundle(bundleOf(Pair(Common.BundleKey.ACCESS_TOKEN, it),
                        Pair(Common.BundleKey.ROOM_ID,
                            appointmentList[currentClickAppointmentPosition].room_id),
                        Pair(Common.BundleKey.ROOM_SID,
                            appointmentList[currentClickAppointmentPosition].room_sid),
                        Pair(Common.BundleKey.ROOM_NAME,
                            appointmentList[currentClickAppointmentPosition].room_name),
                        Pair(Common.BundleKey.DOCTOR_HC_NAME,
                            appointmentList[currentClickAppointmentPosition].doctor_name))).start()
            }
        }, onError = { throwable ->
            hideLoader()
            false
        })

        //testsListCarePlanLiveData
        doctorViewModel.testsListCarePlanLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            handleTestListHomeResponse(responseBody.data)
        }, onError = { throwable ->
            hideLoader()
            handleTestListHomeResponse(null)
            false
        })

        //getCatSurveyLiveData
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

        //addCatSurveyLiveData
        goalReadingViewModel.addCatSurveyLiveData.observe(this, onChange = { responseBody ->
            hideLoader()

            analytics.logEvent(analytics.USER_UPDATED_READING, Bundle().apply {
                putString(analytics.PARAM_READING_NAME, catReadingName)
                putString(analytics.PARAM_READING_ID, catReadingMasterId)
            }, screenName = AnalyticsScreenNames.LogReading)

            dailySummary()
        }, onError = { throwable ->
            hideLoader()
            true
        })
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setDietPlanData(dietPlanListData: java.util.ArrayList<Diet>, msg: String? = null) {
        with(binding) {
            if (msg.isNullOrBlank().not()) {
                layoutDietPlan.isVisible = true
                textViewNoDietPlan.isVisible = true
                recyclerViewDietPlan.isVisible = false
                buttonViewAllDietPlan.isVisible = false
                textViewNoDietPlan.text = msg

            } else {
                layoutDietPlan.isVisible = true
                textViewNoDietPlan.isVisible = false
                recyclerViewDietPlan.isVisible = true
                buttonViewAllDietPlan.isVisible = true

                dietPlanList.clear()
                dietPlanListData.let { dietPlanList.addAll(it) }
                carePlanDietPlanAdapter.notifyDataSetChanged()
            }
        }
    }

    /**
     * *****************************************************
     * Response handle methods
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun handleTestListHomeResponse(arrayList: java.util.ArrayList<TestPackageData>?) {
        if (isAdded) {
            with(binding) {
                bookTestList.clear()
                arrayList?.let { bookTestList.addAll(it) }
                homeBookTestAdapter.notifyDataSetChanged()
                layoutBookYourTest.isVisible = bookTestList.isNullOrEmpty().not()
            }
        }
    }

    private fun setGoalRecordData(chartRecordData: ChartRecordData?, throwable: Throwable? = null) {
        when (currentPagerGoal) {
            Goals.Medication -> {
                if (chartDuration == ChartDurations.SEVEN_DAYS) {
                    /*goalSummaryMedicationFragment.setChartData(chartRecordData)*/
                } else {
                    if (goalSummaryMedicationChartFragment.isAdded) {
                        goalSummaryMedicationChartFragment.setChartData(chartRecordData, throwable)
                    }
                }
            }
            Goals.Exercise -> {
                if (goalSummaryExerciseFragment.isAdded) {
                    goalSummaryExerciseFragment.setChartData(chartRecordData, throwable)
                }
            }
            Goals.Pranayam -> {
                if (goalSummaryPranayamFragment.isAdded) {
                    goalSummaryPranayamFragment.setChartData(chartRecordData, throwable)
                }
            }
            Goals.Steps -> {
                if (goalSummaryStepsFragment.isAdded) {
                    goalSummaryStepsFragment.setChartData(chartRecordData, throwable)
                }
            }
            Goals.WaterIntake -> {
                if (goalSummaryWaterFragment.isAdded) {
                    goalSummaryWaterFragment.setChartData(chartRecordData, throwable)
                }
            }
            Goals.Sleep -> {
                if (goalSummarySleepFragment.isAdded) {
                    goalSummarySleepFragment.setChartData(chartRecordData, throwable)
                }
            }
            Goals.Diet -> {
                if (goalSummaryDietFragment.isAdded) {
                    goalSummaryDietFragment.setChartData(chartRecordData, throwable)
                }
            }
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setGoalReadingData(dailySummaryData: DailySummaryData) {
        // set readings
        allReadingHistoryList.clear()
        dailySummaryData.readings?.let { allReadingHistoryList.addAll(it) }
        setUpRecyclerViewData()
        if (allReadingHistoryList.size > 5) {
            binding.textViewReadingHistoryMoreLess.visibility = View.VISIBLE
            toggleReadingHistoryData()
        } else {
            binding.textViewReadingHistoryMoreLess.visibility = View.GONE
        }

        // set goals
        goalsList.clear()
        dailySummaryData.goals?.let { goalsList.addAll(it) }
        if (goalsList.isNullOrEmpty().not()) {
            setUpGoalSummary()
        }

        //handle for coachmark
        Handler(Looper.getMainLooper()).postDelayed({
            onCoachMarkFinish?.let {
                showCoachMark(it)
            }
        }, 500)


        /*
         * To get single diet plan from dailySummaryData logic removed from below,
         * Added new API to show multiple diet plans
         */
        /*with(binding) {
            if (dailySummaryData.diet?.first_name.isNullOrBlank().not()) {
                layoutDietPlan.isVisible = true
                textViewLabelDietPlan.text =
                    getString(R.string.care_plan_label_diet_plan_by_your_health_coach_,
                        dailySummaryData.diet?.document_title)
                        .plus(" ${dailySummaryData.diet?.first_name} ${dailySummaryData.diet?.last_name}")
                diet = dailySummaryData.diet
            } else {
                layoutDietPlan.isVisible = false
            }
        }*/
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setPrescriptionMedicationData(list: java.util.ArrayList<PrescriptionMedicationData>) {
        prescriptionMedicationList.clear()
        prescriptionMedicationList.addAll(list)
        prescriptionMedicationAdapter.notifyDataSetChanged()
    }

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
                        Log.d("catData", "::$responseData")
                        responseData?.let { addCatSurvey(it, score) }
                    }

                } catch (e: Exception) {

                }
            } else {
                Log.d("Response", "::$message")
            }
        }

    }

    /**
     * *****************************************************
     * Download video methods
     * *****************************************************
     */
    private fun startDownload() {

        /*if (downloadStorageDirectory == null) {
            downloadStorageDirectory = File(activity?.filesDir, Common.COURSE_VIDEO_DIRECTORY)
        }*/

        /*if (diet?.document_title != null) {
            val mediaUrl = diet?.document_url!!
            val fileTitle = diet?.document_name

            if (NetworkUtil.isNetworkAvailable(requireActivity())) {

                if (mediaUrl.isNotEmpty()) {

                    val uri = Uri.parse(mediaUrl)

                    *//*if (downloadStorageDirectory?.exists() != true)
                        downloadStorageDirectory?.mkdirs()*//*

                    val lastDownload =
                        mgr!!.enqueue(DownloadManager.Request(uri)
                            .setAllowedNetworkTypes(
                                DownloadManager.Request.NETWORK_WIFI or
                                        DownloadManager.Request.NETWORK_MOBILE)
//                            .setAllowedOverRoaming(false)
                            .setTitle(fileTitle)
                            .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
//                            .setDescription("Something useful. No, really.")
                            *//*.setDestinationInExternalFilesDir(activity, Common.COURSE_VIDEO_DIRECTORY, tutorCoursesData.title + "-" + uri.lastPathSegment)*//*
                            .setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS,
                                "MyTatvaDietPlan/${fileTitle}"))

                }

            } else {
                showMessage("Connect to internet")
            }
        }*/
    }

}