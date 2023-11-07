package com.mytatva.patient.data.pojo.request

import com.google.gson.annotations.SerializedName

class ApiRequest {

    @SerializedName("is_active_medicine_only")
    var is_active_medicine_only: String? = null

    @SerializedName("home")
    var home: Boolean? = null

    @SerializedName("order_master_id")
    var order_master_id: String? = null

    @SerializedName("message")
    var message: String? = null

    @SerializedName("lab_test_id")
    var lab_test_id: String? = null

    @SerializedName("code")
    var code: String? = null

    @SerializedName("bcp_flag")
    var bcp_flag: String? = null

    @SerializedName("separate")
    var separate: String? = null

    @SerializedName("address_id")
    var address_id: String? = null

    @SerializedName("Pincode")
    var Pincode: String? = null

    @SerializedName("pincode")
    var pincodeSmall: String? = null

    @SerializedName("Date")
    var Date: String? = null

    @SerializedName("address_type")
    var address_type: String? = null

    @SerializedName("street")
    var street: String? = null

    @SerializedName("room_id")
    var room_id: String? = null

    @SerializedName("room_name")
    var room_name: String? = null

    @SerializedName("question")
    var question: String? = null

    @SerializedName("topic_ids")
    var topic_ids: ArrayList<String>? = null

    @SerializedName("top_answer_id")
    var top_answer_id: String? = null

    @SerializedName("question_types")
    var question_types: ArrayList<String>? = null

    @SerializedName("documents")
    var documents: ArrayList<ApiRequestSubData>? = null

    @SerializedName("mark_as_done_data")
    var mark_as_done_data: ArrayList<ApiRequestSubData>? = null

    @SerializedName("phone_number")
    var phone_number: String? = null

    @SerializedName("email")
    var email: String? = null

    @SerializedName("relation")
    var relation: String? = null

    @SerializedName("sub_relation")
    var sub_relation: String? = null

    @SerializedName("plan_id")
    var plan_id: String? = null

    @SerializedName("duration_type")
    var duration_type: String? = null

    @SerializedName("plan_date")
    var plan_date: String? = null

    @SerializedName("live")
    var live: String? = null

    @SerializedName("dev")
    var dev: String? = null

    @SerializedName("answer_id")
    var answer_id: String? = null

    @SerializedName("total_count")
    var total_count: Int? = null

    @SerializedName("plan_master_id")
    var plan_master_id: String? = null

    @SerializedName("transaction_id")
    var transaction_id: String? = null

    @SerializedName("patient_address_rel_id")
    var patient_address_rel_id: String? = null

    @SerializedName("plan_package_duration_rel_id")
    var plan_package_duration_rel_id: String? = null

    @SerializedName("patient_plan_rel_id")
    var patient_plan_rel_id: String? = null

    @SerializedName("bcp_test_price_data")
    var bcp_test_price_data:ApiRequestSubData?=null

    @SerializedName("is_bcp_tests_added")
    var is_bcp_tests_added: String? = null

    @SerializedName("dob")
    var dob: String? = null

    @SerializedName("current_weight")
    var current_weight: String? = null

    @SerializedName("goal_weight")
    var goal_weight: String? = null

    @SerializedName("height")
    var height: String? = null

    @SerializedName("weight")
    var weight: String? = null

    @SerializedName("weight_unit")
    var weight_unit: String? = null

    @SerializedName("height_unit")
    var height_unit: String? = null

    @SerializedName("gender")
    var gender: String? = null

    @SerializedName("profile_pic")
    var profile_pic: String? = null

    @SerializedName("address")
    var address: String? = null

    @SerializedName("month")
    var month: String? = null

    @SerializedName("study_id")
    var study_id: String? = null

    @SerializedName("year")
    var year: String? = null

    @SerializedName("contact_no")
    var contact_no: String? = null

    @SerializedName("otp")
    var otp: String? = null

    @SerializedName("password")
    var password: String? = null

    @SerializedName("email_verified")
    var email_verified: String? = null

