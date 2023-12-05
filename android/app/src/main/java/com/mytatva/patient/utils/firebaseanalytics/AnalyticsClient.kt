package com.mytatva.patient.utils.firebaseanalytics

import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.core.os.bundleOf
import com.apxor.androidsdk.core.ApxorSDK
import com.apxor.androidsdk.core.Attributes
import com.freshchat.consumer.sdk.Freshchat
import com.freshchat.consumer.sdk.FreshchatConfig
import com.google.firebase.analytics.FirebaseAnalytics
import com.google.firebase.analytics.ktx.analytics
import com.google.firebase.ktx.Firebase
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.utils.DeviceUtils
import com.mytatva.patient.utils.appendFieldAsString
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.webengage.sdk.android.Analytics
import com.webengage.sdk.android.User
import com.webengage.sdk.android.WebEngage
import com.webengage.sdk.android.WebEngage.getApplicationContext
import com.webengage.sdk.android.utils.Gender
import java.util.Calendar
import java.util.Locale
import java.util.concurrent.TimeUnit
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class AnalyticsClient @Inject constructor(
    private val session: Session,
    private val context: Context
) {

    //Common Params
    val PARAM_DEVICE_TYPE = "device_type"
    val PARAM_PATIENT_ID = "patient_id"
    val PARAM_LOG_DATE = "log_date"
    val PARAM_PATIENT_GENDER = "patientGender"
    val PARAM_PATIENT_INDICATION = "patientIndication"
    val PARAM_CURRENT_APP_VERSION = "currentAppVersion"
    val PARAM_ANDROID_VERSION = "OS_Version"
    val PARAM_SCREEN_RESOLUTION = "screenResolution"
    val PARAM_DOCTOR_ID = "doctorId"
    val PARAM_DOCTOR_SPECIALIZATION = "doctorSpecialization"
    val PARAM_HEALTH_COACH_IDS = "healthCoachId"
    val PARAM_HEALTH_COACH_SPECIALIZATION = "HealthCoachSpecialization"
    val PARAM_CITY = "city"
    val PARAM_EMAIL_VERIFIED = "emailVerified"
    val PARAM_CURRENT_PLAN_NAME = "current_plan_name"
    val PARAM_CURRENT_PLAN_TYPE = "current_plan_type"
    val PARAM_CURRENT_PLAN_ID = "current_plan_id"
    val PARAM_SCREEN_NAME = "ScreenName"

    //Params
    val PARAM_CONTENT_MASTER_ID = "content_master_id"
    val PARAM_ROUTINE_NO = "routine_no"
    val PARAM_PATIENT_EXERCISE_PLANS_ID = "patient_exercise_plans_id"
    val PARAM_EXERCISE_PLAN_NAME = "exercise_plan_name"
    val PARAM_EXERCISE_NAME = "exercise_name"
    val PARAM_START_DATE = "start_date"
    val PARAM_END_DATE = "end_date"
    val PARAM_FLAG = "flag"
    val PARAM_VALUE = "value"
    val PARAM_CONTENT_HEADING = "content_heading"
    val PARAM_CONTENT_TYPE = "content_type"
    val PARAM_CONTENT_CARD_NUMBER = "content_card_number"
    val PARAM_EXERCISE_PLAN_DAY_ID = "exercise_plan_day_id"
    val PARAM_TYPE = "type"
    val PARAM_SURVEY_ID = "survey_id"
    val PARAM_OCCUR_INCIDENT_TRACKING_MASTER_ID = "occurIncidentTrackingMasterId"
    val PARAM_READING_ID = "reading_id"
    val PARAM_READING_NAME = "reading_name"
    val PARAM_CONTENT_COMMENTS_ID = "content_comments_id"
    val PARAM_GOAL_NAME = "goal_name"
    val PARAM_GOAL_ID = "goal_id"
    val PARAM_PATIENT_RECORDS_ID = "patient_records_id"
    val PARAM_FOOD_NAME = "food_name"
    val PARAM_FOOD_ITEM_ID = "food_item_id"
    val PARAM_MEAL_TYPES_ID = "meal_types_id"
    val PARAM_DURATION_SECOND = "duration_second"
    val PARAM_GOAL_VALUE = "goal_value"
    val PARAM_NOTIFICATION_MASTER_ID = "notification_master_id"
    val PARAM_HEALTH_COACH_ID = "health_coach_id"
    val PARAM_PHONE_NO = "phone_no"
    val PARAM_IS_SELECT = "is_select"
    val PARAM_LAB_TEST_ID = "lab_test_id"
    val PARAM_MEMBER_ID = "member_id"
    val PARAM_ADDRESS_ID = "address_id"
    val PARAM_APPOINTMENT_DATE = "appointment_date"
    val PARAM_SLOT_TIME = "slot_time"
    val PARAM_TRANSACTION_ID = "transaction_id"
    val PARAM_ORDER_MASTER_ID = "order_master_id"
    val PARAM_APPOINTMENT_ID = "appointment_id"
    val PARAM_DOCTOR_ACCESS_CODE = "doctor_access_code"
    //

    //HealthCoach Specialization
    val PARAM_LINKED_DEVICES = "linked_devices"
    val PARAM_LANGUAGE_SELECTED = "language_selected"
    val PARAM_DATE_OF_INSIGHT = "date_of_insight"
    val PARAM_MENU = "menu"
    val PARAM_CARDS = "cards"
    val PARAM_DIET_START_DATE = "diet_start_date"
    val PARAM_DIET_END_DATE = "diet_end_date"
    val PARAM_HEALTH_MARKER_NAME = "health_marker_name"
    val PARAM_HEALTH_MARKER_COLOUR = "health_marker_colour"
    val PARAM_HEALTH_MARKER_VALUE = "health_marker_value"
    val PARAM_PLAN_ID = "plan_id"
    val PARAM_PLAN_TYPE = "plan_type"
    val PARAM_PLAN_EXPIRY_DATE = "plan_expiry_date"
    val PARAM_PLAN_DURATION = "plan_duration"
    val PARAM_PLAN_VALUE = "plan_value"
    val PARAM_FEATURE_STATUS = "feature_status" //active/inactive
    val PARAM_ACTION = "action" //active/inactive
    val PARAM_MEDICAL_DEVICE = "medical_device"
    val PARAM_DEVICE_AVAILABILITY = "device_availability"
    val PARAM_TOGGLE = "toggle"
    val PARAM_ATTEMPT = "attempt"
    val PARAM_MODULE = "module"
    val PARAM_DATE_RANGE_VALUE = "date_range_value"
    val PARAM_CAROUSEL_NUMBER = "carousel_number"
    val PARAM_AUTO_FLAG = "auto_flag"
    val PARAM_CHANGED_FROM = "changed_from"
    val PARAM_CHANGES_TO = "changes_to"
    val PARAM_BOTTOM_SHEET_NAME = "bottom_sheet_name"
    val PARAM_GRANT_LOCATION_PERMISSION = "grant location permission"
    val PARAM_SEARCH_TYPE = "search_type"
    val PARAM_SEARCH_KEYWORD = "search_keyword"
    val PARAM_SUCCESS = "success"
    val PARAM_ATTEMPTED = "attempted"
    val PARAM_PROFILE = "Profile Tab"
    val PARAM_ACCOUNT_SETTINGS = "Account Settings"
    val PARAM_HEALTH_RECORDS = "Health Records"
    val PARAM_GOALS = "Goals"
    val PARAM_BMI = "BMI"
    val PARAM_BOOKMARKS = "Bookmarks"
    val PARAM_CONSULTATIONS = "Consultations"
    val PARAM_LAB_TESTS = "Lab Tests"
    val PARAM_SHARE_APP = "Share App"
    val PARAM_RATE_APP = "Rate App"
    val PARAM_CONTACT_US = "Contact Us"
    val PARAM_DEVICES = "Devices"
    val PARAM_DIET = "Diet"
    val PARAM_MY_INCIDENTS = "My Incidents"
    val PARAM_EXERCISES = "Exercises"
    val PARAM_MEDICINE = "Medicine"
    val PARAM_CARD_NUMBER = "card_number"
    val PARAM_ADDRESS_NUMBER = "address_number"
    val PARAM_ADDRESS_TYPE = "address_type"
    val PARAM_PATIENT_PLAN_REL_ID = "patient_plan_rel_id"

    val PARAM_ETHNICITY = "ethnicity"
    val PARAM_TEST_TYPE = "test_type"
    val PARAM_SYNC_STATUS = "sync_status"

    val PARAM_SERVICE_TYPE = "service_type"
    val PARAM_AMOUNT_BEFORE_DISCOUNT = "amount_before_discount"
    val PARAM_AMOUNT_AFTER_DISCOUNT = "amount_after_discount"
    val PARAM_DISCOUNT_CODE = "discount_code"
    val PARAM_DESIGN_ELEMENT_TYPE = "design_element_type"

    val PARAM_PERMISSION_TYPE = "permission_type"

    val PARAM_DAYS_TO_EXPIRE = "days_to_expire"

    val PARAM_DOMAIN = "domain"
    val PARAM_DOMAIN_MAP_SIZE = "domain_map_size"
    val PARAM_DOMAIN_MAP_DATA = "domain_map_data"
    val PARAM_DIARY_ITEM = "diary_item"
    val PARAM_DIARY_ITEM_COMPLETION = "diary_item_completion"
    val PARAM_CHATBOT_SCREEN = "chatbot screen"

    /*patientGender
    patientIndication
    currentAppVersion
    iOS_Version
    screenResolution
    doctorId
    doctorSpecialization
    healthCoachId
    HealthCoachSpecialization
    city
    emailVerified
    subscriptionPlan*/


    // Event names
    val NEW_USER_LANGUAGE_SELECTION =
        "NEW_USER_LANGUAGE_SELECTION" // submit click on select language
    val NEW_USER_SIGNUP_ATTEMPT = "NEW_USER_SIGNUP_ATTEMPT"  // on open signup phone screen

    //REMOVED
    //val NEW_USER_MOBILE_CAPTURE = "NEW_USER_MOBILE_CAPTURE" // on signup phone screen, when send otp success

    val NEW_USER_OTP_VERIFY = "NEW_USER_OTP_VERIFY" // on signup verify otp success
    val LOGIN_OTP_SUCCESS = "LOGIN_OTP_SUCCESS" // on login verify otp success

    /**/val NEW_USER_ACCESS_CODE_VERIFY = "NEW_USER_ACCESS_CODE_VERIFY" //Qry
    /**/val NEW_USER_EMAIL_VERIFICATION = "NEW_USER_EMAIL_VERIFICATION" //Qry
    val NEW_USER_QRCODE_VERIFIED = "NEW_USER_QRCODE_VERIFIED" //

    val LOGIN_ATTEMPT = "LOGIN_ATTEMPT"  // on open login phone
    val LOGIN_SMS_SENT = "LOGIN_SMS_SENT"  // from login phone, when otp sent success
    /**/val LOGIN_PASSWORD_ATTEMPT = "LOGIN_PASSWORD_ATTEMPT"  // on open login with password
    val LOGIN_PASSWORD_SUCCESS = "LOGIN_PASSWORD_SUCCESS"  // on login with password success
    val FORGOT_PASSWORD_ATTEMPT = "FORGOT_PASSWORD_ATTEMPT"  // on forgot password screen
    val PASSWORD_CHANGE = "PASSWORD_CHANGE"  // from create password, on password change success

    //NEW_USER_WATCHED_TUTORIAL
    //NEW_USER_TUTORUAL_SKIP

    val USER_SELECTED_STATE = "USER_SELECTED_STATE" // User selects state **
    val USER_SELECTED_CITY = "USER_SELECTED_CITY" // User select city **
    val NEW_USER_MEDICINE_ADDED = "NEW_USER_MEDICINE_ADDED"  // when click on add medication

    val NEW_USER_GOALS_READINGS = "NEW_USER_GOALS_READINGS"  // when add goal reading
    //val NEW_USER_READING = "NEW_USER_READING"  // when add goal reading

    val USER_CLICKED_PROFILE_COMPLETION =
        "USER_CLICKED_PROFILE_COMPLETION"  // when click on complete profile from home popup

    val USER_CHANGED_GOALS_READINGS = "USER_CHANGED_GOALS_READINGS"  // when update goal reading
    //val USER_CHANGED_MARKER = "USER_CHANGED_MARKER"  // when update goal reading

    val USER_MARKS_MEDICINE = "USER_MARKS_MEDICINE"

    //USER_SELECTED_OPTION
    val USER_CLICKED_ON_REPORT_INCIDENT = "USER_CLICKED_ON_REPORT_INCIDENT"
    val USER_CLICKED_DETAIL_INCIDENT_PAGE = "USER_CLICKED_DETAIL_INCIDENT_PAGE"

    val USER_CLICKED_ON_CAREPLANPAGE_GOAL = "USER_CLICKED_ON_CAREPLANPAGE_GOAL" //
    val USER_TAP_ON_CAREPLAN_READING = "USER_TAP_ON_CAREPLAN_READING" // tap on care plan reading

    val USER_RECORDS_UPDATED = "USER_RECORDS_UPDATED"

    //USER_INCIDENT_HISTORY_FROM_
    //WIDGET
    val USER_SCROLL_DEPTH_HOME = "USER_SCROLL_DEPTH_HOME"
    val USER_SCROLL_DEPTH_CARE_PLAN = "USER_SCROLL_DEPTH_CARE_PLAN"

    //val USER_READ_CONTENT = "USER_READ_CONTENT"
    val USER_PLAY_MEDIA_CONTENT = "USER_PLAY_MEDIA_CONTENT"
    //val USER_TIME_SPENT_CONTENT = "USER_TIME_SPENT_CONTENT" // removed

    val USER_BOOKMARKED_CONTENT = "USER_BOOKMARKED_CONTENT"
    val USER_UN_BOOKMARK_CONTENT = "USER_UN_BOOKMARK_CONTENT"

    val USER_COMMENTED = "USER_COMMENTED"
    val USER_CLICKED_ON_CARD = "USER_CLICKED_ON_CARD"

    //val USER_TIME_SPENT_HOME = "USER_TIME_SPENT_HOME" - removed
    //val USER_TIME_SPENT_CARE_PLAN = "USER_TIME_SPENT_CARE_PLAN" - removed
    //val USER_TIME_SPENT_ENGAGE = "USER_TIME_SPENT_ENGAGE" - removed
    //val USER_TIME_SPENT_EXERCISE = "USER_TIME_SPENT_EXERCISE" - removed

    val USER_VIEW_CONTENT = "USER_VIEW_CONTENT"

    val USER_LIKED_CONTENT = "USER_LIKED_CONTENT"
    val USER_UNLIKED_CONTENT = "USER_UNLIKED_CONTENT"

    //USER_COMMENTED_ON_POST
    val USER_REPORTED_COMMENT = "USER_REPORTED_COMMENT"

    val USER_DELETED_OWN_COMMENT = "USER_DELETED_OWN_COMMENT"
    val USER_UN_REPORTED_COMMENT = "USER_UN_REPORTED_COMMENT"
    val USER_CLICKED_ON_RECORD = "USER_CLICKED_ON_RECORD"

    //val USER_UPLOADED_RECORD = "USER_UPLOADED_RECORD"
    val USER_MARKED_VIDEO_DONE_EXERCISE = "USER_MARKED_VIDEO_DONE_EXERCISE"
    val USER_PLAYED_GIF_IN_EXERCISE = "USER_PLAYED_GIF_IN_EXERCISE"

    val USER_CLICKED_ON_PLAN_EXERCISE = "USER_CLICKED_ON_PLAN_EXERCISE"
    val USER_PLAY_VIDEO = "USER_PLAY_VIDEO"
    val USER_CLICKED_ON_MARK_ALL_AS_DONE = "USER_CLICKED_ON_MARK_ALL_AS_DONE"
    val USER_DURATION_OF_VIDEO = "USER_DURATION_OF_VIDEO"

    val USER_UPDATED_READING = "USER_UPDATED_READING" // For reading update **
    val USER_UPDATED_ACTIVITY = "USER_UPDATED_ACTIVITY" // For goal update **

    //READING_CAPTURED_APPLE_HEALTH
    val READING_CAPTURED_GOOGLE_FIT = "READING_CAPTURED_GOOGLE_FIT"

    val USER_CHANGED_TIME_DURATION =
        "USER_CHANGED_TIME_DURATION" // User changed time duration for chart time
    val USER_CLICKED_ON_EMAIL_VERIFICATION =
        "USER_CLICKED_ON_EMAIL_VERIFICATION" // from home, on email verify click

    //USER_CLICKED_ON_WIDGET
    //USER_CLICKED_ON_ACTIVITY
    //USER_CLICKED_ON_MEDICATION_HOME
    //USER_CLICKED_ON_PRANAYAMA_HOME

    val USER_CLICKED_ON_HOME =
        "USER_CLICKED_ON_HOME" // user click on goals or readings of home with name postfix

    val USER_SEARCHED_FOOD_DISH = "USER_SEARCHED_FOOD_DISH"
    val USER_SELECTED_FOOD_DISH = "USER_SELECTED_FOOD_DISH"
    val USER_ADDED_QUANTITY = "USER_ADDED_QUANTITY"
    val USER_LOGGED_MEAL = "USER_LOGGED_MEAL"

    //USER_ADDED_CALORIE
    //USER_NOT_LOGGED_<meal name>
    val USER_CLICKED_ON_REFERENCE_UTENSILS = "USER_CLICKED_ON_REFERENCE_UTENSILS"

    //USER_LOGGED_<meal name>
    val USER_CLICKED_ON_INSIGHT = "USER_CLICKED_ON_INSIGHT"

    val USER_CLICKED_ON_EDIT_MEAL = "USER_CLICKED_ON_EDIT_MEAL"

    val USER_VIEWED_DAILY_INSIGHT = "USER_VIEWED_DAILY_INSIGHT"

    val USER_CLICKED_ON_MONTHLY_INSIGHT = "USER_CLICKED_ON_MONTHLY_INSIGHT"
    val USER_STARTED_QUIZ = "USER_STARTED_QUIZ"
    //USER_SELECTED_ANSWER

    val NEW_USER_DOCTOR_LINK_VERIFIED = "NEW_USER_DOCTOR_LINK_VERIFIED"  //
    val USER_SHARED_CONTENT = "USER_SHARED_CONTENT"
    val USER_SENT_QUERY = "USER_SENT_QUERY"

    val USER_SIGNUP_COMPLETE = "USER_SIGNUP_COMPLETE"
    val USER_PROFILE_COMPLETED = "USER_PROFILE_COMPLETED"
    val USER_PROFILE_VIEW = "USER_PROFILE_VIEW"
    val USER_LOGGOAL_MEDICINE_CONTENTVIEW = "USER_LOGGOAL_MEDICINE_CONTENTVIEW"

    val GOOGLE_FIT_OPTIN = "GOOGLE_FIT_OPTIN"

    val GOAL_TARGET_VALUE_UPDATED = "GOAL_TARGET_VALUE_UPDATED"

    //
    val GOAL_COMPLETED = "GOAL_COMPLETED"

    val USER_SESSION_START = "USER_SESSION_START"
    val USER_SESSION_END = "USER_SESSION_END"


    //time spent new events
    val TIME_SPENT_MY_ROUTINE = "TIME_SPENT_MY_ROUTINE"

    //val TIME_SPENT_EXPLORE = "TIME_SPENT_EXPLORE" - removed
    val TIME_SPENT_PLAN_DETAIL = "TIME_SPENT_PLAN_DETAIL"
    val TIME_SPENT_PLAN_DETAIL_EXC = "TIME_SPENT_PLAN_DETAIL_EXC"
    val TIME_SPENT_PLAN_DETAIL_BREATH = "TIME_SPENT_PLAN_DETAIL_BREATH"

    //val TIME_SPENT_FOOD_LOG = "TIME_SPENT_FOOD_LOG" - removed
    //val TIME_SPENT_FOOD_DIARY_DAY = "TIME_SPENT_FOOD_DIARY_DAY" - removed
    val TIME_SPENT_FOOD_DIARY_MONTH = "TIME_SPENT_FOOD_DIARY_MONTH"
    val TIME_SPENT_FOOD_INSIGHT = "TIME_SPENT_FOOD_INSIGHT"
    val TIME_SPENT_UPDATE_PRESCRIPTION = "TIME_SPENT_UPDATE_PRESCRIPTION"
    val TIME_SPENT_SUPPORT = "TIME_SPENT_SUPPORT"
    val TIME_SPENT_BREATHING_TIME = "TIME_SPENT_BREATHING_TIME"
    val TIME_SPENT_INCIDENT_HISTORY = "TIME_SPENT_INCIDENT_HISTORY"
    val TIME_SPENT_RECORD_HISTORY = "TIME_SPENT_RECORD_HISTORY"

    //val TIME_SPENT_OPTION_MENU = "TIME_SPENT_OPTION_MENU" - removed
    val TIME_SPENT_ACCOUNT_SETTING = "TIME_SPENT_ACCOUNT_SETTING"
    val TIME_SPENT_SET_GOALS = "TIME_SPENT_SET_GOALS"
    val TIME_SPENT_ADD_GOALS = "TIME_SPENT_ADD_GOALS"
    val TIME_SPENT_ADD_READINGS = "TIME_SPENT_ADD_READINGS"
    val TIME_SPENT_MY_DEVICES = "TIME_SPENT_MY_DEVICES"
    val TIME_SPENT_UPDATE_LOCATION = "TIME_SPENT_UPDATE_LOCATION"
    //val TIME_SPENT_UPDATE_HEIGHT_WEIGHT = "TIME_SPENT_UPDATE_HEIGHT_WEIGHT" - removed


    val USER_CLICKED_READING_INFO = "USER_CLICKED_READING_INFO"

    val USER_ENABLED_NOTIFICATION = "USER_ENABLED_NOTIFICATION"
    val USER_DISABLED_NOTIFICATION = "USER_DISABLED_NOTIFICATION"
    val USER_COMPLETED_COACH_MARKS = "USER_COMPLETED_COACH_MARKS"

    val USER_CHAT_SUPPORT = "USER_CHAT_SUPPORT"
    val USER_CHAT_WITH_HC = "USER_CHAT_WITH_HC"

    val USER_CLICKED_REMINDER_NOTIFICATION = "USER_CLICKED_REMINDER_NOTIFICATION"
    val SIGNUP_OTP_SENT_SUCCESS = "SIGNUP_OTP_SENT_SUCCESS" //send otp success sendOtpSignup API

    val USER_CLICKED_ON_STAY_INFORMED = "USER_CLICKED_ON_STAY_INFORMED"
    val USER_CLICKED_ON_RECOMMENDED = "USER_CLICKED_ON_RECOMMENDED"

    val HEIGHT_WEIGHT_ADDED = "HEIGHT_WEIGHT_ADDED"

    //====
    val USER_PLAY_VIDEO_EXERCISE = "USER_PLAY_VIDEO_EXERCISE"
    //val USER_TIME_SPENT_ASK_EXPERT = "USER_TIME_SPENT_ASK_EXPERT" //removed

    //
    val USER_VIEW_QUESTION = "USER_VIEW_QUESTION"
    val USER_VIEW_ANSWER = "USER_VIEW_ANSWER"
    val USER_POST_QUESTION = "USER_POST_QUESTION"
    val USER_SUBMIT_ANSWER = "USER_SUBMIT_ANSWER"
    val USER_UPDATE_ANSWER = "USER_UPDATE_ANSWER"
    val USER_LIKED_ANSWER = "USER_LIKED_ANSWER"
    val USER_UNLIKED_ANSWER = "USER_UNLIKED_ANSWER"
    val USER_LIKED_COMMENT = "USER_LIKED_COMMENT"
    val USER_UNLIKED_COMMENT = "USER_UNLIKED_COMMENT"
    val USER_BOOKMARKED_QUESTION = "USER_BOOKMARKED_QUESTION"
    val USER_UN_BOOKMARK_QUESTION = "USER_UN_BOOKMARK_QUESTION"

    //
    val LOGIN_OTP_INCORRECT = "LOGIN_OTP_INCORRECT"
    val LOGIN_PASSWORD_INCORRECT = "LOGIN_PASSWORD_INCORRECT"
    val USER_SKIP_PROFILE = "USER_SKIP_PROFILE"
    val USER_CONTINUE_PROFILE = "USER_CONTINUE_PROFILE"
    val USER_SELECT_GOAL = "USER_SELECT_GOAL"
    val USER_SELECT_READING = "USER_SELECT_READING"

    // Labtest events
    val HOME_LABTEST_CARD_CLICKED = "HOME_LABTEST_CARD_CLICKED"
    val CAREPLAN_LABTEST_CARD_CLICKED = "CAREPLAN_LABTEST_CARD_CLICKED"
    val USER_OPEN_POPULAR_LABTESTS = "USER_OPEN_POPULAR_LABTESTS"
    val CALL_US_TO_BOOK_TEST_CLICKED = "CALL_US_TO_BOOK_TEST_CLICKED"
    val TEST_ADDED_TO_CART = "TEST_ADDED_TO_CART"
    val TEST_REMOVED_FROM_CART = "TEST_REMOVED_FROM_CART"
    val USER_VIEWED_CART = "USER_VIEWED_CART"
    val LABTEST_PATIENT_ADDED = "LABTEST_PATIENT_ADDED"
    val LABTEST_PATIENT_SELECTED = "LABTEST_PATIENT_SELECTED"
    val LABTEST_ADDRESS_ADDED = "LABTEST_ADDRESS_ADDED"
    val LABTEST_ADDRESS_UPDATED = "LABTEST_ADDRESS_UPDATED"
    val LABTEST_ADDRESS_DELETED = "LABTEST_ADDRESS_DELETED"
    val LABTEST_ADDRESS_SELECTED = "LABTEST_ADDRESS_SELECTED"
    val LABTEST_APPOINTMENT_TIME_SELECTED = "LABTEST_APPOINTMENT_TIME_SELECTED"
    val USER_OPEN_LABTEST_ORDER_REVIEW = "USER_OPEN_LABTEST_ORDER_REVIEW"
    val LABTEST_ORDER_PAYMENT_SUCCESS = "LABTEST_ORDER_PAYMENT_SUCCESS"
    val LABTEST_ORDER_BOOK_SUCCESS = "LABTEST_ORDER_BOOK_SUCCESS"
    val LABTEST_HISTORY_CARD_CLICKED = "LABTEST_HISTORY_CARD_CLICKED"
    val USER_VIEWED_LABTEST_ORDER_DETAILS = "USER_VIEWED_LABTEST_ORDER_DETAILS"

    //appointment module events
    val CAREPLAN_APPOINTMENT_VIEW_ALL = "CAREPLAN_APPOINTMENT_VIEW_ALL"
    val CAREPLAN_APPOINTMENT_REQ_CANCEL = "CAREPLAN_APPOINTMENT_REQ_CANCEL"
    val CAREPLAN_APPOINTMENT_JOIN_VIDEO = "CAREPLAN_APPOINTMENT_JOIN_VIDEO"
    val APPOINTMENT_HISTORY_DOCTOR = "APPOINTMENT_HISTORY_DOCTOR"
    val APPOINTMENT_HISTORY_COACH = "APPOINTMENT_HISTORY_COACH"
    val APPOINTMENT_HISTORY_REQ_CANCEL = "APPOINTMENT_HISTORY_REQ_CANCEL"
    val APPOINTMENT_HISTORY_JOIN_VIDEO = "APPOINTMENT_HISTORY_JOIN_VIDEO"
    val USER_CLICK_BOOK_APPOINTMENT = "USER_CLICK_BOOK_APPOINTMENT"
    val USER_CONFIRM_BOOK_APPOINTMENT = "USER_CONFIRM_BOOK_APPOINTMENT"
    val BOOK_APPOINTMENT_SUCCESSFUL = "BOOK_APPOINTMENT_SUCCESSFUL"

    //val USER_VIEW_ANSWER = "USER_VIEW_ANSWER"
    val NEW_APP_LAUNCHED = "NEW_APP_LAUNCHED"


    //==============================================================================
    val USER_CLICKED_ON_MENU = "USER_CLICKED_ON_MENU"
    val MENU_NAVIGATION = "MENU_NAVIGATION"
    val ACCOUNT_SETTING_NAVIGATION = "ACCOUNT_SETTING_NAVIGATION"
    val PROFILE_NAVIGATION = "PROFILE_NAVIGATION"

    val DIET_PLAN_DOWNLOAD = "DIET_PLAN_DOWNLOAD"

    val USER_CLICKED_ON_SUBSCRIPTION_PAGE = "USER_CLICKED_ON_SUBSCRIPTION_PAGE"
    val USER_CLICKED_ON_SUBSCRIPTION_DURATION = "USER_CLICKED_ON_SUBSCRIPTION_DURATION"
    val USER_CLICKED_ON_SUBSCRIPTION_BUY = "USER_CLICKED_ON_SUBSCRIPTION_BUY"

    //
    val USER_CLICKED_ON_DIET_PLAN_CARD = "USER_CLICKED_ON_DIET_PLAN_CARD"

    // signup journey revamp sprint may1 2023, new events start==
    val NEW_USER_SIGNED_AS_MYSELF = "NEW_USER_SIGNED_AS_MYSELF"
    val NEW_USER_SIGNED_AS_SOMEONE_ELSE = "NEW_USER_SIGNED_AS_SOMEONE_ELSE"
    val SCAN_DOCTOR_QR = "SCAN_DOCTOR_QR"
    val ENTER_DOCTOR_CODE = "ENTER_DOCTOR_CODE"

    val NEW_USER_MOBILE_CAPTURE = "NEW_USER_MOBILE_CAPTURE" // added this event again
    // signup journey revamp sprint may1 2023, new events end==

    // BCA leftover point events sprint may3 2023, new events start==
    val USER_CLICKS_ON_CONNECT = "USER_CLICKS_ON_CONNECT"
    val MEDICAL_DEVICE_AVAILABILITY = "MEDICAL_DEVICE_AVAILABILITY"
    val USER_TAPS_ON_LEARN_TO_CONNECT = "USER_TAPS_ON_LEARN_TO_CONNECT"
    val USER_TOGGLES_BLUETOOTH = "USER_TOGGLES_BLUETOOTH"
    val MEDICAL_DEVICE_SEARCH_ACTION = "MEDICAL_DEVICE_SEARCH_ACTION"
    val USER_SELECTS_MEDICAL_DEVICE = "USER_SELECTS_MEDICAL_DEVICE"
    val USER_CLICKS_MEASURE = "USER_CLICKS_MEASURE"
    val HEALTH_MARKERS_POPULATED = "HEALTH_MARKERS_POPULATED"
    val USER_DOWNLOADS_REPORT = "USER_DOWNLOADS_REPORT"
    val USER_CLICKED_ON_DEVICE_READINGS = "USER_CLICKED_ON_DEVICE_READINGS"
    val USER_CHANGES_DATE_RANGE = "USER_CHANGES_DATE_RANGE"
    // BCA leftover point events sprint may3 2023, new events end==

    // onboarding events start
    val PRE_ONBOARDING_CAROUSEL = "PRE_ONBOARDING_CAROUSEL"
    val CLOSE_BOTTOM_SHEET = "CLOSE_BOTTOM_SHEET"
    // onboarding events end

    // BCP events start
    val USER_TAPS_ON_CARE_PLAN_CARD = "USER_TAPS_ON_CARE_PLAN_CARD"
    val HOME_CARE_PLAN_CARD_CLICKED = "HOME_CARE_PLAN_CARD_CLICKED"
    val TAP_RENT_BUY = "TAP_RENT_BUY"
    val SHOW_BOTTOM_SHEET = "SHOW_BOTTOM_SHEET"
    val ADD_ADDRESS = "ADD_ADDRESS"
    val SELECT_ADDRESS = "SELECT_ADDRESS"
    val TAP_ADD_NEW = "TAP_ADD_NEW"
    val TAP_SAVE_AND_NEXT = "TAP_SAVE_AND_NEXT"
    val TAP_PROCEED_TO_PAYMENT = "TAP_PROCEED_TO_PAYMENT"

    //val TAP_PROCEED_TO_PAYMENT_LAB_TEST = "TAP_PROCEED_TO_PAYMENT_LAB_TEST"
    val TAP_CONTACT_US = "TAP_CONTACT_US"
    val TAP_LABTEST_CARD = "TAP_LABTEST_CARD"
    val ADD_TEST = "ADD_TEST"
    val SELECT_DATE_TIME = "SELECT_DATE_TIME"
    val TAP_BOOK_LAB_TEST = "TAP_BOOK_LAB_TEST"
    val TAP_HEALTH_COACH_CARD = "TAP_HEALTH_COACH_CARD"
    val TAP_DEVICE_CARD = "TAP_DEVICE_CARD"

    //val USER_CHANGES_DATE = "USER_CHANGES_DATE"
    // BCP events end

    //Revamped exercise plan events starts
    val USER_TAPS_ON_BOTTOM_NAV = "USER_TAPS_ON_BOTTOM_NAV"
    val USER_TAPS_ON_ROUTINE = "USER_TAPS_ON_ROUTINE"
    val USER_SUBMIT_FEEDBACK = "USER_SUBMIT_FEEDBACK"
    val USER_CHANGES_DATE = "USER_CHANGES_DATE"
    val USER_TAPS_ON_READ_MORE = "USER_TAPS_ON_READ_MORE"
    val USER_GOES_BACK = "USER_GOES_BACK"
    //Revamped exercise plan events ends


    // BCP events start
    val SELECT_TEST_TYPE = "SELECT_TEST_TYPE"
    val USER_VIEWS_ALL_READINGS = "USER_VIEWS_ALL_READINGS"
    // BCP events end

    //Discount on app events starts
    val USER_TAPS_ON_APPLY_COUPON_CARD = "USER_TAPS_ON_APPLY_COUPON_CARD"
    val USER_TAPS_ON_DETAILS = "USER_TAPS_ON_DETAILS"
    val APPLY_CLICK = "APPLY_CLICK"
    val USER_TAPS_OK = "USER_TAPS_OK"
    val USER_TAPS_ON_REMOVE = "USER_TAPS_ON_REMOVE"
    val USER_ENTERS_CODE = "USER_ENTERS_CODE"
    //Discount on app events ends

    // GEO Location events start
//    val SHOW_BOTTOM_SHEET = "SHOW_BOTTOM_SHEET"
    val TAP_SELECT_MANUALLY = "TAP_SELECT_MANUALLY"
    val TAP_GRANT_LOCATION = "TAP_GRANT_LOCATION"
    val PINCODE_ENTERED = "PINCODE_ENTERED"
    val USE_CURRENT_LOCATION = "USE_CURRENT_LOCATION"
    val BACK_BUTTON_CLICK = "BACK_BUTTON_CLICK"
    val LOCATION_SEARCH = "LOCATION_SEARCH"
    val MAP_USAGE = "MAP_USAGE"
    val TAP_COMPLETE_ADDRESS = "TAP_COMPLETE_ADDRESS"
    val TAP_SAVE_ADDRESS = "TAP_SAVE_ADDRESS"
    val LOCATION_PERMISSION = "LOCATION_PERMISSION"
    // GEO Location events end

    val RENEW_PLAN = "RENEW_PLAN"

    val USER_CLICK_DONT_HAVE_ACCESS_CODE = "USER_CLICK_DONT_HAVE_ACCESS_CODE"
    val USER_CLICK_HAVE_ACCESS_CODE = "USER_CLICK_HAVE_ACCESS_CODE"
    val USER_CLICK_CHECK_ACCESS_CODE = "USER_CLICK_CHECK_ACCESS_CODE"
    val ACCESS_CODE_VERIFY_SUCCESS = "ACCESS_CODE_VERIFY_SUCCESS"
    val ACCESS_CODE_VERIFY_FAIL = "ACCESS_CODE_VERIFY_FAIL"
    val DOCTOR_ACCESS_CODE_HIDDEN_BY_DEFAULT = "DOCTOR_ACCESS_CODE_HIDDEN_BY_DEFAULT"
    val USER_ADD_ACCOUNT_STEP_SUCCESS = "USER_ADD_ACCOUNT_STEP_SUCCESS"

    val APP_LINK_DOMAINS = "APP_LINK_DOMAINS"


    // Analytics instance
    var firebaseAnalytics: FirebaseAnalytics? = null
    var weAnalytics: Analytics? = null
    var weUser: User? = null

    init {
        //firebase
        firebaseAnalytics = Firebase.analytics
        firebaseAnalytics?.setSessionTimeoutDuration(TimeUnit.MINUTES.toMillis(1))
        //webengage
        weAnalytics = WebEngage.get().analytics()
        weUser = WebEngage.get().user()
        //freshdesk
        initFreshdesk()
        //ApXorSDK
        ApxorSDK.initialize(context.resources.getString(R.string.apxor_key_value), context)
    }

    private fun initFreshdesk() {
        val freshChatConfig: FreshchatConfig = FreshchatConfig(
            /*getApplicationContext().resources.getString(R.string.freshdesk_app_id)*/
            BuildConfig.freshdesk_app_id,
            /*getApplicationContext().resources.getString(R.string.freshdesk_app_key)*/
            BuildConfig.freshdesk_app_key
        )
        freshChatConfig.domain = BuildConfig.freshdesk_domain
        /*getApplicationContext().resources.getString(R.string.freshdesk_domain)*/

        freshChatConfig.isCameraCaptureEnabled = true
        freshChatConfig.isGallerySelectionEnabled = true
        freshChatConfig.isResponseExpectationEnabled = true
        Freshchat.getInstance(getApplicationContext()).init(freshChatConfig)
    }

    fun logEvent(
        eventName: String, bundle: Bundle = Bundle(),
        screenName: String? = null,
        eventNamePostFix: String? = null,
    ) {

        // Event Name
        val finalEventName = if (eventNamePostFix.isNullOrBlank().not()) {
            eventName + "_" + eventNamePostFix?.uppercase(Locale.ENGLISH)
        } else {
            eventName
        }

        // common parameters for all events
        bundle.putString(
            PARAM_LOG_DATE,
            DateTimeFormatter.date(/*Date()*/ Calendar.getInstance().time)
                .formatDateToLocalTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
        )
        bundle.putString(PARAM_DEVICE_TYPE, "Android")

        bundle.putString(PARAM_CURRENT_APP_VERSION, BuildConfig.VERSION_NAME)
        bundle.putString(PARAM_ANDROID_VERSION, DeviceUtils.deviceOSVersion)
        bundle.putString(
            PARAM_SCREEN_RESOLUTION,
            DeviceUtils.deviceResolution(getApplicationContext())
        )
        if (screenName.isNullOrBlank().not()) {
            bundle.putString(PARAM_SCREEN_NAME, screenName)
        }

        if (session.userId.isNotBlank()) {
            session.user?.let {
                bundle.putString(PARAM_PATIENT_ID, session.userId)

                bundle.putString(PARAM_PATIENT_GENDER, it.gender ?: "")
                bundle.putString(
                    PARAM_PATIENT_INDICATION,
                    it.medical_condition_name?.firstOrNull()?.medical_condition_name ?: ""
                )
                it.patient_link_doctor_details?.firstOrNull()?.let { doctor ->
                    bundle.putString(PARAM_DOCTOR_ID, doctor.doctor_id ?: "")
                    bundle.putString(PARAM_DOCTOR_SPECIALIZATION, doctor.specialization ?: "")
                }

                bundle.putString(
                    PARAM_HEALTH_COACH_IDS,
                    it.hc_list?.appendFieldAsString(HealthCoachData::health_coach_id)
                )
                bundle.putString(
                    PARAM_HEALTH_COACH_SPECIALIZATION,
                    it.hc_list?.appendFieldAsString(HealthCoachData::role)
                )

                bundle.putString(PARAM_CITY, it.city ?: "")
                bundle.putString(PARAM_EMAIL_VERIFIED, it.email_verified ?: "")

                // user current plan parameters
                bundle.putString(PARAM_CURRENT_PLAN_NAME, it.allCurrentPlanNames)
                bundle.putString(PARAM_CURRENT_PLAN_ID, it.allCurrentPlanIds)
                bundle.putString(PARAM_CURRENT_PLAN_TYPE, it.allCurrentPlanTypes)

                //bundle.putString(PARAM_LINKED_DEVICES, "")
            }
        }

        // Firebase Analytics
        firebaseAnalytics?.logEvent(finalEventName, bundle)

        // WebEngage Analytics
        if (bundle.keySet()?.isNullOrEmpty() == true) {
            weAnalytics?.track(finalEventName)
        } else {
            weAnalytics?.track(finalEventName, bundleToMap(bundle))
        }


        //ApXor SDK Analytics
        ApxorSDK.logAppEvent(finalEventName, bundleToAttribute(bundle))

        Log.d("EVENT_FIRE", "::  $finalEventName :: $bundle")
    }

    fun setScreenName(screenName: String) {
        weAnalytics?.screenNavigated(screenName)

        firebaseAnalytics?.logEvent(
            FirebaseAnalytics.Event.SCREEN_VIEW,
            bundleOf(Pair(FirebaseAnalytics.Param.SCREEN_NAME, screenName))
        )

        ApxorSDK.setCurrentScreenName(screenName)
        ApxorSDK.trackScreen(screenName)
    }

    fun login(user: com.mytatva.patient.data.pojo.User) {
        user.patient_id?.let {

            //webengage user
            weUser?.login(it)

            //ApXor SDK
            ApxorSDK.setUserIdentifier(it)


            //set WE system attributes
            weUser?.setEmail(user.email)
            weUser?.setPhoneNumber(user.country_code + user.contact_no)
            weUser?.setFirstName(user.name)
            weUser?.setBirthDate(user.dob ?: "")
            //weUser?.setLocation(latitude, longitude)
            //weUser?.setLastName()
            //weUser?.setBirthDate(user.dob)
            //weUser?.setOptIn(Channel.PUSH, true)
            weUser?.setGender(
                if (user.gender == "M") Gender.MALE
                else if (user.gender == "F") Gender.FEMALE
                else Gender.OTHER
            )
            //set WE custom attributes
            weUser?.setAttribute(
                "indication",
                user.medical_condition_name?.firstOrNull()?.medical_condition_name
            )
            weUser?.setAttribute("dr_name", user.patient_link_doctor_details?.firstOrNull()?.name)
            weUser?.setAttribute(
                "dr_phone",
                user.patient_link_doctor_details?.firstOrNull()?.contact_no
            )
            weUser?.setAttribute("language", user.language_name)
            weUser?.setAttribute("severity", user.severity_name)
            weUser?.setAttribute("email", user.email ?: "")
            weUser?.setAttribute("name", user.name ?: "")
            weUser?.setAttribute("phone", user.country_code + user.contact_no)
            weUser?.setAttribute("birthDate", user.dob ?: "")
            weUser?.setAttribute(
                "patientGender",
                if (user.gender == "M") "Male" else if (user.gender == "F") "Female" else ""
            )
            weUser?.setAttribute("current_plan_type", user.allCurrentPlanTypes)
            weUser?.setAttribute("current_plan_name", user.allCurrentPlanNames)
            /*weUser?.setAttribute("Twitter username", "@origjohndoe86")*/
            //delete custom attributes
            /*weUser?.deleteAttribute("Points earned")
            weUser?.deleteAttributes(arrayListOf(""))*/

            //ApXor User Details data set in Dashboard
            ApxorSDK.setUserCustomInfo(Attributes().apply {
                putAttribute(
                    "indication",
                    user.medical_condition_name?.firstOrNull()?.medical_condition_name
                )
                putAttribute("dr_name", user.patient_link_doctor_details?.firstOrNull()?.name)
                putAttribute(
                    "dr_phone",
                    user.patient_link_doctor_details?.firstOrNull()?.contact_no
                )
                putAttribute("language", user.language_name)
                putAttribute("severity", user.severity_name)

                putAttribute("email", user.email)
                putAttribute("phone_number", user.country_code + user.contact_no)
                putAttribute("name", user.name)
                putAttribute("dob", user.dob ?: "")
                putAttribute("gender", user.gender)
                putAttribute("current_plan_type", user.allCurrentPlanTypes)
                putAttribute("current_plan_name", user.allCurrentPlanNames)
            });

            //firebase user
            firebaseAnalytics?.setUserId(it)

            //freshdesk user -  when restore_id is null fresh chat create new restore id and
            //it will be stored to user model
            Freshchat.getInstance(getApplicationContext())
                .identifyUser(user.patient_id, user.restore_id)
            // Get the user object for the current installation
            val freshChatUser = Freshchat.getInstance(getApplicationContext()).user
            freshChatUser.firstName = user.name
            //freshchatUser.lastName = "Doe"
            freshChatUser.email = user.email
            freshChatUser.setPhone(user.country_code, user.contact_no)


            val userMeta: HashMap<String, String> = HashMap()
            userMeta["name"] = user.name ?: ""
            userMeta["email"] = user.email ?: ""
            userMeta["patientId"] = user.patient_id ?: ""
            userMeta["gender"] = user.gender ?: ""

            /*userMeta["nutritionist"] =
                user.hc_list?.firstOrNull { it.role.equals("Nutritionist", true) }?.fullName ?: ""
            userMeta["physiotherapist"] =
                user.hc_list?.firstOrNull { it.role.equals("Physiotherapist", true) }?.fullName
                    ?: ""*/

            Freshchat.getInstance(getApplicationContext()).setUserProperties(userMeta)

            // Call setUser so that the user information is synced with Freshchat's servers
            Freshchat.getInstance(getApplicationContext()).setUser(freshChatUser)

            Freshchat.getInstance(getApplicationContext())
                .setPushRegistrationToken(session.deviceId)

        }
    }

    fun logout() {
        weUser?.logout()
        Freshchat.resetUser(getApplicationContext())
    }

    private fun bundleToMap(extras: Bundle): Map<String, Any?> {
        val map: MutableMap<String, Any?> = HashMap()
        val ks = extras.keySet()
        val iterator: Iterator<String> = ks.iterator()
        while (iterator.hasNext()) {
            val key = iterator.next()
            //uncomment below code to pass date object
            //in map instead of string formatted date
            /*if (key == PARAM_LOG_DATE) {
                // pass date obj in map instead of stringDate
                map[key] = Date()
            } else {*/
            map[key] = extras.get(key)
            /*}*/
        }
        return map
    }

    private fun bundleToAttribute(extras: Bundle): Attributes {
        val attribute = Attributes()
        val ks = extras.keySet()
        val iterator: Iterator<String> = ks.iterator()
        while (iterator.hasNext()) {
            val key = iterator.next()
            attribute.putAttribute(key, extras.getString(key))
        }
        return attribute
    }

    //Web Engage Event Names
    companion object {
        val CLICKED_SELECT_MANUALLY = "CLICKED_SELECT_MANUALLY"
        val CLICKED_SEARCH = "CLICKED_SEARCH"
        val CLICKED_GRANT_LOCATION = "CLICKED_GRANT_LOCATION"
        val CLICKED_NOTIFICATION = "CLICKED_NOTIFICATION"
        val MENU_NAVIGATION = "MENU_NAVIGATION"
        val HOME_CARE_PLAN_CARD_CLICKED = "HOME_CARE_PLAN_CARD_CLICKED"
        val USER_CLICKED_ON_DIET_PLAN_CARD = "USER_CLICKED_ON_DIET_PLAN_CARD"
        val CLICKED_HEALTH_DIARY = "CLICKED_HEALTH_DIARY"
        val CLICKED_HEALTH_INSIGHTS = "CLICKED_HEALTH_INSIGHTS"
        val CLICKED_CONSULT_NUTRITIONIST = "CLICKED_CONSULT_NUTRITIONIST"
        val USER_CLICKED_ON_CARD = "USER_CLICKED_ON_CARD"
        val SHOW_BOTTOM_SHEET = "SHOW_BOTTOM_SHEET"
        val PINCODE_ENTERED = "PINCODE_ENTERED"
        val USE_CURRENT_LOCATION = "USE_CURRENT_LOCATION"
        val USER_CLICKED_ON_MENU = "USER_CLICKED_ON_MENU"
        val CLICKED_BOOK_DEVICES = "CLICKED_BOOK_DEVICES"
        val HOME_LABTEST_CARD_CLICKED = "HOME_LABTEST_CARD_CLICKED"
        val CLICKED_CONTENT_VIEW_ALL = "CLICKED_CONTENT_VIEW_ALL"
        val CLICK_APPLY = "CLICK_APPLY"
        val CLICKED_CONSULT_PHYSIO = "CLICKED_CONSULT_PHYSIO"
        val BACK_BUTTON_CLICK = "BACK_BUTTON_CLICK"
    }
}