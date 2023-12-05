package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class TestPatientData(
    @SerializedName("patient_member_rel_id")
    val patient_member_rel_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("email")
    val email: String? = null,
    @SerializedName("age")
    val age: String? = null,
    @SerializedName("gender")
    val gender: String? = null,
    @SerializedName("indication")
    val indication: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
) : Parcelable