    @SerializedName("account_role")
    var account_role: String? = null

    @SerializedName("conf_password")
    var conf_password: String? = null

    @SerializedName("whatsapp_optin")
    var whatsapp_optin: String? = null

    @SerializedName("is_accept_terms_accept")
    var is_accept_terms_accept: String? = null

    @SerializedName("active_deactive_id")
    var active_deactive_id: String? = null


    @SerializedName("slot_time")
    var slot_time: String? = null

    @SerializedName("order_total")
    var order_total: String? = null

    @SerializedName("payable_amount")
    var payable_amount: String? = null

    @SerializedName("final_payable_amount")
    var final_payable_amount: String? = null

    @SerializedName("amount")
    var amount: String? = null

    @SerializedName("service_charge")
    var service_charge: String? = null

    @SerializedName("home_collection_charge")
    var home_collection_charge: String? = null

    @SerializedName("member_id")
    var member_id: String? = null

    @SerializedName("age")
    var age: String? = null

    @SerializedName("indication")
    var indication: String? = null

    @SerializedName("name")
    var name: String? = null

    @SerializedName("access_code")
    var access_code: String? = null

    @SerializedName("access_from")
    var access_from: String? = null

    @SerializedName("doctor_access_code")
    var doctor_access_code: String? = null

    @SerializedName("languages_id")
    var languages_id: String? = null

    @SerializedName("medical_condition_ids")
    var medical_condition_ids: ArrayList<String>? = null

    @SerializedName("medical_condition_group_id")
    var medical_condition_group_id: String? = null

    @SerializedName("medicine_name")
    var medicine_name: String? = null

    @SerializedName("device_token")
    var device_token: String? = null

    @SerializedName("device_type")
    var device_type: String? = null

    @SerializedName("purchase_amount")
    var purchase_amount: String? = null

    @SerializedName("subscription_id")
    var subscription_id: String? = null

    @SerializedName("uuid")
    var uuid: String? = null

    @SerializedName("os_version")
    var os_version: String? = null

    @SerializedName("device_name")
    var device_name: String? = null

    @SerializedName("model_name")
    var model_name: String? = null

    @SerializedName("version_number")
    var version_number: String? = null

    @SerializedName("build_version_number")
    var build_version_number: String? = null

    @SerializedName("ip")
    var ip: String? = null

    @SerializedName("optional_update")
    var optional_update: String? = null

    @SerializedName("lat")
    var lat: String? = null

    @SerializedName("long")
    var long: String? = null

    @SerializedName("api_version")
    var api_version: String? = null

    @SerializedName("app_version")
    var app_version: String? = null

    @SerializedName("city")
    var city: String? = null

    @SerializedName("state")
    var state: String? = null

    @SerializedName("state_name")
    var state_name: String? = null

    @SerializedName("country")
    var country: String? = null

    @SerializedName("medicine_details")
    var medicine_details: ArrayList<ApiRequestSubData>? = null

    @SerializedName("document_name")
    var document_name: ArrayList<ApiRequestSubData>? = null

    @SerializedName("readings")
    var readings: ArrayList<ApiRequestSubData>? = null

    @SerializedName("goals")
    var goals: ArrayList<ApiRequestSubData>? = null

    @SerializedName("patient_goal_rel_id")
    var patient_goal_rel_id: String? = null

    @SerializedName("goal_id")
    var goal_id: String? = null

    @SerializedName("goal_time")
    var goal_time: String? = null

    @SerializedName("start_time")
    var start_time: String? = null

    @SerializedName("end_time")
    var end_time: String? = null

    @SerializedName("achieved_value")
    var achieved_value: String? = null

    @SerializedName("patient_sub_goal_id")
    var patient_sub_goal_id: String? = null

    @SerializedName("achieved_datetime")
    var achieved_datetime: String? = null

    @SerializedName("end_datetime")
    var end_datetime: String? = null

    @SerializedName("reading_id")
    var reading_id: String? = null

    @SerializedName("reading_time")
    var reading_time: String? = null

