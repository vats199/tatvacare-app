//
//  GoogleAnalytics.swift

//
//  Created by you on 24/06/22.
//  Copyright © 2023 MyTatva. All rights reserved.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsParameters: String {
    case patient_id
    case log_date
    case device_type
    
    case patientGender
    case patientIndication
    case currentAppVersion
    case iOS_Version
    case OS_Version
        

    case screenResolution
    case doctor_access_code
    case doctorId
    case doctorSpecialization
    case healthCoachId
    case city
    case emailVerified
    case HealthCoachSpecialization
    case goal_name
    case goal_id
    case goal_value
    case reading_name
    case reading_id
    case duration
    case survey_id
    case occurIncidentTrackingMasterId
    case content_master_id
    case content_type
    case feature_status
    case diet_start_date
    case diet_end_date
    case content_comments_id
    case patient_records_id
    case exercise_plan_day_id
    case type
    case food_name
    case food_item_id
    case meal_types_id
    case duration_second
    case notification_master_id
    case health_coach_id
    case phone_no
    case is_select
    case lab_test_id
    case address_id
    case member_id
    case appointment_date
    case slot_time
    case transaction_id
    case order_master_id
    case appointment_id
    case ScreenName
    case language_selected
    
    case plan_id
    case plan_type
    case plan_expiry_date
    case plan_duration
    case plan_value
    case menu
    case cards
    case current_plan_name
    case current_plan_id
    case current_plan_type
    case action
    
    case medical_device
    case Device_availability
    case toggle
    case attempt
    case date_range_value
    case module
    
    case changed_from
    case changes_to
    case bottom_sheet_name
    case carousel_number
    case auto_flag
    
    case card_number
    case address_number
    case address_type
    case rentOrBuy
    case slot_booking_for
    case patient_plan_rel_id
    
    case exercise_id
    case exercise_name
    case exercise_day
    case validity_range
    case start_date
    case end_date
    case routine_no
    case patient_exercise_plans_id
    case title
    case breathing_exercise
    case value
    case flag
    case sync_status
    case exercise_plan_name

}

enum PlanActionParameter: String {
    case moreDetails = "more details"
    case buy = "buy"
    case card = "card"
    case cancle = "cancel"
}

/*
 val NEW_USER_LANGUAGE_SELECTION =
         "NEW_USER_LANGUAGE_SELECTION" // submit click on select language
     val NEW_USER_OTP_VERIFY = "NEW_USER_OTP_VERIFY" // on signup verify otp success
     val LOGIN_OTP_SUCCESS = "LOGIN_OTP_SUCCESS" // on login verify otp success
     val NEW_USER_SIGNUP_ATTEMPT = "NEW_USER_SIGNUP_ATTEMPT"  // on open signup phone screen
     val NEW_USER_MOBILE_CAPTURE =
         "NEW_USER_MOBILE_CAPTURE" // on signup phone screen, when send otp success

     val NEW_USER_ACCESS_CODE_VERIFY = "NEW_USER_ACCESS_CODE_VERIFY" //
     val NEW_USER_EMAIL_VERIFICATION =
         "NEW_USER_EMAIL_VERIFICATION" // as per jira, in add account screen
     val NEW_USER_QRCODE_VERIFIED = "NEW_USER_QRCODE_VERIFIED" //
     val NEW_USER_DOCTOR_LINK_VERIFIED = "NEW_USER_DOCTOR_LINK_VERIFIED"  //

     val LOGIN_ATTEMPT = "LOGIN_ATTEMPT"  // on open login phone
     val LOGIN_SMS_SENT = "LOGIN_SMS_SENT"  // from login phone, when otp sent success
     val LOGIN_PASSWORD_ATTEMPT = "LOGIN_PASSWORD_ATTEMPT"  // on open login with password
     val LOGIN_PASSWORD_SUCCESS = "LOGIN_PASSWORD_SUCCESS"  // on login with password success
     val FORGOT_PASSWORD_ATTEMPT = "FORGOT_PASSWORD_ATTEMPT"  // on forgot password screen
     val PASSWORD_CHANGE = "PASSWORD_CHANGE"  // from create password, on password change success
     val NEW_USER_MEDICINE_ADDED = "NEW_USER_MEDICINE_ADDED"  // when click on add medication
     val NEW_USER_GOALS = "NEW_USER_GOALS"  // when add goal reading
     val NEW_USER_READING = "NEW_USER_READING"  // when add goal reading
     val USER_CLICKED_PROFILE_COMPLETION =
         "USER_CLICKED_PROFILE_COMPLETION"  // when click on complete profile from home popup
     val USER_CLICKED_ON_EMAIL_VERIFICATION =
         "USER_CLICKED_ON_EMAIL_VERIFICATION" // from home, on email verify click
     val USER_CHANGED_GOAL = "USER_CHANGED_GOAL"  // when update goal reading
     val USER_CHANGED_MARKER = "USER_CHANGED_MAR

 */

enum FIREventType {
    
    case NEW_USER_LANGUAGE_SELECTION // On new user selecting language **
    case USER_SIGNUP_COMPLETE // **
    case USER_PROFILE_COMPLETED // **
    case USER_PROFILE_VIEW // **
    case NEW_USER_SIGNUP_ATTEMPT // User Enter Screen **
    case NEW_USER_MOBILE_CAPTURE // Click on Next button with Successful Validation
    case NEW_USER_OTP_VERIFY // On User Verify OTP(In case Register Flow) **
    case NEW_USER_SIGNED_AS_MYSELF //When the user selects ‘Myself’ while signing up
    case NEW_USER_SIGNED_AS_SOMEONE_ELSE //When the user signs in for someone else
    case SCAN_DOCTOR_QR //When the user scans the doctor QR code to link themselves to the doctor
    case ENTER_DOCTOR_CODE //When the user enters an alphanumeric code of the doctor in order to link themselves to the doctor
    case LOGIN_PASSWORD_ATEMPT // User Enter Screen
    case LOGIN_OTP_SUCCESS // On User Verify OTP(In case Login Flow) **
    case NEW_USER_ACCESS_CODE_VERIFY // On User verifies access code
    case NEW_USER_EMAIL_VERIFICATION // On user verifies email address // from backend
    case NEW_USER_QRCODE_VERIFIED // On new user scans QR code
    case NEW_USER_DOCTOR_LINK_VERIFIED // On new user scans QR code
    case LOGIN_ATTEMPT // User Enter Screen **
    case LOGIN_SMS_SENT // Click on Next button with Successful Validation **
    case LOGIN_PASSWORD_ATTEMPT // User Enter Screen **
    case LOGIN_PASSWORD_SUCCESS // Click on Next button with Successful Validation **
    case FORGOT_PASSWORD_ATTEMPT // User Enter Screen **
    case PASSWORD_CHANGE // Click on Next button with Successful Validation **
    case NEW_USER_WATCHED_TUTORIAL // User watches coach mark
    case NEW_USER_TUTORUAL_SKIP // User Skip Coach mark
    case NEW_USER_MEDICINE_ADDED // Medicine entered
    
    case NEW_USER_GOALS_READINGS // Goals and readings added **
    case NEW_USER_READING // Readings added
    
