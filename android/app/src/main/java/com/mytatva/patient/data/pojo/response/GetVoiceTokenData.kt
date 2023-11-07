package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class GetVoiceTokenData(
    @SerializedName("token")
    val token: String? = null,
    @SerializedName("identity")
    val identity: String? = null,
)