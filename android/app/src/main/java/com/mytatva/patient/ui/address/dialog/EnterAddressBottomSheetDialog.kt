package com.mytatva.patient.ui.address.dialog

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.os.bundleOf
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.ViewModelProvider
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.BcpDuration
import com.mytatva.patient.data.pojo.response.BcpPlanData
import com.mytatva.patient.data.pojo.response.ListCartData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.data.pojo.response.TestPatientData
import com.mytatva.patient.databinding.AddressBottomsheetEnterAddressBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.activity.VideoActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.labtest.fragment.v1.SelectLabtestAppointmentDateTimeFragmentV1
import com.mytatva.patient.ui.payment.bottomsheet.SelectAddressBottomSheetDialog
import com.mytatva.patient.ui.payment.fragment.v1.BcpOrderReviewFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable

class EnterAddressBottomSheetDialog :
    BaseBottomSheetDialogFragment<AddressBottomsheetEnterAddressBinding>() {

    private val bcpPlanData: BcpPlanData? by lazy {
        arguments?.parcelable(Common.BundleKey.PLAN_DATA)
    }

    private val bcpDuration: BcpDuration? by lazy {
        arguments?.parcelable(Common.BundleKey.PLAN_DURATION_DATA)
    }

    private val listCartData: ListCartData? by lazy {
        arguments?.getParcelable(Common.BundleKey.LIST_CART_DATA)
    }

    private val testPatientData: TestPatientData? by lazy {
        arguments?.getParcelable(Common.BundleKey.TEST_PATIENT_DATA)
    }

    var isOpenFromMap:Boolean=false

    /*private var pinCode:String? by lazy {
        arguments?.getParcelable(Common.BundleKey.PINCODE)
    }*/

    // for edit only
    private val addressData: TestAddressData? by lazy {
        arguments?.parcelable(Common.BundleKey.TEST_ADDRESS_DATA)
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.EnterAddress)
    }
    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AddressBottomsheetEnterAddressBinding {
        return AddressBottomsheetEnterAddressBinding.inflate(inflater, container, attachToRoot)
    }

    override fun bindData() = with(binding) {
        setUpViewListeners()
        changeListener()
        setUIDate()
    }

    private fun setUIDate() = with(binding){
        addressData.let {
            if (it?.pincode.isNullOrBlank().not()){
                editTextPinCode.setText(it?.pincode)
                editTextPinCode.isEnabled = false
                editTextPinCode.isFocusable = false
                editTextPinCode.isClickable = false
                editTextPinCode.isSelected = true
                editTextPinCode.background = ContextCompat.getDrawable(requireContext(),R.drawable.bg_edittext_gray_stroke_12_disable)
            }

            if (it?.address.isNullOrBlank().not()){
                editTextHouseNumberBuilding.setText(it?.address)
                editTextHouseNumberBuilding.isSelected = true
            }

            if (it?.street.isNullOrBlank().not()) {
                editTextStreetName.setText(it?.street)
                editTextStreetName.isSelected = true
            }

            if (it?.address_type?.isNotBlank() == true){
                it.address_type.let { type ->
                    when (type) {
                        Common.AddressTypes.WORK -> {
                            binding.radioOffice.isChecked = true
                        }
                        Common.AddressTypes.OTHER -> {
                            binding.radioOther.isChecked = true
                        }
                        else -> {
                            binding.radioHome.isChecked = true
                        }
                    }
                }
            }
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        bottomSheetState()
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSaveAddress.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSaveAddress -> {
                if (isValid) {
                    hideLoader()
                    analytics.logEvent(
                        eventName = analytics.TAP_SAVE_ADDRESS,
                        bundle = Bundle().apply {
                            putString(analytics.PARAM_BOTTOM_SHEET_NAME, "enter address")
                            putString(analytics.PARAM_ADDRESS_TYPE,
                                if (binding.radioHome.isChecked)
                                    Common.AddressTypes.HOME
                                else if(binding.radioOffice.isChecked)
                                    Common.AddressTypes.WORK
                                else
                                    Common.AddressTypes.OTHER
                            )
                        },
                        screenName = AnalyticsScreenNames.EnterAddress
                    )
                    updateAddress()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    private fun changeListener() = with(binding) {
        editTextPinCode.focusableSelectorBlackGray(inputLayoutPincode)
        editTextHouseNumberBuilding.focusableSelectorBlackGray(inputLayoutHouseNumberBuilding)
        editTextStreetName.focusableSelectorBlackGray(inputLayoutStreetName)
    }

    private fun bottomSheetState() = with(binding) {
        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
        }
    }

    private fun buttonEnable() = with(binding) {
        buttonSaveAddress.isEnabled = editTextPinCode.text?.isNotBlank() == true
                && editTextHouseNumberBuilding.text?.isNotBlank() == true
                && editTextStreetName.text?.isNotBlank() == true
    }

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

            if (binding.editTextPinCode == this && !b) {
                isValidPinCode
            } else if (binding.editTextHouseNumberBuilding == this && !b) {
                isValidHouseNumber
            } else if (binding.editTextStreetName == this && !b) {
                isValidStreetName
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

            textInputLayout.error = null
            textInputLayout.isErrorEnabled = false

            buttonEnable()
        }
    }

    private val isValidPinCode: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextPinCode, inputLayoutPincode)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_pin_code))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }

    private val isValidHouseNumber: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextHouseNumberBuilding, inputLayoutHouseNumberBuilding)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_empty_house_and_building))
                        .checkMinDigits(25)
                        .errorMessage(getString(R.string.validation_valid_house_and_building))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }

    private val isValidStreetName: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextStreetName, inputLayoutStreetName)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_street_name))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextPinCode, inputLayoutPincode)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_pin_code))
                        .check()

                    validator.submit(editTextHouseNumberBuilding, inputLayoutHouseNumberBuilding)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_empty_house_and_building))
                        .checkMinDigits(25)
                        .errorMessage(getString(R.string.validation_valid_house_and_building))
                        .check()

                    validator.submit(editTextStreetName, inputLayoutStreetName)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_street_name))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                //showAppMessage(requireActivity(), e.message, AppMsgStatus.ERROR)
                false
            }
        }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateAddress() {
        val apiRequest = ApiRequest().apply {
            address_id = this@EnterAddressBottomSheetDialog.addressData?.patient_address_rel_id
            name = session.user?.name
            pincodeSmall = binding.editTextPinCode.text.toString().trim()
            contact_no = session.user?.contact_no
            street = binding.editTextStreetName.text.toString().trim()
            address_type =
                if (binding.radioOffice.isChecked) Common.AddressTypes.WORK
                else if (binding.radioOther.isChecked) Common.AddressTypes.OTHER
                else Common.AddressTypes.HOME

            address = binding.editTextHouseNumberBuilding.text.toString().trim()

            val lat = this@EnterAddressBottomSheetDialog.addressData?.latitude
            val long = this@EnterAddressBottomSheetDialog.addressData?.longitude

            if (lat != null && long != null) {
                latitude = lat
                longitude = long
            }
        }
        showLoader()
        doctorViewModel.updateAddress(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //updateAddressLiveData
        doctorViewModel.updateAddressLiveData.observe(this,
            onChange = {response ->
                hideLoader()
                response.data?.let { addressData ->
                    if(this.addressData?.patient_address_rel_id?.isNotBlank() == true){
                        //edit flow
                        if(isOpenFromMap) {
                            (requireActivity() as BaseActivity).finish()
                        } else {
                            //send update broadcast to refresh address list
                            dismiss()
                            val broadCastIntent = Intent(SelectAddressBottomSheetDialog.ACTION_ADDRESS_UPDATED)
                            LocalBroadcastManager.getInstance(requireContext()).sendBroadcast(broadCastIntent)
                        }
                    } else {
                        //add flow
                        if (bcpPlanData != null) {
                            handleBCPNavigationOnAddressUpdate(addressData)
                        } else {
                            handleLabTestOnAddressUpdate(addressData)
                        }
                        dismiss()
                    }

                    /*if (this.addressData == null || this.addressData!!.patient_address_rel_id.isNullOrBlank()) {
                        //add flow
                        if (bcpPlanData != null) {
                            handleBCPNavigationOnAddressUpdate(addressData)
                        } else {
                            handleLabTestOnAddressUpdate(addressData)
                        }
                    } else {
                        //edit flow
                        (requireActivity() as BaseActivity).finish()
                    }*/

                }
            },
            onError = {
                hideLoader()
                if (it is ServerException){
                    it.message?.let { it1 -> (requireActivity() as  BaseActivity).showAppMessage(it1, AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })


    }

    private fun handleLabTestOnAddressUpdate(addressData: TestAddressData) {
        if (addressData == null) {
            analytics.logEvent(
                analytics.LABTEST_ADDRESS_ADDED,
                screenName = AnalyticsScreenNames.AddAddress
            )
        } else {
            analytics.logEvent(analytics.LABTEST_ADDRESS_UPDATED, Bundle().apply {
                putString(analytics.PARAM_ADDRESS_ID, addressData?.patient_address_rel_id)
            }, screenName = AnalyticsScreenNames.AddAddress)
        }


        if (isOpenFromMap) {
            (requireActivity() as BaseActivity).loadActivity(
                IsolatedFullActivity::class.java,
                SelectLabtestAppointmentDateTimeFragmentV1::class.java
            )
                .addBundle(
                    bundleOf(
                        Pair(Common.BundleKey.LIST_CART_DATA, listCartData),
                        Pair(Common.BundleKey.TEST_PATIENT_DATA, testPatientData),
                        Pair(Common.BundleKey.TEST_ADDRESS_DATA, addressData)
                    )
                ).byFinishingCurrent().start()
        } else {
            (requireActivity() as BaseActivity).loadActivity(
                IsolatedFullActivity::class.java,
                SelectLabtestAppointmentDateTimeFragmentV1::class.java
            )
                .addBundle(
                    bundleOf(
                        Pair(Common.BundleKey.LIST_CART_DATA, listCartData),
                        Pair(Common.BundleKey.TEST_PATIENT_DATA, testPatientData),
                        Pair(Common.BundleKey.TEST_ADDRESS_DATA, addressData)
                    )
                ).start()
        }
    }
    private fun handleBCPNavigationOnAddressUpdate(addressData: TestAddressData) {



        if (isOpenFromMap) {
            (requireActivity() as BaseActivity).loadActivity(
                IsolatedFullActivity::class.java,
                BcpOrderReviewFragment::class.java
            ).addBundle(Bundle().apply {
                putParcelable(Common.BundleKey.TEST_ADDRESS_DATA, addressData)
                putParcelable(Common.BundleKey.PLAN_DATA, bcpPlanData)
                putParcelable(Common.BundleKey.PLAN_DURATION_DATA, bcpDuration)
            }).byFinishingCurrent().start()
        } else {
            (requireActivity() as BaseActivity).loadActivity(
                IsolatedFullActivity::class.java,
                BcpOrderReviewFragment::class.java
            ).addBundle(Bundle().apply {
                putParcelable(Common.BundleKey.TEST_ADDRESS_DATA, addressData)
                putParcelable(Common.BundleKey.PLAN_DATA, bcpPlanData)
                putParcelable(Common.BundleKey.PLAN_DURATION_DATA, bcpDuration)
            }).start()
        }

    }
}