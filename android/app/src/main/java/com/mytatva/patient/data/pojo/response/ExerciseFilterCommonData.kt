package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
class ExerciseFilterCommonData(
    @SerializedName("exercise_tools")
    val exercise_tools: String? = null,
    @SerializedName("from_time")
    val from_time: String? = null,
    @SerializedName("to_time")
    val to_time: String? = null,
    @SerializedName("show_time")
    val show_time: String? = null,
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
    @SerializedName("fitness_level")
    val fitness_level: String? = null,
    var isSelected: Boolean = false,
) : Parcelable