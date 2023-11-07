package com.mytatva.patient.ui.home

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.verify.domain.DomainVerificationManager
import android.content.pm.verify.domain.DomainVerificationUserState
import android.location.Location
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.view.KeyEvent
import android.view.View
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.os.bundleOf
import androidx.core.view.GravityCompat
import androidx.core.view.isVisible
import androidx.drawerlayout.widget.DrawerLayout
import androidx.lifecycle.ViewModelProvider
import com.facebook.react.PackageList
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactPackage
import com.facebook.react.ReactRootView
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.facebook.react.common.LifecycleState
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler
import com.facebook.react.modules.core.PermissionAwareActivity
import com.facebook.react.modules.core.PermissionListener
import com.facebook.soloader.SoLoader
import com.freshchat.consumer.sdk.Freshchat
import com.freshchat.consumer.sdk.FreshchatMessage
import com.google.android.gms.maps.model.LatLng
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.model.DrawerItem
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CoachMarksData
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.data.pojo.response.IncidentSurveyData
import com.mytatva.patient.databinding.HomeActivityBinding
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.di.module.AndroidBridgeReactPackage
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.fcm.Notification
import com.mytatva.patient.location.MyLocationUtil
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.appointment.fragment.AllAppointmentsFragment
import com.mytatva.patient.ui.auth.fragment.SetupGoalsReadingsFragment
import com.mytatva.patient.ui.auth.fragment.SetupHeightWeightFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.common.fragment.WebViewCommonFragment
import com.mytatva.patient.ui.home.adapter.HomeNavDrawerAdapter
import com.mytatva.patient.ui.home.dialog.StartCoachMarkDialog
import com.mytatva.patient.ui.home.dialog.UpdatePinCodeBottomSheetDialog
import com.mytatva.patient.ui.home.fragment.AppUnderMaintenenceFragment
import com.mytatva.patient.ui.menu.dialog.HelpDialog
import com.mytatva.patient.ui.menu.fragment.AboutUsFragment
import com.mytatva.patient.ui.menu.fragment.BookmarksFragment
import com.mytatva.patient.ui.menu.fragment.HelpSupportFAQFragment
import com.mytatva.patient.ui.menu.fragment.HistoryFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentCarePlanListingFragment
import com.mytatva.patient.ui.profile.fragment.AccountSettingsFragment
import com.mytatva.patient.ui.profile.fragment.MyProfileFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.DeviceUtils
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import com.mytatva.patient.utils.imagepicker.loadUrl
import com.mytatva.patient.utils.listOfField
import com.mytatva.patient.utils.openAppInStore
import com.mytatva.patient.utils.rnbridge.ContextHolder
import com.mytatva.patient.utils.shareApp
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.Calendar
import java.util.concurrent.TimeUnit

