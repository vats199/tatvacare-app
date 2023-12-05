package com.mytatva.patient.di

import android.annotation.SuppressLint
import android.app.Application
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import androidx.lifecycle.ProcessLifecycleOwner
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.facebook.react.PackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactNativeHost
import com.facebook.react.ReactPackage
import com.facebook.react.defaults.DefaultReactNativeHost
import com.facebook.soloader.SoLoader
import com.freshchat.consumer.sdk.Event
import com.freshchat.consumer.sdk.Freshchat
import com.freshchat.consumer.sdk.FreshchatNotificationConfig
import com.google.firebase.crashlytics.FirebaseCrashlytics
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.core.AppPreferences
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.repository.AuthRepository
import com.mytatva.patient.di.module.AndroidBridgeReactPackage
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.home.fragment.AppUnderMaintenenceFragment
import com.mytatva.patient.ui.manager.ActivityStarter
import com.mytatva.patient.utils.DeviceUtils
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.lifetron.LSBleManager
import com.webengage.sdk.android.PushChannelConfiguration
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks
import com.webengage.sdk.android.WebEngageConfig
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.reflect.InvocationTargetException
import javax.inject.Inject


class MyTatvaApp : Application(), ReactApplication, LifecycleObserver {

    companion object {
        const val TAG = "MyTatvaApp"

        val IS_RAZORPAY_LIVE = URLFactory.ENVIRONMENT == URLFactory.Env.PRODUCTION
        val IS_TO_USE_FIREBASE_FLAGS = true

        val YOUR_WEBENGAGE_LICENSE_CODE =
            if (URLFactory.ENVIRONMENT == URLFactory.Env.PRODUCTION)
                "311c4c4b"
            else if (URLFactory.ENVIRONMENT == URLFactory.Env.UAT)
                "82617b48"
            else
                "~2024baca"

        val IS_WEBENGAGE_DEBUG_MODE = BuildConfig.DEBUG
        const val FILE_PROVIDER_AUTHORITY = BuildConfig.APPLICATION_ID + ".provider"
        var mContext: Context? = null

        const val IS_SPIRO_PROD = true

        fun getProcessName(): String? {
            return if (Build.VERSION.SDK_INT >= 28) Application.getProcessName() else try {
                @SuppressLint("PrivateApi") val activityThread =
                    Class.forName("android.app.ActivityThread")

                // Before API 18, the method was incorrectly named "currentPackageName", but it still returned the process name
                // See https://github.com/aosp-mirror/platform_frameworks_base/commit/b57a50bd16ce25db441da5c1b63d48721bb90687
                val methodName =
                    if (Build.VERSION.SDK_INT >= 18) "currentProcessName" else "currentP" +
                            "ackageName"
                val getProcessName = activityThread.getDeclaredMethod(methodName)
                getProcessName.invoke(null) as String

            } catch (e: ClassNotFoundException) {
                throw java.lang.RuntimeException(e)
            } catch (e: NoSuchMethodException) {
                throw java.lang.RuntimeException(e)
            } catch (e: IllegalAccessException) {
                throw java.lang.RuntimeException(e)
            } catch (e: InvocationTargetException) {
                throw java.lang.RuntimeException(e)
            }

            // Using the same technique as Application.getProcessName() for older devices
            // Using reflection since ActivityThread is an internal API
        }
    }

    @Inject
    lateinit var appPreferences: AppPreferences

    @Inject
    lateinit var session: Session

    @Inject
    lateinit var analytics: AnalyticsClient

    @Inject
    lateinit var lsBleManager: LSBleManager

    override fun onCreate() {
        super.onCreate()
        SoLoader.init(this, /* native exopackage */ false)

        //Security.insertProviderAt(Conscrypt.newProvider(), 1)
        initWebEngage()
        initFreshdesk()
        mContext = applicationContext
        Injector.INSTANCE.initAppComponent(this, "6939CB32CA9C1")
        Injector.INSTANCE.applicationComponent.inject(this)

        //analytics.logEvent(analytics.NEW_APP_LAUNCHED)

        ProcessLifecycleOwner.get().lifecycle.addObserver(this)

        //Enable crash reporting for release build only
        FirebaseCrashlytics.getInstance().setCrashlyticsCollectionEnabled(BuildConfig.DEBUG.not())

        //checkTLS()
        lsBleManager.initSDK()
    }

