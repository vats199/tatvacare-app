package com.mytatva.patient.ui.address.fragment

import android.app.Activity
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.location.Geocoder
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.result.contract.ActivityResultContracts.StartActivityForResult
import androidx.annotation.RequiresApi
import androidx.lifecycle.ViewModelProvider
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.LocationSettingsStatusCodes
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.widget.Autocomplete
import com.google.android.libraries.places.widget.model.AutocompleteActivityMode
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.data.pojo.response.TestAddressData
import com.mytatva.patient.databinding.ConfirmLocationFragmentAddressBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ServerException
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.location.MyLocationUtil
import com.mytatva.patient.ui.address.dialog.EnterAddressBottomSheetDialog
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseBottomSheetDialogFragment
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.viewmodel.DoctorViewModel
import com.mytatva.patient.utils.AppMsgStatus
import com.mytatva.patient.utils.enableShadow
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.parcelable
import java.util.Arrays
import java.util.Locale


class AddressConfirmLocationFragment:BaseFragment<ConfirmLocationFragmentAddressBinding>(), OnMapReadyCallback {

    private lateinit var googleMap: GoogleMap
    private var supportMapFragment: SupportMapFragment? = null
    private var locationRequest: LocationRequest? = null
    private var addressData: TestAddressData = TestAddressData()

    private val startAutocomplete = registerForActivityResult(StartActivityForResult()) { result ->
        if (result.getResultCode() === Activity.RESULT_OK) {
            val intent: Intent? = result.getData()
            if (intent != null) {
                val place = Autocomplete.getPlaceFromIntent(intent)
//                latLng = place.latLng
                setMarkerPosition(place.latLng)
                locationByDragging()
                getCurrentLocation()
            }
        } else if (result.getResultCode() === Activity.RESULT_CANCELED) {
            // The user canceled the operation.
            Log.i(
                AddressConfirmLocationFragment::class.java.simpleName,
                "User canceled autocomplete"
            )
        }
    }

    private val doctorViewModel by lazy {
        ViewModelProvider(
            this,
            viewModelFactory
        )[DoctorViewModel::class.java]
    }

