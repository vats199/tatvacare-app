package com.mytatva.patient.ui.base

import android.app.DatePickerDialog
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.TimePickerDialog
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.location.Location
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.MenuItem
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.annotation.ColorRes
import androidx.annotation.StringRes
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.biometric.BiometricManager
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import com.apxor.androidsdk.core.ApxorSDK
import com.apxor.androidsdk.core.RedirectionListener
import com.facebook.react.bridge.ReactContext
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks
import com.google.firebase.dynamiclinks.PendingDynamicLinkData
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.mytatva.patient.R
import com.mytatva.patient.core.AppPreferences
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.model.ApXorKeyValueData
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.response.FeatureRes
import com.mytatva.patient.data.webengage.InAppNotificationModel
import com.mytatva.patient.di.HasComponent
import com.mytatva.patient.di.Injector
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.di.component.DaggerActivityComponent
import com.mytatva.patient.location.LocationException
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.TransparentActivity
import com.mytatva.patient.ui.activity.VideoActivity
import com.mytatva.patient.ui.address.dialog.EnterLocationPinCodeBottomSheetDialog
import com.mytatva.patient.ui.address.dialog.LocationPermissionBottomSheetDialog
import com.mytatva.patient.ui.appointment.fragment.AllAppointmentsFragment
import com.mytatva.patient.ui.appointment.fragment.BookAppointmentsFragment
import com.mytatva.patient.ui.auth.fragment.SelectYourLocationFragment
import com.mytatva.patient.ui.auth.fragment.SetupDrugsFragment
import com.mytatva.patient.ui.auth.fragment.SetupGoalsReadingsFragment
import com.mytatva.patient.ui.careplan.fragment.AddIncidentFragment
import com.mytatva.patient.ui.common.dialog.ImageViewerDialog
import com.mytatva.patient.ui.engage.fragment.EngageFeedDetailsFragment
import com.mytatva.patient.ui.engage.fragment.QuestionDetailsFragment
import com.mytatva.patient.ui.exercise.ExercisePlanDetailsNewFragment
import com.mytatva.patient.ui.exercise.PlanDayDetailsNewFragment
import com.mytatva.patient.ui.goal.fragment.FoodDayInsightFragment
import com.mytatva.patient.ui.goal.fragment.FoodDiaryMainFragment
import com.mytatva.patient.ui.goal.fragment.LogFoodFragment
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.home.dialog.LocationUpdateBottomSheetDialog
import com.mytatva.patient.ui.labtest.fragment.LabTestDetailsFragment
import com.mytatva.patient.ui.labtest.fragment.v1.LabtestCartV1Fragment
import com.mytatva.patient.ui.manager.ActivityBuilder
import com.mytatva.patient.ui.manager.ActivityStarter
import com.mytatva.patient.ui.manager.FragmentActionPerformer
import com.mytatva.patient.ui.manager.FragmentNavigationFactory
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.ui.menu.fragment.BookmarksFragment
import com.mytatva.patient.ui.menu.fragment.HelpSupportFAQFragment
import com.mytatva.patient.ui.menu.fragment.HistoryFragment
import com.mytatva.patient.ui.menu.fragment.UploadRecordFragment
import com.mytatva.patient.ui.payment.fragment.v1.BcpPurchasedDetailsFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentCarePlanListingFragment
import com.mytatva.patient.ui.payment.fragment.v1.PaymentPlanDetailsV1Fragment
import com.mytatva.patient.ui.profile.fragment.EditProfileFragment
import com.mytatva.patient.ui.profile.fragment.MyDevicesFragment
import com.mytatva.patient.ui.profile.fragment.MyProfileFragment
import com.mytatva.patient.ui.profile.fragment.NotificationsFragment
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.utils.AlertNotification
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.DownloadHelper
import com.mytatva.patient.utils.FirebaseConfigUtil
import com.mytatva.patient.utils.LocaleHelper
import com.mytatva.patient.utils.apputils.AppFlagHandler
import com.mytatva.patient.utils.coachmarks.CoachMarksUtil
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import com.mytatva.patient.utils.googlefit.GoogleFit
import com.mytatva.patient.utils.lifetron.MyBluetoothManager
import com.mytatva.patient.utils.openAppSystemSettings
import com.mytatva.patient.utils.surveysparrow.SurveyUtil
import com.webengage.sdk.android.WebEngage
import com.webengage.sdk.android.actions.render.InAppNotificationData
import com.webengage.sdk.android.callbacks.InAppNotificationCallbacks
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.lang.reflect.Type
import java.util.Calendar
import javax.inject.Inject


