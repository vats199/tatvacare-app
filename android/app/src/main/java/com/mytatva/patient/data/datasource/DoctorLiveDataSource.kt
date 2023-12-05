package com.mytatva.patient.data.datasource

import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.DataWrapper
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AddToCartData
import com.mytatva.patient.data.pojo.response.AppointmentData
import com.mytatva.patient.data.pojo.response.AppointmentTimeSlotResData
import com.mytatva.patient.data.pojo.response.BCPScheduleAppointmentData
import com.mytatva.patient.data.pojo.response.BcpTestMainData
import com.mytatva.patient.data.pojo.response.BookTestResData
import com.mytatva.patient.data.pojo.response.Cart
import com.mytatva.patient.data.pojo.response.CatalogListData
import com.mytatva.patient.data.pojo.response.ConfirmationPaymentData
import com.mytatva.patient.data.pojo.response.DoctorClinicListResData
import com.mytatva.patient.data.pojo.response.DownloadReportResData
import com.mytatva.patient.data.pojo.response.GetAppointmentListResData
import com.mytatva.patient.data.pojo.response.GetVoiceTokenData
import com.mytatva.patient.data.pojo.response.HistoryTestOrderData
import com.mytatva.patient.data.pojo.response.LabTestTimeSlotData
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestListSeparateData
import com.mytatva.patient.data.pojo.response.TestOrderSummaryResData
import com.mytatva.patient.data.pojo.response.TestPackageData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.data.pojo.response.TimeSlotData
import com.mytatva.patient.data.repository.DoctorRepository
import com.mytatva.patient.data.service.DoctorService
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class DoctorLiveDataSource @Inject constructor(private val doctorService: DoctorService) :
    BaseDataSource(), DoctorRepository {

    @Inject
    lateinit var session: Session

    @Inject
    lateinit var analytics: AnalyticsClient

    override suspend fun todaysAppointment(apiRequest: ApiRequest): DataWrapper<ArrayList<AppointmentData>> {
        return execute { doctorService.todaysAppointment(apiRequest) }
    }

    override suspend fun clinicDoctorList(apiRequest: ApiRequest): DataWrapper<DoctorClinicListResData> {
        return execute { doctorService.clinicDoctorList(apiRequest) }
    }

    override suspend fun getAppointmentList(apiRequest: ApiRequest): DataWrapper<GetAppointmentListResData> {
        return execute { doctorService.getAppointmentList(apiRequest) }
    }

    override suspend fun addAppointment(apiRequest: ApiRequest): DataWrapper<AppointmentData> {
        return execute { doctorService.addAppointment(apiRequest) }
    }

    override suspend fun appointmentTimeSlot(apiRequest: ApiRequest): DataWrapper<AppointmentTimeSlotResData> {
        return execute { doctorService.appointmentTimeSlot(apiRequest) }
    }

    override suspend fun cancelAppointment(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.cancelAppointment(apiRequest) }
    }

    override suspend fun getVoiceToken(apiRequest: ApiRequest): DataWrapper<GetVoiceTokenData> {
        return execute { doctorService.getVoiceToken(apiRequest) }
    }

    override suspend fun fetchVideoCallData(apiRequest: ApiRequest): DataWrapper<AppointmentData> {
        return execute { doctorService.fetchVideoCallData(apiRequest) }
    }

    override suspend fun checkBCPHCDetails(): DataWrapper<BCPScheduleAppointmentData> {
        return execute { doctorService.checkBCPHCDetails() }
    }

    override suspend fun getBcpTimeSlots(apiRequest: ApiRequest): DataWrapper<ArrayList<TimeSlotData>> {
        return execute { doctorService.getBcpTimeSlots(apiRequest) }
    }

    override suspend fun updateBcpHCDetails(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.updateBcpHCDetails(apiRequest) }
    }

    override suspend fun getAvailableSlots(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.getAvailableSlots(apiRequest) }
    }

    override suspend fun updateAppointment(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.updateAppointment(apiRequest) }
    }

    override suspend fun testsList(apiRequest: ApiRequest): DataWrapper<ArrayList<TestPackageData>> {
        return execute { doctorService.testsList(apiRequest) }
    }

    override suspend fun testsListHome(apiRequest: ApiRequest): DataWrapper<ArrayList<TestPackageData>> {
        return execute { doctorService.testsListHome(apiRequest) }
    }

    override suspend fun testsListSeparate(apiRequest: ApiRequest): DataWrapper<TestListSeparateData> {
        return execute { doctorService.testsListSeparate(apiRequest) }
    }

    override suspend fun testDetail(apiRequest: ApiRequest): DataWrapper<TestPackageData> {
        return execute { doctorService.testDetail(apiRequest) }
    }

    override suspend fun addToCart(
        apiRequest: ApiRequest,
        labTestId: String,
        screenName: String,
    ): DataWrapper<AddToCartData> {
        return execute { doctorService.addToCart(apiRequest) }.apply {
        }
    }

    override suspend fun removeFromCart(
        apiRequest: ApiRequest,
        labTestId: String,
        screenName: String,
    ): DataWrapper<Any> {
        return execute { doctorService.removeFromCart(apiRequest) }.apply {
        }
    }

    override suspend fun listCart(apiRequest: ApiRequest): DataWrapper<ListCartData> {
        return execute { doctorService.listCart(apiRequest) }
    }

    override suspend fun patientMembersList(apiRequest: ApiRequest): DataWrapper<ArrayList<TestPatientData>> {
        return execute { doctorService.patientMembersList(apiRequest) }
    }

    override suspend fun updatePatientMembers(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.updatePatientMembers(apiRequest) }
    }

    override suspend fun addressList(apiRequest: ApiRequest): DataWrapper<ArrayList<TestAddressData>> {
        return execute { doctorService.addressList(apiRequest) }
    }

    override suspend fun updateAddress(apiRequest: ApiRequest): DataWrapper<TestAddressData> {
        return execute { doctorService.updateAddress(apiRequest) }
    }

    override suspend fun deleteAddress(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.deleteAddress(apiRequest) }
    }

    override suspend fun getAppointmentSlots(apiRequest: ApiRequest): DataWrapper<ArrayList<LabTestTimeSlotData>> {
        return execute { doctorService.getAppointmentSlots(apiRequest) }
    }

    override suspend fun pincodeAvailability(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.pincodeAvailability(apiRequest) }
    }

    override suspend fun bookTest(apiRequest: ApiRequest): DataWrapper<BookTestResData> {
        return execute { doctorService.bookTest(apiRequest) }.apply {
        }
    }

    override suspend fun orderSummary(apiRequest: ApiRequest): DataWrapper<TestOrderSummaryResData> {
        return execute { doctorService.orderSummary(apiRequest) }
    }

    override suspend fun contactSupport(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.contactSupport(apiRequest) }
    }

    override suspend fun orderHistory(apiRequest: ApiRequest): DataWrapper<ArrayList<HistoryTestOrderData>> {
        return execute { doctorService.orderHistory(apiRequest) }
    }

    override suspend fun getDownloadReportUrl(apiRequest: ApiRequest): DataWrapper<DownloadReportResData> {
        return execute { doctorService.getDownloadReportUrl(apiRequest) }
    }

    override suspend fun cancelLabTest(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.cancelLabTest(apiRequest) }
    }

    override suspend fun checkBookTest(apiRequest: ApiRequest): DataWrapper<String> {
        return execute { doctorService.checkBookTest(apiRequest) }
    }

    override suspend fun getCartInfo(apiRequest: ApiRequest): DataWrapper<Cart> {
        return execute { doctorService.getCartInfo(apiRequest) }.apply {
            if (responseBody?.responseCode == Common.ResponseCode.SUCCESS
                && responseBody.data != null
            ) {
                session.cart = responseBody.data
            } else {
                session.cart = null
            }
        }
    }

    override suspend fun catalogList(apiRequest: ApiRequest): DataWrapper<ArrayList<CatalogListData>> {
        return execute { doctorService.catalogList(apiRequest) }
    }

    override suspend fun searchCatalogList(apiRequest: ApiRequest): DataWrapper<ArrayList<TestPackageData>> {
        return execute { doctorService.searchCatalogList(apiRequest) }
    }

    override suspend fun catalogListAll(apiRequest: ApiRequest): DataWrapper<ArrayList<TestPackageData>> {
        return execute { doctorService.catalogListAll(apiRequest) }
    }

    override suspend fun catalogDetails(apiRequest: ApiRequest): DataWrapper<TestPackageData> {
        return execute { doctorService.catalogDetails(apiRequest) }
    }

    override suspend fun confirmationOrder(apiRequest: ApiRequest): DataWrapper<ConfirmationPaymentData> {
        return execute { doctorService.confirmationOrder(apiRequest) }
    }

    override suspend fun rescheduleLabTest(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { doctorService.rescheduleLabTest(apiRequest) }
    }

    override suspend fun getNearByExpireBCPData(apiRequest: ApiRequest): DataWrapper<BcpTestMainData> {
        return execute { doctorService.getNearByExpireBCPData(apiRequest) }
    }
}