    case USER_CLICKED_PROFILE_COMPLETION // Clicked on profile completion **
    case USER_CLICKED_ON_EMAIL_VERIFICATION // Clicked on email verified // from backend
    case USER_CHANGED_GOALS_READINGS // Goals and readings changed **
    case USER_CHANGED_MARKER // Markers changed
    case USER_SELECTED_STATE // User selects state **
    case USER_SELECTED_CITY // User select city **
    case USER_UPDATED_READING // For reading **
    case USER_UPDATED_ACTIVITY // For goal **
    case USER_CLICKED_ON_HOME // **
    case USER_CLICKED_ON_CAREPLANPAGE_GOAL // User clicked on history of goals
    case USER_CHANGED_TIME_DURATION // User changed time duration for chart time
    case USER_TAP_ON_CAREPLAN_READING // **
    case USER_LIKED_CONTENT// **
    case USER_UNLIKED_CONTENT// **
    case USER_BOOKMARKED_CONTENT//**
    case USER_UN_BOOKMARK_CONTENT// **
    case USER_COMMENTED// **
    case USER_REPORTED_COMMENT// **
    case USER_UN_REPORTED_COMMENT//**
    case READING_CAPTURED_APPLE_HEALTH//**
    case USER_CLICKED_ON_REPORT_INCIDENT//**
    case USER_MARKS_MEDICINE // User mark any medicine **
    case USER_CLICKED_DETAIL_INCIDENT_PAGE // User clicked on details **
    case USER_PLAY_MEDIA_CONTENT // **
    case USER_CLICKED_ON_CARD // **
    case USER_VIEW_CONTENT // **
    case USER_DELETED_OWN_COMMENT // **
    case USER_VIEW_QUESTION // **
    case USER_VIEW_ANSWER // **
    case USER_PLAY_VIDEO_EXERCISE//**
    
    case USER_SENT_QUERY // **
    case USER_CLICKED_ON_RECORD //**
    case USER_MARKED_VIDEO_DONE_EXERCISE //**
    case USER_STARTED_QUIZ //**
    case USER_CLICKED_ON_REFERENCE_UTENSILS //**
    case USER_SEARCHED_FOOD_DISH // **
    case USER_VIEWED_DAILY_INSIGHT // **
    case USER_CLICKED_ON_INSIGHT // **
    case USER_RECORDS_UPDATED // **
    
    case USER_PLAYED_GIF_IN_EXERCISE // **
    case USER_CLICKED_ON_PLAN_EXERCISE // **
    case USER_CLICKED_ON_DIET_PLAN_CARD //**
    case DIET_PLAN_DOWNLOAD //**
    case USER_PLAY_VIDEO // **
    case USER_CLICKED_ON_MARK_ALL_AS_DONE //**
    case USER_SELECTED_FOOD_DISH //**
    case USER_ADDED_QUANTITY //**
    case USER_LOGGED_MEAL //**
    case USER_CLICKED_ON_EDIT_MEAL //**
    case USER_CLICKED_ON_MONTHLY_INSIGHT //**
    
    case USER_SCROLL_DEPTH_HOME // **
    case USER_SCROLL_DEPTH_CARE_PLAN //**
    
    case USER_LOGGOAL_MEDICINE_CONTENTVIEW //**
    case APPLE_HEALTH_OPTIN_ATTEMPT //**
    case USER_DURATION_OF_VIDEO //**
    case GOAL_TARGET_VALUE_UPDATED//**
    case GOAL_COMPLETED//**
    
    //User sessions
    case USER_SESSION_START//**
    case USER_SESSION_END//**
    case NEW_APP_LAUNCHED//**
    
    ///Time spent evetns
    case USER_TIME_SPENT_HOME //**
    case USER_TIME_SPENT_CARE_PLAN //**
    case USER_TIME_SPENT_ENGAGE //**
    case USER_TIME_SPENT_ASK_EXPERT //**
    case USER_TIME_SPENT_EXERCISE //not in use
    case USER_TIME_SPENT_CONTENT //**
    case TIME_SPENT_MY_ROUTINE //**
    case TIME_SPENT_EXPLORE //**
    case TIME_SPENT_PLAN_DETAIL //**
    case TIME_SPENT_PLAN_DETAIL_EXC //**
    case TIME_SPENT_PLAN_DETAIL_BREATH //**
    case TIME_SPENT_FOOD_LOG //**
    case TIME_SPENT_FOOD_DIARY_DAY //**
    case TIME_SPENT_FOOD_DIARY_MONTH //**
    case TIME_SPENT_FOOD_INSIGHT //**
    case TIME_SPENT_UPDATE_PRESCRIPTION //**
    case TIME_SPENT_SUPPORT //**
    case TIME_SPENT_BREATHING_TIME//**
    case TIME_SPENT_INCIDENT_HISTORY//**
    case TIME_SPENT_RECORD_HISTORY//**
    case TIME_SPENT_OPTION_MENU//**
    case TIME_SPENT_ACCOUNT_SETTING//**
    case TIME_SPENT_SET_GOALS//**
    case TIME_SPENT_ADD_GOALS//**
    case TIME_SPENT_ADD_READINGS//**
    case TIME_SPENT_MY_DEVICES//**
    case TIME_SPENT_UPDATE_LOCATION//**
    case TIME_SPENT_UPDATE_HEIGHT_WEIGHT//**
    case USER_CLICKED_READING_INFO//**
    
    case USER_ENABLED_NOTIFICATION//**
    case USER_DISABLED_NOTIFICATION//**
    case USER_COMPLETED_COACH_MARKS//**
    case USER_CHAT_SUPPORT //**
    case USER_CHAT_WITH_HC //**
    

    case USER_CLICKED_REMINDER_NOTIFICATION//**
    case SIGNUP_OTP_SENT_SUCCESS//**
    case USER_CLICKED_ON_STAY_INFORMED//**
    case USER_CLICKED_ON_RECOMMENDED//**
    
    case USER_POST_QUESTION//**
    case USER_SUBMIT_ANSWER//**
    case USER_UPDATE_ANSWER//**
    case USER_LIKED_ANSWER//**
    case USER_UNLIKED_ANSWER//**
    case USER_LIKED_COMMENT//**
    case USER_UNLIKED_COMMENT//**
    case USER_BOOKMARKED_QUESTION//**
    case USER_UN_BOOKMARK_QUESTION//**
    case HEIGHT_WEIGHT_ADDED//**
    
    case LOGIN_OTP_INCORRECT//**
    case LOGIN_PASSWORD_INCORRECT//**
    case USER_SKIP_PROFILE//**
    case USER_CONTINUE_PROFILE//**
    
    case USER_SELECT_GOAL//**
    case USER_SELECT_READING//**
    
//    case USER_REPORTED_QUESTION// **
//    case USER_UN_REPORTED_QUESTION//**
    
//    case USER_REPORTED_COMMENT// **
//    case USER_UN_REPORTED_COMMENT//**

//    case USER_CLICKED_ON_6MINUTE_WALK_TEST
    
