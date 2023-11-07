package com.mytatva.patient.ui.auth.fragment.v2

import android.location.Location
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.core.content.res.ResourcesCompat
import androidx.core.view.isVisible
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.BuildConfig
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.core.Session
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.MedicalConditionData
import com.mytatva.patient.databinding.AuthFragmentChooseConditionV2Binding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.auth.adapter.v2.ChooseYourConditionV2Adapter
import com.mytatva.patient.ui.auth.dialog.AccountCreateSuccessDialog
import com.mytatva.patient.ui.auth.fragment.SelectYourLocationFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.DeviceUtils
import com.mytatva.patient.utils.datetime.DateTimeFormatter
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.firebaselink.FirebaseLink
import java.util.Calendar

class ChooseYourConditionV2Fragment : BaseFragment<AuthFragmentChooseConditionV2Binding>() {

    private val allMedicalConditionList = arrayListOf<MedicalConditionData>()
    private var selectedMedicalCondition: MedicalConditionData? = null

    private val chooseConditionAdapter by lazy {
        ChooseYourConditionV2Adapter(allMedicalConditionList) { medicalCondition ->
            medicalCondition?.let {
                selectedMedicalCondition = medicalCondition
                updateOtherMedicalConditionUI()
            }
            binding.buttonFinish.isEnabled = true
        }
    }

    private fun updateOtherMedicalConditionUI() {
        binding.groupProvideCondition.isVisible = selectedMedicalCondition?.is_other.equals("Yes", true)
        if (binding.groupProvideCondition.isVisible) {
            Handler(Looper.getMainLooper()).postDelayed({
                binding.nestedScrollView.smoothScrollTo(0, binding.nestedScrollView.bottom)
            },100)
        }
    }

    private val calDob = Calendar.getInstance()
    private var location: Location? = null

    private val authViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[AuthViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentChooseConditionV2Binding {
        return AuthFragmentChooseConditionV2Binding.inflate(layoutInflater)
    }

    override fun bindData() {
        setUpRecyclerView()
        medicalConditionGroupList()
        setOnClickListener()
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

    private fun setOnClickListener() = with(binding) {
        layoutHeader.imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        buttonFinish.setOnClickListener { onViewClick(it) }
        editTextProvideCondition.focusableSelectorBlackGray(inputLayoutProvideCondition)
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }

            R.id.buttonFinish -> {
                callRegister()
            }
        }
    }

