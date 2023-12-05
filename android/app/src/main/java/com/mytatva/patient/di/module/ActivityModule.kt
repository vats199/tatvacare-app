package com.mytatva.patient.di.module

import com.mytatva.patient.di.PerActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.manager.FragmentHandler
import com.mytatva.patient.ui.manager.Navigator
import dagger.Module
import dagger.Provides
import javax.inject.Named


@Module
class ActivityModule {

    @Provides
    @PerActivity
    internal fun navigator(activity: BaseActivity): Navigator {
        return activity
    }

    @Provides
    @PerActivity
    internal fun fragmentManager(baseActivity: BaseActivity): androidx.fragment.app.FragmentManager {
        return baseActivity.supportFragmentManager
    }

    @Provides
    @PerActivity
    @Named("placeholder")
    internal fun placeHolder(baseActivity: BaseActivity): Int {
        return baseActivity.findFragmentPlaceHolder()
    }

    @Provides
    @PerActivity
    internal fun fragmentHandler(fragmentManager: com.mytatva.patient.ui.manager.FragmentManager): FragmentHandler {
        return fragmentManager
    }


}