    //For lab test
    case HOME_LABTEST_CARD_CLICKED//**
    case CAREPLAN_LABTEST_CARD_CLICKED//**
    case USER_OPEN_POPULAR_LABTESTS//**
    case CALL_US_TO_BOOK_TEST_CLICKED//**
    case TEST_ADDED_TO_CART//**
    case TEST_REMOVED_FROM_CART//**
    case USER_VIEWED_CART//**
    case LABTEST_PATIENT_ADDED//**
    case LABTEST_PATIENT_SELECTED//**
    case LABTEST_ADDRESS_ADDED//**
    case LABTEST_ADDRESS_UPDATED//**
    case LABTEST_ADDRESS_DELETED//**
    case LABTEST_ADDRESS_SELECTED//**
    case LABTEST_APPOINTMENT_TIME_SELECTED//**
    case USER_OPEN_LABTEST_ORDER_REVIEW//**
    case LABTEST_ORDER_PAYMENT_SUCCESS//**
    case LABTEST_ORDER_BOOK_SUCCESS//**
    case LABTEST_HISTORY_CARD_CLICKED//**
    case USER_VIEWED_LABTEST_ORDER_DETAILS//**
    
    //For appointment module
    case CAREPLAN_APPOINTMENT_VIEW_ALL//**
    case CAREPLAN_APPOINTMENT_REQ_CANCEL//**
    case CAREPLAN_APPOINTMENT_JOIN_VIDEO//**
    case APPOINTMENT_HISTORY_DOCTOR//**
    case APPOINTMENT_HISTORY_COACH//**
    case APPOINTMENT_HISTORY_REQ_CANCEL//**
    case APPOINTMENT_HISTORY_JOIN_VIDEO//**
    case USER_CLICK_BOOK_APPOINTMENT//**
    case USER_CONFIRM_BOOK_APPOINTMENT//**
    case BOOK_APPOINTMENT_SUCCESSFUL//**
    
    case USER_CLICKED_ON_SUBSCRIPTION_PAGE//**
    case USER_CLICKED_ON_SUBSCRIPTION_DURATION//**
    case USER_CLICKED_ON_SUBSCRIPTION_BUY//**
    case SUBSCRIPTION_PLAN_PAYMENT_SUCCESSFUL//**
    
    case USER_CLICKED_ON_MENU//**
    case MENU_NAVIGATION//**
    case ACCOUNT_SETTING_NAVIGATION//**
    case PROFILE_NAVIGATION//**
    
    case USER_CLICKS_ON_CONNECT//** When the user clicks on Connect button
    case MEDICAL_DEVICE_AVAILABILITY//** When the user selects either ‘I have a device’ or ‘I have to purchase one’
    case USER_TAPS_ON_LEARN_TO_CONNECT//** When the user clicks on ‘Learn how to connect’
    case USER_TOGGLES_BLUETOOTH//** When the user toggles the Bluetooth toggle button
    case MEDICAL_DEVICE_SEARCH_ACTION// When the user clicks on either ‘Search Device’ or ‘Search again’ to find a medical device in the vicinity
    case USER_SELECTS_MEDICAL_DEVICE// When the user selects a device after searching for it
    case USER_CLICKS_MEASURE// When the user clicks on ‘Measure’
    case HEALTH_MARKERS_POPULATED// When the health markers get populated on the app
    case USER_DOWNLOADS_REPORT// When the user downloads the PDF report
    case USER_CLICKED_ON_DEVICE_READINGS//When the user clicks on any health marker populated after retrieving it from the medical device
    case USER_CHANGES_DATE_RANGE// When the user clicks on dropdown to change the number of days (7 Days, 15 Days, 30 Days, 90 Days, 1 Year)
    
    case PRE_ONBOARDING_CAROUSEL// When carousel is changing **
    case CLOSE_BOTTOM_SHEET//**
    
    //BCP Events
    case USER_TAPS_ON_CARE_PLAN_CARD //User taps on Care plan card
    case HOME_CARE_PLAN_CARD_CLICKED //When user taps on the tile of Care Plan on the home page
    case TAP_RENT_BUY //When user taps on Rent/Buy option for a duration
    case SHOW_BOTTOM_SHEET //When the bottom sheet appears
    
    case ADD_ADDRESS //When user tap on "Add Address" on the bottom sheet of addresses
    case SELECT_ADDRESS //user taps on existing address
    case TAP_ADD_NEW //When user tap on "Add New" action on the bottom sheet of address list
    case TAP_SAVE_AND_NEXT //When the user tap on the Save and Next button
    case TAP_PROCEED_TO_PAYMENT //user taps on CTA Proceed to payment
    case TAP_CONTACT_US //When user tap on "Contact Us" CTA
    case TAP_LABTEST_CARD //When user tap on "Lab Test card" from the paid care plan detail page
    case ADD_TEST //When user tap on "Add Test" from the Review Order Test page
    case SELECT_DATE_TIME //When user tap on "Select Date & Time: CTA from the Lab test order review page
    case TAP_BOOK_LAB_TEST //When user tap on the "Book" button on the Order review page of Lab Test
    case TAP_HEALTH_COACH_CARD //When user tap on the "HCs" tile from the paid care plan detail page
    case TAP_DEVICE_CARD //When user tap on the "Device" tile from the paid care plan detail page
    case USER_CHANGES_DATE //When user changes the date 
    
