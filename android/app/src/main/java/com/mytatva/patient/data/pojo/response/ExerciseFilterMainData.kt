package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class ExerciseFilterMainData(
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("label")
    val label: String? = null,
    @SerializedName("data")
    val data: ArrayList<ExerciseFilterCommonData>? = null,
)