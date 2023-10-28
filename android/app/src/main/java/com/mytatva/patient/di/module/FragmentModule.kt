package com.mytatva.patient.di.module

import com.mytatva.patient.di.PerFragment
import com.mytatva.patient.ui.base.BaseFragment
import dagger.Module
import dagger.Provides


@Module
class FragmentModule(private val baseFragment: BaseFragment<*>) {

    @Provides
    @PerFragment
    internal fun provideBaseFragment(): BaseFragment<*> {
        return baseFragment
    }

}