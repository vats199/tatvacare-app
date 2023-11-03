package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class FoodLogResData(
    @SerializedName("total_calories_consumed")
    val total_calories_consumed: String? = null,
    @SerializedName("goal_value")
    val goal_value: String? = null,
    @SerializedName("data")
    val data: ArrayList<FoodLogMainData>? = null,
)

class FoodLogMainData(
    @SerializedName("meal_types_id")
    val meal_types_id: String? = null,
    @SerializedName("meal_type")
    val meal_type: String? = null,
    @SerializedName("keys")
    val keys: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("patient_meal_rel_id")
    val patient_meal_rel_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("total_carbs")
    val total_carbs: String? = null,
    @SerializedName("total_protein")
    val total_protein: String? = null,
    @SerializedName("total_fat")
    val total_fat: String? = null,
    @SerializedName("total_cal")
    val total_cal: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("meal_data")
    val meal_data: ArrayList<FoodLogSubData>? = null,
    @SerializedName("image_url")
    val image_url:ArrayList<String>?=null,
    var isSelected: Boolean = false,
    @SerializedName("cal_unit_name")
    val cal_unit_name: String? = "Cal",
)

class FoodLogSubData(
    @SerializedName("patient_food_logs_id")
    val patient_food_logs_id: String? = null,
    @SerializedName("patient_meal_rel_id")
    val patient_meal_rel_id: String? = null,
    @SerializedName("food_item_id")
    val food_item_id: String? = null,
    @SerializedName("food_name")
    val food_name: String? = null,
    @SerializedName("quantity")
    val quantity: String? = null,
    @SerializedName("fat")
    val fat: String? = null,
    @SerializedName("protein")
    val protein: String? = null,
    @SerializedName("carbohydrate")
    val carbohydrate: String? = null,
    @SerializedName("calories")
    val calories: String? = null,
    @SerializedName("updated_from")
    val updated_from: String? = null,
    @SerializedName("unit_name")
    val unit_name: String? = null,
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
    @SerializedName("cal_unit_name")
    val cal_unit_name: String? = "Cal",
)