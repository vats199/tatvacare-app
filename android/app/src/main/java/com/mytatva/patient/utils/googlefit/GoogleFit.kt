package com.mytatva.patient.utils.googlefit

import android.Manifest
import android.app.Activity.RESULT_OK
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.auth.api.signin.GoogleSignInOptionsExtension
import com.google.android.gms.fitness.Fitness
import com.google.android.gms.fitness.FitnessActivities
import com.google.android.gms.fitness.FitnessOptions
import com.google.android.gms.fitness.data.DataPoint
import com.google.android.gms.fitness.data.DataSet
import com.google.android.gms.fitness.data.DataSource
import com.google.android.gms.fitness.data.DataType
import com.google.android.gms.fitness.data.Field
import com.google.android.gms.fitness.data.HealthDataTypes
import com.google.android.gms.fitness.data.HealthFields
import com.google.android.gms.fitness.data.Session
import com.google.android.gms.fitness.data.SleepStages
import com.google.android.gms.fitness.request.DataDeleteRequest
import com.google.android.gms.fitness.request.DataReadRequest
import com.google.android.gms.fitness.request.DataUpdateRequest
import com.google.android.gms.fitness.request.SessionInsertRequest
import com.google.android.gms.fitness.request.SessionReadRequest
import com.google.gson.Gson
import com.mytatva.patient.R
import com.mytatva.patient.core.AppConstants
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.formatToDateTime
import com.mytatva.patient.utils.formatToDecimalPoint
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.inject.Singleton

/**
 * This enum is used to define actions that can be performed after a successful sign in to Fit.
 * One of these values is passed to the Fit sign-in, and returned in a successful callback, allowing
 * subsequent execution of the desired action.
 */
enum class FitActionRequestCode {
    INSERT_AND_READ_DATA/*,
    UPDATE_AND_READ_DATA,
    DELETE_DATA*/
}

@Singleton
class GoogleFit @Inject constructor(val context: Context) {

    companion object {
        private const val REQUEST_CHECK_PERMISSION_RECOGNITION = 101
        private const val REQUEST_GOOGLE_AUTH = 102
    }

    var activity: BaseActivity? = null
    private val TAG = GoogleFit::class.java.simpleName

    /* private val fitnessOptions: GoogleSignInOptionsExtension = FitnessOptions.builder()
         //goals
         .addDataType(DataType.TYPE_STEP_COUNT_CUMULATIVE, FitnessOptions.ACCESS_READ) // steps
         .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ) // steps
         .addDataType(DataType.TYPE_SLEEP_SEGMENT, FitnessOptions.ACCESS_READ) // sleep
         //.addDataType(DataType.TYPE_HYDRATION, FitnessOptions.ACCESS_READ) // water
         //readings
         //.addDataType(HealthDataTypes.TYPE_BLOOD_GLUCOSE, FitnessOptions.ACCESS_READ) //bloodglucose
         //.addDataType(HealthDataTypes.TYPE_OXYGEN_SATURATION, FitnessOptions.ACCESS_READ) // SPO2
         //.addDataType(HealthDataTypes.TYPE_BLOOD_PRESSURE, FitnessOptions.ACCESS_READ)//blpressure
         //.addDataType(DataType.TYPE_HEART_RATE_BPM, FitnessOptions.ACCESS_READ) // heart rate
         //.addDataType(DataType.TYPE_WEIGHT, FitnessOptions.ACCESS_READ) // weight-BMI
         //.addDataType(DataType.TYPE_HEIGHT, FitnessOptions.ACCESS_READ) // height-BMI
         .build()*/

