package com.mytatva.patient.ui.viewmodel

import android.os.Bundle
import androidx.lifecycle.viewModelScope
import com.mytatva.patient.data.model.CommonSelectItemData
import com.mytatva.patient.data.pojo.User
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CoachMarksData
import com.mytatva.patient.data.pojo.response.CommonSettingFlagsData
import com.mytatva.patient.data.pojo.response.DaysData
import com.mytatva.patient.data.pojo.response.DosageTimeData
import com.mytatva.patient.data.pojo.response.FaqMainData
import com.mytatva.patient.data.pojo.response.GetMedicineResData
import com.mytatva.patient.data.pojo.response.GetPrescriptionDetailsResData
import com.mytatva.patient.data.pojo.response.GoalReadingData
import com.mytatva.patient.data.pojo.response.HealthCoachData
import com.mytatva.patient.data.pojo.response.LanguageData
import com.mytatva.patient.data.pojo.response.MedicalConditionData
import com.mytatva.patient.data.pojo.response.MyPrescriptionMainData
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
import com.mytatva.patient.ui.base.APILiveData
import com.mytatva.patient.ui.base.BaseViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import kotlinx.coroutines.launch
import javax.inject.Inject

class AuthViewModel @Inject constructor(private val authRepository: AuthRepository) :
    BaseViewModel() {

    /**
     * @API :- register
     */
    val verifyDoctorAccessCodeLiveData = APILiveData<VerifyAccessCodeRes>()
    fun verifyDoctorAccessCode(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.verifyDoctorAccessCode(apiRequest)
            verifyDoctorAccessCodeLiveData.value = result
        }
    }

    /**
     * @API :- register
     */
    val registerLiveData = APILiveData<User>()
    fun register(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.register(apiRequest)
            registerLiveData.value = result
        }
    }

    /**
     * @API :- getLanguageList
     */
    val getLanguageListLiveData = APILiveData<List<LanguageData>>()
    fun getLanguageList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getLanguageList(apiRequest)
            getLanguageListLiveData.value = result
        }
    }

    /**
     * @API :- contentLanguageList
     */
    val contentLanguageListLiveData = APILiveData<List<LanguageData>>()
    fun contentLanguageList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.contentLanguageList(apiRequest)
            contentLanguageListLiveData.value = result
        }
    }

    /**
     * @API :- login
     */
    val loginLiveData = APILiveData<User>()
    fun login(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.login(apiRequest)
            loginLiveData.value = result
        }
    }

    /**
     * @API :- linkDoctor
     */
    val linkDoctorLiveData = APILiveData<Any>()
    fun linkDoctor(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.linkDoctor(apiRequest)
            linkDoctorLiveData.value = result
        }
    }

    /**
     * @API :- updateMedicalCondition
     */
    val updateMedicalConditionLiveData = APILiveData<Any>()
    fun updateMedicalCondition(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateMedicalCondition(apiRequest)
            updateMedicalConditionLiveData.value = result
        }
    }

    /**
     * @API :- doctorDetailsById
     */
    val doctorDetailsByIdLiveData = APILiveData<Any>()
    fun doctorDetailsById(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.doctorDetailsById(apiRequest)
            doctorDetailsByIdLiveData.value = result
        }
    }

    /**
     * @API :- updateDoctorAppointment
     */
    val updateDoctorAppointmentLiveData = APILiveData<Any>()
    fun updateDoctorAppointment(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateDoctorAppointment(apiRequest)
            updateDoctorAppointmentLiveData.value = result
        }
    }

    /**
     * @API :- updateGoals
     */
    val updateGoalsLiveData = APILiveData<Any>()
    fun updateGoals(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateGoals(apiRequest)
            updateGoalsLiveData.value = result
        }
    }

    /**
     * @API :- getAppointmentDetails
     */
    val getAppointmentDetailsLiveData = APILiveData<Any>()
    fun getAppointmentDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getAppointmentDetails(apiRequest)
            getAppointmentDetailsLiveData.value = result
        }
    }

    /**
     * @API :- getFaqData
     *//*
    val getFaqDataLiveData = APILiveData<Any>()
    fun getFaqData(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getFaqData(apiRequest)
            getFaqDataLiveData.value = result
        }
    }*/

    /**
     * @API :- checkContactDetails
     */
    val checkContactDetailsLiveData = APILiveData<Any>()
    fun checkContactDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.checkContactDetails(apiRequest)
            checkContactDetailsLiveData.value = result
        }
    }

    /**
     * @API :- forgotPassword
     */
    val forgotPasswordLiveData = APILiveData<Any>()
    fun forgotPassword(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.forgotPassword(apiRequest)
            forgotPasswordLiveData.value = result
        }
    }

    /**
     * @API :- updatePatientLocation
     */
    val updatePatientLocationLiveData = APILiveData<User>()
    fun updatePatientLocation(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updatePatientLocation(apiRequest)
            updatePatientLocationLiveData.value = result
        }
    }

    /**
     * @API :- updatePatientHeight
     */
    val updatePatientHeightWeightLiveData = APILiveData<User>()
    fun updatePatientHeightWeight(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updatePatientHeightWeight(apiRequest)
            updatePatientHeightWeightLiveData.value = result
        }
    }

    /**
     * @API :- updatePatientWeight
     *//*
    val updatePatientWeightLiveData = APILiveData<Any>()
    fun updatePatientWeight(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updatePatientWeight(apiRequest)
            updatePatientWeightLiveData.value = result
        }
    }*/

    /**
     * @API :- readingList
     */
    val readingListLiveData = APILiveData<List<GoalReadingData>>()
    fun readingList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.readingList(apiRequest)
            readingListLiveData.value = result
        }
    }

    /**
     * @API :- checkEmailVerified
     */
    val checkEmailVerifiedLiveData = APILiveData<Any>()
    fun checkEmailVerified(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.checkEmailVerified(apiRequest)
            checkEmailVerifiedLiveData.value = result
        }
    }

    /**
     * @API :- updateProfile
     */
    val updateProfileLiveData = APILiveData<User>()
    fun updateProfile(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateProfile(apiRequest)
            updateProfileLiveData.value = result
        }
    }

    /**
     * @API :- myCurrentMedicalCondition
     */
    val myCurrentMedicalConditionLiveData = APILiveData<Any>()
    fun myCurrentMedicalCondition(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.myCurrentMedicalCondition(apiRequest)
            myCurrentMedicalConditionLiveData.value = result
        }
    }

    /**
     * @API :- doseList
     */
    val doseListLiveData = APILiveData<List<DosageTimeData>>()
    fun doseList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.doseList(apiRequest)
            doseListLiveData.value = result
        }
    }

    /**
     * @API :- goalList
     */
    val goalListLiveData = APILiveData<List<GoalReadingData>>()
    fun goalList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.goalList(apiRequest)
            goalListLiveData.value = result
        }
    }

    /**
     * @API :- medialConditionGoalPatientRelList
     */
    val medialConditionGoalPatientRelListLiveData = APILiveData<List<GoalReadingData>>()
    fun medialConditionGoalPatientRelList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.medialConditionGoalPatientRelList(apiRequest)
            medialConditionGoalPatientRelListLiveData.value = result
        }
    }

    /**
     * @API :- medicalConditionReadingPatientRelList
     */
    val medicalConditionReadingPatientRelListLiveData = APILiveData<List<GoalReadingData>>()
    fun medicalConditionReadingPatientRelList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.medicalConditionReadingPatientRelList(apiRequest)
            medicalConditionReadingPatientRelListLiveData.value = result
        }
    }

    /**
     * @API :- addPrescription
     */
    val addPrescriptionLiveData = APILiveData<Any>()
    fun addPrescription(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.addPrescription(apiRequest)
            addPrescriptionLiveData.value = result
        }
    }

    /**
     * @API :- addMedicinePrescription
     */
    val addMedicinePrescriptionLiveData = APILiveData<Any>()
    fun addMedicinePrescription(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.addMedicinePrescription(apiRequest)
            addMedicinePrescriptionLiveData.value = result
        }
    }

    /**
     * @API :- fetchMedicinePrescription
     */
    val fetchMedicinePrescriptionLiveData = APILiveData<ArrayList<MyPrescriptionMainData>>()
    fun fetchMedicinePrescription(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.fetchMedicinePrescription(apiRequest)
            fetchMedicinePrescriptionLiveData.value = result
        }
    }

    /**
     * @API :- medicalConditionList
     */
    val medicalConditionListLiveData = APILiveData<List<MedicalConditionData>>()
    fun medicalConditionList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.medicalConditionList(apiRequest)
            medicalConditionListLiveData.value = result
        }
    }

    /**
     * @API :- medicalConditionGroupList
     */
    val medicalConditionGroupListLiveData = APILiveData<List<MedicalConditionData>>()
    fun medicalConditionGroupList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.medicalConditionGroupList(apiRequest)
            medicalConditionGroupListLiveData.value = result
        }
    }

    /**
     * @API :- updateDeviceInfo
     */
    val updateDeviceInfoLiveData = APILiveData<UpdateDeviceInfoResData>()
    fun updateDeviceInfo(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateDeviceInfo(apiRequest)
            updateDeviceInfoLiveData.value = result
        }
    }

    /**
     * @API :- languageValidation
     */
    val languageValidationLiveData = APILiveData<Any>()
    fun languageValidation(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.languageValidation(apiRequest)
            languageValidationLiveData.value = result
        }
    }

    /**
     * @API :- verifyContactNo
     */
    /*val verifyContactNoLiveData = APILiveData<Any>()
    fun verifyContactNo(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.verifyContactNo(apiRequest)
            verifyContactNoLiveData.value = result
        }
    }*/

    /**
     * @API :- contactNoValidation
     */
    val contactNoValidationLiveData = APILiveData<Any>()
    fun contactNoValidation(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.contactNoValidation(apiRequest)
            contactNoValidationLiveData.value = result
        }
    }

    /**
     * @API :- getPatientDetails
     */
    val getPatientDetailsLiveData = APILiveData<User>()
    fun getPatientDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getPatientDetails(apiRequest)
            getPatientDetailsLiveData.value = result
        }
    }

    /**
     * @API :- loginSendOtp
     */
    val loginSendOtpLiveData = APILiveData<Any>()
    fun loginSendOtp(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.loginSendOtp(apiRequest)
            loginSendOtpLiveData.value = result
        }
    }

    /**
     * @API :- loginVerifyOtp
     */
    val loginVerifyOtpLiveData = APILiveData<User>()
    fun loginVerifyOtp(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.loginVerifyOtp(apiRequest)
            loginVerifyOtpLiveData.value = result
        }
    }

    /**
     * @API :- forgotPasswordSendOtp
     */
    val forgotPasswordSendOtpLiveData = APILiveData<Any>()
    fun forgotPasswordSendOtp(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.forgotPasswordSendOtp(apiRequest)
            forgotPasswordSendOtpLiveData.value = result
        }
    }

    /**
     * @API :- forgotPasswordVerifyOtp
     */
    val forgotPasswordVerifyOtpLiveData = APILiveData<Any>()
    fun forgotPasswordVerifyOtp(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.forgotPasswordVerifyOtp(apiRequest)
            forgotPasswordVerifyOtpLiveData.value = result
        }
    }

    /**
     * @API :- getDaysList
     */
    val getDaysListLiveData = APILiveData<List<DaysData>>()
    fun getDaysList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getDaysList(apiRequest)
            getDaysListLiveData.value = result
        }
    }

    /**
     * @API :- patientLinkedDrDetails
     */
    val patientLinkedDrDetailsLiveData = APILiveData<Any>()
    fun patientLinkedDrDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.patientLinkedDrDetails(apiRequest)
            patientLinkedDrDetailsLiveData.value = result
        }
    }

    /**
     * @API :- getDeviceInfo
     */
    val getDeviceInfoLiveData = APILiveData<Any>()
    fun getDeviceInfo(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getDeviceInfo(apiRequest)
            getDeviceInfoLiveData.value = result
        }
    }

    /**
     * @API :- getDeviceInfo
     */
    val getMedicineListLiveData = APILiveData<ArrayList<GetMedicineResData>>()
    fun getMedicineList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getMedicineList(apiRequest)
            getMedicineListLiveData.value = result
        }
    }

    /**
     * @API :- verifyOtpSignup
     */
    val verifyOtpSignupLiveData = APILiveData<User>()
    fun verifyOtpSignup(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.verifyOtpSignup(apiRequest)
            verifyOtpSignupLiveData.value = result
        }
    }

    /**
     * @API :- sendOtpSignup
     */
    val sendOtpSignupLiveData = APILiveData<SendOtpSignUpResData>()
    fun sendOtpSignup(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.sendOtpSignup(apiRequest)
            sendOtpSignupLiveData.value = result
        }
    }

    /**
     * @API :- stateList
     */
    val stateListLiveData = APILiveData<List<CommonSelectItemData>>()
    fun stateList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.stateList(apiRequest)
            stateListLiveData.value = result
        }
    }

    /**
     * @API :- cityList
     */
    val cityListLiveData = APILiveData<List<CommonSelectItemData>>()
    fun cityList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.cityList(apiRequest)
            cityListLiveData.value = result
        }
    }

    /**
     * @API :- cityListByStateName
     */
    val cityListByStateNameLiveData = APILiveData<List<CommonSelectItemData>>()
    fun cityListByStateName(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.cityListByStateName(apiRequest)
            cityListByStateNameLiveData.value = result
        }
    }

    /**
     * @API :- cityListByStateName
     */
    val addReadingGoalLiveData = APILiveData<Any>()
    fun addReadingGoal(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.addReadingGoal(apiRequest)
            addReadingGoalLiveData.value = result
        }
    }

    /**
     * @API :- cityListByStateName
     */
    val sendEmailVerificationLinkLiveData = APILiveData<Any>()
    fun sendEmailVerificationLink(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.sendEmailVerificationLink(apiRequest)
            sendEmailVerificationLinkLiveData.value = result
        }
    }

    /**
     * @API :- requestPrescriptionCardCallback
     */
    val requestPrescriptionCardCallbackLiveData = APILiveData<Any>()
    fun requestPrescriptionCardCallback(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.requestPrescriptionCardCallback(apiRequest)
            requestPrescriptionCardCallbackLiveData.value = result
        }
    }

    /**
     * @API :- prescriptionMedicineList
     */
    val prescriptionMedicineListLiveData = APILiveData<ArrayList<PrescriptionMedicationData>>()
    fun prescriptionMedicineList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.prescriptionMedicineList(apiRequest)
            prescriptionMedicineListLiveData.value = result
        }
    }

    /**
     * @API :- updatedRecords
     */
    val updatedRecordsLiveData = APILiveData<Any>()
    fun updatedRecords(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updatedRecords(apiRequest)
            updatedRecordsLiveData.value = result
        }
    }

    /**
     * @API :- getRecords
     */
    val getRecordsLiveData = APILiveData<ArrayList<RecordData>>()
    fun getRecords(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getRecords(apiRequest)
            getRecordsLiveData.value = result
        }
    }

    /**
     * @API :- testTypes
     */
    val testTypesLiveData = APILiveData<TestTypeResData>()
    fun testTypes(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.testTypes(apiRequest)
            testTypesLiveData.value = result
        }
    }

    /**
     * @API :- getFaqData
     */
    /*val getFaqDataLiveData = APILiveData<ArrayList<FaqData>>()
    fun getFaqData(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getFaqData(apiRequest)
            getFaqDataLiveData.value = result
        }
    }*/

    /**
     * @API :- getFaqData
     */
    val getFaqsLiveData = APILiveData<ArrayList<FaqMainData>>()
    fun getFaqs(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getFaqs(apiRequest)
            getFaqsLiveData.value = result
        }
    }

    /**
     * @API :- queryReasonList
     */
    val queryReasonListLiveData = APILiveData<ArrayList<QueryReasonData>>()
    fun queryReasonList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.queryReasonList(apiRequest)
            queryReasonListLiveData.value = result
        }
    }

    /**
     * @API :- sendQuery
     */
    val sendQueryLiveData = APILiveData<Any>()
    fun sendQuery(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.sendQuery(apiRequest)
            sendQueryLiveData.value = result
        }
    }

    /**
     * @API :- updatePrescription
     */
    val updatePrescriptionLiveData = APILiveData<Any>()
    fun updatePrescription(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updatePrescription(apiRequest)
            updatePrescriptionLiveData.value = result
        }
    }

    /**
     * @API :- getPrescriptionDetails
     */
    val getPrescriptionDetailsLiveData = APILiveData<GetPrescriptionDetailsResData>()
    fun getPrescriptionDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getPrescriptionDetails(apiRequest)
            getPrescriptionDetailsLiveData.value = result
        }
    }

    /**
     * @API :- linkedHealthCoachList
     */
    val linkedHealthCoachListLiveData = APILiveData<ArrayList<HealthCoachData>>()
    fun linkedHealthCoachList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.linkedHealthCoachList(apiRequest)
            linkedHealthCoachListLiveData.value = result
        }
    }

    /**
     * @API :- healthCoachDetailsById
     */
    val healthCoachDetailsByIdLiveData = APILiveData<HealthCoachData>()
    fun healthCoachDetailsById(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.healthCoachDetailsById(apiRequest)
            healthCoachDetailsByIdLiveData.value = result
        }
    }

    /**
     * @API :- updateHealthcoachChatInitiate
     */
    val updateHealthcoachChatInitiateLiveData = APILiveData<Any>()
    fun updateHealthcoachChatInitiate(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateHealthcoachChatInitiate(apiRequest)
            updateHealthcoachChatInitiateLiveData.value = result
        }
    }

    /**
     * @API :- linkHealthCoachChat
     */
    val linkHealthCoachChatLiveData = APILiveData<Any>()
    fun linkHealthCoachChat(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.linkHealthCoachChat(apiRequest)
            linkHealthCoachChatLiveData.value = result
        }
    }

    /**
     * @API :- logout
     */
    val logoutLiveData = APILiveData<Any>()
    fun logout(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.logout(apiRequest)
            logoutLiveData.value = result
        }
    }

    /**
     * @API :- deleteAccount
     */
    val deleteAccountLiveData = APILiveData<Any>()
    fun deleteAccount(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.deleteAccount(apiRequest)
            deleteAccountLiveData.value = result
        }
    }

    /**
     * @API :- deleteAccount
     */
    val getNoLoginSettingFlagsLiveData = APILiveData<CommonSettingFlagsData>()
    fun getNoLoginSettingFlags(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getNoLoginSettingFlags(apiRequest)
            getNoLoginSettingFlagsLiveData.value = result
        }
    }

    /**
     * @API :- updateSignupFor
     */
    val updateSignupForLiveData = APILiveData<User>()
    fun updateSignupFor(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateSignupFor(apiRequest)
            updateSignupForLiveData.value = result
        }
    }

    /**
     * @API :- updateAccessCode
     */
    val updateAccessCodeLiveData = APILiveData<User>()
    fun updateAccessCode(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateAccessCode(apiRequest)
            updateAccessCodeLiveData.value = result
        }
    }


    /**
     * @API :- OnBoardingSignUp
     */
    val onBordingSignUpLiveData = APILiveData<ArrayList<SignUpOnboardingData>>()
    fun onBordingSignUp() {
        viewModelScope.launch {
            val result = authRepository.onBordingSignUpData()
            onBordingSignUpLiveData.value = result
        }
    }


    /**
     * @API :- linkHealthCoachChat
     */
    val getZydusInfoLiveData = APILiveData<ZydusInfoData>()
    fun getZydusInfo(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getZydusInfo(apiRequest)
            getZydusInfoLiveData.value = result
        }
    }

    /**
     * @API :- updateNotification
     */
    val updateNotificationLiveData = APILiveData<Any>()
    fun updateNotification(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateNotification(apiRequest)
            updateNotificationLiveData.value = result
        }
    }

    /**
     * @API :- getNotification
     */
    val getNotificationLiveData = APILiveData<NotificationResData>()
    fun getNotification(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.getNotification(apiRequest)
            getNotificationLiveData.value = result
        }
    }


    /**
     * @API :- notificationMasterList
     */
    val notificationMasterListLiveData = APILiveData<ArrayList<NotificationSettingData>>()
    fun notificationMasterList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.notificationMasterList(apiRequest)
            notificationMasterListLiveData.value = result
        }
    }

    /**
     * @API :- notificationDetailsCommon
     */
    val notificationDetailsCommonLiveData = APILiveData<NotificationReminderOtherResData>()
    fun notificationDetailsCommon(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.notificationDetailsCommon(apiRequest)
            notificationDetailsCommonLiveData.value = result
        }
    }

    /**
     * @API :- notificationDetailsFood
     */
    val notificationDetailsFoodLiveData = APILiveData<NotificationReminderFoodResData>()
    fun notificationDetailsFood(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.notificationDetailsFood(apiRequest)
            notificationDetailsFoodLiveData.value = result
        }
    }

    /**
     * @API :- notificationDetailsWater
     */
    val notificationDetailsWaterLiveData = APILiveData<NotificationReminderWaterResData>()
    fun notificationDetailsWater(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.notificationDetailsWater(apiRequest)
            notificationDetailsWaterLiveData.value = result
        }
    }

    /**
     * @API :- notificationDetailsReadings
     */
    val notificationDetailsReadingsLiveData = APILiveData<NotificationReminderReadingsResData>()
    fun notificationDetailsReadings(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.notificationDetailsReadings(apiRequest)
            notificationDetailsReadingsLiveData.value = result
        }
    }

    /**
     * @API :- updateNotificationReminder
     */
    val updateNotificationReminderLiveData = APILiveData<Any>()
    fun updateNotificationReminder(apiRequest: ApiRequest, analytics: AnalyticsClient) {

        if (apiRequest.is_active == "Y") {
            analytics.logEvent(analytics.USER_ENABLED_NOTIFICATION, Bundle().apply {
                putString(analytics.PARAM_NOTIFICATION_MASTER_ID, apiRequest.notification_master_id)
            }, screenName = AnalyticsScreenNames.NotificationSettings)
        } else {
            analytics.logEvent(analytics.USER_DISABLED_NOTIFICATION, Bundle().apply {
                putString(analytics.PARAM_NOTIFICATION_MASTER_ID, apiRequest.notification_master_id)
            }, screenName = AnalyticsScreenNames.NotificationSettings)
        }

        viewModelScope.launch {
            val result = authRepository.updateNotificationReminder(apiRequest)
            updateNotificationReminderLiveData.value = result
        }
    }

    /**
     * @API :- updateNotificationDetails
     */
    val updateNotificationDetailsLiveData = APILiveData<Any>()
    fun updateNotificationDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateNotificationDetails(apiRequest)
            updateNotificationDetailsLiveData.value = result
        }
    }

    /**
     * @API :- updateReadingsNotifications
     */
    val updateReadingsNotificationsLiveData = APILiveData<Any>()
    fun updateReadingsNotifications(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateReadingsNotifications(apiRequest)
            updateReadingsNotificationsLiveData.value = result
        }
    }

    /**
     * @API :- updateMealReminder
     */
    val updateMealReminderLiveData = APILiveData<Any>()
    fun updateMealReminder(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateMealReminder(apiRequest)
            updateMealReminderLiveData.value = result
        }
    }

    /**
     * @API :- updateWaterReminder
     */
    val updateWaterReminderLiveData = APILiveData<Any>()
    fun updateWaterReminder(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.updateWaterReminder(apiRequest)
            updateWaterReminderLiveData.value = result
        }
    }

    /**
     * @API :- updateWaterReminder
     */
    val coachMarksLiveData = APILiveData<ArrayList<CoachMarksData>>()
    fun coachMarks(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.coachMarks(apiRequest)
            coachMarksLiveData.value = result
        }
    }

    /**
     * @API :- getNotification
     */
    val readLanguageFileLiveData = APILiveData<Any>()
    fun readLanguageFile(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.readLanguageFile(apiRequest)
            readLanguageFileLiveData.value = result
        }
    }

    /**
     * @API :- RegisterTempPatientProfileLiveData
     */
    val registerTempPatientProfileLiveData = APILiveData<User>()
    fun registerTempPatientProfile(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = authRepository.registerTempPatientProfile(apiRequest)
            registerTempPatientProfileLiveData.value = result
        }
    }
}