package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.data.pojo.User

data class BcpMyDevicesData(
    @SerializedName("address_data")
    val address_data: TestAddressData? = null,
    @SerializedName("patient_details")
    val patient_details: User? = null,
    @SerializedName("devices")
    val devices: ArrayList<MyDevicesData>? = null,
    @SerializedName("status")
    val status: String? = null,
    @SerializedName("transaction_id")
    val transaction_id: String? = null,
)

/*
data class Devices(
    @SerializedName("key")
    val key: String? = null,
    @SerializedName("title")
    val title: String? = null,
)*/
