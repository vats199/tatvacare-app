package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class AddPlanResData(
    @SerializedName("patient_plan_rel_id")
    val patient_plan_rel_id: String? = null,
)