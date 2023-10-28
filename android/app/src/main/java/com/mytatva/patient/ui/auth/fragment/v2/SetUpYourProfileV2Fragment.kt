package com.mytatva.patient.ui.auth.fragment.v2

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Patterns
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.os.bundleOf
import androidx.core.view.isVisible
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.ViewModelProvider
import androidx.transition.AutoTransition
import androidx.transition.Fade
import androidx.transition.TransitionManager
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.URLFactory
import com.mytatva.patient.data.model.DrawerItem
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.VerifyAccessCodeRes
import com.mytatva.patient.databinding.AuthFragmentSetupProfileV2Binding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.auth.fragment.ScanQRCodeFragment
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.fragment.WebViewCommonFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.disableFocus
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import com.mytatva.patient.utils.setAdjustResize
import com.mytatva.patient.utils.textdecorator.TextDecorator
import java.util.Calendar


class SetUpYourProfileV2Fragment : BaseFragment<AuthFragmentSetupProfileV2Binding>() {

    private val calDob = Calendar.getInstance()
    var accessCode: String? = null
    var doctorAccessCode: String? = null
    var isGender: Boolean = false

    /*private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    *//*if (accessCode.isNullOrBlank()) {
                        throw ApplicationException(getString(R.string.validation_verify_access_code))
                    }*//*

                    validator.submit(editTextYourName)
                        .checkEmpty().errorMessage(getString(R.string.common_validation_empty_name))
                        .matchPatter(Common.NAME_PATTERN)
                        .errorMessage(getString(R.string.validation_valid_name))
                        .check()

                    validator.submit(editTextYourEmail)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_email))
                        .checkValidEmail()
                        .errorMessage(getString(R.string.common_validation_invalid_email))
                        .check()

                    validator.submit(editTextDOB)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_date))
                        .check()

                    if (!isGender) {
                        throw ApplicationException(getString(R.string.common_validation_select_gender))
                    }

                    if(binding.editTextDoctorAccessCode.text.toString().trim().isNotEmpty()
                        && binding.textViewDoctorName.visibility!=View.VISIBLE) {
                        //if code entered but not verified
                        throw ApplicationException(getString(R.string.validation_verify_access_code))
                    }

                    if (binding.checkBoxAgreeTerms.isChecked.not()) {
                        throw ApplicationException(getString(R.string.common_validation_agree_terms))
                    }
                }
                true
            } catch (e: ApplicationException) {
                showAppMessage(e.message,AppMsgStatus.ERROR)
                false
            }
        }*/

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    /*if (accessCode.isNullOrBlank()) {
                        throw ApplicationException(getString(R.string.validation_verify_access_code))
                    }*/

                    validator.submit(editTextYourName, inputLayoutYourName)
                        .checkEmpty().errorMessage(getString(R.string.common_validation_empty_name))
                        .matchPatter(Common.NAME_PATTERN)
                        .errorMessage(getString(R.string.validation_valid_name))
                        .check()

