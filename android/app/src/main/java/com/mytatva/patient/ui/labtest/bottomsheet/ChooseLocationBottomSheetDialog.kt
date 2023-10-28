package com.mytatva.patient.ui.labtest.bottomsheet

import android.content.DialogInterface
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
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.R
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.LabtestBottomsheetChooseYourLocationBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.location.MyLocationUtil
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

class ChooseLocationBottomSheetDialog : BaseBottomSheetDialogFragment<LabtestBottomsheetChooseYourLocationBinding>() {

    companion object {
        var currentPinCode = ""
    }

    var callback: (pincode: String) -> Unit?={}

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
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
    override fun injectDependencies(applicationComponent: ApplicationComponent) {
        applicationComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): LabtestBottomsheetChooseYourLocationBinding {
        return LabtestBottomsheetChooseYourLocationBinding.inflate(inflater,
            container,
            attachToRoot)

    }

    override fun onPause() {
        binding.editTextPinCode.clearFocus()
        hideKeyboardFrom(binding.editTextPinCode)
        super.onPause()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.EnterLocationPinCode)

        analytics.logEvent(analytics.SHOW_BOTTOM_SHEET,
            Bundle().apply {
                putString(analytics.PARAM_BOTTOM_SHEET_NAME, "add pincode")
            }, screenName = AnalyticsScreenNames.EnterLocationPinCode
        )

        //setView()
    }

    private fun setView() {
        with(binding) {
            editTextPinCode.requestFocus()
        }
    }

    override fun bindData() {
        dialog?.setOnShowListener {
            val bottomSheetBehavior =
                BottomSheetBehavior.from(dialog!!.findViewById(com.google.android.material.R.id.design_bottom_sheet))
            bottomSheetBehavior.skipCollapsed = true
            bottomSheetBehavior.setState(BottomSheetBehavior.STATE_EXPANDED)
        }
        setViewListener()
        changeListener()
    }

    private fun setViewListener() {
        binding.apply {
            textViewSelectCurrentLocation.setOnClickListener { onViewClick(it) }
//            textViewCancel.setOnClickListener { onViewClick(it) }
            buttonApply.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.textViewSelectCurrentLocation -> {

                analytics.logEvent(
                    eventName = analytics.USE_CURRENT_LOCATION,
                    bundle = Bundle().apply {
                        putString(analytics.PARAM_BOTTOM_SHEET_NAME, "add pincode")
                    },
                    screenName = AnalyticsScreenNames.EnterLocationPinCode
                )

                showLoader()
                locationManager.startLocationUpdates { location, exception ->
                    hideLoader()
                    location?.let {
                        val mLatLng = LatLng(location.latitude, location.longitude)
                        locationManager.stopFetchLocationUpdates()
                        Log.d("LatLng", ":: ${mLatLng?.latitude} , ${mLatLng?.longitude}")
                        if (isAdded) {
                            showLoader()
                            MyLocationUtil.getCurrantLocation(requireContext(),
                                mLatLng,
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
//                            it.message?.let { it1 -> showMessage(it1) }
                            (requireActivity() as BaseActivity).showOpenPermissionSettingDialog(
                                arrayListOf(BaseActivity.AndroidPermissions.Location),
                                onSettingCallback = {
                                    dismiss()
                                }
                            )
                        }
                    }
                }
            }
            R.id.textViewCancel -> {
                dismiss()
            }
            R.id.buttonApply -> {
                if (isValidPinCode) {
                    analytics.logEvent(
                        eventName = analytics.APPLY_CLICK,
                        bundle = Bundle().apply {
                            putString(analytics.PARAM_BOTTOM_SHEET_NAME, "add pincode")
                        },
                        screenName = AnalyticsScreenNames.EnterLocationPinCode
                    )
                    pincodeAvailability()
                }
            }
        }
    }

    private fun changeListener() = with(binding) {
        editTextPinCode.focusableSelectorBlackGray(inputLayoutEnterPinCode)
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

            binding.buttonApply.isEnabled = text.isNullOrBlank() != true  && (this.text?.toString()?.count()
                ?: 0) == 6

            val digits = text.toString().count()
            if (digits == 6) {
                analytics.logEvent(
                    eventName = analytics.PINCODE_ENTERED,
                    screenName = AnalyticsScreenNames.EnterLocationPinCode
                )
            }

            textInputLayout.error = null
            textInputLayout.isErrorEnabled = false
        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
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
        //pincodeAvailabilityLiveData
        doctorViewModel.pincodeAvailabilityLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                currentPinCode = binding.editTextPinCode.text.toString().trim()
                callback.invoke(binding.editTextPinCode.text.toString().trim())
                dismiss()
            },
            onError = {
                hideLoader()
                if (it is ServerException){
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