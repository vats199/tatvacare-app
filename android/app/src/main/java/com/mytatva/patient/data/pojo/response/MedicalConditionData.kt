package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class MedicalConditionData(
    @SerializedName("medical_condition_master_id")
    val medical_condition_master_id: String? = null,
    @SerializedName("medical_condition_group_id")
    var medical_condition_group_id: String? = null,
    @SerializedName("medical_condition_name")
    var medical_condition_name: String? = null,
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
    @SerializedName("selected_imagess")
    val selected_imagess: String? = null,
    @SerializedName("unselected_imagess")
    val unselected_imagess: String? = null,
    @SerializedName("is_other")
    val is_other: String? = null,
    var isSelected : Boolean = false
)