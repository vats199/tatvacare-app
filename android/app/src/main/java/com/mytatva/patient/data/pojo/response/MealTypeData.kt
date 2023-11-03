package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class MealTypeData(
    @SerializedName("meal_types_id")
    val meal_types_id: String? = null,
    @SerializedName("meal_type")
    val meal_type: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("keys")
    val keys: String? = null,
)