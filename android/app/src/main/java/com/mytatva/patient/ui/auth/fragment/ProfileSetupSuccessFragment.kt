package com.mytatva.patient.ui.auth.fragment

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.mytatva.patient.R
import com.mytatva.patient.databinding.AuthFragmentProfileSetupSuccessBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class ProfileSetupSuccessFragment : BaseFragment<AuthFragmentProfileSetupSuccessBinding>() {

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentProfileSetupSuccessBinding {
        return AuthFragmentProfileSetupSuccessBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ProfileCompleteSuccess)
    }

    override fun bindData() {
        setViewListeners()
        analytics.logEvent(
            analytics.USER_PROFILE_COMPLETED,
            screenName = AnalyticsScreenNames.ProfileCompleteSuccess
        )
        Handler(Looper.getMainLooper()).postDelayed({
            /*navigator.loadActivity(HomeActivity::class.java)
                .byFinishingAll().start()*/

            openHome(/*screenName = AnalyticsScreenNames.ProfileCompleteSuccess*/)

        }, 2000)
    }

    private fun setViewListeners() {
        binding.apply {
            layoutSuccess.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.layoutSuccess -> {
                /*  navigator.loadActivity(HomeActivity::class.java)
                      .byFinishingAll().start()*/
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {

    }
}