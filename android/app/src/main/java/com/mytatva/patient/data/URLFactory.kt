package com.mytatva.patient.data

import okhttp3.HttpUrl

object URLFactory {

    enum class Env {
        DEVELOPMENT, UAT, PRODUCTION
    }

    /** ********************************
     * server details
     * DEV:- api.mytatvadev.in
     * UAT:- api-uat.mytatva.in
     * PROD:- api.mytatva.in
     * ********************************/
    val ENVIRONMENT = Env.UAT

    //const val IS_PRODUCTION = true

    private val SCHEME = when (ENVIRONMENT) {
        Env.PRODUCTION -> "https"
        Env.UAT -> "https"
        Env.DEVELOPMENT -> "https"
    }

    private val HOST = when (ENVIRONMENT) {
        Env.PRODUCTION -> "api.mytatva.in"
        Env.UAT -> "api-uat.mytatva.in"
        Env.DEVELOPMENT -> "api.mytatvadev.in"
    }

    private val API_PATH = when (ENVIRONMENT) {
        Env.PRODUCTION -> "api/v7/"
        Env.UAT -> "api/v7/"
        Env.DEVELOPMENT -> "api/v7/"
    }

    //private val PORT = if (IS_PRODUCTION) 8080 else 8080

    /*const val IS_PRODUCTION = true
    private val SCHEME = if (IS_PRODUCTION) "https" else "http"
    private val HOST =
        if (IS_PRODUCTION) "api-prod.mytatva.in" else "api.mytatvadev.in"
    private val API_PATH = if (IS_PRODUCTION) "api/v3/" else "api/v3/"
    private val PORT = if (IS_PRODUCTION) 8080 else 8080*/

    /**
     * provideHttpUrl
     * @return HttpUrl
     */
    fun provideHttpUrl(): HttpUrl {
        return HttpUrl.Builder()
            .scheme(SCHEME)
            .host(HOST)
            //.apply { if (IS_PRODUCTION) port(PORT) }
            .addPathSegments(API_PATH)
            .build()
    }

    object AppUrls {
        /*"http://mytatva.in/terms.html"*/
        /*"https://www.mytatva.in/assets/terms-and-conditions.html"*/
        const val TERMS_CONDITIONS = "https://www.mytatva.in/terms-and-conditions/"
        const val ABOUT_US = "https://www.mytatva.in/"

        /*"https://mytatva.in/assets/privacy-policy.html"*/
        const val PRIVACY_POLICY = "https://www.mytatva.in/privacy-policy/"
        const val WEBINAR_BOOK_SEAT = "www.google.com"

        /*
        https://www.thyrocare.com/Cancellation
        https://www.thyrocare.com/Terms/Service
        https://www.thyrocare.com/Terms/Use
         */
        const val THYROCARE_CANCELLATION = "https://www.thyrocare.com/Cancellation"
        const val THYROCARE_TERMS_USE = "https://www.thyrocare.com/Terms/Use"
        const val THYROCARE_TERMS_SERVICE = "https://admin.mytatva.in/terms_of_use.html"
    }

    /**
     * API methods declaration
     */
    object Patient {
        private const val PATIENT = "patient/"

        const val VERIFY_DOCTOR_ACCESS_CODE = "${PATIENT}verify_doctor_access_code"
        const val REGISTER = "${PATIENT}register"
        const val GET_LANGUAGE_LIST = "${PATIENT}get_language_list"
        const val CONTENT_LANGUAGE_LIST = "${PATIENT}content_language_list"

        // REMOVED this API(patient/signin), as Login with password feature removed
        const val LOGIN = "${PATIENT}signin"
        const val LINK_DOCTOR = "${PATIENT}link_doctor"
        const val UPDATE_MEDICAL_CONDITION = "${PATIENT}update_medical_condition"
        const val DOCTOR_DETAILS_BY_ID = "${PATIENT}doctor_details_by_id"
        const val UPDATE_DOCTOR_APPOINTMENT = "${PATIENT}update_doctor_appointment"
        const val UPDATE_GOALS = "${PATIENT}update_goals"
        const val GET_APPOINTMENT_DETAILS = "${PATIENT}get_appointment_details"

        const val CHECK_CONTACT_DETAILS = "${PATIENT}check_contact_details"
        const val FORGOT_PASSWORD = "${PATIENT}forgot_password"
        const val UPDATE_PATIENT_LOCATION = "${PATIENT}update_patient_location"