    @SerializedName("patient_exercise_plans_list_rel_id")
    var patient_exercise_plans_list_rel_id: String? = null

    @SerializedName("done")
    var done: String? = null

    @SerializedName("fit_start_time")
    var fit_start_time: String? = null

    @SerializedName("fit_end_time")
    var fit_end_time: String? = null

    @SerializedName("difficulty")
    var difficulty: String? = null

    @SerializedName("reading_datetime")
    var reading_datetime: String? = null

    @SerializedName("reading_value")
    var reading_value: String? = null

    @SerializedName("duration")
    var duration: String? = null

    @SerializedName("reading_value_data")
    var reading_value_data: ApiRequestSubData? = null

    @SerializedName("medication_data")
    var medication_data: ArrayList<ApiRequestSubData>? = null

    @SerializedName("medication_date")
    var medication_date: String? = null

    @SerializedName("page")
    var page: String? = null

    @SerializedName("search")
    var search: String? = null

    @SerializedName("page_no")
    var page_no: String? = null

    @SerializedName("filter_by_words")
    var filter_by_words: String? = null

    @SerializedName("ask_by_you")
    var ask_by_you: String? = null

    @SerializedName("plan_type")
    var plan_type: String? = null

    @SerializedName("show_plan_type")
    var show_plan_type: String? = null

    @SerializedName("content_master_id")
    var content_master_id: String? = null

    @SerializedName("comment")
    var comment: String? = null

    @SerializedName("content_comments_id")
    var content_comments_id: String? = null

    @SerializedName("is_active")
    var is_active: String? = null

    @SerializedName("notification_master_id")
    var notification_master_id: String? = null

    @SerializedName("notification_data")
    var notification_data: ArrayList<ApiRequestSubData>? = null

    @SerializedName("notify_from")
    var notify_from: String? = null

    @SerializedName("notify_to")
    var notify_to: String? = null

    @SerializedName("remind_every")
    var remind_every: String? = null

    @SerializedName("total_reminds")
    var total_reminds: String? = null

    @SerializedName("reported")
    var reported: String? = null

    @SerializedName("description")
    var description: String? = null

    @SerializedName("query_reason_master_id")
    var query_reason_master_id: String? = null

    @SerializedName("query_docs")
    var query_docs: ArrayList<String>? = null

    @SerializedName("report_type")
    var report_type: String? = null

    @SerializedName("type")
    var type: String? = null

    @SerializedName("add_type")
    var add_type: String? = null

    @SerializedName("rate")
    var rate: String? = null

    @SerializedName("months")
    var months: String? = null

    @SerializedName("activity_level")
    var activity_level: String? = null

    @SerializedName("exercise_plan_day_id")
    var exercise_plan_day_id: String? = null

    @SerializedName("routine")
    var routine: String? = null

    @SerializedName("show")
    var show: String? = null

    @SerializedName("survey_id")
    var survey_id: String? = null

    @SerializedName("score")
    var score: String? = null

    @SerializedName("cat_survey_master_id")
    var cat_survey_master_id: String? = null

    @SerializedName("poll_master_id")
    var poll_master_id: String? = null

    @SerializedName("quiz_master_id")
    var quiz_master_id: String? = null

    @SerializedName("quiz_data")
    var quiz_data: ArrayList<ApiRequestSubData>? = null

    /*@SerializedName("quiz_data")
    var quiz_data: Any? = null*/

    @SerializedName("poll_data")
    var poll_data: ArrayList<ApiRequestSubData>? = null

    @SerializedName("response")
    var response: ArrayList<ApiRequestSubData>? = null

    @SerializedName("incident_tracking_master_id")
    var incident_tracking_master_id: String? = null

    @SerializedName("patient_incident_add_rel_id")
    var patient_incident_add_rel_id: String? = null

    @SerializedName("callback_for")
    var callback_for: String? = null

    @SerializedName("patient_dose_rel_id")
    var patient_dose_rel_id: String? = null

