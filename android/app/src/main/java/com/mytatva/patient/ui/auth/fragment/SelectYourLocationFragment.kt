package com.mytatva.patient.ui.auth.fragment

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.app.ActivityCompat
import androidx.core.os.bundleOf
import androidx.lifecycle.ViewModelProvider
import com.google.android.gms.maps.model.LatLng
import com.mytatva.patient.R
import com.mytatva.patient.core.Common
import com.mytatva.patient.data.model.CommonSelectItemData
import com.mytatva.patient.data.pojo.request.ApiRequest
import com.mytatva.patient.databinding.AuthFragmentSelectYourLocationBinding
import com.mytatva.patient.di.component.FragmentComponent
import com.mytatva.patient.exception.ApplicationException
import com.mytatva.patient.location.LocationManager
import com.mytatva.patient.location.MyLocationUtil
import com.mytatva.patient.ui.activity.AuthActivity
import com.mytatva.patient.ui.activity.IsolatedFullActivity
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.ui.base.BaseFragment
import com.mytatva.patient.ui.common.fragment.SelectItemFragment
import com.mytatva.patient.ui.viewmodel.AuthViewModel
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames
import com.mytatva.patient.utils.rnbridge.ContextHolder
import java.util.Calendar
import java.util.concurrent.TimeUnit


class SelectYourLocationFragment : BaseFragment<AuthFragmentSelectYourLocationBinding>() {

    var selectedStateId: String? = null
    private var selectedCity = ""
    private var selectedState = ""
    var resumedTime = Calendar.getInstance().timeInMillis