                    validator.submit(editTextYourEmail, inputLayoutYourEmail)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_email))
                        .checkValidEmail()
                        .errorMessage(getString(R.string.common_validation_invalid_email))
                        .check()

                    validator.submit(editTextDOB)
                        .checkEmpty().errorMessage(getString(R.string.validation_select_date))
                        .check()

                    if (!isGender) {
                        showAppMessage(getString(R.string.common_validation_select_gender), AppMsgStatus.ERROR)
                        throw ApplicationException(getString(R.string.common_validation_select_gender))
                    }

                    if (isDummyAccessCodeApplied.not()
                        && binding.editTextDoctorAccessCode.text.toString().trim().isNotEmpty()
                        && binding.textViewDoctorName.visibility != View.VISIBLE
                    ) {
                        showAppMessage(getString(R.string.validation_verify_access_code), AppMsgStatus.ERROR)
                        //if code entered but not verified
                        throw ApplicationException(getString(R.string.validation_verify_access_code))
                    }

                    if (binding.checkBoxAgreeTerms.isChecked.not()) {
                        showAppMessage(getString(R.string.common_validation_agree_terms), AppMsgStatus.ERROR)
                        throw ApplicationException(getString(R.string.common_validation_agree_terms))
                    }
                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }

    private val isEmptyOrValidEmail: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextYourEmail, inputLayoutYourEmail/*, inputLayoutYourEmail.isErrorEnabled*/)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_email))
                        .checkValidEmail()
                        .errorMessage(getString(R.string.common_validation_invalid_email))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }

    private val isValidEmail: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextYourEmail, inputLayoutYourEmail)
                        .checkValidEmail()
                        .errorMessage(getString(R.string.common_validation_invalid_email))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }

    private val isValidName: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextYourName, inputLayoutYourName)
                        .checkEmpty().errorMessage(getString(R.string.common_validation_empty_name))
                        .matchPatter(Common.NAME_PATTERN)
                        .errorMessage(getString(R.string.validation_valid_name))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }

    private val isValidAccessCode: Boolean
        get() {
            return try {
                with(binding) {

                    if (binding.editTextDoctorAccessCode.text.toString().trim().isEmpty()) {
                        validator.submit(editTextDoctorAccessCode, inputLayoutDoctorAccessCode)
                            .checkEmpty().errorMessage(getString(R.string.common_validation_empty_access_code))
                            .check()
                    }

                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }


    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    private var isMale = true
    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSetupProfileV2Binding {
        return AuthFragmentSetupProfileV2Binding.inflate(layoutInflater)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AddAccountDetails)
    }

    override fun bindData() {
        setUI()
        setPatientDataAutoFill()
        handleUiToShowHideAccessCodeToggleOptions()
        setTermCondition()
        changeListener()
        //makeGenderSelected(binding.radioButtonMale)
        setOnViewClickListener()
        setAdjustResize()

        setUpHaveDoctorAccessCodeToggleUI()
    }

    private fun handleUiToShowHideAccessCodeToggleOptions() {
        with(binding) {
            if (groupAccessCode.isVisible) {
                binding.textViewDontHaveAccessCode.isVisible = true
                binding.groupIHaveAccessCodeLabels.isVisible = false
            } else {

                analytics.logEvent(analytics.DOCTOR_ACCESS_CODE_HIDDEN_BY_DEFAULT, screenName = AnalyticsScreenNames.AddAccountDetails)

                binding.textViewDontHaveAccessCode.isVisible = false
                binding.groupIHaveAccessCodeLabels.isVisible = false
            }
        }
    }

    private fun setUpHaveDoctorAccessCodeToggleUI() {
        TextDecorator.decorate(binding.textViewDontHaveAccessCode, "Click here if you don't have a doctor code.")
            .underline("here")
            .setTextColor(R.color.link_blue, "here")
            .build()

        TextDecorator.decorate(binding.textViewIHaveAccessCode, "If you have a doctor code, click here.")
            .underline("here")
            .setTextColor(R.color.link_blue, "here")
            .build()
    }

    private fun buttonEnable() = with(binding) {
        if (binding.groupAccessCode.isVisible) {
            buttonNext.isEnabled = checkBoxAgreeTerms.isChecked
                    && editTextYourName.text?.isNotBlank() == true
                    && editTextYourEmail.text?.isNotBlank() == true
                    && editTextDOB.text?.isNotBlank() == true
                    && isGender
                    && editTextDoctorAccessCode.text?.isNotBlank() == true //textViewDoctorName.isVisible
        } else {
            buttonNext.isEnabled = checkBoxAgreeTerms.isChecked
                    && editTextYourName.text?.isNotBlank() == true
                    && editTextYourEmail.text?.isNotBlank() == true
                    && editTextDOB.text?.isNotBlank() == true
                    && isGender
        }
    }

    private fun setTermCondition() {
        TextDecorator.decorate(binding.textViewTermCondition, getString(R.string.choose_condition_label_terms_conditions))
            .makeTextClickableWithSecondaryColor(
                requireContext().getColor(R.color.textGray6), View.OnClickListener {

                    navigator.loadActivity(IsolatedFullActivity::class.java, WebViewCommonFragment::class.java)
                        .addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.TITLE, DrawerItem.TermsConditions.drawerItem),
                                Pair(Common.BundleKey.URL, URLFactory.AppUrls.TERMS_CONDITIONS)
                            )
                        )
                        .start()


                    /*WebViewCommonDialog().apply {
                        arguments = bundleOf(
                            Pair(Common.BundleKey.TITLE, DrawerItem.TermsConditions.drawerItem),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.TERMS_CONDITIONS)
                        )
                    }.show(requireActivity().supportFragmentManager,
                        WebViewCommonDialog::class.java.simpleName)*/

                }, true, "Terms & Conditions"
            ).makeTextClickableWithSecondaryColor(
                requireContext().getColor(R.color.textGray6), View.OnClickListener {

                    navigator.loadActivity(IsolatedFullActivity::class.java, WebViewCommonFragment::class.java)
                        .addBundle(
                            bundleOf(
                                Pair(Common.BundleKey.TITLE, DrawerItem.PrivacyPolicy.drawerItem),
                                Pair(Common.BundleKey.URL, URLFactory.AppUrls.PRIVACY_POLICY)
                            )
                        ).start()

                    /*WebViewCommonDialog().apply {
                        arguments = bundleOf(
                            Pair(Common.BundleKey.TITLE, DrawerItem.PrivacyPolicy.drawerItem),
                            Pair(Common.BundleKey.URL, URLFactory.AppUrls.PRIVACY_POLICY)
                        )
                    }.show(requireActivity().supportFragmentManager,
                        WebViewCommonDialog::class.java.simpleName)*/

                }, true, "Privacy Policy"
            ).build()
    }

    private fun changeListener() = with(binding) {
        editTextYourName.focusableSelectorBlackGray(inputLayoutYourName)
        editTextYourEmail.focusableSelectorBlackGray(inputLayoutYourEmail)
        editTextDOB.focusableSelectorBlackGray(inputLayoutDOB)
        editTextDoctorAccessCode.focusableSelectorBlackGray(inputLayoutDoctorAccessCode)
        editTextDoctorAccessCode.doOnTextChanged { text, _, _, _ ->
            textViewCheck.isEnabled = text.isNullOrBlank() != true
        }
    }

    var isEmailErrorTriggered = false
    private fun EditText.focusableSelectorBlackGray(textInputLayout: TextInputLayout) {
        textInputLayout.setHintTextAppearance(R.style.hintAppearance)
        this.onFocusChangeListener = View.OnFocusChangeListener { _, b ->
            if (!b && this.text.toString() != "") {
                this.isSelected = true
                textInputLayout.isSelected = true
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_semi_bold)
            } else if (this.text.toString() == "") {
                this.isSelected = b
                textInputLayout.isSelected = b
            }

            if (binding.editTextYourEmail == this && !b) {
                isEmptyOrValidEmail
            } else if (binding.editTextYourName == this && !b) {
                isValidName
            } else if (binding.editTextDoctorAccessCode == this && !b) {
                isValidAccessCode
            }
        }

        this.doOnTextChanged { text, _, _, _ ->
            if (text?.length!! > 0) {
                if (text.startsWith(".") || text.startsWith("'")) {
                    this.setText("")
                }
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_semi_bold)
            } else {
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_regular)
            }

            if (binding.editTextYourEmail != this) {
                textInputLayout.error = null
                textInputLayout.isErrorEnabled = false
            }

            buttonEnable()

            if (binding.editTextYourEmail == this) {

                if (binding.editTextYourEmail.text.toString().trim().length >= 7) {
                    isValidEmail
                } else {
                    textInputLayout.error = null
                    textInputLayout.isErrorEnabled = false
                }

                /*if(isEmailErrorTriggered) {
                    val email = binding.editTextYourEmail.text.toString().trim()
                    if (email.matches(Patterns.EMAIL_ADDRESS.pattern().toRegex())) {
                        isEmptyOrValidEmail
                    }
                } else {
                    isEmailErrorTriggered = !isValidEmail
                }*/
            }
        }
    }

    private fun setUI() {
        if (FirebaseLink.Values.accessCode.isNullOrBlank().not()) {
            accessCode = FirebaseLink.Values.accessCode ?: "" //pass empty if null
            doctorAccessCode = FirebaseLink.Values.doctorAccessCode //pass only it is there via link
            binding.groupAccessCode.visibility = View.GONE
        } else {
            binding.groupAccessCode.isVisible =
                session.user?.doctor_access_code.isNullOrBlank() || session.user?.access_code.isNullOrBlank()
            binding.textViewCheck.isEnabled = binding.editTextDoctorAccessCode.text.toString().isNotBlank()
            binding.textViewDoctorName.visibility = View.GONE
        }
    }

    private fun setPatientDataAutoFill() = with(binding) {
        // set from user session, if details found from auth API response
        session.user?.let {

            //"name": "",
            if (it.name.isNullOrBlank().not()) {
                editTextYourName.setText(it.name!!.trim())
                if (editTextYourName.text.toString().trim().isNotBlank()) {
                    editTextYourName.isEnabled = false
                    editTextYourName.isSelected = true
                }
            }

            //"email": "",
            if (it.email.isNullOrBlank().not()) {
                editTextYourEmail.setText(it.email)
                editTextYourEmail.isSelected = true
                editTextYourEmail.isEnabled = false
            }

            //"gender": "M",
            if (it.gender.isNullOrBlank().not()) {
                makeGenderSelected(
                    if (it.gender == "M")
                        binding.radioButtonMale
                    else
                        binding.radioButtonFemale
                )
                binding.radioButtonMale.isEnabled = false
                binding.radioButtonFemale.isEnabled = false
            }

            //"dob": "2019-01-15",
            if (it.dob.isNullOrBlank().not()) {
                try {
                    calDob.timeInMillis =
                        DateTimeFormatter.date(it.dob, "yyyy-MM-dd").date!!.time
                    editTextDOB.setText(
                        DateTimeFormatter.date(calDob.time)
                            .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
                    )
                    editTextDOB.isEnabled = false
                    editTextDOB.isSelected = true
                } catch (e: Exception) {
                    editTextDOB.isEnabled = true
                }
            }

            //Doctor Access Code Content
            groupAccessCode.isVisible = session.user?.doctor_access_code.isNullOrBlank() || session.user?.access_code.isNullOrBlank()
        }
    }

    private var isDummyAccessCodeApplied = false
    private fun setOnViewClickListener() = with(binding) {
        radioButtonMale.setOnClickListener { onViewClick(it) }
        radioButtonFemale.setOnClickListener { onViewClick(it) }
        layoutHeader.imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        buttonNext.setOnClickListener { onViewClick(it) }
        editTextDOB.setOnClickListener { onViewClick(it) }
        textViewCheck.setOnClickListener { onViewClick(it) }
        imageViewScanner.setOnClickListener { onViewClick(it) }
        checkBoxAgreeTerms.setOnCheckedChangeListener { compoundButton, b ->
            buttonEnable()
        }
        textViewDontHaveAccessCode.setOnClickListener {
            analytics.logEvent(analytics.USER_CLICK_DONT_HAVE_ACCESS_CODE, screenName = AnalyticsScreenNames.AddAccountDetails)
            toggleDoNotHaveAccessCode(true)
        }
        textViewIHaveAccessCode.setOnClickListener {
            analytics.logEvent(analytics.USER_CLICK_HAVE_ACCESS_CODE, screenName = AnalyticsScreenNames.AddAccountDetails)
            toggleDoNotHaveAccessCode(false)
        }
    }

    private fun toggleDoNotHaveAccessCode(isDoNotHave: Boolean) {
        with(binding) {
            //TransitionManager.beginDelayedTransition(root,AutoTransition().setDuration(100))
            if (isDoNotHave) {
                isDummyAccessCodeApplied = true
                groupIHaveAccessCodeLabels.isVisible = true
                groupAccessCode.isVisible = false
                textViewDontHaveAccessCode.isVisible = false
                /*editTextDoctorAccessCode.setText("12345678")
                editTextDoctorAccessCode.disableFocus()
                textViewCheck.isEnabled = false
                imageViewScanner.isEnabled = false
                imageViewScanner.isClickable = false*/
            } else {
                isDummyAccessCodeApplied = false
                groupIHaveAccessCodeLabels.isVisible = false
                groupAccessCode.isVisible = true
                textViewDontHaveAccessCode.isVisible = true
            }
            editTextDoctorAccessCode.setText("")
            inputLayoutDoctorAccessCode.isErrorEnabled = false
            buttonEnable()
        }
    }

    private fun makeGenderSelected(view: View) = with(binding) {
        radioButtonMale.isSelected = view.id == radioButtonMale.id
        viewMale.isSelected = view.id == radioButtonMale.id
        textViewLabelMale.isSelected = view.id == radioButtonMale.id

        radioButtonFemale.isSelected = view.id == radioButtonFemale.id
        viewFemale.isSelected = view.id == radioButtonFemale.id
        textViewLabelFemale.isSelected = view.id == radioButtonFemale.id

        isMale = view.id == radioButtonMale.id

        isGender = true
        buttonEnable()
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (
            requestCode == Common.RequestCode.REQUEST_SCAN_QR_CODE
            && resultCode == Activity.RESULT_OK
            && data?.getBooleanExtra(Common.BundleKey.IS_QR_SCAN_SUCCESS, false) == true
            && FirebaseLink.Values.accessCode.isNullOrBlank().not()
        ) {
            accessCode = FirebaseLink.Values.accessCode ?: "" //pass empty if null
            doctorAccessCode = FirebaseLink.Values.doctorAccessCode //pass only it is there via link

            with(binding) {
                if (accessCode.isNullOrBlank().not()) {
                    editTextDoctorAccessCode.setText(accessCode)
                    //editTextDoctorAccessCode.disableFocus()
                    //textViewCheck.isEnabled = false
                    scrollOnVerifyAccessCodesSuccess()
                    verifyDoctorAccessCode()
                }
            }

        }
    }

    private fun scrollOnVerifyAccessCodesSuccess() {
        with(binding) {
            nestedScrollView.smoothScrollTo(
                0,
                layoutMain.top + checkBoxAgreeTerms.top - 16
            )
        }
    }

    private fun handleOnVerifyAccessCode(
        verifyAccessCodeRes: VerifyAccessCodeRes,
    ) {
        // pass access code only when verify manually
        accessCode = verifyAccessCodeRes.access_code
        doctorAccessCode = verifyAccessCodeRes.access_code

        analytics.logEvent(analytics.ACCESS_CODE_VERIFY_SUCCESS,
            Bundle().apply {
                putString(analytics.PARAM_DOCTOR_ACCESS_CODE, binding.editTextDoctorAccessCode.text.toString().trim())
            }, screenName = AnalyticsScreenNames.AddAccountDetails
        )

        with(binding) {
            editTextDoctorAccessCode.disableFocus()
            textViewCheck.isEnabled = false
            imageViewScanner.isEnabled = false
            imageViewScanner.isClickable = false
            textViewDoctorName.visibility = View.VISIBLE
            textViewDoctorName.text = verifyAccessCodeRes.name
            scrollOnVerifyAccessCodesSuccess()

            textViewDontHaveAccessCode.isVisible = false
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                if (binding.textViewCheck.isEnabled) {
                    FirebaseLink.clearValues()
                }
                navigator.goBack()
            }

            R.id.radioButtonMale -> {
                makeGenderSelected(view)
            }

            R.id.radioButtonFemale -> {
                makeGenderSelected(view)
            }

            R.id.editTextDOB -> {
                navigator.pickDate({ view, year, month, dayOfMonth ->
                    binding.editTextDOB.isSelected = true
                    calDob.set(year, month, dayOfMonth)
                    binding.editTextDOB.setText(
                        DateTimeFormatter.date(calDob.time)
                            .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_DISPLAY_DATE)
                    )
                }, 0L, Calendar.getInstance().apply { add(Calendar.YEAR, -18) }.timeInMillis)
            }

            R.id.textViewCheck -> {
                analytics.logEvent(analytics.USER_CLICK_CHECK_ACCESS_CODE, screenName = AnalyticsScreenNames.AddAccountDetails)
                if (binding.editTextDoctorAccessCode.text.toString().trim().isBlank().not())
                    verifyDoctorAccessCode()
                else
                    showAppMessage(getString(R.string.common_validation_empty_access_code), AppMsgStatus.ERROR)
            }

            R.id.buttonNext -> {
                if (isValid) {
                    registerTempPatientProfile()
                }
            }

            R.id.imageViewScanner -> {
                checkPermissions()
            }
        }
    }

    private fun checkPermissions() {
        if (Build.VERSION.SDK_INT >= 23) {
            if (ActivityCompat.checkSelfPermission(
                    requireActivity(),
                    Manifest.permission.CAMERA
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                requestPermissions(
                    Common.PERMISSIONS_ONLY_CAMERA,
                    Common.RequestCode.REQUEST_CAMERA_PERMISSION
                )
            } else {
                openScanner()
            }
        } else {
            openScanner()
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            Common.RequestCode.REQUEST_CAMERA_PERMISSION -> {
                if (PermissionUtil.verifyPermissions(grantResults)) {
                    openScanner()
                } else {
                    (requireActivity() as BaseActivity).showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Camera))
                }
            }
        }
    }

    private fun openScanner() {
        navigator.loadActivity(
            IsolatedFullActivity::class.java,
            ScanQRCodeFragment::class.java
        )
            .forResult(Common.RequestCode.REQUEST_SCAN_QR_CODE)
            .start()
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
    private fun registerTempPatientProfile() = with(binding) {
        val apiRequest = ApiRequest().apply {
            name = this@with.editTextYourName.text.toString().trim()
            email = this@with.editTextYourEmail.text.toString().trim()
            gender = if (isMale) "M" else "F"
            dob = DateTimeFormatter.date(calDob.time)
                .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
            if (isDummyAccessCodeApplied.not()) {
                access_code = accessCode
            }
        }
        showLoader()
        authViewModel.registerTempPatientProfile(apiRequest)
    }

    private fun verifyDoctorAccessCode() {
        showLoader()
        authViewModel.verifyDoctorAccessCode(ApiRequest().apply {
            access_code = binding.editTextDoctorAccessCode.text.toString().trim()
        })
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.registerTempPatientProfileLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data.let { response ->
                    analytics.logEvent(analytics.USER_ADD_ACCOUNT_STEP_SUCCESS, screenName = AnalyticsScreenNames.AddAccountDetails)
                    Handler(Looper.getMainLooper()).postDelayed({
                        navigator.load(ChooseYourConditionV2Fragment::class.java)
                            .add(true)
                    }, 100)
                }

            },
            onError = { throwable ->
                hideLoader()
                if (throwable is ServerException) {
                    showAppMessage(throwable.message ?: "", AppMsgStatus.ERROR)
                    false
                } else {
                    true
                }
            })

        authViewModel.verifyDoctorAccessCodeLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                responseBody.data?.let {
                    binding.editTextDoctorAccessCode.isSelected = true
                    handleOnVerifyAccessCode(it)
                }
            },
            onError = { throwable ->
                hideLoader()
                analytics.logEvent(analytics.ACCESS_CODE_VERIFY_FAIL,
                    Bundle().apply {
                        putString(analytics.PARAM_DOCTOR_ACCESS_CODE, binding.editTextDoctorAccessCode.text.toString().trim())
                    }, screenName = AnalyticsScreenNames.AddAccountDetails
                )
                if (throwable is ServerException) {
                    //showAppMessage(throwable.message ?: "", AppMsgStatus.ERROR)
                    binding.inputLayoutDoctorAccessCode.isErrorEnabled = true
                    binding.inputLayoutDoctorAccessCode.error = throwable.message ?: ""
                    false
                } else {
                    true
                }
            })
    }
}