        const val UPDATE_PATIENT_HEIGHT_WEIGHT = "${PATIENT}update_height_weight"

        /*const val UPDATE_PATIENT_WEIGHT = "${PATIENT}update_patient_weight"*/
        const val READING_LIST = "${PATIENT}reading_list"

        const val CHECK_EMAIL_VERIFIED = "${PATIENT}check_email_verified"
        const val UPDATE_PROFILE = "${PATIENT}update_profile"
        const val MY_CURRENT_MEDICAL_CONDITION = "${PATIENT}my_current_medical_condition"

        const val DOSE_LIST = "${PATIENT}dose_list"
        const val GOAL_LIST = "${PATIENT}goal_list"
        const val MEDIAL_CONDITION_GOAL_PATIENT_REL_LIST =
            "${PATIENT}medial_condition_goal_patient_rel_list"
        const val MEDICAL_CONDITION_READING_PATIENT_REL_LIST =
            "${PATIENT}medical_condition_reading_patient_rel_list"


        const val ADD_PRESCRIPTION = "${PATIENT}add_prescription"
        const val MEDICAL_CONDITION_LIST = "${PATIENT}medical_condition_list"
        const val MEDICAL_CONDITION_GROUP_LIST = "${PATIENT}medical_condition_group_list"
        const val UPDATE_DEVICE_INFO = "${PATIENT}update_device_info"
        const val LANGUAGE_VALIDATION = "${PATIENT}language_validation"
        const val VERIFY_CONTACT_NO = "${PATIENT}verify_contact_no"
        const val CONTACT_NO_VALIDATION = "${PATIENT}contact_no_validation"
        const val GET_PATIENT_DETAILS = "${PATIENT}get_patient_details"
        const val LOGIN_SEND_OTP = "${PATIENT}login_send_otp"
        const val LOGIN_VERIFY_OTP = "${PATIENT}login_verify_otp"
        const val FORGOT_PASSWORD_SEND_OTP = "${PATIENT}forgot_password_send_otp"
        const val FORGOT_PASSWORD_VERIFY_OTP = "${PATIENT}forgot_password_verify_otp"
        const val GET_DAYS_LIST = "${PATIENT}get_days_list"
        const val PATIENT_LINKED_DR_DETAILS = "${PATIENT}patient_linked_dr_details"
        const val GET_DEVICE_INFO = "${PATIENT}get_device_info"
        const val GET_MEDICINE_LIST = "${PATIENT}get_medicine_list"

        const val VERIFY_OTP_SIGNUP = "${PATIENT}verify_otp_signup"
        const val SEND_OTP_SIGNUP = "${PATIENT}send_otp_signup"

        const val STATE_LIST = "${PATIENT}state_list"
        const val CITY_LIST = "${PATIENT}city_list"
        const val CITY_LIST_BY_STATE_NAME = "${PATIENT}city_list_by_state_name"

        const val ADD_READING_GOAL = "${PATIENT}add_reading_goal"

        const val SEND_EMAIL_VERIFICATION_LINK = "${PATIENT}send_email_verification_link"

        const val REQUEST_PRESCRIPTION_CARD_CALLBACK =
            "${PATIENT}request_prescription_card_callback"

        const val PRESCRIPTION_MEDICINE_LIST = "${PATIENT}prescription_medicine_list"


        const val UPDATED_RECORDS = "${PATIENT}updated_records"
        const val GET_RECORDS = "${PATIENT}get_records"
        const val TEST_TYPES = "${PATIENT}test_types"
        const val GET_FAQ_DATA = "${PATIENT}get_faq_data"
        const val GET_FAQS = "${PATIENT}get_faqs"

        const val QUERY_REASON_LIST = "${PATIENT}query_reason_list"
        const val SEND_QUERY = "${PATIENT}send_query"

        const val UPDATE_PRESCRIPTION = "${PATIENT}update_prescription"
        const val GET_PRESCRIPTION_DETAILS = "${PATIENT}get_prescription_details"

        const val LINKED_HEALTH_COACH_LIST = "${PATIENT}linked_health_coach_list"
        const val HEALTH_COACH_DETAILS_BY_ID = "${PATIENT}health_coach_details_by_id"
        const val UPDATE_HEALTHCOACH_CHAT_INITIATE = "${PATIENT}update_healthcoach_chat_initiate"
        const val LINK_HEALTHCOACH_CHAT = "${PATIENT}link_healthcoach_chat"
        const val GET_ZYDUS_INFO = "${PATIENT}get_zydus_info"
        const val LOGOUT = "${PATIENT}logout"
        const val DELETE_ACCOUNT = "${PATIENT}delete_account"
        const val GET_NO_LOGIN_SETTING_FLAGS = "${PATIENT}get_no_login_setting_flags"