    /*private fun checkTLS(){
        val sslParameters: SSLParameters?
        try {
            sslParameters = SSLContext.getDefault().defaultSSLParameters
            Log.d(TAG, "checkTLS: ${sslParameters?.protocols}")
            sslParameters?.protocols?.forEach {
                Log.d(TAG, "checkTLS: $it")
            }
            // SSLv3, TLSv1, TLSv1.1, TLSv1.2 etc.
        } catch (e: NoSuchAlgorithmException) {
            // ...
        }
    }*/

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    fun onMoveToForeground() { // app moved to foreground
        Log.d(TAG, "Lifecycle ON_START: ${getProcessName()}")
        analytics.logEvent(analytics.NEW_APP_LAUNCHED)


        //if (appPreferences.getBoolean(Common.IS_LOGIN)) {
        // need to trigger this always, for login or not login, as per MTP-911
        analytics.logEvent(analytics.USER_SESSION_START)
        //}

        callUserProfile()
        callUpdateDeviceInfo()

        //freshchat event receiver
        val userActionsIntentFilter: IntentFilter = IntentFilter(Freshchat.FRESHCHAT_EVENTS)
        LocalBroadcastManager.getInstance(applicationContext)
            .registerReceiver(freshChatEventReceiver, userActionsIntentFilter)

        //register receiver to store restore id
        val intentFilter: IntentFilter =
            IntentFilter(Freshchat.FRESHCHAT_USER_RESTORE_ID_GENERATED)
        LocalBroadcastManager.getInstance(applicationContext)
            .registerReceiver(freshChatGenerateUserRestoreIdReceiver, intentFilter)
    }

    private fun callUserProfile() {
        // check is user login, call user profile API when app comes to foreground
        if (appPreferences.getBoolean(Common.IS_LOGIN)) {
            scope.launch {
                val response = authRepository.getPatientDetails(ApiRequest())
                response.responseBody?.data?.let { user ->
                    user.token?.let { session.userSession = it }
                    user.patient_id?.let { session.userId = it }
                    session.user = user
                }
            }
        }
    }

