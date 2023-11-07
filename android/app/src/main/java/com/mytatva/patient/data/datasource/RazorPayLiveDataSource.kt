package com.mytatva.patient.data.datasource

import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CreateSubscriptionData
import com.mytatva.patient.data.repository.RazorPayRepository
import com.mytatva.patient.data.service.RazorPayService
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class RazorPayLiveDataSource @Inject constructor(private val razorPayService: RazorPayService) :
    BaseDataSource(), RazorPayRepository {

    @Inject
    lateinit var session: Session

    @Inject
    lateinit var analytics: AnalyticsClient

    override suspend fun subscriptions(apiRequest: ApiRequest): CreateSubscriptionData {
        //return executeCustom { razorPayService.subscriptions(apiRequest) }
        return razorPayService.subscriptions(apiRequest)
    }

    /*override suspend fun plansList(apiRequest: ApiRequest): DataWrapper<ArrayList<PatientPlanMainData>> {
        return execute { patientPlanService.plansList(apiRequest) }
    }

    override suspend fun plansDetailsById(apiRequest: ApiRequest): DataWrapper<PatientPlanData> {
        return execute { patientPlanService.plansDetailsById(apiRequest) }
    }

    override suspend fun addPatientPlan(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { patientPlanService.addPatientPlan(apiRequest) }
    }

    override suspend fun cancelPatientPlan(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { patientPlanService.cancelPatientPlan(apiRequest) }
    }

    override suspend fun paymentHistory(apiRequest: ApiRequest): DataWrapper<Any> {
        return execute { patientPlanService.paymentHistory(apiRequest) }
    }*/

}