abstract class
BaseActivity : AppCompatActivity(), HasComponent<ActivityComponent>, HasToolbar,
    Navigator, InAppNotificationCallbacks {

    override val component: ActivityComponent
        get() = activityComponent

    @Inject
    lateinit var analytics: AnalyticsClient

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    @Inject
    lateinit var navigationFactory: FragmentNavigationFactory

    @Inject
    lateinit var activityStarter: ActivityStarter

    @Inject
    lateinit var locationManager: LocationManager

    @Inject
    lateinit var appPreferences: AppPreferences

    @Inject
    lateinit var session: Session
    val isSessionInitialized get() = this::session.isInitialized

    @Inject
    lateinit var googleFit: GoogleFit

    @Inject
    lateinit var surveyUtil: SurveyUtil

    @Inject
    lateinit var downloadHelper: DownloadHelper

    @Inject
    lateinit var coachMarksUtil: CoachMarksUtil

    @Inject
    lateinit var myBluetoothManager: MyBluetoothManager

    lateinit var firebaseConfigUtil: FirebaseConfigUtil

    internal var progressDialog: AlertDialog? = null
    internal var alertDialog: AlertDialog? = null

    private lateinit var activityComponent: ActivityComponent


    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    private val patientPlansViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[PatientPlansViewModel::class.java]
    }

    public fun sendEventToRN(
        reactContext: ReactContext,
        eventName: String,
        params: Any
    ) {
        if (!reactContext.hasActiveCatalystInstance()) {
            return;
        }
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }


    override fun attachBaseContext(newBase: Context?) {
        super.attachBaseContext(/*newBase*/LocaleHelper.updateConfig(newBase))
    }

    override fun onResume() {
        super.onResume()
        WebEngage.registerInAppNotificationCallback(this)
        surveyUtil.activity = this
        googleFit.activity = this
        locationManager.activity = this
        coachMarksUtil.activity = this
        downloadHelper.activity = this
        downloadHelper.registerReceiver()
    }

    override fun onPause() {
        super.onPause()
        WebEngage.unregisterInAppNotificationCallback(this)
        downloadHelper.unregisterReceiver()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        activityComponent = DaggerActivityComponent.builder()
            .bindApplicationComponent(Injector.INSTANCE.applicationComponent)
            .bindActivity(this)
            .build()

        inject(activityComponent)

        observeLiveData()
        super.onCreate(savedInstanceState)
        setContentView(createViewBinding())

        firebaseConfigUtil = FirebaseConfigUtil.getInstance(this)

        setUpDialog()

        /*if (toolbar != null)
            setSupportActionBar(toolbar)*/

        createNotificationChannel()

        // Register a redirection listener ONLY ONCE in your app
        // If you register in multiple places, ONLY the last value will be available.
        // Whenever you register a new one, it will override the existing listener
        ApxorSDK.setRedirectionListener(RedirectionListener { keyValuePairs ->
            val length = keyValuePairs.length()
            /** Response
             * [
             *  {"name": "YourKey","value": "YourValue"},
             * ]
             */
            try {
                val jsonStr = keyValuePairs?.toString()
                val gson = Gson()
                val listType: Type = object : TypeToken<ArrayList<ApXorKeyValueData?>?>() {}.type
                val list: ArrayList<ApXorKeyValueData> = gson.fromJson(jsonStr, listType)

                val apXorKeyValueData = list.firstOrNull { it.name == "deep_link" }
                apXorKeyValueData?.let {
                    val value = it.value ?: ""
                    if (value.isNotBlank() && value.contains("https://", true)) {
                        getDeepLink(Uri.parse(value)) {

                        }
                    }
                }

                /*val pair = keyValuePairs.getJSONObject(0)
                val key = pair.getString("name")
                // Values are always String type. You need to convert based on your need
                val value = pair.getString("value")
                // Your logic continues from here
                Log.d(ApxorSDK::class.java.simpleName, "Pair -> $pair \n key -> $key value -> $value")
                if (value.isNotBlank() && value.contains("https://", true)) {
                    getDeepLink(Uri.parse(value)) {

                    }
                }*/
            } catch (e: JSONException) {
            }
        })
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            //set default notification channel
            val channel = NotificationChannel(
                Common.CHANNEL_ID,
                Common.CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            )
            channel.description = Common.CHANNEL_DESC

            // Register the channel with the system; you can't change the importance or other notification behaviors after this
            val notificationManager = getSystemService(NotificationManager::class.java)

            val notificationChannel = notificationManager?.getNotificationChannel(Common.CHANNEL_ID)
            if (notificationChannel == null) {
                notificationManager?.createNotificationChannel(channel)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        locationManager.checkResult(requestCode, resultCode, data)
        googleFit.onActivityResult(requestCode, resultCode, data)
        surveyUtil.onActivityResult(requestCode, resultCode, data)
        getCurrentFragment<BaseFragment<*>>()?.onActivityResult(requestCode, resultCode, data)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        locationManager.onRequestPermissionsResult(requestCode, permissions, grantResults)
        googleFit.onRequestPermissionsResult(requestCode, permissions, grantResults)
        downloadHelper.onRequestPermissionsResult(requestCode, permissions, grantResults)
        myBluetoothManager.onRequestPermissionsResult(requestCode, permissions, grantResults)
        getCurrentFragment<BaseFragment<*>>()?.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        )
    }

    /**
     * handleLocationPermission from address list
     */
    fun handleLocationPermission(
        successCallBack: ((location: Location?, error: LocationException?) -> Unit),
        isSelectedCustom: Boolean = false,
        bundle: Bundle? = null
    ) {
        locationManager.isPermissionGranted { granted ->
            if (granted) {
                //locationManager.checkNewTypeLocationManage(successCallBack)
//                showLoader()
                Log.d("loader", "1. showLoder")
                locationManager.startLocationUpdates(callback = successCallBack, showLoader = true)
            } else {
                val locationPermissionBottomSheetDialog =
                    LocationPermissionBottomSheetDialog().apply {
                        arguments = bundle
                    }

                locationPermissionBottomSheetDialog.grantPermission = {
                    val isGranted =
                        locationManager.requestPermissionCustom(successCallback = { location, error ->
                            if (locationPermissionBottomSheetDialog.isVisible) {
                                location?.let {
                                    successCallBack.invoke(location, error)
                                    locationPermissionBottomSheetDialog.dismiss()
                                }

                                error?.let {
                                    hideLoader()

                                    if (it.status == LocationManager.Status.NO_PERMISSION) {
                                        showOpenLocationPermissionSettingsOrAskManually()
                                        locationPermissionBottomSheetDialog.dismiss()
                                    }

                                }

                            }
                            locationPermissionBottomSheetDialog.dismiss()
                        })

                    if (isGranted) {
                        hideLoader()
                        locationManager.startLocationUpdates(
                            callback = successCallBack,
                            showLoader = true
                        )
                        locationPermissionBottomSheetDialog.dismiss()
                    }
                }

                locationPermissionBottomSheetDialog.selectManual = {
                    if (!isSelectedCustom) {
                        EnterLocationPinCodeBottomSheetDialog().apply {
                            arguments = bundle
                        }.show(
                            supportFragmentManager,
                            EnterLocationPinCodeBottomSheetDialog::class.java.simpleName
                        )
                    } else {

                    }
                    locationPermissionBottomSheetDialog.dismiss()
                }

                locationPermissionBottomSheetDialog.show(
                    supportFragmentManager,
                    LocationPermissionBottomSheetDialog::class.java.simpleName
                )
            }
        }
    }


    /**
     * handleLocationPermission For Choose PinCode
     */
    fun handleLocationPermissionForChoosePinCode(
        successCallBack: ((location: Location?, error: LocationException?) -> Unit),
        manualCallback: () -> Unit
    ) {
        locationManager.isPermissionGranted { granted ->
            if (granted) {
                showLoader()
                locationManager.startLocationUpdates(callback = successCallBack, showLoader = true)
            } else {
                val locationPermissionBottomSheetDialog =
                    LocationPermissionBottomSheetDialog().apply {
                        arguments = this.arguments
                    }

                locationPermissionBottomSheetDialog.grantPermission = {
                    locationManager.requestPermissionCustom(successCallback = { location, error ->

                        if (locationPermissionBottomSheetDialog.isVisible) {
                            location?.let {
                                showLoader()
                                successCallBack.invoke(location, error)
                                locationPermissionBottomSheetDialog.dismiss()
                            }

                            error?.let {
                                hideLoader()
                                if (it.status == LocationManager.Status.NO_PERMISSION) {
                                    showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location),
                                        onCancelCallback = {
                                            manualCallback.invoke()
                                        })
                                    locationPermissionBottomSheetDialog.dismiss()
                                }
                            }

                        }
                        locationPermissionBottomSheetDialog.dismiss()
                    })
                }

                locationPermissionBottomSheetDialog.selectManual = {
                    manualCallback.invoke()
                    locationPermissionBottomSheetDialog.dismiss()
                }

                locationPermissionBottomSheetDialog.show(
                    supportFragmentManager,
                    LocationPermissionBottomSheetDialog::class.java.simpleName
                )
            }
        }
    }

    /**
     * handleLocationPermission For Home Screen
     */
    fun handleLocationUpdateForHomeScreen(
        successCallBack: ((location: Location?, error: LocationException?) -> Unit),
        manualCallback: () -> Unit
    ) {
        locationManager.isPermissionGranted { granted ->
            if (granted) {

                showLoader()
                locationManager.startLocationUpdates(callback = successCallBack, showLoader = true)
            } else {
                val locationUpdateBottomSheetDialog = LocationUpdateBottomSheetDialog().apply {
                    arguments = this.arguments
                }

                locationUpdateBottomSheetDialog.grantPermission = {
                    analytics.logEvent(AnalyticsClient.CLICKED_GRANT_LOCATION, Bundle().apply {
                        putString(
                            analytics.PARAM_BOTTOM_SHEET_NAME,
                            analytics.PARAM_GRANT_LOCATION_PERMISSION
                        )
                    })

                    locationManager.requestPermissionCustom(successCallback = { location, error ->

                        location?.let {
                            showLoader()
                            successCallBack.invoke(location, error)
                            locationUpdateBottomSheetDialog.dismiss()
                        }

                        error?.let {
                            hideLoader()
                            if (it.status == LocationManager.Status.NO_PERMISSION) {
                                showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location))
                            }
                            locationUpdateBottomSheetDialog.dismiss()
                        }
                    })
                }

                locationUpdateBottomSheetDialog.selectManual = {
                    manualCallback.invoke()
                    locationUpdateBottomSheetDialog.dismiss()
                }

                if (!locationUpdateBottomSheetDialog.isVisible) {
                    locationUpdateBottomSheetDialog.show(
                        supportFragmentManager,
                        LocationPermissionBottomSheetDialog::class.java.simpleName
                    )
                }

            }
        }
    }

    /*fun handleLocationUpdateForHomeScreen(
        successCallBack: ((location: Location?, error: LocationException?) -> Unit),
        manualCallback: () -> Unit
    ) {
        locationManager.isPermissionGranted { granted ->
            if (granted) {
                showLoader()
                locationManager.startLocationUpdates(callback = successCallBack)
            } else {
                val locationUpdateBottomSheetDialog = LocationUpdateBottomSheetDialog().apply {
                    arguments = this.arguments
                }

                locationUpdateBottomSheetDialog.grantPermission = {
                    locationManager.requestPermissionCustom(successCallback = { location, error ->

                        if (locationUpdateBottomSheetDialog.isVisible) {
                            location?.let {
                                showLoader()
                                successCallBack.invoke(location, error)
                                locationUpdateBottomSheetDialog.dismiss()
                            }

                            error?.let {
                                hideLoader()
                                if (it.status == LocationManager.Status.NO_PERMISSION) {
                                    showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location),
                                        onCancelCallback = {
                                            manualCallback.invoke()
                                        })
                                    locationUpdateBottomSheetDialog.dismiss()
                                }
                            }

                        }
                        locationUpdateBottomSheetDialog.dismiss()
                    })
                }

                locationUpdateBottomSheetDialog.selectManual = {
                    manualCallback.invoke()
                    locationUpdateBottomSheetDialog.dismiss()
                }

                locationUpdateBottomSheetDialog.show(supportFragmentManager, LocationPermissionBottomSheetDialog::class.java.simpleName)
            }
        }
    }*/


    fun onError(throwable: Throwable) {
        Log.d("TIMEOUT", ":: BaseActivity On Error")
        getCurrentFragment<BaseFragment<*>>()?.onError(throwable)
    }

    //var imageViewProgress: AppCompatImageView?=null
    private fun setUpDialog() {
        val dialogBuilder = AlertDialog.Builder(this)
        val dialogView =
            LayoutInflater.from(this).inflate(R.layout.progress_bar_layout, null, false)
        //imageViewProgress = dialogView.findViewById<AppCompatImageView>(R.id.imageViewProgress)

        /*Glide.with(this)
            .asGif()
            .load(R.drawable.mytatva_loader)
            .into(imageViewProgress!!)*/

        dialogBuilder.setView(dialogView)
        dialogBuilder.setCancelable(false)
        progressDialog = dialogBuilder.create()
        progressDialog?.window?.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        progressDialog?.window?.setDimAmount(0.6f)
    }

    fun logout(screenName: String? = null) {

        //clear all notifications on logout
        val notificationManager =
            applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancelAll()

        //clear applied coupon code on logout
        LabtestCartV1Fragment.clearAppliedCouponCodeData()

        googleFit.disconnect {
            FirebaseLink.clearValues()
            analytics.logout()
            analytics.logEvent(analytics.USER_SESSION_END, screenName = screenName)
            appPreferences.putBoolean(Common.IS_LOGIN, false)
            session.user = null
            session.userSession = ""
            session.userId = ""

            if (VideoActivity.isPictureInPictureModeActive) {
                // if PiP mode active then close it first and then after delay, move to auth screen
                sendBroadcastToFinishPiPActivity()
                Handler(Looper.getMainLooper()).postDelayed({
                    loadActivity(AuthActivity::class.java).byFinishingAll().start()
                }, 700)
            } else {
                loadActivity(AuthActivity::class.java).byFinishingAll().start()
            }
        }
    }

    private fun sendBroadcastToFinishPiPActivity() {
        if (VideoActivity.isPictureInPictureModeActive) {
            val broadCastIntent = Intent(VideoActivity.ACTION_FINISH_ACTIVITY)
            sendBroadcast(broadCastIntent)
            Log.d("VideoActivity", "sendBroadcastToFinishPiPActivity")
        }
    }

    fun showLoader() {
        if (progressDialog != null) {
            if (progressDialog!!.isShowing.not())
                progressDialog?.show()
        } else {
            setUpDialog()
            if (progressDialog!!.isShowing.not())
                progressDialog?.show()
        }
    }

    fun hideLoader() {
        if (progressDialog != null && progressDialog!!.isShowing) {
            progressDialog?.dismiss()
        }
    }

    fun <F : BaseFragment<*>> getCurrentFragment(): F? {
        return if (findFragmentPlaceHolder() == 0) null else supportFragmentManager.findFragmentById(
            findFragmentPlaceHolder()
        ) as F?
    }

    abstract fun findFragmentPlaceHolder(): Int

    abstract fun createViewBinding(): View

    abstract fun inject(activityComponent: ActivityComponent)

    override fun onStart() {
        super.onStart()
        Log.e("BaseActivity", "onStart: ")
    }

    override fun onStop() {
        super.onStop()
        Log.e("BaseActivity", "onStop: ")
    }

    fun showErrorMessage(message: String) {
        /*val f = getCurrentFragment<BaseFragment<*, *>>()
        if (f != null)
            Snackbar.make(f.getView()!!, message!!, BaseTransientBottomBar.LENGTH_SHORT).show()*/

        AlertNotification.showMessage(this, message)
    }

    fun showAppMessage(message: String, status: AppMsgStatus = AppMsgStatus.DEFAULT) {
        AlertNotification.showAppMessage(this, message, status)
    }

    fun showToast(message: String) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    }

    fun toggleLoader(show: Boolean) {
        if (show) {
            if (!progressDialog!!.isShowing) {
                /*imageViewProgress?.let {
                    Glide.with(this)
                        .asGif()
                        .load(R.drawable.mytatva_loader)
                        .into(it)
                }*/
                progressDialog!!.show()
            }
        } else {
            if (progressDialog!!.isShowing)
                progressDialog!!.dismiss()
        }
    }

    protected fun shouldGoBack(): Boolean {
        return true
    }

    override fun onBackPressed() {
        hideKeyboard()

        try {
            val currentFragment = getCurrentFragment<BaseFragment<*>>()
            if (currentFragment == null)
                super.onBackPressed()
            else if (currentFragment.onBackActionPerform() && shouldGoBack())
                super.onBackPressed()
        } catch (e: TypeCastException) {
            super.onBackPressed()
        }

        /*val currentFragment = getCurrentFragment<BaseFragment<*>>()
        if (currentFragment == null)
            super.onBackPressed()
        else if (currentFragment.onBackActionPerform() && shouldGoBack())
            super.onBackPressed()*/
        // pending animation
        // overridePendingTransition(R.anim.pop_enter, R.anim.pop_exit);
    }


    fun hideKeyboard() {
        // Check if no view has focus:
        val view = this.currentFocus
        if (view != null) {
            val inputManager =
                this.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputManager.hideSoftInputFromWindow(
                view.windowToken,
                InputMethodManager.HIDE_NOT_ALWAYS
            )
        }
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == android.R.id.home) {
            onBackPressed()
            return true
        }
        return super.onOptionsItemSelected(item)
    }

    override fun setToolbar(toolbar: Toolbar) {
        setSupportActionBar(toolbar)
    }

    override fun showToolbar(b: Boolean) {
        val supportActionBar = supportActionBar
        if (supportActionBar != null) {
            if (b)
                supportActionBar.show()
            else
                supportActionBar.hide()
        }
    }

    override fun setToolbarTitle(title: CharSequence) {
        if (supportActionBar != null) {
            supportActionBar!!.title = title
        }
    }

    override fun setToolbarTitle(@StringRes title: Int) {

        if (supportActionBar != null) {
            supportActionBar!!.setTitle(title)
            //appToolbarTitle.setText(name);
        }
    }

    override fun showBackButton(b: Boolean) {

        val supportActionBar = supportActionBar
        supportActionBar?.setDisplayHomeAsUpEnabled(b)
    }

    override fun setToolbarColor(@ColorRes color: Int) {
        TODO("Remove Comment")
        /*if (toolbar != null) {
            toolbar.setBackgroundResource(color)
        }*/
    }


    override fun setToolbarElevation(isVisible: Boolean) {

        if (supportActionBar != null) {
            supportActionBar!!.elevation = if (isVisible) 8f else 0f
        }
    }

    fun showKeyboard() {
        val view = this.currentFocus
        if (view != null) {
            val inputManager =
                this.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            inputManager.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT)
        }
    }

    override fun <T : BaseFragment<*>> load(tClass: Class<T>): FragmentActionPerformer<T> {
        return navigationFactory.make(tClass)
    }

    override fun loadActivity(aClass: Class<out BaseActivity>): ActivityBuilder {
        return activityStarter.make(aClass)
    }

    override fun <T : BaseFragment<*>> loadActivity(
        aClass: Class<out BaseActivity>,
        pageTClass: Class<T>,
    ): ActivityBuilder {
        return activityStarter.make(aClass).setPage(pageTClass)
    }

    override fun goBack() {
        onBackPressed()
    }

    override fun pickDate(
        listener: DatePickerDialog.OnDateSetListener,
        minimumDate: Long,
        maximumDate: Long,
    ) {
        val calendar = Calendar.getInstance()
        if (minimumDate != 0L) {
            val calendar1 = Calendar.getInstance()
            calendar1.timeInMillis = minimumDate
            calendar.set(Calendar.YEAR, calendar1.get(Calendar.YEAR))
            calendar.set(Calendar.MONTH, calendar1.get(Calendar.MONTH))
            calendar.set(Calendar.DATE, calendar1.get(Calendar.DATE))
        }
        val datePickerDialog = DatePickerDialog(
            this, R.style.dateTimePickerDialog, listener, calendar.get(
                Calendar.YEAR
            ), calendar.get(Calendar.MONTH), calendar.get(Calendar.DATE)
        )
        if (minimumDate != 0L)
            datePickerDialog.datePicker.minDate = calendar.time.time
        if (maximumDate != 0L)
            datePickerDialog.datePicker.maxDate = maximumDate
        datePickerDialog.show()
    }

    override fun pickTime(
        onTimeSetListener: TimePickerDialog.OnTimeSetListener,
        is24Hour: Boolean,
    ) {
        val calendar = Calendar.getInstance()

        val timePickerDialog = TimePickerDialog(
            this,
            R.style.dateTimePickerDialog, onTimeSetListener,
            calendar.get(Calendar.HOUR_OF_DAY),
            calendar.get(Calendar.MINUTE),
            is24Hour
        )

        timePickerDialog.show()
    }

    override fun showAlertDialog(
        message: String,
        neutralText: String,
        dialogOkListener: DialogOkListener?,
    ) {
        AlertDialog.Builder(this, R.style.dateTimePickerDialog)
            .setMessage(message)
            .setCancelable(false)
            .setPositiveButton(neutralText) { dialog, which ->
                dialogOkListener?.onClick()
                dialog.cancel()
            }.show()
    }

    override fun showAlertDialogWithOptions(
        message: String,
        positiveText: String,
        negativeText: String,
        dialogYesNoListener: DialogYesNoListener?,
    ) {
        AlertDialog.Builder(this, R.style.dateTimePickerDialog)
            .setMessage(message)
            .setCancelable(false)
            .setPositiveButton(positiveText) { dialog, which ->
                dialogYesNoListener?.onYesClick()
                dialog.cancel()
            }
            .setNegativeButton(negativeText) { dialog, which ->
                dialogYesNoListener?.onNoClick()
                dialog.cancel()
            }.show()
    }

    override fun showImageViewerDialog(imageLis: ArrayList<String>, position: Int) {
        ImageViewerDialog()
            .setImageList(imageLis)
            .setCurrentPos(position)
            .show(supportFragmentManager, ImageViewerDialog::class.java.simpleName)
    }

    override fun openPdfViewer(certificate: String) {

        /*loadActivity(IsolatedFullActivity::class.java, PDFViewerFragment::class.java)
            .addBundle(Bundle().apply {
                putString(Common.BundleKey.URL, certificate)
            }).start()*/

        try {
            val intent = Intent(Intent.ACTION_VIEW)
            intent.setDataAndType(Uri.parse(certificate), "application/pdf")
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            //user does not have a pdf viewer installed
            showErrorMessage("No apps found to open this file")
            /*navigator.loadActivity(IsolatedActivity::class.java, PdfViewerFragment::class.java)
                .addBundle(Bundle().apply {
                    putString(Common.BundleKey.DOC_URL, certificate)
                }).start()*/
        }
    }

    fun showSkipCoachMarkMessage() {
        showAlertDialog(getString(R.string.alert_skip_coachmark))
    }

    interface DialogOkListener {
        fun onClick()
    }

    interface DialogYesNoListener {
        fun onYesClick()
        fun onNoClick()
    }

    fun isFeatureAllowedAsPerPlan(
        featureKey: String,
        subFeatureKey: String = "",
        needToShowDialog: Boolean = true,
        okCallback: (() -> Unit)? = null,
    ): Boolean {

        //uncomment below line to by pass plan condition : return true
        //return true

        val featuresList = arrayListOf<FeatureRes>()
        session.user?.patient_plans?.forEachIndexed { index, patientPlanData ->
            patientPlanData.features_res?.let { featuresList.addAll(it) }
        }

        if (featureKey == PlanFeatures.activity_logs) {

            // return true to bypass the activity_logs feature condition
            // this bypass change done as per BCP adhoc tasks changes
            // https://digicare123.atlassian.net/browse/MTP-1666
            return true

            // for activity_logs match sub feature key
            /*if (featuresList.any { it.feature_keys == featureKey }) {
                val activityLogFeaturesList = featuresList.filter { it.feature_keys == featureKey }
                activityLogFeaturesList.forEach { featureRes ->
                    if (featureRes.sub_features_keys?.contains(subFeatureKey, true) == true) {
                        return true
                    }
                }
            }*/

        } else if (featureKey == PlanFeatures.reading_logs) {

            // return true to bypass the reading_logs feature condition
            // this bypass change done as per BCP adhoc tasks changes
            // https://digicare123.atlassian.net/browse/MTP-1666
            return true

            // for reading_logs match sub feature key
            /*if (featuresList.any { it.feature_keys == featureKey }) {
                val readingLogFeaturesList = featuresList.filter { it.feature_keys == featureKey }
                readingLogFeaturesList.forEach { featureRes ->
                    if (featureRes.sub_features_keys?.contains(subFeatureKey, true) == true) {
                        return true
                    }
                }
            }*/

        } else if (featureKey == PlanFeatures.book_appointments && subFeatureKey.isNotBlank()) {
            // for book_appointments match sub feature key only, if it is not blank
            if (featuresList.any { it.feature_keys == featureKey }) {
                val bookAppointmentFeaturesList =
                    featuresList.filter { it.feature_keys == featureKey }
                bookAppointmentFeaturesList.forEach { featureRes ->
                    if (featureRes.sub_features_keys?.contains(subFeatureKey, true) == true) {
                        return true
                    }
                }
            }

        } else if (featuresList.any { it.feature_keys == featureKey }) {
            return true
        }

        // show feature not available dialog and return false
        if (needToShowDialog) {
            showFeatureNotAllowedDialog(okCallback)
        }

        return false
    }

    fun showFeatureNotAllowedDialog(okCallback: (() -> Unit)?) {
        showAlertDialog("Please subscribe to continue using this feature\n" +
                "Follow: More > MyTatva Plans for more details.",
            dialogOkListener = object : DialogOkListener {
                override fun onClick() {
                    okCallback?.invoke()
                }
            })
    }

    enum class AndroidPermissions(val permissionText: String) {
        Camera("Camera"),
        Bluetooth("Bluetooth (Nearby devices)"),
        Location("Location")
    }

    fun showOpenPermissionSettingDialog(
        arrayList: ArrayList<AndroidPermissions> = ArrayList(),
        onCancelCallback: (() -> Unit)? = null,
        onSettingCallback: (() -> Unit)? = null
    ) {
        val sb = StringBuilder()
        sb.append("Please allow required permissions from settings")
        arrayList.forEachIndexed { index, androidPermissions ->
            sb.append("\n").append((index + 1).toString()).append(". ")
                .append(androidPermissions.permissionText)
        }
        showAlertDialogWithOptions(sb.toString(),
            positiveText = "Settings",
            negativeText = "Cancel",
            object : DialogYesNoListener {
                override fun onYesClick() {
                    onSettingCallback?.invoke()
                    openAppSystemSettings()
                }

                override fun onNoClick() {
                    onCancelCallback?.invoke()
                }
            })
    }

    fun showOpenLocationPermissionSettingsOrAskManually(bundle: Bundle? = null) {
        showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location),
            onCancelCallback = {
                EnterLocationPinCodeBottomSheetDialog().apply {
                    arguments = bundle
                }.show(
                    supportFragmentManager,
                    EnterLocationPinCodeBottomSheetDialog::class.java.simpleName
                )
            })
    }


    fun showAccountSetupDialog() {
        //hidden this dialog from app side
        /*session.user?.let { user ->
            if (user.profile_completion == "N") {
                supportFragmentManager.let {
                    AccountSetupProfileDialog(
                        onCreateProfile = {
                            analytics.logEvent(analytics.USER_CLICKED_PROFILE_COMPLETION)
                            if (user.profile_completion_status?.location == "N") {
                                loadActivity(AuthActivity::class.java,
                                    SelectYourLocationFragment::class.java)
                                    .start()
                            } else if (user.profile_completion_status?.drug_prescription == "N") {
                                loadActivity(AuthActivity::class.java,
                                    SetupDrugsFragment::class.java)
                                    .start()
                            } else if (user.profile_completion_status?.goal_reading == "N") {
                                loadActivity(AuthActivity::class.java,
                                    SetupGoalsReadingsFragment::class.java)
                                    .start()
                            }
                        }).show(it, AccountSetupProfileDialog::class.java.simpleName)
                }
            }
        }*/
    }

    protected val biometricManager by lazy {
        BiometricManager.from(this)
    }

    fun isBiometricSupportedAndAdded(): Boolean {
        when (biometricManager.canAuthenticate(BiometricManager.Authenticators.BIOMETRIC_WEAK)) {
            BiometricManager.BIOMETRIC_SUCCESS -> {
                /*preferenceStorage.isLocked = !preferenceStorage.isLocked*/
                Log.d("MY_APP_TAG", "App can authenticate using biometrics.")
                return true
            }

            BiometricManager.BIOMETRIC_ERROR_NO_HARDWARE -> {
                /*switchShowFingerLock.isChecked = false*/
                Log.d("TAG", "MY_APP_TAG No biometric features available on this device.")
                return false
            }

            BiometricManager.BIOMETRIC_ERROR_HW_UNAVAILABLE -> {
                /*switchShowFingerLock.isChecked = false*/
                Log.d("TAG", "MY_APP_TAG Biometric features are currently unavailable.")
                return false
            }

            BiometricManager.BIOMETRIC_ERROR_NONE_ENROLLED -> {
                /*switchShowFingerLock.isChecked = false*/
                Log.d(
                    "TAG",
                    "The user hasn't associated any biometric credentials with their account."
                )
                return false
            }

            else -> {
                return false
            }
        }
    }

    fun showBiometricPrompt(callback: (isSuccess: Boolean, message: String) -> Unit) {
        val promptInfo = BiometricPrompt.PromptInfo.Builder()
            .setTitle("Validate Fingerprint")
            .setNegativeButtonText("Cancel")
            .setConfirmationRequired(false)
            .setAllowedAuthenticators(BiometricManager.Authenticators.BIOMETRIC_STRONG)
            .build()

        BiometricPrompt(
            this,
            ContextCompat.getMainExecutor(this),
            object : BiometricPrompt.AuthenticationCallback() {
                override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
                    // No need to handle this case because we have passcode option available.
                    if (errorCode == 13) {
                        callback.invoke(false, "")
                        /*finish()*/
                    } else {
                        callback.invoke(false, "error : $errString")
                    }
                    /*showToast("ERROR $errorCode :: $errString")*/
                }

                override fun onAuthenticationFailed() {
                    /*showToast("FAILED")*/
                    // No need to handle this case because we have passcode option available.
                }

                override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                    /*showToast("SUCCESS")*/
                    callback.invoke(true, "")
                }
            }).authenticate(promptInfo)
    }

    /**
     * Web engage notification callback
     */
    override fun onInAppNotificationClicked(
        context: Context?,
        inAppNotificationData: InAppNotificationData?,
        actionId: String?,
    ): Boolean {

        Log.d("actionId", ":: $actionId")
        Log.d("inAppNotiData", ":: ${inAppNotificationData.toString()}")

        val gson = Gson()
        val inAppNotificationModel = gson.fromJson(
            inAppNotificationData?.data.toString(),
            InAppNotificationModel::class.java
        )

        val action = inAppNotificationModel.actions?.firstOrNull { it.actionEId == actionId }

        val deepLink = action?.actionLink?.let { FirebaseLink.getDeepLinkFromWEActionLink(it) }

        if (deepLink != null) {
            showLoader()
            getDeepLink(Uri.parse(deepLink)) {

            }
        }

        /*val deepLinkAction = inAppNotificationModel.actions?.firstOrNull {
            it.actionText == action?.actionText && it.type == "DEEP_LINK"
        }

        deepLinkAction?.actionLink?.let {
            getDeepLink(Uri.parse(it)) {

            }
        }*/

        //Return true if the click was handled by your app, or false to let WebEngage SDK handle it.
        return true
    }


    fun onInAppNotificationClickedNew(
        context: Context,
        inAppNotificationData: InAppNotificationData, s: String,
    ): Boolean {
        //log(context, Constants.IN_APP_CLICKED, "");
        val jsonObject: JSONObject = inAppNotificationData.data;
        try {
            val actions: JSONArray? =
                if (jsonObject.isNull("actions")) null else jsonObject.getJSONArray("actions")
            if (actions != null) {
                val actionLink: String? = null

                for (i in 0 until actions.length()) {
                    val action: JSONObject = actions.getJSONObject(i);
                    val actionEId: String? =
                        if (action.isNull("actionEId")) null else action.optString("actionEId");
                    if (actionEId != null && actionEId == s) {
                        val actionLink =
                            if (action.isNull("actionLink")) null else action.getString("actionLink");
                        break
                    }
                }

                //MyLogger.d("action link: " + actionLink);
            }
        } catch (e: JSONException) {
        } catch (t: Throwable) {
        }
        return false//Return true if the click was handled by your app, or false to let WebEngage SDK handle it.    }

    }

    override fun onInAppNotificationDismissed(
        context: Context?,
        inAppNotificationData: InAppNotificationData?,
    ) {

    }

    override fun onInAppNotificationPrepared(
        context: Context?,
        inAppNotificationData: InAppNotificationData?,
    ): InAppNotificationData {
        return inAppNotificationData!!
    }

    override fun onInAppNotificationShown(
        context: Context?,
        inAppNotificationData: InAppNotificationData?,
    ) {

    }

    /**
     * *****************************
     */
    protected fun getDeepLink(uri: Uri, callbackToDefaultFlow: () -> Unit) {
        FirebaseDynamicLinks.getInstance()
            .getDynamicLink(uri)
            /*.getDynamicLink(intent)*/
            .addOnSuccessListener(this) { pendingDynamicLinkData: PendingDynamicLinkData? ->
                // Get deep link from result (may be null if no link is found)
                var deepLink: Uri? = null
                if (pendingDynamicLinkData != null) {

                    deepLink = pendingDynamicLinkData.link

                    if (deepLink?.queryParameterNames?.contains(FirebaseLink.Params.OPERATION) == true) {

                        when (deepLink.getQueryParameter(FirebaseLink.Params.OPERATION)) {

                            FirebaseLink.Operation.SIGNUP_LINK_DOCTOR -> {
                                FirebaseLink.handleSignUpLinkDoctorOperationDeepLinkWithResult(
                                    deepLink
                                )
                                callbackToDefaultFlow.invoke()
                                /*if (deepLink.queryParameterNames?.contains(FirebaseLink.Params.ACCESS_CODE) == true
                                    && deepLink.queryParameterNames?.contains(FirebaseLink.Params.DOCTOR_ACCESS_CODE) == true
                                ) {
                                    FirebaseLink.Values.accessCode =
                                        deepLink.getQueryParameter(FirebaseLink.Params.ACCESS_CODE)
                                    FirebaseLink.Values.doctorAccessCode =
                                        deepLink.getQueryParameter(FirebaseLink.Params.DOCTOR_ACCESS_CODE)

                                    callbackToDefaultFlow.invoke()
                                } else {
                                    callbackToDefaultFlow.invoke()
                                }*/
                            }

                            FirebaseLink.Operation.CONTENT -> {
                                val contentMasterId =
                                    deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_MASTER_ID)

                                if (contentMasterId?.isNotBlank() == true) {
                                    loadActivity(HomeActivity::class.java).start()
                                    loadActivity(
                                        IsolatedFullActivity::class.java,
                                        EngageFeedDetailsFragment::class.java
                                    )
                                        .addBundle(Bundle().apply {
                                            putString(
                                                Common.BundleKey.CONTENT_ID,
                                                contentMasterId
                                            )
                                        }).start()
                                    finish()
                                } else {
                                    callbackToDefaultFlow.invoke()
                                }
                            }

                            FirebaseLink.Operation.SCREEN_NAV -> {
                                handleScreenNavigation(deepLink)
                            }

                            else -> {
                                callbackToDefaultFlow.invoke()
                            }
                        }
                    } else {
                        callbackToDefaultFlow.invoke()
                    }

                } else {
                    callbackToDefaultFlow.invoke()
                }

            }
            .addOnFailureListener(this) { e: Exception? ->
                Log.w("addOnFailureListener", "getDynamicLink:onFailure")
                callbackToDefaultFlow.invoke()
            }
    }

    fun handleScreenNavigation(deepLink: Uri/*, callbackToDefaultFlow: () -> Unit*/) {
        val screenName = deepLink.getQueryParameter(FirebaseLink.Params.SCREEN_NAME)

        when (screenName) {
            /*AnalyticsScreenNames.Home -> {
                if (this !is HomeActivity) {
                    loadActivity(HomeActivity::class.java).start()
                }
            }*/
            AnalyticsScreenNames.Home,
            AnalyticsScreenNames.LogGoal,
            AnalyticsScreenNames.CarePlan,
            AnalyticsScreenNames.DiscoverEngage,
            AnalyticsScreenNames.ExerciseMyRoutine,/*ExercisePlan*/
            AnalyticsScreenNames.ExerciseMore,
            AnalyticsScreenNames.FaqQuery,
            -> {
                /*loadActivity(HomeActivity::class.java)
                    .addBundle(bundleOf(
                        Pair(Common.BundleKey.SCREEN_NAME, screenName)
                    )).byFinishingCurrent().start()*/

                if (this is HomeActivity) {
                    (this as HomeActivity).handleHomeNavigation(deepLink)
                } else {
                    loadActivity(HomeActivity::class.java)
                        .addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.DEEP_LINK, deepLink.toString())
                            )
                        ).start()
                }
            }

            AnalyticsScreenNames.ContentDetailPhotoGallery,
            AnalyticsScreenNames.ContentDetailNormalVideo,
            AnalyticsScreenNames.ContentDetailKolVideo,
            AnalyticsScreenNames.ContentDetailBlog,
            AnalyticsScreenNames.ContentDetailWebinar,
            -> {
                val contentMasterId =
                    deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_MASTER_ID)
                loadActivity(
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

                loadActivity(
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

                loadActivity(
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
                    loadActivity(
                        IsolatedFullActivity::class.java,
                        FoodDiaryMainFragment::class.java
                    ).start()
                }
            }

            AnalyticsScreenNames.FoodDiaryMonth -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.activity_logs, Goals.Diet.goalKey)) {
                    loadActivity(
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
                    loadActivity(
                        IsolatedFullActivity::class.java,
                        FoodDayInsightFragment::class.java
                    ).start()
                }
            }

            AnalyticsScreenNames.LogFood -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    LogFoodFragment::class.java
                ).start()
            }

            AnalyticsScreenNames.HelpSupportFaq -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    HelpSupportFAQFragment::class.java
                ).start()
            }

            AnalyticsScreenNames.NotificationList -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    NotificationsFragment::class.java
                ).start()
            }

            AnalyticsScreenNames.HistoryIncident -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    HistoryFragment::class.java
                ).addBundle(Bundle().apply {
                    putBoolean(Common.BundleKey.IS_SHOW_INCIDENT, true)
                }).start()
            }

            AnalyticsScreenNames.HistoryRecord -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_records_history_records)) {
                    loadActivity(IsolatedFullActivity::class.java, HistoryFragment::class.java)
                        .addBundle(Bundle().apply {
                            putBoolean(Common.BundleKey.IS_SHOW_RECORD, true)
                        }).start()
                }
            }

            AnalyticsScreenNames.HistoryTest -> {
                if (AppFlagHandler.isToHideDiagnosticTest(firebaseConfigUtil).not()) {
                    loadActivity(IsolatedFullActivity::class.java, HistoryFragment::class.java)
                        .addBundle(Bundle().apply {
                            putBoolean(Common.BundleKey.IS_SHOW_TEST, true)
                        }).start()
                }
            }

            AnalyticsScreenNames.HistoryPayment -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.history_payments)) {
                    //default first tab is payment tab in history
                    loadActivity(IsolatedFullActivity::class.java, HistoryFragment::class.java)
                        .start()
                }
            }

            AnalyticsScreenNames.UploadRecord -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_records_history_records)) {
                    loadActivity(IsolatedFullActivity::class.java, UploadRecordFragment::class.java)
                        .start()
                }
            }

            AnalyticsScreenNames.AddIncident -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.incident_records_history)) {
                    loadActivity(TransparentActivity::class.java, AddIncidentFragment::class.java)
                        .start()
                }
            }

            AnalyticsScreenNames.MyProfile -> {
                loadActivity(IsolatedFullActivity::class.java, MyProfileFragment::class.java)
                    .start()
            }

            AnalyticsScreenNames.EditProfile -> {
                loadActivity(IsolatedFullActivity::class.java, EditProfileFragment::class.java)
                    .start()
            }

            AnalyticsScreenNames.MyDevices -> {
                loadActivity(IsolatedFullActivity::class.java, MyDevicesFragment::class.java)
                    .start()
            }

            AnalyticsScreenNames.SetUpDrugs -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_medication)) {
                    loadActivity(IsolatedFullActivity::class.java, SetupDrugsFragment::class.java)
                        .start()
                }
            }

            AnalyticsScreenNames.SetUpGoalsReadings -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    SetupGoalsReadingsFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.SelectLocation -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    SelectYourLocationFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.CreateProfileFlow -> {
                // open auth flow to complete profile
                loadActivity(
                    AuthActivity::class.java,
                    SelectYourLocationFragment::class.java
                )
                    .start()
            }

            AnalyticsScreenNames.BookmarkList -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.bookmarks)) {
                    loadActivity(IsolatedFullActivity::class.java, BookmarksFragment::class.java)
                        .start()
                }
            }

            AnalyticsScreenNames.CatSurvey -> {
                if (this is HomeActivity) {
                    (this as HomeActivity).openHomeFragmentAndNavigateToCatSurvey()
                } else {
                    loadActivity(HomeActivity::class.java)
                        .addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.DEEP_LINK, deepLink.toString())
                            )
                        ).start()
                }
            }

            AnalyticsScreenNames.RequestCallBack -> {
                if (this is HomeActivity) {
                    (this as HomeActivity).openCarePlanAndShowRequestCallbackDialog()
                } else {
                    loadActivity(HomeActivity::class.java)
                        .addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.DEEP_LINK, deepLink.toString())
                            )
                        ).start()
                }
            }

            AnalyticsScreenNames.QuestionDetails -> {
                val contentMasterId =
                    deepLink.getQueryParameter(FirebaseLink.Params.CONTENT_MASTER_ID)
                loadActivity(IsolatedFullActivity::class.java, QuestionDetailsFragment::class.java)
                    .addBundle(Bundle().apply {
                        putString(Common.BundleKey.CONTENT_ID, contentMasterId)
                    }).start()
            }

            AnalyticsScreenNames.BookAppointment -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                    val selection = deepLink.getQueryParameter(FirebaseLink.Params.SELECTION)
                    loadActivity(
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
                loadActivity(IsolatedFullActivity::class.java, AllAppointmentsFragment::class.java)
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.SELECTION, selection)
                        )
                    ).start()
            }

            AnalyticsScreenNames.MyTatvaPlans -> {
                loadActivity(
                    IsolatedFullActivity::class.java,
                    /*PaymentPlanServiceMainFragment*/PaymentCarePlanListingFragment::class.java
                ).start()
            }

            AnalyticsScreenNames.LabtestDetails -> {
                val labTestId = deepLink.getQueryParameter(FirebaseLink.Params.LAB_TEST_ID)
                loadActivity(IsolatedFullActivity::class.java, LabTestDetailsFragment::class.java)
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.LAB_TEST_ID, labTestId)
                        )
                    ).start()
            }

            AnalyticsScreenNames.BcpDetails -> {
                val planMasterId = deepLink.getQueryParameter(FirebaseLink.Params.PLAN_MASTER_ID)
                //call API to check is plan purchased, and handle navigation
                planMasterId?.let { checkIsPlanPurchased(it) }
            }

            else -> {
                //callbackToDefaultFlow.invoke()
            }
        }
    }

    /**
     * *****************************
     */


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    fun updateReadingsGoals(isCalledOnPermissionApproved: Boolean = false) {

        if (isCalledOnPermissionApproved) {
            //when this API is called when user approved permission
            //trigger GOOGLE_FIT_OPTIN event
            analytics.logEvent(
                analytics.GOOGLE_FIT_OPTIN,
                screenName = AnalyticsScreenNames.MyDeviceDetail
            )
        }

        val cal = Calendar.getInstance() //

        // for calories time, it will from always synced from last sync date
        // if never sync before then existing logic
        val calForCaloriesConsumed = Calendar.getInstance()

        // take data from the previous updated_at or from past 365 days
        if (session.user?.sync_at.isNullOrBlank().not()) {
            try {
                cal.timeInMillis = DateTimeFormatter.date(
                    session.user!!.sync_at,
                    DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                ).date!!.time

                // below code to sync at least past 7 days of record if last sync date diff is < 7
                val calCurrent = Calendar.getInstance()
                Log.d("DAYSDIFF", ":: ${DateTimeFormatter.getDiffInDays(cal, calCurrent)}")
                if (DateTimeFormatter.getDiffInDays(cal, calCurrent) < 7) {
                    //if diff is less than 7 days then fetch record of past 7 days
                    cal.timeInMillis = Calendar.getInstance().timeInMillis
                    cal.add(Calendar.DAY_OF_YEAR, -7)
                }
                Log.d("DAYSDIFFFETCH", ":: ${DateTimeFormatter.getDiffInDays(cal, calCurrent)}")
                //================================================================================

            } catch (e: Exception) {
                cal.add(Calendar.DAY_OF_YEAR, -30)
            }
        } else {
            cal.add(Calendar.DAY_OF_YEAR, -30)
        }

        googleFit.readGoals(cal) { goalsList ->

            Log.d("FINAL", "GOAL")

            googleFit.readReadings(cal, calForCaloriesConsumed) { readingsList ->

                analytics.logEvent(analytics.READING_CAPTURED_GOOGLE_FIT)

                // goals update in server with sub data list
                for (i in 0 until goalsList.size step 20) {
                    Log.d("GOAL-READING", "updateReadingsGoals: $i :: ${goalsList.size}")

                    val subList = arrayListOf<ApiRequestSubData>()
                    subList.addAll(goalsList.take(20))

                    //remove from main list which are added to sublist
                    for (j in 0 until subList.size) {
                        goalsList.removeAt(0)
                    }

                    Log.d("GOAL-READING", "subList goal Size: ${subList.size}")

                    // update sublist in server
                    val apiRequest = ApiRequest()
                    apiRequest.goal_data = subList
                    goalReadingViewModel.updateReadingsGoals(apiRequest)

                    Log.d("updateReadingsGoals", " :: SENT GOALS")
                }

                // readings update in server with sub data list
                for (i in 0 until readingsList.size step 20) {
                    Log.d("GOAL-READING", "updateReadingsGoals: $i :: ${readingsList.size}")

                    val subList = arrayListOf<ApiRequestSubData>()
                    subList.addAll(readingsList.take(20))

                    //remove from main list which are added to sublist
                    for (j in 0 until subList.size) {
                        readingsList.removeAt(0)
                    }

                    Log.d("GOAL-READING", "subList reading Size: ${subList.size}")

                    // update sublist in server
                    val apiRequest = ApiRequest()
                    apiRequest.reading_data = subList
                    goalReadingViewModel.updateReadingsGoals(apiRequest)

                    Log.d("updateReadingsGoals", " :: SENT READINGS")
                }

            }
        }


        /*val uploadServiceIntent = Intent(this, SyncGoogleFitService::class.java)
        uploadServiceIntent.putExtra(Common.BundleKey.CALENDAR, cal)
        ContextCompat.startForegroundService(this, uploadServiceIntent)*/
    }

    fun checkIsPlanPurchased(planMasterId: String) {
        val apiRequest = ApiRequest()
        apiRequest.plan_master_id = planMasterId
        patientPlansViewModel.checkIsPlanPurchased(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.updateReadingsGoalsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                Log.d("updateReadingsGoals", " :: UPDATE SUCCESS")
            },
            onError = { throwable ->
                hideLoader()
                Log.d("updateReadingsGoals", " :: UPDATE ERROR")
                false
            })

        patientPlansViewModel.checkIsPlanPurchasedLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { bcpPlanData ->
                    // handle plan details page deeplink navigation
                    if (bcpPlanData.plan_type == Common.MyTatvaPlanType.INDIVIDUAL
                        && bcpPlanData.patient_plan_rel_id.isNullOrBlank().not()
                    ) {
                        loadActivity(
                            IsolatedFullActivity::class.java,
                            BcpPurchasedDetailsFragment::class.java
                        ).addBundle(
                            bundleOf(
                                Pair(
                                    Common.BundleKey.PATIENT_PLAN_REL_ID,
                                    bcpPlanData.patient_plan_rel_id
                                ),
                            )
                        ).start()
                    } else {
                        loadActivity(
                            IsolatedFullActivity::class.java,
                            PaymentPlanDetailsV1Fragment::class.java
                        ).addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.PLAN_ID, bcpPlanData.plan_master_id),
                                Pair(Common.BundleKey.PLAN_TYPE, bcpPlanData.plan_type),
                                Pair(
                                    Common.BundleKey.PATIENT_PLAN_REL_ID,
                                    bcpPlanData.patient_plan_rel_id
                                ),
                                Pair(Common.BundleKey.ENABLE_RENT_BUY, bcpPlanData.enable_rent_buy),
                            )
                        ).start()
                    }

                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}