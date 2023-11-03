package com.mytatva.patient.ui.appointment.dialog

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Build
import android.os.Bundle
import android.util.DisplayMetrics
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.core.view.isVisible
import com.mytatva.patient.R
import com.mytatva.patient.data.model.AppointmentTypes
import com.mytatva.patient.data.pojo.response.AppointmentData
import com.mytatva.patient.databinding.AppointmentDialogAppointmentConfirmedBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.ui.base.BaseDialogFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.imagepicker.loadCircle

class AppointmentConfirmedDialog(val appointmentData: AppointmentData) :
    BaseDialogFragment<AppointmentDialogAppointmentConfirmedBinding>() {

    var callback: (() -> Unit)? = null
    fun setCallback(callback: () -> Unit): AppointmentConfirmedDialog {
        this.callback = callback
        return this
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AppointmentDialogAppointmentConfirmedBinding {
        return AppointmentDialogAppointmentConfirmedBinding.inflate(inflater,
            container,
            attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        dialog?.window!!.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
        dialog?.setCancelable(false)
        dialog?.setCanceledOnTouchOutside(false)
        val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            requireContext().display
        } else {
            wm.defaultDisplay
        }
        val metrics = DisplayMetrics()
        display?.getMetrics(metrics)
        val width = metrics.widthPixels * 1
        val height = metrics.heightPixels * .7
        val win = dialog?.window
        win!!.setLayout(width.toInt(), WindowManager.LayoutParams.WRAP_CONTENT)

        analytics.setScreenName(AnalyticsScreenNames.AppointmentConfirmed)
    }

    override fun bindData() {
        analytics.logEvent(analytics.BOOK_APPOINTMENT_SUCCESSFUL, Bundle().apply {
            putString(analytics.PARAM_APPOINTMENT_ID, appointmentData.appointment_id)
            putString(analytics.PARAM_TYPE, if (appointmentData.health_coach_id.isNullOrBlank()) "D" else "H")
        }, screenName = AnalyticsScreenNames.AppointmentConfirmed)

        setViewListener()
        setDetails()
    }

    private fun setDetails() {
        appointmentData.let {
            with(binding) {
                //textViewStatus.text = item.appointment_status
                imageViewProfile.loadCircle(it.profile_picture ?: "")
                textViewDoctorName.text = it.doctor_name
                textViewDegree.text = it.doctor_qualification
                textViewDate.text = it.formattedAppointmentData
                textViewTime.text = it.appointment_time
                textViewAddress.text = it.clinic_address

                // options
                layoutOptions.isVisible = false
                layoutJoinVideoCall.isVisible =
                    it.appointment_type?.contains(AppointmentTypes.VIDEO.typeKey) ?: false
                layoutInClinicAppointment.isVisible =
                    it.appointment_type?.contains(AppointmentTypes.CLINIC.typeKey) ?: false

                // prescriptions & discharge summary
                /*layoutPrescriptions.isVisible = item.prescription_pdf.isNullOrBlank().not()
                layoutDischargeSummary.isVisible = false
                textViewNoOfPrescription
                textViewNoOfDischargeSummary*/
            }
        }
    }

    private fun setViewListener() {
        binding.apply {
            textViewRequestCancellation.setOnClickListener { onViewClick(it) }
            layoutJoinVideoCall.setOnClickListener { onViewClick(it) }
            layoutInClinicAppointment.setOnClickListener { onViewClick(it) }
            buttonDone.setOnClickListener { onViewClick(it) }
            imageViewClose.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewRequestCancellation -> {
            }
            R.id.layoutJoinVideoCall -> {
            }
            R.id.layoutInClinicAppointment -> {
            }
            R.id.buttonDone -> {
                callback?.invoke()
                dismiss()
            }
            R.id.imageViewClose -> {
                callback?.invoke()
                dismiss()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateAnswer() {
        /*val apiRequest = ApiRequest().apply {
        }
        showLoader()
        engageContentViewModel.updateAnswer(apiRequest)*/
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        /*engageContentViewModel.updateAnswerLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                dismiss()
            },
            onError = { throwable ->
                hideLoader()
                true
            })*/
    }

}