package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class BookmarkedContentData(
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("display_value")
    val display_value: String? = null,
    @SerializedName("data")
    val data: ArrayList<ContentData>? = null,
)