    private var latLng : LatLng? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        if (supportMapFragment == null) {
            supportMapFragment = SupportMapFragment.newInstance()
            childFragmentManager.beginTransaction()
                .replace(R.id.frameLayoutMap, supportMapFragment!!).commitAllowingStateLoss()
        }
        supportMapFragment?.getMapAsync(this)
        autoGoogleMapIntialize()
        observeLiveData()
    }

    private fun autoGoogleMapIntialize() {
        // Fetching API_KEY which we wrapped
        val ai: ApplicationInfo = requireActivity().applicationContext.packageManager
            .getApplicationInfo(requireActivity().applicationContext.packageName, PackageManager.GET_META_DATA)

        val value = ai.metaData[getString(R.string.google_api_id)]
        val apiKey = value.toString()

        if (!Places.isInitialized()) {
            Places.initialize(requireActivity().applicationContext, getString(R.string.google_api_id), Locale.US)
        }
    }

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): ConfirmLocationFragmentAddressBinding {
        return ConfirmLocationFragmentAddressBinding.inflate(layoutInflater)
    }

    override fun bindData() {
//        latLng = arguments?.getParcelable(Common.MapKey.LATLONG) ?: null
        if (arguments?.containsKey(Common.BundleKey.TEST_ADDRESS_DATA) == true){
            addressData = arguments?.parcelable<TestAddressData>(Common.BundleKey.TEST_ADDRESS_DATA) ?: TestAddressData()
            latLng = LatLng(addressData.latitude!!.toDouble(), addressData.longitude!!.toDouble())
        }

        setUpToolbar()
        setUpViewListeners()
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.ConfirmLocationMap)
    }

    private fun setUpToolbar() {
        binding.layoutHeader.apply {
            root.enableShadow()
            textViewToolbarTitle.text = "Confirm location"
            imageViewNotification.visibility = View.GONE
            imageViewUnreadNotificationIndicator.visibility = View.GONE
            buttonToolbarBook.visibility = View.GONE
            imageViewToolbarBack.setOnClickListener { onViewClick(it) }
        }
    }

    private fun setUpViewListeners() {
        with(binding) {
            buttonUseCurrentLocation.setOnClickListener { onViewClick(it) }
            editTextSearchLocation.setOnClickListener { onViewClick(it) }
            buttonAddCompleteAddress.setOnClickListener { onViewClick(it) }
        }
    }

    fun onSearchCalled() {
        // Set the fields to specify which types of place data to return.
        val fields: List<Place.Field> = Arrays.asList(Place.Field.ID,
            Place.Field.NAME,
            Place.Field.ADDRESS,
            Place.Field.LAT_LNG)
        // Start the autocomplete intent.
        val intent: Intent = Autocomplete.IntentBuilder(
            AutocompleteActivityMode.FULLSCREEN, fields)
            .build(requireContext())

        startAutocomplete.launch(intent)
    }

    override fun onViewClick(view: View) {

        when (view.id) {
            R.id.imageViewToolbarBack -> {
                analytics.logEvent(analytics.BACK_BUTTON_CLICK,
                    Bundle().apply {
                        putString(analytics.PARAM_SCREEN_NAME, "map screen")
                    }, screenName = AnalyticsScreenNames.ConfirmLocationMap
                )
                navigator.goBack()
            }
            R.id.editTextSearchLocation -> {
                analytics.logEvent(analytics.LOCATION_SEARCH,
                    screenName = AnalyticsScreenNames.ConfirmLocationMap
                )
                onSearchCalled()
            }
            R.id.buttonUseCurrentLocation -> {
                setCurrentLocation()
            }
            R.id.buttonAddCompleteAddress -> {
                analytics.logEvent(analytics.TAP_COMPLETE_ADDRESS,
                    Bundle().apply {
                        putString(analytics.PARAM_SCREEN_NAME, "map screen")
                    },
                    screenName = AnalyticsScreenNames.ConfirmLocationMap
                )
                pincodeAvailability()
            }
        }
    }

    private fun setCurrentLocation() {
        if (isVisible) {
            showLoader()
            locationManager.startLocationUpdates({ location, exception ->
                hideLoader()
                location?.let {
                    //Current Location get
                    val mLatLng = LatLng(location.latitude, location.longitude)
                    Log.d("LatLng", ":: ${mLatLng.latitude} , ${mLatLng.longitude}")

                    if (mLatLng.latitude != 0.0 && mLatLng.longitude != 0.0) {
                        setMarkerPosition(LatLng(mLatLng.latitude, mLatLng.longitude))
                    }

                    locationByDragging()
                    getCurrentLocation()
                }
                exception?.let {
                    hideLoader()
                    if (it.status == LocationManager.Status.NO_PERMISSION) {
                        (requireActivity() as BaseActivity).showOpenPermissionSettingDialog(arrayListOf(
                            BaseActivity.AndroidPermissions.Location))
                    }
                }
            }, true)
        }
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        val fragment = requireActivity().supportFragmentManager.fragments.find { it is BaseBottomSheetDialogFragment<*> }
        Log.d("onActivityResult","$fragment")
        if(fragment != null) {
            (fragment as BottomSheetDialogFragment)
                .onActivityResult(requestCode, resultCode, data)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        Log.e("onRequestPermissionsResult","$requestCode")
        val fragment = requireActivity().supportFragmentManager.fragments.find { it is BaseBottomSheetDialogFragment<*> }
        Log.d("onRequestPermissionsResult","$fragment")

        if (fragment != null) {
            (fragment as BottomSheetDialogFragment)
                .onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    override fun onMapReady(googleMapReady: GoogleMap) {
        googleMap = googleMapReady
        if (latLng != null) {
            if (latLng!!.latitude != 0.0 && latLng!!.longitude != 0.0) {
                setMarkerPosition(LatLng(latLng!!.latitude, latLng!!.longitude))
            }
        }
        locationByDragging()
        getCurrentLocation()
    }

    private fun locationByDragging() {
        googleMap.setOnCameraIdleListener {
            Geocoder(requireContext())
            val latLng = googleMap.cameraPosition.target
            getAddressFromLatLng(latLng)
            //logError("locationByDragging: $latLng")
        }
    }

    private fun setMarkerPosition(latLng: LatLng?) {
        latLng?.let {
            val cameraUpdate = CameraUpdateFactory.newLatLngZoom(latLng, 16F)
            googleMap.animateCamera(cameraUpdate)
            getAddressFromLatLng(latLng)
        }
    }

    private fun getAddressFromLatLng(latLng: LatLng?) {
        if (latLng != null)
            this.latLng = latLng
        val geocoder = Geocoder(requireContext(), Locale.getDefault())
        try {
            latLng?.let {
                val addressList = geocoder.getFromLocation(latLng.latitude, latLng.longitude, 1)
                val address = addressList?.get(0)?.getAddressLine(0)
                val city = addressList?.get(0)?.locality

                Log.e("getAddressFromLatLng","$addressList")
                addressData.apply {
                    this.address = address
                }
                analytics.logEvent(analytics.MAP_USAGE,
                    screenName = AnalyticsScreenNames.ConfirmLocationMap
                )
                binding.textViewAddress.text = address
                binding.textViewLabelStreetName.text = city

            }
        } catch (e: Exception) {
            //logError(e)
        }
    }

    private fun getCurrentLocation() {
        locationRequest = LocationRequest.create().apply {
            numUpdates = 1
            priority = LocationRequest.PRIORITY_HIGH_ACCURACY
            interval = 4000
            fastestInterval = 2000
        }

        val builder = LocationSettingsRequest.Builder().addLocationRequest(locationRequest!!)

        builder.setAlwaysShow(true)

        val result = LocationServices.getSettingsClient(requireContext())
            .checkLocationSettings(builder.build())

        result.addOnCompleteListener { task ->
            try {
                //val response = task.getResult(ApiException::class.java)

               /* Handler(Looper.getMainLooper()).postDelayed({
                    getLastKnowLocation()
                }, 500)*/
            } catch (e: ApiException) {
                try {
                    when (e.statusCode) {
                        LocationSettingsStatusCodes.RESOLUTION_REQUIRED -> {
                            val resolvableApiException = e as ResolvableApiException
                            resolvableApiException.startResolutionForResult(requireActivity(), 1)
                        }
                    }
                } catch (e: Exception) {
//                    requestLocationPermission()
                    //setUpAlertDialog("This permission require to access location")
                }
            }
        }
    }

    private fun pincodeAvailability() {
        latLng.let {
            val mLatLng = LatLng(it!!.latitude, it.longitude)
            locationManager.stopFetchLocationUpdates()
            Log.d("LatLng", ":: ${mLatLng.latitude} , ${mLatLng.longitude}")
            if (isAdded) {
                showLoader()
                MyLocationUtil.getCurrantLocation(requireContext(),
                    mLatLng,
                    callback = { address ->
                        val pinCode = address?.postalCode ?: ""
                        if (pinCode.isNotBlank()) {
                            val apiRequest = ApiRequest().apply {
                                Pincode = pinCode
                            }
                            showLoader()
                            doctorViewModel.pincodeAvailability(apiRequest)
                        } else {
                            hideLoader()
                        }
                    })
            }
        }
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
                if (latLng != null){
                    MyLocationUtil.getCurrantLocation(requireContext(),
                        latLng!!,
                        callback = { address ->
                            val pinCode = address?.postalCode ?: ""
                            if (pinCode.isNotBlank()) {
                                addressData.let {
                                    it.pincode = pinCode
                                    it.latitude = latLng?.latitude.toString()
                                    it.longitude = latLng?.longitude.toString()
                                }
                                EnterAddressBottomSheetDialog().apply {
                                    isOpenFromMap = true
                                    arguments = this@AddressConfirmLocationFragment.arguments
                                    //addressData = this@AddressConfirmLocationFragment.addressData
                                }.show(parentFragmentManager,EnterAddressBottomSheetDialog::class.java.simpleName)
                            }
                        })
                }
            },
            onError = {
                hideLoader()
                if (it is ServerException){
                    it.message?.let { it1 -> showAppMessage(it1, AppMsgStatus.ERROR) }
                    false
                } else {
                    true
                }
            })
    }
}