    private fun EditText.focusableSelectorBlackGray(textInputLayout: TextInputLayout) {
        textInputLayout.setHintTextAppearance(R.style.hintAppearance)
        this.onFocusChangeListener = View.OnFocusChangeListener { _, b ->
            if (!b && this.text.toString() != "") {
                this.isSelected = true
                textInputLayout.isSelected = true
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_semi_bold)
            }
            else if (this.text.toString() == "") {
                this.isSelected = b
                textInputLayout.isSelected = b
            }
        }
        this.doOnTextChanged { text,_,_,_ ->
            if (text?.length!! > 0) {
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_semi_bold)
            } else {
                this.typeface = ResourcesCompat.getFont(this.context, R.font.sf_regular)
            }
        }
    }

    private fun setUpRecyclerView() {
        binding.recyclerViewChooseCondition.apply {
            layoutManager = GridLayoutManager(requireContext(), 3, RecyclerView.VERTICAL, false)
            adapter = chooseConditionAdapter
        }
    }

    private fun updateDeviceInfo() {
        val apiRequest = ApiRequest().apply {
            device_token = session.deviceId
            device_type = Session.DEVICE_TYPE
            uuid = session.deviceFID
            os_version = DeviceUtils.deviceOSVersion
            device_name = DeviceUtils.deviceName
            model_name = DeviceUtils.deviceName
            app_version = BuildConfig.VERSION_NAME
            build_version_number = BuildConfig.VERSION_CODE.toString()
            ip = DeviceUtils.getIPAddress()
            other_condition = binding.editTextProvideCondition.text.toString().trim()
        }

        location?.let {
            apiRequest.lat = it.latitude.toString()
            apiRequest.long = it.longitude.toString()
        }

        authViewModel.updateDeviceInfo(apiRequest)
    }


    private fun handleOnRegisterSuccess() {
        analytics.logEvent(
            analytics.USER_SIGNUP_COMPLETE,
            screenName = AnalyticsScreenNames.AddAccountDetails
        )
        appPreferences.putBoolean(Common.IS_LOGIN, true)
        openHome(AnalyticsScreenNames.AddAccountDetails)
//        activity?.supportFragmentManager?.let {
//            appPreferences.putBoolean(Common.IS_LOGIN, true)
//            AccountCreateSuccessDialog().apply {
//                onCreateProfile = {
//                    openHome(AnalyticsScreenNames.AddAccountDetails)
//                    navigator.loadActivity(
//                        AuthActivity::class.java,
//                        SelectYourLocationFragment::class.java
//                    ).start()
//                }
//                onGoToHome = {
//                    openHome(AnalyticsScreenNames.AddAccountDetails)
//                }
//            }.show(it, AccountCreateSuccessDialog::class.java.simpleName)
//        }
        /*}*/
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

    private fun medicalConditionGroupList() {
        showLoader()
        authViewModel.medicalConditionGroupList(ApiRequest())
    }

    private fun callRegister() {
        val apiRequest = ApiRequest().apply {
            session.user.let {
                contact_no = it?.contact_no
                email = it?.email
                languages_id = session.selectedLanguageId
                name = it?.name
                if (it?.dob.isNullOrBlank().not()) {
                    calDob.timeInMillis = DateTimeFormatter.date(it?.dob, "yyyy-MM-dd").date!!.time
                }
                dob = DateTimeFormatter.date(calDob.time)
                    .formatDateToCurrentTimeZone(DateTimeFormatter.FORMAT_yyyyMMdd)
                gender = it?.gender

                account_role = "P"

                active_deactive_id = ""
                is_accept_terms_accept = "Y"
                whatsapp_optin = "Y"
                email_verified = "N"
                medical_condition_group_id = chooseConditionAdapter.list.find { it.isSelected }?.medical_condition_group_id
                if (binding.editTextProvideCondition.text.toString().isNotBlank())
                    other_condition = binding.editTextProvideCondition.text.toString().trim()
                medical_condition_group_id = selectedMedicalCondition?.medical_condition_group_id
                /*medical_condition_ids =selectedMedicalConditionList.listOfField(MedicalConditionData::medical_condition_master_id)*/

                if (it?.access_code.isNullOrBlank().not() || it?.doctor_access_code.isNullOrBlank().not()) {
                    access_from = FirebaseLink.Values.accessFrom
                    access_code = it?.access_code
                    doctor_access_code = it?.doctor_access_code
                }
            }
        }
        showLoader()
        authViewModel.register(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.medicalConditionGroupListLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                allMedicalConditionList.clear()
                responseBody.data?.let { allMedicalConditionList.addAll(it) }
                //PM side user come and check the medical condtion our side and don't selected another acceess of user in this screen
                if (session.user?.medical_condition_group_id.isNullOrBlank().not() && session.user?.indication_name.isNullOrBlank().not()) {

                    val item = allMedicalConditionList.find { it.medical_condition_group_id == session.user?.medical_condition_group_id }

                    if (item != null) {
                        selectedMedicalCondition = item
                        binding.groupProvideCondition.isVisible = selectedMedicalCondition?.is_other.equals("Yes", true)
                        val index = allMedicalConditionList.indexOf(item)
                        allMedicalConditionList[index].isSelected = true
                    }

                }
                chooseConditionAdapter.notifyDataSetChanged()
            },
            onError = { throwable ->
                if(throwable is ServerException){
                    showAppMessage(throwable.message?:"",AppMsgStatus.ERROR)
                    false
                } else {
                    true
                }
            })

        authViewModel.registerLiveData.observe(this,
            onChange = { _ ->
                hideLoader()
                FirebaseLink.clearValues()
                //to update device info of registered user
                updateDeviceInfo()
                handleOnRegisterSuccess()
            },
            onError = { throwable ->
                if(throwable is ServerException){
                    showAppMessage(throwable.message?:"", AppMsgStatus.ERROR)
                    false
                } else {
                    true
                }
            })
    }
}