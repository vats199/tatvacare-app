package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class AskAnExpertFiltersData(
    @SerializedName("topic")
    val topic: List<TopicsData>? = null,
    @SerializedName("question_type")
    val question_type: List<QuestionTypeData>? = null,
)

class QuestionTypeData(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("value")
    val value: String? = null,
    var isSelected:Boolean=false
)