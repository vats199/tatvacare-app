package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class GetBcaReadingsMainData(
    @SerializedName("last_sync_date")
    val last_sync_date: String? = null,
    @SerializedName("readings")
    val readings: ArrayList<GoalReadingData>? = null,
)