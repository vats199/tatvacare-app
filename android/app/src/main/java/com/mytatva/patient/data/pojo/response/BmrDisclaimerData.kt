package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class BmrDisclaimerData(
    @SerializedName("bmi")
    val bmi: String? = null,
    @SerializedName("calories")
    val calories: String? = null,
)