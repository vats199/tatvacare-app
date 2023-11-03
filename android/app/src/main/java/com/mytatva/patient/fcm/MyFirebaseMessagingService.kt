package com.mytatva.patient.fcm

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.RemoteInput
import com.freshchat.consumer.sdk.Freshchat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.google.gson.Gson
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.core.AppPreferences
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.repository.AuthRepository
import com.mytatva.patient.data.webengage.NotificationPayloadData
import com.mytatva.patient.di.Injector
import com.mytatva.patient.di.component.DaggerServiceComponent
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import com.webengage.sdk.android.WebEngage
import com.webengage.sdk.android.actions.render.PushNotificationData
import com.webengage.sdk.android.callbacks.PushNotificationCallbacks
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.*
import javax.inject.Inject


open class MyFirebaseMessagingService : FirebaseMessagingService() {

    private val uniqeId: Int
        get() {
            val time = Date().time
            val tmpStr = time.toString()
            val last4Str = tmpStr.substring(tmpStr.length - 5)
            return Integer.valueOf(last4Str)
        }

    lateinit var notificationMap: MutableMap<String, String>

    @Inject
    lateinit var authRepository: AuthRepository

    @Inject
    lateinit var appPreferences: AppPreferences

    private var scope = CoroutineScope(Dispatchers.IO)

    /*@Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }*/

    override fun onNewToken(p0: String) {
        super.onNewToken(p0)
        WebEngage.get().setRegistrationID(p0)
        Freshchat.getInstance(applicationContext).setPushRegistrationToken(p0)
//        Log.d(TAG, "Refreshed token: " + refreshedToken);
    }

    override fun onCreate() {
        super.onCreate()
        DaggerServiceComponent.builder()
            .applicationComponent(Injector.INSTANCE.applicationComponent)
            .build()
            .inject(this)

        registerWebEngageCallback()
    }

    private fun registerWebEngageCallback() {
        WebEngage.registerPushNotificationCallback(object : PushNotificationCallbacks {
            override fun onPushNotificationReceived(
                context: Context?,
                pushNotificationData: PushNotificationData?,
            ): PushNotificationData? {
                Log.d("PushCallback",
                    "onPushNotificationReceived: ${pushNotificationData.toString()}")
                Log.d("PushCallback", "summary: ${pushNotificationData?.bigTextStyleData?.summary}")
                Log.d("PushCallback", "bigText: ${pushNotificationData?.bigTextStyleData?.bigText}")
                Log.d("PushCallback", "actions: ${pushNotificationData?.actions}")
                //pushNotificationData?.InboxStyle()
                return pushNotificationData
            }

            override fun onPushNotificationShown(
                context: Context?,
                pushNotificationData: PushNotificationData?,
            ) {
                // Log.d("PushCallback", "onPushNotificationShown: ")
            }

            override fun onPushNotificationClicked(
                context: Context?,
                pushNotificationData: PushNotificationData?,
            ): Boolean {
                //Log.d("PushCallback", "onPushNotificationClicked: ")
                return false
            }

            override fun onPushNotificationDismissed(
                context: Context?,
                pushNotificationData: PushNotificationData?,
            ) {
                //Log.d("PushCallback", "onPushNotificationDismissed: ")
            }

            override fun onPushNotificationActionClicked(
                context: Context?,
                pushNotificationData: PushNotificationData?,
                buttonId: String?,
            ): Boolean {
                //Log.d("PushCallback", "onPushNotificationActionClicked: ")
                //Return true if the click was handled by your app, or false to let WebEngage SDK handle it.
                return false
            }
        })
    }

    /**
     * Called when message is received.
     *
     * @param remoteMessage Object representing the message received from Firebase Cloud Messaging.
     */
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        // [START_EXCLUDE]
        // There are two types of messages data messages and notification messages. Data messages are handled
        // here in onMessageReceived whether the app is in the foreground or background. Data messages are the type
        // traditionally used with GCM. Notification messages are only received here in onMessageReceived when the app
        // is in the foreground. When the app is in the background an automatically generated notification is displayed.
        // When the user taps on the notification they are returned to the app. Messages containing both notification
        // and data payloads are treated as notification messages. The Firebase console always sends notification
        // messages. For more see: https://firebase.google.com/docs/cloud-messaging/concept-options
        // [END_EXCLUDE]//{job_id=, post_id=, tag=admin_notify, body=HELLO how are you, sender_id=, title=Opps}
        // TODO(developer): Handle FCM messages here.
        // Not getting messages here? See why this may be: https://goo.gl/39bRNJ


