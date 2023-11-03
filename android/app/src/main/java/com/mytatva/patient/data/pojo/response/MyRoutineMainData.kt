package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class MyRoutineMainData(
    @SerializedName("is_rest_day")
    val is_rest_day: String? = null,
    @SerializedName("plan_details")
    val plan_details: PlanDetails? = null,
    @SerializedName("exercise_details")
    val exercise_details: ArrayList<RoutinesData>? = null,
)

data class PlanDetails(
    @SerializedName("patient_exercise_plans_id")
    val patient_exercise_plans_id: String? = null,
    @SerializedName("exercise_plan_name")
    val exercise_plan_name: String? = null,
    @SerializedName("medical_condition_group_id")
    val medical_condition_group_id: String? = null,
    @SerializedName("start_date")
    val start_date: String? = null,
    @SerializedName("end_date")
    val end_date: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("assigned_by")
    val assigned_by: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
)

data class RoutinesData(
    @SerializedName("routine_no")
    val routine_no: String? = null,
    @SerializedName("exercise_details")
    val exercise_details: ArrayList<RoutineExerciseData>? = null,
)

data class RoutineExerciseData(
    @SerializedName("patient_exercise_plans_list_rel_id")
    val patient_exercise_plans_list_rel_id: String? = null,
    @SerializedName("patient_exercise_plans_id")
    val patient_exercise_plans_id: String? = null,
    @SerializedName("week_no")
    val week_no: String? = null,
    @SerializedName("day_no")
    val day_no: String? = null,
    @SerializedName("date")
    val date: String? = null,
    @SerializedName("rest_day")
    val rest_day: String? = null,
    @SerializedName("routine_no")
    val routine_no: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("content_type")
    val content_type: String? = null,
    @SerializedName("reps")
    val reps: String? = null,
    @SerializedName("sets")
    val sets: String? = null,
    @SerializedName("rest_post_sets")
    val rest_post_sets: String? = null,
    @SerializedName("rest_post_sets_unit")
    val rest_post_sets_unit: String? = null,
    @SerializedName("rest_post_exercise")
    val rest_post_exercise: String? = null,
    @SerializedName("rest_post_exercise_unit")
    val rest_post_exercise_unit: String? = null,
    @SerializedName("order_no")
    val order_no: String? = null,
    @SerializedName("done")
    var done: String? = null,
    @SerializedName("difficulty_level")
    var difficulty_level: String? = null,
    @SerializedName("done_duration")
    val done_duration: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("description")
    val description: String? = null,
    @SerializedName("time_duration")
    val time_duration: String? = null,
    @SerializedName("duration_unit")
    val duration_unit: String? = null,
    @SerializedName("breathing_exercise")
    val breathing_exercise: String? = null,
    @SerializedName("media")
    val media: ContentMediaData? = null,
    @SerializedName("fit_start_time")
    var fit_start_time: String? = null,
    @SerializedName("fit_end_time")
    var fit_end_time: String? = null,
) {
    val getTimeDuration: Int
        get() {
            return time_duration?.toDoubleOrNull()?.toInt() ?: 0
        }
}
