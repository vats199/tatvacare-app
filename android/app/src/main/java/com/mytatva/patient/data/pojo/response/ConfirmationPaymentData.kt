package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class ConfirmationPaymentData(
    @SerializedName("order_master_id")
    val order_master_id: String? = null,
)