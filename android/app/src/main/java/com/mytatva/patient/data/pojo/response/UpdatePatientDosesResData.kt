package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class UpdatePatientDosesResData(
    @SerializedName("goal_value")
    val goal_value: String? = null,
    @SerializedName("achieved_value")
    val achieved_value: String? = null,
    @SerializedName("todays_achieved_value")
    val todays_achieved_value: String? = null,
)