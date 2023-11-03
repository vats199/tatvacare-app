package com.mytatva.patient.ui.activity

import android.os.Bundle
import android.view.View
import com.mytatva.patient.R
import com.mytatva.patient.databinding.AuthAcitivtyBinding
import com.mytatva.patient.di.component.ActivityComponent
import com.mytatva.patient.ui.auth.fragment.v2.WalkThroughFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.manager.ActivityStarter


/**
 * Created by Hlink 44.
 */
class AuthActivity : BaseActivity() {

    lateinit var authActivityBinding: AuthAcitivtyBinding

    override fun findFragmentPlaceHolder(): Int {
        return R.id.placeHolder
    }

    override fun createViewBinding(): View {
        authActivityBinding = AuthAcitivtyBinding.inflate(layoutInflater)
        return authActivityBinding.root
    }

    override fun inject(activityComponent: ActivityComponent) {
        activityComponent.inject(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // if contains fragment to open, else default open auth flow fragment
        if (savedInstanceState == null && intent.hasExtra(ActivityStarter.ACTIVITY_FIRST_PAGE)) {
            val page =
                intent.getSerializableExtra(ActivityStarter.ACTIVITY_FIRST_PAGE) as Class<BaseFragment<*>>
            load(page)
                .setBundle(intent.extras!!)
                .replace(false)
        } else {

//            if (AppFlagHandler.isToHideLanguagePage(appPreferences, firebaseConfigUtil)) {
//                /*load(LoginWithOtpFragment::class.java).replace(false)*/
//                /*load(SignUpPhoneFragment::class.java).replace(false)*/
//                /*load(LoginOrSignupNewFragment::class.java).replace(false)*/
//                load(WalkThroughFragment::class.java).replace(false)
//            } else {
//                load(SelectLanguageFragment::class.java).replace(false)
//            }

            load(WalkThroughFragment::class.java).replace(false)

        }
    }


}