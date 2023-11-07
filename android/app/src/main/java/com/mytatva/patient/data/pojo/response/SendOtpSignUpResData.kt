package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class SendOtpSignUpResData(
    @SerializedName("doctor_access_code")
    val doctor_access_code: String? = null,
    @SerializedName("access_code")
    val access_code: String? = null,
)
