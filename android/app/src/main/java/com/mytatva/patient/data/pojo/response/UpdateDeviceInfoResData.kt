package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class UpdateDeviceInfoResData(
    @SerializedName("maintainance")
    val maintainance: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("message")
    val message: String? = null,
)