        Log.d(TAG, "From: " + remoteMessage.from)
        Log.d(TAG, "MESSAGE DATA: " + remoteMessage.data)

        // Check if message contains a data payload.

        val notificationMap = remoteMessage.data

        if (Freshchat.isFreshchatNotification(remoteMessage)) {
            Freshchat.handleFcmMessage(applicationContext, remoteMessage)
        } else {
            if (notificationMap.isNotEmpty()) {
                val gson = Gson()

                if (notificationMap.containsKey("source") && "webengage" == notificationMap["source"]) {
                    // handle WE notification
                    WebEngage.get().receive(notificationMap)
                    Log.d("PushCallback", "remoteMessage.data: ${remoteMessage.data}")

                    if (notificationMap.containsKey("message_data")) {

                        /*Log.i("WE_PUSH",
                            "message_data : ${notificationMap["message_data"].toString()}")*/
                        val notificationPayloadData = gson.fromJson(notificationMap["message_data"],
                            NotificationPayloadData::class.java)

                        notificationPayloadData?.let {
                            if (appPreferences.getBoolean(Common.IS_LOGIN)) {
                                callUpdateNotificationAPI(notificationPayloadData)
                            }
                        }
                    }
                } else {

                    Log.d("PushCallback", "remoteMessage.data: ${remoteMessage.data}")
                    val notification = gson.fromJson(notificationMap["message"],
                        Notification::class.java)
                    notification?.let {
                        handleNotification(it, remoteMessage.data)
                    }

                }
            }
        }
    }

    private fun callUpdateNotificationAPI(notificationPayloadData: NotificationPayloadData) {
        scope.launch {

            val deepLink =
                if (notificationPayloadData.cta?.actionLink?.contains("open_url_in_browser/") == true) {
                    //notificationPayloadData.cta.actionLink.split("open_url_in_browser/")[1]
                    notificationPayloadData.cta.actionLink.let {
                        FirebaseLink.getDeepLinkFromWEActionLink(it)
                    }
                } else if (notificationPayloadData.expandableDetails?.cta1?.actionLink?.contains("open_url_in_browser/") == true) {
                    //notificationPayloadData.expandableDetails.cta1.actionLink.split("open_url_in_browser/")[1]
                    notificationPayloadData.expandableDetails.cta1.actionLink.let {
                        FirebaseLink.getDeepLinkFromWEActionLink(it)
                    }
                } else if (notificationPayloadData.expandableDetails?.cta2?.actionLink?.contains("open_url_in_browser/") == true) {
                    //notificationPayloadData.expandableDetails.cta2.actionLink.split("open_url_in_browser/")[1]
                    notificationPayloadData.expandableDetails.cta2.actionLink.let {
                        FirebaseLink.getDeepLinkFromWEActionLink(it)
                    }
                } else {
                    null
                }

            val response = authRepository.updateNotification(
                ApiRequest().apply {
                    image_url = notificationPayloadData.expandableDetails?.image
                    we_notification_id = notificationPayloadData.identifier
                    if (deepLink.isNullOrBlank().not()) {
                        deep_link = deepLink
                    }
                    mesage = notificationPayloadData.message
                    title = notificationPayloadData.title
                    data = notificationPayloadData
                }
            )

            Log.d(TAG, "request :- " + "\n" +
                    "image_url=" + notificationPayloadData.expandableDetails?.image + "\n" +
                    "we_notification_id=" + notificationPayloadData.identifier + "\n" +
                    "title=" + notificationPayloadData.title + "\n" +
                    "message=" + notificationPayloadData.message + "\n" +
                    "deep_link=" + deepLink + "\n")

            if (response.throwable != null) {
                Log.d(TAG, "ERROR ${response.throwable.message}")
            }
            if (response.responseBody != null) {
                Log.d(TAG, "Success ${response.responseBody.message}")
            }
        }
    }

    private fun handleNotification(
        notification: Notification,
        map: MutableMap<String, String>,
    ) {

        if (notification.flag != null) {

            val intent = Intent(this, HomeActivity::class.java)

            Log.d("notification_tag", "::" + notification.flag)

            /**
             * handle for req code and tag wise
             * params in notification
             */
            var requestCode = uniqeId
            /*when (notification.flag) {
                Common.NotificationTag.LogGoal -> {
                    when (notification.other_details?.key) {
                        Goals.Medication.goalKey -> {
                            requestCode = 1
                        }
                        Goals.Exercise.goalKey -> {
                            requestCode = 2
                        }
                        Goals.Pranayam.goalKey -> {
                            requestCode = 3
                        }
                        Goals.Steps.goalKey -> {
                            requestCode = 4
                        }
                        Goals.WaterIntake.goalKey -> {
                            requestCode = 5
                        }
                        Goals.Sleep.goalKey -> {
                            requestCode = 6
                        }
                        Goals.Diet.goalKey -> {
                            requestCode = 7
                        }
                    }
                }
                Common.NotificationTag.LogReading -> {
                    when (notification.other_details?.key) {
                        Readings.SPO2.readingKey -> {
                            requestCode = 8
                        }
                        Readings.FEV1.readingKey -> {
                            requestCode = 9
                        }
                        Readings.PEF.readingKey -> {
                            requestCode = 10
                        }
                        Readings.BloodPressure.readingKey -> {
                            requestCode = 11
                        }
                        Readings.HeartRate.readingKey -> {
                            requestCode = 12
                        }
                        Readings.BodyWeight.readingKey -> {
                            requestCode = 13
                        }
                        Readings.BMI.readingKey -> {
                            requestCode = 14
                        }
                        Readings.BloodGlucose.readingKey -> {
                            requestCode = 15
                        }
                        Readings.HbA1c.readingKey -> {
                            requestCode = 16
                        }
                        Readings.ACR.readingKey -> {
                            requestCode = 17
                        }
                        Readings.eGFR.readingKey -> {
                            requestCode = 18
                        }
                        Readings.CAT.readingKey -> {
                            requestCode = 19
                        }
                        Readings.SIX_MIN_WALK.readingKey -> {
                            requestCode = 20
                        }
                    }
                }
                else -> {
                    requestCode = 21
                }
            }*/

            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            intent.putExtra(Common.BundleKey.NOTIFICATION, notification)

            val pendingIntent = PendingIntent.getActivity(
                this, requestCode,
                intent, PendingIntent.FLAG_IMMUTABLE /*or PendingIntent.FLAG_ONE_SHOT*/
            )
            /*if (BaseActivity.isActive) {
                // send broadcast if app is active
                val broadcastIntent = Intent(ACTION_APP_NOTIFICATION)
                intent.extras?.let { broadcastIntent.putExtras(it) }
                sendBroadcast(broadcastIntent)
            }*/

            sendNotification(notification.message ?: "",
                notification.title ?: ""/*getString(R.string.app_name)*/,
                pendingIntent)

            /*sendNotificationWithReply(notification.message ?: "",
                notification.title ?: ""*//*getString(R.string.app_name)*//*,
                pendingIntent)*/

        }
    }

    /*
    public void createNotification (View view) {
      RemoteViews contentView = new RemoteViews(getPackageName() , R.layout. custom_notification_layout ) ;
      NotificationManager mNotificationManager = (NotificationManager) getSystemService( NOTIFICATION_SERVICE ) ;
      NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(MainActivity. this, default_notification_channel_id ) ;
      mBuilder.setContent(contentView) ;
      mBuilder.setSmallIcon(R.drawable. ic_launcher_foreground ) ;
      mBuilder.setAutoCancel( true ) ;
      if (android.os.Build.VERSION. SDK_INT >= android.os.Build.VERSION_CODES. O ) {
         int importance = NotificationManager. IMPORTANCE_HIGH ;
         NotificationChannel notificationChannel = new NotificationChannel( NOTIFICATION_CHANNEL_ID , "NOTIFICATION_CHANNEL_NAME" , importance) ;
         mBuilder.setChannelId( NOTIFICATION_CHANNEL_ID ) ;
         assert mNotificationManager != null;
         mNotificationManager.createNotificationChannel(notificationChannel) ;
      }
      assert mNotificationManager != null;
      mNotificationManager.notify(( int ) System. currentTimeMillis () , mBuilder.build()) ;
   }
     */

    private fun sendNotification(messageBody: String, title: String, pendingIntent: PendingIntent) {

        val notificationBuilder = NotificationCompat.Builder(
            this,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) Common.CHANNEL_ID else BuildConfig.APPLICATION_ID
        )

        val notification = notificationBuilder
            .setSmallIcon(R.drawable.ic_notification_small)
            .setLargeIcon(BitmapFactory.decodeResource(resources, R.drawable.ic_app_icon_big))
            .setAutoCancel(true)
            .setContentTitle(title)
            //.setCategory(NotificationCompat.CATEGORY_MESSAGE)
            //.addAction(R.drawable.ic_launcher_foreground, "Cancel 1", getDeleteIntent())
            //.addAction(R.drawable.ic_launcher_foreground, "Cancel 2", getDeleteIntent2())
            .setStyle(NotificationCompat.BigTextStyle().bigText(messageBody))
            .setContentIntent(pendingIntent)
            .setColor(Common.Colors.COLOR_PRIMARY)
            /*.setLargeIcon(
                BitmapFactory.decodeResource(applicationContext.resources, R.mipmap.ic_launcher)
            )*/
            .setDefaults(NotificationManagerCompat.IMPORTANCE_HIGH)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentText(messageBody).build()

        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        notificationManager.notify(uniqeId, notification)
    }

    fun getDeleteIntent(): PendingIntent? {
        val intent = Intent(this, NotificationBroadcastReceiver::class.java)
        intent.action = "notification_cancelled"
        return PendingIntent.getBroadcast(this,
            0,
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_CANCEL_CURRENT)
    }

    val KEY_REPLY = "submittedValue"
    private fun sendNotificationWithReply(
        messageBody: String,
        title: String,
        pendingIntent: PendingIntent,
    ) {

        val remoteInput: RemoteInput = RemoteInput.Builder(KEY_REPLY)
            .setLabel("Submit")
            .build()

        val replyAction: NotificationCompat.Action = NotificationCompat.Action.Builder(
            R.drawable.ic_exercise_info, "Submit", getReplyPendingIntent())
            .addRemoteInput(remoteInput)
            .setAllowGeneratedReplies(true)
            .build()


        val notificationBuilder = NotificationCompat.Builder(
            this,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) Common.CHANNEL_ID else BuildConfig.APPLICATION_ID
        )

        val notification = notificationBuilder
            .setSmallIcon(R.drawable.ic_notification_small)
            .setLargeIcon(BitmapFactory.decodeResource(resources, R.drawable.ic_app_icon_big))
            .setAutoCancel(true)
            .setContentTitle(title)
            .addAction(replyAction)
            //.setCategory(NotificationCompat.CATEGORY_MESSAGE)
            //.addAction(R.drawable.ic_launcher_foreground, "Cancel 1", getDeleteIntent())
            //.addAction(R.drawable.ic_launcher_foreground, "Cancel 2", getDeleteIntent2())
            .setStyle(NotificationCompat.BigTextStyle().bigText(messageBody))
            .setContentIntent(pendingIntent)
            .setColor(Common.Colors.COLOR_PRIMARY)
            /*.setLargeIcon(
                BitmapFactory.decodeResource(applicationContext.resources, R.mipmap.ic_launcher)
            )*/
            .setDefaults(NotificationManagerCompat.IMPORTANCE_HIGH)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentText(messageBody).build()

        val notificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        notificationManager.notify(uniqeId, notification)
    }

    private fun getReplyPendingIntent(): PendingIntent? {
        val intent: Intent
        /* return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {*/
        // start a
        // (i)  broadcast receiver which runs on the UI thread or
        // (ii) service for a background task to b executed , but for the purpose of
        // this codelab, will be doing a broadcast receiver
        intent = Intent(this, NotificationBroadcastReceiver::class.java)
        intent.action = "REPLY_ACTION"
        intent.putExtra("KEY_NOTIFICATION_ID", uniqeId)
        intent.putExtra("KEY_MESSAGE_ID", "messageId")
        return PendingIntent.getBroadcast(applicationContext, 100, intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        /*} else {
            // start your activity for Android M and below
            intent = Intent(context, ReplyActivity::class.java)
            intent.action = REPLY_ACTION
            intent.putExtra(KEY_MESSAGE_ID, messageId)
            intent.putExtra(KEY_NOTIFICATION_ID, notifyId)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            PendingIntent.getActivity(this, 100, intent,
                PendingIntent.FLAG_UPDATE_CURRENT)
        }*/

    }

    companion object {
        private val TAG = "MyFirebaseMsgService"
        val ACTION_PUSH = "MyFirebaseMsgService_ActionPush"
        val RC_common = 0
        val ACTION_RATE = "MyFirebaseMsgService_ActionRATE"
        val ACTION_BADGE_COUNT = "MyFirebaseMsgService_ActionPush"
        val ACTION_APP_NOTIFICATION = "AppNotification"
    }
}