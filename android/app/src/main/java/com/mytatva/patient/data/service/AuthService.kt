package com.mytatva.patient.data.service

import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.model.CommonSelectItemData
import com.mytatva.patient.data.pojo.ResponseBody
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.*
import retrofit2.http.Body
import retrofit2.http.POST

interface AuthService {

    @POST(URLFactory.Patient.VERIFY_DOCTOR_ACCESS_CODE)
    suspend fun verifyDoctorAccessCode(@Body apiRequest: ApiRequest): ResponseBody<VerifyAccessCodeRes>

    @POST(URLFactory.Patient.REGISTER)
    suspend fun register(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.GET_LANGUAGE_LIST)
    suspend fun getLanguageList(@Body apiRequest: ApiRequest): ResponseBody<List<LanguageData>>

    @POST(URLFactory.Patient.CONTENT_LANGUAGE_LIST)
    suspend fun contentLanguageList(@Body apiRequest: ApiRequest): ResponseBody<List<LanguageData>>

    @POST(URLFactory.Patient.LOGIN)
    suspend fun login(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.LINK_DOCTOR)
    suspend fun linkDoctor(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.UPDATE_MEDICAL_CONDITION)
    suspend fun updateMedicalCondition(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.DOCTOR_DETAILS_BY_ID)
    suspend fun doctorDetailsById(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.UPDATE_DOCTOR_APPOINTMENT)
    suspend fun updateDoctorAppointment(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.UPDATE_GOALS)
    suspend fun updateGoals(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_APPOINTMENT_DETAILS)
    suspend fun getAppointmentDetails(@Body apiRequest: ApiRequest): ResponseBody<Any>

    /*@POST(URLFactory.Patient.GET_FAQ_DATA)
    suspend fun getFaqData(@Body apiRequest: ApiRequest): ResponseBody<Any>*/

    @POST(URLFactory.Patient.CHECK_CONTACT_DETAILS)
    suspend fun checkContactDetails(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.FORGOT_PASSWORD)
    suspend fun forgotPassword(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.UPDATE_PATIENT_LOCATION)
    suspend fun updatePatientLocation(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.UPDATE_PATIENT_HEIGHT_WEIGHT)
    suspend fun updatePatientHeightWeight(@Body apiRequest: ApiRequest): ResponseBody<User>

    /*@POST(URLFactory.Patient.UPDATE_PATIENT_WEIGHT)
    suspend fun updatePatientWeight(@Body apiRequest: ApiRequest): ResponseBody<Any>*/

    @POST(URLFactory.Patient.READING_LIST)
    suspend fun readingList(@Body apiRequest: ApiRequest): ResponseBody<List<GoalReadingData>>

    @POST(URLFactory.Patient.CHECK_EMAIL_VERIFIED)
    suspend fun checkEmailVerified(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.UPDATE_PROFILE)
    suspend fun updateProfile(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.MY_CURRENT_MEDICAL_CONDITION)
    suspend fun myCurrentMedicalCondition(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.DOSE_LIST)
    suspend fun doseList(@Body apiRequest: ApiRequest): ResponseBody<List<DosageTimeData>>

    @POST(URLFactory.Patient.GOAL_LIST)
    suspend fun goalList(@Body apiRequest: ApiRequest): ResponseBody<List<GoalReadingData>>

    @POST(URLFactory.Patient.MEDIAL_CONDITION_GOAL_PATIENT_REL_LIST)
    suspend fun medialConditionGoalPatientRelList(@Body apiRequest: ApiRequest): ResponseBody<List<GoalReadingData>>

    @POST(URLFactory.Patient.MEDICAL_CONDITION_READING_PATIENT_REL_LIST)
    suspend fun medicalConditionReadingPatientRelList(@Body apiRequest: ApiRequest): ResponseBody<List<GoalReadingData>>