        // signup revamp May Sprint1 2023, new APIs
        const val UPDATE_SIGNUP_FOR = "${PATIENT}update_signup_for"
        const val UPDATE_ACCESS_CODE = "${PATIENT}update_access_code"
        const val ONBORDING_SIGNUP_DATA = "${PATIENT}onbording_signup_data"

        const val REGISTER_TEMP_PATIENT_PROFILE = "${PATIENT}register_temp_patient_profile"
        const val ADD_MEDICINE_PRESCRIPTION = "${PATIENT}add_medicine_prescription"
        const val FETCH_MEDICINE_PRESCRIPTION = "${PATIENT}fetch_medicine_prescription"
    }

    object PatientPlans {
        private const val PATIENT_PLANS = "patient_plans/"

        //extra APIs
        const val PLANS_LIST = "${PATIENT_PLANS}plans_list"
        const val PLANS_DETAILS_BY_ID = "${PATIENT_PLANS}plans_details_by_id"
        const val ADD_PATIENT_PLAN = "${PATIENT_PLANS}add_patient_plan"
        const val CANCEL_PATIENT_PLAN = "${PATIENT_PLANS}cancel_patient_plan"
        const val PAYMENT_HISTORY = "${PATIENT_PLANS}payment_history"
        const val RAZORPAY_SUBSCRIPTION = "${PATIENT_PLANS}razorpay_subscription"

        const val RAZORPAY_ORDER_ID = "${PATIENT_PLANS}razorpay_order_id"

        const val ALL_PAYMENT_HISTORY = "${PATIENT_PLANS}all_payment_history"

        const val CARE_PLAN_SERVICES = "${PATIENT_PLANS}care_plan_services"
        const val MY_DEVICES = "${PATIENT_PLANS}my_devices"
        const val HOME_CARE_PLAN = "${PATIENT_PLANS}home_page_plans"
        const val HC_DEVICE_PLAN = "${PATIENT_PLANS}hc_device_plan"

        const val CHECK_IS_PLAN_PURCHASED = "${PATIENT_PLANS}check_is_plan_purchased"
        const val DISCOUNT_LIST = "${PATIENT_PLANS}discount_list"
        const val CHECK_DISCOUNT = "${PATIENT_PLANS}check_discount"
    }

    object Doctor {
        private const val DOCTOR = "doctor/"

        const val TODAYS_APPOINTMENT = "${DOCTOR}todays_appointment"
        const val CLINIC_DOCTOR_LIST = "${DOCTOR}clinic_doctor_list"
        const val GET_APPOINTMENT_LIST = "${DOCTOR}get_appointment_list"
        const val ADD_APPOINTMENT = "${DOCTOR}add_appointment"
        const val APPOINTMENT_TIME_SLOT = "${DOCTOR}appointment_time_slot"
        const val CANCEL_APPOINTMENT = "${DOCTOR}cancel_appointment"

        const val GET_VOICETOKEN = "${DOCTOR}get_voicetoken"
        const val FETCH_VIDEOCALL_DATA = "${DOCTOR}fetch_videocall_data"
        const val CHECK_BCP_HC_DETAILS = "${DOCTOR}check_bcp_hc_details"
        const val GET_BCP_TIME_SLOTS = "${DOCTOR}get_bcp_time_slots"
        const val UPDATE_BCP_HC_DETAILS = "${DOCTOR}update_bcp_hc_details"
    }

    object PatientHC {
        private const val PATIENT_HC = "patient_hc/"

        const val GET_AVAILABLE_SLOTS = "${PATIENT_HC}get_available_slots"
        const val UPDATE_APPOINTMENT = "${PATIENT_HC}update_appointment"
    }

    object Language {
        private const val LANGUAGES = "languages/"

        const val READ_LANGUAGE_FILE = "${LANGUAGES}read_language_file"
    }

    object Notification {
        private const val NOTIFICATION = "notification/"

        //extra APIs
        const val UPDATE_NOTIFICATION = "${NOTIFICATION}update_notification"
        const val GET_NOTIFICATION = "${NOTIFICATION}get_notification"

