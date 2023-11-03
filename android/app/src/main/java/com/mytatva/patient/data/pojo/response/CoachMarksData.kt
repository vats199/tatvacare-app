package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class CoachMarksData(
    @SerializedName("coach_marks_id")
    val coach_marks_id: String? = null,
    @SerializedName("page")
    val page: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
)