    private val fitnessOptions: GoogleSignInOptionsExtension = FitnessOptions.builder()
        .accessSleepSessions(FitnessOptions.ACCESS_WRITE)
        .accessSleepSessions(FitnessOptions.ACCESS_READ)
        //goals
        .addDataType(DataType.TYPE_STEP_COUNT_CUMULATIVE, FitnessOptions.ACCESS_READ) // steps
        .addDataType(DataType.TYPE_STEP_COUNT_CUMULATIVE, FitnessOptions.ACCESS_WRITE)
        .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_READ) // steps
        .addDataType(DataType.TYPE_STEP_COUNT_DELTA, FitnessOptions.ACCESS_WRITE)
        .addDataType(DataType.TYPE_SLEEP_SEGMENT, FitnessOptions.ACCESS_READ) // sleep
        .addDataType(DataType.TYPE_SLEEP_SEGMENT, FitnessOptions.ACCESS_WRITE)
        .addDataType(DataType.TYPE_HYDRATION, FitnessOptions.ACCESS_READ) // water
        .addDataType(DataType.TYPE_HYDRATION, FitnessOptions.ACCESS_WRITE)
        //readings
        .addDataType(DataType.TYPE_DISTANCE_DELTA, FitnessOptions.ACCESS_READ) // walk distance
        .addDataType(DataType.TYPE_DISTANCE_DELTA, FitnessOptions.ACCESS_WRITE)
        .addDataType(HealthDataTypes.TYPE_BLOOD_GLUCOSE, FitnessOptions.ACCESS_READ) //bloodglucose
        .addDataType(HealthDataTypes.TYPE_BLOOD_GLUCOSE, FitnessOptions.ACCESS_WRITE)
        .addDataType(HealthDataTypes.TYPE_OXYGEN_SATURATION, FitnessOptions.ACCESS_READ) // SPO2
        .addDataType(HealthDataTypes.TYPE_OXYGEN_SATURATION, FitnessOptions.ACCESS_WRITE)
        .addDataType(HealthDataTypes.TYPE_BLOOD_PRESSURE, FitnessOptions.ACCESS_READ)//blpressure
        .addDataType(HealthDataTypes.TYPE_BLOOD_PRESSURE, FitnessOptions.ACCESS_WRITE)
        //.addDataType(DataType.TYPE_HEART_RATE_BPM, FitnessOptions.ACCESS_READ) // heart rate//
        //.addDataType(DataType.TYPE_HEART_RATE_BPM, FitnessOptions.ACCESS_WRITE)
        .addDataType(DataType.TYPE_WEIGHT, FitnessOptions.ACCESS_READ) // weight-BMI
        .addDataType(DataType.TYPE_WEIGHT, FitnessOptions.ACCESS_WRITE)
        //.addDataType(DataType.TYPE_HEIGHT, FitnessOptions.ACCESS_READ) // height-BMI
        //.addDataType(DataType.TYPE_HEIGHT, FitnessOptions.ACCESS_WRITE)
        .addDataType(DataType.TYPE_CALORIES_EXPENDED, FitnessOptions.ACCESS_READ) // calories
        .addDataType(DataType.TYPE_CALORIES_EXPENDED, FitnessOptions.ACCESS_WRITE)
        .addDataType(
            DataType.TYPE_ACTIVITY_SEGMENT,
            FitnessOptions.ACCESS_READ
        ) // physical activity
        .addDataType(DataType.TYPE_ACTIVITY_SEGMENT, FitnessOptions.ACCESS_WRITE)
        .build()

    private fun getGoogleAccount() = GoogleSignIn.getAccountForExtension(activity, fitnessOptions)

    val hasAllPermissions: Boolean
        get() {
            return hasPermission() && oAuthPermissionsApproved()
        }

    private fun oAuthPermissionsApproved() =
        GoogleSignIn.hasPermissions(getGoogleAccount(), fitnessOptions)

    var onPermissionAllowed: (() -> Unit)? = null

    fun initializeFit(onPermissionAllowed: (() -> Unit)) {
        this.onPermissionAllowed = onPermissionAllowed
        if (hasPermission(isNeedToRequest = true)) {
            fitSignIn(FitActionRequestCode.INSERT_AND_READ_DATA)
        }
    }

    /**
     * Checks that the user is signed in, and if so, executes the specified function. If the user is
     * not signed in, initiates the sign in flow, specifying the post-sign in function to execute.
     *
     * @param requestCode The request code corresponding to the action to perform after sign in.
     */
    private fun fitSignIn(requestCode: FitActionRequestCode) {
        if (oAuthPermissionsApproved()) {
            onPermissionAllowed?.invoke()
            /*performActionForRequestCode(requestCode)*/
        } else {
            requestCode.let {
                GoogleSignIn.requestPermissions(
                    activity,
                    REQUEST_GOOGLE_AUTH,
                    getGoogleAccount(), fitnessOptions
                )
            }
        }
    }

    /**
     * Handles the callback from the OAuth sign in flow, executing the post sign in function
     */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        when (resultCode) {
            RESULT_OK -> {
                /*val postSignInAction = FitActionRequestCode.values()[requestCode]
                postSignInAction.let {
                    onPermissionAllowed?.invoke()
                    *//*performActionForRequestCode(postSignInAction)*//*
                }*/

                if (requestCode == REQUEST_GOOGLE_AUTH) {
                    onPermissionAllowed?.invoke()
                    /*performActionForRequestCode(postSignInAction)*/
                }
            }

            else -> oAuthErrorMsg(requestCode, resultCode)
        }
    }

    /**
     * Handles the onRequestPermissionsResult
     */
    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        when (requestCode) {
            REQUEST_CHECK_PERMISSION_RECOGNITION -> {
                if (PermissionUtil.verifyPermissions(grantResults)) {
                    fitSignIn(FitActionRequestCode.INSERT_AND_READ_DATA)
                }
            }

            else -> {

            }
        }
    }

    /**
     * Runs the desired method, based on the specified request code. The request code is typically
     * passed to the Fit sign-in flow, and returned with the success callback. This allows the
     * caller to specify which method, post-sign-in, should be called.
     *
     * @param requestCode The code corresponding to the action to perform.
     */
    private fun performActionForRequestCode(requestCode: FitActionRequestCode) =
        when (requestCode) {
            FitActionRequestCode.INSERT_AND_READ_DATA -> /*insertAndReadData()*/ readDataForLoop()
            //FitActionRequestCode.UPDATE_AND_READ_DATA -> updateAndReadData()
            //FitActionRequestCode.DELETE_DATA -> deleteData()
        }

    private fun oAuthErrorMsg(requestCode: Int, resultCode: Int) {
        val message = """
            There was an error signing into Fit. Check the troubleshooting section of the README
            for potential issues.
            Request code was: $requestCode
            Result code was: $resultCode
        """.trimIndent()
        Log.d(TAG, message)
    }

    /**
     * Disconnet from google fit
     */
    fun disconnectWithAlert(callback: (isSuccess: Boolean) -> Unit) {
        activity?.let {
            /*  Fitness.getConfigClient(it, getGoogleAccount())
                  .disableFit()
                  .addOnSuccessListener {
                      Log.i(TAG, "Disabled Google Fit")
                      if (Fitness.getConfigClient(activity!!, getGoogleAccount())
                              .disableFit().isSuccessful
                      ) {
                         // callback.invoke(true)
                      } else {
                          Log.d(TAG,
                              "There was an error :: ${
                                  Fitness.getConfigClient(activity!!, getGoogleAccount())
                                      .disableFit().exception?.cause
                              }")
                          Fitness.getConfigClient(activity!!, getGoogleAccount())
                              .disableFit().exception?.printStackTrace()
                         // callback.invoke(false)
                      }
                  }
                  .addOnFailureListener { e ->
                     *//* Log.w(TAG, "There was an error disabling Google Fit", e)
                    if (Fitness.getConfigClient(activity!!, getGoogleAccount())
                            .disableFit().isSuccessful
                    ) {
                        callback.invoke(true)
                    } else {
                        callback.invoke(false)
                    }*//*
                }.addOnCanceledListener {

                    Log.d(TAG, "cancelled ::")

                }.addOnCompleteListener {
                    if (it.isSuccessful) {
                      //  callback.invoke(true)
                        Log.d(TAG, "false")
                    } else {
                        //callback.invoke(false)
                        Log.d(TAG, "false")
                    }

                    Log.d(TAG, "success msg :: ${it.exception?.message}")
                    Log.d(TAG, "success cause :: ${it.exception?.cause}")
                    it.exception?.printStackTrace()
                }*/
        }

        activity?.showAlertDialogWithOptions("Are you sure want to disconnect from Google Fit?",
            dialogYesNoListener = object : BaseActivity.DialogYesNoListener {
                override fun onYesClick() {
                    // do disconnect
                    disconnect(callback)

                }

                override fun onNoClick() {
                }
            })

    }

    fun disconnect(callback: (isSuccess: Boolean) -> Unit) {
        try {
            activity?.showLoader()
        } catch (e: Exception) {
        }
        val signInOptions =
            GoogleSignInOptions.Builder().addExtension(fitnessOptions).build()
        val client = GoogleSignIn.getClient(context, signInOptions)
        client.revokeAccess()
            .addOnCompleteListener {

                /*Log.d(TAG, "is successful disable fit :: ${
                    Fitness.getConfigClient(activity, getGoogleAccount())
                        .disableFit().isSuccessful
                }")*/

                Log.d(TAG, "complete cause :: ${it.exception?.cause}")
                Log.d(TAG, "complete msg :: ${it.exception?.message}")
                try {
                    activity?.hideLoader()
                } catch (e: java.lang.Exception) {
                }
                if (it.isSuccessful) {
                    callback.invoke(true)
                } else {
                    callback.invoke(false)
                }
            }
            .addOnCanceledListener {
                Log.d(TAG, "cancelled msg :: ")
            }
            .addOnSuccessListener {
                Log.d(TAG, "success msg :: ")
            }
            .addOnFailureListener {
                Log.d(TAG, "failure msg :: ${it.message}")
            }
    }

    fun readDataForLoop() {
        val cal = Calendar.getInstance()
        cal.set(Calendar.HOUR_OF_DAY, 22)
        cal.set(Calendar.MINUTE, 59)
        cal.set(Calendar.SECOND, 60)
        val endTime = cal.time.time
        cal.add(Calendar.DAY_OF_YEAR, -7)
        cal.set(Calendar.HOUR_OF_DAY, 0)
        cal.set(Calendar.MINUTE, 0)
        cal.set(Calendar.SECOND, 0)
        val startTime = cal.time.time

        //GOALS
        val goals = arrayListOf<Goals>()
        goals.add(Goals.Steps)
        goals.add(Goals.Sleep)
        goals.add(Goals.WaterIntake)

        /*getStepRecords(startTime, endTime) { stepsList ->
            getSleepRecords(startTime, endTime) { sleepList ->
                getWaterRecords(startTime, endTime) { waterList ->

                }
            }
        }*/

        //READINGS
        val readings = arrayListOf<Readings>()
        readings.add(Readings.SPO2)
        readings.add(Readings.BloodGlucose)
        readings.add(Readings.BloodPressure)
        readings.add(Readings.HeartRate)
        //readings.add(Readings.BMI) height weight


        /*getSpo2Records(startTime, endTime) { spo2List ->
            getBloodGlucoseRecords(startTime, endTime) { bloodGlucoseList ->
                getBloodPressureRecords(startTime, endTime) { bloodPressureList ->
                    getHeartRateRecords(startTime, endTime) { heartRateList ->
                        getBodyWeightRecords(startTime, endTime) { weightList ->

                        }
                    }
                }
            }
        }*/

    }

    fun readGoals(
        updatedAt: Calendar,
        callback: (goalsList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        //endTime
        val cal = Calendar.getInstance()
        cal.set(Calendar.HOUR_OF_DAY, 22)
        cal.set(Calendar.MINUTE, 59)
        cal.set(Calendar.SECOND, 60)
        val endTime = cal.time.time

        //startTime
        //cal.add(Calendar.DAY_OF_YEAR, -7)
        updatedAt.set(Calendar.HOUR_OF_DAY, 0)
        updatedAt.set(Calendar.MINUTE, 0)
        updatedAt.set(Calendar.SECOND, 0)
        val startTime = updatedAt.time.time

        val list = ArrayList<ApiRequestSubData>()

        getStepRecords(startTime, endTime) { stepsList ->
            list.addAll(stepsList)

            getSleepRecords(startTime, endTime) { sleepList ->
                list.addAll(sleepList)

                getWaterRecords(startTime, endTime) { waterList ->
                    list.addAll(waterList)

                    getActivityExericseRecords(startTime, endTime) { activityList ->
                        list.addAll(activityList/*.filter { it.achieved_datetime?.contains("2023-10-31") == true }*/)

                        list.forEach { apiRequestSubData ->
                            Log.d(
                                "goal",
                                Gson().toJson(apiRequestSubData, ApiRequestSubData::class.java)
                            )
                        }

                        /*val tempList = arrayListOf<ApiRequestSubData>()
                        for (i in 0..200) {
                            tempList.addAll(list)
                        }*/

                        callback.invoke(ArrayList(list.reversed()))

                    }
                }
            }
        }

    }

    fun readReadings(
        updatedAt: Calendar,
        calForCaloriesConsumed: Calendar,
        callback: (readingsList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        //endTime
        val cal = Calendar.getInstance()
        cal.set(Calendar.HOUR_OF_DAY, 22)
        cal.set(Calendar.MINUTE, 59)
        cal.set(Calendar.SECOND, 60)
        val endTime = cal.time.time

        //startTime
        //cal.add(Calendar.DAY_OF_YEAR, -7)
        updatedAt.set(Calendar.HOUR_OF_DAY, 0)
        updatedAt.set(Calendar.MINUTE, 0)
        updatedAt.set(Calendar.SECOND, 0)
        val startTime = updatedAt.time.time

        //startTime for calories, same as last sync time, no need to change in time to 0 for calories
        calForCaloriesConsumed.set(Calendar.HOUR_OF_DAY, 0)
        calForCaloriesConsumed.set(Calendar.MINUTE, 0)
        calForCaloriesConsumed.set(Calendar.SECOND, 0)
        val startTimeCalories = calForCaloriesConsumed.time.time

        val list = ArrayList<ApiRequestSubData>()

        getSpo2Records(startTime, endTime) { spo2List ->
            list.addAll(spo2List)
            getBloodGlucoseRecords(startTime, endTime) { bloodGlucoseList ->
                list.addAll(bloodGlucoseList)
                getBloodPressureRecords(startTime, endTime) { bloodPressureList ->
                    list.addAll(bloodPressureList)

                    /*getHeartRateRecords(startTime, endTime) { heartRateList ->
                        list.addAll(heartRateList)*/

                    getBodyWeightRecords(startTime, endTime) { weightList ->
                        list.addAll(weightList)

                        getCaloriesBurnedRecords(startTimeCalories, endTime) { caloriesList ->
                            list.addAll(caloriesList)

                            list.forEach { apiRequestSubData ->
                                Log.d(
                                    "reading",
                                    Gson().toJson(apiRequestSubData, ApiRequestSubData::class.java)
                                )
                            }
                            callback.invoke(ArrayList(list.reversed()))

                        }
                    }

                    /*}*/

                }
            }
        }

    }


    private fun hasPermission(isNeedToRequest: Boolean = false): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            val permissions = arrayListOf<String>()

            if (ActivityCompat.checkSelfPermission(
                    activity!!,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                permissions.add(Manifest.permission.ACCESS_COARSE_LOCATION)
            }

            if (ActivityCompat.checkSelfPermission(
                    activity!!,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                permissions.add(Manifest.permission.ACCESS_FINE_LOCATION)
            }

            if (ActivityCompat.checkSelfPermission(
                    activity!!,
                    Manifest.permission.ACTIVITY_RECOGNITION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    permissions.add(Manifest.permission.ACTIVITY_RECOGNITION)
                }
            }

            if (permissions.isNotEmpty()) {
                if (isNeedToRequest) {
                    activity?.requestPermissions(
                        permissions.toTypedArray(),
                        REQUEST_CHECK_PERMISSION_RECOGNITION
                    )
                }
                return false
            } else {
                return true
            }

        } else
            return true
    }

    /**
     * read goal methods
     */
    fun getStepRecords(
        startTime: Long, endTime: Long,
        callback: (stepsList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        val datasource = DataSource.Builder()
            .setAppPackageName("com.google.android.gms")
            .setDataType(DataType.TYPE_STEP_COUNT_DELTA)
            .setType(DataSource.TYPE_DERIVED)
            .setStreamName("estimated_steps")
            .build()

        //steps
        val readRequest = DataReadRequest.Builder()
            //.read(DataType.TYPE_STEP_COUNT_DELTA)
            .aggregate(datasource /*DataType.TYPE_STEP_COUNT_DELTA*/)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_STEPS: ${dataPoint.getValue(Field.FIELD_STEPS)}"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                try {

                                    val cal = Calendar.getInstance()
                                    cal.timeInMillis =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        ).date?.time!!
                                    cal.set(Calendar.HOUR_OF_DAY, 0)
                                    cal.set(Calendar.MINUTE, 0)
                                    cal.set(Calendar.SECOND, 0)

                                    list.add(ApiRequestSubData().apply {
                                        source_name = dataPoint.originalDataSource.streamName
                                        achieved_value =
                                            dataPoint.getValue(Field.FIELD_STEPS).toString()
                                        source_id = dataPoint.originalDataSource.appPackageName
                                        goal_key = Goals.Steps.goalKey
                                        achieved_datetime = DateTimeFormatter.date(cal.time)
                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    })
                                    Log.d(
                                        "achieved", "Steps DateTime :: ${
                                            DateTimeFormatter.date(cal.time)
                                                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                        }"
                                    )

                                } catch (e: Exception) {
                                    e.printStackTrace()
                                }

                            }
                        }
                    }
                }

                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.w(TAG, "There was a problem getting the step count.", it)
                callback.invoke(list)
            }

    }

    fun getSleepRecords(
        startTime: Long, endTime: Long,
        callback: (sleepList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        //temp start-end time
        /*val tempStartTime = Calendar.getInstance()
        val tempEndTime = Calendar.getInstance()
        tempStartTime.timeInMillis = Calendar.getInstance().apply {
            set(Calendar.DAY_OF_YEAR, -10)
        }.timeInMillis*/

        val request = SessionReadRequest.Builder()
            .readSessionsFromAllApps()
            // By default, only activity sessions are included, so it is necessary to explicitly
            // request sleep sessions. This will cause activity sessions to be *excluded*.
            .includeSleepSessions()
            // Sleep segment data is required for details of the fine-granularity sleep, if it is present.
            .read(DataType.TYPE_SLEEP_SEGMENT)
            .setTimeInterval(
                startTime /*tempStartTime.timeInMillis*/,
                endTime /*tempEndTime.timeInMillis*/,
                TimeUnit.MILLISECONDS
            )
            .build()

        Fitness.getSessionsClient(
            activity,
            GoogleSignIn.getAccountForExtension(activity, fitnessOptions)
        )
            .readSession(request)
            .addOnSuccessListener { response ->
                for (session in response.sessions) {
                    val sessionStart = session.getStartTime(TimeUnit.MILLISECONDS)
                    val sessionEnd = session.getEndTime(TimeUnit.MILLISECONDS)
                    Log.d(TAG, "SLEEP::: between $sessionStart and $sessionEnd")

                    val calStartSession = Calendar.getInstance()
                    calStartSession.timeInMillis = sessionStart
                    val calEndSession = Calendar.getInstance()
                    calEndSession.timeInMillis = sessionEnd

                    val hours = DateTimeFormatter.getDiffInHours(calStartSession, calEndSession)
                        .formatToDecimalPoint(2)

                    Log.d(TAG, "SLEEP::: ===============================")
                    Log.d(TAG, "SLEEP::: hours : achieved_value $hours")
                    Log.d(TAG, "SLEEP::: source_name ${session.identifier}")
                    Log.d(TAG, "SLEEP::: source_id ${session.appPackageName}")
                    Log.d(TAG, "SLEEP::: goal_key ${Goals.Sleep.goalKey}")
                    Log.d(
                        TAG, "SLEEP::: start time ${
                            DateTimeFormatter.date(calStartSession.time)
                                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                        }"
                    )
                    Log.d(
                        TAG, "SLEEP::: achieved_datetime ${
                            DateTimeFormatter.date(calEndSession.time)
                                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                        }"
                    )

                    list.add(ApiRequestSubData().apply {
                        source_name = session.identifier
                        achieved_value = hours
                        source_id = session.appPackageName
                        goal_key = Goals.Sleep.goalKey
                        achieved_datetime =
                            DateTimeFormatter.date(calEndSession.time)
                                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)

                        //start_time & end_time params added for resolve time conflict issue in API side
                        start_time = DateTimeFormatter.date(calStartSession.time)
                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                        end_time = DateTimeFormatter.date(calEndSession.time)
                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                    })

                    val SLEEP_STAGE_NAMES = arrayOf(
                        "Unused", "Awake (during sleep)",
                        "Sleep", "Out-of-bed", "Light sleep", "Deep sleep", "REM sleep"
                    )
                    // If the sleep session has finer granularity sub-components, extract them:
                    val dataSets = response.getDataSet(session)
                    for (dataSet in dataSets) {
                        for (point in dataSet.dataPoints) {
                            val sleepStageVal =
                                point.getValue(Field.FIELD_SLEEP_SEGMENT_TYPE).asInt()
                            val sleepStage = SLEEP_STAGE_NAMES[sleepStageVal]
                            val segmentStart = point.getStartTime(TimeUnit.MILLISECONDS)
                            val segmentEnd = point.getEndTime(TimeUnit.MILLISECONDS)
                            Log.d(
                                TAG,
                                "* SLEEP::: Type $sleepStage between $segmentStart and $segmentEnd"
                            )
                        }
                    }
                }

                callback.invoke(list)
            }.addOnFailureListener {
                callback.invoke(list)
            }


        //sleep
        /*val readRequestSleep = DataReadRequest.Builder()
            .read(DataType.TYPE_SLEEP_SEGMENT)
            .bucketByTime(1, TimeUnit.DAYS)
            //.bucketByActivityType(1, TimeUnit.DAYS)
            //.bucketBySession(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        //FIELD_TEMPORAL_RELATION_TO_SLEEP
        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequestSleep)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {

                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            //+ "\nFIELD_STEPS: ${dataPoint.getValue(Field.zzmz)}"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(Date(dataPoint.getTimestamp(
                                            TimeUnit.MILLISECONDS)))
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                list.add(ApiRequestSubData().apply {
                                    source_name = dataPoint.originalDataSource.streamName
                                    achieved_value =
                                        dataPoint.getValue(Field.FIELD_SLEEP_SEGMENT_TYPE)
                                            .toString()
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    goal_key = Goals.Sleep.goalKey
                                    achieved_datetime =
                                        DateTimeFormatter.date(Date(dataPoint.getTimestamp(
                                            TimeUnit.MILLISECONDS)))
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })

                            }
                        }
                    }
                }

                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.w(TAG, "There was a problem getting the step count.", it)
                callback.invoke(list)
            }*/

    }

    fun getWaterRecords(
        startTime: Long, endTime: Long,
        callback: (waterList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        //water
        val readRequestWater = DataReadRequest.Builder()
            .read(DataType.TYPE_HYDRATION)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequestWater)
            .addOnSuccessListener { dataReadResponse ->
                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {

                                val waterLitre =
                                    dataPoint.getValue(Field.FIELD_VOLUME).asFloat()
                                val waterML = waterLitre * 1000
                                val waterNoOfGlass = waterML / AppConstants.WATER_ML_PER_GLASS

                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nWATER_VOLUME: ${dataPoint.getValue(Field.FIELD_VOLUME)}"
                                            + "\nWATER_VOLUME Glass: $waterNoOfGlass"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                list.add(ApiRequestSubData().apply {
                                    source_name = dataPoint.originalDataSource.streamName
                                    achieved_value = waterNoOfGlass.toString()
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    goal_key = Goals.WaterIntake.goalKey
                                    achieved_datetime =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })

                            }
                        }
                    }
                }

                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.w(TAG, "There was a problem getting the step count.", it)
                callback.invoke(list)
            }

    }

    fun getActivityExericseRecords(
        startTime: Long, endTime: Long,
        callback: (activityList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        // physical activity
        val readRequest = DataReadRequest.Builder()
            .read(DataType.TYPE_ACTIVITY_SEGMENT)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_ACTIVITY: ${dataPoint.getValue(Field.FIELD_ACTIVITY)}"
                                            + "\nFIELD_ACTIVITY as Name: ${
                                        dataPoint.getValue(Field.FIELD_ACTIVITY).asActivity()
                                    }"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(Date(dataPoint.getTimestamp(TimeUnit.MILLISECONDS)))
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                            + "\nstartTime: ${
                                        DateTimeFormatter.date(Date(dataPoint.getStartTime(TimeUnit.MILLISECONDS)))
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                            + "\nendTime: ${
                                        DateTimeFormatter.date(Date(dataPoint.getEndTime(TimeUnit.MILLISECONDS)))
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )


                                try {
                                    val calStart = Calendar.getInstance()
                                    calStart.timeInMillis =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getStartTime(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        ).date?.time!!

                                    val calEnd = Calendar.getInstance()
                                    calEnd.timeInMillis =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getEndTime(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        ).date?.time!!

                                    val diffInMs = calEnd.timeInMillis - calStart.timeInMillis
                                    val durationInMin =
                                        TimeUnit.MILLISECONDS.toMinutes(diffInMs).toInt()

                                    list.add(ApiRequestSubData().apply {
                                        source_name = dataPoint.originalDataSource.streamName
                                        source_id = dataPoint.originalDataSource.appPackageName

                                        goal_key = Goals.Exercise.goalKey
                                        achieved_value = durationInMin.toString() // diff in minutes

                                        patient_sub_goal_id =
                                            dataPoint.getValue(Field.FIELD_ACTIVITY)
                                                .toString()//.asActivity()

                                        achieved_datetime = DateTimeFormatter.date(calStart.time)
                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                        start_time = DateTimeFormatter.date(calStart.time)
                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                        end_time = DateTimeFormatter.date(calEnd.time)
                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    })
                                    /*Log.d(
                                        TAG, "ACTIVITY_DATA\n" +
                                                "source_name : ${dataPoint.originalDataSource.streamName}\n" +
                                                "source_id : ${dataPoint.originalDataSource.appPackageName}\n" +
                                                "goal_key : ${Goals.Exercise.goalKey}\n" +
                                                "sub_goal_key : ${dataPoint.getValue(Field.FIELD_ACTIVITY)}:: ${dataPoint.getValue(Field.FIELD_ACTIVITY).asActivity()}\n" +
                                                "achieved_value (in min) : $durationInMin\n" +
                                                "achieved_datetime : ${
                                                    DateTimeFormatter.date(calStart.time)
                                                        .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                                }\n" +
                                                "end_datetime : ${
                                                    DateTimeFormatter.date(calEnd.time)
                                                        .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                                }\n"
                                    )*/
                                    Log.d(
                                        TAG, "====================================\n" +
                                                "ACTIVITY_DATA ==>\n" +
                                                "source_name : ${dataPoint.originalDataSource.streamName}\n" +
                                                "source_id : ${dataPoint.originalDataSource.appPackageName}\n" +
                                                "goal_key : ${Goals.Exercise.goalKey}\n" +
                                                "sub_goal_key (intValue :: stringKey) : ${
                                                    dataPoint.getValue(
                                                        Field.FIELD_ACTIVITY
                                                    )
                                                } :: ${
                                                    dataPoint.getValue(Field.FIELD_ACTIVITY)
                                                        .asActivity()
                                                }\n" +
                                                "achieved_value (in min) : $durationInMin\n" +
                                                "start_datetime : ${
                                                    DateTimeFormatter.date(calStart.time)
                                                        .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                                }\n" +
                                                "end_datetime : ${
                                                    DateTimeFormatter.date(calEnd.time)
                                                        .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                                }\n"
                                    )
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                }

                            }
                        }
                    }
                }

                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the Exercise.", it)
                callback.invoke(list)
            }
    }

    /**
     * read reading methods
     */
    fun getSpo2Records(
        startTime: Long, endTime: Long,
        callback: (spo2List: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        //steps
        val readRequest = DataReadRequest.Builder()
            .read(HealthDataTypes.TYPE_OXYGEN_SATURATION)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_OXYGEN_SATURATION: ${
                                        dataPoint.getValue(HealthFields.FIELD_OXYGEN_SATURATION)
                                    }"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                list.add(ApiRequestSubData().apply {
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    source_name = dataPoint.originalDataSource.streamName
                                    reading_key = Readings.SPO2.readingKey
                                    reading_value =
                                        dataPoint.getValue(HealthFields.FIELD_OXYGEN_SATURATION)
                                            .toString()
                                    reading_datetime =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })

                            }
                        }
                    }
                }

                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the SPO2.", it)
                callback.invoke(list)
            }

    }

    fun getBloodGlucoseRecords(
        startTime: Long, endTime: Long,
        callback: (bloodGlucoseList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        //steps
        val readRequest = DataReadRequest.Builder()
            .read(HealthDataTypes.TYPE_BLOOD_GLUCOSE)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_BLOOD_GLUCOSE_LEVEL: ${
                                        dataPoint.getValue(HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL)
                                    }"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )


                                var fastStrValue = ""
                                var ppStrValue = ""
                                if (dataPoint?.getValue(HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL)?.isSet == true
                                    && dataPoint.getValue(HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL)
                                        .asInt() == HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL_FASTING
                                ) {
                                    fastStrValue =
                                        dataPoint.getValue(HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL)
                                            .toString()
                                } else if (dataPoint?.getValue(HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL)?.isSet == true
                                    && dataPoint.getValue(HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL)
                                        .asInt() == HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL_AFTER_MEAL
                                ) {
                                    ppStrValue =
                                        dataPoint.getValue(HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL)
                                            .toString()
                                } else {
                                    // nothing set then default after meal value goes in PP blood glucose
                                    // fast bg will be empty
                                    ppStrValue =
                                        dataPoint.getValue(HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL)
                                            .toString()
                                }


                                list.add(ApiRequestSubData().apply {
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    source_name = dataPoint.originalDataSource.streamName
                                    reading_key = Readings.BloodGlucose.readingKey
                                    reading_value_data = ApiRequestSubData().apply {
                                        pp = ppStrValue
                                        fast = fastStrValue
                                    }
                                    reading_datetime =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })

                            }
                        }
                    }
                }
                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the TYPE_BLOOD_GLUCOSE.", it)
                callback.invoke(list)
            }

    }

    fun getBloodPressureRecords(
        startTime: Long, endTime: Long,
        callback: (bloodPressureList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        //steps
        val readRequest = DataReadRequest.Builder()
            .read(HealthDataTypes.TYPE_BLOOD_PRESSURE)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_BLOOD_PRESSURE_DIASTOLIC: ${
                                        dataPoint.getValue(HealthFields.FIELD_BLOOD_PRESSURE_DIASTOLIC)
                                    }"
                                            + "\nFIELD_BLOOD_PRESSURE_SYSTOLIC: ${
                                        dataPoint.getValue(HealthFields.FIELD_BLOOD_PRESSURE_SYSTOLIC)
                                    }"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                list.add(ApiRequestSubData().apply {
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    source_name = dataPoint.originalDataSource.streamName
                                    reading_key = Readings.BloodPressure.readingKey
                                    reading_value_data = ApiRequestSubData().apply {
                                        diastolic =
                                            dataPoint.getValue(HealthFields.FIELD_BLOOD_PRESSURE_DIASTOLIC)
                                                .toString()
                                        systolic =
                                            dataPoint.getValue(HealthFields.FIELD_BLOOD_PRESSURE_SYSTOLIC)
                                                .toString()
                                    }
                                    reading_datetime =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })

                            }
                        }
                    }
                }
                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the TYPE_BLOOD_GLUCOSE.", it)
                callback.invoke(list)
            }

    }

    //Removed to sync heart rate, as widget changed to "Resting Heart Rate" from "Heart Rate"
    //Jira Ref Link: https://digicare123.atlassian.net/browse/MT-463
    //Date: 04-01-2023
    fun getHeartRateRecords(
        startTime: Long, endTime: Long,
        callback: (heartRateList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        /** ******************************************************************
         * Tried code of read request for fetch resting heart rate
         * Reference Links :-
         * 1.https://stackoverflow.com/a/68400366
         * 2.https://github.com/StasDoskalenko/react-native-google-fit/pull/325
         * But currently resting heart rate is not in Google fit Android App,
         * it's there in Google fit iOS app only, as mentioned in below
         * stackoverflow question.
         * Link :- https://stackoverflow.com/q/58714865
         *******************************************************************/

        /*val readRequest: DataReadRequest = DataReadRequest.Builder()
            .aggregate(DataSource.Builder()
                .setType(DataSource.TYPE_DERIVED)
                .setDataType(DataType.TYPE_HEART_RATE_BPM)
                .setAppPackageName("com.google.android.gms")
                .setStreamName("resting_heart_rate<-merge_heart_rate_bpm")
                .build())
            .read(DataType.TYPE_HEART_RATE_BPM)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()*/

        //actual working for normal heart rate
        val readRequest = DataReadRequest.Builder()
            .read(DataType.TYPE_HEART_RATE_BPM)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_BPM: ${
                                        dataPoint.getValue(Field.FIELD_BPM)
                                    }"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                list.add(ApiRequestSubData().apply {
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    source_name = dataPoint.originalDataSource.streamName
                                    reading_key = Readings.HeartRate.readingKey
                                    reading_value =
                                        dataPoint.getValue(Field.FIELD_BPM)
                                            .toString()
                                    reading_datetime =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })

                            }
                        }
                    }
                }

                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the HeartRate.", it)
                callback.invoke(list)
            }

    }

    fun getBodyWeightRecords(
        startTime: Long, endTime: Long,
        callback: (weightList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        //steps
        val readRequest = DataReadRequest.Builder()
            .read(DataType.TYPE_WEIGHT)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_WEIGHT: ${
                                        dataPoint.getValue(Field.FIELD_WEIGHT)
                                    }"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                list.add(ApiRequestSubData().apply {
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    source_name = dataPoint.originalDataSource.streamName
                                    reading_key = Readings.BodyWeight.readingKey
                                    reading_value =
                                        dataPoint.getValue(Field.FIELD_WEIGHT)
                                            .toString()
                                    reading_datetime =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })

                            }
                        }
                    }
                }

                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the SPO2.", it)
                callback.invoke(list)
            }

    }

    fun getWalkDistanceRecords(
        startTime: Long, endTime: Long,
        callback: (distance: Double) -> Unit,
    ) {

        activity?.showLoader()

        val list = arrayListOf<Double>()

        //steps
        /*val readRequest = DataReadRequest.Builder()
            //.read(DataType.TYPE_DISTANCE_DELTA)
            .aggregate(DataType.TYPE_DISTANCE_DELTA)
            .bucketByTime(6, TimeUnit.MINUTES)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.e("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.e(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_DISTANCE: ${
                                        dataPoint.getValue(Field.FIELD_DISTANCE)
                                    }"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(Date(dataPoint.getTimestamp(
                                            TimeUnit.MILLISECONDS)))
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                Log.e(TAG, "**************************************")
                                Log.e(TAG,
                                    "Aggregate value :- ${dataPoint.getValue(Field.FIELD_DISTANCE)}")
                                Log.e(TAG, "**************************************")
                            }
                        }
                    }
                }

                *//*if (list.isNotEmpty()) {
                    callback.invoke(list.last())
                } else {
                    callback.invoke(0.0)
                }*//*


            }
            .addOnFailureListener {
                Log.e(TAG, "There was a problem getting the Distance.", it)
                callback.invoke(0.0)
            }*/

        //list.clear()

        val readRequestTest = DataReadRequest.Builder()
            .read(DataType.TYPE_DISTANCE_DELTA)
            //.aggregate(DataType.TYPE_DISTANCE_DELTA)
            .bucketByTime(1, TimeUnit.MINUTES)
            .setTimeRange(startTime, endTime, TimeUnit.MILLISECONDS)
            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequestTest)
            .addOnSuccessListener { dataReadResponse ->

                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints *** ",
                                    "\n\nstreamName *** : ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields *** : ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier *** : ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype *** : ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName *** : ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice *** : ${dataPoint.originalDataSource.device}"
                                            + "\ndataType *** : ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_OXYGEN_SATURATION *** : ${
                                        dataPoint.getValue(Field.FIELD_DISTANCE)
                                    }"
                                            + "\nDATE *** : ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                if (dataPoint.originalDataSource.streamName.equals("user_input")
                                        .not()
                                ) {
                                    try {
                                        list.add(
                                            dataPoint.getValue(Field.FIELD_DISTANCE).asFloat()
                                                .toDouble()
                                        )
                                    } catch (e: Exception) {
                                        e.printStackTrace()
                                    }
                                }

                            }
                        }
                    }
                }


                if (list.isNotEmpty()) {
                    val total = list.sum()
                    callback.invoke(total)
                    Log.d(TAG, "**************************************")
                    Log.d(TAG, "Total of value except user input :- $total")
                    Log.d(TAG, "**************************************")
                } else {
                    callback.invoke(0.0)
                }
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the Distance.", it)
                //callback.invoke(list)
            }

    }

    fun getCaloriesBurnedRecords(
        startTime: Long, endTime: Long,
        callback: (caloriesBurnedList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

//        val datasource = DataSource.Builder()
//            //.setAppPackageName("com.google.android.gms")
//            .setDataType(DataType.TYPE_CALORIES_EXPENDED)
//            .setType(DataSource.TYPE_RAW)
//            //.setStreamName("estimated_steps")
//            .build()
//
//        //steps
//        val readRequest = DataReadRequest.Builder()
//            //.read(DataType.TYPE_STEP_COUNT_DELTA)
//            .read(datasource)
//            //.bucketByTime(1, TimeUnit.HOURS)
//            .setTimeRange(startTime,Calendar.getInstance().timeInMillis /*endTime*/, TimeUnit.MILLISECONDS)
//            .build()


        /**
         * for calories passing current time only for end time instead of endTime,
         * to get same as google fit calories till this time, as for ednTime it returns total based on end time
         */
        //calories
        val readRequest = DataReadRequest.Builder()
            .aggregate/*read*/(DataType.TYPE_CALORIES_EXPENDED)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(
                startTime,
                Calendar.getInstance().timeInMillis /*endTime*/,
                TimeUnit.MILLISECONDS
            )
            .build()


//        val readRequest = DataReadRequest.Builder()
//            .read(DataType.AGGREGATE_CALORIES_EXPENDED)
//            .bucketByTime(1, TimeUnit.HOURS)
//            .setTimeRange(startTime, Calendar.getInstance().timeInMillis /*endTime*/, TimeUnit.MILLISECONDS)
//            .build()

        Fitness.getHistoryClient(activity, getGoogleAccount())
            .readData(readRequest)
            .addOnSuccessListener { dataReadResponse ->


                var calories = 0f
                var prevDate = ""
                var curDate = ""

                // directly data sets
                /*if(dataReadResponse.dataSets.isNullOrEmpty().not()) {
                    for (dataset in dataReadResponse.dataSets) {
                        Log.d("dataSets", "************************")
                        for (dataPoint in dataset.dataPoints) {
                            Log.d(
                                "dataPoints",
                                "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                        + "\nfields: ${dataPoint?.dataType?.fields}"
                                        + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                        + "\ntype: ${dataPoint.originalDataSource.type}"
                                        + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                        + "\ndevice: ${dataPoint.originalDataSource.device}"
                                        + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                        + "\nFIELD_CALORIES A: ${
                                    dataPoint.getValue(Field.FIELD_CALORIES)
                                }"
                                        + "\nDATE: ${
                                    DateTimeFormatter.date(
                                        Date(
                                            dataPoint.getTimestamp(
                                                TimeUnit.MILLISECONDS
                                            )
                                        )
                                    ).formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                }"
                            )


                            curDate = DateTimeFormatter.date(
                                Date(
                                    dataPoint.getTimestamp(
                                        TimeUnit.MILLISECONDS
                                    )
                                )
                            ).formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd)
                            if(prevDate.isNotEmpty() && prevDate!=curDate) {
                                Log.d("Calorie","FIELD_CALORIES_SUM_V1 $prevDate :: $calories")
                                calories = 0f
                            }
                            prevDate = DateTimeFormatter.date(
                                Date(
                                    dataPoint.getTimestamp(
                                        TimeUnit.MILLISECONDS
                                    )
                                )
                            ).formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd)
                            calories += dataPoint.getValue(Field.FIELD_CALORIES).asFloat()

                            try {
                                val cal = Calendar.getInstance()
                                cal.timeInMillis =
                                    DateTimeFormatter.date(
                                        Date(
                                            dataPoint.getTimestamp(
                                                TimeUnit.MILLISECONDS
                                            )
                                        )
                                    ).date?.time!!

                                if (cal.get(Calendar.HOUR_OF_DAY) == 0
                                    && cal.get(Calendar.MINUTE) == 0
                                    && cal.get(Calendar.SECOND) == 0
                                ) {
                                    cal.add(Calendar.DAY_OF_YEAR, -1)
                                }

                                cal.set(Calendar.HOUR_OF_DAY, 0)
                                cal.set(Calendar.MINUTE, 0)
                                cal.set(Calendar.SECOND, 0)

                                list.add(ApiRequestSubData().apply {
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    source_name = dataPoint.originalDataSource.streamName
                                    reading_key = Readings.CaloriesBurned.readingKey
                                    reading_value = dataPoint.getValue(Field.FIELD_CALORIES).toString()
                                    reading_datetime =
                                        DateTimeFormatter.date(cal.time)
                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })
                                Log.d(
                                    "achieved", "Calories DateTime for API :: ${
                                        DateTimeFormatter.date(cal.time)
                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )
                            } catch (e: Exception) {
                                e.printStackTrace()
                            }

                        }
                    }
                }*/

                Log.d(
                    TAG,
                    "***********************************************************************"
                )
                Log.d(TAG, "data set end, bucket start")
                Log.d(
                    TAG,
                    "***********************************************************************"
                )


                calories = 0f
                prevDate = ""
                curDate = ""
                // data by bucket
                if (!dataReadResponse.buckets.isNullOrEmpty()) {
                    for (bucket in dataReadResponse.buckets) {
                        //Log.d("buckets", "************************")
                        for (dataset in bucket.dataSets) {
                            Log.d("dataSets", "************************")
                            for (dataPoint in dataset.dataPoints) {
                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_CALORIES B: ${
                                        dataPoint.getValue(Field.FIELD_CALORIES)
                                    }"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                curDate = DateTimeFormatter.date(
                                    Date(
                                        dataPoint.getTimestamp(
                                            TimeUnit.MILLISECONDS
                                        )
                                    )
                                )
                                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd)
                                if (prevDate.isNotEmpty() && prevDate != curDate) {
                                    Log.d("Calorie", "FIELD_CALORIES_SUM_V2 $prevDate :: $calories")
                                    calories = 0f
                                }
                                prevDate = DateTimeFormatter.date(
                                    Date(
                                        dataPoint.getTimestamp(
                                            TimeUnit.MILLISECONDS
                                        )
                                    )
                                )
                                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd)
                                calories += dataPoint.getValue(Field.FIELD_CALORIES).asFloat()



                                try {
                                    val cal = Calendar.getInstance()
                                    cal.timeInMillis =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        ).date?.time!!

                                    if (cal.get(Calendar.HOUR_OF_DAY) == 0
                                        && cal.get(Calendar.MINUTE) == 0
                                        && cal.get(Calendar.SECOND) == 0
                                    ) {
                                        cal.add(Calendar.DAY_OF_YEAR, -1)
                                    }

                                    cal.set(Calendar.HOUR_OF_DAY, 0)
                                    cal.set(Calendar.MINUTE, 0)
                                    cal.set(Calendar.SECOND, 0)

                                    list.add(ApiRequestSubData().apply {
                                        source_id = dataPoint.originalDataSource.appPackageName
                                        source_name = dataPoint.originalDataSource.streamName
                                        reading_key = Readings.CaloriesBurned.readingKey
                                        reading_value =
                                            dataPoint.getValue(Field.FIELD_CALORIES).toString()
                                        reading_datetime =
                                            DateTimeFormatter.date(cal.time)
                                                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    })
                                    Log.d(
                                        "achieved", "Calories DateTime for API :: ${
                                            DateTimeFormatter.date(cal.time)
                                                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                        } :: ${dataPoint.getValue(Field.FIELD_CALORIES)}"
                                    )
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                }


                            }
                        }
                    }
                }

                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the SPO2.", it)
                callback.invoke(list)
            }


        /**
         * get today's calories same as showing on google fit
         */
        /*Fitness.getHistoryClient(activity, getGoogleAccount())
            .readDailyTotal(DataType.TYPE_CALORIES_EXPENDED)
            .addOnSuccessListener { dataReadResponse ->
                for (dataPoint in dataReadResponse.dataPoints) {
                    Log.d(
                        "dataPoints",
                        "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                + "\nfields: ${dataPoint?.dataType?.fields}"
                                + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                + "\ntype: ${dataPoint.originalDataSource.type}"
                                + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                + "\ndevice: ${dataPoint.originalDataSource.device}"
                                + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                + "\nFIELD_CALORIES: ${
                            dataPoint.getValue(Field.FIELD_CALORIES)
                        }"
                                + "\nDATE: ${
                            DateTimeFormatter.date(
                                Date(
                                    dataPoint.getTimestamp(
                                        TimeUnit.MILLISECONDS
                                    )
                                )
                            )
                                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                        }"
                    )

                    list.add(ApiRequestSubData().apply {
                        source_id = dataPoint.originalDataSource.appPackageName
                        source_name = dataPoint.originalDataSource.streamName
                        reading_key = Readings.CaloriesBurned.readingKey
                        reading_value = dataPoint.getValue(Field.FIELD_CALORIES).toString()
                        reading_datetime =
                            DateTimeFormatter.date(
                                Date(
                                    dataPoint.getTimestamp(
                                        TimeUnit.MILLISECONDS
                                    )
                                )
                            ).formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                    })

                }
                callback.invoke(list)
            }
            .addOnFailureListener {
                Log.d(TAG, "There was a problem getting the SPO2.", it)
                callback.invoke(list)
            }*/
        /**
         * **********************************************************************************************************
         */
    }

    fun getCaloriesBurnedRecordsV2(
        startTime: Long, endTime: Long,
        callback: (caloriesBurnedList: ArrayList<ApiRequestSubData>) -> Unit,
    ) {

        val list = arrayListOf<ApiRequestSubData>()

        val request = SessionReadRequest.Builder()
            .setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
            .readSessionsFromAllApps()
            .includeActivitySessions()
            //.includeSessionsFromAllApps()
            .setSessionName(DataType.TYPE_CALORIES_EXPENDED.name)
            .build();

        Fitness.getSessionsClient(
            activity,
            GoogleSignIn.getAccountForExtension(activity, fitnessOptions)
        )
            .readSession(request)
            .addOnSuccessListener { response ->


//                for (Session session : sessionReadResponse.getSessions()) {
//                String sessionName = session.getName();
//                long sessionStartTime = session.getStartTime(TimeUnit.MILLISECONDS);
//                long sessionEndTime = session.getEndTime(TimeUnit.MILLISECONDS);
//
//                // Get the calories burned for this session.
//                float caloriesBurned = 0;
//                for (DataSet dataSet : sessionReadResponse.getDataSet(session)) {
//                for (DataPoint dataPoint : dataSet.getDataPoints()) {
//                if (dataPoint.getDataType().equals(DataType.TYPE_CALORIES_EXPENDED)) {
//                    caloriesBurned += dataPoint.getValue(Field.FIELD_CALORIES).asFloat();
//                }


                for (session in response.sessions) {
                    val sessionStart = session.getStartTime(TimeUnit.MILLISECONDS)
                    val sessionEnd = session.getEndTime(TimeUnit.MILLISECONDS)
                    Log.d(TAG, "Calories::: between $sessionStart and $sessionEnd")

                    /*val calStartSession = Calendar.getInstance()
                    calStartSession.timeInMillis = sessionStart
                    val calEndSession = Calendar.getInstance()
                    calEndSession.timeInMillis = sessionEnd*/

                    var caloriesBurned = 0f;

                    for (data in response.getDataSet(session)) {
                        for (dataPoint in data.dataPoints) {
                            if (dataPoint.dataType == DataType.TYPE_CALORIES_EXPENDED) {

                                Log.d(
                                    "dataPoints",
                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
                                            + "\nfields: ${dataPoint?.dataType?.fields}"
                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
                                            + "\ntype: ${dataPoint.originalDataSource.type}"
                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
                                            + "\nFIELD_CALORIES: ${dataPoint.getValue(Field.FIELD_CALORIES)}"
                                            + "\nDATE: ${
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                    }"
                                )

                                caloriesBurned += dataPoint.getValue(Field.FIELD_CALORIES).asFloat()

                                list.add(ApiRequestSubData().apply {
                                    source_id = dataPoint.originalDataSource.appPackageName
                                    source_name = dataPoint.originalDataSource.streamName
                                    reading_key = Readings.CaloriesBurned.readingKey
                                    reading_value =
                                        dataPoint.getValue(Field.FIELD_CALORIES).toString()
                                    reading_datetime =
                                        DateTimeFormatter.date(
                                            Date(
                                                dataPoint.getTimestamp(
                                                    TimeUnit.MILLISECONDS
                                                )
                                            )
                                        )
                                            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                })


                            }
                        }
                    }

                    Log.d(
                        TAG, "Session Calorie :: \nactivity : ${session.activity} " +
                                "\nSession name : ${session.name}" +
                                "\nCalories : $caloriesBurned"
                    )

                }

                callback.invoke(list)
            }.addOnFailureListener {
                callback.invoke(list)
            }


        /*
         * for calories passing current time only for end time instead of endTime,
         * to get same as google fit calories till this time, as for ednTime it returns total based on end time
         */
        //calories
