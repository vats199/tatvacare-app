package com.mytatva.patient.utils;
/*

import android.Manifest
import android.app.Activity
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.appcompat.widget.AppCompatTextView
import androidx.core.app.ActivityCompat
import androidx.work.*
import com.fitbit.api.APIUtils
import com.fitbit.api.models.DailyActivitySummary
import com.fitbit.authentication.AuthenticationHandler
import com.fitbit.authentication.AuthenticationManager
import com.fitbit.authentication.AuthenticationResult
import com.fitbit.authentication.Scope
import com.fitbit.fitbitcommon.network.BasicHttpRequest
import com.fitbit.fitbitcommon.network.BasicHttpResponse
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.FitnessActivities
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataSet
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.data.Field
import com.google.android.gms.fitness.request.DataReadRequest
import com.google.android.gms.fitness.request.SessionReadRequest
import com.google.android.gms.fitness.result.SessionReadResponse
import com.google.android.gms.tasks.OnFailureListener
import com.google.android.gms.tasks.OnSuccessListener
import com.google.android.material.snackbar.Snackbar
import com.google.gson.Gson
import com.paidworkout.R
import com.paidworkout.core.Common
import com.paidworkout.core.Session
import com.paidworkout.data.pojo.RequestData
import com.paidworkout.di.component.FragmentComponent
import com.paidworkout.ui.activity.HomeActivity
import com.paidworkout.ui.base.BaseActivity
import com.paidworkout.ui.base.BaseFragment
import com.paidworkout.ui.modules.account.googlefitscheduler.AlarmReceiver
import com.paidworkout.ui.modules.account.googlefitscheduler.UploadWorker
import com.paidworkout.utils.extentions.OpenAppUsingIntent
import com.paidworkout.utils.extentions.format
import com.paidworkout.utils.extentions.formatDate
import com.paidworkout.utils.extentions.getColorFromResource
import kotlinx.android.synthetic.main.account_get_health_info_fragment.*
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import kotlin.collections.ArrayList


class GetHealthInfoFragment : BaseFragment(), AuthenticationHandler {

    val TAG = "StepCounter"
    val arrayListData = ArrayList<RequestData>()

    @Inject
    lateinit var session: Session

    enum class FitActionRequestCode {
        SUBSCRIBE,
        READ_DATA
    }

    private val fitnessOptions = FitnessOptions.builder()
        .addDataType(DataType.TYPE_STEP_COUNT_CUMULATIVE)
        .addDataType(DataType.TYPE_STEP_COUNT_DELTA)
        .addDataType(DataType.TYPE_ACTIVITY_SEGMENT)
        .addDataType(DataType.TYPE_CALORIES_EXPENDED)
        .addDataType(DataType.TYPE_WORKOUT_EXERCISE)
        .addDataType(DataType.TYPE_ACTIVITY_SEGMENT, FitnessOptions.ACCESS_READ)
        .build()

    private val runningQOrLater =
        android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun createLayout(): Int = R.layout.account_get_health_info_fragment
    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun bindData() {
        toolbar.setToolbarTitle("Get Health Info")
        when (appPreferences.getString(Common.HEALTH_CONNECTED_DEVICE)) {
            Common.HealthDevice.GOOGLE_FIT -> {
                readDataForLoop()
                checkBoxGoogle.isChecked = true
                checkBoxSamsung.isChecked = false
                checkBoxGramin.isChecked = false
            }
            Common.HealthDevice.FITBIT -> {
                fitbitForLoop()
                checkBoxSamsung.isChecked = true
                checkBoxGoogle.isChecked = false
                checkBoxGramin.isChecked = false
            }
            Common.HealthDevice.GARMIN -> {
                checkBoxGramin.isChecked = true
                checkBoxGoogle.isChecked = false
                checkBoxSamsung.isChecked = false
            }
        }
    readData()
            getActivitySessions()
        }

//        checkBoxGoogle.isChecked = appPreferences.getBoolean(Common.IS_GOOGLE_FIT_INTEGRATED)
        buttonConnect.setOnClickListener(this::onViewClick)
        relativeSamsungHealth.setOnClickListener(this::onViewClick)
        relativeGoogleFit.setOnClickListener(this::onViewClick)
        relativeGramin.setOnClickListener(this::onViewClick)
        checkBoxSamsung.setOnClickListener(this::onViewClick)
        checkBoxGoogle.setOnClickListener(this::onViewClick)
        checkBoxGramin.setOnClickListener(this::onViewClick)
    }

    private fun fitbitForLoop() {
        for (i in 0 until 7) {
            arrayListData.clear()

            var total: Int? = null
            var totalCal: String? = null
            var totalActivity: String? = null

            val cal = Calendar.getInstance()
            cal.add(Calendar.DAY_OF_MONTH, -i)

            Thread {
                // Do network action in this function
                try {
                    val dateFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)
                    val url = String.format(
                        "https://api.fitbit.com/1/user/%s/activities/date/%s.json",
                        AuthenticationManager.getCurrentAccessToken().userId,
                        dateFormat.format(cal.time)
                    )

//                    Log.e("FitBitUrl", url)

                    APIUtils.validateToken(
                        activity,
                        AuthenticationManager.getCurrentAccessToken(),
                        *arrayOf(Scope.activity)
                    )
//                    Log.e("url", url)
                    val request: BasicHttpRequest = AuthenticationManager
                        .createSignedRequest()
                        .setContentType("Application/json")
                        .setUrl(url)
                        .build()

//                    Log.e("reqest", request.toString())
//                    Log.e("request", request.params.toString())
                    val response: BasicHttpResponse = request.execute()
                    val responseCode: Int = response.getStatusCode()
                    val json: String = response.getBodyAsString()
                    if (response.isSuccessful()) {
                        val resource: DailyActivitySummary =
                            Gson().fromJson(json, DailyActivitySummary::class.java)
                        total = resource.summary.steps
                        totalActivity =
                            (resource.summary.fairlyActiveMinutes + resource.summary.veryActiveMinutes).toString()
                        totalCal = resource.summary.activityCalories.toString()
                        callSetActivityScore(total, totalCal, totalActivity, cal)

//                ResourceLoaderResult.onSuccess(resource)
                    } else {
                        if (responseCode == 401) {
                            if (AuthenticationManager.getAuthenticationConfiguration().isLogoutOnAuthFailure) {
                                // Token may have been revoked or expired
                                callLogout()
                            } else {

                            }
//                    ResourceLoaderResult.onLoggedOut()
                        } else {
                    val errorMessage = String.format(
                        Locale.ENGLISH,
                        "Error making request:%s\tHTTP Code:%d%s\tResponse Body:%s%s%s\n",
                        ResourceLoader.EOL,
                        responseCode,
                        ResourceLoader.EOL,
                        ResourceLoader.EOL,
                        json,
                        ResourceLoader.EOL
                    )


//                    ResourceLoaderResult.onError(errorMessage)
                        }
                    }
                } catch (e: Exception) {
                    showExeption(e)
//            ResourceLoaderResult.onException(e)
                }

            }.start()

        }
    }

    private fun getActivitySessions() {
        // Set a start and end time for our query, using a start time of 1 week before this moment.

        // Set a start and end time for our query, using a start time of 1 week before this moment.
        val cal = Calendar.getInstance()
        val now = Date()
        cal.time = now
        val endTime = cal.timeInMillis
        cal.add(Calendar.WEEK_OF_YEAR, -1)
        val startTime = cal.timeInMillis

        // Build a session read request
        val readRequest = SessionReadRequest.Builder()
            .setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
            .read(DataType.TYPE_SPEED)
            .setSessionName(FitnessActivities.WALKING)
            .build()

        Fitness.getSessionsClient(
            requireActivity(),
            GoogleSignIn.getAccountForExtension(requireActivity(), fitnessOptions)
        )
            .readSession(readRequest)
            .addOnSuccessListener(object : OnSuccessListener<SessionReadResponse?> {
                fun onSuccess(sessionReadResponse: SessionReadResponse) {
                    // Get a list of the sessions that match the criteria to check the result.
                    val sessions: List<Session> = sessionReadResponse.getSessions()
                    Log.i(
                        TAG, "Session read was successful. Number of returned sessions is: "
                                + sessions.size()
                    )
                    for (session in sessions) {
                        // Process the session
                        dumpSession(session)

                        // Process the data sets for this session
                        val dataSets: List<DataSet> = sessionReadResponse.getDataSet(session)
                        for (dataSet in dataSets) {
                            dumpDataSet(dataSet)
                        }
                    }
                }



                override fun onSuccess(p0: SessionReadResponse?) {
                    if (p0 != null) {
                        val sessions: MutableList<com.google.android.gms.fitness.data.Session>? =
                            p0.getSessions()
//                        Log.e(
//                            TAG, "Session read was successful. Number of returned sessions is: "
//                                    + sessions?.size
//                        )
                        if (sessions != null) {
                            for (session in sessions) {
                                // Process the session
//                                Log.e(
//                                    TAG, "Session read was successful.sessions is: "
//                                            + session
//                                )

//                                dumpSession(session)

                                // Process the data sets for this session
                                val dataSets: List<DataSet> = p0.getDataSet(session)
                                for (dataSet in dataSets) {
//                                    Log.e(
//                                        TAG, "Session read was successful.dataset is: "
//                                                + dataSet
//                                    )

//                                    dumpDataSet(dataSet)
                                }
                            }
                        }
                    }
                }
            })
            .addOnFailureListener(object : OnFailureListener {
 fun onFailure(@NonNull e: Exception?) {
                     Log.i(TAG, "Failed to read session")
                 }


                override fun onFailure(p0: java.lang.Exception) {
//                    Log.i(TAG, "Failed to read session" + p0.toString())

                }
            })
    }

    override fun onViewClick(view: View) {
        when (view) {
            buttonConnect -> {
                if (checkBoxGoogle.isChecked) {
                    if (OpenAppUsingIntent.checkIfFitInstalled(requireActivity().applicationContext)) {
                        checkPermissionsAndRun(FitActionRequestCode.SUBSCRIBE)
                    } else {
                        showAlertDialog(
                            "Please install google fit app from play store",
                            dialogOkListener = object : BaseActivity.DialogOkListener {
                                override fun onClick() {
                                    OpenAppUsingIntent.openFitInPlayStore(activity!!)
                                }
                            })
                    }
                } else if (checkBoxSamsung.isChecked) {
   val intent: Intent = FitBitActivity.newIntent(this)
                       startActivity(intent)

                    AuthenticationManager.login(this)

                } else if (checkBoxGramin.isChecked) {

                } else {
                    showMessage("Please select application")
                }
//                navigator.goBack()
            }
            relativeSamsungHealth,
            checkBoxSamsung -> {
                checkBoxSamsung.isChecked = true
                checkBoxGoogle.isChecked = false
                checkBoxGramin.isChecked = false
            }
            relativeGoogleFit,
            checkBoxGoogle -> {
                checkBoxGoogle.isChecked = true
                checkBoxSamsung.isChecked = false
                checkBoxGramin.isChecked = false
            }
            relativeGramin,
            checkBoxGramin -> {
                checkBoxGramin.isChecked = true
                checkBoxGoogle.isChecked = false
                checkBoxSamsung.isChecked = false
            }
        }
    }

    private fun checkPermissionsAndRun(fitActionRequestCode: FitActionRequestCode) {
        if (permissionApproved()) {
            fitSignIn(fitActionRequestCode)
        } else {
            requestRuntimePermissions(fitActionRequestCode)
        }
    }

    private fun fitSignIn(requestCode: FitActionRequestCode) {
        if (oAuthPermissionsApproved()) {
            performActionForRequestCode(requestCode)
        } else {
            requestCode.let {
                GoogleSignIn.requestPermissions(
                    this,
                    requestCode.ordinal,
                    getGoogleAccount(), fitnessOptions
                )
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        AuthenticationManager.onActivityResult(requestCode, resultCode, data, this)
        if (requestCode == FitActionRequestCode.SUBSCRIBE.ordinal)
            when (resultCode) {
                Activity.RESULT_OK -> {
                    val postSignInAction = FitActionRequestCode.values()[requestCode]
                    postSignInAction.let {
                        performActionForRequestCode(postSignInAction)
                    }
                }
                else -> oAuthErrorMsg(requestCode, resultCode)
            }
    }

    private fun oAuthErrorMsg(requestCode: Int, resultCode: Int) {
        val message = """
            There was an error signing into Fit. Check the troubleshooting section of the README
            for potential issues.
            Request code was: $requestCode
            Result code was: $resultCode
        """.trimIndent()
//        Log.e(TAG, message)
    }

    private fun oAuthPermissionsApproved() =
        GoogleSignIn.hasPermissions(getGoogleAccount(), fitnessOptions)

    private fun getGoogleAccount() =
        GoogleSignIn.getAccountForExtension(requireActivity(), fitnessOptions)

    private fun permissionApproved(): Boolean {
        return if (runningQOrLater) {
            PackageManager.PERMISSION_GRANTED == ActivityCompat.checkSelfPermission(
                requireActivity(),
                Manifest.permission.ACTIVITY_RECOGNITION
            )
        } else {
            true
        }
    }

    private fun performActionForRequestCode(requestCode: FitActionRequestCode) =
        when (requestCode) {
            FitActionRequestCode.READ_DATA -> readData()
            FitActionRequestCode.SUBSCRIBE -> subscribe()
        }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        if (permissionApproved())
            checkPermissionsAndRun(FitActionRequestCode.SUBSCRIBE)
    }

    private fun requestRuntimePermissions(requestCode: FitActionRequestCode) {
        val shouldProvideRationale =
            shouldShowRequestPermissionRationale(
                Manifest.permission.ACTIVITY_RECOGNITION
            )

        // Provide an additional rationale to the user. This would happen if the user denied the
        // request previously, but didn't check the "Don't ask again" checkbox.
        requestCode.let {
            if (shouldProvideRationale) {
//                Log.e(TAG, "Displaying permission rationale to provide additional context.")
                Snackbar.make(
                    requireView(),
                    "Location data is used as part of the Google Fit API",
                    Snackbar.LENGTH_INDEFINITE
                )
                    .setAction(R.string.label_ok) {
                        // Request permission
                        requestPermissions(
                            arrayOf(Manifest.permission.ACTIVITY_RECOGNITION),
                            requestCode.ordinal
                        )
                    }
                    .show()
            } else {
//                Log.e(TAG, "Requesting permission")
                // Request permission. It's possible this can be auto answered if device policy
                // sets the permission in a given state or the user denied the permission
                // previously and checked "Never ask again".
                requestPermissions(
                    arrayOf(Manifest.permission.ACTIVITY_RECOGNITION),
                    requestCode.ordinal
                )
            }
        }
    }

    private fun readDataForLoop() {
        arrayListData.clear()

        for (i in 0 until 7) {
            val cal = Calendar.getInstance()

            var total: Int? = null
            var totalCal: String? = null
            var totalActivity: String? = null

            cal.add(Calendar.DAY_OF_MONTH, -i)
            if (i > 0) {
                cal.set(Calendar.HOUR_OF_DAY, 22)
                cal.set(Calendar.MINUTE, 59)
                cal.set(Calendar.SECOND, 60)
            }
            val endTime = cal.time.time
//            Log.e("end time", cal.time.toString())
            cal.set(Calendar.HOUR_OF_DAY, 0)
            cal.set(Calendar.MINUTE, 0)
            cal.set(Calendar.SECOND, 0)
            val startTime = cal.time.time
//            Log.e("start time", cal.time.toString())

            val readRequest = DataReadRequest.Builder()
                .read(DataType.TYPE_STEP_COUNT_DELTA)
                .bucketByActivityType(1, TimeUnit.SECONDS)
                .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
                .build()

            Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
                .readData(readRequest)
                .addOnSuccessListener { dataReadResponse ->
//                Log.e("Dataset", dataReadResponse.toString())
                    total =
                        if (!dataReadResponse.buckets.isNullOrEmpty()) {
                            var setpes = 0
                            for (bucket in dataReadResponse.buckets) {
                                for (dataset in bucket.dataSets) {
                                    for (dataPoint in dataset.dataPoints) {
                                    Log.e(
                                        TAG,
                                        "stram name: ${dataPoint.originalDataSource.streamName}"
                                    )


                                        if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                            setpes += dataPoint.getValue(Field.FIELD_STEPS).asInt()
//                                        Log.i(TAG, "Total steps tmp: $setpes")
                                        }
                                    }
                                }

                            }
                            setpes
                        } else {
                            0
                        }
//                Log.i(TAG, "Total steps: $total")
                    if (total != null && totalCal != null && totalActivity != null) {
                        callSetActivityScore(total, totalCal, totalActivity, cal)
                    }
                }
                .addOnFailureListener {
//                Log.w(TAG, "There was a problem getting the step count.", it)
                }

            val readRequestCal = DataReadRequest.Builder()
                .read(DataType.TYPE_CALORIES_EXPENDED)
                .bucketByActivityType(1, TimeUnit.SECONDS)
                .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
                .build()

            Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
                .readData(readRequestCal)
                .addOnSuccessListener { dataReadResponse ->
//                Log.e("Dataset", dataReadResponse.toString())
                    totalCal =
                        if (!dataReadResponse.buckets.isNullOrEmpty()) {
                            var setpes = 0.0
                            for (bucket in dataReadResponse.buckets) {
                                for (dataset in bucket.dataSets) {
                                    for (dataPoint in dataset.dataPoints) {
                                    Log.e(
                                        TAG,
                                        "stram name cal: ${dataPoint.originalDataSource.streamName}"
                                    )


                                        if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                            setpes += dataPoint.getValue(Field.FIELD_CALORIES)
                                                .asFloat()
//                                        Log.i(TAG, "Total cal tmp: $setpes")
                                        }
                                    }
                                }
                            }
                            setpes.toString()
                        } else {
                            "0"
                        }
                    if (session.user?.height?.equals(0.0) ?: false) {
                        if (!session.user!!.weightKg.isNullOrEmpty()) {
                            session.user!!.weight = session.user!!.weightKg.toDoubleOrNull() ?: 0.0
                        } else {
                            session.user!!.weight =
                                ((session.user!!.weightPound.toDoubleOrNull() ?: 0.0) * 0.453592)
                        }
                        if (!session.user!!.heightFeet.isNullOrEmpty()) {
                            val feet = session.user!!.heightFeet.substringBefore("\'")
                            val inch = session.user!!.heightFeet.removePrefix(feet.plus("\'"))
                                .removeSuffix("\"").toIntOrNull() ?: 0
                            session.user!!.height =
                                ((((feet.toIntOrNull() ?: 0) * 12) + (inch)) * 2.54)
                        } else {
                            session.user!!.height = session.user!!.heightCm.toDoubleOrNull() ?: 0.0
                        }
                        when (session.user?.gender) {
                            Common.Gender.MALE -> {
                                session.user!!.bmr =
                                    (66.47 + (13.75 * session.user!!.weight) + (5.003 * session.user!!.height) - (6.755 * (session.user!!.age.toIntOrNull()
                                        ?: 0)))
                            }
                            Common.Gender.FEMALE -> {
                                session.user!!.bmr =
                                    (655.1 + (9.563 * session.user!!.weight) + (1.85 * session.user!!.height) - (4.676 * (session.user!!.age.toIntOrNull()
                                        ?: 0)))
                            }
                            else -> {
                                session.user!!.bmr = 0.0

                            }
                        }
                    }

                    var finalCal: Double = if (i > 0) {
                        (totalCal?.toDoubleOrNull() ?: 0.0) - (session.user?.bmr ?: 0.0)

                    } else {
                        (totalCal?.toDoubleOrNull() ?: 0.0) - ((session.user?.bmr
                            ?: 0.0) / 24 * Calendar.getInstance().get(Calendar.HOUR_OF_DAY))
                    }
                    if (finalCal < 0) {
                        finalCal = 0.0
                    }

       Log.e(
                               "minutes in total",
                               "${
                                   ((Calendar.getInstance()
                                       .get(Calendar.HOUR_OF_DAY) * 60) + (Calendar.getInstance()
                                       .get(Calendar.MINUTE)))
                               }"
                           )
                           Log.e(
                               "cal by minutes", "${
                                   ((totalCal?.toDoubleOrNull()
                                       ?: 0.0) - (((session.user?.bmr ?: 0.0) / 1440) * ((Calendar.getInstance()
                                       .get(Calendar.HOUR_OF_DAY) * 60) + (Calendar.getInstance()
                                       .get(Calendar.MINUTE)))))
                               }"
                           )
                           Log.e("height", session.user?.height.toString())
                           Log.e("weight", session.user?.weight.toString())
                           Log.e("age", session.user?.age.toString())
                           Log.e("bmr", session.user?.bmr.toString())
                           Log.e("Total cal:", " $totalCal")
                           Log.e("Total after cal:", " $finalCal")

                    totalCal = finalCal.toString()

                    if (total != null && totalCal != null && totalActivity != null) {
  val notificationManager =
                              appContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

                          notificationManager.cancel(random)

                        callSetActivityScore(total, totalCal, totalActivity, cal)

                    }

                }
                .addOnFailureListener {
//                Log.w(TAG, "There was a problem getting the step count.", it)
                }

            val readRequestMov = DataReadRequest.Builder()
                .read(DataType.TYPE_MOVE_MINUTES)
                .bucketByActivityType(1, TimeUnit.SECONDS)
                .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
                .build()

            Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
                .readData(readRequestMov)
                .addOnSuccessListener { dataReadResponse ->
//                Log.e("Dataset", dataReadResponse.toString())
                    totalActivity =
                        if (!dataReadResponse.buckets.isNullOrEmpty()) {
                            var setpes = 0
                            for (bucket in dataReadResponse.buckets) {
                                for (dataset in bucket.dataSets) {
                                    for (dataPoint in dataset.dataPoints) {
                                    Log.e(
                                        TAG,
                                        "stram name mov: ${dataPoint.originalDataSource.streamName}"
                                    )


                                        if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                            Log.e(
                                                "stream name",
                                                dataPoint.dataSource.device.toString()
                                            )


                                            setpes += dataPoint.getValue(Field.zzmw).asInt()
//                                        Log.i(TAG, "Total mov tmp: $setpes")
                                        }
                                    }
                                }
                            }
                            setpes.toString()
                        } else {
                            "0"
                        }
//                Log.i(TAG, "Total activiy: $totalActivity")
                    if (total != null && totalCal != null && totalActivity != null) {
                        callSetActivityScore(total, totalCal, totalActivity, cal)
                    }
                }
                .addOnFailureListener {
//                Log.w(TAG, "There was a problem getting the step count.", it)
                }
        }

    }

    private fun callSetActivityScore(
        total: Int?,
        totalCal: String?,
        totalActivity: String?,
        cal: Calendar
    ) {
        if (session.user?.id != null && (session.user?.ef.isNullOrEmpty() || (session.user?.ef?.toDoubleOrNull()
                ?: 0.0) == 0.0)
        ) {
            val weight: Double = if (session.user?.weightPound.isNullOrEmpty()) {
                (session.user?.weightKg?.toDoubleOrNull() ?: 0.0) * 2.20462
            } else {
                session.user?.weightPound?.toDoubleOrNull() ?: 0.0
            }

            val heigh: Double = if (session.user?.heightFeet.isNullOrEmpty()) {
                //cm into inch
                (session.user?.heightCm?.toDoubleOrNull() ?: 0.0) * 0.393701
            } else {
                val feet = session.user?.heightFeet?.substringBefore("\'") ?: "0"
                val inch =
                    session.user?.heightFeet?.removePrefix(feet.plus("\'"))?.removeSuffix("\"")
                        ?: "0"
                (((feet.toDoubleOrNull() ?: 0.0) * 12) + (inch.toDoubleOrNull() ?: 0.0))
            }

            val userBMI = 703 * weight / (heigh * heigh)

            val EF = 1 + ((Common.AVERAGE_BMI - userBMI) / userBMI)

            session.user?.ef = EF.toString()
//            Log.e("ef", session.user?.ef.toString())

            val requestData = RequestData()
            requestData.apply {
                userId = session.userId
                date = cal.time.formatDate(Common.DateFormat.YYYY_MM_DD)
                calories = totalCal
                execiseMin = totalActivity
                ef = session.user?.ef
                deviceType = Session.DEVICE_TYPE
                step = total.toString()
            }

            arrayListData.add(requestData)
            if (arrayListData.size == 7) {
//                Log.e("data", arrayListData.toString())
                val toJson = Gson().toJson(arrayListData)
//                Log.e("datajosn", toJson)
            }
        } else {
            val requestData = RequestData()
            requestData.apply {
                userId = session.userId
                date = cal.time.formatDate(Common.DateFormat.YYYY_MM_DD)
                calories = totalCal
                execiseMin = totalActivity
                ef = session.user?.ef
                deviceType = Session.DEVICE_TYPE
                step = total.toString()
            }

            arrayListData.add(requestData)
            if (arrayListData.size == 7) {
//                Log.e("data", arrayListData.toString())
                val toJson = Gson().toJson(arrayListData)
//                Log.e("datajson", toJson)
            }

        }
    }

    private fun readData() {

        val cal = Calendar.getInstance()
        val endTime = cal.time.time
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        val startTime = cal.time.time

        val readRequest = DataReadRequest.Builder()
            .read(DataType.TYPE_STEP_COUNT_DELTA)
            .bucketByActivityType(1, TimeUnit.SECONDS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->
//                Log.e("Dataset", dataReadResponse.toString())
                val total =
                    if (!dataReadResponse.buckets.isNullOrEmpty()) {
                        var setpes = 0
                        for (bucket in dataReadResponse.buckets) {
                            for (dataset in bucket.dataSets) {
                                for (dataPoint in dataset.dataPoints) {
//                                    Log.e(
//                                        TAG,
//                                        "stram name: ${dataPoint.originalDataSource.streamName}"
//                                    )
                                    if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                        setpes += dataPoint.getValue(Field.FIELD_STEPS).asInt()
//                                        Log.i(TAG, "Total steps tmp: $setpes")
                                    }
                                }
                            }

                        }
                        setpes
                    } else {
                        0
                    }
            }
            .addOnFailureListener {
//                Log.w(TAG, "There was a problem getting the step count.", it)
            }

        val readRequestCal = DataReadRequest.Builder()
            .read(DataType.TYPE_CALORIES_EXPENDED)
            .bucketByActivityType(1, TimeUnit.SECONDS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
            .readData(readRequestCal)
            .addOnSuccessListener { dataReadResponse ->
//                Log.e("Dataset", dataReadResponse.toString())
                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    var setpes = 0.0
                    for (bucket in dataReadResponse.buckets) {
                        for (dataset in bucket.dataSets) {
                            for (dataPoint in dataset.dataPoints) {
//                                Log.e(
//                                    TAG,
//                                    "stram name cal: ${dataPoint.originalDataSource.streamName}"
//                                )
                                if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                    setpes += dataPoint.getValue(Field.FIELD_CALORIES).asFloat()
//                                    Log.i(TAG, "Total cal tmp: $setpes")
                                }
                            }
                        }
                    }
                }
            }
            .addOnFailureListener {
//                Log.w(TAG, "There was a problem getting the step count.", it)
            }

        val readRequestMov = DataReadRequest.Builder()
            .read(DataType.TYPE_MOVE_MINUTES)
            .bucketByActivityType(1, TimeUnit.SECONDS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
            .readData(readRequestMov)
            .addOnSuccessListener { dataReadResponse ->
//                Log.e("Dataset", dataReadResponse.toString())
                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    var setpes = 0
                    for (bucket in dataReadResponse.buckets) {
                        for (dataset in bucket.dataSets) {
                            for (dataPoint in dataset.dataPoints) {
//                                Log.e(
//                                    TAG,
//                                    "stram name mov: ${dataPoint.originalDataSource.streamName}"
//                                )
                                if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                    setpes += dataPoint.getValue(Field.zzmw).asInt()
//                                    Log.i(TAG, "Total mov tmp: $setpes")
                                }
                            }
                        }
                    }
                }
            }
            .addOnFailureListener {
//                Log.w(TAG, "There was a problem getting the step count.", it)
            }


        Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
            .readDailyTotal(DataType.TYPE_STEP_COUNT_DELTA)
            .addOnSuccessListener { dataSet ->
                val total = when {
                    dataSet.isEmpty -> 0
                    else -> {
                        var totalTem = 0
                        for (dataPoint in dataSet.dataPoints) {
                            if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                totalTem += dataPoint.getValue(Field.FIELD_STEPS).asInt()
                            }
                        }
                        totalTem
//                        dataSet.dataPoints.first().getValue(Field.FIELD_STEPS).asInt()
                    }
                }
//                Log.i(TAG, "Total steps: $total")
//                textViewTotalSteps.format("Total steps: $total")

            }
            .addOnFailureListener { e ->
//                Log.w(TAG, "There was a problem getting the step count.", e)
            }

        Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
            .readDailyTotal(DataType.TYPE_CALORIES_EXPENDED)
            .addOnSuccessListener { dataSet ->
                val totalCal: String = when {
                    dataSet.isEmpty -> "0.0"
                    else -> {
                        var temCal = 0.0
                        for (dataPoint in dataSet.dataPoints) {
                            if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                temCal += dataPoint.getValue(Field.FIELD_CALORIES).asFloat()
                            }
                        }
                        temCal.toString()
//                        dataSet.dataPoints.first().getValue(Field.FIELD_CALORIES).toString()
                    }
//                    else -> dataSet.dataPoints.first().getValue(Field.FIELD_CALORIES).asInt()
                }
                //                    dataSet.dataPoints.first().zzlh.zzls

                var finalCal: Double =
                    ((totalCal.toDoubleOrNull()
                        ?: 0.0) - (
(session.user?.bmr ?: 0.0)/24)
(session.user!!.bmr / 24) * (Calendar.getInstance()
                        .get(
                            Calendar.HOUR_OF_DAY
                        ))))
                if (finalCal < 0) {
                    finalCal = 0.0
                }
//                Log.e("height", session.user?.height.toString())
//                Log.e("weight", session.user?.weight.toString())
//                Log.e("age", session.user?.age.toString())
//                Log.e("bmr", session.user?.bmr.toString())
//                Log.e(TAG, "Total cal: $totalCal")
//                textViewHeight.format("User Height: ${session.user?.height}")
//                textViewWeight.format("User Weight: ${session.user?.weight}")
//                textViewAge.format("User Age: ${session.user?.age}")
                when (session.user?.gender) {
                    Common.Gender.MALE -> {
                        session.user!!.bmr =
                            (66.47 + (13.75 * session.user!!.weight) + (5.003 * session.user!!.height) - (6.755 * (session.user!!.age.toIntOrNull()
                                ?: 0)))
//                        textViewBMR.format("BMR:(66.47 + (13.75 * ${session.user!!.weight}) + (5.003 * ${session.user!!.height}) - (6.755 * (${session.user!!.age})))= ${session.user?.bmr}")

                    }
                    Common.Gender.FEMALE -> {
                        session.user!!.bmr =
                            (655.1 + (9.563 * session.user!!.weight) + (1.85 * session.user!!.height) - (4.676 * (session.user!!.age.toIntOrNull()
                                ?: 0)))
//                        textViewBMR.format("BMR:(655.1 + (9.563 * ${session.user!!.weight}) + (1.85 * ${session.user!!.height}) - (4.676 * (${session.user!!.age})))= ${session.user?.bmr}")
//                        textViewBMR.format("BMR: ${session.user?.bmr}")

                    }
                    else -> {
                        session.user!!.bmr = 0.0

                    }
                }
                textViewBMR24.format(
                    "BMR/24*(current hour of day) : ${
                        (session.user!!.bmr / 24) * (Calendar.getInstance().get(
                            Calendar.HOUR_OF_DAY
                        ))
                    }"
                )


//                textViewGoogleFit.format("Google Fit Cal: ${totalCal}")
//                textViewFinal.format("Final Cal: ${finalCal}")
//                textViewTotalCal.format("Total cal: $finalCal")
            }
            .addOnFailureListener { e ->
//                Log.w(TAG, "There was a problem getting the calory count.", e)
            }
        Fitness.getHistoryClient(requireActivity(), getGoogleAccount())
            .readDailyTotal(DataType.TYPE_MOVE_MINUTES)
            .addOnSuccessListener { dataSet ->
                val totalActivity: String = when {
                    dataSet.isEmpty -> "0.0"
                    else -> {
                        var temCal = 0.0
                        for (dataPoint in dataSet.dataPoints) {
                            if (!dataPoint.originalDataSource.streamName.equals("user_input")) {
                                temCal += dataPoint.getValue(Field.zzmw).asInt()
                            }
                        }
                        temCal.toString()
//                        dataSet.dataPoints.first().getValue(Field.zzmw).toString()
                    }
//                    dataSet.dataPoints.first().dataSource.device.equals()
//                    else -> dataSet.dataPoints.first().getValue(Field.FIELD_CALORIES).asInt()
                }
//                Log.i(TAG, "Total activity: $totalActivity")
//                textViewTotalActivity.format("Total activity: $totalActivity")
            }
            .addOnFailureListener { e ->
//                Log.w(TAG, "There was a problem getting the activiy count.", e)
            }

        val make = Snackbar.make(
            requireView(),
            "Successfully get data from google fit",
            Snackbar.LENGTH_INDEFINITE
        )
        val textView = make.view.findViewById<AppCompatTextView>(R.id.snackbar_text)
        textView.setTextColor(requireContext().getColorFromResource(R.color.white))
        make.setAction(R.string.label_ok)
        {
            // Request permission
            if (view != null) {
                if (arguments?.getString(Common.Params.IS_FROM_HOME).equals("1")) {
                    navigator.loadActivity(HomeActivity::class.java).byFinishingAll()
                        .start()
                }
            }
        }
            .show()
 showMessage(
             "Successfully get data from google fit",
             snackBarListener = object : BaseActivity.SnackBarListener {
                 override fun onDismiss() {
                     if (view != null) {
                         if (arguments?.getString(Common.Params.IS_FROM_HOME).equals("1")) {
                             navigator.loadActivity(HomeActivity::class.java).byFinishingAll()
                                 .start()
                         }
                     }
                 }
             })

    }

    private fun subscribe() {
        // To create a subscription, invoke the Recording API. As soon as the subscription is
        // active, fitness data will start recording.
        Fitness.getRecordingClient(requireActivity(), getGoogleAccount())
            .subscribe(DataType.TYPE_STEP_COUNT_CUMULATIVE)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
//                    Log.i(TAG, "Successfully subscribed!")
                    appPreferences.putBoolean(Common.IS_GOOGLE_FIT_INTEGRATED, true)
                    appPreferences.putString(
                        Common.HEALTH_CONNECTED_DEVICE,
                        Common.HealthDevice.GOOGLE_FIT
                    )

//                    startBroadCast()
                    if (!arguments?.getString(Common.Params.IS_FROM_HOME).equals("1")) {
                        jobSchedulerDemo()
                    }
                    readData()
                } else {
//                    Log.w(TAG, "There was a problem subscribing.", task.exception)
                }
            }

        Fitness.getRecordingClient(requireActivity(), getGoogleAccount())
            .subscribe(DataType.TYPE_ACTIVITY_SEGMENT);
    }

    private fun jobSchedulerDemo() {

        // workDataOf (part of KTX) converts a list of pairs to a [Data] object.
  val imageData = workDataOf(Common.KEY_IMAGE_URI to "demo")

          val constraints: Constraints = Constraints.Builder()
              .setRequiredNetworkType(NetworkType.CONNECTED)
              .build()

          val uploadWorkRequest = PeriodicWorkRequestBuilder<UploadWorker>(1, TimeUnit.HOURS)
              .setInputData(imageData)
              .setConstraints(constraints)
              .build()

          WorkManager.getInstance(requireActivity().applicationContext).enqueueUniquePeriodicWork(
              "google fit",
              ExistingPeriodicWorkPolicy.REPLACE, uploadWorkRequest
          )


    }


    private fun startBroadCast() {
        val alarmIntent = Intent(requireActivity().applicationContext, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            requireActivity().applicationContext,
            AlarmReceiver.REQUEST_ALARAM_CODE,
            alarmIntent,
            PendingIntent.FLAG_UPDATE_CURRENT
        )
        val manager = activity?.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val interval = 5L

        manager?.setInexactRepeating(
            AlarmManager.RTC_WAKEUP,
            System.currentTimeMillis(),
            interval,
            pendingIntent
        )
        Toast.makeText(requireActivity().applicationContext, "Alarm Set", Toast.LENGTH_SHORT).show()
//        Log.e("Alarm ", "Set")

    }

    override fun onAuthFinished(result: AuthenticationResult?) {
//        navigator.load(ActivitiesFragment::class.java).replace(false)


        Thread {
            // Do network action in this function
            try {
                val dateFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)
                val url = String.format(
                    "https://api.fitbit.com/1/user/%s/activities/date/%s.json",
                    AuthenticationManager.getCurrentAccessToken().userId,
                    dateFormat.format(Date())
                )

                APIUtils.validateToken(
                    activity,
                    AuthenticationManager.getCurrentAccessToken(),
                    *arrayOf(Scope.activity)
                )
//                Log.e("url", url)
                val request: BasicHttpRequest = AuthenticationManager
                    .createSignedRequest()
                    .setContentType("Application/json")
                    .setUrl(url)
                    .build()
                val response: BasicHttpResponse = request.execute()
                val responseCode: Int = response.getStatusCode()
                val json: String = response.getBodyAsString()
                if (response.isSuccessful()) {
                    this.activity?.runOnUiThread {
                        val resource: DailyActivitySummary =
                            Gson().fromJson(json, DailyActivitySummary::class.java)
                        callSetData(resource)
                        appPreferences.putString(
                            Common.HEALTH_CONNECTED_DEVICE,
                            Common.HealthDevice.FITBIT
                        )

                    }

//                ResourceLoaderResult.onSuccess(resource)
                } else {
                    if (responseCode == 401) {
                        if (AuthenticationManager.getAuthenticationConfiguration().isLogoutOnAuthFailure) {
                            // Token may have been revoked or expired
                            callLogout()
                        } else {

                        }
//                    ResourceLoaderResult.onLoggedOut()
                    } else {
                    val errorMessage = String.format(
                        Locale.ENGLISH,
                        "Error making request:%s\tHTTP Code:%d%s\tResponse Body:%s%s%s\n",
                        ResourceLoader.EOL,
                        responseCode,
                        ResourceLoader.EOL,
                        ResourceLoader.EOL,
                        json,
                        ResourceLoader.EOL
                    )


//                    ResourceLoaderResult.onError(errorMessage)
                    }
                }
            } catch (e: Exception) {
                showExeption(e)
//            ResourceLoaderResult.onException(e)
            }

        }.start()


    }

    private fun showExeption(e: Exception) {
        Log.e("exeption", e.toString())
        showMessage(e.toString())
    }

    private fun callLogout() {
        AuthenticationManager.login(this)
    }

    private fun callSetData(resource: DailyActivitySummary) {
        if (!arguments?.getString(Common.Params.IS_FROM_HOME).equals("1")) {
            jobSchedulerDemo()
        }
        val steps = "Total steps: ${resource.summary.steps}".toString()
        val cal = "Total cal: ${resource.summary.activityCalories}".toString()
        val activty =
            "Total Activity: ${resource.summary.fairlyActiveMinutes + resource.summary.veryActiveMinutes}".toString()
//        textViewTotalSteps.format(steps)
//        textViewTotalCal.format(cal)
//        textViewTotalActivity.format(activty)
        Log.e(
            "rourse",
            "Active calories: ".plus(resource.summary.activityCalories.toString()).plus("steps:  ")
                .plus(resource.summary.steps)
                .plus("active minutes:  ").plus(resource.summary.fairlyActiveMinutes)
        )


        val make = Snackbar.make(
            requireView(),
            "Successfully get data from FitBit",
            Snackbar.LENGTH_INDEFINITE
        )
        val textView = make.view.findViewById<AppCompatTextView>(R.id.snackbar_text)
        textView.setTextColor(requireContext().getColorFromResource(R.color.white))
        make.setAction(R.string.label_ok)
        {
            // Request permission
            if (view != null) {
                if (arguments?.getString(Common.Params.IS_FROM_HOME).equals("1")) {
                    navigator.loadActivity(HomeActivity::class.java).byFinishingAll()
                        .start()
                }
            }
        }
            .show()
    }

}*/
