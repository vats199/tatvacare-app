package com.mytatva.patient.ui.auth.fragment.v1

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.data.model.RelationType
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthNewFragmentSelectRoleBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.auth.bottomsheet.v1.SelectRelationTypeBottomSheetDialog
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink


class SelectRoleFragment : BaseFragment<AuthNewFragmentSelectRoleBinding>() {

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
    ): AuthNewFragmentSelectRoleBinding {
        return AuthNewFragmentSelectRoleBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SelectRole)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setViewListeners()
    }

    private fun setViewListeners() {
        binding.apply {
            layoutHeader.imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            radioMySelf.setOnClickListener { onViewClick(it) }
            radioSomeOne.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.radioMySelf -> {
                updateSignupFor()
            }
            R.id.radioSomeOne -> {
                SelectRelationTypeBottomSheetDialog {
                    updateSignupFor(relationType = it)
                }.show(requireActivity().supportFragmentManager,
                    SelectRelationTypeBottomSheetDialog::class.java.simpleName)
            }
        }
    }

    private fun continueToNextFlow() {
        if (FirebaseLink.Values.accessCode.isNullOrBlank().not()) {
            /*
            accessCode = FirebaseLink.Values.accessCode ?: "" //pass empty if null
            doctorAccessCode = FirebaseLink.Values.doctorAccessCode //pass only it is there via link
             */
            navigator.loadActivity(AuthActivity::class.java,
                AddAccountDetailsNewFragment::class.java)
                .start()
        } else {
            navigator.loadActivity(AuthActivity::class.java, VerifyLinkDoctorFragment::class.java)
                .start()
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateSignupFor(relationType: RelationType? = null) {
        val apiRequest = ApiRequest().apply {
            if (binding.radioMySelf.isChecked) {
                relation = "myself"
            } else {
                relation = "someone_else"
                sub_relation = relationType?.displayName
            }
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
        authViewModel.updateSignupForLiveData.observe(this, onChange = { responseBody ->
            hideLoader()
            if (binding.radioMySelf.isChecked) {
                analytics.logEvent(analytics.NEW_USER_SIGNED_AS_MYSELF,
                    screenName = AnalyticsScreenNames.SelectRole)
            } else {
                analytics.logEvent(analytics.NEW_USER_SIGNED_AS_SOMEONE_ELSE,
                    screenName = AnalyticsScreenNames.SelectRole)
            }
            continueToNextFlow()
        }, onError = { throwable ->
            hideLoader()
            true
        })
    }
}