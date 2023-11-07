package com.mytatva.patient.data.repository

import com.mytatva.patient.data.model.CommonSelectItemData
import com.mytatva.patient.data.pojo.DataWrapper
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CoachMarksData
import com.mytatva.patient.data.pojo.response.CommonSettingFlagsData
import com.mytatva.patient.data.pojo.response.DaysData
import com.mytatva.patient.data.pojo.response.DosageTimeData
import com.mytatva.patient.data.pojo.response.FaqData
import com.mytatva.patient.data.pojo.response.FaqMainData
import com.mytatva.patient.data.pojo.response.GetMedicineResData
import com.mytatva.patient.data.pojo.response.GetPrescriptionDetailsResData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.data.pojo.response.LanguageData
import com.mytatva.patient.data.pojo.response.MedicalConditionData
import com.mytatva.patient.data.pojo.response.NotificationReminderFoodResData
import com.mytatva.patient.data.pojo.response.NotificationReminderOtherResData
import com.mytatva.patient.data.pojo.response.NotificationReminderReadingsResData
import com.mytatva.patient.data.pojo.response.NotificationReminderWaterResData
import com.mytatva.patient.data.pojo.response.NotificationResData
import com.mytatva.patient.data.pojo.response.NotificationSettingData
import com.mytatva.patient.data.pojo.response.PrescriptionMedicationData
import com.mytatva.patient.data.pojo.response.QueryReasonData
import com.mytatva.patient.data.pojo.response.RecordData
import com.mytatva.patient.data.pojo.response.SendOtpSignUpResData
import com.mytatva.patient.data.pojo.response.SignUpOnboardingData
import com.mytatva.patient.data.pojo.response.TestTypeResData
import com.mytatva.patient.data.pojo.response.UpdateDeviceInfoResData
import com.mytatva.patient.data.pojo.response.VerifyAccessCodeRes
import com.mytatva.patient.data.pojo.response.ZydusInfoData

