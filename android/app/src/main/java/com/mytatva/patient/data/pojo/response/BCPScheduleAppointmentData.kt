package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class BCPScheduleAppointmentData(
    @SerializedName("nutritionist")
    var nutritionist: HealthCoachData? = null,
    @SerializedName("physiotherapist")
    var physiotherapist: HealthCoachData? = null,
    @SerializedName("date")
    var date: String? = null,
    @SerializedName("physiotherapist_start_time")
    var physiotherapistStartTime: String? = null,
    @SerializedName("physiotherapist_end_time")
    var physiotherapistEndTime: String? = null,
    @SerializedName("nutritionist_start_time")
    var nutritionistStartTime: String? = null,
    @SerializedName("nutritionist_end_time")
    var nutritionistEndTime: String? = null,
    @SerializedName("nutritionist_availability_date")
    var nutritionistAvailabilityDate: String? = null,
    @SerializedName("physiotherapist_availability_date")
    var physiotherapistAvailabilityDate: String? = null,

    @SerializedName("physiotherapist_day")
    var physiotherapist_day: String? = null,
    @SerializedName("physiotherapist_time_type")
    var physiotherapist_time_type: String? = null,
    @SerializedName("nutritionist_day")
    var nutritionist_day: String? = null,
    @SerializedName("nutritionist_time_type")
    var nutritionist_time_type: String? = null,
)