package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
class FoodInsightResData(
    @SerializedName("meal_energy_distribution")
    val meal_energy_distribution: ArrayList<MealEnergyDistribution>? = null,
    @SerializedName("macronutrition_analysis")
    val macronutrition_analysis: ArrayList<MacronutritionAnalysis>? = null,
    @SerializedName("total_calories_consume")
    val total_calories_consume: String? = null,
    @SerializedName("total_calories_required")
    val total_calories_required: String? = null,
    @SerializedName("target_value")
    val target_value: String? = null,
    @SerializedName("achieved_value")
    val achieved_value: String? = null,
    @SerializedName("todays_achieved_value")
    val todays_achieved_value: String? = null,
    @SerializedName("goal_master_id")
    val goal_master_id: String? = null,
) : Parcelable

@Parcelize
class MealEnergyDistribution(
    @SerializedName("calories_taken")
    val calories_taken: String? = null,
    @SerializedName("meal_type")
    val meal_type: String? = null,
    @SerializedName("cal_unit_name")
    val cal_unit_name: String? = "Cal",
    @SerializedName("recommended")
    val recommended: String? = null,
    @SerializedName("limit")
    val limit: String? = null,
    @SerializedName("color_code")
    val color_code: String? = null,
) : Parcelable

@Parcelize
class MacronutritionAnalysis(
    @SerializedName("key")
    val key: String? = null,
    @SerializedName("taken")
    val taken: String? = null,
    @SerializedName("recommended")
    val recommended: String? = null,
    @SerializedName("unit_name")
    val unit_name: String? = null,
    @SerializedName("label")
    val label: String? = null,
    @SerializedName("limit")
    val limit: String? = null,
    @SerializedName("color_code")
    val color_code: String? = null,
) : Parcelable