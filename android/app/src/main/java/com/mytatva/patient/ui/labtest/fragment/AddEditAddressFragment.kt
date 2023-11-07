package com.mytatva.patient.ui.labtest.fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.LabtestFragmentAddEditAddressBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames


class AddEditAddressFragment : BaseFragment<LabtestFragmentAddEditAddressBinding>() {

    //var resumedTime = Calendar.getInstance().timeInMillis

    private val addressData: TestAddressData? by lazy {
        arguments?.getParcelable(Common.BundleKey.ADDRESS_DATA)
    }

    private val isValid: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextName)
                        .checkEmpty().errorMessage(getString(R.string.common_validation_empty_name))
                        .matchPatter(Common.NAME_PATTERN)
                        .errorMessage(getString(R.string.validation_valid_name))
                        .check()

                    validator.submit(editTextMobileNumber)
                        .checkEmpty()
                        .errorMessage(getString(R.string.common_validation_empty_mobile_number))
                        .checkMinDigits(10)
                        .errorMessage(getString(R.string.common_validation_invalid_mobile_number))
                        .check()

                    validator.submit(editTextPinCode)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_pin_code))
                        .check()

                    validator.submit(editTextHouseNumberBuilding)
                        .checkEmpty()
                        .errorMessage(getString(R.string.validation_empty_house_number_and_building))
                        .checkMinDigits(25)
                        .errorMessage(getString(R.string.validation_valid_house_number_and_building))
                        .check()

                    validator.submit(editTextStreetName)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_street_name))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                showMessage(e.message)
                false
            }
        }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestFragmentAddEditAddressBinding {
        return LabtestFragmentAddEditAddressBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.AddAddress)
        //resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun bindData() {
        setUpToolbar()
        setUpViewListeners()
        setDataForEdit()
    }

    private fun setDataForEdit() {
        addressData?.let {
            with(binding) {
                editTextName.setText(it.name)
                editTextMobileNumber.setText(it.contact_no)
                editTextPinCode.setText(it.pincode)
                editTextHouseNumberBuilding.setText(it.address)
                editTextStreetName.setText(it.street)
                radioHome.isChecked = it.address_type == Common.AddressTypes.HOME
                radioWork.isChecked = it.address_type == Common.AddressTypes.WORK
                radioOther.isChecked = it.address_type == Common.AddressTypes.OTHER
            }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonSave.setOnClickListener { onViewClick(it) }
            //editTextName.dontAllowAsPrefix(".")
            /*editTextName.addTextChangedListener(object : TextWatcher {
                override fun beforeTextChanged(
                    s: CharSequence?,
                    start: Int,
                    count: Int,
                    after: Int,
                ) {

                }

                override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

                }

                override fun afterTextChanged(s: Editable) {
                    if(s.length == 1 && s[0] == '.'){
                        editTextName.setText("");
                    }
                }
            })*/
        }
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            textViewToolbarTitle.text = getString(R.string.labtest_add_address_title)
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            imageViewNotification.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.buttonSave -> {
                if (isValid) {
                    pincodeAvailability()
                }
            }
            R.id.imageViewToolbarBack -> {
                navigator.goBack()
            }
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updateAddress() {
        val apiRequest = ApiRequest().apply {
            address_id = addressData?.patient_address_rel_id //for edit
            name = binding.editTextName.text.toString().trim()
            pincodeSmall = binding.editTextPinCode.text.toString().trim()
            contact_no = binding.editTextMobileNumber.text.toString().trim()
            street = binding.editTextStreetName.text.toString().trim()
            address_type =
                if (binding.radioHome.isChecked) Common.AddressTypes.HOME
                else if (binding.radioWork.isChecked) Common.AddressTypes.WORK
                else Common.AddressTypes.OTHER
            address = binding.editTextHouseNumberBuilding.text.toString().trim()
        }
        showLoader()
        doctorViewModel.updateAddress(apiRequest)
    }

    private fun pincodeAvailability() {
        val apiRequest = ApiRequest().apply {
            Pincode = binding.editTextPinCode.text.toString().trim()
        }
        showLoader()
        doctorViewModel.pincodeAvailability(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        //updateAddressLiveData
        doctorViewModel.updateAddressLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                if (addressData == null) {
                    analytics.logEvent(analytics.LABTEST_ADDRESS_ADDED,
                        screenName = AnalyticsScreenNames.AddAddress)
                } else {
                    analytics.logEvent(analytics.LABTEST_ADDRESS_UPDATED, Bundle().apply {
                        putString(analytics.PARAM_ADDRESS_ID, addressData?.patient_address_rel_id)
                    }, screenName = AnalyticsScreenNames.AddAddress)
                }
                navigator.goBack()
            },
            onError = { throwable ->
                hideLoader()
                true
            })

        //pincodeAvailabilityLiveData
        doctorViewModel.pincodeAvailabilityLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                updateAddress()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    override fun onPause() {
        super.onPause()
        //updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        /*val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_MY_DEVICES, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        })*/
    }
}