    @SerializedName("food_name")
    var food_name: String? = null

    @SerializedName("goal_data")
    var goal_data: ArrayList<ApiRequestSubData>? = null

    @SerializedName("reading_data")
    var reading_data: ArrayList<ApiRequestSubData>? = null

    @SerializedName("meal_types_id")
    var meal_types_id: String? = null

    @SerializedName("patient_meal_rel_id")
    var patient_meal_rel_id: String? = null

    @SerializedName("meal_data")
    var meal_data: ArrayList<ApiRequestSubData>? = null

    @SerializedName("meal_date")
    var meal_date: String? = null

    @SerializedName("remind_everyday")
    var remind_everyday: String? = null

    @SerializedName("reminds_type")
    var reminds_type: String? = null

    @SerializedName("days_of_week")
    var days_of_week: String? = null

    @SerializedName("day_time")
    var day_time: String? = null

    @SerializedName("goal_type")
    var goal_type: String? = null

    @SerializedName("frequency")
    var frequency: String? = null

    @SerializedName("remind_everyday_time")
    var remind_everyday_time: String? = null

    @SerializedName("meal_images")
    var meal_images: ArrayList<String>? = null

    @SerializedName("insight_date")
    var insight_date: String? = null

    @SerializedName("test_type_id")
    var test_type_id: String? = null

    @SerializedName("test_type")
    var test_type: String? = null

    @SerializedName("title")
    var title: String? = null

    @SerializedName("document_data")
    var document_data: ArrayList<String>? = null

    @SerializedName("image_url")
    var image_url: String? = null

    @SerializedName("we_notification_id")
    var we_notification_id: String? = null

    @SerializedName("deep_link")
    var deep_link: String? = null

    @SerializedName("mesage")
    var mesage: String? = null

    @SerializedName("data")
    var data: Any? = null

    @SerializedName("health_coach_id")
    var health_coach_id: String? = null

    @SerializedName("list_type")
    var list_type: String? = null

    @SerializedName("health_coach_ids")
    var health_coach_ids: ArrayList<String>? = null

    @SerializedName("restore_id")
    var restore_id: String? = null

    @SerializedName("clinic_id")
    var clinic_id: String? = null

    @SerializedName("doctor_id")
    var doctor_id: String? = null

    @SerializedName("consulation_type")
    var consulation_type: String? = null

    @SerializedName("appointment_date")
    var appointment_date: String? = null

    @SerializedName("date")
    var bcpSlotDate: String? = null

    @SerializedName("time_slot")
    var time_slot: String? = null

    @SerializedName("appointment_id")
    var appointment_id: String? = null

    @SerializedName("type_consult")
    var type_consult: String? = null

    @SerializedName("appointment_slot")
    var appointment_slot: String? = null

    @SerializedName("nutritionist_availability_date")
    var nutritionist_availability_date: String? = null

    @SerializedName("physiotherapist_availability_date")
    var physiotherapist_availability_date: String? = null

    @SerializedName("physiotherapist_start_time")
    var physiotherapist_start_time: String? = null

    @SerializedName("physiotherapist_end_time")
    var physiotherapist_end_time: String? = null

    @SerializedName("nutritionist_start_time")
    var nutritionist_start_time: String? = null

    @SerializedName("nutritionist_end_time")
    var nutritionist_end_time: String? = null

    @SerializedName("ethnicity")
    var ethnicity: String? = null

    @SerializedName("parent_event_id")
    var parent_event_id: String? = null

    @SerializedName("other_condition")
    var other_condition:String?=null

    @SerializedName("discount_type")
    var discount_type:String?=null

    @SerializedName("discount_code")
    var discount_code:String?=null

    @SerializedName("discounts_master_id")
    var discounts_master_id:String?=null

    @SerializedName("price")
    var price:String?=null

    @SerializedName("discount_amount")
    var discount_amount:String?=null

    @SerializedName("latitude")
    var latitude: String? = null

    @SerializedName("longitude")
    var longitude: String? = null
}