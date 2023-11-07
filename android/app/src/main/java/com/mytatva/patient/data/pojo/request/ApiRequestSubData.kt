package com.mytatva.patient.data.pojo.request

import com.google.gson.annotations.SerializedName

class ApiRequestSubData {

    @SerializedName("bcp_total_amount_old")
    var bcp_total_amount_old: String? = null

    @SerializedName("bcp_total_amount")
    var bcp_total_amount: String? = null

    @SerializedName("bcp_home_collection_charge_old")
    var bcp_home_collection_charge_old: String? = null

    @SerializedName("bcp_home_collection_charge")
    var bcp_home_collection_charge: String? = null

    @SerializedName("bcp_service_charge")
    var bcp_service_charge: String? = null

    @SerializedName("bcp_final_amount_to_pay")
    var bcp_final_amount_to_pay: String? = null


    @SerializedName("patient_exercise_plans_list_rel_id")
    var patient_exercise_plans_list_rel_id: String? = null

    @SerializedName("done")
    var done: String? = null

    @SerializedName("prescription_name")
    var prescription_name: String? = null

    @SerializedName("prescription_document_rel_id")
    var prescription_document_rel_id: String? = null

    @SerializedName("dose_id")
    var dose_id: String? = null

    @SerializedName("food_name")
    var food_name: String? = null

    @SerializedName("document")
    var document: String? = null

    @SerializedName("document_type")
    var document_type: String? = null

    @SerializedName("dose_name")
    var dose_name: String? = null

    @SerializedName("meal_types_id")
    var meal_types_id: String? = null

    @SerializedName("meal_time")
    var meal_time: String? = null

    @SerializedName("days_of_week")
    var days_of_week: String? = null

    @SerializedName("frequency")
    var frequency: String? = null

    @SerializedName("day_time")
    var day_time: String? = null

    @SerializedName("readings_master_id")
    var readings_master_id: String? = null


    @SerializedName("is_active")
    var is_active: String? = null

    @SerializedName("medicine_name")
    var medicine_name: String? = null

    @SerializedName("medecine_id")
    var medecine_id: String? = null

    @SerializedName("start_date")
    var start_date: String? = null

    @SerializedName("end_date")
    var end_date: String? = null

    @SerializedName("dose_days")
    var dose_days: String? = null

    @SerializedName("dose_time_slot")
    var dose_time_slot: List<String>? = null


    @SerializedName("reading_id")
    var reading_id: String? = null

    @SerializedName("reading_datetime")
    var reading_datetime: String? = null


    @SerializedName("goal_id")
    var goal_id: String? = null

    @SerializedName("goal_value")
    var goal_value: String? = null

    @SerializedName("mandatory")
    var mandatory: String? = null

    @SerializedName("height")
    var height: String? = null

    @SerializedName("weight")
    var weight: String? = null

    @SerializedName("fast")
    var fast: String? = null

    @SerializedName("pp")
    var pp: String? = null

    @SerializedName("diastolic")
    var diastolic: String? = null

    @SerializedName("systolic")
    var systolic: String? = null

    @SerializedName("dose_status")
    var dose_status: ArrayList<DoseStatusData>? = null

    @SerializedName("patient_dose_rel_id")
    var patient_dose_rel_id: String? = null

    @SerializedName("genre_ids")
    var genre_ids: ArrayList<String>? = null

    @SerializedName("topic_ids")
    var topic_ids: ArrayList<String>? = null

    @SerializedName("content_types")
    var content_types: ArrayList<String>? = null

    @SerializedName("show_time")
    var show_time: ArrayList<String>? = null

    @SerializedName("exercise_tools")
    var exercise_tools: ArrayList<String>? = null

    @SerializedName("fitness_level")
    var fitness_level: ArrayList<String>? = null

    @SerializedName("page")
    var page: String? = null

    @SerializedName("genre_master_id")
    var genre_master_id: String? = null

    @SerializedName("recommended_health_doctor")
    var recommended_health_doctor: Boolean? = null

    @SerializedName("search")
    var search: String? = null

    @SerializedName("languages_id")
    var languages_id: ArrayList<String>? = null

    @SerializedName("id")
    var id: String? = null

    @SerializedName("question")
    var question: String? = null

    @SerializedName("answer")
    var answer: Any? = null

    @SerializedName("start_time")
    var start_time: String? = null

    @SerializedName("end_time")
    var end_time: String? = null

    @SerializedName("achieved_datetime")
    var achieved_datetime: String? = null

    @SerializedName("end_datetime")
    var end_datetime: String? = null

    @SerializedName("achieved_value")
    var achieved_value: String? = null

    @SerializedName("patient_sub_goal_id")
    var patient_sub_goal_id: String? = null

    @SerializedName("sleep_achieved_value")
    var sleep_achieved_value: String? = null

    @SerializedName("goal_key")
    var goal_key: String? = null

    @SerializedName("sub_goal_key")
    var sub_goal_key: String? = null

    @SerializedName("source_id")
    var source_id: String? = null

    @SerializedName("reading_key")
    var reading_key: String? = null

    @SerializedName("source_name")
    var source_name: String? = null

    @SerializedName("reading_value")
    var reading_value: String? = null

    @SerializedName("reading_value_data")
    var reading_value_data: ApiRequestSubData? = null

    @SerializedName("food_item_id")
    var food_item_id: String? = null

    @SerializedName("quantity")
    var quantity: String? = null

    @SerializedName("unit_name")
    var unit_name: String? = null

    @SerializedName("calories")
    var calories: String? = null


    @SerializedName("sgot")
    var sgot: String? = null

    @SerializedName("sgpt")
    var sgpt: String? = null

    @SerializedName("platelet")
    var platelet: String? = null

    @SerializedName("lsm")
    var lsm: String? = null

    @SerializedName("cap")
    var cap: String? = null

    @SerializedName("ldl_cholesterol")
    var ldl_cholesterol: String? = null

    @SerializedName("hdl_cholesterol")
    var hdl_cholesterol: String? = null

    @SerializedName("triglycerides")
    var triglycerides: String? = null

    @SerializedName("sleep_start_time")
    var sleep_start_time: String? = null

    @SerializedName("sleep_end_time")
    var sleep_end_time: String? = null

    @SerializedName("sleep_time_difference")
    var sleep_time_difference: String? = null

    @SerializedName("exercise_start_time")
    var exercise_start_time: String? = null

    @SerializedName("exercise_end_time")
    var exercise_end_time: String? = null

    @SerializedName("physical_time_difference")
    var physical_time_difference: String? = null

}

class DoseStatusData {
    @SerializedName("dose_time_slot")
    var dose_time_slot: String? = null

    @SerializedName("dose_taken")
    var dose_taken: String? = null
}