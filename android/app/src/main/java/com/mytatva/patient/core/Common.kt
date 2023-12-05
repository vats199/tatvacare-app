package com.mytatva.patient.core

import android.Manifest
import android.graphics.Color
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.data.model.Device

object Common {

    val SMS_SENDER_PHONE_NUMBER = null

    const val APP_NAME = "MyTatva"
    const val SS_DOMAIN = "hyperlink.surveysparrow.com"

    val PASSWORD_PATTERN =
        "^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#\$%^&*])(?=.*\\d)[a-zA-Z\\d|#@\$!%*?&.]{6,}\$"

    val NAME_PATTERN = "^.*[a-zA-Z0-9]+.*$"
    val STUDY_ID_PATTERN = "^(?:[A-Za-z0-9]{3}-?){1,3}\$"
    //"^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*\\d)[a-zA-Z\\d|#@$!%*?&.]{6,}$"
    //*[!@#$%^&*

    const val IS_LOGIN = "isLogin"
    const val IS_BIOMETRIC_ENABLED = "isBiometricEnabled"
    const val IS_COACHMARKS_COMPLETED = "isCoachMarksCompleted"
    const val IS_FIRST_TIME_OPENED = "isFirstTimeOpened"
    const val IS_TO_OPEN_LOGIN_STEP = "isToOpenLoginStep"

    const val IS_TO_HIDE_LANGUAGE_PAGE = "isToHideLanguagePage"
    const val IS_APP_UNDER_MAINTENANCE = "isAppUnderMaintenance"

    const val APP_VERSION_CODE = "appVersionCode"

    // notification channel constants
    const val CHANNEL_ID: String = BuildConfig.APPLICATION_ID.plus(".notifications")
    const val CHANNEL_NAME: String = "My Tatva"
    const val CHANNEL_DESC: String = "Default notifications"

