package com.mytatva.patient.ui.viewmodel

import androidx.lifecycle.viewModelScope
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.AddPlanResData
import com.mytatva.patient.data.pojo.response.BcpDetailsMainData
import com.mytatva.patient.data.pojo.response.BcpMainData
import com.mytatva.patient.data.pojo.response.BcpMyDevicesData
import com.mytatva.patient.data.pojo.response.BcpPlanData
import com.mytatva.patient.data.pojo.response.BcpPurchasedData
import com.mytatva.patient.data.pojo.response.CheckCouponData
import com.mytatva.patient.data.pojo.response.CouponCodeData
import com.mytatva.patient.data.pojo.response.HcDevicePlan
import com.mytatva.patient.data.pojo.response.MyHealthInsightData
import com.mytatva.patient.data.pojo.response.PaymentHistoryData
import com.mytatva.patient.data.pojo.response.PaymentHistorySubData
import com.mytatva.patient.data.pojo.response.RazorPaySubscriptionData
import com.mytatva.patient.data.repository.PatientPlanRepository
import com.mytatva.patient.ui.base.APILiveData
import com.mytatva.patient.ui.base.BaseViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

class PatientPlansViewModel @Inject constructor(
    private val patientPlanRepository: PatientPlanRepository,
) : BaseViewModel() {

    // Goal Readings APIs
    /**
     * @API :- plansList
     */
    val plansListLiveData = APILiveData<ArrayList<BcpMainData>>()
    fun plansList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.plansList(apiRequest)
            plansListLiveData.value = result
        }
    }

    /**
     * @API :- plansDetailsById
     */
    val plansDetailsByIdLiveData = APILiveData<BcpDetailsMainData>()
    fun plansDetailsById(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.plansDetailsById(apiRequest)
            plansDetailsByIdLiveData.value = result
        }
    }

    /**
     * @API :- plansDetailsById
     */
    val addPatientPlanLiveData = APILiveData<AddPlanResData>()
    fun addPatientPlan(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.addPatientPlan(apiRequest)
            addPatientPlanLiveData.value = result
        }
    }

    /**
     * @API :- plansDetailsById
     */
    val cancelPatientPlanLiveData = APILiveData<Any>()
    fun cancelPatientPlan(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.cancelPatientPlan(apiRequest)
            cancelPatientPlanLiveData.value = result
        }
    }

    /**
     * @API :- plansDetailsById
     */
    val paymentHistoryLiveData = APILiveData<PaymentHistoryData>()
    fun paymentHistory(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.paymentHistory(apiRequest)
            paymentHistoryLiveData.value = result
        }
    }

    /**
     * @API :- razorpaySubscription
     */
    val razorpaySubscriptionLiveData = APILiveData<RazorPaySubscriptionData>()
    fun razorpaySubscription(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.razorpaySubscription(apiRequest)
            razorpaySubscriptionLiveData.value = result
        }
    }


    /**
     * @API :- razorpaySubscription
     */
    val razorpayOrderIdLiveData = APILiveData<String>()
    fun razorpayOrderId(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.razorpayOrderId(apiRequest)
            razorpayOrderIdLiveData.value = result
        }
    }

    /**
     * @API :- allPaymentHistory
     */
    val allPaymentHistoryLiveData = APILiveData<ArrayList<PaymentHistorySubData>>()
    fun allPaymentHistory(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.allPaymentHistory(apiRequest)
            allPaymentHistoryLiveData.value = result
        }
    }

    /**
     * @API :- carePlanServices
     */
    val carePlanServicesLiveData = APILiveData<BcpPurchasedData>()
    fun carePlanServices(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.carePlanServices(apiRequest)
            carePlanServicesLiveData.value = result
        }
    }

    /**
     * @API :- myDevices
     */
    val myDevicesLiveData = APILiveData<BcpMyDevicesData>()
    fun myDevices(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.myDevices(apiRequest)
            myDevicesLiveData.value = result
        }
    }

    /**
     * @API :- HomePlansList
     */
    val homePlansListLiveData = APILiveData<ArrayList<BcpPlanData>>()
    fun homePlansList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.homePlanList(apiRequest)
            homePlansListLiveData.value = result
        }
    }

    /**
     * @API :- hcDevicePlan
     */
    val hcDevicePlanLiveData = APILiveData<HcDevicePlan>()
    fun hcDevicePlan(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.hcDevicePlan(apiRequest)
            hcDevicePlanLiveData.value = result
        }
    }
    
     /**
     * @API :- checkIsPlanPurchased
     */
    val checkIsPlanPurchasedLiveData = APILiveData<BcpPlanData>()
    fun checkIsPlanPurchased(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.checkIsPlanPurchased(apiRequest)
            checkIsPlanPurchasedLiveData.value = result
        }
    }

    /**
     * @API :- discountList
     */
    val discountListLiveData = APILiveData<ArrayList<CouponCodeData>>()
    fun discountList(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.discountList(apiRequest)
            discountListLiveData.value = result
        }
    }

    /**
     * @API :- checkDiscount
     */
    val checkDiscountLiveData = APILiveData<CheckCouponData>()
    fun checkDiscount(apiRequest: ApiRequest) {
        viewModelScope.launch {
            val result = patientPlanRepository.checkDiscount(apiRequest)
            checkDiscountLiveData.value = result
        }
    }
}