//        val readRequest = DataReadRequest.Builder()
//            ./*aggregate*/read(DataType.TYPE_CALORIES_EXPENDED)
//            //.bucketByTime(1, TimeUnit.DAYS)
//            //.bucketByActivitySegment(1,TimeUnit.DAYS)
//            .setTimeRange(startTime, Calendar.getInstance().timeInMillis /*endTime*/, TimeUnit.MILLISECONDS)
//            .build()
//
//        Fitness.getHistoryClient(activity, getGoogleAccount())
//            .readData(readRequest)
//            .addOnSuccessListener { dataReadResponse ->
//
//                if (dataReadResponse.dataSets.isNullOrEmpty().not()) {
//                    for (dataset in dataReadResponse.dataSets) {
//                        Log.d("dataSets", "************************")
//                        for (dataPoint in dataset.dataPoints) {
//                            Log.d(
//                                "dataPoints",
//                                "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
//                                        + "\nfields: ${dataPoint?.dataType?.fields}"
//                                        + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
//                                        + "\ntype: ${dataPoint.originalDataSource.type}"
//                                        + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
//                                        + "\ndevice: ${dataPoint.originalDataSource.device}"
//                                        + "\ndataType: ${dataPoint.originalDataSource.dataType}"
//                                        + "\nFIELD_CALORIES: ${
//                                    dataPoint.getValue(Field.FIELD_CALORIES)
//                                }"
//                                        + "\nDATE: ${
//                                    DateTimeFormatter.date(
//                                        Date(
//                                            dataPoint.getTimestamp(
//                                                TimeUnit.MILLISECONDS
//                                            )
//                                        )
//                                    ).formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
//                                }"
//                            )
//
//
//                            try {
//                                val cal = Calendar.getInstance()
//                                cal.timeInMillis =
//                                    DateTimeFormatter.date(
//                                        Date(
//                                            dataPoint.getTimestamp(
//                                                TimeUnit.MILLISECONDS
//                                            )
//                                        )
//                                    ).date?.time!!
//
////                                if (cal.get(Calendar.HOUR_OF_DAY) == 0
////                                    && cal.get(Calendar.MINUTE) == 0
////                                    && cal.get(Calendar.SECOND) == 0
////                                ) {
////                                    cal.add(Calendar.DAY_OF_YEAR, -1)
////                                }
////
////                                cal.set(Calendar.HOUR_OF_DAY, 0)
////                                cal.set(Calendar.MINUTE, 0)
////                                cal.set(Calendar.SECOND, 0)
//
//                                list.add(ApiRequestSubData().apply {
//                                    source_id = dataPoint.originalDataSource.appPackageName
//                                    source_name = dataPoint.originalDataSource.streamName
//                                    reading_key = Readings.CaloriesBurned.readingKey
//                                    reading_value = dataPoint.getValue(Field.FIELD_CALORIES).toString()
//                                    reading_datetime =
//                                        DateTimeFormatter.date(cal.time)
//                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
//                                })
//                                Log.d(
//                                    "achieved", "Calories DateTime for API :: ${
//                                        DateTimeFormatter.date(cal.time)
//                                            .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
//                                    }"
//                                )
//                            } catch (e: Exception) {
//                                e.printStackTrace()
//                            }
//
//
//                        }
//                    }
//                }
//
//
//                // old by bucket calories data
//                /*if (!dataReadResponse.buckets.isNullOrEmpty()) {
//                    for (bucket in dataReadResponse.buckets) {
//                        //Log.d("buckets", "************************")
//                        for (dataset in bucket.dataSets) {
//                            Log.d("dataSets", "************************")
//                            for (dataPoint in dataset.dataPoints) {
//                                Log.d(
//                                    "dataPoints",
//                                    "\n\nstreamName: ${dataPoint.originalDataSource.streamName}"
//                                            + "\nfields: ${dataPoint?.dataType?.fields}"
//                                            + "\nstreamIdentifier: ${dataPoint.originalDataSource.streamIdentifier}"
//                                            + "\ntype: ${dataPoint.originalDataSource.type}"
//                                            + "\nappPackageName: ${dataPoint.originalDataSource.appPackageName}"
//                                            + "\ndevice: ${dataPoint.originalDataSource.device}"
//                                            + "\ndataType: ${dataPoint.originalDataSource.dataType}"
//                                            + "\nFIELD_CALORIES: ${
//                                        dataPoint.getValue(Field.FIELD_CALORIES)
//                                    }"
//                                            + "\nDATE: ${
//                                        DateTimeFormatter.date(
//                                            Date(
//                                                dataPoint.getTimestamp(
//                                                    TimeUnit.MILLISECONDS
//                                                )
//                                            )
//                                        ).formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
//                                    }"
//                                )
//
//
//                                try {
//                                    val cal = Calendar.getInstance()
//                                    cal.timeInMillis =
//                                        DateTimeFormatter.date(
//                                            Date(
//                                                dataPoint.getTimestamp(
//                                                    TimeUnit.MILLISECONDS
//                                                )
//                                            )
//                                        ).date?.time!!
//
//                                    *//*if (cal.get(Calendar.HOUR_OF_DAY) == 0
//                                        && cal.get(Calendar.MINUTE) == 0
//                                        && cal.get(Calendar.SECOND) == 0
//                                    ) {
//                                        cal.add(Calendar.DAY_OF_YEAR, -1)
//                                    }
//
//                                    cal.set(Calendar.HOUR_OF_DAY, 0)
//                                    cal.set(Calendar.MINUTE, 0)
//                                    cal.set(Calendar.SECOND, 0)*//*
//
//                                    list.add(ApiRequestSubData().apply {
//                                        source_id = dataPoint.originalDataSource.appPackageName
//                                        source_name = dataPoint.originalDataSource.streamName
//                                        reading_key = Readings.CaloriesBurned.readingKey
//                                        reading_value = dataPoint.getValue(Field.FIELD_CALORIES).toString()
//                                        reading_datetime =
//                                            DateTimeFormatter.date(cal.time)
//                                                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
//                                    })
//                                    Log.d(
//                                        "achieved", "Calories DateTime for API :: ${
//                                            DateTimeFormatter.date(cal.time)
//                                                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
//                                        }"
//                                    )
//                                } catch (e: Exception) {
//                                    e.printStackTrace()
//                                }
//
//
//                            }
//                        }
//                    }
//                }*/
//
//                callback.invoke(list)
//            }
//            .addOnFailureListener {
//                Log.d(TAG, "There was a problem getting the SPO2.", it)
//                callback.invoke(list)
//            }
    }

    /**
     * Write goal methods
     */
    fun writeSteps(stepCount: Int, calTime: Calendar) {
        activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            // [START build_insert_data_request]
            /*val calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"))*/
            val calendar = Calendar.getInstance()
            /*val now = Date()*/
            calendar.time = calTime.time
            val endTime = calendar.timeInMillis

            calendar.add(Calendar.HOUR_OF_DAY, -3)
            /*calendar.set(Calendar.HOUR_OF_DAY, 0)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)*/

            val startTime = calendar.timeInMillis

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(DataType.TYPE_STEP_COUNT_DELTA)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            try {

                // Create a data set
                val dataSet = DataSet.builder(dataSource)
                    .add(
                        DataPoint.builder(dataSource)
                            .setField(Field.FIELD_STEPS, stepCount)
                            //.setTimestamp(endTime, TimeUnit.DAYS)
                            .setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
                            .build()
                    ).build()


                Fitness.getHistoryClient(
                    it,
                    GoogleSignIn.getAccountForExtension(it, fitnessOptions)
                )
                    .insertData(dataSet)
                    .addOnSuccessListener {
                        Log.i(TAG, "======== STEP DataSet added successfully!")
                    }.addOnFailureListener { e ->
                        Log.i(TAG, "======== There was an error adding the DataSet", e)
                    }

            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }

    fun writeSleep(calStart: Calendar, calEnd: Calendar) {
        activity?.let {

            val endTime = calEnd.timeInMillis
            val startTime = calStart.timeInMillis

            val tempTimeStamp = Calendar.getInstance().timeInMillis.toString()

            val session = Session.Builder()
                //.setName(tempTimeStamp)
                //.setDescription(description)
                .setIdentifier(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setStartTime(startTime, TimeUnit.MILLISECONDS)
                .setEndTime(endTime, TimeUnit.MILLISECONDS)
                .setActivity(FitnessActivities.SLEEP)
                .build()

            // Build the request to insert the session.
            val request = SessionInsertRequest.Builder()
                .setSession(session)
                .build()

            // Insert the session into Fit platform
            Log.i(TAG, "Inserting the session with the SessionsClient")
            Fitness.getSessionsClient(
                activity,
                GoogleSignIn.getAccountForExtension(activity, fitnessOptions)
            )
                .insertSession(request)
                .addOnSuccessListener {
                    Log.d(TAG, "Sleep Session insert was successful! $tempTimeStamp")
                }
                .addOnFailureListener { e ->
                    Log.d(TAG, "There was a problem inserting the sleep session", e)
                }

            // Create a data source
            /* val dataSource = DataSource.Builder()
                 .setAppPackageName(it)
                 .setDataType(DataType.TYPE_SLEEP_SEGMENT)
                 .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                 .setType(DataSource.TYPE_RAW)
                 .build()

             // Create a data set
             val dataSet = DataSet.builder(dataSource)
                 .add(DataPoint.builder(dataSource)
                     .setField(Field.FIELD_SLEEP_SEGMENT_TYPE, SleepStages.SLEEP_DEEP)
                     //.setTimestamp(endTime, TimeUnit.DAYS)
                     .setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
                     .build()
                 ).build()

                   Fitness.getHistoryClient(it,
                 GoogleSignIn.getAccountForExtension(it, fitnessOptions))
                 .insertData(dataSet)
                 .addOnSuccessListener {
                     Log.i(TAG, "======== Sleep DataSet added successfully!")
                 }.addOnFailureListener { e ->
                     Log.i(TAG, "======== There was an error adding the DataSet", e)
                 }*/

        }
    }

    fun writeSleepV2(calStart: Calendar, calEnd: Calendar) {
        activity?.let {

            val dataSource = DataSource.Builder()
                .setDataType(DataType.TYPE_SLEEP_SEGMENT)
                .setType(DataSource.TYPE_RAW)
                .setStreamName("MySleepSource")//activity?.getString(R.string.app_name) ?: Common.APP_NAME
                .setAppPackageName(activity)
                .build()

            val builder: DataSet.Builder = DataSet.builder(dataSource)
            val dataPoint = DataPoint.builder(dataSource)
                .setField(Field.FIELD_SLEEP_SEGMENT_TYPE, SleepStages.SLEEP_DEEP)
                .setTimeInterval(calStart.timeInMillis, calEnd.timeInMillis, TimeUnit.MILLISECONDS)
                .build()
            builder.add(dataPoint)

            val dataSet = builder.build()

            /*val dataSet=dataSource.createDataSet("2020-08-10T23:00:00Z",
                // Monday
                Pair(SleepStages.SLEEP_LIGHT, 60),
                Pair(SleepStages.SLEEP_DEEP, 60),
                Pair(SleepStages.SLEEP_LIGHT, 60),
                Pair(SleepStages.SLEEP_REM, 60),
                Pair(SleepStages.SLEEP_DEEP, 60),
                Pair(SleepStages.SLEEP_LIGHT, 120)
            )*/

            Session.Builder()
                .setActivity(FitnessActivities.SLEEP)
                .setStartTime(
                    dataSet.dataPoints.first().getStartTime(TimeUnit.NANOSECONDS),
                    TimeUnit.NANOSECONDS
                )
                .setEndTime(
                    dataSet.dataPoints.last().getEndTime(TimeUnit.NANOSECONDS),
                    TimeUnit.NANOSECONDS
                )
                .setName("Sleep")
                .build()


            val endTime = calEnd.timeInMillis
            val startTime = calStart.timeInMillis

            /*val tempTimeStamp = Calendar.getInstance().timeInMillis.toString()*/

            val session = Session.Builder()
                .setName("Sleep")
                //.setDescription(description)
                .setIdentifier(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                /*.setStartTime(startTime, TimeUnit.MILLISECONDS)
                .setEndTime(endTime, TimeUnit.MILLISECONDS)*/
                .setStartTime(
                    dataSet.dataPoints.first().getStartTime(TimeUnit.NANOSECONDS),
                    TimeUnit.NANOSECONDS
                )
                .setEndTime(
                    dataSet.dataPoints.last().getEndTime(TimeUnit.NANOSECONDS),
                    TimeUnit.NANOSECONDS
                )
                .setActivity(FitnessActivities.SLEEP)
                .build()

            Log.d(TAG, "startTime:: $startTime")
            Log.d(TAG, "endTime:: $endTime")
            Log.d(
                TAG,
                "startTime1 :: ${dataSet.dataPoints.first().getStartTime(TimeUnit.MILLISECONDS)}"
            )
            Log.d(TAG, "endTime1 :: ${dataSet.dataPoints.last().getEndTime(TimeUnit.MILLISECONDS)}")

            // Build the request to insert the session.
            val request = SessionInsertRequest.Builder()
                .setSession(session)
                .addDataSet(dataSet)
                .build()

            // Insert the session into Fit platform
            Log.i(TAG, "Inserting the session with the SessionsClient")
            Fitness.getSessionsClient(
                activity,
                GoogleSignIn.getAccountForExtension(activity, fitnessOptions)
            )
                .insertSession(request)
                .addOnSuccessListener {
                    Log.d(TAG, "Sleep Session insert was successful!")
                }
                .addOnFailureListener { e ->
                    Log.d(TAG, "There was a problem inserting the sleep session", e)
                }

            // Create a data source
            /* val dataSource = DataSource.Builder()
                 .setAppPackageName(it)
                 .setDataType(DataType.TYPE_SLEEP_SEGMENT)
                 .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                 .setType(DataSource.TYPE_RAW)
                 .build()

             // Create a data set
             val dataSet = DataSet.builder(dataSource)
                 .add(DataPoint.builder(dataSource)
                     .setField(Field.FIELD_SLEEP_SEGMENT_TYPE, SleepStages.SLEEP_DEEP)
                     //.setTimestamp(endTime, TimeUnit.DAYS)
                     .setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
                     .build()
                 ).build()

                   Fitness.getHistoryClient(it,
                 GoogleSignIn.getAccountForExtension(it, fitnessOptions))
                 .insertData(dataSet)
                 .addOnSuccessListener {
                     Log.i(TAG, "======== Sleep DataSet added successfully!")
                 }.addOnFailureListener { e ->
                     Log.i(TAG, "======== There was an error adding the DataSet", e)
                 }*/

        }
    }

    fun writeWaterIntake(noOfGlass: Int, calTime: Calendar) {
        activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            // [START build_insert_data_request]
            /*val calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"))*/
            val calendar = Calendar.getInstance()
            /*val now = Date()*/
            calendar.time = calTime.time
            val endTime = calendar.timeInMillis
            /*calendar.add(Calendar.HOUR_OF_DAY, -1)
            val startTime = calendar.timeInMillis*/

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(DataType.TYPE_HYDRATION)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            val waterML = noOfGlass.toFloat() * AppConstants.WATER_ML_PER_GLASS
            val waterInLitre = waterML / 1000

            // Create a data set
            val dataSet = DataSet.builder(dataSource)
                .add(
                    DataPoint.builder(dataSource)
                        .setField(Field.FIELD_VOLUME, waterInLitre)
                        .setTimestamp(endTime, TimeUnit.MILLISECONDS)
                        /*.setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)*/
                        .build()
                ).build()

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .insertData(dataSet)
                .addOnSuccessListener {
                    Log.d(
                        TAG,
                        "======== WATER HYDRATION DataSet added successfully! $waterInLitre"
                    )
                }.addOnFailureListener { e ->
                    Log.d(
                        TAG,
                        "======== There was an error adding the DataSet WATER HYDRATION $waterInLitre",
                        e
                    )
                }

        }
    }

    fun writePhysicalActivity(activityType: Int, startTime: Calendar, endTime: Calendar) {
        activity?.let {

            Log.i(
                TAG,
                "Creating a data insert request. Start: ${startTime.time.formatToDateTime()}, End: ${endTime.time.formatToDateTime()}"
            )

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(DataType.TYPE_ACTIVITY_SEGMENT)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            // Create a data set
            val dataSet = DataSet.builder(dataSource)
                .add(
                    DataPoint.builder(dataSource)
                        .setTimeInterval(
                            startTime.timeInMillis,
                            endTime.timeInMillis,
                            TimeUnit.MILLISECONDS
                        )
                        .setField(Field.FIELD_ACTIVITY, activityType)
                        .build()
                ).build()

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .insertData(dataSet)
                .addOnSuccessListener {
                    Log.i(TAG, "======== Activity DataSet added successfully!")
                }.addOnFailureListener { e ->
                    Log.i(TAG, "======== There was an error adding the DataSet Activity", e)
                }

        }
    }

    fun deletePhysicalActivity(startTime: Calendar, endTime: Calendar) {
        activity?.let {
            val startTimeMillis = startTime.timeInMillis
            val endTimeMillis = endTime.timeInMillis

            val dataDeleteRequest = DataDeleteRequest.Builder()
                .setTimeInterval(startTimeMillis, endTimeMillis, TimeUnit.MILLISECONDS)
                .addDataType(DataType.TYPE_ACTIVITY_SEGMENT)
                //.deleteAllData()
                .build();

            Log.i(
                TAG,
                "Creating a data delete request. Start: ${startTime.time.formatToDateTime()}, End: ${endTime.time.formatToDateTime()}"
            )

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .deleteData(dataDeleteRequest)
                .addOnSuccessListener {
                    Log.i(TAG, "======== Activity DataSet deleted successfully!")
                }.addOnFailureListener { e ->
                    Log.i(TAG, "======== There was an error adding the DataSet Activity", e)
                }.addOnCanceledListener {
                    Log.i(
                        TAG,
                        "======== addOnCanceledListener"
                    )//2023-10-27 18:47:00, End: 2023-10-27 20:37:00
                }.addOnCompleteListener {
                    Log.i(TAG, "======== addOnCompleteListener")
                }

        }
    }

    /**
     * Write reading methods
     */
    fun writeSpo2(spo2: Float, calTime: Calendar) {
        activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            // [START build_insert_data_request]
            /*val calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"))*/
            val calendar = Calendar.getInstance()
            /*val now = Date()*/
            calendar.time = calTime.time
            val endTime = calendar.timeInMillis
            /*calendar.add(Calendar.HOUR_OF_DAY, -1)
            val startTime = calendar.timeInMillis*/

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(HealthDataTypes.TYPE_OXYGEN_SATURATION)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()


            // Create a data set
            val dataSet = DataSet.builder(dataSource)
                .add(
                    DataPoint.builder(dataSource)
                        .setField(HealthFields.FIELD_OXYGEN_SATURATION, spo2)
                        //HealthFields.FIELD_SUPPLEMENTAL_OXYGEN_FLOW_RATE mandatory
                        //The rate additional oxygen is supplied to a user in liters per minute.
                        //Zero indicates no supplemental oxygen is provided, and the user is breathing room air only.
                        .setField(HealthFields.FIELD_SUPPLEMENTAL_OXYGEN_FLOW_RATE, 0f)
                        .setTimestamp(endTime, TimeUnit.MILLISECONDS)
                        //.setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
                        .build()
                ).build()

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .insertData(dataSet)
                .addOnSuccessListener {
                    Log.i(TAG, "======== SPO2 DataSet added successfully!")
                }.addOnFailureListener { e ->
                    Log.i(TAG, "======== There was an error adding the DataSet SPO2", e)
                }

        }
    }

    fun writeBloodGlucose(
        bloodGlucoseLevelFastMgDl: Float,
        bloodGlucoseLevelPPMgDl: Float,
        calTime: Calendar,
    ) {
        activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            // [START build_insert_data_request]
            /*val calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"))*/
            val calendar = Calendar.getInstance()
            /*val now = Date()*/
            calendar.time = calTime.time
            val ppBGTime = calendar.timeInMillis

            // considering 1 hour before PP for fasting BG
            calendar.add(Calendar.HOUR_OF_DAY, -1)
            val fastingBGTime = calendar.timeInMillis

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(HealthDataTypes.TYPE_BLOOD_GLUCOSE)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            //The blood glucose level or concentration in mmol/L where 1 mmol/L is 18 mg/dL.
            //to write to google fit we need to convert it to mmol/L
            val bgLevelFastMmol = bloodGlucoseLevelFastMgDl / 18
            val bgLevelPPMmol = bloodGlucoseLevelPPMgDl / 18

            val dataPoints = arrayListOf<DataPoint>()

            //fast - FIELD_TEMPORAL_RELATION_TO_MEAL_FASTING
            dataPoints.add(
                DataPoint.builder(dataSource)
                    .setField(HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL, bgLevelFastMmol)
                    .setField(
                        HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL,
                        HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL_FASTING
                    )
                    .setTimestamp(fastingBGTime, TimeUnit.MILLISECONDS)
                    .build()
            )

            //pp - FIELD_TEMPORAL_RELATION_TO_MEAL_AFTER_MEAL
            dataPoints.add(
                DataPoint.builder(dataSource)
                    .setField(HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL, bgLevelPPMmol)
                    .setField(
                        HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL,
                        HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL_AFTER_MEAL
                    )
                    .setTimestamp(ppBGTime, TimeUnit.MILLISECONDS)
                    .build()
            )

            val dataSets = DataSet.builder(dataSource)
                .addAll(dataPoints)
                .build()

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .insertData(dataSets)
                .addOnSuccessListener {
                    Log.i(
                        TAG,
                        "======== BloodGlucose DataSet added successfully! fast :- $bgLevelFastMmol pp :- $bgLevelPPMmol mgmol"
                    )
                }.addOnFailureListener { e ->
                    Log.i(
                        TAG,
                        "======== There was an error adding the DataSet BloodGlucose fast :- $bgLevelFastMmol pp :- $bgLevelPPMmol mgmol",
                        e
                    )
                }

        }
    }

    fun writeBloodPressure(diastolic: Float, systolic: Float, calTime: Calendar) {
        activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            // [START build_insert_data_request]
            /*val calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"))*/
            val calendar = Calendar.getInstance()
            /*val now = Date()*/
            calendar.time = calTime.time
            val endTime = calendar.timeInMillis

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(HealthDataTypes.TYPE_BLOOD_PRESSURE)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            //The blood glucose level or concentration in mmol/L where 1 mmol/L is 18 mg/dL.
            //to write to google fit we need to convert it to mmol/L

            val dataSet = DataSet.builder(dataSource)
                .add(
                    DataPoint.builder(dataSource)
                        .setField(HealthFields.FIELD_BLOOD_PRESSURE_DIASTOLIC, diastolic)
                        .setField(HealthFields.FIELD_BLOOD_PRESSURE_SYSTOLIC, systolic)
                        .setTimestamp(endTime, TimeUnit.MILLISECONDS)
                        //.setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
                        .build()
                ).build()

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .insertData(dataSet)
                .addOnSuccessListener {
                    Log.i(
                        TAG,
                        "======== BloodPressure DataSet added successfully! diastolic :- $diastolic systolic :- $systolic mgmol"
                    )
                }.addOnFailureListener { e ->
                    Log.i(
                        TAG,
                        "======== There was an error adding the DataSet BloodPressure diastolic :- $diastolic systolic :- $systolic mgmol",
                        e
                    )
                }
        }
    }

    //Removed to sync heart rate, as widget changed to "Resting Heart Rate" from "Heart Rate"
    //Jira Ref Link: https://digicare123.atlassian.net/browse/MT-463
    //Date: 04-01-2023
    fun writeHeartRate(bpm: Float, calTime: Calendar) {
        activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            // [START build_insert_data_request]
            /*val calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"))*/
            val calendar = Calendar.getInstance()
            /*val now = Date()*/
            calendar.time = calTime.time
            val endTime = calendar.timeInMillis
            /*calendar.add(Calendar.HOUR_OF_DAY, -1)
            val startTime = calendar.timeInMillis*/

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(DataType.TYPE_HEART_RATE_BPM)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            /*val dataSource = DataSource.Builder()
                .setDataType(DataType.TYPE_HEART_RATE_BPM)
                .setAppPackageName("com.google.android.gms")
                .setStreamName("resting_heart_rate<-merge_heart_rate_bpm")
                .setType(DataSource.TYPE_DERIVED)
                .build()*/

            // Create a data set
            val dataSet = DataSet.builder(dataSource)
                .add(
                    DataPoint.builder(dataSource)
                        .setField(Field.FIELD_BPM, bpm)
                        .setTimestamp(endTime, TimeUnit.MILLISECONDS)
                        .build()
                ).build()

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .insertData(dataSet)
                .addOnSuccessListener {
                    Log.i(TAG, "======== Heartrate DataSet added successfully!")
                }.addOnFailureListener { e ->
                    Log.i(TAG, "======== There was an error adding the DataSet Heartrate", e)
                }

        }
    }

    fun writeBodyWeight(weight: Float, calTime: Calendar) {
        activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            val calendar = Calendar.getInstance()
            calendar.time = calTime.time
            val endTime = calendar.timeInMillis

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(DataType.TYPE_WEIGHT)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            // Create a data set
            val dataSet = DataSet.builder(dataSource)
                .add(
                    DataPoint.builder(dataSource)
                        .setField(Field.FIELD_WEIGHT, weight)
                        .setTimestamp(endTime, TimeUnit.MILLISECONDS)
                        .build()
                ).build()

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .insertData(dataSet)
                .addOnSuccessListener {
                    Log.i(TAG, "======== Weight DataSet added successfully!")
                }.addOnFailureListener { e ->
                    Log.i(TAG, "======== There was an error adding the DataSet Weight", e)
                }
        }
    }

    fun writeCaloriesBurned(caloriesBurned: Float, calTime: Calendar) {
        activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            // [START build_insert_data_request]
            /*val calendar = Calendar.getInstance(TimeZone.getTimeZone("UTC"))*/
            val calendar = Calendar.getInstance()
            /*val now = Date()*/
            calendar.time = calTime.time
            val endTime = calendar.timeInMillis

//            calendar.add(Calendar.HOUR_OF_DAY, -3)
            calendar.set(Calendar.HOUR_OF_DAY, 0)
            calendar.set(Calendar.MINUTE, 0)
            calendar.set(Calendar.SECOND, 0)

            val startTime = calendar.timeInMillis

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(DataType.TYPE_CALORIES_EXPENDED)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            try {

                // Create a data set
                val dataSet = DataSet.builder(dataSource)
                    .add(
                        DataPoint.builder(dataSource)
                            .setField(Field.FIELD_CALORIES, caloriesBurned)
                            //.setTimestamp(endTime, TimeUnit.DAYS)
                            .setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
                            .build()
                    ).build()

                val dataUpdateRequest = DataUpdateRequest.Builder()
                    .setDataSet(dataSet)
                    .setTimeInterval(startTime, endTime, TimeUnit.MILLISECONDS)
                    .build()

                Fitness.getHistoryClient(
                    it,
                    GoogleSignIn.getAccountForExtension(it, fitnessOptions)
                )
                    .insertData(dataSet)
                    //.updateData(dataUpdateRequest)
                    .addOnSuccessListener {
                        Log.i(TAG, "======== Calories")
                    }.addOnFailureListener { e ->
                        Log.i(TAG, "======== There was an error adding the Calories DataSet", e)
                    }.addOnCanceledListener {
                        Log.i(TAG, "======== Calories DataSet task OnCanceled")
                    }.addOnCompleteListener { task ->
                        Log.i(
                            TAG,
                            "======== Calories DataSet task isSuccessful: ${task.isSuccessful}"
                        )
                    }

            } catch (e: Exception) {
                e.printStackTrace()
            }

        }

        /*activity?.let {

            Log.i(TAG, "Creating a new data insert request.")

            val calendar = Calendar.getInstance()
            calendar.time = calTime.time
            val endTime = calendar.timeInMillis

            // Create a data source
            val dataSource = DataSource.Builder()
                .setAppPackageName(it)
                .setDataType(DataType.TYPE_CALORIES_EXPENDED)
                .setStreamName(activity?.getString(R.string.app_name) ?: Common.APP_NAME)
                .setType(DataSource.TYPE_RAW)
                .build()

            // Create a data set
            val dataSet = DataSet.builder(dataSource)
                .add(
                    DataPoint.builder(dataSource)
                        .setField(Field.FIELD_CALORIES, caloriesBurned)
                        .setTimestamp(endTime, TimeUnit.MILLISECONDS)
                        .build()
                ).build()

            Fitness.getHistoryClient(
                it,
                GoogleSignIn.getAccountForExtension(it, fitnessOptions)
            )
                .insertData(dataSet)
                .addOnSuccessListener {
                    Log.i(TAG, "======== Calories DataSet added successfully!")
                }.addOnFailureListener { e ->
                    Log.i(TAG, "======== There was an error adding the DataSet Calories", e)
                }
        }*/
    }


}


