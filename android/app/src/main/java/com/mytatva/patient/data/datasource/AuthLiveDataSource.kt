package com.mytatva.patient.data.datasource

import com.mytatva.patient.core.AppPreferences
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
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
import com.mytatva.patient.data.repository.AuthRepository
import com.mytatva.patient.data.service.AuthService
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class AuthLiveDataSource @Inject constructor(private val authService: AuthService) :
    BaseDataSource(), AuthRepository {

    @Inject
    lateinit var session: Session

    @Inject
    lateinit var appPreferences: AppPreferences

    override suspend fun verifyDoctorAccessCode(apiRequest: ApiRequest): DataWrapper<VerifyAccessCodeRes> {
        return execute { authService.verifyDoctorAccessCode(apiRequest) }
    }

    override suspend fun register(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.register(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.userSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun getLanguageList(apiRequest: ApiRequest): DataWrapper<List<LanguageData>> {
        return execute { authService.getLanguageList(apiRequest) }
    }

    override suspend fun contentLanguageList(apiRequest: ApiRequest): DataWrapper<List<LanguageData>> {
        return execute { authService.contentLanguageList(apiRequest) }
    }

    override suspend fun login(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.login(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.userSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun linkDoctor(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.linkDoctor(apiRequest) }
    }

    override suspend fun updateMedicalCondition(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateMedicalCondition(apiRequest) }
    }

    override suspend fun doctorDetailsById(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.doctorDetailsById(apiRequest) }
    }

    override suspend fun updateDoctorAppointment(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateDoctorAppointment(apiRequest) }
    }

    override suspend fun updateGoals(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateGoals(apiRequest) }
    }

    override suspend fun getAppointmentDetails(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.getAppointmentDetails(apiRequest) }
    }

    /*override suspend fun getFaqData(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.getFaqData(apiRequest) }
    }*/

    override suspend fun checkContactDetails(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.checkContactDetails(apiRequest) }
    }

    override suspend fun forgotPassword(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.forgotPassword(apiRequest) }
    }

    override suspend fun updatePatientLocation(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.updatePatientLocation(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.userSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun updatePatientHeightWeight(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.updatePatientHeightWeight(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.userSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    /*override suspend fun updatePatientWeight(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updatePatientWeight(apiRequest) }
    }*/

    override suspend fun readingList(apiRequest: ApiRequest): DataWrapper<List<GoalReadingData>> {
        return execute { authService.readingList(apiRequest) }
    }

    override suspend fun checkEmailVerified(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.checkEmailVerified(apiRequest) }
    }

    override suspend fun updateProfile(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.updateProfile(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.userSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun myCurrentMedicalCondition(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.myCurrentMedicalCondition(apiRequest) }
    }

    override suspend fun doseList(apiRequest: ApiRequest): DataWrapper<List<DosageTimeData>> {
        return execute { authService.doseList(apiRequest) }
    }

    override suspend fun goalList(apiRequest: ApiRequest): DataWrapper<List<GoalReadingData>> {
        return execute { authService.goalList(apiRequest) }
    }

    override suspend fun medialConditionGoalPatientRelList(apiRequest: ApiRequest): DataWrapper<List<GoalReadingData>> {
        return execute { authService.medialConditionGoalPatientRelList(apiRequest) }
    }

    override suspend fun medicalConditionReadingPatientRelList(apiRequest: ApiRequest): DataWrapper<List<GoalReadingData>> {
        return execute { authService.medicalConditionReadingPatientRelList(apiRequest) }
    }

    override suspend fun addPrescription(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.addPrescription(apiRequest) }
    }

    override suspend fun medicalConditionList(apiRequest: ApiRequest): DataWrapper<List<MedicalConditionData>> {
        return execute { authService.medicalConditionList(apiRequest) }
    }

    override suspend fun medicalConditionGroupList(apiRequest: ApiRequest): DataWrapper<List<MedicalConditionData>> {
        return execute { authService.medicalConditionGroupList(apiRequest) }
    }

    override suspend fun updateDeviceInfo(apiRequest: ApiRequest): DataWrapper<UpdateDeviceInfoResData> {
        return execute { authService.updateDeviceInfo(apiRequest) }.apply {
            appPreferences.setAppUnderMaintenance(responseBody?.responseCode == Common.ResponseCode.APP_UNDER_MAINTENENCE)
            responseBody?.data?.let { updateDeviceInfoData ->
                appPreferences.updateDeviceInfoResData = updateDeviceInfoData
            }
        }
    }

    override suspend fun languageValidation(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.languageValidation(apiRequest) }
    }

    override suspend fun verifyContactNo(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.verifyContactNo(apiRequest) }
    }

    override suspend fun contactNoValidation(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.contactNoValidation(apiRequest) }
    }

    override suspend fun getPatientDetails(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.getPatientDetails(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.userSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun loginSendOtp(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.loginSendOtp(apiRequest) }
    }

    override suspend fun loginVerifyOtp(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.loginVerifyOtp(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.userSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun forgotPasswordSendOtp(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.forgotPasswordSendOtp(apiRequest) }
    }

    override suspend fun forgotPasswordVerifyOtp(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.forgotPasswordVerifyOtp(apiRequest) }
    }

    override suspend fun getDaysList(apiRequest: ApiRequest): DataWrapper<List<DaysData>> {
        return execute { authService.getDaysList(apiRequest) }
    }

    override suspend fun patientLinkedDrDetails(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.patientLinkedDrDetails(apiRequest) }
    }

    override suspend fun getDeviceInfo(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.getDeviceInfo(apiRequest) }
    }

    override suspend fun getMedicineList(apiRequest: ApiRequest): DataWrapper<ArrayList<GetMedicineResData>> {
        return execute { authService.getMedicineList(apiRequest) }
    }

    override suspend fun verifyOtpSignup(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.verifyOtpSignup(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.token?.let { session.authUserSession = it }
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun sendOtpSignup(apiRequest: ApiRequest): DataWrapper<SendOtpSignUpResData> {
        return execute { authService.sendOtpSignup(apiRequest) }.apply {
            responseBody?.data?.let {
                if (it.access_code.isNullOrBlank().not() && it.doctor_access_code.isNullOrBlank()
                        .not()
                ) {
                    FirebaseLink.Values.accessFrom = FirebaseLink.AccessFrom.LinkPatient
                    // IMP Note *************************************
                    // accessCode var is actual doctor access code(in register API),
                    // doctorAccessCode is just random number, so from response
                    // store access_code to doctorAccessCode
                    // and store doctor_access_code to accessCode
                    // *************************************
                    FirebaseLink.Values.doctorAccessCode = it.access_code
                    FirebaseLink.Values.accessCode = it.doctor_access_code
                }
            }
        }
    }

    override suspend fun stateList(apiRequest: ApiRequest): DataWrapper<List<CommonSelectItemData>> {
        return execute { authService.stateList(apiRequest) }
    }

    override suspend fun cityList(apiRequest: ApiRequest): DataWrapper<List<CommonSelectItemData>> {
        return execute { authService.cityList(apiRequest) }
    }

    override suspend fun cityListByStateName(apiRequest: ApiRequest): DataWrapper<List<CommonSelectItemData>> {
        return execute { authService.cityListByStateName(apiRequest) }
    }

    override suspend fun addReadingGoal(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.addReadingGoal(apiRequest) }
    }

    override suspend fun sendEmailVerificationLink(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.sendEmailVerificationLink(apiRequest) }
    }

    override suspend fun requestPrescriptionCardCallback(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.requestPrescriptionCardCallback(apiRequest) }
    }

    override suspend fun prescriptionMedicineList(apiRequest: ApiRequest): DataWrapper<ArrayList<PrescriptionMedicationData>> {
        return execute { authService.prescriptionMedicineList(apiRequest) }
    }

    override suspend fun updatedRecords(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updatedRecords(apiRequest) }
    }

    override suspend fun getRecords(apiRequest: ApiRequest): DataWrapper<ArrayList<RecordData>> {
        return execute { authService.getRecords(apiRequest) }
    }

    override suspend fun testTypes(apiRequest: ApiRequest): DataWrapper<TestTypeResData> {
        return execute { authService.testTypes(apiRequest) }
    }

    override suspend fun getFaqData(apiRequest: ApiRequest): DataWrapper<ArrayList<FaqData>> {
        return execute { authService.getFaqData(apiRequest) }
    }

    override suspend fun getFaqs(apiRequest: ApiRequest): DataWrapper<ArrayList<FaqMainData>> {
        return execute { authService.getFaqs(apiRequest) }
    }

    override suspend fun queryReasonList(apiRequest: ApiRequest): DataWrapper<ArrayList<QueryReasonData>> {
        return execute { authService.queryReasonList(apiRequest) }
    }

    override suspend fun sendQuery(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.sendQuery(apiRequest) }
    }

    override suspend fun updatePrescription(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updatePrescription(apiRequest) }
    }

    override suspend fun getPrescriptionDetails(apiRequest: ApiRequest): DataWrapper<GetPrescriptionDetailsResData> {
        return execute { authService.getPrescriptionDetails(apiRequest) }
    }

    override suspend fun linkedHealthCoachList(apiRequest: ApiRequest): DataWrapper<ArrayList<HealthCoachData>> {
        return execute { authService.linkedHealthCoachList(apiRequest) }
    }

    override suspend fun healthCoachDetailsById(apiRequest: ApiRequest): DataWrapper<HealthCoachData> {
        return execute { authService.healthCoachDetailsById(apiRequest) }
    }

    override suspend fun updateHealthcoachChatInitiate(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateHealthcoachChatInitiate(apiRequest) }
    }

    override suspend fun linkHealthCoachChat(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.linkHealthCoachChat(apiRequest) }
    }

    override suspend fun getZydusInfo(apiRequest: ApiRequest): DataWrapper<ZydusInfoData> {
        return execute { authService.getZydusInfo(apiRequest) }
    }

    override suspend fun logout(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.logout(apiRequest) }
    }

    override suspend fun deleteAccount(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.deleteAccount(apiRequest) }
    }

    override suspend fun getNoLoginSettingFlags(apiRequest: ApiRequest): DataWrapper<CommonSettingFlagsData> {
        return execute { authService.getNoLoginSettingFlags(apiRequest) }
    }

    override suspend fun updateSignupFor(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.updateSignupFor(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.patient_id?.let { session.userId = it }
                session.user = user

                //add data to handle Verify link doctor navigation
                if (user.access_code.isNullOrBlank().not()
                    && user.doctor_access_code.isNullOrBlank().not()
                ) {
                    FirebaseLink.Values.accessFrom = FirebaseLink.AccessFrom.LinkPatient
                    // IMP Note *************************************
                    // accessCode var is actual doctor access code(in register API),
                    // doctorAccessCode is just random number, so from response
                    // store access_code to doctorAccessCode
                    // and store doctor_access_code to accessCode
                    // *************************************
                    FirebaseLink.Values.doctorAccessCode = user.access_code
                    FirebaseLink.Values.accessCode = user.doctor_access_code
                }
            }
        }
    }

    override suspend fun updateAccessCode(apiRequest: ApiRequest): DataWrapper<User> {
        return execute { authService.updateAccessCode(apiRequest) }.apply {
            responseBody?.data?.let { user ->
                user.patient_id?.let { session.userId = it }
                session.user = user
            }
        }
    }

    override suspend fun onBordingSignUpData(): DataWrapper<ArrayList<SignUpOnboardingData>> {
        return execute { authService.onBordingSignUpData() }
    }

    override suspend fun updateNotification(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateNotification(apiRequest) }
    }

    override suspend fun getNotification(apiRequest: ApiRequest): DataWrapper<NotificationResData> {
        return execute { authService.getNotification(apiRequest) }
    }

    override suspend fun notificationMasterList(apiRequest: ApiRequest): DataWrapper<ArrayList<NotificationSettingData>> {
        return execute { authService.notificationMasterList(apiRequest) }
    }

    override suspend fun notificationDetailsCommon(apiRequest: ApiRequest): DataWrapper<NotificationReminderOtherResData> {
        return execute { authService.notificationDetailsCommon(apiRequest) }
    }

    override suspend fun notificationDetailsFood(apiRequest: ApiRequest): DataWrapper<NotificationReminderFoodResData> {
        return execute { authService.notificationDetailsFood(apiRequest) }
    }

    override suspend fun notificationDetailsWater(apiRequest: ApiRequest): DataWrapper<NotificationReminderWaterResData> {
        return execute { authService.notificationDetailsWater(apiRequest) }
    }

    override suspend fun notificationDetailsReadings(apiRequest: ApiRequest): DataWrapper<NotificationReminderReadingsResData> {
        return execute { authService.notificationDetailsReadings(apiRequest) }
    }

    override suspend fun updateNotificationReminder(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateNotificationReminder(apiRequest) }
    }

    override suspend fun updateNotificationDetails(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateNotificationDetails(apiRequest) }
    }

    override suspend fun updateReadingsNotifications(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateReadingsNotifications(apiRequest) }
    }

    override suspend fun updateMealReminder(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateMealReminder(apiRequest) }
    }

    override suspend fun updateWaterReminder(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.updateWaterReminder(apiRequest) }
    }

    override suspend fun coachMarks(apiRequest: ApiRequest): DataWrapper<ArrayList<CoachMarksData>> {
        return execute { authService.coachMarks(apiRequest) }
    }

    override suspend fun readLanguageFile(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { authService.readLanguageFile(apiRequest) }
    }

    override suspend fun registerTempPatientProfile(apiRequest:ApiRequest): DataWrapper<User> {
        return execute { authService.registerTempPatientProfile(apiRequest) }.apply {
            responseBody?.data.let {
                session.user = it
            }
        }
    }
}
