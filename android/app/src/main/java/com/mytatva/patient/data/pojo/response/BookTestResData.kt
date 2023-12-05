package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class BookTestResData(
    @SerializedName("razorpay_order_id")
    val razorPayOrderId: String? = null,
    @SerializedName("order_master_id")
    val order_master_id: String? = null,
)