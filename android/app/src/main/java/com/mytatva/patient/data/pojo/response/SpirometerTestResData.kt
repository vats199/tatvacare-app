package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class SpirometerTestResData(
    @SerializedName("spirometer_reading_logs_id")
    val spirometer_reading_logs_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("parent_event_id")
    val parent_event_id: String? = null,
    @SerializedName("test_date_time")
    val test_date_time: String? = null,
    @SerializedName("fvc")
    val fvc: String? = null,
    @SerializedName("fvc_percentage")
    val fvc_percentage: String? = null,
    @SerializedName("fev1")
    val fev1: String? = null,
    @SerializedName("fev1_percentage")
    val fev1_percentage: String? = null,
    @SerializedName("fvc_fev1_ratio")
    val fvc_fev1_ratio: String? = null,
    @SerializedName("fvc_fev1_ratio_percentage")
    val fvc_fev1_ratio_percentage: String? = null,
    @SerializedName("pef")
    val pef: String? = null,
    @SerializedName("pef_percentage")
    val pef_percentage: String? = null,
    @SerializedName("incentive_current_volume")
    val incentive_current_volume: String? = null,
    @SerializedName("incentive_target_volume")
    val incentive_target_volume: String? = null,
    @SerializedName("document")
    val document: String? = null,
    @SerializedName("test_type")
    val test_type: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("document_url")
    val document_url: String? = null,
    @SerializedName("fvc_unit")
    val fvc_unit: String? = null,
    @SerializedName("fev1_unit")
    val fev1_unit: String? = null,
    @SerializedName("fvc_fev1_ratio_unit")
    val fvc_fev1_ratio_unit: String? = null,
    @SerializedName("pef_unit")
    val pef_unit: String? = null,
)