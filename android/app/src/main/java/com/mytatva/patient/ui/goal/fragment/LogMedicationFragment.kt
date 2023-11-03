package com.mytatva.patient.ui.goal.fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.R
import com.mytatva.patient.data.model.Goals
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.request.ApiRequestSubData
import com.mytatva.patient.data.pojo.request.DoseStatusData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.data.pojo.response.MedicationData
import com.mytatva.patient.databinding.GoalFragmentLogMedicationBinding
import com.mytatva.patient.databinding.GoalFragmentLogMedicationNewBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.fragment.SetupDrugsFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.goal.adapter.LogMedicationAdapter
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parseAsColor
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.*

class LogMedicationFragment : BaseFragment<GoalFragmentLogMedicationNewBinding>() {

    lateinit var callbackOnClose: (isToGoNext: Boolean) -> Unit

    var goalReadingData: GoalReadingData? = null
    var isLastIndex: Boolean = false

    private val medicationList = arrayListOf<MedicationData>()
    private val logMedicationAdapter by lazy {
        LogMedicationAdapter(medicationList)
    }

    private val goalReadingViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[GoalReadingViewModel::class.java]
    }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val cal = Calendar.getInstance()

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): GoalFragmentLogMedicationNewBinding {
        return GoalFragmentLogMedicationNewBinding.inflate(inflater, container, attachToRoot)/*.apply {
            rootMedication.transitionName = goalReadingData?.keys
            (requireActivity() as TransparentActivity).scheduleStartPostponedTransition(rootMedication)
        }*/
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.LogGoal.plus(goalReadingData?.keys))
    }

    override fun bindData() {
        setHeaderData()
        setViewListeners()
        setUpRecyclerView()
        //patientTodaysMedicationList()
        getPrescriptionDetails()
        updateDate()
        analytics.logEvent(analytics.USER_LOGGOAL_MEDICINE_CONTENTVIEW,
            screenName = AnalyticsScreenNames.LogGoal)
    }

    private fun setHeaderData() {
        with(binding) {
            textViewToolbarTitle.text = goalReadingData?.goal_name

            val color =
                if (goalReadingData?.color_code.isNullOrBlank().not())
                    goalReadingData?.color_code.parseAsColor()
                else requireContext().resources
                    .getColor(R.color.colorPrimary, null)
            progressIndicator.setIndicatorColor(color)

            val achievedValue = goalReadingData?.todays_achieved_value?.toDoubleOrNull() ?: 0.0
            val goalValue = goalReadingData?.goal_value?.toDoubleOrNull() ?: 0.0

            if (achievedValue >= goalValue) {
                progressIndicator.max = goalValue.toInt()
                progressIndicator.progress = goalValue.toInt()
                //textViewProgress.text = "Completed"

                if (goalValue == 0.0 && goalReadingData?.keys == Goals.Medication.goalKey) {
                    /*progressIndicator.max = 10
                    progressIndicator.progress = 10*/
                    textViewProgress.text = "Add medicine"
                } else {
                    textViewProgress.text = "Completed"
                }

            } else {
                progressIndicator.max = goalValue.toInt()
                progressIndicator.progress = achievedValue.toInt()

                textViewProgress.text = "${achievedValue.toInt()} of ${goalValue.toInt()} doses"
            }
        }

        /*analytics.logEvent(
            AnalyticsClient.CLICKED_HEALTH_INSIGHTS,
            Bundle().apply {
                putString(
                    analytics.PARAM_HEALTH_MARKER_NAME,
                    goalReadingData?.goal_name
                )
                putString(
                    analytics.PARAM_HEALTH_MARKER_COLOUR,
                    goalReadingData?.color_code
                )
                putString(
                    analytics.PARAM_HEALTH_MARKER_VALUE,
                    goalReadingData?.todays_achieved_value
                )
            }
        )*/
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewLogMedication.apply {
            layoutManager = LinearLayoutManager(context, RecyclerView.VERTICAL, false)
            adapter = logMedicationAdapter
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewEdit.setOnClickListener { onViewClick(it) }
            buttonAddEditPrescription.setOnClickListener { onViewClick(it) }
            buttonAddPrescription.setOnClickListener { onViewClick(it) }
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            buttonMarkAllDone.setOnClickListener { onViewClick(it) }
            buttonSubmit.setOnClickListener { onViewClick(it) }
            textViewDate.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonAddEditPrescription,
            R.id.buttonAddPrescription,
            R.id.imageViewEdit,
            -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.add_medication)) {
                    navigator.loadActivity(IsolatedFullActivity::class.java,
                        SetupDrugsFragment::class.java)
                        .byFinishingCurrent()
                        .start()
                }
            }
            R.id.imageViewToolbarBack -> {
                callbackOnClose.invoke(false)
            }
            R.id.buttonMarkAllDone -> {
                analytics.logEvent(analytics.USER_CLICKED_ON_MARK_ALL_AS_DONE,
                    screenName = AnalyticsScreenNames.LogGoal)
                markAllDone()
            }
            R.id.buttonSubmit -> {
                if (medicationList.isEmpty()) {
                    showMessage(getString(R.string.validation_add_medication_prescription))
                } else {//
                    updatePatientDoses()
                }
            }
            R.id.textViewDate -> {
                navigator.pickDate({ _, year, month, dayOfMonth ->
                    cal.set(year, month, dayOfMonth)
                    updateDate()
                    patientTodaysMedicationList()
                }, 0L, Calendar.getInstance().timeInMillis)
            }
        }
    }

    private fun updateDate() {
        binding.textViewDate.text = try {
            DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE)
        } catch (e: Exception) {
            ""
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun markAllDone() {
        medicationList.forEachIndexed { index, tempDataModel ->
            tempDataModel.dose_time_slot?.forEachIndexed { subIndex, _ ->
                medicationList[index].dose_time_slot!![subIndex].taken = "Y"
            }
        }
        logMedicationAdapter.notifyDataSetChanged()
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getPrescriptionDetails() {
        val apiRequest = ApiRequest().apply {
            is_active_medicine_only = "Y"
        }
        showLoader()
        authViewModel.getPrescriptionDetails(apiRequest)
    }

    private fun patientTodaysMedicationList() {
        val apiRequest = ApiRequest().apply {
            medication_date = DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
        }
        showLoader()
        goalReadingViewModel.patientTodaysMedicationList(apiRequest)
    }

    private fun updatePatientDoses() {
        showLoader()
        goalReadingViewModel.updatePatientDoses(createMedicationDataRequest(),
            goalReadingData?.goal_master_id)
    }

    private fun createMedicationDataRequest(): ApiRequest {
        return ApiRequest().apply {
            medication_data = arrayListOf()
            medicationList.forEach { medicationData ->
                val medData = ApiRequestSubData()
                medData.patient_dose_rel_id = medicationData.patient_dose_rel_id
                medData.dose_status = arrayListOf()
                medicationData.dose_time_slot?.forEach { doseTimeSlotData ->
                    val doseStatusData = DoseStatusData()
                    doseStatusData.dose_taken = doseTimeSlotData.taken
                    doseStatusData.dose_time_slot = doseTimeSlotData.time
                    medData.dose_status?.add(doseStatusData)
                }
                medication_data?.add(medData)
            }
            medication_date = DateTimeFormatter.date(cal.time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
        }
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        goalReadingViewModel.patientTodaysMedicationListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.medication?.let { setMedicationData(it) }
            },
            onError = { throwable ->
                hideLoader()
                setMedicationData(arrayListOf(), throwable.message ?: "")
                false
            })

        goalReadingViewModel.updatePatientDosesLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"updatedGoalReadingSuccess","") }

                callbackOnClose.invoke(false)
                analytics.logEvent(analytics.USER_UPDATED_ACTIVITY, Bundle().apply {
                    putString(analytics.PARAM_GOAL_NAME, goalReadingData?.goal_name)
                    putString(analytics.PARAM_GOAL_ID, goalReadingData?.goal_master_id)
                }, screenName = AnalyticsScreenNames.LogGoal)

                analytics.logEvent(analytics.USER_MARKS_MEDICINE, Bundle().apply {
                    putString(analytics.PARAM_GOAL_NAME, goalReadingData?.goal_name)
                    putString(analytics.PARAM_GOAL_ID, goalReadingData?.goal_master_id)
                }, screenName = AnalyticsScreenNames.LogGoal)

            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //getPrescriptionDetailsLiveData
        authViewModel.getPrescriptionDetailsLiveData.observe(this,
            onChange = { responseBody ->
                with(binding) {
                    if (responseBody.data?.medicine_data.isNullOrEmpty()) {
                        hideLoader()
                        handleNoPrescriptionMedicineData()
                    } else {
                        patientTodaysMedicationList()
                        //handleOnPrescriptionMedicineDataAvailable()
                    }
                }
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException) {
                    handleNoPrescriptionMedicineData()
                    false
                } else
                    true
            })

    }

    private fun showPrescriptionMedicineDataViews() {
        with(binding) {
            layoutAddPrescriptions.isVisible = false
            layoutPrescriptions.isVisible = true
        }
    }

    private fun handleNoPrescriptionMedicineData() {
        with(binding) {
            layoutAddPrescriptions.isVisible = true
            layoutPrescriptions.isVisible = false
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    private fun setMedicationData(list: List<MedicationData>, message: String = "") {
        showPrescriptionMedicineDataViews()
        medicationList.clear()
        medicationList.addAll(list)
        logMedicationAdapter.notifyDataSetChanged()

        with(binding) {
            if (medicationList.isEmpty()) {
                textViewNoData.visibility = View.VISIBLE
                recyclerViewLogMedication.visibility = View.INVISIBLE
                textViewNoData.text = message
            } else {
                textViewNoData.visibility = View.INVISIBLE
                recyclerViewLogMedication.visibility = View.VISIBLE
            }
        }
    }
}