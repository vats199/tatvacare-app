package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class ExerciseMainData(
    @SerializedName("genre_master_id")
    val genre_master_id: String? = null,
    @SerializedName("genre")
    val genre: String? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("content_data")
    val content_data: ArrayList<ContentData>? = null,
)