class HomeActivity : BaseActivity(), View.OnClickListener, DefaultHardwareBackBtnHandler,
    PermissionAwareActivity {
    private val REQUEST_CHECK_PERMISSION = 111
    private lateinit var reactRootView: ReactRootView
    private lateinit var reactInstanceManager: ReactInstanceManager


    companion object {
        const val OVERLAY_PERMISSION_REQ_CODE = 1

        val coachMarksList = arrayListOf<CoachMarksData>()

        fun getCoachMarkDesc(pageKey: String): String {
            return coachMarksList.firstOrNull { it.page == pageKey }?.description ?: ""
        }

        var incidentSurveyData: IncidentSurveyData? = null
    }

    lateinit var binding: HomeActivityBinding

    private val notification: Notification? by lazy {
        intent?.extras?.getParcelable(Common.BundleKey.NOTIFICATION)
    }

    private val deepLink: String by lazy {
        intent?.extras?.getString(Common.BundleKey.DEEP_LINK) ?: ""
    }

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    private var homeHandler: HomeHandler? = null

    var linkHealthCoachListAPICalled = false

    private var selectedCity = ""
    private var selectedState = ""

    private val drawerItems = ArrayList<DrawerItem>(/*DrawerItem.values().toList()*/)
    private val homeNavDrawerAdapter by lazy {
        HomeNavDrawerAdapter(drawerItems, object : HomeNavDrawerAdapter.AdapterListener {
            override fun onItemClick(drawerItem: DrawerItem) {
                analytics.logEvent(
                    analytics.MENU_NAVIGATION,
                    Bundle().apply {
                        putString(analytics.PARAM_MENU, drawerItem.drawerItem)
                    }, screenName = AnalyticsScreenNames.Menu
                )
                handleDrawerItemClick(drawerItem)
            }
        })
    }

    private fun setUpDrawerItems() {
        drawerItems.clear()
        drawerItems.addAll(DrawerItem.values().toList())

        /*if (session.user?.isNaflOrNashPatient == true) {
            drawerItems.remove(DrawerItem.ReportIncident)
        }*/

        /*if (session.user?.isToShowAppointmentModule?.not() == true) {
            drawerItems.remove(DrawerItem.BookAppointment)
        }*/

        // remove payment history option if not allowed in plan
        if (isFeatureAllowedAsPerPlan(
                PlanFeatures.history_payments,
                needToShowDialog = false
            ).not()
        ) {
            drawerItems.remove(DrawerItem.TransactionHistory)
        }

        // remove test history option if not allowed from firebase app flags
        if (AppFlagHandler.isToHideDiagnosticTest(firebaseConfigUtil)) {
            //drawerItems.remove(DrawerItem.BookYourTest)
            drawerItems.remove(DrawerItem.DiagnosticReports)
        }

        /*if (AppFlagHandler.isToHideIncidentSurvey(firebaseConfigUtil)
            || incidentSurveyData == null
        ) {
            drawerItems.remove(DrawerItem.ReportIncident)
        }*/

    }

    /*
     * Params for screen events
     */
    var previousSelectedHomeMenuId = 0
    val currentSelectedHomeMenuId: Int
        get() {
            with(binding) {
                return if (layoutHome.isSelected) R.id.layoutHome
                else if (layoutCarePlan.isSelected) R.id.layoutCarePlan
                else if (layoutMyCircle.isSelected) R.id.layoutMyCircle
                else if (layoutExercise.isSelected) R.id.layoutExercise
                else R.id.layoutMore
            }
        }
    var lastSelectedTabTime = Calendar.getInstance().timeInMillis
    /*
     * ***********************
     */

    private var location: Location? = null

    /*val googleFit: GoogleFit by lazy {
        GoogleFit(this)
    }*/

    override fun createViewBinding(): View {
        binding = HomeActivityBinding.inflate(layoutInflater)
        return binding.root
    }

    override fun findFragmentPlaceHolder(): Int = R.id.placeHolder

    override fun inject(activityComponent: ActivityComponent) {
        activityComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        /*if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package: $packageName")
            )
            startActivityForResult(intent, OVERLAY_PERMISSION_REQ_CODE)
            return
        }*/
        initRN()
    }

    private fun initRN() {
        GlobalScope.launch(Dispatchers.Main) {
            SoLoader.init(this@HomeActivity, false)
            reactRootView = ReactRootView(this@HomeActivity)
            val packages: List<ReactPackage> = PackageList(application).packages
            // Packages that cannot be autolinked yet can be added manually here, for example:
            // packages.add(MyReactNativePackage())
            // Remember to include them in `settings.gradle` and `app/build.gradle` too.
            reactInstanceManager = ReactInstanceManager.builder()
                .setApplication(application)
                .setCurrentActivity(this@HomeActivity)
                .setBundleAssetName("index.android.bundle")
                .setJSMainModulePath("index")
                .addPackages(packages)
                .addPackage(AndroidBridgeReactPackage())
                .setUseDeveloperSupport(BuildConfig.DEBUG)
                .setInitialLifecycleState(LifecycleState.RESUMED)
                .build()


            reactInstanceManager.createReactContextInBackground()


            if (!AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
                observeLiveData()
            }

            handleToShowHideEngageTab()

            if (homeHandler/*savedInstanceState*/ == null) {
                homeHandler = HomeHandler(navigationFactory.fragmentHandler, firebaseConfigUtil)
                //handleHomeNavigation(intent?.extras?.getString(Common.BundleKey.SCREEN_NAME) ?: "")
                //handleHomeNavigation() // pass empty to open default home flow

                homeHandler?.showHomeFragment(notification, reactInstanceManager)

                analytics.setScreenName(AnalyticsScreenNames.Home)
                setBottomSelection(R.id.layoutHome)
            }

            setViewListeners()
            if (!AppFlagHandler.getIsHomeFromReactNative(firebaseConfigUtil)) {
                setUpDrawer()
            }
            setUpDrawer()

            /*showBiometricPrompt()*/

            if (deepLink.isNotBlank()) {
                handleScreenNavigation(Uri.parse(deepLink))
            }

            /* locationManager.startLocationUpdates { location, exception ->
                 location?.let {
                     locationManager.stopFetchLocationUpdates()
                     this.location = location
                     analytics.weUser?.setLocation(it.latitude, it.longitude)
                     *//*Handler(Looper.getMainLooper()).postDelayed({
                    updateDeviceInfo()
                },1000)*//*
            }
            exception?.let {
                // location will not be updated
            }
        }*/

            handleNotificationNavigation()
            getIncidentSurvey()

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                checkForAllowedVerifiedDomain()
            }

            /* handleLocationUpdateForHomeScreen(successCallBack = { location, error ->
                 location?.let {
                     hideLoader()
                     val mLatLng = LatLng(location.latitude, location.longitude)
                     locationManager.stopFetchLocationUpdates()
                 }

             }, manualCallback = {

             })*/
        }
    }

    public fun initLocation() {
        locationManager.isPermissionGranted { granted ->
            if (granted) {
                startLocationUpdate()
            } else {
                if (ActivityCompat.checkSelfPermission(
                        this@HomeActivity, Manifest.permission.ACCESS_COARSE_LOCATION
                    ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                        this@HomeActivity, Manifest.permission.ACCESS_FINE_LOCATION
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    requestPermissions(
                        arrayOf(
                            Manifest.permission.ACCESS_COARSE_LOCATION,
                            Manifest.permission.ACCESS_FINE_LOCATION
                        ), REQUEST_CHECK_PERMISSION
                    )
                } else if (ActivityCompat.checkSelfPermission(
                        this@HomeActivity, Manifest.permission.ACCESS_COARSE_LOCATION
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    requestPermissions(
                        arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION),
                        REQUEST_CHECK_PERMISSION
                    )
                } else if (ActivityCompat.checkSelfPermission(
                        this@HomeActivity, Manifest.permission.ACCESS_FINE_LOCATION
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    requestPermissions(
                        arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                        REQUEST_CHECK_PERMISSION
                    )
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == OVERLAY_PERMISSION_REQ_CODE) {
            if (!Settings.canDrawOverlays(this)) {

            } else {
                initRN()
            }
        }
        reactInstanceManager.onActivityResult(this, requestCode, resultCode, data);
    }

    private fun startLocationUpdate() {
        locationManager.startLocationUpdates({ location, exception ->
            analytics.logEvent(
                AnalyticsClient.SHOW_BOTTOM_SHEET,
                Bundle().apply {
                    putString(
                        analytics.PARAM_BOTTOM_SHEET_NAME,
                        analytics.PARAM_GRANT_LOCATION_PERMISSION
                    )
                })

            location?.let {
                val mLatLng = LatLng(location.latitude, location.longitude)
                locationManager.stopFetchLocationUpdates()
                Log.d("LatLng", ":: ${mLatLng.latitude} , ${mLatLng.longitude}")
                MyLocationUtil.getCurrantLocation(this,
                    mLatLng,
                    callback = { address ->
                        hideLoader()
                        selectedState = address?.adminArea ?: ""
                        selectedCity = address?.locality ?: address?.subAdminArea ?: ""
                        if (address != null && selectedState.isNotBlank() && selectedCity.isNotBlank()) {
                            updatePatientLocation()
                        } else {

                        }
                    })
            }
            exception?.let {
                hideLoader()
            }
        }, false)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        if (requestCode == REQUEST_CHECK_PERMISSION) {
            if (PermissionUtil.verifyPermissions(grantResults)) {
                startLocationUpdate()
            } else {
                handleLocationUpdateForHomeScreen(successCallBack = { location, error ->
                    location?.let {
                        val mLatLng = LatLng(location.latitude, location.longitude)
                        locationManager.stopFetchLocationUpdates()

                        MyLocationUtil.getCurrantLocation(this,
                            mLatLng,
                            callback = { address ->
                                hideLoader()
                                selectedState = address?.adminArea ?: ""
                                selectedCity = address?.locality ?: address?.subAdminArea ?: ""
                                if (address != null && selectedState.isNotBlank() && selectedCity.isNotBlank()) {
                                    updatePatientLocation()
                                }
                            })
                    }
                }, manualCallback = {
                    analytics.logEvent(
                        AnalyticsClient.CLICKED_SELECT_MANUALLY,
                        Bundle().apply {
                            putString(
                                analytics.PARAM_BOTTOM_SHEET_NAME,
                                analytics.PARAM_GRANT_LOCATION_PERMISSION
                            )
                        })
                    UpdatePinCodeBottomSheetDialog(successCallBack = {
                        //todo Do RN Code
                        //homeHandler?.homeFragment?.updateUserData()
                    }).apply {
                        arguments
                    }.show(
                        supportFragmentManager,
                        UpdatePinCodeBottomSheetDialog::class.java.simpleName
                    )
                })
            }
        }
        mPermissionsCallback = Callback {
            if (mPermissionListener != null && mPermissionListener!!.onRequestPermissionsResult(
                    requestCode,
                    permissions,
                    grantResults
                )
            ) {
                mPermissionListener = null
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }


    @RequiresApi(Build.VERSION_CODES.S)
    private fun checkForAllowedVerifiedDomain() {
        val manager = getSystemService(DomainVerificationManager::class.java)
        val userState = manager.getDomainVerificationUserState(packageName)

        // Domains that have passed Android App Links verification.
        val verifiedDomains = userState?.hostToStateMap
            ?.filterValues { it == DomainVerificationUserState.DOMAIN_STATE_VERIFIED }
        Log.d("APP_DOMAINS", "verifiedDomains size: ${verifiedDomains?.size ?: 0}")
        verifiedDomains?.forEach { mapData ->
            Log.d("APP_DOMAINS", "VerifiedDomains: ${mapData.key} :: VALUE : ${mapData.value}")
        }

        // Domains that haven't passed Android App Links verification but that the user
        // has associated with an app.
        val selectedDomains = userState?.hostToStateMap
            ?.filterValues { it == DomainVerificationUserState.DOMAIN_STATE_SELECTED }
        Log.d("APP_DOMAINS", "selectedDomains size: ${selectedDomains?.size ?: 0}")
        selectedDomains?.forEach { mapData ->
            Log.d("APP_DOMAINS", "selectedDomains: ${mapData.key} :: VALUE : ${mapData.value}")
        }

        // All other domains.
        val unapprovedDomains = userState?.hostToStateMap
            ?.filterValues { it == DomainVerificationUserState.DOMAIN_STATE_NONE }
        Log.d("APP_DOMAINS", "unapprovedDomains size: ${unapprovedDomains?.size ?: 0}")
        unapprovedDomains?.forEach { mapData ->
            Log.d("APP_DOMAINS", "unapprovedDomains: ${mapData.key} :: VALUE : ${mapData.value}")
        }

        /*try {
            if (userState?.hostToStateMap?.containsKey("mytatva.page.link") == true) {
                analytics.logEvent(
                    analytics.APP_LINK_DOMAINS,
                    Bundle().apply {
                        putString(analytics.PARAM_DOMAIN, "mytatva.page.link")
                        putString(
                            analytics.PARAM_VALUE,
                            "${userState.hostToStateMap["mytatva.page.link"]}"
                        )
                    },
                    screenName = AnalyticsScreenNames.Home
                )
            } else {
                analytics.logEvent(
                    analytics.APP_LINK_DOMAINS,
                    Bundle().apply {
                        putString(
                            analytics.PARAM_DOMAIN_MAP_SIZE,
                            "${userState?.hostToStateMap?.size ?: 0}"
                        )
                        putString(
                            analytics.PARAM_DOMAIN_MAP_DATA,
                            "${userState?.hostToStateMap?.toString()}"
                        )
                    },
                    screenName = AnalyticsScreenNames.Home
                )
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }*/


        if (unapprovedDomains?.isNotEmpty() == true && unapprovedDomains.containsKey("mytatva.page.link")) {
            showAlertDialogWithOptions("Allow supported app links to open MyTatva app from settings.\n" +
                    "1. Open Settings" +
                    "2. Click on \"+Add link\"" +
                    "3. Select \"mytatva.page.link\" from supported link and click on Add",
                positiveText = "Open Settings",
                negativeText = "Cancel",
                dialogYesNoListener = object : DialogYesNoListener {
                    override fun onYesClick() {
                        val intent = Intent(
                            Settings.ACTION_APP_OPEN_BY_DEFAULT_SETTINGS,
                            Uri.parse("package:${packageName}")
                        )
                        startActivity(intent)
                    }

                    override fun onNoClick() {

                    }
                })
        }
    }

    private fun handleNotificationNavigation() {
        notification?.let {
            when (it.flag) {
                Common.NotificationTag.LogGoal,
                Common.NotificationTag.LogReading,
                -> {
                    // will be handled in home fragment
                }

                Common.NotificationTag.DoctorAppointment -> {
                    loadActivity(
                        IsolatedFullActivity::class.java,
                        AllAppointmentsFragment::class.java
                    ).start()
                }

                Common.NotificationTag.UpdateGoalValue -> {
                    loadActivity(
                        IsolatedFullActivity::class.java,
                        SetupGoalsReadingsFragment::class.java
                    ).start()
                }

                Common.NotificationTag.HealthcoachTask -> {
                    // open home only, no need to navigate
                }

                Common.NotificationTag.HealthcoachAppointment,
                Common.NotificationTag.HealthcoachContent,
                -> {
                    it.other_details?.deep_link?.let { deep_link ->
                        if (deep_link.isNotBlank()) {//https://mytatva.page.link/qtSriFnTn3BXMQtz8
                            //handleScreenNavigation(Uri.parse(deep_link))
                            getDeepLink(Uri.parse(deep_link)) {

                            }
                        }
                    }
                }

                else -> {

                }
            }
        }
    }


    fun handleHomeNavigation(deepLink: Uri/*screenName: String? = null*/) {
        val screenName = deepLink.getQueryParameter(FirebaseLink.Params.SCREEN_NAME)

        when (screenName) {
            AnalyticsScreenNames.Home -> {
                if (deepLink.queryParameterNames?.contains(FirebaseLink.Params.SCREEN_SECTION) == true) {
                    // show home if not currently open
                    if (binding.layoutHome.isSelected.not()) {
                        homeHandler?.showHomeFragment(notification, reactInstanceManager)
                        ContextHolder.reactContext?.let {
                            sendEventToRN(
                                it,
                                "bottomTabNavigationInitiated",
                                ""
                            )
                        }

                        analytics.setScreenName(AnalyticsScreenNames.Home)
                        setBottomSelection(R.id.layoutHome)
                    }
                    // =================================
                    //todo Do RN Code
                    /*homeHandler?.homeFragment?.deepLinkScreenSection =
                        deepLink.getQueryParameter(FirebaseLink.Params.SCREEN_SECTION) ?: ""*/

                }
            }

            AnalyticsScreenNames.LogGoal -> {
                if (deepLink.queryParameterNames?.contains(FirebaseLink.Params.GOAL_KEY) == true) {
                    // show home if not currently open
                    if (binding.layoutHome.isSelected.not()) {
                        homeHandler?.showHomeFragment(notification, reactInstanceManager)
                        ContextHolder.reactContext?.let {
                            sendEventToRN(
                                it,
                                "bottomTabNavigationInitiated",
                                ""
                            )
                        }

                        analytics.setScreenName(AnalyticsScreenNames.Home)
                        setBottomSelection(R.id.layoutHome)
                    }
                    // =================================
                    //todo Do RN Code
                    /*homeHandler?.homeFragment?.deepLinkGoalKey =
                        deepLink.getQueryParameter(FirebaseLink.Params.GOAL_KEY) ?: ""*/

                }
            }

            AnalyticsScreenNames.CarePlan -> {
                homeHandler?.showCarePlanFragment()
                analytics.setScreenName(AnalyticsScreenNames.CarePlan)
                setBottomSelection(R.id.layoutCarePlan)

                if (deepLink.queryParameterNames?.contains(FirebaseLink.Params.SCREEN_SECTION) == true) {
                    homeHandler?.carePlanFragment?.deepLinkScreenSection =
                        deepLink.getQueryParameter(FirebaseLink.Params.SCREEN_SECTION) ?: ""
                }

                //binding.layoutCarePlan.isSelected = true
            }

            AnalyticsScreenNames.DiscoverEngage -> {
                homeHandler?.showMyCircleFragment()
                //analytics.setScreenName(AnalyticsScreenNames.DiscoverEngage)
                setBottomSelection(R.id.layoutMyCircle)

                // if filter parameter is there in deeplink
                val contentType = deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_TYPE)
                if (contentType.isNullOrBlank().not()) {
                    Handler(Looper.getMainLooper()).postDelayed({
                        homeHandler?.engageFragment?.handleFilterFromDeeplinkData(contentType ?: "")
                    }, 50)
                }
            }

            AnalyticsScreenNames.ExerciseMyRoutine/*ExercisePlan*/ -> {
                homeHandler?.showExerciseFragment()
                setBottomSelection(R.id.layoutExercise)
                Handler(Looper.getMainLooper()).postDelayed({
                    homeHandler?.exerciseFragment?.setViewPagerItemPosition(0)
                }, 50)
            }

            AnalyticsScreenNames.ExerciseMore -> {
                homeHandler?.showExerciseFragment()
                setBottomSelection(R.id.layoutExercise)
                Handler(Looper.getMainLooper()).postDelayed({
                    homeHandler?.exerciseFragment?.setViewPagerItemPosition(1)
                }, 50)
            }

            AnalyticsScreenNames.FaqQuery -> {
                //default HomeFragment for popup
                homeHandler?.showHomeFragment(notification, reactInstanceManager)
                ContextHolder.reactContext?.let {
                    sendEventToRN(
                        it,
                        "bottomTabNavigationInitiated",
                        ""
                    )
                }

                analytics.setScreenName(AnalyticsScreenNames.Home)
                setBottomSelection(R.id.layoutHome)

                Handler(Looper.getMainLooper()).postDelayed({
                    supportFragmentManager.let {
                        HelpDialog().show(it, HelpDialog::class.java.simpleName)
                    }
                }, 50)
            }

            else -> {
                //default HomeFragment
                homeHandler?.showHomeFragment(notification, reactInstanceManager)
                ContextHolder.reactContext?.let {
                    sendEventToRN(
                        it,
                        "bottomTabNavigationInitiated",
                        ""
                    )
                }

                analytics.setScreenName(AnalyticsScreenNames.Home)
                binding.layoutHome.isSelected = true
            }
        }
    }

    private fun setUpGoogleFit() {
        if (googleFit.hasAllPermissions) {
            /*googleFit.initializeFit()*/
            updateReadingsGoals()
        }
    }

    //method to handle request callback deeplink navigation
    fun openCarePlanAndShowRequestCallbackDialog() {
        homeHandler?.showCarePlanFragment()
        analytics.setScreenName(AnalyticsScreenNames.CarePlan)
        setBottomSelection(R.id.layoutCarePlan)

        Handler(Looper.getMainLooper()).postDelayed({
            homeHandler?.carePlanFragment?.showRequestCallbackDialogForOrderTest()
        }, 100)
    }

    //method to handle request callback deeplink navigation
    fun openHomeFragmentAndNavigateToCatSurvey() {
        // open home if not already opened
        if (!binding.layoutHome.isSelected) {
            homeHandler?.showHomeFragment(notification, reactInstanceManager)
            ContextHolder.reactContext?.let {
                sendEventToRN(
                    it,
                    "bottomTabNavigationInitiated",
                    ""
                )
            }

            analytics.setScreenName(AnalyticsScreenNames.Home)
            binding.layoutHome.isSelected = true
        }
        //todo Do RN Code
        /*Handler(Looper.getMainLooper()).postDelayed({
            homeHandler?.homeFragment?.handleForCatSurveyNavigation()
        }, 100)*/
    }

    override fun onResume() {
        super.onResume()
        if (this::reactInstanceManager.isInitialized && reactInstanceManager != null) {
            reactInstanceManager.onHostResume(this, this)
        }
        /*Handler(Looper.getMainLooper()).postDelayed({
            getPatientDetails()
        }, 100)*/

        setUserData()
        setUpGoogleFit()
        updateDeviceInfo()

        //reset lastSelectedTabTime to current time
        lastSelectedTabTime = Calendar.getInstance().timeInMillis
    }

    private fun handleToShowHideEngageTab() {
        if (AppFlagHandler.isToHideEngagePage(session.user, firebaseConfigUtil)) {
            binding.layoutMyCircle.isVisible = false
            if (binding.layoutMyCircle.isSelected) {
                binding.layoutHome.callOnClick()
            }
        } else {
            binding.layoutMyCircle.isVisible = true
        }
    }

    override fun onPause() {
        super.onPause()
        if (reactInstanceManager != null) {
            reactInstanceManager.onHostPause(this)
        }
        updateScreenTimeDurationInAnalytics()
    }

    /*private fun setUserData() {
        binding.layoutHeader.apply {
            session.user?.let {
                //imageViewProfile.loadUrl(it.profile_pic ?: "")
                //val imageUri="android.resource://${BuildConfig.APPLICATION_ID}/ic_exercise"
                imageViewProfile.loadUrl(it.profile_pic ?: "")
                Log.d("PROFILE_IMG", "setUserData: ${it.profile_pic}")
                textViewPatientName.text = it.name
                textViewPlan.text =
                    session.user?.currentPlanName
                //textViewDrName

                if (binding.layoutHome.isSelected && homeHandler?.homeFragment?.isVisible == true) {
                    homeHandler?.homeFragment?.updateUserData()
                } else if (binding.layoutCarePlan.isSelected && homeHandler?.carePlanFragment?.isVisible == true) {
                    homeHandler?.carePlanFragment?.updateNotificationCountBadge()
                }
            }
        }
    }*/

    private fun setUserData() {
        binding.layoutNavigation.apply {
            session.user?.let {
                if (it.profile_pic.isNullOrEmpty()) {
                    imageViewEditProfile.isVisible = true
                } else {
                    imageViewEditProfile.isVisible = false
                    imageViewProfile.loadUrl(
                        it.profile_pic
                            ?: "", R.drawable.place_holder, true
                    )
                }

                textViewPatientName.text = it.name
                tvContactNo.text = "${it.country_code}-${it.contact_no}"
                if (binding.layoutHome.isSelected && homeHandler?.homeFragment?.isVisible == true) {
                    //todo Do RN Code
                    //homeHandler?.homeFragment?.updateUserData()
                } else if (binding.layoutCarePlan.isSelected && homeHandler?.carePlanFragment?.isVisible == true) {
                    homeHandler?.carePlanFragment?.updateNotificationCountBadge()
                }
            }
        }
    }

    /*private fun setViewListeners() {
        binding.apply {
            layoutHome.setOnClickListener { onClick(it) }
            layoutCarePlan.setOnClickListener { onClick(it) }
            layoutMyCircle.setOnClickListener { onClick(it) }
            layoutExercise.setOnClickListener { onClick(it) }
            *//*layoutMore.setOnClickListener { onClick(it) }*//*
            layoutHeader.apply {
                imageViewCloseMenu.setOnClickListener { onClick(it) }
                textViewAccountSettings.setOnClickListener { onClick(it) }
                imageViewProfile.setOnClickListener { onClick(it) }
                textViewPatientName.setOnClickListener { onClick(it) }
            }
        }
    }*/

    private fun setViewListeners() {
        binding.apply {
            layoutHome.setOnClickListener { onClick(it) }
            layoutCarePlan.setOnClickListener { onClick(it) }
            layoutMyCircle.setOnClickListener { onClick(it) }
            layoutExercise.setOnClickListener { onClick(it) }
            layoutMore.setOnClickListener { onClick(it) }
            layoutNavigation.apply {
                imageViewProfile.setOnClickListener { onClick(it) }
                textViewPatientName.setOnClickListener { onClick(it) }
            }
        }
    }

    /*private fun setUpDrawer() {
        binding.apply {
            setUpDrawerItems()
            layoutItems.recyclerViewNavMenu.apply {
                layoutManager = LinearLayoutManager(this@HomeActivity, RecyclerView.VERTICAL, false)
                adapter = homeNavDrawerAdapter
            }

            displayAppVersion()

            // to stop opening through slide gesture
            drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED)
        }
    }*/

    private fun setUpDrawer() {
        displayAppVersion()
        setNavigationViewListeners()
        // to stop opening through slide gesture
        binding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED)
    }


    private fun setNavigationViewListeners() {
        binding.layoutNavigation.apply {
            cvHeader.setOnClickListener { onClick(it) }
            ivHealth.setOnClickListener { onClick(it) }
            tvHealth.setOnClickListener { onClick(it) }
            ivBookmark.setOnClickListener { onClick(it) }
            tvBookmark.setOnClickListener { onClick(it) }
            ivGoals.setOnClickListener { onClick(it) }
            tvGoals.setOnClickListener { onClick(it) }
            ivHealthTrends.setOnClickListener { onClick(it) }
            tvHealthTrends.setOnClickListener { onClick(it) }
            ivBmi.setOnClickListener { onClick(it) }
            tvBmi.setOnClickListener { onClick(it) }
            ivConsult.setOnClickListener { onClick(it) }
            tvConsult.setOnClickListener { onClick(it) }
            ivLabTest.setOnClickListener { onClick(it) }
            tvLabTest.setOnClickListener { onClick(it) }
            ivAccount.setOnClickListener { onClick(it) }
            tvAccount.setOnClickListener { onClick(it) }
            ivHelp.setOnClickListener { onClick(it) }
            tvHelp.setOnClickListener { onClick(it) }
            ivAbout.setOnClickListener { onClick(it) }
            tvAbout.setOnClickListener { onClick(it) }
            ivShare.setOnClickListener { onClick(it) }
            tvShare.setOnClickListener { onClick(it) }
            ivRate.setOnClickListener { onClick(it) }
            tvRate.setOnClickListener { onClick(it) }
        }
    }

    private fun displayAppVersion() {
        val sb = StringBuilder()
        sb.append("Version ").append(BuildConfig.VERSION_NAME)
        if (BuildConfig.DEBUG) {
            //display version code for debug build only
            sb.append("(${BuildConfig.VERSION_CODE})")
        }
        binding.layoutNavigation.textViewAppVersion.text = sb.toString()
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.layoutHome -> {
                if (binding.layoutHome.isSelected.not()) {
                    //binding.imageViewHome.animationOne()
                    analytics.logEvent(analytics.USER_TAPS_ON_BOTTOM_NAV, Bundle().apply {
                        putString(analytics.PARAM_MODULE, "Home")
                    }, screenName = AnalyticsScreenNames.Home)

                    setBottomSelection(v.id)
                    homeHandler?.showHomeFragment(notification, reactInstanceManager)
                    ContextHolder.reactContext?.let {
                        sendEventToRN(
                            it,
                            "bottomTabNavigationInitiated",
                            ""
                        )
                    }

                    analytics.setScreenName(AnalyticsScreenNames.Home)
                    showAccountSetupDialog()
                }
            }

            R.id.layoutCarePlan -> {
                if (binding.layoutCarePlan.isSelected.not()) {
                    //binding.imageViewCarePlan.animationOne()
                    analytics.logEvent(analytics.USER_TAPS_ON_BOTTOM_NAV, Bundle().apply {
                        putString(analytics.PARAM_MODULE, "Care Plan")
                    }, screenName = AnalyticsScreenNames.Home)

                    setBottomSelection(v.id)
                    homeHandler?.showCarePlanFragment()
                    analytics.setScreenName(AnalyticsScreenNames.CarePlan)
                }
            }

            R.id.layoutMyCircle -> {
                if (binding.layoutMyCircle.isSelected.not()) {
                    //binding.imageViewMyCircle.animationOne()
                    analytics.logEvent(analytics.USER_TAPS_ON_BOTTOM_NAV, Bundle().apply {
                        putString(analytics.PARAM_MODULE, "Discover")
                    }, screenName = AnalyticsScreenNames.Home)

                    setBottomSelection(v.id)
                    homeHandler?.showMyCircleFragment()
                    //analytics.setScreenName(AnalyticsScreenNames.DiscoverEngage)
                }
            }

            R.id.layoutExercise -> {
                if (binding.layoutExercise.isSelected.not()) {
                    //binding.imageViewExercise.animationOne()
                    analytics.logEvent(analytics.USER_TAPS_ON_BOTTOM_NAV, Bundle().apply {
                        putString(analytics.PARAM_MODULE, "Exercise")
                    }, screenName = AnalyticsScreenNames.Home)

                    setBottomSelection(v.id)
                    homeHandler?.showExerciseFragment()
                }
            }

            R.id.layoutMore -> {
                if (binding.layoutMore.isSelected.not()) {
                    setBottomSelection(v.id)
                    homeHandler?.showMoreFragment()
                }
            }

            R.id.imageViewCloseMenu -> {
                toggleDrawer()
            }

            R.id.textViewAccountSettings -> {
                toggleDrawer()
                loadActivity(
                    IsolatedFullActivity::class.java,
                    AccountSettingsFragment::class.java
                ).start()
            }


            R.id.cvHeader -> {
                toggleDrawer()
                loadActivity(
                    IsolatedFullActivity::class.java,
                    MyProfileFragment::class.java
                ).start()
            }

            R.id.ivHealth, R.id.tvHealth -> {
                toggleDrawer()
                loadActivity(IsolatedFullActivity::class.java, HistoryFragment::class.java)
                    .addBundle(Bundle().apply {
                        putBoolean(Common.BundleKey.IS_SHOW_RECORD, true)
                    }).start()
            }

            R.id.ivBookmark, R.id.tvBookmark -> {
                toggleDrawer()
                if (isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                    loadActivity(IsolatedFullActivity::class.java, BookmarksFragment::class.java)
                        .start()
                }
            }

            R.id.ivGoals, R.id.tvGoals, R.id.ivHealthTrends, R.id.tvHealthTrends -> {
                toggleDrawer()
                loadActivity(
                    IsolatedFullActivity::class.java,
                    SetupGoalsReadingsFragment::class.java
                )
                    .start()
            }

            R.id.ivLabTest, R.id.tvLabTest -> {
                toggleDrawer()
                /*loadActivity(IsolatedFullActivity::class.java, LabTestListFragment::class.java)
                    .start()*/

                loadActivity(
                    IsolatedFullActivity::class.java,
                    HistoryFragment::class.java
                )
                    .addBundle(Bundle().apply {
                        putBoolean(Common.BundleKey.IS_SHOW_TEST, true)
                    }).start()
            }

            R.id.ivConsult, R.id.tvConsult -> {
                toggleDrawer()
                loadActivity(IsolatedFullActivity::class.java, AllAppointmentsFragment::class.java)
                    .start()
            }

            R.id.ivAccount, R.id.tvAccount -> {
                toggleDrawer()
                loadActivity(IsolatedFullActivity::class.java, AccountSettingsFragment::class.java)
                    .start()
            }

            R.id.ivHelp, R.id.tvHelp -> {
                toggleDrawer()
                loadActivity(IsolatedFullActivity::class.java, HelpSupportFAQFragment::class.java)
                    .start()
            }

            R.id.ivAbout, R.id.tvAbout -> {
                toggleDrawer()
                loadActivity(IsolatedFullActivity::class.java, AboutUsFragment::class.java)
                    .start()
            }

            R.id.ivShare, R.id.tvShare -> {
                toggleDrawer()
                shareApp()
            }

            R.id.ivRate, R.id.tvRate -> {
                toggleDrawer()
                openAppInStore()
            }

            R.id.ivBmi, R.id.tvBmi -> {
                toggleDrawer()
                loadActivity(
                    IsolatedFullActivity::class.java, SetupHeightWeightFragment::class.java
                ).start()
            }
        }
    }

    fun navigateToExercise() {
        setBottomSelection(R.id.layoutExercise)
        homeHandler?.showExerciseFragment()
        Handler(Looper.getMainLooper()).postDelayed({
            homeHandler?.exerciseFragment?.setViewPagerItemPosition(0)
        }, 50)
    }

    fun navigateToCarePlan() {
        analytics.logEvent(analytics.USER_TAPS_ON_BOTTOM_NAV, Bundle().apply {
            putString(analytics.PARAM_MODULE, "Care Plan")
        }, screenName = AnalyticsScreenNames.Home)

        setBottomSelection(R.id.layoutCarePlan)
        homeHandler?.showCarePlanFragment()
        analytics.setScreenName(AnalyticsScreenNames.CarePlan)
    }

    fun navigateToDiscover() {
        analytics.logEvent(analytics.USER_TAPS_ON_BOTTOM_NAV, Bundle().apply {
            putString(analytics.PARAM_MODULE, "Discover")
        }, screenName = AnalyticsScreenNames.Home)

        setBottomSelection(R.id.layoutMyCircle)
        homeHandler?.showMyCircleFragment()
    }

    private fun setBottomSelection(viewId: Int) {
        //set previousSelectedHomeMenuId before updating new selection
        with(binding) {
            previousSelectedHomeMenuId = if (layoutHome.isSelected) R.id.layoutHome
            else if (layoutCarePlan.isSelected) R.id.layoutCarePlan
            else if (layoutMyCircle.isSelected) R.id.layoutMyCircle
            else if (layoutExercise.isSelected) R.id.layoutExercise
            else R.id.layoutMore
        }

        when (viewId) {
            R.id.layoutHome, R.id.layoutCarePlan, R.id.layoutMyCircle, R.id.layoutExercise, R.id.layoutMore -> {
                with(binding) {
                    layoutHome.isSelected = viewId == R.id.layoutHome
                    layoutCarePlan.isSelected = viewId == R.id.layoutCarePlan
                    layoutMyCircle.isSelected = viewId == R.id.layoutMyCircle
                    layoutExercise.isSelected = viewId == R.id.layoutExercise
                    layoutMore.isSelected = viewId == R.id.layoutMore
                }
            }
        }

        //update selected text style
        with(binding) {
            textViewHome.setTextAppearance(if (viewId == R.id.layoutHome) R.style.bottom_nav_item_text_selected else R.style.bottom_nav_item_text)
            textViewCarePlan.setTextAppearance(if (viewId == R.id.layoutCarePlan) R.style.bottom_nav_item_text_selected else R.style.bottom_nav_item_text)
            textViewLearn.setTextAppearance(if (viewId == R.id.layoutMyCircle) R.style.bottom_nav_item_text_selected else R.style.bottom_nav_item_text)
            textViewExercise.setTextAppearance(if (viewId == R.id.layoutExercise) R.style.bottom_nav_item_text_selected else R.style.bottom_nav_item_text)
        }

        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics(isActivityPaused: Boolean = false) {
        // updateScreenTimeDurationInAnalytics - method to update last screen time duration in analytics
        val diffInMs: Long = Calendar.getInstance().timeInMillis - lastSelectedTabTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()

        //reset lastSelectedTabTime to current time
        lastSelectedTabTime = Calendar.getInstance().timeInMillis

        when (if (isActivityPaused) currentSelectedHomeMenuId else previousSelectedHomeMenuId) {
            R.id.layoutHome -> {
                /*analytics.logEvent(analytics.USER_TIME_SPENT_HOME, Bundle().apply {
                    putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
                }, screenName = AnalyticsScreenNames.Home)*/
            }

            R.id.layoutCarePlan -> {
                /*analytics.logEvent(analytics.USER_TIME_SPENT_CARE_PLAN, Bundle().apply {
                    putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
                }, screenName = AnalyticsScreenNames.CarePlan)*/
            }

            R.id.layoutMyCircle -> {
                /*analytics.logEvent(analytics.USER_TIME_SPENT_ENGAGE, Bundle().apply {
                    putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
                })*/
            }

            R.id.layoutExercise -> {
                /*analytics.logEvent(analytics.USER_TIME_SPENT_EXERCISE, Bundle().apply {
                    putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
                })*/
            }
        }
    }

    fun toggleDrawer() {
        hideKeyboard()
        with(binding) {
            if (drawerLayout.isDrawerOpen(GravityCompat.END)) {
                analytics.setScreenName(AnalyticsScreenNames.Home)
                drawerLayout.closeDrawers()
                updateMenuScreenTimeDurationInAnalytics()
            } else {
                analytics.setScreenName(AnalyticsScreenNames.Menu)
                drawerLayout.openDrawer(GravityCompat.END)
                menuResumedTime = Calendar.getInstance().timeInMillis
            }
        }
    }

    var menuResumedTime = Calendar.getInstance().timeInMillis
    private fun updateMenuScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - menuResumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        /*analytics.logEvent(analytics.TIME_SPENT_OPTION_MENU, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.Menu)*/
    }

    override fun onBackPressed() {
        hideKeyboard()
        if (binding.drawerLayout.isDrawerOpen(GravityCompat.START)) {
            //binding.drawerLayout.closeDrawer(GravityCompat.START)
            toggleDrawer()
        } else {
            if (reactInstanceManager != null) {
                reactInstanceManager.onBackPressed()
                super.onBackPressed()
            } else {
                super.onBackPressed()
            }
        }
    }

    private fun handleDrawerItemClick(drawerItem: DrawerItem) {
        toggleDrawer()
        when (drawerItem) {
            /*DrawerItem.FoodDiary -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs, Goals.Diet.goalKey)) {
                    loadActivity(IsolatedFullActivity::class.java,
                        FoodDiaryMainFragment::class.java).start()
                }
            }*/
            DrawerItem.MyTatvaPlans -> {
                /*loadActivity(IsolatedFullActivity::class.java,
                    PaymentPlanServiceMainFragment::class.java).start()*/
                loadActivity(
                    IsolatedFullActivity::class.java,
                    PaymentCarePlanListingFragment::class.java
                ).start()
            }

            DrawerItem.TransactionHistory -> {
                loadActivity(IsolatedFullActivity::class.java, HistoryFragment::class.java).start()
            }

            DrawerItem.DefineYourGoals -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    SetupHeightWeightFragment::class.java
                ).start()
            }

            DrawerItem.GoalsAndHealthTrends -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    SetupGoalsReadingsFragment::class.java
                ).start()
            }

            DrawerItem.DiagnosticReports -> {
                loadActivity(IsolatedFullActivity::class.java, HistoryFragment::class.java)
                    .addBundle(Bundle().apply {
                        putBoolean(Common.BundleKey.IS_SHOW_TEST, true)
                    }).start()
            }

            DrawerItem.History -> {
                loadActivity(IsolatedFullActivity::class.java, HistoryFragment::class.java).start()
            }
            /*DrawerItem.BookAppointment -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                    loadActivity(IsolatedFullActivity::class.java,
                        BookAppointmentsFragment::class.java).start()
                }
            }
            DrawerItem.BookYourTest -> {
                loadActivity(IsolatedFullActivity::class.java,
                    LabTestListFragment::class.java).start()
            }*/
            DrawerItem.Bookmarks -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                    loadActivity(
                        IsolatedFullActivity::class.java,
                        BookmarksFragment::class.java
                    ).start()
                }
            }

            DrawerItem.AppTour -> {
                /*coachMarksUtil.start {
                    if (homeHandler?.homeFragment?.isAdded == true && homeHandler?.homeFragment?.isVisible == true) {
                        //homeHandler?.homeFragment?.showCoachMark()
                    }
                }*/

                initCoachMarks()
            }

            DrawerItem.ShareApp -> {
                shareApp()
            }

            DrawerItem.RateApp -> {
                openAppInStore()
            }
            /*DrawerItem.ReportIncident -> {
                analytics.logEvent(analytics.USER_CLICKED_ON_REPORT_INCIDENT,
                    screenName = AnalyticsScreenNames.Menu)
                if (isFeatureAllowedAsPerPlan(PlanFeatures.incident_records_history)) {
                    //getIncidentSurvey()
                    if (incidentSurveyData != null) {
                        loadActivity(TransparentActivity::class.java,
                            AddIncidentFragment::class.java).addBundle(bundleOf(Pair(Common.BundleKey.INCIDENT_SURVEY_DATA,
                            incidentSurveyData))).start()
                    }
                }
            }*/
            DrawerItem.ContactUs -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    HelpSupportFAQFragment::class.java
                ).start()
            }

            DrawerItem.TermsConditions -> {
                //openBrowser(URLFactory.AppUrls.TERMS_CONDITIONS)
                loadActivity(IsolatedFullActivity::class.java, WebViewCommonFragment::class.java)
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.TITLE, DrawerItem.TermsConditions.drawerItem),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.TERMS_CONDITIONS)
                        )
                    )
                    .start()

                /*WebViewCommonDialog().apply {
                    arguments = bundleOf(
                        Pair(Common.BundleKey.TITLE, DrawerItem.TermsConditions.drawerItem),
                        Pair(Common.BundleKey.URL, URLFactory.AppUrls.TERMS_CONDITIONS)
                    )
                }.show(supportFragmentManager, WebViewCommonDialog::class.java.simpleName)*/
            }

            DrawerItem.PrivacyPolicy -> {
                loadActivity(IsolatedFullActivity::class.java, WebViewCommonFragment::class.java)
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.TITLE, DrawerItem.PrivacyPolicy.drawerItem),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.PRIVACY_POLICY)
                        )
                    ).start()

                /*WebViewCommonDialog().apply {
                    arguments = bundleOf(
                        Pair(Common.BundleKey.TITLE, DrawerItem.PrivacyPolicy.drawerItem),
                        Pair(Common.BundleKey.URL, URLFactory.AppUrls.PRIVACY_POLICY)
                    )
                }.show(supportFragmentManager, WebViewCommonDialog::class.java.simpleName)*/
            }
            /*DrawerItem.LogOut -> {
                showAlertDialogWithOptions("Are you sure want to log out?",
                    dialogYesNoListener = object : DialogYesNoListener {
                        override fun onYesClick() {
                            callLogoutApi()
                        }

                        override fun onNoClick() {

                        }
                    })
            }*/
        }
    }

    fun initCoachMarks() {
        if (coachMarksList.isNotEmpty()) {
            startCoachMarksFlow()
        } else {
            coachMarks()
        }
    }

    private fun startCoachMarksFlow() {
        if (binding.layoutHome.isSelected.not()) {
            //display home screen if not
            homeHandler?.showHomeFragment(notification, reactInstanceManager)
            ContextHolder.reactContext?.let {
                sendEventToRN(
                    it,
                    "bottomTabNavigationInitiated",
                    ""
                )
            }

            analytics.setScreenName(AnalyticsScreenNames.Home)
            setBottomSelection(R.id.layoutHome)
        }

        StartCoachMarkDialog { isSkip ->
            if (isSkip.not()) {
                if (homeHandler?.homeFragment?.isAdded == true && homeHandler?.homeFragment?.isVisible == true) {
                    //todo Do RN Code
                    /*homeHandler?.homeFragment?.showCoachMark {
                        goToCarePlan()
                    }*/
                }
            } else {
                showSkipCoachMarkMessage()
            }
        }.show(supportFragmentManager, StartCoachMarkDialog::class.java.simpleName)
    }

    private fun goToCarePlan() {
        binding.layoutCarePlan.callOnClick()
        Handler(Looper.getMainLooper()).postDelayed({
            if (homeHandler?.carePlanFragment?.isAdded == true && homeHandler?.carePlanFragment?.isVisible == true) {
                homeHandler?.carePlanFragment?.showCoachMark {
                    if (AppFlagHandler.isToHideEngagePage(session.user, firebaseConfigUtil)) {
                        //if engage is hidden directly move coachMark to exercise
                        goToExercise()
                    } else {
                        // else continue to engage tab
                        goToEngage()
                    }
                }
            }
        }, 200)
    }

    private fun goToEngage() {
        binding.layoutMyCircle.callOnClick()
        Handler(Looper.getMainLooper()).postDelayed({
            if (homeHandler?.engageFragment?.isAdded == true && homeHandler?.engageFragment?.isVisible == true) {
                homeHandler?.engageFragment?.showCoachMark {
                    goToExercise()
                }
            }
        }, 200)
    }

    private fun goToExercise() {
        binding.layoutExercise.callOnClick()
        Handler(Looper.getMainLooper()).postDelayed({
            if (homeHandler?.exerciseFragment?.isAdded == true && homeHandler?.exerciseFragment?.isVisible == true) {
                homeHandler?.exerciseFragment?.showCoachMark {

                    //coachmarks completed
                    analytics.logEvent(
                        analytics.USER_COMPLETED_COACH_MARKS,
                        screenName = AnalyticsScreenNames.ExerciseMore
                    )

                }
            }
        }, 200)
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateDeviceInfo(
        optionalUpdateSkip: Boolean? = null,
        isToShowLoader: Boolean = false,
    ) {
        val apiRequest = ApiRequest().apply {
            device_token = session.deviceId
            device_type = Session.DEVICE_TYPE
            uuid = session.deviceFID
            os_version = DeviceUtils.deviceOSVersion.toString()
            device_name = DeviceUtils.deviceName
            model_name = DeviceUtils.deviceName
            app_version = BuildConfig.VERSION_NAME
            build_version_number = BuildConfig.VERSION_CODE.toString()
            ip = DeviceUtils.getIPAddress()

            //to skip optional update
            optionalUpdateSkip?.let {
                optional_update = it.toString()
            }
        }

        location?.let {
            apiRequest.lat = it.latitude.toString()
            apiRequest.long = it.longitude.toString()
        }

        if (isToShowLoader) showLoader()

        authViewModel.updateDeviceInfo(apiRequest)
    }

    /*fun callLogoutApi() {
        val apiRequest = ApiRequest()
        showLoader()
        authViewModel.logout(apiRequest)
    }*/

    fun getPatientDetails() {
        val apiRequest = ApiRequest()
        authViewModel.getPatientDetails(apiRequest)
    }

    fun coachMarks() {
        val apiRequest = ApiRequest()
        authViewModel.coachMarks(apiRequest)
    }

    private fun linkedHealthCoachList() {
        val apiRequest = ApiRequest()
        // A for all HCs or C for chat not initiated HCs only
        apiRequest.list_type = "C"
        //showLoader()
        authViewModel.linkedHealthCoachList(apiRequest)
    }

    private fun updateHealthCoachChatInitiate(healthCoachList: ArrayList<HealthCoachData>) {
        val apiRequest = ApiRequest()
        apiRequest.health_coach_ids = healthCoachList.listOfField(HealthCoachData::health_coach_id)
        //showLoader()
        authViewModel.updateHealthcoachChatInitiate(apiRequest)
    }

    private fun getIncidentSurvey() {
        val apiRequest = ApiRequest()
        showLoader()
        goalReadingViewModel.getIncidentSurvey(apiRequest)
    }

    /*private fun updateReadingsGoals() {
        val cal = Calendar.getInstance()
        cal.add(Calendar.DAY_OF_YEAR, -100)

        googleFit.readGoals(cal) { goalsList ->

            Log.e("FINAL", "GOAL")

            googleFit.readReadings(cal) { readingsList ->

                *//*val apiRequest = ApiRequest()
                apiRequest.goal_data = goalsList
                apiRequest.reading_data = readingsList
                goalReadingViewModel.updateReadingsGoals(apiRequest)*//*

                // goals update in server with sub data list
                for (i in 0 until goalsList.size step 20) {
                    Log.e("GOAL-READING", "updateReadingsGoals: $i :: ${goalsList.size}")

                    val subList = arrayListOf<ApiRequestSubData>()
                    subList.addAll(goalsList.take(20))

                    //remove from main list which are added to sublist
                    for (j in 0 until subList.size) {
                        goalsList.removeAt(0)
                    }

                    Log.e("GOAL-READING", "subList goal Size: ${subList.size}")

                    // update sublist in server
                    val apiRequest = ApiRequest()
                    apiRequest.goal_data = subList
                    goalReadingViewModel.updateReadingsGoals(apiRequest)
                }


                // readings update in server with sub data list
                for (i in 0 until readingsList.size step 20) {
                    Log.e("GOAL-READING", "updateReadingsGoals: $i :: ${readingsList.size}")

                    val subList = arrayListOf<ApiRequestSubData>()
                    subList.addAll(readingsList.take(20))

                    //remove from main list which are added to sublist
                    for (j in 0 until subList.size) {
                        readingsList.removeAt(0)
                    }

                    Log.e("GOAL-READING", "subList reading Size: ${subList.size}")

                    // update sublist in server
                    val apiRequest = ApiRequest()
                    apiRequest.reading_data = subList
                    goalReadingViewModel.updateReadingsGoals(apiRequest)
                }

            }
        }
    }*/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updateDeviceInfoLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            //showErrorMessage(responseBody.message)
            /*if (responseBody.responseCode == Common.ResponseCode.APP_UNDER_MAINTENENCE) {
                Handler(Looper.getMainLooper()).postDelayed({
                    navigateToAppUnderMaintenance(responseBody.data?.title ?: "",
                        responseBody.data?.message ?: "")
                }, 0)
            }*/
        }, onError = { throwable ->
            hideLoader()
            if (throwable is ServerException && throwable.code == Common.ResponseCode.FORCE_UPDATE_APP) {
                /*if (BuildConfig.DEBUG.not()) {*/
                showAlertDialog(throwable.message ?: "",
                    dialogOkListener = object : DialogOkListener {
                        override fun onClick() {
                            openAppInStore()
                        }
                    })
                /*}*/
            } else if (throwable is ServerException && throwable.code == Common.ResponseCode.OPTIONAL_UPDATE_APP) {
                showAlertDialogWithOptions(throwable.message ?: "",
                    positiveText = "Update",
                    negativeText = "Skip",
                    dialogYesNoListener = object : DialogYesNoListener {
                        override fun onYesClick() {
                            openAppInStore()
                        }

                        override fun onNoClick() {
                            updateDeviceInfo(optionalUpdateSkip = true)
                        }
                    })
            }
            false
        })

        /*authViewModel.logoutLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            logout(AnalyticsScreenNames.Menu)
        }, onError = { throwable ->
            hideLoader()
            *//*googleFit.disconnect {
                 logout()
             }*//*
            true
        })*/

        authViewModel.getPatientDetailsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            setUserData()

            // to refresh home screen
            if (binding.layoutHome.isSelected) {
                //todo Do RN Code
                //homeHandler?.homeFragment?.updateUserData()
            }

            showAccountSetupDialog()

            /*if (linkHealthCoachListAPICalled.not()) {
                linkHealthCoachListAPICalled = true
                linkedHealthCoachList()
            }*/
        }, onError = { throwable ->
            hideLoader()
            true
        })

        /*authViewModel.linkedHealthCoachListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            if (responseBody.data.isNullOrEmpty().not()) {
                handleToInitiateChatWithHCs(responseBody.data!!)
            }
        }, onError = { throwable ->
            hideLoader()
            false
        })*/

        authViewModel.updateHealthcoachChatInitiateLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                Log.d("Response", "updateHealthcoachChatInitiateLiveData success")
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.coachMarksLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            responseBody.data?.let {
                coachMarksList.clear()
                coachMarksList.addAll(it)
                //startCoachMarksFlow()
            }
        }, onError = { throwable ->
            hideLoader()
            false
        })

        //getIncidentSurveyLiveData
        goalReadingViewModel.getIncidentSurveyLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            incidentSurveyData = responseBody.data
            setUpDrawerItems()
            homeNavDrawerAdapter.notifyDataSetChanged()
        }, onError = { throwable ->
            hideLoader()
            false
        })

        /* goalReadingViewModel.updateReadingsGoalsLiveData.observe(this,
             onChange = { responseBody ->
                 hideLoader()
                 //showErrorMessage(responseBody.message)
                 Log.e("updateReadingsGoals", " :: UPDATE SUCCESS")
             },
             onError = { throwable ->
                 hideLoader()
                 Log.e("updateReadingsGoals", " :: UPDATE ERROR")
                 true
             })*/

        authViewModel.updatePatientLocationLiveData.observe(this,
            onChange = { responseBody ->
                val resultData: WritableMap = WritableNativeMap()
                resultData.putString("city", selectedCity)
                resultData.putString("state", selectedState)
                resultData.putString("country", "india")

                hideLoader()
                ContextHolder.reactContext?.let {
                    sendEventToRN(
                        it,
                        "locationUpdatedSuccessfully",
                        resultData
                    )
                }
                //homeHandler?.homeFragment?.updateUserData()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    /*
     * above method is not called from changes as per MAR1 2023 sprint
     * [MTP-169] Chat feature bug - Jira (atlassian.net)
     */
    private fun handleToInitiateChatWithHCs(healthCoachList: ArrayList<HealthCoachData>) {
        healthCoachList.forEachIndexed { index, healthCoachData ->
            val tag = healthCoachData.tag_name
            val msgText = "Welcome to the chat between you and your healthcoach"
            val freshChatMessage = FreshchatMessage().setTag(tag).setMessage(msgText)
            Freshchat.sendMessage(this, freshChatMessage)
        }
        updateHealthCoachChatInitiate(healthCoachList)
    }

    private fun navigateToAppUnderMaintenance(title: String, message: String) {
        loadActivity(IsolatedFullActivity::class.java, AppUnderMaintenenceFragment::class.java)
            .addBundle(
                bundleOf(
                    Pair(Common.BundleKey.TITLE, title),
                    Pair(Common.BundleKey.DESCRIPTION, message)
                )
            )
            .byFinishingAll()
            .start()
    }

    private fun updatePatientLocation() {
        val apiRequest = ApiRequest().apply {
            city = selectedCity
            state = selectedState
            country = "india"
        }
        authViewModel.updatePatientLocation(apiRequest)
    }

    override fun invokeDefaultOnBackPressed() {
        if (reactInstanceManager != null) {
            reactInstanceManager.onBackPressed()
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        if (reactInstanceManager != null) {
            reactInstanceManager.onHostDestroy(this);
        }
        if (reactRootView != null) {
            reactRootView.unmountReactApplication();
        }
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_MENU) {
            reactInstanceManager.showDevOptionsDialog()
            return true
        }
        return super.onKeyUp(keyCode, event)
    }

    private var mPermissionsCallback: Callback? = null
    private var mPermissionListener: PermissionListener? = null

    override fun requestPermissions(
        permissions: Array<out String>?,
        requestCode: Int,
        listener: PermissionListener?
    ) {
        mPermissionListener = listener
        requestPermissions(permissions, requestCode, listener)
    }

}