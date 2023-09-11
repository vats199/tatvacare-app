//
//  ApiEndPoints.swift
//  MVVMBasicStructure
//
//  Created by KISHAN_RAJA on 18/12/20.
//

import UIKit

/// ApiEndPoints - This will be main api points
enum ApiEndPoints {
    case patient(Patient)
    case patient_plans(Patient_plans)
    case user(User)
    case combine(Combine)
    case goalReading(GoalReading)
    case content(Content)
    case survey(Survey)
    case notificationAPI(NotificationAPI)
    case doctor(Doctor)
    case tests(Tests)
    case patient_hc(Patient_hc)
    
    /// API methods name.
    var methodName : String {
        switch self {
        case .patient(let patient):
            return "patient/" +  patient.rawValue
            
        case .patient_plans(let patient_plans):
            return "patient_plans/" +  patient_plans.rawValue
            
        case .user(let user):
            return "user/" +  user.rawValue
            
        case .combine(let combine):
            return "combine/" + combine.rawValue
            
        case .goalReading(let goalReading):
            return "goal_readings/" + goalReading.rawValue
            
        case .content(let content):
            return "content/" + content.rawValue
            
        case .survey(let survey):
            return "survey/" + survey.rawValue
            
        case .notificationAPI(let notificationAPI):
            return "notification/" + notificationAPI.rawValue
            
        case .doctor(let doctor):
            return "doctor/" + doctor.rawValue
        
        case .patient_hc(let patient_hc):
            return "patient_hc/" + patient_hc.rawValue
            
        case .tests(let tests):
            return "tests/" + tests.rawValue
        }
    }
}

enum Patient: String {
    case getLanguageList                = "get_language_list" //
    case contentLanguageList            = "content_language_list" //
    case updateDeviceInfo               = "update_device_info" //
    case medicalConditionList           = "medical_condition_list" //
    case register                       = "register" //
    case login                          = "signin" //
    case logout                         = "logout"
    case delete_account                 = "delete_account"
    
    case login_send_otp                 = "login_send_otp"//
    case login_verify_otp               = "login_verify_otp"//
    case send_otp_signup                = "send_otp_signup"//
    
    case verify_otp_signup              = "verify_otp_signup"//
    case forgot_password_send_otp       = "forgot_password_send_otp"//
    case forgot_password_verify_otp     = "forgot_password_verify_otp"//
    
    case state_list                     = "state_list"//
    case city_list                      = "city_list"//
    case city_list_by_state_name        = "city_list_by_state_name"//
    case get_patient_details            = "get_patient_details" //
    
    case add_prescription               = "add_prescription"//
    case send_email_verification_link   = "send_email_verification_link"//
    
    case dose_list                      = "dose_list"//
    case get_days_list                  = "get_days_list"
    
    case goal_list                      = "goal_list"//
    case reading_list                   = "reading_list"//
    
    case medial_condition_goal_patient_rel_list = "medial_condition_goal_patient_rel_list"//
    case medical_condition_reading_patient_rel_list = "medical_condition_reading_patient_rel_list"
    case add_reading_goal               = "add_reading_goal"//
    
    case link_doctor                    = "link_doctor"
    case update_medical_condition       = "update_medical_condition"//
    case doctor_details_by_id           = "doctor_details_by_id"//
    case update_doctor_appointment      = "update_doctor_appointment"
    case update_goals                   = "update_goals"//
    case get_appointment_details        = "get_appointment_details"
    case get_faq_data                   = "get_faq_data"
    case get_faqs                       = "get_faqs"
    case check_contact_details          = "check_contact_details"
    case forgot_password                = "forgot_password"//
    case update_patient_location        = "update_patient_location"//
    case update_patient_height          = "update_patient_height"
    case update_patient_weight          = "update_patient_weight"
    
    case update_patient_readings        = "update_patient_readings"//
    case check_email_verified           = "check_email_verified"//
    case update_profile                 = "update_profile"//
    case my_current_medical_condition   = "my_current_medical_condition"//
    case medical_condition_group_list   = "medical_condition_group_list"
    
    case prescription_medicine_list     = "prescription_medicine_list"//
    case request_prescription_card_callback = "request_prescription_card_callback"//
    
    case updated_records                = "updated_records"//
    case update_height_weight           = "update_height_weight"//
    case get_records                    = "get_records"//
    case test_types                     = "test_types"//
    
