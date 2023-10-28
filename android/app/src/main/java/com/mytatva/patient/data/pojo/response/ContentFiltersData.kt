package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class ContentFiltersData(
    @SerializedName("language")
    val language: List<LanguageData>? = null,
    @SerializedName("topic")
    val topic: List<TopicsData>? = null,
    @SerializedName("genre")
    val genre: List<GenreData>? = null,
    @SerializedName("content_type")
    val content_type: List<ContentTypeData>? = null,
)