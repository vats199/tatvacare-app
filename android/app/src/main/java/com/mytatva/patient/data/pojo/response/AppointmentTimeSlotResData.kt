package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class AppointmentTimeSlotResData(
    @SerializedName("Response Code")
    val responseCode: String? = null,
    @SerializedName("status_update")
    val status_update: String? = null,
    @SerializedName("result")
    val result: TimeSlotResult? = null,
)

class TimeSlotResult(
    @SerializedName("time_slot")
    val time_slot: ArrayList<TimeSlotData>? = null,
)

class TimeSlotData(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("icon_url")
    val icon_url: String? = null,
    @SerializedName("slots")
    val slots: ArrayList<String>? = null,
)

class LabTestTimeSlotData(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("icon_url")
    val icon_url: String? = null,
    @SerializedName("slots")
    val slots: ArrayList<SlotsData>? = null,
)

class SlotsData(
    @SerializedName("time") var time: String? = null,
    @SerializedName("slot_id") var slotId: String? = null,
    @SerializedName("type") var type: String? = null
)