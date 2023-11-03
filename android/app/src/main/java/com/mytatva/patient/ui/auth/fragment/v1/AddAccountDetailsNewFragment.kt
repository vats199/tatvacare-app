package com.mytatva.patient.ui.auth.fragment.v1

import android.location.Location
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.model.DrawerItem
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.MedicalConditionData
import com.mytatva.patient.databinding.AuthNewFragmentAddAccountDetailsBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.adapter.AddedMedicalConditionAdapter
import com.mytatva.patient.ui.auth.bottomsheet.SelectMedicalConditionBottomSheetDialog
import com.mytatva.patient.ui.auth.dialog.AccountCreateSuccessDialog
import com.mytatva.patient.ui.auth.fragment.SelectYourLocationFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.dialog.WebViewCommonDialog
import com.mytatva.patient.ui.common.fragment.WebViewCommonFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.DeviceUtils
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import com.mytatva.patient.utils.textdecorator.TextDecorator
import java.util.*

class AddAccountDetailsNewFragment : BaseFragment<AuthNewFragmentAddAccountDetailsBinding>() {

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {

                    /*validator.submit(editTextFullName)
                        .checkEmpty().errorMessage(getString(R.string.common_validation_empty_name))
                        .matchPatter(Common.NAME_PATTERN)
                        .errorMessage(getString(R.string.validation_valid_name))
                        .check()*/

                    validator.submit(editTextFirstName)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_first_name))
                        .matchPatter(Common.NAME_PATTERN)
                        .errorMessage(getString(R.string.validation_valid_first_name))
                        .check()

                    validator.submit(editTextLastName)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_last_name))
                        .matchPatter(Common.NAME_PATTERN)
                        .errorMessage(getString(R.string.validation_valid_last_name))
                        .check()

                    validator.submit(editTextDOB)
                        .checkEmpty().errorMessage(getString(R.string.common_validation_empty_dob))
                        .check()

                    validator.submit(editTextEmail)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_email))
                        .checkValidEmail()
                        .errorMessage(getString(R.string.common_validation_invalid_email))
                        .check()

                    /*validator.submit(editTextPassword)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_password))
                        .checkMinDigits(8)
                        .errorMessage(getString(R.string.common_validation_min_password))
                        .matchPatter(Common.PASSWORD_PATTERN)
                        .errorMessage(getString(R.string.common_validation_invalid_password_pattern))
                        .check()

                    validator.submit(editTextConfirmPassword)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_confirm_password))
                        .matchString(editTextPassword.text.toString().trim())
                        .errorMessage(getString(R.string.common_validation_password_mismatch))
                        .check()*/

                    validator.submit(editTextMedicalCondition)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_select_medical_condition))
                        .check()

                    if (imageViewAgreeTerms.isSelected.not()) {
                        throw ApplicationException(getString(R.string.common_validation_agree_terms))
                    }

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

    private val phoneNo by lazy {
        session.user?.contact_no
        //arguments?.getString(Common.BundleKey.PHONE)
    }

    private val calDob = Calendar.getInstance()

    private var selectedMedicalCondition: MedicalConditionData? = null
    private val allMedicalConditionList = arrayListOf<MedicalConditionData>()
    private val selectedMedicalConditionList = arrayListOf<MedicalConditionData>()

    private var location: Location? = null

    private val addedMedicalConditionAdapter by lazy {
        AddedMedicalConditionAdapter(selectedMedicalConditionList)
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthNewFragmentAddAccountDetailsBinding {
        return AuthNewFragmentAddAccountDetailsBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        observeLiveData()
        super.onCreate(savedInstanceState)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AddAccountDetails)
    }

    override fun bindData() {
        setUpToolbar()
        setPatientDataAutoFill()
        setUpUI()
        setViewListeners()
        medicalConditionGroupList()

        /*locationManager.startLocationUpdates { location, exception ->
            location?.let {
                locationManager.stopFetchLocationUpdates()
                this.location = location
                analytics.weUser?.setLocation(it.latitude, it.longitude)
            }
            exception?.let {
                // location will not be updated
            }
        }*/
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            progressBar.isVisible = true
            progressBar.progress = 100
        }
    }

    private fun setPatientDataAutoFill() {
        // set from user session, if details found from auth API response
        session.user?.let {
            with(binding) {

                //"name": "",
                if (it.name.isNullOrBlank().not()) {
                    //editTextFullName.setText(it.name)
                    //editTextFullName.disableFocus()
                    //editTextFullName.isEnabled = false

                    if (it.name?.trim()?.contains(" ") == true) {
                        val firstWord = it.name.trim().split(" ")[0]
                        editTextFirstName.setText(firstWord)
                        editTextLastName.setText(it.name.removePrefix(firstWord).trim())
                    } else {
                        editTextFirstName.setText(it.name?.trim())
                        editTextLastName.setText("")
                    }

                    if (editTextFirstName.text.toString().trim().isNotBlank()) {
                        editTextFirstName.isEnabled = false
                    }
                    if (editTextLastName.text.toString().trim().isNotBlank()) {
                        editTextLastName.isEnabled = false
                    }

                }

                //"email": "",
                if (it.email.isNullOrBlank().not()) {
                    editTextEmail.setText(it.email)
                    //editTextEmail.disableFocus()
                    editTextEmail.isEnabled = false
                }

                //"gender": "M",
                if (it.gender.isNullOrBlank().not()) {
                    radioMale.isEnabled = false
                    radioFemale.isEnabled = false
                    //radioPreferNotToSay.isEnabled = false
                    radioMale.isChecked = it.gender == "M"
                    radioFemale.isChecked = it.gender == "F"
                    //radioPreferNotToSay.isChecked = it.gender == "P"
                }

                //"dob": "2019-01-15",
                if (it.dob.isNullOrBlank().not()) {
                    try {
                        calDob.timeInMillis =
                            DateTimeFormatter.date(it.dob, "yyyy-MM-dd").date!!.time
                        editTextDOB.setText(DateTimeFormatter.date(calDob.time)
                            .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE))
                        editTextDOB.isEnabled = false
                    } catch (e: Exception) {
                        editTextDOB.isEnabled = true
                    }
                }

                //"medical_condition_group_id": "6daa87e4-1da1-4ac7-8fc7-c9ee9e340bd8",
                //"indication_name": "Asthma",
                if (it.medical_condition_group_id.isNullOrBlank().not()
                    && it.indication_name.isNullOrBlank().not()
                ) {
                    selectedMedicalCondition = MedicalConditionData().apply {
                        medical_condition_group_id = it.medical_condition_group_id
                        medical_condition_name = it.indication_name
                    }
                    editTextMedicalCondition.isEnabled = false
                    editTextMedicalCondition.setText(it.indication_name)
                }
                //"account_role": "P",
            }
        }
    }

    private fun setUpUI() {
        TextDecorator.decorate(binding.checkBoxAgreeTerms,
            getString(R.string.add_account_label_i_agree_to_the_terms_and_conditions_and_privacy_policy))
            .makeTextClickableWithSecondaryColor(
                requireContext().getColor(R.color.colorPrimary), View.OnClickListener {
                    //binding.checkBoxAgreeTerms.isChecked = !binding.checkBoxAgreeTerms.isChecked

                    navigator.loadActivity(IsolatedFullActivity::class.java, WebViewCommonFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.TITLE, DrawerItem.TermsConditions.drawerItem),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.TERMS_CONDITIONS)))
                        .start()

                    /*WebViewCommonDialog().apply {
                        arguments = bundleOf(
                            Pair(Common.BundleKey.TITLE, DrawerItem.TermsConditions.drawerItem),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.TERMS_CONDITIONS)
                        )
                    }.show(requireActivity().supportFragmentManager,
                        WebViewCommonDialog::class.java.simpleName)*/

                }, false, "Terms & Conditions"
            ).makeTextClickableWithSecondaryColor(
                requireContext().getColor(R.color.colorPrimary), View.OnClickListener {
                    //binding.checkBoxAgreeTerms.isChecked = !binding.checkBoxAgreeTerms.isChecked

                    navigator.loadActivity(IsolatedFullActivity::class.java, WebViewCommonFragment::class.java)
                        .addBundle(bundleOf(
                            Pair(Common.BundleKey.TITLE, DrawerItem.PrivacyPolicy.drawerItem),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.PRIVACY_POLICY))
                        ).start()

                    /*WebViewCommonDialog().apply {
                        arguments = bundleOf(
                            Pair(Common.BundleKey.TITLE, DrawerItem.PrivacyPolicy.drawerItem),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.PRIVACY_POLICY)
                        )
                    }.show(requireActivity().supportFragmentManager,
                        WebViewCommonDialog::class.java.simpleName)*/

                }, false, "Privacy Policy"
            ).build()
    }


    private fun setViewListeners() {
        binding.apply {
            layoutHeader.imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            editTextDOB.setOnClickListener { onViewClick(it) }
            editTextMedicalCondition.setOnClickListener { onViewClick(it) }
            buttonNext.setOnClickListener { onViewClick(it) }
            imageViewAgreeTerms.setOnClickListener { onViewClick(it) }

            //editTextFullName.dontAllowAsPrefix(".")

            /*checkBoxAgreeTerms.setOnCheckedChangeListener { buttonView, isChecked ->
                buttonNext.isEnabled = isChecked
            }*/
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewAgreeTerms -> {
                binding.imageViewAgreeTerms.isSelected =
                    binding.imageViewAgreeTerms.isSelected.not()
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
            R.id.editTextDOB -> {
                navigator.pickDate({ view, year, month, dayOfMonth ->
                    calDob.set(year, month, dayOfMonth)
                    binding.editTextDOB.setText(
                        DateTimeFormatter.date(calDob.time)
                            .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
                    )
                }, 0L, Calendar.getInstance().apply { add(Calendar.YEAR, -18) }.timeInMillis)
            }
            R.id.editTextMedicalCondition -> {
                activity?.supportFragmentManager?.let {
                    SelectMedicalConditionBottomSheetDialog(allMedicalConditionList)
                        .setCallBack { medicalCondition ->
                            medicalCondition?.let {
                                selectedMedicalCondition = medicalCondition
                                binding.editTextMedicalCondition.setText(selectedMedicalCondition?.medical_condition_name
                                    ?: "")
                            }
                        }.show(it, SelectMedicalConditionBottomSheetDialog::class.java.simpleName)
                }
            }
            R.id.textViewAddOtherMedicalCondition -> {
                if (selectedMedicalCondition != null
                    && selectedMedicalConditionList.any {
                        it.medical_condition_master_id == selectedMedicalCondition!!.medical_condition_master_id
                    }.not()
                ) {
                    // if medical cond selected & not contain same in list then add it
                    selectedMedicalConditionList.add(selectedMedicalCondition!!)
                    addedMedicalConditionAdapter.notifyItemInserted(selectedMedicalConditionList.lastIndex)
                }
                binding.editTextMedicalCondition.setText("")
            }
            R.id.buttonNext -> {
                if (isValid) {
                    callRegister()
                }
            }
        }
    }


    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun callRegister() {
        val apiRequest = ApiRequest().apply {
            contact_no = phoneNo /*binding.textViewMobileNumber.text.toString()*/
            email = binding.editTextEmail.text.toString().trim()
            languages_id = session.selectedLanguageId
            /*name = binding.editTextFullName.text.toString().trim()*/
            name = "${
                binding.editTextFirstName.text.toString().trim()
            } ${binding.editTextLastName.text.toString().trim()}"
            dob = DateTimeFormatter.date(calDob.time)
                .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
            gender =
                if (binding.radioMale.isChecked) "M"
                else if (binding.radioFemale.isChecked) "F" else "P"

            //password = binding.editTextPassword.text.toString()
            account_role =
                if (binding.radioPatient.isChecked) "P"
                else if (binding.radioCaregiver.isChecked) "C" else ""

            active_deactive_id = ""
            is_accept_terms_accept = "Y"
            whatsapp_optin = "Y"
            email_verified = "N"
            medical_condition_group_id = selectedMedicalCondition?.medical_condition_group_id
            /*medical_condition_ids =selectedMedicalConditionList.listOfField(MedicalConditionData::medical_condition_master_id)*/

            access_from = FirebaseLink.Values.accessFrom
            /*access_code = accessCode
            doctor_access_code = doctorAccessCode*/
        }
        showLoader()
        authViewModel.register(apiRequest)
    }

    private fun medicalConditionGroupList() {
        showLoader()
        /*authViewModel.medicalConditionList(ApiRequest())*/
        authViewModel.medicalConditionGroupList(ApiRequest())
    }

    private fun updateDeviceInfo() {
        val apiRequest = ApiRequest().apply {
            device_token = session.deviceId
            device_type = Session.DEVICE_TYPE
            uuid = session.deviceFID
            os_version = DeviceUtils.deviceOSVersion.toString()
            device_name = DeviceUtils.deviceName
            model_name = DeviceUtils.deviceName
            app_version = BuildConfig.VERSION_NAME
            build_version_number = BuildConfig.VERSION_CODE.toString()
            ip = DeviceUtils.getIPAddress()
        }

        location?.let {
            apiRequest.lat = it.latitude.toString()
            apiRequest.long = it.longitude.toString()
        }

        authViewModel.updateDeviceInfo(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.registerLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                FirebaseLink.clearValues()
                //to update device info of registered user
                updateDeviceInfo()
                handleOnRegisterSuccess()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        authViewModel.medicalConditionGroupListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                allMedicalConditionList.clear()
                responseBody.data?.let { allMedicalConditionList.addAll(it) }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    private fun handleOnRegisterSuccess() {
        analytics.logEvent(analytics.USER_SIGNUP_COMPLETE,
            screenName = AnalyticsScreenNames.AddAccountDetails)
        // remove biometric step currently
        /*if ((activity as BaseActivity).isBiometricSupportedAndAdded()) {
            navigator.loadActivity(AuthActivity::class.java, UseBiometricFragment::class.java)
                .byFinishingCurrent()
                .start()
        } else {*/
        activity?.supportFragmentManager?.let {
            appPreferences.putBoolean(Common.IS_LOGIN, true)
            AccountCreateSuccessDialog().apply {
                onCreateProfile = {
                    openHome(AnalyticsScreenNames.AddAccountDetails)
                    navigator.loadActivity(AuthActivity::class.java,
                        SelectYourLocationFragment::class.java).start()
                }
                onGoToHome = {
                    openHome(AnalyticsScreenNames.AddAccountDetails)
                }
            }.show(it, AccountCreateSuccessDialog::class.java.simpleName)
        }
        /*}*/
    }

}