        const val NOTIFICATION_MASTER_LIST = "${NOTIFICATION}notification_master_list"
        const val UPDATE_NOTIFICATION_REMINDER = "${NOTIFICATION}update_notification_reminder"

        const val NOTIFICATION_DETAILS_COMMON =
            "${NOTIFICATION}notification_details" //NOTIFICATION_DETAILS_COMMON - same API endpoint for all
        const val NOTIFICATION_DETAILS_FOOD =
            "${NOTIFICATION}notification_details" //NOTIFICATION_DETAILS_FOOD - same API endpoint for all
        const val NOTIFICATION_DETAILS_WATER =
            "${NOTIFICATION}notification_details" //NOTIFICATION_DETAILS_WATER - same API endpoint for all
        const val NOTIFICATION_DETAILS_READINGS =
            "${NOTIFICATION}notification_details" //NOTIFICATION_DETAILS_READINGS - same API endpoint for all


        const val UPDATE_NOTIFICATION_DETAILS = "${NOTIFICATION}update_notification_details"
        const val UPDATE_READINGS_NOTIFICATIONS = "${NOTIFICATION}update_readings_notifications"
        const val UPDATE_MEAL_REMINDER = "${NOTIFICATION}update_meal_reminder"
        const val UPDATE_WATER_REMINDER = "${NOTIFICATION}update_water_reminder"

        //
        const val COACH_MARKS = "${NOTIFICATION}coach_marks"
    }

    object GoalReading {
        private const val GOAL_READING = "goal_readings/"

        //extra APIs
        const val GOAL_DAILY_SUMMARY = "${GOAL_READING}goal_daily_summary"
        const val READINGS_DAILY_SUMMARY = "${GOAL_READING}readings_daily_summary"
        //===========//https://devops.mytatvadev.in/gitlab/root/mytatva-android.git

        const val UPDATE_GOAL_LOGS = "${GOAL_READING}update_goal_logs"
        const val UPDATE_PATIENT_READINGS = "${GOAL_READING}update_patient_readings"
        const val GET_EXERCISE_LIST = "${GOAL_READING}get_exercise_list"
        const val DAILY_SUMMARY = "${GOAL_READING}daily_summary"
        const val GET_READING_RECORDS = "${GOAL_READING}get_reading_records"

        const val GET_GOAL_RECORDS = "${GOAL_READING}get_goal_records"
        const val UPDATE_PATIENT_DOSES = "${GOAL_READING}update_patient_doses"
        const val PATIENT_TODAYS_MEDICATION_LIST = "${GOAL_READING}patient_todays_medication_list"
        const val LAST_SEVEN_DAYS_MEDICATION = "${GOAL_READING}last_seven_days_medication"

        const val UPDATE_READINGS_GOALS = "${GOAL_READING}update_readings_goals"

        const val ADD_CAT_SURVEY = "${GOAL_READING}add_cat_survey"
        const val GET_CAT_SURVEY = "${GOAL_READING}get_cat_survey"
        const val MY_HEALTH_INSIGHTS = "${GOAL_READING}my_health_insights"

        // food
        const val SEARCH_FOOD = "${GOAL_READING}search_food"
        const val FREQUENTLY_ADDED_FOOD = "${GOAL_READING}frequently_added_food"
        const val ADD_MEAL = "${GOAL_READING}add_meal"
        const val EDIT_MEAL = "${GOAL_READING}edit_meal"
        const val MEAL_TYPES = "${GOAL_READING}meal_types"
        const val FOOD_INSIGHT = "${GOAL_READING}food_insight"
        const val FOOD_LOGS = "${GOAL_READING}food_logs"

        const val GET_MONTHLY_DIET_CAL = "${GOAL_READING}get_monthly_diet_cal"
        const val PATIENT_MEAL_REL_BY_ID = "${GOAL_READING}patient_meal_rel_by_id"

        //bmr
        const val CALCULATE_BMR_MONTHS = "${GOAL_READING}calculate_bmr_months"
        const val CALCULATE_BMR_CALORIES = "${GOAL_READING}calculate_bmr_calories"
        const val CHECK_BMR_DISCLAIMER = "${GOAL_READING}check_bmr_disclaimer"

        //diet plan list
        const val DIET_PLAN_LIST = "${GOAL_READING}diet_plan_list"

