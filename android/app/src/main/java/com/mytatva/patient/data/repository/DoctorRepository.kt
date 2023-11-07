package com.mytatva.patient.data.repository

import com.mytatva.patient.data.pojo.DataWrapper
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AppointmentData
import com.mytatva.patient.data.pojo.response.AppointmentTimeSlotResData
import com.mytatva.patient.data.pojo.response.BCPScheduleAppointmentData
import com.mytatva.patient.data.pojo.response.BookTestResData
import com.mytatva.patient.data.pojo.response.Cart
import com.mytatva.patient.data.pojo.response.DoctorClinicListResData
import com.mytatva.patient.data.pojo.response.DownloadReportResData
import com.mytatva.patient.data.pojo.response.GetAppointmentListResData
import com.mytatva.patient.data.pojo.response.GetVoiceTokenData
import com.mytatva.patient.data.pojo.response.HistoryTestOrderData
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestListSeparateData
import com.mytatva.patient.data.pojo.response.TestOrderSummaryResData
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.data.pojo.response.TimeSlotData

interface DoctorRepository {
    suspend fun todaysAppointment(apiRequest: ApiRequest): DataWrapper<ArrayList<AppointmentData>>
    suspend fun clinicDoctorList(apiRequest: ApiRequest): DataWrapper<DoctorClinicListResData>
    suspend fun getAppointmentList(apiRequest: ApiRequest): DataWrapper<GetAppointmentListResData>
    suspend fun addAppointment(apiRequest: ApiRequest): DataWrapper<AppointmentData>
    suspend fun appointmentTimeSlot(apiRequest: ApiRequest): DataWrapper<AppointmentTimeSlotResData>
    suspend fun cancelAppointment(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getVoiceToken(apiRequest: ApiRequest): DataWrapper<GetVoiceTokenData>
    suspend fun fetchVideoCallData(apiRequest: ApiRequest): DataWrapper<AppointmentData>
    suspend fun checkBCPHCDetails(): DataWrapper<BCPScheduleAppointmentData>
    suspend fun getBcpTimeSlots(apiRequest: ApiRequest): DataWrapper<ArrayList<TimeSlotData>>
    suspend fun updateBcpHCDetails(apiRequest: ApiRequest): DataWrapper<Any>

    // HC appointment booking
    suspend fun getAvailableSlots(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun updateAppointment(apiRequest: ApiRequest): DataWrapper<Any>

    //tests APIs
    suspend fun testsList(apiRequest: ApiRequest): DataWrapper<ArrayList<TestPackageData>>
    suspend fun testsListHome(apiRequest: ApiRequest): DataWrapper<ArrayList<TestPackageData>>
    suspend fun testsListSeparate(apiRequest: ApiRequest): DataWrapper<TestListSeparateData>
    suspend fun testDetail(apiRequest: ApiRequest): DataWrapper<TestPackageData>

    suspend fun addToCart(apiRequest: ApiRequest, labTestId: String, screenName: String): DataWrapper<Any>
    suspend fun removeFromCart(apiRequest: ApiRequest, labTestId: String, screenName: String): DataWrapper<Any>
    suspend fun listCart(apiRequest: ApiRequest): DataWrapper<ListCartData>

    suspend fun patientMembersList(apiRequest: ApiRequest): DataWrapper<ArrayList<TestPatientData>>
    suspend fun updatePatientMembers(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun addressList(apiRequest: ApiRequest): DataWrapper<ArrayList<TestAddressData>>
    suspend fun updateAddress(apiRequest: ApiRequest): DataWrapper<TestAddressData>
    suspend fun deleteAddress(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun getAppointmentSlots(apiRequest: ApiRequest): DataWrapper<ArrayList<TimeSlotData>>
    suspend fun pincodeAvailability(apiRequest: ApiRequest): DataWrapper<Any>

    suspend fun bookTest(apiRequest: ApiRequest): DataWrapper<BookTestResData>
    suspend fun orderSummary(apiRequest: ApiRequest): DataWrapper<TestOrderSummaryResData>
    suspend fun contactSupport(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun orderHistory(apiRequest: ApiRequest): DataWrapper<ArrayList<HistoryTestOrderData>>

    suspend fun getDownloadReportUrl(apiRequest: ApiRequest): DataWrapper<DownloadReportResData>

    suspend fun checkBookTest(apiRequest: ApiRequest): DataWrapper<String>

    suspend fun getCartInfo(apiRequest: ApiRequest): DataWrapper<Cart>
}