//NOT AVAILABLE - READINGS
//FEV1- not available
//BMI- not available
//PEF- not available
//HbA1c- not available
//CAT- not available
//ACR- not available
//eGFR- not available

//NOT AVAILABLE - GOALS
//Medication-not available
//Pranayama-not available


/**
 * Creates a {@code DataSet} from a start date/time and sleep periods (fine-grained sleep segments).
 *
 * @param startDateTime The start of the sleep session in UTC
 * @param sleepPeriods One or more sleep periods, defined as a Pair of {@code SleepStages}
 *     string constant and duration in minutes.
 * @return The created DataSet.
 */
fun DataSource.createDataSet(startDateTime: String, vararg sleepPeriods: Pair<Int, Long>): DataSet {
    val builder: DataSet.Builder = DataSet.builder(this)
    var cursorMilliseconds = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US)
        .parse(startDateTime).time

    for (sleepPeriod in sleepPeriods) {
        val duration = TimeUnit.MINUTES.toMillis(sleepPeriod.second)
        val dataPoint = DataPoint.builder(this)
            .setField(Field.FIELD_SLEEP_SEGMENT_TYPE, sleepPeriod.first)
            .setTimeInterval(
                cursorMilliseconds,
                cursorMilliseconds + duration,
                TimeUnit.MILLISECONDS
            )
            .build()
        builder.add(dataPoint)
        cursorMilliseconds += duration
    }
    return builder.build()
}