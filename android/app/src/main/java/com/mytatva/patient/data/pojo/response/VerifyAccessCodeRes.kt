package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName


class VerifyAccessCodeRes(
    @SerializedName("patient_doctor_request_id")
    val patient_doctor_request_id: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("access_code")
    val access_code: String? = null,
    @SerializedName("patient_contact_no")
    val patient_contact_no: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("link")
    val link: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("doctor_id")
    val doctor_id: String? = null,
    @SerializedName("patient_email")
    val patient_email: String? = null,
    @SerializedName("name")
    val name: String? = null,
)