package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.data.pojo.RazorPayResponseBody

class CreateSubscriptionData(
    @SerializedName("id")
    val id: String? = null
) : RazorPayResponseBody()