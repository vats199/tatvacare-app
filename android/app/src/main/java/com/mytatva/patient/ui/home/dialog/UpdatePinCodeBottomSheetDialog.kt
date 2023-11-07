package com.mytatva.patient.ui.home.dialog

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import androidx.core.app.ActivityCompat
import androidx.core.content.res.ResourcesCompat
import androidx.core.widget.doOnTextChanged
import androidx.lifecycle.ViewModelProvider
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.google.android.gms.maps.model.LatLng
import com.google.android.material.textfield.TextInputLayout
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.GeoCodeApiData
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.AddressBottomsheetEnterLocationBinding
import com.mytatva.patient.di.component.ApplicationComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.location.MyLocationUtil
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable
import com.mytatva.patient.utils.rnbridge.ContextHolder
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Url

class UpdatePinCodeBottomSheetDialog(val successCallBack: () -> Unit) :
    BaseBottomSheetDialogFragment<AddressBottomsheetEnterLocationBinding>() {
    var selectedState = ""
    var selectedCity = ""
    val REQUEST_CHECK_PERMISSION = 333

    private val authViewModel by lazy {
        ViewModelProvider(this, viewModelFactory)[AuthViewModel::class.java]
    }

    private lateinit var latLong: LatLng
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
        binding.editTextPinCode.setText(addressData?.pincode ?: "")
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
                    analytics.logEvent(AnalyticsClient.PINCODE_ENTERED, Bundle().apply {
                        putString(
                            analytics.PARAM_BOTTOM_SHEET_NAME,
                            analytics.PARAM_GRANT_LOCATION_PERMISSION
                        )
                    })

                    checkGeocodeAPI(binding.editTextPinCode.text.toString())

                    analytics.logEvent(AnalyticsClient.CLICK_APPLY, Bundle().apply {
                        putString(
                            analytics.PARAM_BOTTOM_SHEET_NAME,
                            binding.editTextPinCode.text.toString()
                        )
                    })
                    //pinCodeAvailability()
                }
            }

            R.id.textViewUseCurrentLocation -> {
                locationManager.isPermissionGranted { granted ->
                    if (granted) {
                        showLoader()
                        getTheCurrentLocationPinCode()
                    } else {

                        if (ActivityCompat.checkSelfPermission(
                                requireContext(), Manifest.permission.ACCESS_COARSE_LOCATION
                            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                                requireContext(), Manifest.permission.ACCESS_FINE_LOCATION
                            ) != PackageManager.PERMISSION_GRANTED
                        ) {
                            requestPermissions(
                                arrayOf(
                                    Manifest.permission.ACCESS_COARSE_LOCATION,
                                    Manifest.permission.ACCESS_FINE_LOCATION
                                ), REQUEST_CHECK_PERMISSION
                            )
                        } else if (ActivityCompat.checkSelfPermission(
                                requireContext(), Manifest.permission.ACCESS_COARSE_LOCATION
                            ) != PackageManager.PERMISSION_GRANTED
                        ) {
                            requestPermissions(
                                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION),
                                REQUEST_CHECK_PERMISSION
                            )
                        } else if (ActivityCompat.checkSelfPermission(
                                requireContext(), Manifest.permission.ACCESS_FINE_LOCATION
                            ) != PackageManager.PERMISSION_GRANTED
                        ) {
                            requestPermissions(
                                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                                REQUEST_CHECK_PERMISSION
                            )
                        }

                    }
                }

            }
        }
    }

    interface APIInterface {
        @GET()
        fun checkPinCode(@Url urlString: String): Call<GeoCodeApiData>
    }

    private fun checkGeocodeAPI(pincode: String) {
        showLoader()

        val retrofit by lazy {
            Retrofit.Builder()
                .baseUrl("https://maps.googleapis.com/maps/api/")
                .addConverterFactory(GsonConverterFactory.create())
                .build()
                .create(APIInterface::class.java)
        }

        val call: Call<GeoCodeApiData> =
            retrofit.checkPinCode("geocode/json?address=${pincode}&key=AIzaSyD8zxk4kvKlAMGaOQrABy8xqdRKIWGBJlo")
        call.enqueue(object : Callback<GeoCodeApiData> {
            override fun onResponse(
                call: Call<GeoCodeApiData>,
                response: Response<GeoCodeApiData>
            ) {
                if (response.body() != null) {
                    if (response.body()!!.results!!.isNotEmpty()) {
                        try {
                            selectedState =
                                response.body()!!.results?.get(0)?.addressComponents?.single { addressComponent ->
                                    addressComponent?.types?.contains(
                                        "administrative_area_level_1"
                                    ) == true
                                }?.longName.toString()

                            selectedCity =
                                response.body()!!.results?.get(0)?.addressComponents?.single { addressComponent ->
                                    addressComponent?.types?.contains(
                                        "locality"
                                    ) == true
                                }?.longName.toString()
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }

                        updatePatientLocation()
                    } else {
                        binding.inputLayoutEnterPinCode.isErrorEnabled = true
                        if (response.body()!!.status == "ZERO_RESULTS") {
                            binding.inputLayoutEnterPinCode.error = "Enter a valid pincode"
                        } else {
                            binding.inputLayoutEnterPinCode.error = "Something went wrong!"
                        }
                    }
                }
                hideLoader()
            }

            override fun onFailure(call: Call<GeoCodeApiData>, t: Throwable) {
                hideLoader()
                binding.inputLayoutEnterPinCode.isErrorEnabled = true
                binding.inputLayoutEnterPinCode.error = "Something went wrong!"
            }
        })
    }

    private fun getTheCurrentLocationPinCode() {
        showLoader()
        locationManager.startLocationUpdates({ location, exception ->
            location?.let {
                val mLatLng = LatLng(location.latitude, location.longitude)
                Log.d("LatLng", ":: ${mLatLng.latitude} , ${mLatLng.longitude}")
                latLong = mLatLng

                MyLocationUtil.getCurrantLocation(requireContext(), mLatLng,
                    callback = { address ->
                        hideLoader()
                        selectedState = address?.adminArea ?: ""
                        selectedCity = address?.locality ?: address?.subAdminArea ?: ""
                        if (address != null && selectedState.isNotBlank() && selectedCity.isNotBlank()) {
                            updatePatientLocation()
                        }

                        val pinCode = address?.postalCode ?: ""
                        if (pinCode.isNotBlank()) {
                            analytics.logEvent(AnalyticsClient.USE_CURRENT_LOCATION, Bundle().apply {
                                putString(
                                    analytics.PARAM_BOTTOM_SHEET_NAME,
                                    pinCode
                                )
                            })

                            binding.editTextPinCode.setText(pinCode)
                            binding.editTextPinCode.isSelected = true
                        } else {
                            showMessage(getString(R.string.common_msg_location_data_not_found))
                        }
                    })
            }
            exception?.let {
                hideLoader()
                if (it.status == LocationManager.Status.NO_PERMISSION) {
                    (requireActivity() as BaseActivity).showOpenPermissionSettingDialog(
                        arrayListOf(
                            BaseActivity.AndroidPermissions.Location
                        )
                    )
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
        doctorViewModel.pincodeAvailabilityLiveData.observe(this,
            onChange = {
                hideLoader()

                if (addressData == null) {
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

        authViewModel.updatePatientLocationLiveData.observe(this,
            onChange = { responseBody ->
                val resultData: WritableMap = WritableNativeMap()
                resultData.putString("city", selectedCity)
                resultData.putString("state", selectedState)
                resultData.putString("country", "india")

                hideLoader()
                ContextHolder.reactContext?.let {
                    sendEventToRN(
                        it,
                        "locationUpdatedSuccessfully",
                        resultData
                    )
                }
                binding.editTextPinCode.clearFocus()
                hideKeyboardFrom(binding.editTextPinCode)
                dismiss()
                successCallBack.invoke()
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }


    private fun updatePatientLocation() {
        val apiRequest = ApiRequest().apply {
            city = selectedCity
            state = selectedState
            country = "india"
        }
        showLoader()
        authViewModel.updatePatientLocation(apiRequest)
    }


    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        if (requestCode == REQUEST_CHECK_PERMISSION) {
            if (PermissionUtil.verifyPermissions(grantResults)) {
                getTheCurrentLocationPinCode()
            } else {
                showOpenPermissionSettingDialog(arrayListOf(BaseActivity.AndroidPermissions.Location))
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

}