    //Revamped Exercise Plan
    case USER_TAPS_ON_BOTTOM_NAV
    case USER_TAPS_ON_ROUTINE
    case USER_SUBMIT_FEEDBACK
    case USER_TAPS_ON_READ_MORE
    case USER_GOES_BACK
    
    
    var rawString : String {
        
        switch self {
            
        case .NEW_USER_LANGUAGE_SELECTION:
            return "NEW_USER_LANGUAGE_SELECTION"
        case .NEW_USER_SIGNUP_ATTEMPT:
            return "NEW_USER_SIGNUP_ATTEMPT"
        case .NEW_USER_MOBILE_CAPTURE:
            return "NEW_USER_MOBILE_CAPTURE"
        case .NEW_USER_OTP_VERIFY:
            return "NEW_USER_OTP_VERIFY"
        case .LOGIN_OTP_SUCCESS:
            return "LOGIN_OTP_SUCCESS"
        case .NEW_USER_ACCESS_CODE_VERIFY:
            return "NEW_USER_ACCESS_CODE_VERIFY"
        case .NEW_USER_EMAIL_VERIFICATION:
            return "NEW_USER_EMAIL_VERIFICATION"
        case .NEW_USER_QRCODE_VERIFIED:
            return "NEW_USER_QRCODE_VERIFIED"
        case .NEW_USER_DOCTOR_LINK_VERIFIED:
            return "NEW_USER_DOCTOR_LINK_VERIFIED"
        case .LOGIN_ATTEMPT:
            return "LOGIN_ATTEMPT"
        case .LOGIN_SMS_SENT:
            return "LOGIN_SMS_SENT"
        case .LOGIN_PASSWORD_ATTEMPT:
            return "LOGIN_PASSWORD_ATTEMPT"
        case .LOGIN_PASSWORD_SUCCESS:
            return "LOGIN_PASSWORD_SUCCESS"
        case .FORGOT_PASSWORD_ATTEMPT:
            return "FORGOT_PASSWORD_ATTEMPT"
        case .PASSWORD_CHANGE:
            return "PASSWORD_CHANGE"
        case .NEW_USER_WATCHED_TUTORIAL:
            return "NEW_USER_WATCHED_TUTORIAL"
        case .NEW_USER_TUTORUAL_SKIP:
            return "NEW_USER_TUTORUAL_SKIP"
        case .NEW_USER_MEDICINE_ADDED:
            return "NEW_USER_MEDICINE_ADDED"
        case .NEW_USER_GOALS_READINGS:
            return "NEW_USER_GOALS"
        case .NEW_USER_READING:
            return "NEW_USER_READING"
        case .USER_CLICKED_PROFILE_COMPLETION:
            return "USER_CLICKED_PROFILE_COMPLETION"
        case .USER_CLICKED_ON_EMAIL_VERIFICATION:
            return "USER_CLICKED_ON_EMAIL_VERIFICATION"
        case .USER_CHANGED_GOALS_READINGS:
            return "USER_CHANGED_GOAL"
        case .USER_CHANGED_MARKER:
            return "USER_CHANGED_MARKER"
        case .USER_SELECTED_STATE:
            return "USER_SELECTED_STATE"
        case .USER_SELECTED_CITY:
            return "USER_SELECTED_CITY"
        case .USER_UPDATED_READING:
            return "USER_UPDATED_READING"
        case .USER_UPDATED_ACTIVITY:
            return "USER_UPDATED_ACTIVITY"
        case .USER_CLICKED_ON_CAREPLANPAGE_GOAL:
            return "USER_CLICKED_ON_CAREPLANPAGE_GOAL"
        case .USER_CHANGED_TIME_DURATION:
            return "USER_CHANGED_TIME_DURATION"
        case .USER_CLICKED_ON_HOME:
            return "USER_CLICKED_ON_HOME"
        case .USER_TAP_ON_CAREPLAN_READING:
            return "USER_TAP_ON_CAREPLAN_READING"
        case .USER_LIKED_CONTENT:
            return "USER_LIKED_CONTENT"
        case .USER_UNLIKED_CONTENT:
            return "USER_UNLIKED_CONTENT"
        case .USER_BOOKMARKED_CONTENT:
            return "USER_BOOKMARKED_CONTENT"
        case .USER_UN_BOOKMARK_CONTENT:
            return "USER_UN_BOOKMARK_CONTENT"
        case .USER_COMMENTED:
            return "USER_COMMENTED"
        case .USER_REPORTED_COMMENT:
            return "USER_REPORTED_COMMENT"
        case .USER_UN_REPORTED_COMMENT:
            return "USER_UN_REPORTED_COMMENT"
        case .READING_CAPTURED_APPLE_HEALTH:
            return "READING_CAPTURED_APPLE_HEALTH"
        case .USER_CLICKED_ON_REPORT_INCIDENT:
            return "USER_CLICKED_ON_REPORT_INCIDENT"
        case .LOGIN_PASSWORD_ATEMPT:
            return "LOGIN_PASSWORD_ATEMPT"
        case .USER_MARKS_MEDICINE:
            return "USER_MARKS_MEDICINE"
        case .USER_CLICKED_DETAIL_INCIDENT_PAGE:
            return "USER_CLICKED_DETAIL_INCIDENT_PAGE"
        case .USER_PLAY_MEDIA_CONTENT:
            return "USER_PLAY_MEDIA_CONTENT"
        case .USER_CLICKED_ON_CARD:
            return "USER_CLICKED_ON_CARD"
        case .USER_VIEW_CONTENT:
            return "USER_VIEW_CONTENT"
        case .USER_DELETED_OWN_COMMENT:
            return "USER_DELETED_OWN_COMMENT"
        case .USER_SENT_QUERY:
            return "USER_SENT_QUERY"
        case .USER_CLICKED_ON_RECORD:
            return "USER_CLICKED_ON_RECORD"
        case .USER_MARKED_VIDEO_DONE_EXERCISE:
            return "USER_MARKED_VIDEO_DONE_EXERCISE"
        case .USER_STARTED_QUIZ:
            return "USER_STARTED_QUIZ"
        case .USER_CLICKED_ON_REFERENCE_UTENSILS:
            return "USER_CLICKED_ON_REFERENCE_UTENSILS"
        case .USER_SEARCHED_FOOD_DISH:
            return "USER_SEARCHED_FOOD_DISH"
        case .USER_VIEWED_DAILY_INSIGHT:
            return "USER_VIEWED_DAILY_INSIGHT"
        case .USER_CLICKED_ON_INSIGHT:
            return "USER_CLICKED_ON_INSIGHT"
        case .USER_RECORDS_UPDATED:
            return "USER_UPLOADED_RECORD"
        case .USER_PLAYED_GIF_IN_EXERCISE:
            return "USER_PLAYED_GIF_IN_EXERCISE"
        case .USER_CLICKED_ON_PLAN_EXERCISE:
            return "USER_CLICKED_ON_PLAN_EXERCISE"
        case .USER_CLICKED_ON_DIET_PLAN_CARD:
            return "USER_CLICKED_ON_DIET_PLAN_CARD"
        case .DIET_PLAN_DOWNLOAD:
            return "DIET_PLAN_DOWNLOAD"
        case .USER_PLAY_VIDEO:
            return "USER_PLAY_VIDEO"
        case .USER_CLICKED_ON_MARK_ALL_AS_DONE:
            return "USER_CLICKED_ON_MARK_ALL_AS_DONE"
        case .USER_SELECTED_FOOD_DISH:
            return "USER_SELECTED_FOOD_DISH"
        case .USER_ADDED_QUANTITY:
            return "USER_ADDED_QUANTITY"
        case .USER_LOGGED_MEAL:
            return "USER_LOGGED_MEAL"
        case .USER_CLICKED_ON_EDIT_MEAL:
            return "USER_CLICKED_ON_EDIT_MEAL"
        case .USER_CLICKED_ON_MONTHLY_INSIGHT:
            return "USER_CLICKED_ON_MONTHLY_INSIGHT"
        case .USER_TIME_SPENT_HOME:
            return "USER_TIME_SPENT_HOME"
        case .USER_TIME_SPENT_CARE_PLAN:
            return "USER_TIME_SPENT_CARE_PLAN"
        case .USER_TIME_SPENT_ENGAGE:
            return "USER_TIME_SPENT_ENGAGE"
        case .USER_TIME_SPENT_EXERCISE:
            return "USER_TIME_SPENT_EXERCISE"
        case .USER_SCROLL_DEPTH_HOME:
            return "USER_SCROLL_DEPTH_HOME"
        case .USER_SCROLL_DEPTH_CARE_PLAN:
            return "USER_SCROLL_DEPTH_CARE_PLAN"
        case .USER_TIME_SPENT_CONTENT:
            return "USER_TIME_SPENT_CONTENT"
        case .USER_SIGNUP_COMPLETE:
            return "USER_SIGNUP_COMPLETE"
        case .USER_PROFILE_COMPLETED:
            return "USER_PROFILE_COMPLETED"
        case .USER_PROFILE_VIEW:
            return "USER_PROFILE_VIEW"
        case .USER_LOGGOAL_MEDICINE_CONTENTVIEW:
            return "USER_LOGGOAL_MEDICINE_CONTENTVIEW"
        case .APPLE_HEALTH_OPTIN_ATTEMPT:
            return "APPLE_HEALTH_OPTIN_ATTEMPT"
        case .USER_DURATION_OF_VIDEO:
            return "USER_DURATION_OF_VIDEO"
        case .GOAL_TARGET_VALUE_UPDATED:
            return "GOAL_TARGET_VALUE_UPDATED"
        case .GOAL_COMPLETED:
            return "GOAL_COMPLETED"
        case .USER_SESSION_START:
            return "USER_SESSION_START"
        case .USER_SESSION_END:
            return "USER_SESSION_END"
        case .NEW_APP_LAUNCHED:
            return "NEW_APP_LAUNCHED"
        case .TIME_SPENT_MY_ROUTINE:
            return "TIME_SPENT_MY_ROUTINE"
        case .TIME_SPENT_EXPLORE:
            return "TIME_SPENT_EXPLORE"
        case .TIME_SPENT_PLAN_DETAIL:
            return "TIME_SPENT_PLAN_DETAIL"
        case .TIME_SPENT_PLAN_DETAIL_EXC:
            return "TIME_SPENT_PLAN_DETAIL_EXC"
        case .TIME_SPENT_PLAN_DETAIL_BREATH:
            return "TIME_SPENT_PLAN_DETAIL_BREATH"
        case .TIME_SPENT_FOOD_LOG:
            return "TIME_SPENT_FOOD_LOG"
        case .TIME_SPENT_FOOD_DIARY_DAY:
            return "TIME_SPENT_FOOD_DIARY_DAY"
        case .TIME_SPENT_FOOD_DIARY_MONTH:
            return "TIME_SPENT_FOOD_DIARY_MONTH"
        case .TIME_SPENT_FOOD_INSIGHT:
            return "TIME_SPENT_FOOD_INSIGHT"
        case .TIME_SPENT_UPDATE_PRESCRIPTION:
            return "TIME_SPENT_UPDATE_PRESCRIPTION"
        case .TIME_SPENT_SUPPORT:
            return "TIME_SPENT_SUPPORT"
        case .TIME_SPENT_BREATHING_TIME:
            return "TIME_SPENT_BREATHING_TIME"
        case .TIME_SPENT_INCIDENT_HISTORY:
            return "TIME_SPENT_INCIDENT_HISTORY"
        case .TIME_SPENT_RECORD_HISTORY:
            return "TIME_SPENT_RECORD_HISTORY"
        case .TIME_SPENT_OPTION_MENU:
            return "TIME_SPENT_OPTION_MENU"
        case .TIME_SPENT_ACCOUNT_SETTING:
            return "TIME_SPENT_ACCOUNT_SETTING"
        case .TIME_SPENT_SET_GOALS:
            return "TIME_SPENT_SET_GOALS"
        case .TIME_SPENT_ADD_GOALS:
            return "TIME_SPENT_ADD_GOALS"
        case .TIME_SPENT_ADD_READINGS:
            return "TIME_SPENT_ADD_READINGS"
        case .TIME_SPENT_MY_DEVICES:
            return "TIME_SPENT_MY_DEVICES"
        case .TIME_SPENT_UPDATE_LOCATION:
            return "TIME_SPENT_UPDATE_LOCATION"
        case .TIME_SPENT_UPDATE_HEIGHT_WEIGHT:
            return "TIME_SPENT_UPDATE_HEIGHT_WEIGHT"
        case .USER_CLICKED_READING_INFO:
            return "USER_CLICKED_READING_INFO"
        case .USER_ENABLED_NOTIFICATION:
            return "USER_ENABLED_NOTIFICATION"
        case .USER_DISABLED_NOTIFICATION:
            return "USER_DISABLED_NOTIFICATION"
        case .USER_COMPLETED_COACH_MARKS:
            return "USER_COMPLETED_COACH_MARKS"
        case .USER_CHAT_SUPPORT:
            return "USER_CHAT_SUPPORT"
        case .USER_CHAT_WITH_HC:
            return "USER_CHAT_WITH_HC"
            
        case .USER_CLICKED_REMINDER_NOTIFICATION:
            return "USER_CLICKED_REMINDER_NOTIFICATION"
        case .SIGNUP_OTP_SENT_SUCCESS:
            return "SIGNUP_OTP_SENT_SUCCESS"
        case .USER_CLICKED_ON_STAY_INFORMED:
            return "USER_CLICKED_ON_STAY_INFORMED"
        case .USER_CLICKED_ON_RECOMMENDED:
            return "USER_CLICKED_ON_RECOMMENDED"
        case .USER_TIME_SPENT_ASK_EXPERT:
            return "USER_TIME_SPENT_ASK_EXPERT"
        case .USER_VIEW_QUESTION:
            return "USER_VIEW_QUESTION"
        case .USER_VIEW_ANSWER:
            return "USER_VIEW_ANSWER"
        case .USER_PLAY_VIDEO_EXERCISE:
            return "USER_PLAY_VIDEO_EXERCISE"
        case .USER_POST_QUESTION:
            return "USER_POST_QUESTION"
        case .USER_SUBMIT_ANSWER:
            return "USER_SUBMIT_ANSWER"
        case .USER_UPDATE_ANSWER:
            return "USER_UPDATE_ANSWER"
        case .USER_LIKED_ANSWER:
            return "USER_LIKED_ANSWER"
        case .USER_UNLIKED_ANSWER:
            return "USER_UNLIKED_ANSWER"
        case .USER_LIKED_COMMENT:
            return "USER_LIKED_COMMENT"
        case .USER_UNLIKED_COMMENT:
            return "USER_UNLIKED_COMMENT"
        case .USER_BOOKMARKED_QUESTION:
            return "USER_BOOKMARKED_QUESTION"
        case .USER_UN_BOOKMARK_QUESTION:
            return "USER_UN_BOOKMARK_QUESTION"
        case .HEIGHT_WEIGHT_ADDED:
            return "HEIGHT_WEIGHT_ADDED"
        case .LOGIN_OTP_INCORRECT:
            return "LOGIN_OTP_INCORRECT"
        case .LOGIN_PASSWORD_INCORRECT:
            return "LOGIN_PASSWORD_INCORRECT"
        case .USER_SKIP_PROFILE:
            return "USER_SKIP_PROFILE"
        case .USER_CONTINUE_PROFILE:
            return "USER_CONTINUE_PROFILE"
        case .USER_SELECT_GOAL:
            return "USER_SELECT_GOAL"
        case .USER_SELECT_READING:
            return "USER_SELECT_READING"
            
        case .HOME_LABTEST_CARD_CLICKED:
            return "HOME_LABTEST_CARD_CLICKED"
        case .CAREPLAN_LABTEST_CARD_CLICKED:
            return "CAREPLAN_LABTEST_CARD_CLICKED"
        case .USER_OPEN_POPULAR_LABTESTS:
            return "USER_OPEN_POPULAR_LABTESTS"
        case .CALL_US_TO_BOOK_TEST_CLICKED:
            return "CALL_US_TO_BOOK_TEST_CLICKED"
        case .TEST_ADDED_TO_CART:
            return "TEST_ADDED_TO_CART"
        case .TEST_REMOVED_FROM_CART:
            return "TEST_REMOVED_FROM_CART"
        case .USER_VIEWED_CART:
            return "USER_VIEWED_CART"
        case .LABTEST_PATIENT_ADDED:
            return "LABTEST_PATIENT_ADDED"
        case .LABTEST_PATIENT_SELECTED:
            return "LABTEST_PATIENT_SELECTED"
        case .LABTEST_ADDRESS_ADDED:
            return "LABTEST_ADDRESS_ADDED"
        case .LABTEST_ADDRESS_UPDATED:
            return "LABTEST_ADDRESS_UPDATED"
        case .LABTEST_ADDRESS_DELETED:
            return "LABTEST_ADDRESS_DELETED"
        case .LABTEST_ADDRESS_SELECTED:
            return "LABTEST_ADDRESS_SELECTED"
        case .LABTEST_APPOINTMENT_TIME_SELECTED:
            return "LABTEST_APPOINTMENT_TIME_SELECTED"
        case .USER_OPEN_LABTEST_ORDER_REVIEW:
            return "USER_OPEN_LABTEST_ORDER_REVIEW"
        case .LABTEST_ORDER_PAYMENT_SUCCESS:
            return "LABTEST_ORDER_PAYMENT_SUCCESS"
        case .LABTEST_ORDER_BOOK_SUCCESS:
            return "LABTEST_ORDER_BOOK_SUCCESS"
        case .LABTEST_HISTORY_CARD_CLICKED:
            return "LABTEST_HISTORY_CARD_CLICKED"
        case .USER_VIEWED_LABTEST_ORDER_DETAILS:
            return "USER_VIEWED_LABTEST_ORDER_DETAILS"
            
        case .CAREPLAN_APPOINTMENT_VIEW_ALL:
            return "CAREPLAN_APPOINTMENT_VIEW_ALL"
        case .CAREPLAN_APPOINTMENT_REQ_CANCEL:
            return "CAREPLAN_APPOINTMENT_REQ_CANCEL"
        case .CAREPLAN_APPOINTMENT_JOIN_VIDEO:
            return "CAREPLAN_APPOINTMENT_JOIN_VIDEO"
        case .APPOINTMENT_HISTORY_DOCTOR:
            return "APPOINTMENT_HISTORY_DOCTOR"
        case .APPOINTMENT_HISTORY_COACH:
            return "APPOINTMENT_HISTORY_COACH"
        case .APPOINTMENT_HISTORY_REQ_CANCEL:
            return "APPOINTMENT_HISTORY_REQ_CANCEL"
        case .APPOINTMENT_HISTORY_JOIN_VIDEO:
            return "APPOINTMENT_HISTORY_JOIN_VIDEO"
        case .USER_CLICK_BOOK_APPOINTMENT:
            return "USER_CLICK_BOOK_APPOINTMENT"
        case .USER_CONFIRM_BOOK_APPOINTMENT:
            return "USER_CONFIRM_BOOK_APPOINTMENT"
        case .BOOK_APPOINTMENT_SUCCESSFUL:
            return "BOOK_APPOINTMENT_SUCCESSFUL"
            
        case .USER_CLICKED_ON_SUBSCRIPTION_PAGE:
            return "USER_CLICKED_ON_SUBSCRIPTION_PAGE"
        case .USER_CLICKED_ON_SUBSCRIPTION_DURATION:
            return "USER_CLICKED_ON_SUBSCRIPTION_DURATION"
        case .USER_CLICKED_ON_SUBSCRIPTION_BUY:
            return "USER_CLICKED_ON_SUBSCRIPTION_BUY"
        case .SUBSCRIPTION_PLAN_PAYMENT_SUCCESSFUL:
            return "SUBSCRIPTION_PLAN_PAYMENT_SUCCESSFUL"
        case .USER_CLICKED_ON_MENU:
            return "USER_CLICKED_ON_MENU"
        case .MENU_NAVIGATION:
            return "MENU_NAVIGATION"
        case .ACCOUNT_SETTING_NAVIGATION:
            return "ACCOUNT_SETTING_NAVIGATION"
        case .PROFILE_NAVIGATION:
            return "PROFILE_NAVIGATION"
        case .NEW_USER_SIGNED_AS_MYSELF:
            return "NEW_USER_SIGNED_AS_MYSELF"
        case .NEW_USER_SIGNED_AS_SOMEONE_ELSE:
            return "NEW_USER_SIGNED_AS_SOMEONE_ELSE"
        case .SCAN_DOCTOR_QR:
            return "SCAN_DOCTOR_QR"
        case .ENTER_DOCTOR_CODE:
            return "ENTER_DOCTOR_CODE"
        case .USER_CLICKS_ON_CONNECT:
            return "USER_CLICKS_ON_CONNECT"
        case .MEDICAL_DEVICE_AVAILABILITY:
            return "MEDICAL_DEVICE_AVAILABILITY"
        case .USER_TAPS_ON_LEARN_TO_CONNECT:
            return "USER_TAPS_ON_LEARN_TO_CONNECT"
        case .USER_TOGGLES_BLUETOOTH:
            return "USER_TOGGLES_BLUETOOTH"
        case .MEDICAL_DEVICE_SEARCH_ACTION:
            return "MEDICAL_DEVICE_SEARCH_ACTION"
        case .USER_SELECTS_MEDICAL_DEVICE:
            return "USER_SELECTS_MEDICAL_DEVICE"
        case .USER_CLICKS_MEASURE:
            return "USER_CLICKS_MEASURE"
        case .USER_DOWNLOADS_REPORT:
            return "USER_DOWNLOADS_REPORT"
        case .USER_CHANGES_DATE_RANGE:
            return "USER_CHANGES_DATE_RANGE"
        case .HEALTH_MARKERS_POPULATED:
            return "HEALTH_MARKERS_POPULATED"
        case .USER_CLICKED_ON_DEVICE_READINGS:
            return "USER_CLICKED_ON_DEVICE_READINGS"
            
        case .PRE_ONBOARDING_CAROUSEL:
            return "PRE_ONBOARDING_CAROUSEL"
        case .CLOSE_BOTTOM_SHEET:
            return "CLOSE_BOTTOM_SHEET"
        
        case .USER_TAPS_ON_CARE_PLAN_CARD:
            return "USER_TAPS_ON_CARE_PLAN_CARD"
        case .HOME_CARE_PLAN_CARD_CLICKED:
            return "HOME_CARE_PLAN_CARD_CLICKED"
        case .TAP_RENT_BUY:
            return "TAP_RENT_BUY"
        case .SHOW_BOTTOM_SHEET:
            return "SHOW_BOTTOM_SHEET"
        case .ADD_ADDRESS:
            return "ADD_ADDRESS"
        case .SELECT_ADDRESS:
            return "SELECT_ADDRESS"
        case .TAP_ADD_NEW:
            return "TAP_ADD_NEW"
        case .TAP_SAVE_AND_NEXT:
            return "TAP_SAVE_AND_NEXT"
        case .TAP_PROCEED_TO_PAYMENT:
            return "TAP_PROCEED_TO_PAYMENT"
        case .TAP_CONTACT_US:
            return "TAP_CONTACT_US"
        case .TAP_LABTEST_CARD:
            return "TAP_LABTEST_CARD"
        case .ADD_TEST:
            return "ADD_TEST"
        case .SELECT_DATE_TIME:
            return "SELECT_DATE_TIME"
        case .TAP_BOOK_LAB_TEST:
            return "TAP_BOOK_LAB_TEST"
        case .TAP_HEALTH_COACH_CARD:
            return "TAP_HEALTH_COACH_CARD"
        case .TAP_DEVICE_CARD:
            return "TAP_DEVICE_CARD"
            
        case .USER_TAPS_ON_BOTTOM_NAV:
            return "USER_TAPS_ON_BOTTOM_NAV"
        case .USER_TAPS_ON_ROUTINE:
            return "USER_TAPS_ON_ROUTINE"
        case .USER_SUBMIT_FEEDBACK:
            return "USER_SUBMIT_FEEDBACK"
        case .USER_CHANGES_DATE:
            return "USER_CHANGES_DATE"
        case .USER_TAPS_ON_READ_MORE:
            return "USER_TAPS_ON_READ_MORE"
        case .USER_GOES_BACK:
            return "USER_GOES_BACK"
        }
    }
}