    case send_query                     = "send_query"//
    case query_reason_list              = "query_reason_list"//
    case get_prescription_details       = "get_prescription_details"
    case update_prescription            = "update_prescription"
    case verify_doctor_access_code      = "verify_doctor_access_code"
    case linked_health_coach_list       = "linked_health_coach_list"
    case health_coach_details_by_id     = "health_coach_details_by_id"//{"health_coach_id":"8dec2a25-5d0d-11ec-845f-7c11e23978ae"}
    case get_medicine_list              = "get_medicine_list"
    case link_healthcoach_chat          = "link_healthcoach_chat"
    case get_zydus_info                 = "get_zydus_info"
    case update_healthcoach_chat_initiate = "update_healthcoach_chat_initiate"
    case get_no_login_setting_flags     = "get_no_login_setting_flags"
    case update_signup_for              = "update_signup_for"
    case update_access_code             = "update_access_code"
    
    case onbording_signup_data          = "onbording_signup_data"
    case register_temp_patient_profile  = "register_temp_patient_profile"
}

enum Patient_plans: String {
    case plans_list                     = "plans_list"
    case plans_details_by_id            = "plans_details_by_id"
    case add_patient_plan               = "add_patient_plan"
    case cancel_patient_plan            = "cancel_patient_plan"
    case payment_history                = "payment_history"
    case all_payment_history            = "all_payment_history"
    case razorpay_order_id              = "razorpay_order_id"
    case care_plan_services             = "care_plan_services"
    case my_devices                     = "my_devices"
}

enum GoalReading: String {
    case diet_plan_list                 = "diet_plan_list"//
    case get_exercise_list              = "get_exercise_list"//
    case daily_summary                  = "daily_summary"//
    case update_goal_logs               = "update_goal_logs" //
    case update_patient_readings        = "update_patient_readings" //
    case get_reading_records            = "get_reading_records" //
    case patient_todays_medication_list = "patient_todays_medication_list"//
    case get_goal_records               = "get_goal_records" //
    case update_patient_doses           = "update_patient_doses" //
    case last_seven_days_medication     = "last_seven_days_medication"//
    case update_readings_goals          = "update_readings_goals"//

    case get_cat_survey                 = "get_cat_survey"//
    case add_cat_survey                 = "add_cat_survey"//
    case search_food                    = "search_food"//
    case frequently_added_food          = "frequently_added_food"//
    case meal_types                     = "meal_types"//
    case add_meal                       = "add_meal"//
    case food_logs                      = "food_logs"//
    case food_insight                   = "food_insight"//
    case get_monthly_diet_cal           = "get_monthly_diet_cal"//
    case patient_meal_rel_by_id         = "patient_meal_rel_by_id"//
    case edit_meal                      = "edit_meal"//
    case calculate_bmr_months           = "calculate_bmr_months"
    case calculate_bmr_calories         = "calculate_bmr_calories"
    case check_bmr_disclaimer           = "check_bmr_disclaimer"
    
    //BCA Reading
    case get_bca_vitals                 = "get_bca_vitals"
    case update_bca_readings            = "update_bca_readings"
    case vitals_trend_analysis          = "vitals_trend_analysis"
    case generate_bca_report            = "generate_bca_report"
}

enum Content: String {
    case topic_list                     = "topic_list"
    case content_list                   = "content_list"
    case content_by_id                  = "content_by_id"
    case content_filters                = "content_filters"
    case update_view_count              = "update_view_count"
    case update_share_count             = "update_share_count"
    case update_bookmarks               = "update_bookmarks"
    case update_likes                   = "update_likes"
    case report_comment                 = "report_comment"
    case remove_comment                 = "remove_comment"
    case update_comment                 = "update_comment"
    case bookmark_content_list          = "bookmark_content_list"
    case bookmark_content_list_by_type  = "bookmark_content_list_by_type"
    case comment_list                   = "comment_list"
    case exercise_filters               = "exercise_filters"
    case exercise_list                  = "exercise_list"
    case utensil_list                   = "utensil_list"

    //Exercises APIs
    case exercise_plan_list             = "exercise_plan_list"
    case plan_days_list                 = "plan_days_list"
    case exercise_plan_days_list        = "exercise_plan_days_list"//new
    case plan_days_details_by_id        = "plan_days_details_by_id"
    case exercise_plan_days_details_by_id_custom = "exercise_plan_days_details_by_id"//new
    case update_breathing_exercise_log  = "update_breathing_exercise_log"
    case update_breathing_exercise_logs_custom = "update_breathing_exercise_logs"//new
    case stay_informed                  = "stay_informed"
    case recommended_content            = "recommended_content"
    case exercise_list_by_genre_id      = "exercise_list_by_genre_id"
    
