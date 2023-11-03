package com.mytatva.patient.ui.goal.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.text.format.DateUtils
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.DifficultyLevel
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.ExerciseData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.data.pojo.response.MyRoutineMainData
import com.mytatva.patient.data.pojo.response.RoutinesData
import com.mytatva.patient.databinding.GoalFragmentLogExerciseNewBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.exercise.dialog.ExerciseUpdateDifficultyDialog
import com.mytatva.patient.ui.goal.adapter.LogExerciseRoutineMainAdapter
import com.mytatva.patient.ui.goal.adapter.LogExerciseRoutineSubAdapter
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.bottomsheet.BottomSheet
import com.mytatva.patient.utils.bottomsheet.BottomSheetAdapter
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.Calendar

class LogExerciseFragment : BaseFragment<GoalFragmentLogExerciseNewBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    private var maxDuration = 120
    private var durationCount = 5

    var goalReadingData: GoalReadingData? = null
    var isLastIndex: Boolean = false

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(textViewDate).checkEmpty()
                        .errorMessage(getString(R.string.validation_select_date)).check()

                    validator.submit(textViewTime).checkEmpty()
                        .errorMessage(getString(R.string.validation_select_time)).check()

                    if (isRoutinesView) {
                        //no extra validations required
                    } else {
                        validator.submit(editTextExercise).checkEmpty()
                            .errorMessage(getString(R.string.validation_select_exercise)).check()
                    }
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    //var selectedExerciseId: String? = null
    var selectedExerciseValue: Int = -1
    val exerciseList = arrayListOf<ExerciseData>()

    private val cal = Calendar.getInstance().apply {
        set(Calendar.SECOND, 0)
    }

    var isGoToNext = false
    private val goalReadingViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[GoalReadingViewModel::class.java]
    }

    private val engageContentViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[EngageContentViewModel::class.java]
    }

    private var isRoutinesView = false

    private var currentClickMainPosition = -1
    private var currentClickSubPosition = -1
    private val routinesList = arrayListOf<RoutinesData>()
    private val logExerciseRoutineMainAdapter by lazy {
        LogExerciseRoutineMainAdapter(routinesList,
            object : LogExerciseRoutineSubAdapter.AdapterListener {
                override fun onDoneClick(mainPosition: Int, position: Int) {
                    if (isValid) {
                        currentClickMainPosition = mainPosition
                        currentClickSubPosition = position
                        exercisePlanMarkAsDone()
                    }
                }
            })
    }


    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): GoalFragmentLogExerciseNewBinding {
        return GoalFragmentLogExerciseNewBinding.inflate(inflater, container, attachToRoot)/*.apply {
            rootExercise.transitionName = goalReadingData?.keys
            (requireActivity() as TransparentActivity).scheduleStartPostponedTransition(rootExercise)
        }*/
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LogGoal.plus(goalReadingData?.keys))
        setData()
    }

    private fun setData() {
        goalReadingData?.let {
            with(binding) {
                updateHeaderData()

                UpdateGoalLogsFragment.setUpSyncDataLayout(
                    binding.layoutSyncData,
                    googleFit.hasAllPermissions,
                    googleFit,
                    (requireActivity() as BaseActivity)
                )

                updateDate()
                updateTime()

                if (it.achieved_value?.toIntOrNull() != null && it.achieved_value.toInt() > 0) {
                    durationCount = it.achieved_value.toIntOrNull() ?: durationCount
                }
                editTextDuration.setText(durationCount.toString())
            }
        }
    }

    private fun updateHeaderData() {
        goalReadingData?.let {
            with(binding) {
                UpdateGoalLogsFragment.setUpHeader(it, layoutHeader, navigator)
            }

            /*analytics.logEvent(
                AnalyticsClient.CLICKED_HEALTH_INSIGHTS,
                Bundle().apply {
                    putString(
                        analytics.PARAM_HEALTH_MARKER_NAME,
                        it.goal_name
                    )
                    putString(
                        analytics.PARAM_HEALTH_MARKER_COLOUR,
                        it.color_code
                    )
                    putString(
                        analytics.PARAM_HEALTH_MARKER_VALUE,
                        it.todays_achieved_value
                    )
                }
            )*/
        }
    }

    override fun bindData() {
        setViewListeners()
//        setUpHeader()
        getExerciseList()
        binding.buttonAddNext.visibility = if (isLastIndex) View.GONE else View.VISIBLE
        setUpRecyclerView()
    }

    private fun setUpRecyclerView() {
        with(binding) {
            recyclerViewRoutines.apply {
                layoutManager = LinearLayoutManager(requireContext(), RecyclerView.VERTICAL, false)
                adapter = logExerciseRoutineMainAdapter
            }
        }
    }

    /*private fun setUpHeader() {
        binding.layoutHeader.apply {
            imageViewIcon.loadDrawable(R.drawable.ic_pranayam, false)
            textViewTitle.text = "Log Exercise"
            progressIndicator.progress = 50
            textViewValue.text = "10 of 15 minutes"
        }
    }*/

    private fun setViewListeners() {
        binding.apply {
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            buttonAdd.setOnClickListener { onViewClick(it) }
            buttonAddNext.setOnClickListener { onViewClick(it) }
            editTextExercise.setOnClickListener { onViewClick(it) }
            imageViewPlus.setOnClickListener { onViewClick(it) }
            imageViewMinus.setOnClickListener { onViewClick(it) }
            textViewDate.setOnClickListener { onViewClick(it) }
            textViewTime.setOnClickListener { onViewClick(it) }
            textViewLogNormalExercise.setOnClickListener { onViewClick(it) }
        }
    }

    private fun updateDate() {
        binding.textViewDate.text = try {
            DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
        } catch (e: Exception) {
            ""
        }

        exercisePlanDetails()
    }

    private fun updateTime() {
        binding.textViewTime.text = try {
            DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
        } catch (e: Exception) {
            ""
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewDate -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->
                    cal.set(year, month, dayOfMonth)
                    updateDate()

                    //set current time when on date change
                    /*val calCurrentTime = Calendar.getInstance()
                    cal.set(Calendar.HOUR_OF_DAY, calCurrentTime.get(Calendar.HOUR_OF_DAY))
                    cal.set(Calendar.MINUTE, calCurrentTime.get(Calendar.MINUTE))
                    cal.set(Calendar.SECOND, 0)
                    updateTime()*/

                    binding.textViewTime.text = ""

                }, 0L, Calendar.getInstance().timeInMillis)
            }

            R.id.textViewTime -> {
                navigator.pickTime({ _, hourOfDay, minute ->

                    val calTemp = Calendar.getInstance()
                    calTemp.timeInMillis = cal.timeInMillis
                    calTemp.set(Calendar.HOUR_OF_DAY, hourOfDay)
                    calTemp.set(Calendar.MINUTE, minute)
                    calTemp.set(Calendar.SECOND, 0)

                    if (Calendar.getInstance().before(calTemp)) {
                        showMessage(getString(R.string.validation_valid_time))
                    } else {
                        cal.set(Calendar.HOUR_OF_DAY, hourOfDay)
                        cal.set(Calendar.MINUTE, minute)
                        cal.set(Calendar.SECOND, 0)
                        updateTime()
                    }

                }, false)
            }

            R.id.buttonAdd -> {
                if (isValid) {
                    isGoToNext = false
                    updateGoalLogs()
                }
            }

            R.id.imageViewToolbarBack -> {
                callbackOnClose.invoke(false)
            }

            R.id.buttonAddNext -> {
                if (isValid) {
                    isGoToNext = true
                    updateGoalLogs()
                }
            }

            R.id.editTextExercise -> {
                showExerciseDialog()
            }

            R.id.imageViewPlus -> {
                if (durationCount < maxDuration) {
                    durationCount += 5
                    updateDuration()
                }
            }

            R.id.imageViewMinus -> {
                if (durationCount > 5) {
                    durationCount -= 5
                    updateDuration()
                }
            }

            R.id.textViewLogNormalExercise -> {
                isRoutinesView = false
                updateRoutineOrNormalView()
            }
        }
    }

    private fun showExerciseDialog() {
        BottomSheet<ExerciseData>().showBottomSheetDialog(
            requireActivity(),
            exerciseList,
            "Exercise",
            object : BottomSheetAdapter.ItemListener<ExerciseData> {
                override fun onItemClick(item: ExerciseData, position: Int) {
                    //selectedExerciseId = item.exercise_master_id
                    selectedExerciseValue =
                        item.exercise_value?.toIntOrNull() ?: selectedExerciseValue

                    binding.editTextExercise.text = item.exercise_name
                }

                override fun onBindViewHolder(
                    holder: BottomSheetAdapter<ExerciseData>.MyViewHolder,
                    position: Int,
                    item: ExerciseData,
                ) {
                    holder.textView.text = item.exercise_name
                }
            })
    }

    private fun updateDuration() {
        binding.editTextDuration.setText(durationCount.toString())
    }

    private fun updateRoutineOrNormalView() {
        if (isAdded) {
            with(binding) {
                //TransitionManager.beginDelayedTransition(rootLogExercise)
                if (isRoutinesView) {
                    layoutRoutines.isVisible = true
                    layoutNormalExercise.isVisible = false
                } else {
                    layoutRoutines.isVisible = false
                    layoutNormalExercise.isVisible = true
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateGoalLogs() {
        if (isRoutinesView) {
            // call API of log exercise routine view
            //exercisePlanMarkAsDoneMultiple()

            Handler(Looper.getMainLooper()).postDelayed({
                if (isAdded) callbackOnClose.invoke(isGoToNext)
                ContextHolder.reactContext?.let {
                    sendEventToRN(
                        it,
                        "updatedGoalReadingSuccess",
                        ""
                    )
                }
            }, 0)

        } else {
            val apiRequest = ApiRequest().apply {
                goal_id = goalReadingData?.goal_master_id
                achieved_value = binding.editTextDuration.text.toString().trim()
                patient_sub_goal_id = selectedExerciseValue.toString()
                achieved_datetime = DateTimeFormatter.date(cal.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)

                start_time = DateTimeFormatter.date(cal.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)

                val calEndDateTime = Calendar.getInstance()
                calEndDateTime.timeInMillis = cal.timeInMillis
                calEndDateTime.add(Calendar.MINUTE, durationCount)
                end_time = DateTimeFormatter.date(calEndDateTime.time)
                    .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
            }
            showLoader()
            goalReadingViewModel.updateGoalLogs(apiRequest)
        }
    }

    private fun getExerciseList() {
        val apiRequest = ApiRequest()
        //showLoader()
        goalReadingViewModel.getExerciseList(apiRequest)
    }

    //routine APIs
    private fun exercisePlanDetails() {
        val apiRequest = ApiRequest().apply {
            plan_date = DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
        }
        showLoader()
        engageContentViewModel.exercisePlanDetails(apiRequest)
    }


    private var calFitStartTime = Calendar.getInstance()
    private var calFitEndTime = Calendar.getInstance()
    private fun exercisePlanMarkAsDone() {
        val apiRequest = ApiRequest().apply {
            patient_exercise_plans_list_rel_id =
                routinesList[currentClickMainPosition].exercise_details?.get(currentClickSubPosition)?.patient_exercise_plans_list_rel_id
            done = if (routinesList[currentClickMainPosition].exercise_details?.get(
                    currentClickSubPosition
                )?.done == "Y"
            ) "N" else "Y"
            reading_time = DateTimeFormatter.date(Calendar.getInstance().time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
        }


        val exerciseDurationMin =
            routinesList[currentClickMainPosition].exercise_details?.get(currentClickSubPosition)?.getTimeDuration
                ?: 0

        if (apiRequest.done == "Y" && googleFit.hasAllPermissions && exerciseDurationMin > 0) {
            // when mark as done & google fit is connected, then pass start & end time in API
            // which to be stored in google fit, which will be be used to delete the entry from google fit,
            // if the user mark same as undone in future
            calFitStartTime = Calendar.getInstance()
            calFitStartTime.timeInMillis = cal.timeInMillis
            calFitEndTime = Calendar.getInstance()
            calFitEndTime.timeInMillis = cal.timeInMillis
            calFitEndTime.add(Calendar.MINUTE, exerciseDurationMin)

            apiRequest.fit_start_time = DateTimeFormatter.date(calFitStartTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
            apiRequest.fit_end_time = DateTimeFormatter.date(calFitEndTime.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
        }
        showLoader()
        engageContentViewModel.exercisePlanMarkAsDone(apiRequest)
    }

    private fun exercisePlanUpdateDifficulty() {
        val apiRequest = ApiRequest().apply {
            patient_exercise_plans_list_rel_id =
                routinesList[currentClickMainPosition].exercise_details?.get(currentClickSubPosition)?.patient_exercise_plans_list_rel_id
            difficulty = currentUpdatedDifficultyLevel?.title
        }
        showLoader()
        engageContentViewModel.exercisePlanUpdateDifficulty(apiRequest)
    }

    /* private fun exercisePlanMarkAsDoneMultiple() {
         val apiRequest = ApiRequest().apply {
             val list = ArrayList<ApiRequestSubData>()
             routinesList.forEachIndexed { index, routinesData ->
                 routinesData.exercise_details?.forEachIndexed { indexSub, routineExerciseData ->
                     list.add(ApiRequestSubData().apply {
                         patient_exercise_plans_list_rel_id = routineExerciseData.patient_exercise_plans_list_rel_id
                         done = routineExerciseData.done
                     })
                 }
             }
             mark_as_done_data = list
             reading_time = DateTimeFormatter.date(cal.time)
                 .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_HHMMSS)
         }
         showLoader()
         engageContentViewModel.exercisePlanMarkAsDoneMultiple(apiRequest)
     }*/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.updateGoalLogsLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            showMessage(responseBody.message)
            ContextHolder.reactContext?.let { sendEventToRN(it, "updatedGoalReadingSuccess", "") }

            Handler(Looper.getMainLooper()).postDelayed({
                if (isAdded) callbackOnClose.invoke(isGoToNext)
            }, 1000)

            analytics.logEvent(analytics.USER_UPDATED_ACTIVITY, Bundle().apply {
                putString(analytics.PARAM_GOAL_NAME, goalReadingData?.goal_name)
                putString(analytics.PARAM_GOAL_ID, goalReadingData?.goal_master_id)
                putString(
                    analytics.PARAM_GOAL_VALUE, binding.editTextDuration.text.toString().trim()
                )
            }, screenName = AnalyticsScreenNames.LogGoal)

            writeToGoogleFit()
        }, onError = { throwable ->
            hideLoader()
            true
        })

        goalReadingViewModel.getExerciseListLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            exerciseList.clear()
            responseBody.data?.let { exerciseList.addAll(it) }
        }, onError = { throwable ->
            hideLoader()
            true
        })

        //exercisePlanListLiveData
        engageContentViewModel.exercisePlanDetailsLiveData.observe(
            this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let { handleRoutinesData(it) }
            },
            onError = { throwable ->
                hideLoader()
                handleRoutinesData(null)
                false
            })

        /* //exercisePlanMarkAsDoneMultipleLiveData
         engageContentViewModel.exercisePlanMarkAsDoneMultipleLiveData.observe(this,
             onChange = { responseBody ->
                 hideLoader()
                 showMessage(responseBody.message)
                 Handler(Looper.getMainLooper()).postDelayed({
                     if (isAdded) callbackOnClose.invoke(isGoToNext)
                 }, 1000)
             },
             onError = { throwable ->
                 hideLoader()
                 true
             })*/

        //exercisePlanMarkAsDoneLiveData
        engageContentViewModel.exercisePlanMarkAsDoneLiveData.observe(
            this,
            onChange = { responseBody ->
                hideLoader()
                if (currentClickMainPosition != -1 && currentClickSubPosition != -1 && routinesList.isNotEmpty()) {

                    if (routinesList[currentClickMainPosition].exercise_details?.get(
                            currentClickSubPosition
                        )?.done == "Y"
                    ) {
                        routinesList[currentClickMainPosition].exercise_details?.get(
                            currentClickSubPosition
                        )?.done = "N"

                        deleteFromGoogleFitOnExerciseMarkUndone()

                    } else {
                        routinesList[currentClickMainPosition].exercise_details?.get(
                            currentClickSubPosition
                        )?.done = "Y"

                        writeToGoogleFitOnExerciseMarkDone()

                        // show difficulty dialog when mark as done
                        showUpdateDifficultyDialog()
                    }

                    logExerciseRoutineMainAdapter.notifyItemChanged(currentClickMainPosition)

                    // if selected date to today's date then update progress
                    responseBody.data?.let {
                        if (DateUtils.isToday(cal.timeInMillis)) {
                            goalReadingData?.todays_achieved_value = it.todays_achieved_value
                            goalReadingData?.goal_value = it.goal_value
                            updateHeaderData()
                        }
                    }
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //exercisePlanUpdateDifficultyLiveData
        engageContentViewModel.exercisePlanUpdateDifficultyLiveData.observe(
            this,
            onChange = { responseBody ->
                hideLoader()
                // no need to update UI here as no difficulty UI in this screen
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun handleRoutinesData(myRoutineMainData: MyRoutineMainData?) {
        routinesList.clear()
        with(binding) {
            if (myRoutineMainData == null || myRoutineMainData.is_rest_day == "Y" || myRoutineMainData.exercise_details.isNullOrEmpty()) {
                isRoutinesView = false
            } else {
                isRoutinesView = true
                routinesList.addAll(myRoutineMainData.exercise_details)
                logExerciseRoutineMainAdapter.notifyDataSetChanged()
            }/*Handler(Looper.getMainLooper()).postDelayed({
                updateRoutineOrNormalView()
            },250)*/
            updateRoutineOrNormalView()
        }

    }

    private var currentUpdatedDifficultyLevel: DifficultyLevel? = null
    private fun showUpdateDifficultyDialog() {
        if (routinesList.isNotEmpty()) {
            ExerciseUpdateDifficultyDialog().apply {
                /*title = routinesList[currentClickMainPosition].exercise_details?.get(
                    currentClickSubPosition)?.title ?: ""*/
                routineExerciseData = routinesList[currentClickMainPosition].exercise_details?.get(
                    currentClickSubPosition
                )
                callback = { difficultyLevel ->
                    currentUpdatedDifficultyLevel = difficultyLevel
                    exercisePlanUpdateDifficulty()
                }
            }.show(childFragmentManager, ExerciseUpdateDifficultyDialog::class.java.simpleName)
        }
    }

    private fun writeToGoogleFit() {
        if (googleFit.hasAllPermissions && selectedExerciseValue != -1) {
            val calStart = Calendar.getInstance()
            calStart.timeInMillis = cal.timeInMillis

            val calEnd = Calendar.getInstance()
            calEnd.timeInMillis = cal.timeInMillis
            calEnd.add(Calendar.MINUTE, durationCount)

            googleFit.writePhysicalActivity(
                activityType = selectedExerciseValue/*32*/,
                calStart,
                calEnd
            ) //golf
        }
    }

    private fun writeToGoogleFitOnExerciseMarkDone() {
        if (googleFit.hasAllPermissions) {
            //Other (unclassified fitness activity) - 108 (Int value for other activity type)
            googleFit.writePhysicalActivity(activityType = 108, calFitStartTime, calFitEndTime)
        }
    }

    private fun deleteFromGoogleFitOnExerciseMarkUndone() {
        val firStartTime =
            routinesList[currentClickMainPosition].exercise_details?.get(currentClickSubPosition)?.fit_start_time
        val fitEndTime =
            routinesList[currentClickMainPosition].exercise_details?.get(currentClickSubPosition)?.fit_end_time

        /*val firStartTime = "2023-10-31 14:15:00"
        val fitEndTime = "2023-10-31 14:20:00"*/
        Log.d(
            "GoogleFit",
            "deleteFromGoogleFitOnExerciseMarkUndone: start time: $firStartTime, end time: $fitEndTime"
        )

        if (googleFit.hasAllPermissions && firStartTime.isNullOrBlank()
                .not() && fitEndTime.isNullOrBlank().not()
        ) {

            try {
                val calStart = Calendar.getInstance()
                calStart.timeInMillis = DateTimeFormatter.date(
                    firStartTime,
                    DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                ).date!!.time

                val calEnd = Calendar.getInstance()
                calEnd.timeInMillis = DateTimeFormatter.date(
                    fitEndTime,
                    DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss
                ).date!!.time

                googleFit.deletePhysicalActivity(calStart, calEnd)
                Log.d(
                    "GoogleFit",
                    "deleteFromGoogleFitOnExerciseMarkUndone: cal start time: ${calStart.time}, cal end time: ${calEnd.time}"
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }

        }
    }
}