package com.mytatva.patient.ui.auth.fragment.v2

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.bumptech.glide.Glide
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthV2FragmentLetsBeginBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class LetsBeginV2Fragment : BaseFragment<AuthV2FragmentLetsBeginBinding>() {

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthV2FragmentLetsBeginBinding {
        return AuthV2FragmentLetsBeginBinding.inflate(layoutInflater)
    }

    override fun bindData() {
        val image = session.imageURL
        if (image?.isBlank()?.not() == true) {
            Glide.with(binding.root.context)
                .asGif()
                .load(image)
                .into(binding.imageViewGIF)
        }
        with(binding) {
            buttonLetsBegin.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonLetsBegin -> {
                updateSignupFor()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateSignupFor() {
        val apiRequest = ApiRequest().apply {
            /*if (binding.radioMySelf.isChecked) {*/
            relation = "myself"
            /*} else {
                relation = "someone_else"
                sub_relation = relationType?.displayName
            }*/
        }
        showLoader()
        authViewModel.updateSignupFor(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updateSignupForLiveData.observe(this, onChange = {
            hideLoader()
            /*if (binding.radioMySelf.isChecked) {*/
            analytics.logEvent(
                analytics.NEW_USER_SIGNED_AS_MYSELF,
                screenName = AnalyticsScreenNames.SelectRole
            )
            navigator.loadActivity(
                IsolatedFullActivity::class.java,
                SetUpYourProfileV2Fragment::class.java
            )
                .byFinishingCurrent()
                .start()

            /*} else {
                analytics.logEvent(analytics.NEW_USER_SIGNED_AS_SOMEONE_ELSE,
                    screenName = AnalyticsScreenNames.SelectRole)
            }
            continueToNextFlow()*/
        }, onError = {
            hideLoader()
            if (it is ServerException) {
                showAppMessage(it.message ?: "", AppMsgStatus.ERROR)
                false
            } else {
                true
            }
        })
    }
}