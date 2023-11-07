package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class DailySummaryData(
    @SerializedName("goals")
    val goals: List<GoalReadingData>? = null,
    @SerializedName("readings")
    val readings: List<GoalReadingData>? = null,
    @SerializedName("mark_as_today")
    val mark_as_today: MarkAsToday? = null,
    @SerializedName("diet")
    val diet: Diet? = null,
)

class MyHealthInsightData(
    @SerializedName("goal_data")
    val goals: List<GoalReadingData>? = null,
    @SerializedName("readings_response")
    val readings: List<GoalReadingData>? = null
)

class MarkAsToday(
    @SerializedName("breathing_done")
    val breathing_done: String? = null,
    @SerializedName("exercise_done")
    val exercise_done: String? = null,
)

class Diet(
    @SerializedName("patient_healthcoach_diet_plan_id")
    val patient_healthcoach_diet_plan_id: String? = null,
    @SerializedName("health_coach_id")
    val health_coach_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("calories")
    val calories: String? = null,
    @SerializedName("protein")
    val protein: String? = null,
    @SerializedName("fats")
    val fats: String? = null,
    @SerializedName("carbs")
    val carbs: String? = null,
    @SerializedName("start_date")
    val start_date: String? = null,
    @SerializedName("valid_till")
    val valid_till: String? = null,
    @SerializedName("document_title")
    val document_title: String? = null,
    @SerializedName("file_name")
    val file_name: String? = null,
    @SerializedName("document_name")
    val document_name: String? = null,
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
    @SerializedName("first_name")
    val first_name: String? = null,
    @SerializedName("last_name")
    val last_name: String? = null,
    @SerializedName("document_url")
    val document_url: String? = null,
)