    private val isValid: Boolean
        get() {
            return try {
                if (selectedState.isBlank()) {
                    throw ApplicationException(getString(R.string.common_validation_select_state))
                }
                if (selectedCity.isBlank()) {
                    throw ApplicationException(getString(R.string.common_validation_select_city))
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

    override fun inject(fragmentComponent: FragmentComponent) {
        fragmentComponent.inject(this)
    }

    override fun createViewBinding(
        inflater: LayoutInflater,
        container: ViewGroup?,
        attachToRoot: Boolean,
    ): AuthFragmentSelectYourLocationBinding {
        return AuthFragmentSelectYourLocationBinding.inflate(inflater, container, attachToRoot)
    }

    override fun onResume() {
        super.onResume()
        analytics.setScreenName(AnalyticsScreenNames.SelectLocation)
        resumedTime = Calendar.getInstance().timeInMillis
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        observeLiveData()
    }

    override fun bindData() {
        setUserLocationData()
        setViewListeners()
    }

    private fun setUserLocationData() {
        if (activity is IsolatedFullActivity) {
            session.user?.let {
                with(binding) {
                    editTextSelectState.setText(it.state)
                    editTextSelectCity.setText(it.city)
                }
            }
        }
    }

    private fun setViewListeners() {
        binding.apply {
            imageViewBack.setOnClickListener { onViewClick(it) }
            editTextSelectState.setOnClickListener { onViewClick(it) }
            editTextSelectCity.setOnClickListener { onViewClick(it) }
            editTextDeviceLocation.setOnClickListener { onViewClick(it) }
            buttonSubmit.setOnClickListener { onViewClick(it) }
        }
    }

    override fun onViewClick(view: View) {
        when (view.id) {
            R.id.imageViewBack -> {
                navigator.goBack()
            }

            R.id.editTextSelectState -> {
                navigator.loadActivity(
                    IsolatedFullActivity::class.java,
                    SelectItemFragment::class.java
                )
                    .addBundle(
                        bundleOf(
                            Pair(Common.BundleKey.SELECT_TYPE, SelectItemFragment.SelectType.STATE)
                        )
                    ).forResult(Common.RequestCode.REQUEST_SELECT_STATE).start()
            }

            R.id.editTextSelectCity -> {
                if (binding.editTextSelectState.text.toString().trim().isNotBlank()) {
                    navigator.loadActivity(
                        IsolatedFullActivity::class.java,
                        SelectItemFragment::class.java
                    )
                        .addBundle(
                            bundleOf(
                                Pair(
                                    Common.BundleKey.SELECT_TYPE,
                                    SelectItemFragment.SelectType.CITY
                                ),
                                Pair(
                                    Common.BundleKey.STATE_NAME,
                                    binding.editTextSelectState.text.toString().trim()
                                )
                            )
                        ).forResult(Common.RequestCode.REQUEST_SELECT_CITY).start()
                } else {
                    showMessage(getString(R.string.common_validation_select_state))
                }
            }

            R.id.editTextDeviceLocation -> {
                locationManager.isPermissionGranted { granted ->
                    if (granted) {
                        showLoader()
                        startLocationUpdate()
                    } else {

                        requestLocationPermission()

                    }
                }


            }

            R.id.buttonSubmit -> {
                selectedState = binding.editTextSelectState.text.toString().trim()
                selectedCity = binding.editTextSelectCity.text.toString().trim()
                if (isValid) {
                    updatePatientLocation()
                }
            }
        }
    }

    private fun requestLocationPermission() {
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
                ), LocationManager.REQUEST_CHECK_PERMISSION
            )
        } else if (ActivityCompat.checkSelfPermission(
                requireContext(), Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(
                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION),
                LocationManager.REQUEST_CHECK_PERMISSION
            )
        } else if (ActivityCompat.checkSelfPermission(
                requireContext(), Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                LocationManager.REQUEST_CHECK_PERMISSION
            )
        }
    }


    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        when (requestCode) {
            LocationManager.REQUEST_CHECK_PERMISSION -> {
                if (PermissionUtil.verifyPermissions(grantResults)) {
                    showLoader()
                    startLocationUpdate()
                } else {
                    (requireActivity() as BaseActivity).showOpenPermissionSettingDialog(
                        arrayListOf(
                            BaseActivity.AndroidPermissions.Location
                        )
                    )
                }
            }
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    private fun startLocationUpdate() {
        showLoader()
        locationManager.startLocationUpdates { location, exception ->
            hideLoader()
            location?.let {
                val mLatLng = LatLng(location.latitude, location.longitude)
                locationManager.stopFetchLocationUpdates()
                Log.d("LatLng", ":: ${mLatLng?.latitude} , ${mLatLng?.longitude}")
                showLoader()
                MyLocationUtil.getCurrantLocation(requireContext(),
                    mLatLng,
                    callback = { address ->
                        hideLoader()
                        val state = address?.adminArea ?: ""
                        val city = address?.locality ?: address?.subAdminArea ?: ""
                        if (address != null && state.isNotBlank() && city.isNotBlank()) {
                            binding.editTextSelectState.setText(state)
                            binding.editTextSelectCity.setText(city)
                        } else {
                            showMessage(getString(R.string.common_msg_location_data_not_found))
                        }
                    })
            }
            exception?.let {
                hideLoader()
                if (it.status == LocationManager.Status.NO_PERMISSION) {
                    it.message?.let { it1 -> showMessage(it1) }
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (data != null && resultCode == Activity.RESULT_OK) {
            if (requestCode == Common.RequestCode.REQUEST_SELECT_STATE) {
                val commonSelectItemData: CommonSelectItemData =
                    data.getSerializableExtra(Common.BundleKey.COMMON_SELECT_ITEM_DATA) as CommonSelectItemData
                selectedStateId = commonSelectItemData.state_id
                binding.editTextSelectState.setText(commonSelectItemData.state_name)
                binding.editTextSelectCity.setText("")
            } else if (requestCode == Common.RequestCode.REQUEST_SELECT_CITY) {
                val commonSelectItemData: CommonSelectItemData =
                    data.getSerializableExtra(Common.BundleKey.COMMON_SELECT_ITEM_DATA) as CommonSelectItemData
                binding.editTextSelectCity.setText(commonSelectItemData.city_name)
            }
        } else {

        }
    }

    /**
     * *****************************************************
     * API calling methods
     * *****************************************************
     **/
    private fun updatePatientLocation() {
        val apiRequest = ApiRequest().apply {
            city = selectedCity
            state = selectedState
            country = "india"
        }
        showLoader()
        authViewModel.updatePatientLocation(apiRequest)
    }

    /**
     * *****************************************************
     * LiveData observers API Response
     * *****************************************************
     **/
    private fun observeLiveData() {
        authViewModel.updatePatientLocationLiveData.observe(this,
            onChange = { responseBody ->
                hideLoader()
                ContextHolder.reactContext?.let { sendEventToRN(it,"locationUpdatedSuccessfully","") }

                analytics.logEvent(
                    analytics.USER_SELECTED_CITY,
                    screenName = AnalyticsScreenNames.SelectLocation
                )
                analytics.logEvent(
                    analytics.USER_SELECTED_STATE,
                    screenName = AnalyticsScreenNames.SelectLocation
                )
                if (activity is AuthActivity) {
                    // for auth flow
                    navigator.loadActivity(AuthActivity::class.java, SetupDrugsFragment::class.java)
                        //.byFinishingCurrent()
                        .start()
                } else {
                    // change from setting
                    navigator.goBack()
                }
            },
            onError = { throwable ->
                hideLoader()
                true
            })
    }

    override fun onPause() {
        super.onPause()
        updateScreenTimeDurationInAnalytics()
    }

    private fun updateScreenTimeDurationInAnalytics() {
        val diffInMs: Long = Calendar.getInstance().timeInMillis - resumedTime
        val diffInSec: Int = TimeUnit.MILLISECONDS.toSeconds(diffInMs).toInt()
        analytics.logEvent(analytics.TIME_SPENT_UPDATE_LOCATION, Bundle().apply {
            putString(analytics.PARAM_DURATION_SECOND, diffInSec.toString())
        }, screenName = AnalyticsScreenNames.SelectLocation)
    }
}