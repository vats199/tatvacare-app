package com.mytatva.patient.ui.menu.adapter

import android.content.res.ColorStateList
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.view.isVisible
import androidx.recyclerview.widget.RecyclerView
import com.mytatva.patient.data.model.AppointmentStatus
import com.mytatva.patient.data.model.AppointmentTypes
import com.mytatva.patient.data.pojo.response.AppointmentData
import com.mytatva.patient.databinding.MenuRowHistoryAppointmentBinding
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.utils.imagepicker.loadCircle

class HistoryAppointmentAdapter(
    var list: ArrayList<AppointmentData>,
    val navigator: Navigator,
    val adapterListener: AdapterListener,
) : RecyclerView.Adapter<HistoryAppointmentAdapter.ViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = MenuRowHistoryAppointmentBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = list[position]
        val context = holder.binding.root.context
        holder.binding.apply {
            var colorRes: Int = AppointmentStatus.SCHEDULED.colorRes
            var statusLabel: String = item.appointment_status ?: ""
            when (item.appointment_status) {
                AppointmentStatus.SCHEDULED.statusKey -> {
                    textViewRequestCancellation.isVisible = true
                    colorRes = AppointmentStatus.SCHEDULED.colorRes
                    statusLabel = AppointmentStatus.SCHEDULED.statusTitle
                }
                AppointmentStatus.CANCELLED.statusKey -> {
                    textViewRequestCancellation.isVisible = false
                    colorRes = AppointmentStatus.CANCELLED.colorRes
                    statusLabel = AppointmentStatus.CANCELLED.statusTitle
                }
                "Completed",// added for diff spelling of status as per HCr Doctor
                AppointmentStatus.COMPLETED.statusKey,
                -> {
                    textViewRequestCancellation.isVisible = false
                    colorRes = AppointmentStatus.COMPLETED.colorRes
                    statusLabel = AppointmentStatus.COMPLETED.statusTitle
                }
                AppointmentStatus.MISSED.statusKey -> {
                    textViewRequestCancellation.isVisible = false
                    colorRes = AppointmentStatus.MISSED.colorRes
                    statusLabel = AppointmentStatus.MISSED.statusTitle
                }
            }

            layoutJoinVideoCall.alpha = if (item.action?.toBooleanStrictOrNull() == true) {
                1F
            } else {
                0.5F
            }

            textViewStatus.backgroundTintList =
                ColorStateList.valueOf(context.resources.getColor(colorRes, null))
            textViewStatus.text = statusLabel

            imageViewProfile.loadCircle(item.profile_picture ?: "")
            textViewDoctorName.text = item.doctor_name
            textViewDegree.text = item.doctor_qualification
            textViewDate.text = item.formattedAppointmentData
            textViewTime.text = item.appointment_time
            textViewAddress.text = item.clinic_address

            // options
            layoutOptions
            layoutJoinVideoCall.isVisible =
                item.appointment_type?.contains(AppointmentTypes.VIDEO.typeKey) ?: false
            layoutInClinicAppointment.isVisible =
                item.appointment_type?.contains(AppointmentTypes.CLINIC.typeKey) ?: false

            // prescriptions & discharge summary
            layoutPrescriptions.isVisible = item.prescription_pdf.isNullOrBlank().not()
            layoutDischargeSummary.isVisible = false
            textViewNoOfPrescription
            textViewNoOfDischargeSummary
        }
    }

    override fun getItemCount(): Int = list.size

    inner class ViewHolder(val binding: MenuRowHistoryAppointmentBinding) :
        RecyclerView.ViewHolder(binding.root) {
        init {
            with(binding) {
                textViewRequestCancellation.setOnClickListener {
                    adapterListener.onCancelClick(bindingAdapterPosition)
                }
                layoutJoinVideoCall.setOnClickListener {
                    if (it.alpha == 1F) {
                        adapterListener.onJoinVideoClick(bindingAdapterPosition)
                    }
                }
                layoutInClinicAppointment.setOnClickListener {
                }
                buttonViewPrescription.setOnClickListener {
                    if (list.isNotEmpty()) {
                        list[bindingAdapterPosition].prescription_pdf?.let { it1 ->
                            navigator.openPdfViewer(it1)
                        }
                    }
                }
                buttonDischargeSummary.setOnClickListener {

                }
            }
        }
    }

    interface AdapterListener {
        fun onCancelClick(position: Int)
        fun onJoinVideoClick(position: Int)
    }
}