package com.mytatva.patient.data.service

import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.pojo.ResponseBody
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.*
import retrofit2.http.Body
import retrofit2.http.POST

interface DoctorService {

    @POST(URLFactory.Doctor.TODAYS_APPOINTMENT)
    suspend fun todaysAppointment(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<AppointmentData>>

    @POST(URLFactory.Doctor.CLINIC_DOCTOR_LIST)
    suspend fun clinicDoctorList(@Body apiRequest: ApiRequest): ResponseBody<DoctorClinicListResData>

    @POST(URLFactory.Doctor.GET_APPOINTMENT_LIST)
    suspend fun getAppointmentList(@Body apiRequest: ApiRequest): ResponseBody<GetAppointmentListResData>

    @POST(URLFactory.Doctor.ADD_APPOINTMENT)
    suspend fun addAppointment(@Body apiRequest: ApiRequest): ResponseBody<AppointmentData>

    @POST(URLFactory.Doctor.APPOINTMENT_TIME_SLOT)
    suspend fun appointmentTimeSlot(@Body apiRequest: ApiRequest): ResponseBody<AppointmentTimeSlotResData>

    @POST(URLFactory.Doctor.CANCEL_APPOINTMENT)
    suspend fun cancelAppointment(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Doctor.GET_VOICETOKEN)
    suspend fun getVoiceToken(@Body apiRequest: ApiRequest): ResponseBody<GetVoiceTokenData>

    @POST(URLFactory.Doctor.FETCH_VIDEOCALL_DATA)
    suspend fun fetchVideoCallData(@Body apiRequest: ApiRequest): ResponseBody<AppointmentData>

    @POST(URLFactory.Doctor.CHECK_BCP_HC_DETAILS)
    suspend fun checkBCPHCDetails(): ResponseBody<BCPScheduleAppointmentData>

    @POST(URLFactory.Doctor.GET_BCP_TIME_SLOTS)
    suspend fun getBcpTimeSlots(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<TimeSlotData>>

    @POST(URLFactory.Doctor.UPDATE_BCP_HC_DETAILS)
    suspend fun updateBcpHCDetails(@Body apiRequest: ApiRequest): ResponseBody<Any>

    // Health coach appointment booking
    @POST(URLFactory.PatientHC.GET_AVAILABLE_SLOTS)
    suspend fun getAvailableSlots(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.PatientHC.UPDATE_APPOINTMENT)
    suspend fun updateAppointment(@Body apiRequest: ApiRequest): ResponseBody<Any>

    //tests APIs
    @POST(URLFactory.Tests.TESTS_LIST)
    suspend fun testsList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<TestPackageData>>

    @POST(URLFactory.Tests.TESTS_LIST_HOME)
    suspend fun testsListHome(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<TestPackageData>>

    @POST(URLFactory.Tests.TESTS_LIST_HOME)
    suspend fun testsListSeparate(@Body apiRequest: ApiRequest): ResponseBody<TestListSeparateData>

    @POST(URLFactory.Tests.TEST_DETAIL)
    suspend fun testDetail(@Body apiRequest: ApiRequest): ResponseBody<TestPackageData>

    @POST(URLFactory.Tests.ADD_TO_CART)
    suspend fun addToCart(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Tests.REMOVE_FROM_CART)
    suspend fun removeFromCart(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Tests.LIST_CART)
    suspend fun listCart(@Body apiRequest: ApiRequest): ResponseBody<ListCartData>

    @POST(URLFactory.Tests.PATIENT_MEMBERS_LIST)
    suspend fun patientMembersList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<TestPatientData>>

    @POST(URLFactory.Tests.UPDATE_PATIENT_MEMBERS)
    suspend fun updatePatientMembers(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Tests.ADDRESS_LIST)
    suspend fun addressList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<TestAddressData>>

    @POST(URLFactory.Tests.UPDATE_ADDRESS)
    suspend fun updateAddress(@Body apiRequest: ApiRequest): ResponseBody<TestAddressData>

    @POST(URLFactory.Tests.DELETE_ADDRESS)
    suspend fun deleteAddress(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Tests.GET_APPOINTMENT_SLOTS)
    suspend fun getAppointmentSlots(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<TimeSlotData>>

    @POST(URLFactory.Tests.PINCODE_AVAILABILITY)
    suspend fun pincodeAvailability(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Tests.BOOK_TEST)
    suspend fun bookTest(@Body apiRequest: ApiRequest): ResponseBody<BookTestResData>

    @POST(URLFactory.Tests.ORDER_SUMMARY)
    suspend fun orderSummary(@Body apiRequest: ApiRequest): ResponseBody<TestOrderSummaryResData>

    @POST(URLFactory.Tests.CONTACT_SUPPORT)
    suspend fun contactSupport(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.Tests.ORDER_HISTORY)
    suspend fun orderHistory(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<HistoryTestOrderData>>

    @POST(URLFactory.Tests.GET_DOWNLOAD_REPORT_URL)
    suspend fun getDownloadReportUrl(@Body apiRequest: ApiRequest): ResponseBody<DownloadReportResData>

    @POST(URLFactory.Tests.CHECK_BOOK_TEST)
    suspend fun checkBookTest(@Body apiRequest: ApiRequest): ResponseBody<String>

    @POST(URLFactory.Tests.GET_CART_INFO)
    suspend fun getCartInfo(@Body apiRequest: ApiRequest): ResponseBody<Cart>
}