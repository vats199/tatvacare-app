package com.mytatva.patient.data.model

import com.google.gson.annotations.SerializedName

data class ApXorKeyValueData(
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("value")
    val value: String? = null,
)