package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class GetPrescriptionDetailsResData(
    @SerializedName("medicine_data")
    val medicine_data: ArrayList<MedicineResData>? = null,
    @SerializedName("document_data")
    val document_data: ArrayList<DocumentResData>? = null,
)

class MedicineResData(
    @SerializedName("patient_dose_rel_id")
    val patient_dose_rel_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("dose_id")
    val dose_id: String? = null,
    @SerializedName("dose_type")
    val dose_type: String? = null,
    @SerializedName("medecine_id")
    val medecine_id: String? = null,
    @SerializedName("medicine_name")
    val medicine_name: String? = null,
    @SerializedName("start_date")
    val start_date: String? = null,
    @SerializedName("end_date")
    val end_date: String? = null,
    @SerializedName("dose_days")
    val dose_days: String? = null,
    @SerializedName("dose_time_slot")
    val dose_time_slot: ArrayList<String>? = null,
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

class DocumentResData(
    @SerializedName("prescription_document_rel_id")
    val prescription_document_rel_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("document_label")
    val document_label: String? = null,
    @SerializedName("document_name")
    val document_name: String? = null,
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
    @SerializedName("document_url")
    val document_url: String? = null,
)