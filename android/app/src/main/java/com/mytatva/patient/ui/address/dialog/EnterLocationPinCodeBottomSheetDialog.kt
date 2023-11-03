package com.mytatva.patient.ui.address.dialog

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.core.content.res.ResourcesCompat
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.ViewModelProvider
import com.google.android.gms.maps.model.LatLng
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.AddressBottomsheetEnterLocationBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.location.MyLocationUtil
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable

class EnterLocationPinCodeBottomSheetDialog :
    BaseBottomSheetDialogFragment<AddressBottomsheetEnterLocationBinding>() {

    private lateinit var latLong: LatLng
    private val addressData: TestAddressData? by lazy {
        arguments?.parcelable(Common.BundleKey.TEST_ADDRESS_DATA)
    }
    val successCallBack: () -> Unit = {}

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AddressBottomsheetEnterLocationBinding {
        return AddressBottomsheetEnterLocationBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.EnterLocationPinCode)

        analytics.logEvent(
            analytics.SHOW_BOTTOM_SHEET,
            Bundle().apply {
                putString(analytics.PARAM_BOTTOM_SHEET_NAME, "add pincode")
            }, screenName = AnalyticsScreenNames.EnterLocationPinCode
        )

        //setView()
    }

    override fun onPause() {
        binding.editTextPinCode.clearFocus()
        hideKeyboardFrom(binding.editTextPinCode)
        super.onPause()
    }

    private fun setView() {
        with(binding) {
            editTextPinCode.requestFocus()
        }
    }

    override fun bindData() {
        setUpViewListeners()
        changeListener()

        binding.editTextPinCode.setText(addressData?.pincode?:"")
    }

    private fun setUpViewListeners() {
        with(binding) {
            textViewUseCurrentLocation.setOnClickListener { onViewClick(it) }
            textViewApply.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewApply -> {
                if (isValidPinCode) {
                    analytics.logEvent(
                        eventName = analytics.APPLY_CLICK,
                        bundle = Bundle().apply {
                            putString(analytics.PARAM_BOTTOM_SHEET_NAME, "add pincode")
                        },
                        screenName = AnalyticsScreenNames.EnterLocationPinCode
                    )
                    pinCodeAvailability()
                }
            }

            R.id.textViewUseCurrentLocation -> {
                analytics.logEvent(
                    eventName = analytics.USE_CURRENT_LOCATION,
                    bundle = Bundle().apply {
                        putString(analytics.PARAM_BOTTOM_SHEET_NAME, "add pincode")
                    },
                    screenName = AnalyticsScreenNames.EnterLocationPinCode
                )
                getTheCurrentLocationPinCode()
            }
        }
    }

    private fun getTheCurrentLocationPinCode() {
//        showLoader()
        locationManager.startLocationUpdates({ location, exception ->
        //            hideLoader()
            location?.let {
                //Current Location get
                val mLatLng = LatLng(location.latitude, location.longitude)
                Log.d("LatLng", ":: ${mLatLng.latitude} , ${mLatLng.longitude}")
                latLong = mLatLng

                if (isResumed) {
        //                    showLoader()
                    MyLocationUtil.getCurrantLocation(requireContext(), mLatLng,
                        callback = { address ->
                            hideLoader()
                            val pinCode = address?.postalCode ?: ""
                            //val city = address?.locality ?: address?.subAdminArea ?: ""
                            if (pinCode.isNotBlank()) {
                                binding.editTextPinCode.setText(pinCode)
                                binding.editTextPinCode.isSelected = true
                            } else {
                                showMessage(getString(R.string.common_msg_location_data_not_found))
                            }
                        })
                }
            }
            exception?.let {
                hideLoader()
                if (it.status == LocationManager.Status.NO_PERMISSION) {
                    (requireActivity() as BaseActivity).showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location))
                }
            }
        }, true)
    }

    private fun changeListener() = with(binding) {
        editTextPinCode.focusableSelectorBlackGray(inputLayoutEnterPinCode)
        editTextPinCode.doOnTextChanged { text, _, _, _ ->
            val digits = editTextPinCode.text?.toString()?.count() ?: 0
            textViewApply.isEnabled = text.isNullOrBlank() != true && digits == 6
            if (digits == 6) {
                analytics.logEvent(
                    eventName = analytics.PINCODE_ENTERED,
                    screenName = AnalyticsScreenNames.EnterLocationPinCode
                )
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
            } else if (this.text.toString() == "") {
                this.isSelected = b
                textInputLayout.isSelected = b
            }

            if (binding.editTextPinCode == this && !b) {
                isValidPinCode
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
        }
    }

    private val isValidPinCode: Boolean
        get() {
            return try {
                with(binding) {
                    validator.submit(editTextPinCode, inputLayoutEnterPinCode)
                        .checkEmpty().errorMessage(getString(R.string.validation_empty_pin_code))
                        .check()
                }
                true
            } catch (e: ApplicationException) {
                /*showAppMessage(e.message,AppMsgStatus.ERROR)*/
                false
            }
        }

    private fun pinCodeAvailability() {
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
        //pincodeAvailabilityLiveData
        doctorViewModel.pincodeAvailabilityLiveData.observe(this,
            onChange = {
                hideLoader()

                if (addressData==null) {
                    // for add new
                    val testAddressData = TestAddressData().apply {
                        pincode = binding.editTextPinCode.text.toString().trim()
                    }
                    arguments?.putParcelable(Common.BundleKey.TEST_ADDRESS_DATA, testAddressData)
                } else {
                    //for edit address
                    addressData?.pincode = binding.editTextPinCode.text.toString().trim()
                    arguments?.putParcelable(Common.BundleKey.TEST_ADDRESS_DATA, addressData)
                }

                binding.editTextPinCode.clearFocus()
                hideKeyboardFrom(binding.editTextPinCode)
                dismiss()
                EnterAddressBottomSheetDialog().apply {
                    this.arguments = this@EnterLocationPinCodeBottomSheetDialog.arguments
                    //addressData = this@EnterLocationPinCodeBottomSheetDialog.addressData
                }.show(requireActivity().supportFragmentManager, EnterAddressBottomSheetDialog::class.java.simpleName)
            },
            onError = {
                hideLoader()
                if (it is ServerException) {
                    it.message?.let { it1 ->
                        binding.inputLayoutEnterPinCode.error = it1
                        binding.inputLayoutEnterPinCode.isErrorEnabled = true
                    }
                    false
                } else {
                    true
                }
            })
    }
}