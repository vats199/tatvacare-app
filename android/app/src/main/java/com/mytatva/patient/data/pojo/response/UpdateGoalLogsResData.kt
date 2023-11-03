package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class UpdateGoalLogsResData(
    @SerializedName("patient_goal_logs_id")
    val patient_goal_logs_id: String? = null,
    @SerializedName("patient_goal_rel_id")
    val patient_goal_rel_id: String? = null,
    @SerializedName("target_value")
    val target_value: String? = null,
    @SerializedName("achieved_value")
    val achieved_value: String? = null,
    @SerializedName("todays_achieved_value")
    val todays_achieved_value: String? = null,
    @SerializedName("achieved_datetime")
    val achieved_datetime: String? = null,
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
    @SerializedName("source_id")
    val source_id: String? = null,
    @SerializedName("source_name")
    val source_name: String? = null,
    @SerializedName("patient_sub_goal_id")
    val patient_sub_goal_id: String? = null,
    @SerializedName("start_time")
    val start_time: String? = null,
    @SerializedName("end_time")
    val end_time: String? = null,
)