package com.mytatva.patient.data.service

import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CreateSubscriptionData
import retrofit2.http.Body
import retrofit2.http.POST

interface RazorPayService {

    @POST(URLFactory.RazorPay.SUBSCRIPTIONS)
    suspend fun subscriptions(@Body apiRequest: ApiRequest): CreateSubscriptionData

}