        //BCA device integration and related APIs
        const val VITALS_TREND_ANALYSIS = "${GOAL_READING}vitals_trend_analysis"
        const val UPDATE_BCA_READINGS = "${GOAL_READING}update_bca_readings"
        const val GET_BCA_VITALS = "${GOAL_READING}get_bca_vitals"
        const val GENERATE_BCA_REPORT = "${GOAL_READING}generate_bca_report"

        //Spirometer device integration and related APIs
        const val SPIROMETER_TEST_LIST = "${GOAL_READING}spirometer_test_list"
        const val UPDATE_SPIROMETER_DATA = "${GOAL_READING}update_spirometer_data"
        const val UPDATE_INCENTIVE_SPIROMETER_DATA =
            "${GOAL_READING}update_incentive_spirometer_data"
    }

    object Content {
        private const val CONTENT = "content/"

        //extra APIs
        const val TOPIC_LIST = "${CONTENT}topic_list"
        const val CONTENT_LIST = "${CONTENT}content_list"
        const val CONTENT_BY_ID = "${CONTENT}content_by_id"
        const val CONTENT_FILTERS = "${CONTENT}content_filters"
        const val UPDATE_COMMENT = "${CONTENT}update_comment"
        const val UPDATE_VIEW_COUNT = "${CONTENT}update_view_count"//
        const val UPDATE_SHARE_COUNT = "${CONTENT}update_share_count"//
        const val UPDATE_BOOKMARKS = "${CONTENT}update_bookmarks"
        const val UPDATE_LIKES = "${CONTENT}update_likes"
        const val REPORT_COMMENT = "${CONTENT}report_comment"
        const val REMOVE_COMMENT = "${CONTENT}remove_comment"
        const val BOOKMARK_CONTENT_LIST = "${CONTENT}bookmark_content_list"
        const val BOOKMARK_CONTENT_LIST_BY_TYPE = "${CONTENT}bookmark_content_list_by_type"
        const val COMMENT_LIST = "${CONTENT}comment_list"
        const val STAY_INFORMED = "${CONTENT}stay_informed"
        const val RECOMMENDED_CONTENT = "${CONTENT}recommended_content"

        //exercise
        const val EXERCISE_LIST = "${CONTENT}exercise_list"
        const val EXERCISE_LIST_BY_GENRE_ID = "${CONTENT}exercise_list_by_genre_id"
        const val UTENSIL_LIST = "${CONTENT}utensil_list"
        const val EXERCISE_FILTERS = "${CONTENT}exercise_filters"
        const val EXERCISE_BOOKMARK_LIST = "${CONTENT}exercise_bookmark_list"
        const val EXERCISE_PLAN_LIST = "${CONTENT}exercise_plan_list"

        //exercise - old endpoints in v1 - for normal plans as old
        const val PLAN_DAYS_LIST = "${CONTENT}plan_days_list"
        const val UPDATE_BREATHING_EXERCISE_LOG = "${CONTENT}update_breathing_exercise_log"
        const val PLAN_DAYS_DETAILS_BY_ID = "${CONTENT}plan_days_details_by_id"

        //exercise - new endpoints of v2 - for customised plans
        const val PLAN_DAYS_LIST_CUSTOMISED = "${CONTENT}exercise_plan_days_list"
        const val UPDATE_BREATHING_EXERCISE_LOG_CUSTOMISED =
            "${CONTENT}update_breathing_exercise_logs"
        const val PLAN_DAYS_DETAILS_BY_ID_CUSTOMISED = "${CONTENT}exercise_plan_days_details_by_id"

        //exercise - new APIs after exercise revamp changes as per Sprint May1 2023
        const val EXERCISE_PLAN_DETAILS = "${CONTENT}exercise_plan_details"
        const val EXERCISE_PLAN_MARK_AS_DONE = "${CONTENT}exercise_plan_mark_as_done"
        const val EXERCISE_PLAN_UPDATE_DIFFICULTY = "${CONTENT}exercise_plan_update_difficulty"

        //exercise_plan_mark_as_done_multi this API is REMOVED Not in use
        const val EXERCISE_PLAN_MARK_AS_DONE_MULTI = "${CONTENT}exercise_plan_mark_as_done_multi"

