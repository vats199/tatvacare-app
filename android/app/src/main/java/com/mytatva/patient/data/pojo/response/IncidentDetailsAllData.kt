package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class IncidentDetailsAllData(
    @SerializedName("question_occurance")
    val question_occurance: IncidentDetailsMainData? = null,
    @SerializedName("ques_ans_list")
    val ques_ans_list: ArrayList<IncidentDetailsData>? = null,
)