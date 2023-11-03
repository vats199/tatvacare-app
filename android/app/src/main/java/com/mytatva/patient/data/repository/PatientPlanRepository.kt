package com.mytatva.patient.data.repository

import com.mytatva.patient.data.pojo.DataWrapper
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

interface PatientPlanRepository {
    suspend fun plansList(apiRequest: ApiRequest): DataWrapper<ArrayList<BcpMainData>>
    suspend fun plansDetailsById(apiRequest: ApiRequest): DataWrapper<BcpDetailsMainData>
    suspend fun addPatientPlan(apiRequest: ApiRequest): DataWrapper<AddPlanResData>
    suspend fun cancelPatientPlan(apiRequest: ApiRequest): DataWrapper<Any>
    suspend fun paymentHistory(apiRequest: ApiRequest): DataWrapper<PaymentHistoryData>
    suspend fun razorpaySubscription(apiRequest: ApiRequest): DataWrapper<RazorPaySubscriptionData>
    suspend fun razorpayOrderId(apiRequest: ApiRequest): DataWrapper<String>
    suspend fun allPaymentHistory(apiRequest: ApiRequest): DataWrapper<ArrayList<PaymentHistorySubData>>
    suspend fun carePlanServices(apiRequest: ApiRequest): DataWrapper<BcpPurchasedData>
    suspend fun myDevices(apiRequest: ApiRequest): DataWrapper<BcpMyDevicesData>

    suspend fun checkIsPlanPurchased(apiRequest: ApiRequest): DataWrapper<BcpPlanData>
    suspend fun discountList(apiRequest: ApiRequest): DataWrapper<ArrayList<CouponCodeData>>
    suspend fun checkDiscount(apiRequest: ApiRequest): DataWrapper<CheckCouponData>
    suspend fun homePlanList(apiRequest: ApiRequest): DataWrapper<ArrayList<BcpPlanData>>
    suspend fun hcDevicePlan(apiRequest: ApiRequest): DataWrapper<HcDevicePlan>
}