public class FIRAnalytics : NSObject {

    static func FIRLoginEvent(parameter : [String : Any]?){
        
        debugPrint("analtics ==>" ,  AnalyticsEventLogin , " : " , parameter ?? "")
        
        Analytics.logEvent(AnalyticsEventLogin, parameters: parameter)
    }
    
    static func FIRLogEvent(eventName : FIREventType,
                            screen: ScreenName? = nil,
                            customScreenName:String? = nil,
                            parameter : [String : Any]?){
        
        var params = [String: Any]()
        params = parameter ?? [:]
        
        if let id = UserModel.shared.patientId, id.trim() != "" {
            params[AnalyticsParameters.patient_id.rawValue] = id
            
            params[AnalyticsParameters.patientGender.rawValue]          = UserModel.shared.gender
            if let arr = UserModel.shared.medicalConditionName, arr.count > 0 {
                params[AnalyticsParameters.patientIndication.rawValue]  = arr.first!.medicalConditionName
            }
            
            if let doc = UserModel.shared.patientLinkDoctorDetails, doc.count > 0 {
                params[AnalyticsParameters.doctorId.rawValue]               = doc[0].doctorId
                params[AnalyticsParameters.doctorSpecialization.rawValue]   = doc[0].specialization
            }
            
            if UserModel.shared.hcList != nil {
                let arr1: [String] = UserModel.shared.hcList.map { obj in
                    return obj.healthCoachId
                }
                params[AnalyticsParameters.healthCoachId.rawValue] = arr1.joined(separator: ",")
                
                let arr2: [String] = UserModel.shared.hcList.map { obj in
                    return obj.role
                }
                params[AnalyticsParameters.HealthCoachSpecialization.rawValue]  = arr2.joined(separator: ",")
            }
            
            params[AnalyticsParameters.city.rawValue]           = UserModel.shared.city
            params[AnalyticsParameters.emailVerified.rawValue]  = UserModel.shared.emailVerified
            
            /*if UserModel.shared.patientPlans != nil {
                for plan in UserModel.shared.patientPlans {
                    if plan.planType == kSubscription ||
                        plan.planType == KTrial ||
                        plan.planType == KFree {
                        params[AnalyticsParameters.current_plan_name.rawValue]   = plan.planName
                        params[AnalyticsParameters.current_plan_id.rawValue]    = plan.planMasterId
                        params[AnalyticsParameters.current_plan_type.rawValue]  = plan.planType
                    }
                }
            }*/
            
            if let hcServices = UserModel.shared.hcServicesLongestPlan {
                params[AnalyticsParameters.current_plan_name.rawValue]   = hcServices.planName
                params[AnalyticsParameters.current_plan_id.rawValue]    = hcServices.planMasterId
                params[AnalyticsParameters.current_plan_type.rawValue]  = hcServices.planType
            }
            
        }
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = DateTimeFormaterEnum.UTCFormat.rawValue
        dateFormatter.timeZone      = .current
        dateFormatter.locale        = NSLocale(localeIdentifier: "en_US") as Locale
        
        params[AnalyticsParameters.log_date.rawValue]               = dateFormatter.string(from: Date())
        params[AnalyticsParameters.device_type.rawValue]            = "iPhone"
        params[AnalyticsParameters.currentAppVersion.rawValue]      = Bundle.main.releaseVersionNumber
        params[AnalyticsParameters.OS_Version.rawValue]            = DeviceManager.shared.osVersion
        if let screenName = screen {
            params[AnalyticsParameters.ScreenName.rawValue]         = screenName
        } else if let customScreenName = customScreenName {
            params[AnalyticsParameters.ScreenName.rawValue]         = customScreenName
        }
        
        params[AnalyticsParameters.screenResolution.rawValue]       = "\(ScreenSize.physicalHeight)x\(ScreenSize.physicalWidth)"
        
        params = params.filter({ (obj) -> Bool in
            if obj.key == AnalyticsParameters.changed_from.rawValue || obj.key == AnalyticsParameters.changes_to.rawValue || obj.key == AnalyticsParameters.carousel_number.rawValue  {
                return true
            }
            if obj.value as? String != "" {
                return true
            }
            else {
                return false
            }
        })
        
        var converted:[String:Any] = params.compactMapValues { "\($0)"  }
        if converted[AnalyticsParameters.changed_from.rawValue] != nil {
            converted[AnalyticsParameters.changed_from.rawValue] = JSON(converted[AnalyticsParameters.changed_from.rawValue] as Any).intValue
        }
        
        if converted[AnalyticsParameters.changes_to.rawValue] != nil {
            converted[AnalyticsParameters.changes_to.rawValue] = JSON(converted[AnalyticsParameters.changes_to.rawValue] as Any).intValue
        }
        
        if converted[AnalyticsParameters.carousel_number.rawValue] != nil {
            converted[AnalyticsParameters.carousel_number.rawValue] = JSON(converted[AnalyticsParameters.carousel_number.rawValue] as Any).intValue
        }
        
        debugPrint("Analtics 😊😊😊😊😊😊😊😊",  eventName.rawString , " : " , JSON(converted))
        
        DispatchQueue.main.async {
            if converted.count > 0 {
                WebengageManager.shared.weAnalytics.trackEvent(withName: eventName.rawString, andValue: converted)
            }
            
            Analytics.logEvent(eventName.rawString, parameters: converted)
        }
    }
    
