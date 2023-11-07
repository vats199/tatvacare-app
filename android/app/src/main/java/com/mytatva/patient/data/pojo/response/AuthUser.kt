package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class AuthUser(
    @SerializedName("temp_patient_id")
    val temp_patient_id: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("contact_no")
    val contact_no: String? = null,
    @SerializedName("email")
    val email: String? = null,
    @SerializedName("gender")
    val gender: String? = null,
    @SerializedName("dob")
    val dob: String? = null,
    @SerializedName("account_role")
    val account_role: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("severity_id")
    val severity_id: String? = null,
    @SerializedName("severity_name")
    val severity_name: String? = null,
    @SerializedName("patient_guid")
    val patient_guid: String? = null,
    @SerializedName("medical_condition_group_id")
    val medical_condition_group_id: String? = null,
    @SerializedName("indication_name")
    val indication_name: String? = null,
    @SerializedName("access_code")
    val access_code: String? = null,
    @SerializedName("temp_patient_signup_id")
    val temp_patient_signup_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("step")
    val step: String? = null,
    @SerializedName("doctor_access_code")
    val doctor_access_code: String? = null,
    @SerializedName("relation")
    val relation: String? = null,
    @SerializedName("sub_relation")
    val sub_relation: String? = null,
    @SerializedName("token")
    val token: String? = null,
) : Parcelable
