package com.mytatva.patient.ui.payment.fragment.v1

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.PlanFeatures
import com.mytatva.patient.data.pojo.response.BCPScheduleAppointmentData
import com.mytatva.patient.databinding.PaymentFragmentBcpScheduleAppointmentBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.appointment.fragment.BookAppointmentsFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.enableShadow
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class BcpScheduleAppointmentFragment :
    BaseFragment<PaymentFragmentBcpScheduleAppointmentBinding>() {

    private val patientPlanRelId by lazy {
        arguments?.getString(Common.BundleKey.PATIENT_PLAN_REL_ID)
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    lateinit var bcpScheduleAppointmentData: BCPScheduleAppointmentData
    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): PaymentFragmentBcpScheduleAppointmentBinding {
        return PaymentFragmentBcpScheduleAppointmentBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUpToolbar()
        setViewListener()
        checkBCPHcDetails()
        setUpUI()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.BcpHcServices)
    }

    private fun setUpUI() {
        with(binding) {
            layoutDoctor.isVisible = session.user?.isToShowDoctorAppointmentModule == true
        }
    }

    private fun setViewListener() = with(binding) {
        editTextNutrition.setOnClickListener { onViewClick(it) }
        editTextPhysiotherapist.setOnClickListener { onViewClick(it) }
        editTextDoctor.setOnClickListener { onViewClick(it) }
        buttonSchedule.setOnClickListener { onViewClick(it) }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            //root.enableShadow()
            textViewToolbarTitle.text =
                getString(R.string.bcp_schedule_appointment_label_header_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.editTextNutrition -> {
                // on ed click, check if nutritionist.health_coach_id is null or blank then, existing new flow else open book appointment
                if (bcpScheduleAppointmentData.nutritionist?.health_coach_id.isNullOrEmpty()
                        .not()
                ) {
                    if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                        navigator.loadActivity(
                            IsolatedFullActivity::class.java,
                            BookAppointmentsFragment::class.java
                        ).start()
                    }
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        PaymentBCPAppointmentDateTimeFragment::class.java
                    ).addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.PATIENT_PLAN_REL_ID, patientPlanRelId),
                            Pair(Common.BundleKey.IS_PHYSIOTHERAPIST, false),
                        )
                    )
                        .forResult(Common.RequestCode.REQUEST_APPOINTMENT_SCHEDULE)
                        .start()
                }
            }

            R.id.editTextPhysiotherapist -> {
                // on ed click, check if nutritionist.health_coach_id is null or blank then, existing new flow else open book appointment
                if (bcpScheduleAppointmentData.physiotherapist?.health_coach_id.isNullOrEmpty()
                        .not()
                ) {
                    if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                        navigator.loadActivity(
                            IsolatedFullActivity::class.java,
                            BookAppointmentsFragment::class.java
                        ).start()
                    }
                } else {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        PaymentBCPAppointmentDateTimeFragment::class.java
                    )
                        .addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.PATIENT_PLAN_REL_ID, patientPlanRelId),
                                Pair(Common.BundleKey.IS_PHYSIOTHERAPIST, true),
                            )
                        )
                        .forResult(Common.RequestCode.REQUEST_APPOINTMENT_SCHEDULE)
                        .start()
                }
            }

            R.id.editTextDoctor -> {
                if (isFeatureAllowedAsPerPlan(PlanFeatures.book_appointments)) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        BookAppointmentsFragment::class.java
                    ).start()
                }
            }

            R.id.buttonSchedule -> {
                navigator.goBack()
            }

            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == Common.RequestCode.REQUEST_APPOINTMENT_SCHEDULE) {
            if (resultCode == Activity.RESULT_OK) {
                val appointmentData = data?.getStringExtra(Common.BundleKey.MESSAGE)
                appointmentData?.let {
                    showAppMessage(appointmentData,AppMsgStatus.SUCCESS)
                }
                checkBCPHcDetails()
            }
        }
    }

    private fun viewVisible() = with(binding) {
        if (::bcpScheduleAppointmentData.isInitialized) {
            bcpScheduleAppointmentData.let {

                if (it.nutritionist == null && it.nutritionistAvailabilityDate.isNullOrEmpty()
                        .not()
                ) {
                    editTextNutrition.isVisible = false
                    layoutBookedNutrition.isVisible = true
                    textViewNutritionDate.setDate(it.nutritionistAvailabilityDate)
                    textViewNutritionTime.setTime(it.nutritionistStartTime, it.nutritionistEndTime)
                    textViewNutritionTime.text = String.format("%s, %s",it.nutritionist_time_type,textViewNutritionTime.text.toString())
                    /*textViewNutritionDay.text = it.nutritionist_day
                    textViewNutritionTimeType.text = it.nutritionist_time_type*/
                } else {
                    editTextNutrition.isVisible = true
                    layoutBookedNutrition.isVisible = false
                }

                if (it.physiotherapist == null && it.physiotherapistAvailabilityDate.isNullOrEmpty()
                        .not()
                ) {
                    editTextPhysiotherapist.isVisible = false
                    layoutBookedPhysiotherapist.isVisible = true
                    textViewPhysiotherapistDate.setDate(it.physiotherapistAvailabilityDate)
                    textViewPhysiotherapistTime.setTime(
                        it.physiotherapistStartTime,
                        it.physiotherapistEndTime
                    )
                    textViewPhysiotherapistTime.text = String.format("%s, %s", it.physiotherapist_time_type,textViewPhysiotherapistTime.text.toString())
                    /*textViewPhysiotherapistDay.text = it.physiotherapist_day
                    textViewPhysiotherapistTimeType.text = it.physiotherapist_time_type*/
                } else {
                    editTextPhysiotherapist.isVisible = true
                    layoutBookedPhysiotherapist.isVisible = false
                }

                textViewLabelDisclaimer.isVisible = layoutBookedNutrition.isVisible || layoutBookedPhysiotherapist.isVisible
            }
        }
    }

    private fun TextView.setDate(string: String?) {
        this.text = DateTimeFormatter.date(string, DateTimeFormatter.FORMAT_yyyyMMdd)
            .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_EEEEddMMMyyyy)
    }

    private fun TextView.setTime(startStr: String?, endStr: String?) {
        this.text = String.format(
            "%s - %s", DateTimeFormatter.date(startStr, DateTimeFormatter.FORMAT_HHMMSS)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_hhmm),
            DateTimeFormatter.date(endStr, DateTimeFormatter.FORMAT_HHMMSS)
                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_hhmma)
        )
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun checkBCPHcDetails() {
        showLoader()
        doctorViewModel.checkBCPHCDetails()
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //checkBCPHCDetyails
        doctorViewModel.checkBCPHCDetailsLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    bcpScheduleAppointmentData = it
                    viewVisible()
                }
            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException){
                    throwable.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })
    }
}