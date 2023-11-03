package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import kotlinx.parcelize.Parcelize

@Parcelize
data class AppointmentData(
    @SerializedName("appointment_id")
    val appointment_id: String? = null,
    @SerializedName("health_coach_id")
    val health_coach_id: String? = null,
    /*@SerializedName("health_coach_patient_appointment_id")
    val health_coach_patient_appointment_id: String? = null,*/
    @SerializedName("clinic_name")
    val clinic_name: String? = null,
    @SerializedName("clinic_id")
    val clinic_id: String? = null,
    @SerializedName("doctor_name")
    val doctor_name: String? = null,
    @SerializedName("profile_picture")
    val profile_picture: String? = null,
    @SerializedName("doctor_id")
    val doctor_id: String? = null,
    @SerializedName("doctor_qualification")
    val doctor_qualification: String? = null,
    @SerializedName("clinic_address")
    val clinic_address: String? = null,
    @SerializedName("appointment_date")
    var appointment_date: String? = null,
    @SerializedName("appointment_type")
    var appointment_type: String? = null,
    @SerializedName("appointment_status")
    var appointment_status: String? = null,
    @SerializedName("appointment_time")
    var appointment_time: String? = null,
    @SerializedName("payment_status")
    val payment_status: String? = null,
    @SerializedName("room_name")
    val room_name: String? = null,
    @SerializedName("room_id")
    val room_id: String? = null,
    @SerializedName("room_sid")
    val room_sid: String? = null,
    @SerializedName("prescription_pdf")
    val prescription_pdf: String? = null,
    @SerializedName("patient_doctor_appointment_id")
    val patient_doctor_appointment_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("start_time")
    val start_time: String? = null,
    @SerializedName("end_time")
    val end_time: String? = null,
    @SerializedName("transaction_id")
    val transaction_id: String? = null,
    @SerializedName("created_from")
    val created_from: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("action")
    val action: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,

    // for video add appointment response data
    @SerializedName("Status")
    val Status: String? = null,
    @SerializedName("message")
    val message: String? = null,
    @SerializedName("url")
    val url: String? = null,
) : Parcelable {
    val formattedAppointmentData: String
        get() {
            return try {
                DateTimeFormatter.date(appointment_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            } catch (e: Exception) {
                ""
            }
        }
}