        //ask an expert
        const val QUESTION_LIST = "${CONTENT}question_list"
        const val POST_QUESTION = "${CONTENT}post_question"
        const val POST_QUESTION_UPDATE = "${CONTENT}post_question_update"
        const val QUESTION_DELETE = "${CONTENT}question_delete"
        const val UPDATE_ANSWER = "${CONTENT}update_answer"
        const val ANSWERS_LIST = "${CONTENT}answers_list"
        const val ANSWER_COMMENT_DELETE = "${CONTENT}answer_comment_delete"
        const val ANSWER_DELETE = "${CONTENT}answer_delete"
        const val ANSWER_DETAIL = "${CONTENT}answer_detail"
        const val UPDATE_ANSWER_REPLY = "${CONTENT}update_answer_reply"
        const val ANSWER_COMMENT_UPDATE_LIKE = "${CONTENT}answer_comment_update_like"
        const val CONTENT_REPORT = "${CONTENT}content_report"
        const val REPORT_ANSWER_COMMENT = "${CONTENT}report_answer_comment"
        const val ASK_AN_EXPERT_FILTERS = "${CONTENT}ask_an_expert_filters"
        const val QUESTION_DETAIL = "${CONTENT}question_detail"
        const val ANSWER_COMMENTS = "${CONTENT}answer_comments"

    }

    object Survey {
        private const val SURVEY = "survey/"

        //extra APIs
        const val GET_INCIDENT_SURVEY = "${SURVEY}get_incident_survey"
        const val ADD_INCIDENT_DETAILS = "${SURVEY}add_incident_details"
        const val FETCH_INCIDENT_LIST =
            "${SURVEY}get_incident_list_by_add_rel_id"  /*fetch_incident_list*/
        const val GET_QUIZ = "${SURVEY}get_quiz"
        const val QUIZ_QUESTION_IDS = "${SURVEY}quiz_question_ids"
        const val ADD_QUIZ_ANSWERS = "${SURVEY}add_quiz_answers"
        const val ADD_POLL_ANSWERS = "${SURVEY}add_poll_answers"
        const val GET_INCIDENT_FREE_DAYS = "${SURVEY}get_incident_free_days"
        const val GET_INCIDENT_DURATION_OCCURANCE_LIST =
            "${SURVEY}get_incident_duration_occurance_list"
        const val GET_POLL_QUIZ = "${SURVEY}get_poll_quiz"

    }

    object Tests {
        private const val TESTS = "tests/"

        //extra APIs
        const val TESTS_LIST = "${TESTS}tests_list"
        const val TESTS_LIST_HOME = "${TESTS}tests_list_home"
        const val TEST_DETAIL = "${TESTS}test_detail"

        const val ADD_TO_CART = "${TESTS}add_to_cart"
        const val REMOVE_FROM_CART = "${TESTS}remove_from_cart"
        const val LIST_CART = "${TESTS}list_cart"


        const val PATIENT_MEMBERS_LIST = "${TESTS}patient_members_list"
        const val UPDATE_PATIENT_MEMBERS = "${TESTS}update_patient_members"
        const val ADDRESS_LIST = "${TESTS}address_list"
        const val UPDATE_ADDRESS = "${TESTS}update_address"
        const val DELETE_ADDRESS = "${TESTS}delete_address"
        const val GET_APPOINTMENT_SLOTS = "${TESTS}get_appointment_slots"
        const val PINCODE_AVAILABILITY = "${TESTS}pincode_availability"


        const val BOOK_TEST = "${TESTS}book_test"
        const val ORDER_SUMMARY = "${TESTS}order_summary"
        const val CONTACT_SUPPORT = "${TESTS}contact_spport"
        const val ORDER_HISTORY = "${TESTS}order_history"

        const val GET_DOWNLOAD_REPORT_URL = "${TESTS}get_download_report_url"
        const val CANCEL_LAB_TEST = "${TESTS}cancel_lab_test"

        const val CHECK_BOOK_TEST = "${TESTS}check_book_test"

        const val GET_CART_INFO = "${TESTS}get_cart_info"
        const val CATALOG_LIST = "${TESTS}catalog_list"
        const val SEARCH_CATALOG_LIST = "${TESTS}search_catalog_list"
        const val CATALOG_LIST_ALL = "${TESTS}catalog_list_all"
        const val CATALOG_DETAILS = "${TESTS}catalog_details"
        const val CONFIRMATION_ORDER = "${TESTS}confirm_order"
        const val RESCHEDULED_LAB_TEST = "${TESTS}rescheduled_lab_test"
        const val GET_NEARBY_EXPIRE_BCP_DATA = "${TESTS}get_nearby_expiry_bcp_data"
    }

    object RazorPay {
        const val SUBSCRIPTIONS = "subscriptions"
    }

}