package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class MyPrescriptionMainData(
    @SerializedName("date")
    val date: String? = null,
    @SerializedName("data")
    val data: ArrayList<PrescriptionDocument>? = null,
)

data class PrescriptionDocument(
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
    @SerializedName("added_by")
    val added_by: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
)
