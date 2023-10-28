package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class WeightGoalMonthsData(
    @SerializedName("rate")
    val rate: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("months")
    val months: String? = null,
)