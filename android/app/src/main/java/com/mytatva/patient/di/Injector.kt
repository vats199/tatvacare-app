package com.mytatva.patient.di


import android.app.Application
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.di.component.DaggerApplicationComponent


/**
 * Created by hlink21 on 9/5/16.
 */
enum class Injector private constructor() {
    INSTANCE;

    lateinit var applicationComponent: ApplicationComponent
        internal set

    fun initAppComponent(application: Application, apiKey: String) {
        applicationComponent = DaggerApplicationComponent.builder()
                .application(application)
                .apiKey(apiKey)
                .build()
    }
}
