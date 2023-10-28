package com.mytatva.patient.ui.auth.fragment

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common.BundleKey.LANGUAGE_DATA
import com.mytatva.patient.core.Common.RequestCode.REQUEST_SELECT_LANGUAGE
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.LanguageData
import com.mytatva.patient.databinding.AuthFragmentSelectLanguageBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.adapter.LanguageAdapter
import com.mytatva.patient.ui.auth.fragment.v1.LoginOrSignupNewFragment
import com.mytatva.patient.ui.auth.fragment.v2.WalkThroughFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class SelectLanguageFragment : BaseFragment<AuthFragmentSelectLanguageBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextLanguage)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_select_language))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private val languageList = arrayListOf<LanguageData>()

    private val languageAdapter by lazy {
        LanguageAdapter(languageList)
    }

    var selectedLanguage: LanguageData? = null

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSelectLanguageBinding {
        return AuthFragmentSelectLanguageBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SelectLanguage)
    }

    override fun bindData() {
        setViewListeners()
        getLanguageList()


    }

    /*fun tempFit() {
        if (googleFit.hasAllPermissions.not()) {
            //connect
            googleFit.initializeFit {
                val cal = Calendar.getInstance()
                cal.add(Calendar.DAY_OF_YEAR, -10)
                googleFit.readGoals(cal) { goalsList ->
                }
            }
        } else {
            val cal = Calendar.getInstance()
            cal.add(Calendar.DAY_OF_YEAR, -10)
            googleFit.readGoals(cal) { goalsList ->
            }
        }
    }*/

    private fun setViewListeners() {
        binding.apply {
            editTextLanguage.setOnClickListener {
                //tempFit()
                onViewClick(it)
            }
            buttonSubmit.setOnClickListener {
                //googleFit.writeSteps(25, Calendar.getInstance())
                onViewClick(it)
            }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.editTextLanguage -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    SelectLanguageListFragment::class.java
                ).forResult(REQUEST_SELECT_LANGUAGE).start()
            }

            R.id.buttonSubmit -> {
                if (isValid) {
                    analytics.logEvent(
                        analytics.NEW_USER_LANGUAGE_SELECTION,
                        bundleOf(
                            Pair(
                                analytics.PARAM_LANGUAGE_SELECTED,
                                binding.editTextLanguage.text.toString().trim()
                            )
                        ),
                        screenName = AnalyticsScreenNames.SelectLanguage
                    )
                    session.selectedLanguageId = selectedLanguage?.languages_id ?: ""

                    /*navigator.load(LoginWithOtpFragment::class.java).replace(true)*/
                    /*navigator.load(SignUpPhoneFragment::class.java).replace(true)*/
//                    navigator.load(LoginOrSignupNewFragment::class.java).replace(true)
                    navigator.load(WalkThroughFragment::class.java).replace(true)
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (isAdded) {
            if (requestCode == REQUEST_SELECT_LANGUAGE) {
                if (data != null && resultCode == Activity.RESULT_OK) {
                    selectedLanguage = data.getParcelableExtra(LANGUAGE_DATA)
                    binding.editTextLanguage.setText(selectedLanguage?.language_name ?: "")
                }
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun getLanguageList() {
        //showLoader()
        val apiRequest = ApiRequest()
        authViewModel.getLanguageList(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    @SuppressLint("NotifyDataSetChanged")
    private fun observeLiveData() {
        authViewModel.getLanguageListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                selectedLanguage = responseBody.data?.firstOrNull()
                selectedLanguage?.let {
                    session.selectedLanguageId = selectedLanguage?.languages_id ?: ""
                    binding.editTextLanguage.setText(it.language_name)
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }
}