    private fun callUpdateDeviceInfo() {
        scope.launch {
            val apiRequest = ApiRequest().apply {
                if (appPreferences.getBoolean(Common.IS_LOGIN)) {
                    device_token = session.deviceId
                }
                device_type = Session.DEVICE_TYPE
                uuid = session.deviceFID
                os_version = DeviceUtils.deviceOSVersion
                device_name = DeviceUtils.deviceName
                model_name = DeviceUtils.deviceName
                app_version = BuildConfig.VERSION_NAME
                build_version_number = BuildConfig.VERSION_CODE.toString()
                ip = DeviceUtils.getIPAddress()
            }
            val response = authRepository.updateDeviceInfo(apiRequest)
            if (appPreferences.isAppUnderMaintenance()) {
                navigateToAppUnderMaintenance(
                    appPreferences.updateDeviceInfoResData?.title ?: "",
                    appPreferences.updateDeviceInfoResData?.message ?: ""
                )
            }
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    fun onMoveToBackground() { // app moved to background
        Log.d(TAG, "Lifecycle ON_STOP: ${getProcessName()}")
        if (appPreferences.getBoolean(Common.IS_LOGIN)) {
            analytics.logEvent(analytics.USER_SESSION_END)
        }

        LocalBroadcastManager.getInstance(applicationContext)
            .unregisterReceiver(freshChatEventReceiver)

        LocalBroadcastManager.getInstance(applicationContext)
            .unregisterReceiver(freshChatGenerateUserRestoreIdReceiver)
    }

    /*@OnLifecycleEvent(Lifecycle.Event.ON_DESTROY)
    fun onMoveToDestroy() { // app moved to background
        Log.e(TAG, "Lifecycle ON_DESTROY: ${getProcessName()}")
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_ANY)
    fun onMoveToON_ANY() { // app moved to background
        Log.e(TAG, "Lifecycle ON_ANY: ${getProcessName()} ${analytics.GOAL_COMPLETED}", )
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    fun onMoveToON_PAUSE() { // app moved to background
        Log.e(TAG, "Lifecycle ON_PAUSE: ${getProcessName()}", )
    }*/

    override fun onTerminate() {
        //Log.e("TERMINATE", "onTerminate: ")
        super.onTerminate()
    }

    private fun initWebEngage() {
        val pushChannelConfiguration = PushChannelConfiguration.Builder()
            .setNotificationChannelName(Common.CHANNEL_NAME)
            .setNotificationChannelDescription(Common.CHANNEL_DESC)
            .setNotificationChannelImportance(NotificationManagerCompat.IMPORTANCE_HIGH)
            //.setNotificationChannelLockScreenVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            //.setNotificationChannelLightColor(Color.parseColor("#ff0000"))
            //.setNotificationChannelShowBadge(true)
            //.setNotificationChannelVibration(true)
            //.setNotificationChannelGroup()
            .build()

        val webEngageConfig: WebEngageConfig = WebEngageConfig.Builder()
            .setWebEngageKey(YOUR_WEBENGAGE_LICENSE_CODE)
            .setDebugMode(IS_WEBENGAGE_DEBUG_MODE) // only in development mode
            .setPushSmallIcon(R.drawable.ic_notification_small)
            .setPushLargeIcon(R.drawable.ic_app_icon_big)
            .setPushAccentColor(Common.Colors.COLOR_PRIMARY)
            .setDefaultPushChannelConfiguration(pushChannelConfiguration)
            .build()
        registerActivityLifecycleCallbacks(
            WebEngageActivityLifeCycleCallbacks(
                this,
                webEngageConfig
            )
        )
    }

    @Inject
    lateinit var authRepository: AuthRepository
    private var scope = CoroutineScope(Dispatchers.IO)

    private val freshChatEventReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.extras == null) {
                return
            }
            val event: Event? = Freshchat.getEventFromBundle(intent.extras!!)
            if (event != null) {
                Log.d("FreshChatRcv", "Name : " + event.eventName.getName())
                Log.d("FreshChatRcv", "Event Properties: " + event.properties)
                if (Event.EventName.FCEventMessageSent == event.eventName) {
                    Log.d(
                        "FreshChatRcv",
                        "Event Properties: FCPropertyConversationID ::" + event.properties[Event.Property.FCPropertyConversationID]
                    )
                }
                val restoreId = Freshchat.getInstance(applicationContext).user.restoreId
                Log.d("FreshChatRcv", "User restoreId *** : $restoreId")
            }
        }
    }

    private fun callAPIToStoreUserRestoreId(restoreId: String) {
        scope.launch {
            val response = authRepository.linkHealthCoachChat(ApiRequest().apply {
                restore_id = restoreId
            })
            if (response.throwable != null) {
                Log.e(TAG, "profile:: ERROR ${response.throwable.message}")
            }
            if (response.responseBody != null) {
                Log.e(TAG, "profile:: Success restoreId :: $restoreId")
                Log.e(TAG, "profile:: Success ${response.responseBody.message}")
            }
        }
    }

    private val freshChatGenerateUserRestoreIdReceiver: BroadcastReceiver =
        object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                val restoreId = Freshchat.getInstance(applicationContext).user.restoreId
                callAPIToStoreUserRestoreId(restoreId)
                Log.d("FreshChatRcv", "User restoreId : $restoreId")
            }
        }

    private fun initFreshdesk() {
        val notificationConfig: FreshchatNotificationConfig =
            FreshchatNotificationConfig().setNotificationSoundEnabled(true)
                .setSmallIcon(R.drawable.ic_notification_small)
                .setLargeIcon(R.mipmap.ic_launcher)
                //.launchActivityOnFinish(MainActivity::class.java.getName())
                .setPriority(NotificationCompat.PRIORITY_HIGH)
        Freshchat.getInstance(applicationContext)
            .setNotificationConfig(notificationConfig)
    }

    private fun navigateToAppUnderMaintenance(title: String, message: String) {
        /*loadActivity(IsolatedFullActivity::class.java, AppUnderMaintenenceFragment::class.java)
            .addBundle(bundleOf(
                Pair(Common.BundleKey.TITLE, title),
                Pair(Common.BundleKey.DESCRIPTION, message)))
            .byFinishingAll()
            .start()*/
        if (AppUnderMaintenenceFragment.isOpen.not()) {
            val intent = Intent(this, IsolatedFullActivity::class.java)
            intent.putExtra(
                ActivityStarter.ACTIVITY_FIRST_PAGE,
                AppUnderMaintenenceFragment::class.java
            )
            intent.putExtra(Common.BundleKey.TITLE, title)
            intent.putExtra(Common.BundleKey.DESCRIPTION, message)
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK or Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }
    }

    private val mReactNativeHost = object : DefaultReactNativeHost(this) {
        override fun getUseDeveloperSupport(): Boolean {
            return BuildConfig.DEBUG
        }

        override fun getPackages(): kotlin.collections.List<ReactPackage> {
            val packages: ArrayList<ReactPackage> = PackageList(this).packages
            // Packages that cannot be autolinked yet can be added manually here
            packages.add(AndroidBridgeReactPackage())
            return packages
        }

        override fun getJSMainModuleName(): String {
            return "TatvacareApp"
        }

        override fun getBundleAssetName(): String {
            return "index.android.bundle"
        }
    }

    override fun getReactNativeHost(): ReactNativeHost {
        return mReactNativeHost
    }
}