    public val PERMISSIONS_STORAGE =
        arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE/*, Manifest.permission.WRITE_EXTERNAL_STORAGE*/)
    public val PERMISSIONS_CAMERA = arrayOf(
        Manifest.permission.CAMERA,
        Manifest.permission.READ_EXTERNAL_STORAGE/*,
        Manifest.permission.WRITE_EXTERNAL_STORAGE*/
    )
    public val PERMISSIONS_RECORD_VIDEO = arrayOf(
        Manifest.permission.CAMERA,
        Manifest.permission.READ_EXTERNAL_STORAGE,
        Manifest.permission.RECORD_AUDIO/*,
            Manifest.permission.WRITE_EXTERNAL_STORAGE*/
    )
    public val PERMISSIONS_RECORD_AUDIO =
        arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.RECORD_AUDIO)
    val PERMISSIONS_CALENDAR =
        arrayOf(Manifest.permission.READ_CALENDAR, Manifest.permission.WRITE_CALENDAR)

    val PERMISSIONS_ONLY_CAMERA = arrayOf<String>(Manifest.permission.CAMERA)

    object MapKey {
        const val ENABLE_GPS_LOCATION_REQUEST_CODE = 1
        const val AUTOCOMPLETE_REQUEST_CODE = 2
        const val LOCATION_FINE_PERMISSION_REQUEST_CODE = 501
        const val LOCATION_COARSE_PERMISSION_REQUEST_CODE = 502

        const val PREF_LATITUDE = "pref_latitude"
        const val PREF_LONGITUDE = "pref_longitude"
        const val LATITUDE = "latitude"
        const val LONGITUDE = "longitude"
        const val LATLONG = "latlong"
        const val PREF_CITY_NAME = "CityName"
    }

    object BundleKey {
        const val ACCESS_TOKEN = "accessToken"
        const val ROOM_NAME = "roomName"
        const val DOCTOR_HC_NAME = "doctorHcName"
        const val ROOM_ID = "roomId"
        const val ROOM_SID = "roomSid"
        const val PATIENT_MEAL_REL_ID = "patient_meal_rel_id"
        const val MEAL_TYPE_KEY = "meal_type_key"
        const val KEY = "key"
        const val INCIDENT_SURVEY_DATA = "incidentSurveyData"
        const val FOOD_INSIGHT_RES_DATA = "foodInsightResData"
        const val MEAL_TYPE = "meal_type"
        const val SOCIAL_ID = "social_id"
        const val LANGUAGE_DATA = "language_data"
        const val PHONE = "phone"
        const val VERIFY_OTP_SIGNUP_RES_DATA = "verifyOtpSignUpResData"
        const val IS_GOAL = "is_goal"
        const val IS_ALL = "is_all"
        const val IS_TO_OPEN_HOME_ON_BACK = "isToOpenHomeOnBack"
        const val IS_TO_SHOW_MEASURE = "isToShowMeasure"
        const val SELECT_TYPE = "select_type"
        const val STATE_ID = "state_id"
        const val STATE_NAME = "state_name"
        const val SCREEN_NAME = "screen_name"
        const val ACCESS_CODE = "access_code"
        const val IS_QR_SCAN_SUCCESS = "isQrScanSuccess"
        const val DOCTOR_ACCESS_CODE = "doctor_access_code"
        const val CALENDAR = "calendar"
        const val CALENDAR_FOR_CALORIES = "calendarForCalories"
        const val DEEP_LINK = "deep_link"
        const val CONTENT_TYPE = "content_type"
        const val TYPE = "type"
        const val GENRE_ID = "genre_id"
        const val TITLE = "title"
        const val PLAN_TYPE = "plan_type"
        const val SHOW_PLAN_TYPE = "show_plan_type"
        const val DESCRIPTION = "description"
        const val CONTENT_ID = "content_id"
        const val EXERCISE_ADDED_BY = "exercise_added_by"
        const val ANSWER_ID = "answer_id"
        const val COMMON_SELECT_ITEM_DATA = "common_select_item_data"
        const val SELECTED_FOOD_DATA = "selected_food_data"
        const val SELECTION = "selection"
        const val APPOINTMENT_DATA = "appointmentData"
        const val MESSAGE = "message"
        const val ADDRESS_DATA = "addressData"
        const val MEDICINE_NAME = "medicine_name"
        const val MEDICINE_ID = "medicine_id"
        const val PLAN_ID = "plan_id"
        const val PLAN_DATA = "plan_data"
        const val PLAN_DURATION_DATA = "plan_duration_data"
        const val PATIENT_PLAN_REL_ID = "patient_plan_rel_id"
        const val SELECTED_GOAL = "selected_goal"
        const val GOALS = "goals"
        const val NOTIFICATION_MASTER_ID = "notification_master_id"
        const val IS_REMINDER_ON = "is_reminder_on"
        const val IS_EXERCISE_VIDEO = "is_exercise_video"
        const val SELECTED_READING = "selected_reading"
        const val GOAL_LIST = "goal_list"
        const val GOAL_MASTER_ID = "goal_master_id"
        const val TODAYS_ACHIEVED_VALUE = "todays_achieved_value"
        const val GOAL_VALUE = "goal_value"
        const val READING_LIST = "reading_list"
        const val POSITION = "position"
        const val MEDIA_URL = "media_url"
        const val URL = "url"
        const val NOTIFICATION = "notification"
        const val EXERCISE_PLAN_DAY_ID = "exercise_plan_day_id"
        const val ROUTINE = "routine"

        const val DATE = "date"
        const val TIME_SLOT = "timeSlot"
        const val PATIENT_INCIDENT_ADD_REL_ID = "patient_incident_add_rel_id"
        const val INCIDENT_TRACKING_MASTER_ID = "incident_tracking_master_id"

        const val IS_SHOW_RECORD = "isShowRecord"
        const val IS_SHOW_INCIDENT = "isShowIncident"
        const val IS_SHOW_TEST = "isShowTest"
        const val IS_FOR_LOGIN = "isForLogin"
        const val IS_CLICK_ON_BUY = "isClickOnBuyButton"
        const val IS_INDIVIDUAL_PLAN = "isIndividualPlan"

        const val LAB_TEST_ID = "labTestId"
        const val LAB_TEST_TITLE = "labTestTitle"
        const val RED_CLIFF_ID = "redCliffID"

        const val LIST_CART_DATA = "listCartData"
        const val TEST_PATIENT_DATA = "testPatientData"
        const val TEST_ADDRESS_DATA = "testAddressData"
        const val ORDER_MASTER_ID = "orderMasterId"
        const val PIN_CODE = "pinCode"
        const val LAB_TEST_DATA = "labTestData"
        const val MASTER_ID = "MasterID"
        const val HISTORY_TEST_ORDER_DATA = "HistoryTestOrderData"

        const val IS_TO_SET_CALLBACK_RESULT = "isToSetCallbackResult"
        const val FINAL_AMOUNT_TO_PAY = "finalAmountToPay"
        const val IS_PHYSIOTHERAPIST = "isPhysiotherapist"

        const val ENABLE_RENT_BUY = "enable_rent_buy"

        const val IS_OPEN_FROM_ALL_READINGS = "is_open_from_all_readings"
        const val IS_TO_UPDATE_SPIRO_READINGS = "is_to_update_spiro_readings"
        const val IS_FROM_LAB_TEST = "is_from_lab_test"
        const val PAYABLE_AMOUNT = "payable_amount"
        const val ORDER_REVIEW_PAYABLE_AMOUNT = "order_review_payable_amount"
        const val CHECK_COUPON_DATA = "check_coupon_data"
        const val COUPON_CODE_DATA = "coupon_code_data"
        const val IS_RECENT_ADDED = "isRecentAdded"
        const val PINCODE = "pincode"
        const val EVENT_NAME = "event_name"
        const val IS_OPEN_FROM_PLAN_LIST = "is_open_from_plan_list"
        const val VENDOR_FLAG = "VendorFlag"
        const val IS_FROM_CHANGE_ADDRESS = "isFromChangeAddress"
    }

    object ReminderValueType {
        // common goal reminder value types
        val DAYS = "days"
        val FREQUENCY = "frequency"
        val TIME = "time"

        // water reminder value types
        val TIMES = "times" // 1 time, 2 times
        val HOUR = "hour" // 1 hour, 2 hour
    }

    object Colors {
        val COLOR_PRIMARY = Color.parseColor("#760FB2")
    }

    object RequestCode {
        const val REQUEST_SELECT_LANGUAGE = 1
        const val REQUEST_SELECT_GOAL = 2
        const val REQUEST_SELECT_READING = 3
        const val REQUEST_SELECT_STATE = 4
        const val REQUEST_SELECT_CITY = 5
        const val REQUEST_SELECT_MEDICINE = 6

        const val REQUEST_INCIDENT_SURVEY = 7
        const val REQUEST_SELECT_RECORD_TITLE = 8
        const val REQUEST_SMS_CONSENT = 9
        const val REQUEST_CAMERA_PERMISSION = 10
        const val REQUEST_SCAN_QR_CODE = 11
        const val REQUEST_APPOINTMENT_PAYMENT = 12
        const val REQUEST_CALLBACK_LABTEST_DETAILS = 13
        const val REQUEST_SELECT_FOOD = 14
        const val REQUEST_APPOINTMENT_SCHEDULE = 15
        const val REQUEST_SPIROMETER_REAINGS = 16
        const val REQUEST_COUPON_CODE = 17
        const val REQUEST_GOOGLE_PLACE = 18
    }

    object ResponseCode {
        val SUCCESS = 1
        val INACTIVE_ACCOUNT = 3
        val VERIFY_OTP = 4
        val SOCIAL_ID_NOT_REGISTER = 11

        val FORCE_UPDATE_APP = 6
        val APP_UNDER_MAINTENENCE = 7
        val OPTIONAL_UPDATE_APP = 8

        val USER_ALREADY_REGISTERED = 12
        val LABTEST_TEST_CONFLIGE_IN_CART = 5
    }

    object NotificationTag {
        const val LogGoal = "LogGoal"
        const val LogReading = "LogReading"
        const val DoctorAppointment = "DoctorAppointment"
        const val UpdateGoalValue = "UpdateGoalValue"
        const val HealthcoachTask = "HealthcoachTask"
        const val HealthcoachContent = "HealthcoachContent"
        const val HealthcoachAppointment = "HealthcoachAppointment"
        const val LabTestOrderUpdate = "LabTestOrderUpdate"
    }

    object ExerciseType {
        const val BREATHING = "B"
        const val EXERCISE = "E"
    }

    object ExercisePlanType {
        const val NORMAL = "normal"
        const val CUSTOM = "custom"
    }

    object QuestionDocType {
        const val PDF = "PDF"
        const val PHOTO = "Photo"
    }

    object AnswerUserType {
        const val HEALTHCOACH = "H"
        const val PATIENT = "P"
        const val DOCTOR = "D"
        const val ADMIN = "A"
    }

    object AppointmentForType {
        const val HEALTHCOACH = "H"
        const val DOCTOR = "D"
    }

    object AddressTypes {
        const val HOME = "Home"
        const val WORK = "Work"
        const val OFFICE = "Office"
        const val OTHER = "Other"
    }

    object CapabilityYesNo {
        const val YES = "Yes"
        const val NO = "No"
    }

    object PaymentHistoryType {
        const val PLAN = "plan"
        const val TEST = "test"
    }

    object AnalyticsEventActions {
        const val MORE_DETAILS = "more details"
        const val BUY = "buy"
        const val CARD = "card"
        const val CANCEL = "cancel"
    }

    object AuthStep {
        /*const val SELECT_ROLE = "1"
        const val VERIFY_LINK_DOCTOR = "2"
        const val ADD_ACCOUNT_DETAILS = "3"*/

        const val LETS_BEGIN = "1"
        const val SETUP_YOUR_PROFILE = "2"
        const val CHOOSE_CONDITION = "3"
    }

    object MedicalDevice {
        const val BCA = "BCA"
        const val SPIROMETER = "Spirometer"

        fun getDeviceNameFromKey(deviceKey: String): String {
            return if (deviceKey == Device.BcaScale.deviceKey)
                BCA
            else if (deviceKey == Device.Spirometer.deviceKey)
                SPIROMETER
            else
                ""
        }
    }

    object MyTatvaPlanType {
        const val INDIVIDUAL = "Individual"
        const val TRIAL = "Trial"
        const val SUBSCRIPTION = "Subscription"
        const val FREE = "Free"
    }

    object LabTestVendorType {
        const val RED_CLIFF = "redcliff"
        const val RED_CLIFF_ORDER_STATUS_CANCELLED = "Cancelled"
        const val RED_CLIFF_ORDER_STATUS_COMPLETED = "Completed"
    }
}