    static func FIRLogCustomEvent(eventName : FIREventType, postFix: String, parameter : [String : Any]?){
        
        DispatchQueue.main.async {
            debugPrint("Analtics ==>" ,  eventName.rawString + "_" + postFix.uppercased().trim(), " : " , parameter ?? "")
            
            Analytics.logEvent(eventName.rawString + "_" + postFix.uppercased().trim(), parameters: parameter)
            
            if parameter?.count > 0 {
                WebengageManager.shared.weAnalytics.trackEvent(withName: eventName.rawString, andValue: parameter)
            }
            else {
                WebengageManager.shared.weAnalytics.trackEvent(withName: eventName.rawString)
            }
        }
    }
}

enum ScreenStatus {
    case Appear
    case Disappear
}

extension FIRAnalytics {
    
    static func manageTimeSpent(on: ScreenName,
                                when: ScreenStatus,
                                content_master_id: String? = "",
                                content_type: String? = "") {
        switch when {
            
        case .Appear:
            kScreenTimeStart = Date()
            break
        case .Disappear:
            if let seconds = Calendar.current.dateComponents([.second], from: kScreenTimeStart, to: Date()).second  {
            
                var params              = [String: Any]()
                params[AnalyticsParameters.duration_second.rawValue]    = seconds
                params[AnalyticsParameters.content_master_id.rawValue]  = content_master_id
                params[AnalyticsParameters.content_type.rawValue]       = content_type
                
                switch on {
                    
                case .Home:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_HOME,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .CarePlan:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_CARE_PLAN,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .DiscoverEngage:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_ENGAGE,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .ExercisePlan:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_MY_ROUTINE,
                                             screen: on,
                                             parameter: params)
                    break
                case .ExerciseMore:
//                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_EXPLORE,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .ContentDetailPhotoGallery:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_CONTENT,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .ContentDetailNormalVideo:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_CONTENT,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .ContentDetailKolVideo:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_CONTENT,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .ContentDetailBlog:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_CONTENT,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .ContentDetailWebinar:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_CONTENT,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .ExercisePlanDetail:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_PLAN_DETAIL,
                                             screen: on,
                                             parameter: params)
                    break
                case .RequestCallBack:
                    break
                case .ExercisePlanDayDetail:
                    break
                case .FoodDiaryDay:
//                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_FOOD_DIARY_DAY,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .FoodDiaryMonth:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_FOOD_DIARY_MONTH,
                                             screen: on,
                                             parameter: params)
                    break
                case .FoodDiaryDayInsight:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_FOOD_INSIGHT,
                                             screen: on,
                                             parameter: params)
                    break
                case .LogFood:
//                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_FOOD_LOG,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .LogFoodSuccess:
                    break
                case .HelpSupportFaq:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_SUPPORT,
                                             screen: on,
                                             parameter: params)
                    break
                case .FaqQuery:
                    break
                case .NotificationList:
                    break
                case .HistoryIncident:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_INCIDENT_HISTORY,
                                             screen: on,
                                             parameter: params)
                    break
                case .IncidentDetails:
                    break
                case .HistoryRecord:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_RECORD_HISTORY,
                                             screen: on,
                                             parameter: params)
                    break
                case .UploadRecord:
                    break
                case .BreathingVideo:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_BREATHING_TIME,
                                             screen: on,
                                             parameter: params)
                    break
                case .CommentList:
                    break
                case .AddIncident:
                    break
                case .MyAccount:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_ACCOUNT_SETTING,
                                             screen: on,
                                             parameter: params)
                    break
                case .MyProfile:
                    break
                case .EditProfile:
                    break
                case .MyDevices:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_MY_DEVICES,
                                             screen: on,
                                             parameter: params)
                    break
                case .MyDeviceDetail:
                    break
                case .LogGoal:
                    break
                case .LogReading:
                    break
                case .GoalChart:
                    break
                case .ReadingChart:
                    break
                case .LoginWithPhone:
                    break
                case .LoginWithPassword:
                    break
                case .LoginOtp:
                    break
                case .SelectLanguage:
                    break
                case .LanguageList:
                    break
                case .SignUpWithPhone:
                    break
                case .SignUpOtp:
                    break
                case .AddAccountDetails:
                    break
                case .BookmarkList:
                    break
                case .ReportComment:
                    break
                case .AllBookmark:
                    break
                case .UseBiometric:
                    break
                case .SetUpDrugs:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_UPDATE_PRESCRIPTION,
                                             screen: on,
                                             parameter: params)
                    break
                case .SearchDrugs:
                    break
                case .SetUpGoalsReadings:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_SET_GOALS,
                                             screen: on,
                                             parameter: params)
                    break
                case .SelectGoals:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_ADD_GOALS,
                                             screen: on,
                                             parameter: params)
                    break
                case .SelectReadings:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_ADD_READINGS,
                                             screen: on,
                                             parameter: params)
                    break
                case .SelectLocation:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_UPDATE_LOCATION,
                                             screen: on,
                                             parameter: params)
                    break
                case .DoctorProfile:
                    break
                case .ForgotPasswordPhone:
                    break
                case .ForgotPasswordOtp:
                    break
                case .CreatePassword:
                    break
                case .CreateProfileFlow:
                    break
                case .CatSurvey:
                    break
                
                case .ExercisePlanDayDetailBreathing:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_PLAN_DETAIL_BREATH,
                                             screen: on,
                                             parameter: params)
                    break
                case .ExercisePlanDayDetailExercise:
                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_PLAN_DETAIL_EXC,
                                             screen: on,
                                             parameter: params)
                    break
                case .Menu:
