package com.mytatva.patient.di.component

import com.mytatva.patient.di.PerService
import com.mytatva.patient.fcm.MyFirebaseMessagingService
import com.mytatva.patient.service.SyncGoogleFitService
import dagger.Component

//import com.mytatva.patient.service.SyncGoogleFitService;
@PerService
@Component(dependencies = [ApplicationComponent::class])
interface ServiceComponent {
    fun inject(service: SyncGoogleFitService)
    fun inject(service: MyFirebaseMessagingService)
}