package com.mytatva.patient.data.service

import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.pojo.ResponseBody
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.*
import retrofit2.http.Body
import retrofit2.http.POST

interface PatientPlanService {

    @POST(URLFactory.PatientPlans.PLANS_LIST)
    suspend fun plansList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<BcpMainData>>

    @POST(URLFactory.PatientPlans.PLANS_DETAILS_BY_ID)
    suspend fun plansDetailsById(@Body apiRequest: ApiRequest): ResponseBody<BcpDetailsMainData>

    @POST(URLFactory.PatientPlans.ADD_PATIENT_PLAN)
    suspend fun addPatientPlan(@Body apiRequest: ApiRequest): ResponseBody<AddPlanResData>

    @POST(URLFactory.PatientPlans.CANCEL_PATIENT_PLAN)
    suspend fun cancelPatientPlan(@Body apiRequest: ApiRequest): ResponseBody<Any>

    @POST(URLFactory.PatientPlans.PAYMENT_HISTORY)
    suspend fun paymentHistory(@Body apiRequest: ApiRequest): ResponseBody<PaymentHistoryData>

    @POST(URLFactory.PatientPlans.RAZORPAY_SUBSCRIPTION)
    suspend fun razorpaySubscription(@Body apiRequest: ApiRequest): ResponseBody<RazorPaySubscriptionData>

    @POST(URLFactory.PatientPlans.RAZORPAY_ORDER_ID)
    suspend fun razorpayOrderId(@Body apiRequest: ApiRequest): ResponseBody<String>

    @POST(URLFactory.PatientPlans.ALL_PAYMENT_HISTORY)
    suspend fun allPaymentHistory(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<PaymentHistorySubData>>

    @POST(URLFactory.PatientPlans.CARE_PLAN_SERVICES)
    suspend fun carePlanServices(@Body apiRequest: ApiRequest): ResponseBody<BcpPurchasedData>

    @POST(URLFactory.PatientPlans.MY_DEVICES)
    suspend fun myDevices(@Body apiRequest: ApiRequest): ResponseBody<BcpMyDevicesData>

    @POST(URLFactory.PatientPlans.HOME_CARE_PLAN)
    suspend fun homePagePlans(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<BcpPlanData>>

    @POST(URLFactory.PatientPlans.HC_DEVICE_PLAN)
    suspend fun hcDevicePlan(@Body apiRequest: ApiRequest): ResponseBody<HcDevicePlan>


    @POST(URLFactory.PatientPlans.CHECK_IS_PLAN_PURCHASED)
    suspend fun checkIsPlanPurchased(@Body apiRequest: ApiRequest): ResponseBody<BcpPlanData>

    @POST(URLFactory.PatientPlans.DISCOUNT_LIST)
    suspend fun discountList(@Body apiRequest: ApiRequest): ResponseBody<ArrayList<CouponCodeData>>

    @POST(URLFactory.PatientPlans.CHECK_DISCOUNT)
    suspend fun checkDiscount(@Body apiRequest: ApiRequest): ResponseBody<CheckCouponData>
}