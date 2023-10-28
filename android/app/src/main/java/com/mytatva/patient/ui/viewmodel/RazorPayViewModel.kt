package com.mytatva.patient.ui.viewmodel

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.viewModelScope
import com.mytatva.patient.data.pojo.Error
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.CreateSubscriptionData
import com.mytatva.patient.data.repository.RazorPayRepository
import com.mytatva.patient.ui.base.BaseViewModel
import kotlinx.coroutines.launch
import javax.inject.Inject

class RazorPayViewModel @Inject constructor(
    private val razorPayRepository: RazorPayRepository,
) : BaseViewModel() {

    /**
     * @API :- createSubscriptions
     */
    val createSubscriptionsLiveData = MutableLiveData<CreateSubscriptionData>()
    fun createSubscriptions(apiRequest: ApiRequest) {
        viewModelScope.launch {
            try {
                val result = razorPayRepository.subscriptions(apiRequest)
                createSubscriptionsLiveData.value = result
            } catch (e: Exception) {
                val createSubscriptionData = CreateSubscriptionData()
                createSubscriptionData.apply {
                    error = Error().apply {
                        description = e.message
                    }
                }
                createSubscriptionsLiveData.value = createSubscriptionData
                e.printStackTrace()
            }
        }
    }

}