    @POST(URLFactory.Patient.ADD_PRESCRIPTION)
    suspend fun addPrescription(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.ADD_MEDICINE_PRESCRIPTION)
    suspend fun addMedicinePrescription(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.FETCH_MEDICINE_PRESCRIPTION)
    suspend fun fetchMedicinePrescription(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<MyPrescriptionMainData>>

    @POST(URLFactory.Patient.MEDICAL_CONDITION_LIST)
    suspend fun medicalConditionList(@Body apiRequest: ApiRequest): ResponseBody<List<MedicalConditionData>>

    @POST(URLFactory.Patient.MEDICAL_CONDITION_GROUP_LIST)
    suspend fun medicalConditionGroupList(@Body apiRequest: ApiRequest): ResponseBody<List<MedicalConditionData>>

    @POST(URLFactory.Patient.UPDATE_DEVICE_INFO)
    suspend fun updateDeviceInfo(@Body apiRequest: ApiRequest): ResponseBody<UpdateDeviceInfoResData>

    @POST(URLFactory.Patient.LANGUAGE_VALIDATION)
    suspend fun languageValidation(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.VERIFY_CONTACT_NO)
    suspend fun verifyContactNo(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.CONTACT_NO_VALIDATION)
    suspend fun contactNoValidation(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_PATIENT_DETAILS)
    suspend fun getPatientDetails(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.LOGIN_SEND_OTP)
    suspend fun loginSendOtp(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.LOGIN_VERIFY_OTP)
    suspend fun loginVerifyOtp(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.FORGOT_PASSWORD_SEND_OTP)
    suspend fun forgotPasswordSendOtp(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.FORGOT_PASSWORD_VERIFY_OTP)
    suspend fun forgotPasswordVerifyOtp(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_DAYS_LIST)
    suspend fun getDaysList(@Body apiRequest: ApiRequest): ResponseBody<List<DaysData>>

    @POST(URLFactory.Patient.PATIENT_LINKED_DR_DETAILS)
    suspend fun patientLinkedDrDetails(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_DEVICE_INFO)
    suspend fun getDeviceInfo(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_MEDICINE_LIST)
    suspend fun getMedicineList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<GetMedicineResData>>

    @POST(URLFactory.Patient.VERIFY_OTP_SIGNUP)
    suspend fun verifyOtpSignup(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.SEND_OTP_SIGNUP)
    suspend fun sendOtpSignup(@Body apiRequest: ApiRequest): ResponseBody<SendOtpSignUpResData>

    @POST(URLFactory.Patient.STATE_LIST)
    suspend fun stateList(@Body apiRequest: ApiRequest): ResponseBody<List<CommonSelectItemData>>

    @POST(URLFactory.Patient.CITY_LIST)
    suspend fun cityList(@Body apiRequest: ApiRequest): ResponseBody<List<CommonSelectItemData>>

    @POST(URLFactory.Patient.CITY_LIST_BY_STATE_NAME)
    suspend fun cityListByStateName(@Body apiRequest: ApiRequest): ResponseBody<List<CommonSelectItemData>>

    @POST(URLFactory.Patient.ADD_READING_GOAL)
    suspend fun addReadingGoal(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.SEND_EMAIL_VERIFICATION_LINK)
    suspend fun sendEmailVerificationLink(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.REQUEST_PRESCRIPTION_CARD_CALLBACK)
    suspend fun requestPrescriptionCardCallback(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.PRESCRIPTION_MEDICINE_LIST)
    suspend fun prescriptionMedicineList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<PrescriptionMedicationData>>


    @POST(URLFactory.Patient.UPDATED_RECORDS)
    suspend fun updatedRecords(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_RECORDS)
    suspend fun getRecords(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<RecordData>>

    @POST(URLFactory.Patient.TEST_TYPES)
    suspend fun testTypes(@Body apiRequest: ApiRequest): ResponseBody<TestTypeResData>

    @POST(URLFactory.Patient.GET_FAQ_DATA)
    suspend fun getFaqData(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<FaqData>>

    @POST(URLFactory.Patient.GET_FAQS)
    suspend fun getFaqs(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<FaqMainData>>

    @POST(URLFactory.Patient.QUERY_REASON_LIST)
    suspend fun queryReasonList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<QueryReasonData>>

    @POST(URLFactory.Patient.SEND_QUERY)
    suspend fun sendQuery(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.UPDATE_PRESCRIPTION)
    suspend fun updatePrescription(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_PRESCRIPTION_DETAILS)
    suspend fun getPrescriptionDetails(@Body apiRequest: ApiRequest): ResponseBody<GetPrescriptionDetailsResData>

    @POST(URLFactory.Patient.LINKED_HEALTH_COACH_LIST)
    suspend fun linkedHealthCoachList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<HealthCoachData>>

    @POST(URLFactory.Patient.HEALTH_COACH_DETAILS_BY_ID)
    suspend fun healthCoachDetailsById(@Body apiRequest: ApiRequest): ResponseBody<HealthCoachData>

    @POST(URLFactory.Patient.UPDATE_HEALTHCOACH_CHAT_INITIATE)
    suspend fun updateHealthcoachChatInitiate(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.LINK_HEALTHCOACH_CHAT)
    suspend fun linkHealthCoachChat(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_ZYDUS_INFO)
    suspend fun getZydusInfo(@Body apiRequest: ApiRequest): ResponseBody<ZydusInfoData>

    @POST(URLFactory.Patient.LOGOUT)
    suspend fun logout(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.DELETE_ACCOUNT)
    suspend fun deleteAccount(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.GET_NO_LOGIN_SETTING_FLAGS)
    suspend fun getNoLoginSettingFlags(@Body apiRequest: ApiRequest): ResponseBody<CommonSettingFlagsData>

    @POST(URLFactory.Patient.UPDATE_SIGNUP_FOR)
    suspend fun updateSignupFor(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.UPDATE_ACCESS_CODE)
    suspend fun updateAccessCode(@Body apiRequest: ApiRequest): ResponseBody<User>

    @POST(URLFactory.Patient.ONBORDING_SIGNUP_DATA)
    suspend fun onBordingSignUpData(): ResponseBody<ArrayList<SignUpOnboardingData>>

    //notifications
    @POST(URLFactory.Notification.UPDATE_NOTIFICATION)
    suspend fun updateNotification(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Notification.GET_NOTIFICATION)
    suspend fun getNotification(@Body apiRequest: ApiRequest): ResponseBody<NotificationResData>

    @POST(URLFactory.Notification.NOTIFICATION_MASTER_LIST)
    suspend fun notificationMasterList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<NotificationSettingData>>

    @POST(URLFactory.Notification.NOTIFICATION_DETAILS_COMMON)
    suspend fun notificationDetailsCommon(@Body apiRequest: ApiRequest): ResponseBody<NotificationReminderOtherResData>

    @POST(URLFactory.Notification.NOTIFICATION_DETAILS_FOOD)
    suspend fun notificationDetailsFood(@Body apiRequest: ApiRequest): ResponseBody<NotificationReminderFoodResData>

    @POST(URLFactory.Notification.NOTIFICATION_DETAILS_WATER)
    suspend fun notificationDetailsWater(@Body apiRequest: ApiRequest): ResponseBody<NotificationReminderWaterResData>

    @POST(URLFactory.Notification.NOTIFICATION_DETAILS_READINGS)
    suspend fun notificationDetailsReadings(@Body apiRequest: ApiRequest): ResponseBody<NotificationReminderReadingsResData>

    @POST(URLFactory.Notification.UPDATE_NOTIFICATION_REMINDER)
    suspend fun updateNotificationReminder(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Notification.UPDATE_NOTIFICATION_DETAILS)
    suspend fun updateNotificationDetails(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Notification.UPDATE_READINGS_NOTIFICATIONS)
    suspend fun updateReadingsNotifications(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Notification.UPDATE_MEAL_REMINDER)
    suspend fun updateMealReminder(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Notification.UPDATE_WATER_REMINDER)
    suspend fun updateWaterReminder(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Notification.COACH_MARKS)
    suspend fun coachMarks(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<CoachMarksData>>

    //language
    @POST(URLFactory.Language.READ_LANGUAGE_FILE)
    suspend fun readLanguageFile(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Patient.REGISTER_TEMP_PATIENT_PROFILE)
    suspend fun registerTempPatientProfile(@Body apiRequest: ApiRequest): ResponseBody<User>
}