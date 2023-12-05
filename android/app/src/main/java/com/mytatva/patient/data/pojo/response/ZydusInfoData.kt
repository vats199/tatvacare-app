package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class ZydusInfoData(
    @SerializedName("zydus_phone")
    val zydus_phone: String? = null,
    @SerializedName("zydus_address")
    val zydus_address: String? = null,
    @SerializedName("zydus_name")
    val zydus_name: String? = null,
    @SerializedName("zydus_email")
    val zydus_email: String? = null,
    @SerializedName("zydus_pdf")
    val zydus_pdf: String? = null,
)