package com.mytatva.patient.di.module

import com.mytatva.patient.data.datasource.*
import com.mytatva.patient.data.repository.*
import com.mytatva.patient.data.service.*
import dagger.Module
import dagger.Provides
import retrofit2.Retrofit
import javax.inject.Named
import javax.inject.Singleton


@Module
class ServiceModule {

    @Provides
    @Singleton
    fun provideAuthRepository(authLiveDataSource: AuthLiveDataSource): AuthRepository {
        return authLiveDataSource
    }

    @Provides
    @Singleton
    fun provideAuthService(@Named("retrofit_app") retrofit: Retrofit): AuthService {
        return retrofit.create(AuthService::class.java)
    }

    @Provides
    @Singleton
    fun provideGoalReadingRepository(goalReadingLiveDataSource: GoalReadingLiveDataSource): GoalReadingRepository {
        return goalReadingLiveDataSource
    }

    @Provides
    @Singleton
    fun provideGoalReadingService(@Named("retrofit_app") retrofit: Retrofit): GoalReadingService {
        return retrofit.create(GoalReadingService::class.java)
    }

    @Provides
    @Singleton
    fun provideEngageContentRepository(engageContentLiveDataSource: EngageContentLiveDataSource): EngageContentRepository {
        return engageContentLiveDataSource
    }

    @Provides
    @Singleton
    fun provideEngageContentService(@Named("retrofit_app") retrofit: Retrofit): EngageContentService {
        return retrofit.create(EngageContentService::class.java)
    }

    @Provides
    @Singleton
    fun providePatientPlanRepository(patientPlanLiveDataSource: PatientPlanLiveDataSource): PatientPlanRepository {
        return patientPlanLiveDataSource
    }

    @Provides
    @Singleton
    fun providePatientPlanService(@Named("retrofit_app") retrofit: Retrofit): PatientPlanService {
        return retrofit.create(PatientPlanService::class.java)
    }

    @Provides
    @Singleton
    fun provideDoctorRepository(doctorLiveDataSource: DoctorLiveDataSource): DoctorRepository {
        return doctorLiveDataSource
    }

    @Provides
    @Singleton
    fun provideDoctorService(@Named("retrofit_app") retrofit: Retrofit): DoctorService {
        return retrofit.create(DoctorService::class.java)
    }

    @Provides
    @Singleton
    fun provideRazorPayRepository(razorPayLiveDataSource: RazorPayLiveDataSource): RazorPayRepository {
        return razorPayLiveDataSource
    }

    @Provides
    @Singleton
    fun provideRazorPayService(@Named("retrofit_razorpay") retrofit: Retrofit): RazorPayService {
        return retrofit.create(RazorPayService::class.java)
    }
}