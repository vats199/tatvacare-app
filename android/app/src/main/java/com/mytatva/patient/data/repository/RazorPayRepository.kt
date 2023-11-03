package com.mytatva.patient.data.repository

import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CreateSubscriptionData

interface RazorPayRepository {
    suspend fun subscriptions(apiRequest: ApiRequest): CreateSubscriptionData
}