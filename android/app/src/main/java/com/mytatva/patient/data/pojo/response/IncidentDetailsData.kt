package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class IncidentDetailsData(
    @SerializedName("patient_incident_rel_id")
    val patient_incident_rel_id: String? = null,
    @SerializedName("incident_tracking_master_id")
    val incident_tracking_master_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("survey_id")
    val survey_id: String? = null,
    @SerializedName("question_id")
    val question_id: String? = null,
    @SerializedName("question")
    val question: String? = null,
    @SerializedName("answer")
    val answer: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
)