package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class IncidentDetailsMainData(
    @SerializedName("duration_patient_incident_rel_id")
    val duration_patient_incident_rel_id: String? = null,
    @SerializedName("incident_tracking_master_id")
    val incident_tracking_master_id: String? = null,
    @SerializedName("patient_incident_add_rel_id")
    val patient_incident_add_rel_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("survey_id")
    val survey_id: String? = null,
    @SerializedName("duration_question_id")
    val duration_question_id: String? = null,
    @SerializedName("duration_question")
    val duration_question: String? = null,
    @SerializedName("duration_answer")
    val duration_answer: String? = null,
    @SerializedName("duration_is_active")
    val duration_is_active: String? = null,
    @SerializedName("duration_is_deleted")
    val duration_is_deleted: String? = null,
    @SerializedName("duration_updated_by")
    val duration_updated_by: String? = null,
    @SerializedName("duration_created_at")
    val duration_created_at: String? = null,
    @SerializedName("duration_updated_at")
    val duration_updated_at: String? = null,
    @SerializedName("occur_patient_incident_rel_id")
    val occur_patient_incident_rel_id: String? = null,
    @SerializedName("occur_incident_tracking_master_id")
    val occur_incident_tracking_master_id: String? = null,
    @SerializedName("occur_question_id")
    val occur_question_id: String? = null,
    @SerializedName("occur_question")
    val occur_question: String? = null,
    @SerializedName("occur_answer")
    val occur_answer: String? = null,
    @SerializedName("occur_is_active")
    val occur_is_active: String? = null,
    @SerializedName("occur_is_deleted")
    val occur_is_deleted: String? = null,
    @SerializedName("occur_updated_by")
    val occur_updated_by: String? = null,
    @SerializedName("occur_created_at")
    val occur_created_at: String? = null,
    @SerializedName("occur_updated_at")
    val occur_updated_at: String? = null,
) {
    val formattedDate: String
        get() {
            return try {
                //dateUTC
                DateTimeFormatter.date(duration_updated_at,
                    DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            } catch (e: Exception) {
                ""
            }
        }
}