interface AuthRepository {
    suspend fun verifyDoctorAccessCode(apiRequest: ApiRequest): DataWrapper<VerifyAccessCodeRes>
    suspend fun register(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun getLanguageList(apiRequest: ApiRequest): DataWrapper<List<LanguageData>>
    suspend fun contentLanguageList(apiRequest: ApiRequest): DataWrapper<List<LanguageData>>
    suspend fun login(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun linkDoctor(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateMedicalCondition(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun doctorDetailsById(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateDoctorAppointment(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateGoals(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getAppointmentDetails(apiRequest: ApiRequest): DataWrapper<Any>

    /*suspend fun getFaqData(apiRequest: ApiRequest): DataWrapper<Any>*/
    suspend fun checkContactDetails(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun forgotPassword(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updatePatientLocation(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun updatePatientHeightWeight(apiRequest: ApiRequest): DataWrapper<User>

    /*suspend fun updatePatientWeight(apiRequest: ApiRequest): DataWrapper<Any>*/
    suspend fun readingList(apiRequest: ApiRequest): DataWrapper<List<GoalReadingData>>
    suspend fun checkEmailVerified(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateProfile(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun myCurrentMedicalCondition(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun doseList(apiRequest: ApiRequest): DataWrapper<List<DosageTimeData>>
    suspend fun goalList(apiRequest: ApiRequest): DataWrapper<List<GoalReadingData>>
    suspend fun medialConditionGoalPatientRelList(apiRequest: ApiRequest): DataWrapper<List<GoalReadingData>>
    suspend fun medicalConditionReadingPatientRelList(apiRequest: ApiRequest): DataWrapper<List<GoalReadingData>>

    suspend fun addPrescription(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun medicalConditionList(apiRequest: ApiRequest): DataWrapper<List<MedicalConditionData>>
    suspend fun medicalConditionGroupList(apiRequest: ApiRequest): DataWrapper<List<MedicalConditionData>>
    suspend fun updateDeviceInfo(apiRequest: ApiRequest): DataWrapper<UpdateDeviceInfoResData>
    suspend fun languageValidation(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun verifyContactNo(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun contactNoValidation(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getPatientDetails(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun loginSendOtp(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun loginVerifyOtp(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun forgotPasswordSendOtp(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun forgotPasswordVerifyOtp(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getDaysList(apiRequest: ApiRequest): DataWrapper<List<DaysData>>
    suspend fun patientLinkedDrDetails(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getDeviceInfo(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getMedicineList(apiRequest: ApiRequest): DataWrapper<ArrayList<GetMedicineResData>>

    suspend fun verifyOtpSignup(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun sendOtpSignup(apiRequest: ApiRequest): DataWrapper<SendOtpSignUpResData>

    suspend fun stateList(apiRequest: ApiRequest): DataWrapper<List<CommonSelectItemData>>
    suspend fun cityList(apiRequest: ApiRequest): DataWrapper<List<CommonSelectItemData>>
    suspend fun cityListByStateName(apiRequest: ApiRequest): DataWrapper<List<CommonSelectItemData>>

    suspend fun addReadingGoal(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun sendEmailVerificationLink(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun requestPrescriptionCardCallback(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun prescriptionMedicineList(apiRequest: ApiRequest): DataWrapper<ArrayList<PrescriptionMedicationData>>

    suspend fun updatedRecords(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getRecords(apiRequest: ApiRequest): DataWrapper<ArrayList<RecordData>>
    suspend fun testTypes(apiRequest: ApiRequest): DataWrapper<TestTypeResData>
    suspend fun getFaqData(apiRequest: ApiRequest): DataWrapper<ArrayList<FaqData>>
    suspend fun getFaqs(apiRequest: ApiRequest): DataWrapper<ArrayList<FaqMainData>>

    suspend fun queryReasonList(apiRequest: ApiRequest): DataWrapper<ArrayList<QueryReasonData>>
    suspend fun sendQuery(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun updatePrescription(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getPrescriptionDetails(apiRequest: ApiRequest): DataWrapper<GetPrescriptionDetailsResData>

    suspend fun linkedHealthCoachList(apiRequest: ApiRequest): DataWrapper<ArrayList<HealthCoachData>>
    suspend fun healthCoachDetailsById(apiRequest: ApiRequest): DataWrapper<HealthCoachData>
    suspend fun updateHealthcoachChatInitiate(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun linkHealthCoachChat(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun getZydusInfo(apiRequest: ApiRequest): DataWrapper<ZydusInfoData>

    suspend fun logout(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun deleteAccount(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun getNoLoginSettingFlags(apiRequest: ApiRequest): DataWrapper<CommonSettingFlagsData>

    suspend fun updateSignupFor(apiRequest: ApiRequest): DataWrapper<User>
    suspend fun updateAccessCode(apiRequest: ApiRequest): DataWrapper<User>

    suspend fun onBordingSignUpData(): DataWrapper<ArrayList<SignUpOnboardingData>>

    suspend fun updateNotification(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getNotification(apiRequest: ApiRequest): DataWrapper<NotificationResData>
    suspend fun notificationMasterList(apiRequest: ApiRequest): DataWrapper<ArrayList<NotificationSettingData>>
    suspend fun notificationDetailsCommon(apiRequest: ApiRequest): DataWrapper<NotificationReminderOtherResData>
    suspend fun notificationDetailsFood(apiRequest: ApiRequest): DataWrapper<NotificationReminderFoodResData>
    suspend fun notificationDetailsWater(apiRequest: ApiRequest): DataWrapper<NotificationReminderWaterResData>
    suspend fun notificationDetailsReadings(apiRequest: ApiRequest): DataWrapper<NotificationReminderReadingsResData>
    suspend fun updateNotificationReminder(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun updateNotificationDetails(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateReadingsNotifications(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateMealReminder(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateWaterReminder(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun coachMarks(apiRequest: ApiRequest): DataWrapper<ArrayList<CoachMarksData>>


    suspend fun readLanguageFile(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun registerTempPatientProfile(apiRequest:ApiRequest): DataWrapper<User>

}