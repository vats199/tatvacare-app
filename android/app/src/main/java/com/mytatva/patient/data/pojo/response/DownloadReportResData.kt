package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class DownloadReportResData(
    @SerializedName("url")
    val url: String? = null,
)