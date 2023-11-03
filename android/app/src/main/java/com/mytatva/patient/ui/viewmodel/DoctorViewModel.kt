package com.mytatva.patient.ui.viewmodel

import androidx.lifecycle.viewModelScope
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
import com.mytatva.patient.data.repository.DoctorRepository
import com.mytatva.patient.ui.base.APILiveData
import com.mytatva.patient.ui.base.BaseViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

class DoctorViewModel @Inject constructor(
    private val doctorRepository: DoctorRepository,
) : BaseViewModel() {
    /**
     * @API :- todaysAppointment
     */
    val todaysAppointmentLiveData = APILiveData<ArrayList<AppointmentData>>()
    fun todaysAppointment(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.todaysAppointment(apiRequest)
            todaysAppointmentLiveData.value = result
        }
    }

    /**
     * @API :- clinicDoctorList
     */
    val clinicDoctorListLiveData = APILiveData<DoctorClinicListResData>()
    fun clinicDoctorList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.clinicDoctorList(apiRequest)
            clinicDoctorListLiveData.value = result
        }
    }

    /**
     * @API :- getAppointmentList
     */
    val getAppointmentListLiveData = APILiveData<GetAppointmentListResData>()
    fun getAppointmentList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.getAppointmentList(apiRequest)
            getAppointmentListLiveData.value = result
        }
    }

    /**
     * @API :- addAppointment
     */
    val addAppointmentLiveData = APILiveData<AppointmentData>()
    fun addAppointment(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.addAppointment(apiRequest)
            addAppointmentLiveData.value = result
        }
    }

    /**
     * @API :- appointmentTimeSlot
     */
    val appointmentTimeSlotLiveData = APILiveData<AppointmentTimeSlotResData>()
    fun appointmentTimeSlot(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.appointmentTimeSlot(apiRequest)
            appointmentTimeSlotLiveData.value = result
        }
    }

    /**
     * @API :- appointmentTimeSlot
     */
    val cancelAppointmentLiveData = APILiveData<Any>()
    fun cancelAppointment(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.cancelAppointment(apiRequest)
            cancelAppointmentLiveData.value = result
        }
    }

    /**
     * @API :- getVoiceToken
     * @params :- room_id, room_name, type,
     * appointment_id (added this new req param in API to send reminder push)
     */
    val getVoiceTokenLiveData = APILiveData<GetVoiceTokenData>()
    fun getVoiceToken(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.getVoiceToken(apiRequest)
            getVoiceTokenLiveData.value = result
        }
    }

    /**
     * @API :- fetchVideocallData
     */
    val fetchVideocallDataLiveData = APILiveData<AppointmentData>()
    fun fetchVideoCallData(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.fetchVideoCallData(apiRequest)
            fetchVideocallDataLiveData.value = result
        }
    }

    /**
     * @API :- checkBCPHCDetails
     */
    val checkBCPHCDetailsLiveData = APILiveData<BCPScheduleAppointmentData>()
    fun checkBCPHCDetails() {
        viewModelScope.launch {
            val result = doctorRepository.checkBCPHCDetails()
            checkBCPHCDetailsLiveData.value = result
        }
    }

    /**
     * @API :- getBcpTimeSlots
     */
    val getBcpTimeSlotsLiveData = APILiveData<ArrayList<TimeSlotData>>()
    fun getBcpTimeSlots(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.getBcpTimeSlots(apiRequest)
            getBcpTimeSlotsLiveData.value = result
        }
    }

    /**
     * @API :- getBcpTimeSlots
     */
    val updateBcpHCDetailsLiveData = APILiveData<Any>()
    fun updateBcpHCDetails(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.updateBcpHCDetails(apiRequest)
            updateBcpHCDetailsLiveData.value = result
        }
    }

    /* ********* HC appointment booking APIs ********* */

    /**
     * @API :- getAvailableSlots
     */
    val getAvailableSlotsLiveData = APILiveData<Any>()
    fun getAvailableSlots(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.getAvailableSlots(apiRequest)
            getAvailableSlotsLiveData.value = result
        }
    }

    /**
     * @API :- updateAppointment
     */
    val updateAppointmentLiveData = APILiveData<Any>()
    fun updateAppointment(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.updateAppointment(apiRequest)
            updateAppointmentLiveData.value = result
        }
    }

    /* ********* TEST APIs ********* */

    /**
     * @API :- testsList
     */
    val testsListLiveData = APILiveData<ArrayList<TestPackageData>>()
    fun testsList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.testsList(apiRequest)
            testsListLiveData.value = result
        }
    }

    /**
     * @API :- testsListHome
     */
    val testsListHomeLiveData = APILiveData<ArrayList<TestPackageData>>()
    fun testsListHome(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.testsListHome(apiRequest)
            testsListHomeLiveData.value = result
        }
    }

    /**
     * @API :- testsListHome - same API handle with different livedata for care plan
     */
    val testsListCarePlanLiveData = APILiveData<ArrayList<TestPackageData>>()
    fun testsListCarePlan(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.testsListHome(apiRequest)
            testsListCarePlanLiveData.value = result
        }
    }

    /**
     * @API :- testsListHome
     */
    val testsListSeparateLiveData = APILiveData<TestListSeparateData>()
    fun testsListSeparate() {
        viewModelScope.launch {
            val result = doctorRepository.testsListSeparate(ApiRequest().apply {
                separate = "Yes"
            })
            testsListSeparateLiveData.value = result
        }
    }

    /**
     * @API :- testDetail
     */
    val testDetailLiveData = APILiveData<TestPackageData>()
    fun testDetail(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.testDetail(apiRequest)
            testDetailLiveData.value = result
        }
    }

    /**
     * @API :- addToCart
     */
    val addToCartLiveData = APILiveData<Any>()
    fun addToCart(apiRequest: ApiRequest, labTestId: String,screenName:String) {
        viewModelScope.launch {
            val result = doctorRepository.addToCart(apiRequest, labTestId,screenName)
            addToCartLiveData.value = result
        }
    }

    /**
     * @API :- removeFromCart
     */
    val removeFromCartLiveData = APILiveData<Any>()
    fun removeFromCart(apiRequest: ApiRequest, labTestId: String,screenName:String) {
        viewModelScope.launch {
            val result = doctorRepository.removeFromCart(apiRequest, labTestId,screenName)
            removeFromCartLiveData.value = result
        }
    }

    /**
     * @API :- listCart
     */
    val listCartLiveData = APILiveData<ListCartData>()
    fun listCart(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.listCart(apiRequest)
            listCartLiveData.value = result
        }
    }

    /**
     * @API :- patientMembersList
     */
    val patientMembersListLiveData = APILiveData<ArrayList<TestPatientData>>()
    fun patientMembersList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.patientMembersList(apiRequest)
            patientMembersListLiveData.value = result
        }
    }

    /**
     * @API :- updatePatientMembers
     */
    val updatePatientMembersLiveData = APILiveData<Any>()
    fun updatePatientMembers(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.updatePatientMembers(apiRequest)
            updatePatientMembersLiveData.value = result
        }
    }

    /**
     * @API :- addressList
     */
    val addressListLiveData = APILiveData<ArrayList<TestAddressData>>()
    fun addressList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.addressList(apiRequest)
            addressListLiveData.value = result
        }
    }

    /**
     * @API :- updateAddress
     */
    val updateAddressLiveData = APILiveData<TestAddressData>()
    fun updateAddress(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.updateAddress(apiRequest)
            updateAddressLiveData.value = result
        }
    }

    /**
     * @API :- deleteAddress
     */
    val deleteAddressLiveData = APILiveData<Any>()
    fun deleteAddress(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.deleteAddress(apiRequest)
            deleteAddressLiveData.value = result
        }
    }

    /**
     * @API :- getAppointmentSlots
     */
    val getAppointmentSlotsLiveData = APILiveData<ArrayList<TimeSlotData>>()
    fun getAppointmentSlots(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.getAppointmentSlots(apiRequest)
            getAppointmentSlotsLiveData.value = result
        }
    }

    /**
     * @API :- pincodeAvailability
     */
    val pincodeAvailabilityLiveData = APILiveData<Any>()
    fun pincodeAvailability(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.pincodeAvailability(apiRequest)
            pincodeAvailabilityLiveData.value = result
        }
    }

    /**
     * @API :- bookTest
     */
    val bookTestLiveData = APILiveData<BookTestResData>()
    fun bookTest(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.bookTest(apiRequest)
            bookTestLiveData.value = result
        }
    }

    /**
     * @API :- orderSummary
     */
    val orderSummaryLiveData = APILiveData<TestOrderSummaryResData>()
    fun orderSummary(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.orderSummary(apiRequest)
            orderSummaryLiveData.value = result
        }
    }

    /**
     * @API :- contactSupport
     */
    val contactSupportLiveData = APILiveData<Any>()
    fun contactSupport(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.contactSupport(apiRequest)
            contactSupportLiveData.value = result
        }
    }

    /**
     * @API :- orderHistory
     */
    val orderHistoryLiveData = APILiveData<ArrayList<HistoryTestOrderData>>()
    fun orderHistory(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.orderHistory(apiRequest)
            orderHistoryLiveData.value = result
        }
    }

    /**
     * @API :- getDownloadReportUrl
     */
    val getDownloadReportUrlLiveData = APILiveData<DownloadReportResData>()
    fun getDownloadReportUrl(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.getDownloadReportUrl(apiRequest)
            getDownloadReportUrlLiveData.value = result
        }
    }

    /**
     * @API :- getDownloadReportUrl
     */
    val checkBookTestLiveData = APILiveData<String>()
    fun checkBookTest(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = doctorRepository.checkBookTest(apiRequest)
            checkBookTestLiveData.value = result
        }
    }

    /**
     * @API :- getCartInfo
     */
    val getCartInfoLiveData = APILiveData<Cart>()
    fun getCartInfo() {
        viewModelScope.launch {
            val result = doctorRepository.getCartInfo(ApiRequest())
            getCartInfoLiveData.value = result
        }
    }
}