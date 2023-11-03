package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class CatSurveyData(
    @SerializedName("cat_survey_master_id")
    val cat_survey_master_id: String? = null,
    @SerializedName("medical_condition_group_id")
    val medical_condition_group_id: String? = null,
    @SerializedName("survey_id")
    val survey_id: String? = null,
    @SerializedName("deep_link")
    val deep_link: String? = null,
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
    @SerializedName("readings_master_id")
    val readings_master_id: String? = null,
    @SerializedName("reading_name")
    val reading_name: String? = null,
)