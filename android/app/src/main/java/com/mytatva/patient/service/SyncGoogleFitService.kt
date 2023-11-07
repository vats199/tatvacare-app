package com.mytatva.patient.service

import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.repository.GoalReadingRepository
import com.mytatva.patient.di.Injector
import com.mytatva.patient.di.component.DaggerServiceComponent
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.googlefit.GoogleFit
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.*
import javax.inject.Inject

class SyncGoogleFitService : Service() {

    companion object {
        val TAG = SyncGoogleFitService::class.java.simpleName
        var isRunning = false
    }

    private val PROGRESS_MAX = 100
    private var PROGRESS_CURRENT = 0

    private val uniqueId: Int
        get() {
            val time = Date().time
            val tmpStr = time.toString()
            val last4Str = tmpStr.substring(tmpStr.length - 5)
            return Integer.valueOf(last4Str)
        }

    private var notificationId: Int? = null

    private val notificationBuilder by lazy {
        NotificationCompat.Builder(
            this,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) Common.CHANNEL_ID else BuildConfig.APPLICATION_ID
        ).setSmallIcon(R.drawable.ic_notification_small)
            .setContentTitle(getString(R.string.app_name))
            .setColor(Color.parseColor("#2E4799"))
            .setPriority(NotificationManagerCompat.IMPORTANCE_LOW)
            .setSound(null)
            .setContentText(getString(R.string.label_syncing))
    }

    @Inject
    lateinit var goalReadingRepository: GoalReadingRepository

    @Inject
    lateinit var googleFit: GoogleFit

    @Inject
    lateinit var analytics: AnalyticsClient

    private var scope = CoroutineScope(Dispatchers.IO)

    private val notificationManager by lazy {
        getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    }

    override fun onCreate() {
        super.onCreate()
        DaggerServiceComponent.builder()
            .applicationComponent(Injector.INSTANCE.applicationComponent)
            .build()
            .inject(this)
        notificationId = uniqueId
    }

    override fun onDestroy() {
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    var cal: Calendar? = null
    var calForCalories: Calendar? = null
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        isRunning = true
        intent?.extras?.let {
            if (it.containsKey(Common.BundleKey.CALENDAR)) {
                cal = it.getSerializable(Common.BundleKey.CALENDAR) as Calendar?
                calForCalories = it.getSerializable(Common.BundleKey.CALENDAR_FOR_CALORIES) as Calendar?
            }
        }

        if (cal == null) {
            stopSelf()
        } else {
            initProgressNotification()
            fetchData()
        }

        return super.onStartCommand(intent, flags, startId)
    }

    private fun fetchData() {

        googleFit.readGoals(cal!!) { goalsList ->

            Log.e("FINAL", "GOAL")



            googleFit.readReadings(cal!!, calForCalories!!) { readingsList ->

                analytics.logEvent(analytics.READING_CAPTURED_GOOGLE_FIT)

                scope.launch {

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
                        Log.d("updateReadingsGoals", " :: SENT GOALS")
                        callAPI(apiRequest)
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

                        // update sublist in server
                        val apiRequest = ApiRequest()
                        apiRequest.reading_data = subList
                        Log.d("updateReadingsGoals", " :: SENT READINGS")
                        callAPI(apiRequest)
                    }

                    onCompleteUpdateNotification()

                }

            }
        }

    }

    private suspend fun callAPI(apiRequest: ApiRequest) {
        val response = goalReadingRepository.updateReadingsGoals(apiRequest)
        if (response.throwable != null) {
            Log.d(TAG, "updateReadingsGoals ERROR ${response.throwable.message}")
        }
        if (response.responseBody != null) {
            Log.d(TAG, "updateReadingsGoals Success ${response.responseBody.message}")
        }
    }

    private fun initProgressNotification() {
        // Issue the initial notification with zero progress
        notificationBuilder//.setProgress(PROGRESS_MAX, PROGRESS_CURRENT, false)
            .setContentTitle(getString(R.string.app_name))
            .setContentText(getString(R.string.label_syncing)/*.plus("$PROGRESS_CURRENT%")*/)

        notificationManager.notify(notificationId!!, notificationBuilder.build())

        startForeground(notificationId!!, notificationBuilder.build())
    }

    private fun onCompleteUpdateNotification() {
        // Issue the initial notification with zero progress
        //notificationBuilder.setContentTitle(getString(R.string.app_name))
        //.setContentText(getString(R.string.label_syncing)/*.plus("$PROGRESS_CURRENT%")*/)
        //.setProgress(0, 0, false)
        //notificationManager.notify(notificationId!!, notificationBuilder.build())
        stopForeground(true)
        isRunning = false
        //notificationManager.cancel(notificationId!!)
    }

    private fun onFailedUpdateNotification() {
        // Issue the initial notification with zero progress
        /*notificationBuilder.setContentTitle(apiRequest?.title)
            .setContentText(getString(R.string.label_upload_failed))
            .setProgress(0, 0, false)
        notificationManager.notify(notificationId!!, notificationBuilder.build())*/
        stopForeground(true)
        isRunning = false
        //notificationManager.cancel(notificationId!!)
    }

}
