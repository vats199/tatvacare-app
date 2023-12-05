package com.mytatva.patient.data.datasource

import com.mytatva.patient.core.Session
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
import com.mytatva.patient.data.pojo.response.PaymentHistoryData
import com.mytatva.patient.data.pojo.response.PaymentHistorySubData
import com.mytatva.patient.data.pojo.response.RazorPaySubscriptionData
import com.mytatva.patient.data.repository.PatientPlanRepository
import com.mytatva.patient.data.service.PatientPlanService
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class PatientPlanLiveDataSource @Inject constructor(private val patientPlanService: PatientPlanService) :
    BaseDataSource(), PatientPlanRepository {

    @Inject
    lateinit var session: Session

    @Inject
    lateinit var analytics: AnalyticsClient

    override suspend fun plansList(apiRequest: ApiRequest): DataWrapper<ArrayList<BcpMainData>> {
        return execute { patientPlanService.plansList(apiRequest) }
    }

    override suspend fun plansDetailsById(apiRequest: ApiRequest): DataWrapper<BcpDetailsMainData> {
        return execute { patientPlanService.plansDetailsById(apiRequest) }
    }

    override suspend fun addPatientPlan(apiRequest: ApiRequest): DataWrapper<AddPlanResData> {
        return execute { patientPlanService.addPatientPlan(apiRequest) }
    }

    override suspend fun cancelPatientPlan(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { patientPlanService.cancelPatientPlan(apiRequest) }
    }

    override suspend fun paymentHistory(apiRequest: ApiRequest): DataWrapper<PaymentHistoryData> {
        return execute { patientPlanService.paymentHistory(apiRequest) }
    }

    override suspend fun razorpaySubscription(apiRequest: ApiRequest): DataWrapper<RazorPaySubscriptionData> {
        return execute { patientPlanService.razorpaySubscription(apiRequest) }
    }

    override suspend fun razorpayOrderId(apiRequest: ApiRequest): DataWrapper<String> {
        return execute { patientPlanService.razorpayOrderId(apiRequest) }
    }

    override suspend fun allPaymentHistory(apiRequest: ApiRequest): DataWrapper<ArrayList<PaymentHistorySubData>> {
        return execute { patientPlanService.allPaymentHistory(apiRequest) }
    }

    override suspend fun carePlanServices(apiRequest: ApiRequest): DataWrapper<BcpPurchasedData> {
        return execute { patientPlanService.carePlanServices(apiRequest) }
    }

    override suspend fun myDevices(apiRequest: ApiRequest): DataWrapper<BcpMyDevicesData> {
        return execute { patientPlanService.myDevices(apiRequest) }
    }

    override suspend fun homePlanList(apiRequest: ApiRequest): DataWrapper<ArrayList<BcpPlanData>> {
        return execute { patientPlanService.homePagePlans(apiRequest) }
    }

    override suspend fun hcDevicePlan(apiRequest: ApiRequest): DataWrapper<HcDevicePlan> {
        return execute { patientPlanService.hcDevicePlan(apiRequest) }
    }

    override suspend fun discountList(apiRequest: ApiRequest): DataWrapper<ArrayList<CouponCodeData>> {
        return execute { patientPlanService.discountList(apiRequest) }
    }

    override suspend fun checkDiscount(apiRequest: ApiRequest): DataWrapper<CheckCouponData> {
        return execute { patientPlanService.checkDiscount(apiRequest) }
    }

    override suspend fun checkIsPlanPurchased(apiRequest: ApiRequest): DataWrapper<BcpPlanData> {
        return execute { patientPlanService.checkIsPlanPurchased(apiRequest) }
    }
}