//                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_OPTION_MENU,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .SetHeightWeight:
//                    FIRAnalytics.FIRLogEvent(eventName: .TIME_SPENT_UPDATE_HEIGHT_WEIGHT,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .AskAnExpert:
//                    FIRAnalytics.FIRLogEvent(eventName: .USER_TIME_SPENT_ASK_EXPERT,
//                                             screen: on,
//                                             parameter: params)
                    break
                case .QuestionDetails:
                    break
                case .ExerciseVideo:
                    break
                    
                case .BookAppointment:
                    break
                case .AppointmentList:
                    break
                case .AppointmentHistory:
                    break
                case .ChatBot:
                    break
                case .ChatList:
                    break
                case .AddAddress:
                    break
                case .AddPatientDetails:
                    break
                case .BookLabtestAppointmentReview:
                    break
                case .HealthPackageList:
                    break
                case .BookLabtestAppointmentSuccess:
                    break
                case .LabtestCart:
                    break
                case .LabtestDetails:
                    break
                case .LabtestList:
                    break
                case .AllTestPackageList:
                    break
                case .LabtestOrderDetails:
                    break
                case .SelectPatient:
                    break
                case .SelectAddress:
                    break
                case .SelectLabtestAppointmentDateTime:
                    break
                case .MyTatvaPlans:
                    break
                case .AccountDelete:
                    break
                case .VideoPlayer:
                    break
                case .ExerciseViewAll:
                    break
                case .NotificationSettings:
                    break
                case .ProfileCompleteSuccess:
                    break
                case .SearchFood:
                    break
                case .AnswerDetails:
                    break
                case .PostQuestion:
                    break
                case .SubmitAnswer:
                    break
                case .HistoryPayment:
                    break
                case .HistoryTest:
                    break
                case .RegisterSuccess:
                    break
                case .AppointmentConfirmed:
                    break
                case .none:
                    break
                case .MyTatvaPlanDetail:
                    break
                case .MyTatvaIndividualPlan:
                    break
                case .MyTatvaIndividualPlanDetail:
                    break
                case .DietPlan:
                    break
                case .LoginSignup:
                    break
                case .SelectRole:
                    break
                case .LinkDoctor:
                    break
                case .DoYouHaveDevice:
                    break
                case .ConnectDevice:
                    break
                case .LearnToConnectSmartScale:
                    break
                case .SearchSelectSmartScale:
                    break
                case .MeasureSmartScaleReadings:
                    break
                case .SmartScaleReadingAnalysis:
                    break
                case .Walkthrough:
                    break
                    
                case .BcpList:
                    break
                case .BcpDetails:
                    break
                case .BcpPurchasedDetails:
                    break
                case .BcpDeviceDetails:
                    break
                case .BcpHcServices:
                    break
                case .BcpHcServiceSelectTimeSlot:
                    break
                case .BcpPurchaseSuccess:
                    break
                case .BcpOrderReview:
                    break
                case .SelectAddressBottomSheet:
                    break
                case .ConnectDeviceInfo:
                    break
                case .ExerciseFeedback:
                    break
                case .ExerciseMyRoutine:
                    break
                }
            }
            break
        }
    }
}