    //Ask an expert
    case question_list                  = "question_list"
    case question_detail                = "question_detail"
    case post_question                  = "post_question"
    case post_question_update           = "post_question_update"
    case update_answer                  = "update_answer"
    case answers_list                   = "answers_list"
    case question_delete                = "question_delete"
    case answer_comment_delete          = "answer_comment_delete"
    case answer_detail                  = "answer_detail"
    case answer_comments                = "answer_comments"
    case update_answer_reply            = "update_answer_reply"
    case answer_comment_update_like     = "answer_comment_update_like" //answer_comment_update_like
    case content_report                 = "content_report"//ques report
    case report_answer_comment          = "report_answer_comment"
    case ask_an_expert_filters          = "ask_an_expert_filters"
    case answer_delete                  = "answer_delete"
    
    //Exercise Route
    case exercise_plan_details          = "exercise_plan_details"
    case exercise_plan_mark_as_done     = "exercise_plan_mark_as_done"
    case exercise_plan_update_difficulty = "exercise_plan_update_difficulty"
    
}

enum Survey: String {
    case get_incident_free_days         = "get_incident_free_days"
    case get_incident_survey            = "get_incident_survey"
    case add_incident_details           = "add_incident_details"
    case get_incident_duration_occurance_list = "get_incident_duration_occurance_list"
    case fetch_incident_list            = "fetch_incident_list"
    case get_incident_list_by_add_rel_id = "get_incident_list_by_add_rel_id"
    case get_poll_quiz                  = "get_poll_quiz"
    case add_poll_answers               = "add_poll_answers"
    case add_quiz_answers               = "add_quiz_answers"
    //incident_tracking_master_id:"incident_tracking_master_id",
//    patient_incident_add_rel_id:"patient_incident_add_rel_id"
}

enum NotificationAPI: String {
    case update_notification            = "update_notification"
    case get_notification               = "get_notification"
    case notification_master_list       = "notification_master_list"
    case notification_details           = "notification_details"
    case update_meal_reminder           = "update_meal_reminder"
    case update_notification_details    = "update_notification_details" // for goals
    case update_readings_notifications  = "update_readings_notifications" // for reading
    case update_notification_reminder   = "update_notification_reminder"
    case update_water_reminder          = "update_water_reminder"
    case coach_marks                    = "coach_marks"
    
}

/// User Endpoints
enum User: String {
    case sendOtp                        = "send_otp"
    case signup                         = "signup"
    case signin                         = "signin"
    case forgotPassword                 = "forgot_password"
    case changePassword                 = "change_password"
    case profileDetail                  = "profile_detail"
    case editProfile                    = "edit_profile"
    case updateOtherDetail              = "update_other_detail"
    case addCard                        = "add_card"
    case cardList                       = "card_list"
    case deleteCard                     = "delete_card"
}

enum Combine: String {
    case appConfig                      = "app_config"
    case updateDevice                   = "update_device"
    case updateLocation                 = "update_location"
    case editNotificationSetting        = "edit_notification_setting"
    case notificationList               = "notification_list"
    case contactUs                      = "contact_us"
}

enum Doctor: String {
    case todays_appointment             = "todays_appointment"
    case clinic_doctor_list             = "clinic_doctor_list"
    case get_appointment_list           = "get_appointment_list"
    case add_appointment                = "add_appointment"
    case appointment_time_slot          = "appointment_time_slot"
    case cancel_appointment             = "cancel_appointment"
    case get_voicetoken                 = "get_voicetoken"
    case fetch_videocall_data           = "fetch_videocall_data"
    case check_bcp_hc_details           = "check_bcp_hc_details"
    case get_bcp_time_slots             = "get_bcp_time_slots"
    case update_bcp_hc_details          = "update_bcp_hc_details"
}

enum Patient_hc: String {
    case get_available_slots            = "get_available_slots"
    case update_appointment             = "update_appointment"
}

enum Tests: String {
    case tests_list_home                = "tests_list_home"
    case tests_list                     = "tests_list"
    case test_detail                    = "test_detail"
    case add_to_cart                    = "add_to_cart"
    case remove_from_cart               = "remove_from_cart"
    case list_cart                      = "list_cart"
    case patient_members_list           = "patient_members_list"
    case update_patient_members         = "update_patient_members"
    case address_list                   = "address_list"
    case update_address                 = "update_address"
    case delete_address                 = "delete_address"
    case get_appointment_slots          = "get_appointment_slots"
    case pincode_availability           = "pincode_availability"
    case book_test                      = "book_test"
    case order_summary                  = "order_summary"
    case contact_spport                 = "contact_spport"
    case order_history                  = "order_history"
    case get_download_report_url        = "get_download_report_url"
    case check_book_test                = "check_book_test"
    case get_cart_info                  = "get_cart_info"
}

