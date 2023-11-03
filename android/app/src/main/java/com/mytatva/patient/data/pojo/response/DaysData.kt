package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class DaysData(
    @SerializedName("days_keys")
    val days_keys: String? = null,
    @SerializedName("day")
    val day: String? = null,
    @SerializedName("language_id")
    val language_id: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
) {
    var isSelected: Boolean = false
}