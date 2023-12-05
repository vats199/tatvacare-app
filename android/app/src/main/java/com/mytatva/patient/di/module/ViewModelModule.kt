package com.mytatva.patient.di.module

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.di.ViewModelKey
import com.mytatva.patient.ui.base.ViewModelFactory
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.ui.viewmodel.EngageContentViewModel
import com.mytatva.patient.ui.viewmodel.GoalReadingViewModel
import com.mytatva.patient.ui.viewmodel.PatientPlansViewModel
import com.mytatva.patient.ui.viewmodel.RazorPayViewModel
import dagger.Binds
import dagger.Module
import dagger.multibindings.IntoMap

@Module
abstract class ViewModelModule {

    @Binds
    abstract fun bindViewModelFactory(factory: ViewModelFactory): ViewModelProvider.Factory

    @Binds
    @IntoMap
    @ViewModelKey(AuthViewModel::class)
    abstract fun bindLoginViewModel(authViewModel: AuthViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(GoalReadingViewModel::class)
    abstract fun bindGoalReadingViewModel(goalReadingViewModel: GoalReadingViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(EngageContentViewModel::class)
    abstract fun bindEngageContentViewModel(engageContentViewModel: EngageContentViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(PatientPlansViewModel::class)
    abstract fun bindPatientPlansViewModel(patientPlansViewModel: PatientPlansViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(RazorPayViewModel::class)
    abstract fun bindRazorPayViewModel(razorPayViewModel: RazorPayViewModel): ViewModel

    @Binds
    @IntoMap
    @ViewModelKey(DoctorViewModel::class)
    abstract fun bindDoctorViewModel(doctorViewModel: DoctorViewModel): ViewModel

}