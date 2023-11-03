package com.mytatva.patient.di.component


import com.mytatva.patient.di.PerActivity
import com.mytatva.patient.di.module.ActivityModule
import com.mytatva.patient.di.module.FragmentModule
import com.mytatva.patient.ui.activity.*
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.home.HomeActivity
import com.mytatva.patient.ui.home.RNHomeActivity
import com.mytatva.patient.ui.manager.Navigator
import com.mytatva.patient.ui.splash.SplashActivity
import dagger.BindsInstance
import dagger.Component

/**
 * Created by hlink21 on 9/5/16.
 */
@PerActivity
@Component(dependencies = [ApplicationComponent::class], modules = arrayOf(ActivityModule::class))
interface ActivityComponent {

    fun activity(): BaseActivity

    fun navigator(): Navigator

    operator fun plus(fragmentModule: FragmentModule): FragmentComponent

    fun inject(mainActivity: HomeActivity)
    fun inject(mainActivity: SplashActivity)
    fun inject(authActivity: AuthActivity)
    fun inject(isolatedFullActivity: IsolatedFullActivity)
    fun inject(transparentActivity: TransparentActivity)
    fun inject(videoPlayerActivity: VideoPlayerActivity)
    fun inject(videoActivity: VideoActivity)
    fun inject(rNHomeActivity: RNHomeActivity)

    @Component.Builder
    interface Builder {

        fun bindApplicationComponent(applicationComponent: ApplicationComponent): Builder

        @BindsInstance
        fun bindActivity(baseActivity: BaseActivity): Builder

        fun build(): ActivityComponent
    }
}
