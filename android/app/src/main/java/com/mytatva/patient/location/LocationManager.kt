package com.mytatva.patient.location

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.IntentSender
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import android.os.Bundle
import android.os.Looper
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.ResolvableApiException
import com.google.android.gms.location.*
import com.google.android.gms.maps.model.LatLng
import com.mytatva.patient.ui.base.BaseActivity
import com.mytatva.patient.utils.PermissionUtil
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsClient
import com.mytatva.patient.utils.firebaseanalytics.AnalyticsScreenNames

import java.util.*
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.math.cos
import kotlin.math.sin
import kotlin.math.sqrt

/**
 * Created by  on 23/01/19.
 */
@Singleton
class LocationManager @Inject constructor(val context: Context) {

    companion object {
        private const val PLAY_SERVICES_RESOLUTION_REQUEST = 1000
        private const val REQUEST_CHECK_SETTINGS = 111
        const val REQUEST_CHECK_PERMISSION = 222
        private const val UPDATE_INTERVAL = 10000    // 10 seconds
        private const val FASTEST_INTERVAL = 4000   // 4 seconds
        private const val DISPLACEMENT = 1           // 1 meters
    }

    private var fusedLocationProviderClient: FusedLocationProviderClient
    private var settingsClient: SettingsClient
    private var locationSettingsRequest: LocationSettingsRequest
    private var googleApiAvailability: GoogleApiAvailability
    private var locationRequest: LocationRequest
    private var locationCallback: LocationCallback
    private var isSingleLocation = true
    private var callback: ((location: Location?, error: LocationException?) -> Unit)? = null
    private var callbackSingle: ((location: Location?, error: LocationException?) -> Unit)? = null

    var activity: Activity? = null
    var lastLocation: Location? = null

    val permissions: Array<String> = arrayOf(
        Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION
    )

    @Inject
    lateinit var analyticsClient: AnalyticsClient

    init {
        locationRequest = LocationRequest.create().setInterval(UPDATE_INTERVAL.toLong()).setFastestInterval(FASTEST_INTERVAL.toLong())
            .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY).setSmallestDisplacement(DISPLACEMENT.toFloat())

        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(context)

        settingsClient = LocationServices.getSettingsClient(context)

        locationSettingsRequest = LocationSettingsRequest.Builder().addLocationRequest(locationRequest).setAlwaysShow(true).build()

        googleApiAvailability = GoogleApiAvailability.getInstance()

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult?) {
                super.onLocationResult(locationResult)
                val location = locationResult?.lastLocation
                lastLocation = location
//                Timber.i("Location: [ %f , %f ]", location?.latitude, location?.longitude)
                lastLocation?.let {
                    analyticsClient.weUser?.setLocation(it.latitude, it.longitude)
                }
                callback?.invoke(location, null)
            }
        }
    }

    /**
     * Return last known location without fetching new location.
     */
    @SuppressLint("MissingPermission")
    fun fetchLastKnownLocation(callback: (location: Location?, exception: LocationException?) -> Unit) {
        isSingleLocation = true
        isPermissionGranted { isGranted ->
            if (isGranted) {
                fusedLocationProviderClient.lastLocation?.addOnCompleteListener {
                    if (it.isSuccessful) {
                        val location = it.result
                        lastLocation = location
//                        Timber.i("Location: [ %f , %f ]", location?.latitude, location?.longitude)
                        callback.invoke(location, null)
                    } else {
                        callback.invoke(
                            null, LocationException(it.exception?.message, Status.OTHER)
                        )
                    }
                }
            } else {
                callback.invoke(
                    null, LocationException("Location permission denied!", Status.NO_PERMISSION)
                )
            }
        }
    }

    /**
     * Fetch latest location.
     */
    @SuppressLint("MissingPermission")
    fun fetchLatestLocation(callback: (location: Location?, exception: LocationException?) -> Unit) {
        this.callbackSingle = callback
        isSingleLocation = true
        isPermissionGranted { isGranted ->
            if (isGranted) {
                isGooglePlayServicesAvailable { isAvailable, error ->
                    if (isAvailable) {
                        // Begin by checking if the device has the necessary location settings.
                        settingsClient.checkLocationSettings(locationSettingsRequest).addOnSuccessListener {
                                //                                Timber.i("All location settings are satisfied.")
                                LocationServices.getFusedLocationProviderClient(context).requestLocationUpdates(
                                        locationRequest, object : LocationCallback() {
                                            override fun onLocationResult(locationResult: LocationResult?) {
                                                super.onLocationResult(locationResult)
                                                val location = locationResult?.lastLocation
                                                lastLocation = location/*Timber.i(
                                                    "Location: [ %f , %f ]",
                                                    location?.latitude,
                                                    location?.longitude
                                                )*/
                                                callback.invoke(location, null)
                                                LocationServices.getFusedLocationProviderClient(
                                                    context
                                                ).removeLocationUpdates(this)
                                            }
                                        }, Looper.myLooper()
                                    ).addOnCompleteListener {
                                        if (!it.isSuccessful) {
                                            callback.invoke(
                                                null, LocationException(
                                                    it.exception?.message, Status.OTHER
                                                )
                                            )
                                        }
                                    }
                            }.addOnFailureListener {
                                when ((it as ApiException).statusCode) {
                                    LocationSettingsStatusCodes.RESOLUTION_REQUIRED -> {
//                                        Timber.i("Location settings are not satisfied. Attempting to upgrade location settings")
                                        try {
                                            // Cast to a resolvable exception.
                                            val resolvable = it as ResolvableApiException
                                            // Show the dialog by calling startResolutionForResult(),
                                            // and check the result in onActivityResult().
                                            resolvable.startResolutionForResult(
                                                activity, REQUEST_CHECK_SETTINGS
                                            )
                                        } catch (e: IntentSender.SendIntentException) {
                                            // Ignore the error.
//                                            Timber.i("PendingIntent unable to execute request.")
                                        } catch (e: ClassCastException) {
                                            // Ignore, should be an impossible error.
                                        }
                                    }

                                    LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE -> {
                                        val errorMessage = "Location settings are inadequate, and cannot be fixed here. Fix in Settings."
//                                        Timber.i(errorMessage)
                                        Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show()
                                    }

                                    else -> {

                                    }
                                }
                            }
                    } else {
                        callback.invoke(null, error)
                    }
                }
            } else {
                callback.invoke(
                    null, LocationException("Location permission denied!", Status.NO_PERMISSION)
                )
            }
        }
    }

    /**
     * Start fetching location updates.
     */
    @SuppressLint("MissingPermission")
    fun startLocationUpdates(
        callback: (location: Location?, exception: LocationException?) -> Unit,
        showLoader: Boolean
    ) {
        isSingleLocation = false
        this.callback = callback
        isPermissionGranted { isGranted ->
            if (isGranted) {
                (activity as BaseActivity?)!!.analytics.logEvent(AnalyticsClient.CLICKED_GRANT_LOCATION,Bundle().apply {
                    putString(
                        (activity as BaseActivity?)!!.analytics.PARAM_BOTTOM_SHEET_NAME,
                        (activity as BaseActivity?)!!.analytics.PARAM_GRANT_LOCATION_PERMISSION
                    )
                })

                Log.d("loader", "2. isGrantedPermission")
                isGooglePlayServicesAvailable { isAvailable, error ->
                    if (isAvailable) {
                        // Begin by checking if the device has the necessary location settings.
                        Log.d("loader", "3. isAvailable")
                        if (activity is BaseActivity && showLoader) {
                            (activity as BaseActivity).showLoader()
                        }
                        settingsClient.checkLocationSettings(locationSettingsRequest).addOnSuccessListener {
                                //                                Timber.i("All location settings are satisfied.")
                                /*fusedLocationProviderClient.requestLocationUpdates(
                                    locationRequest,
                                    locationCallback,
                                    Looper.myLooper()
                                )*/
                                Log.d("loader", "4. addOnSuccessListner")
                                LocationServices.getFusedLocationProviderClient(context).requestLocationUpdates(
                                        locationRequest, object : LocationCallback() {
                                            override fun onLocationResult(locationResult: LocationResult?) {
                                                super.onLocationResult(locationResult)
                                                val location = locationResult?.lastLocation
                                                lastLocation = location/*Timber.i(
                                                    "Location: [ %f , %f ]",
                                                    location?.latitude,
                                                    location?.longitude
                                                )*/
                                                Log.d("loader", "6. onLocationResult")
                                                callback.invoke(location, null)
                                                LocationServices.getFusedLocationProviderClient(
                                                    context
                                                ).removeLocationUpdates(this)
                                            }

                                            override fun onLocationAvailability(p0: LocationAvailability) {
                                                super.onLocationAvailability(p0)
                                                if (p0.isLocationAvailable) {
                                                    Log.d("isLocationAvailable", "true ")
                                                } else {
                                                    Log.d("isLocationAvailable", "false ")
                                                }
                                            }
                                        }, Looper.myLooper()
                                    ).addOnCanceledListener {
                                        Log.d("addOnCanceledListener", "startLocationUpdates: ")
                                    }.addOnFailureListener {
                                        Log.d("addOnFailureListener", "startLocationUpdates: ")
                                    }.addOnCompleteListener {

                                        /* if(activity is BaseActivity) {
                                             (activity as BaseActivity).hideLoader()
                                         }*/
                                        Log.d("loader", "7. addOnCompleteListener")
                                        if (!it.isSuccessful) {
                                            callback.invoke(
                                                null, LocationException(
                                                    it.exception?.message, Status.OTHER
                                                )
                                            )
                                        }
                                    }


                            }.addOnFailureListener {
                                Log.d("loader", "5. addOnFailureListener")
                                when ((it as ApiException).statusCode) {
                                    LocationSettingsStatusCodes.RESOLUTION_REQUIRED -> {
//                                        Timber.i("Location settings are not satisfied. Attempting to upgrade location settings")
                                        try {
                                            // Cast to a resolvable exception.
                                            val resolvable = it as ResolvableApiException
                                            // Show the dialog by calling startResolutionForResult(),
                                            // and check the result in onActivityResult().
                                            resolvable.startResolutionForResult(
                                                activity, REQUEST_CHECK_SETTINGS
                                            )
                                        } catch (e: IntentSender.SendIntentException) {
                                            // Ignore the error.
//                                            Timber.i("PendingIntent unable to execute request.")
                                        } catch (e: ClassCastException) {
                                            // Ignore, should be an impossible error.
                                        }
                                    }

                                    LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE -> {
                                        val errorMessage = "Location settings are inadequate, and cannot be fixed here. Fix in Settings."
//                                        Timber.i(errorMessage)
                                        Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show()
                                    }

                                    else -> {

                                    }
                                }
                            }
                    } else {
                        callback.invoke(null, error)
                    }
                }
            } else {/*callback.invoke(
                        null,
                        LocationException("Location permission denied!", Status.NO_PERMISSION)
                )*/
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestPermission()
                }
            }
        }
    }

    /**
     * Stop fetching location updates.
     */
    fun stopFetchLocationUpdates() {
//        Timber.i("STOP LOCATION UPDATES")
        fusedLocationProviderClient.removeLocationUpdates(locationCallback).addOnCompleteListener {
                //                Timber.i("STOP LOCATION UPDATES - COMPLETE")
            }
    }

    /**
     * Check whether Google Play Services are installed or not.
     */
    private fun isGooglePlayServicesAvailable(callback: (isAvailable: Boolean, error: LocationException?) -> Unit) {
        val result = googleApiAvailability.isGooglePlayServicesAvailable(context)
        if (result != ConnectionResult.SUCCESS) {
            if (googleApiAvailability.isUserResolvableError(result)) {
                googleApiAvailability.getErrorDialog(activity, result, PLAY_SERVICES_RESOLUTION_REQUEST) {
                        callback.invoke(
                            false, LocationException(googleApiAvailability.getErrorString(result))
                        )
                    }.show()
            } else {
                callback.invoke(
                    false, LocationException(googleApiAvailability.getErrorString(result))
                )
            }
        } else {
            callback.invoke(true, null)
        }
    }

    /**
     * Check if GPS of device is enabled or not.
     */
    fun checkResult(requestCode: Int, resultCode: Int, intent: Intent?) {
        when (requestCode) {
            REQUEST_CHECK_SETTINGS -> when (resultCode) {
                Activity.RESULT_OK -> {
                    // All required changes were successfully made
                    if (isSingleLocation) {
                        callbackSingle?.let {
                            fetchLatestLocation(it)
                        }
                    } else {
                        callback?.let {
                            startLocationUpdates(it, true)
                        }
                    }
                }

                Activity.RESULT_CANCELED -> {
                    callback?.invoke(
                        null, LocationException("GPS is disabled!", Status.GPS_DISABLED)
                    )
                    // The user was asked to change settings, but chose not to
                    //EventBus.getDefault().postSticky(LocationException("GPS is disabled!", Status.GPS_DISABLED))
                }

                else -> {
                    callback?.invoke(
                        null, LocationException(
                            "Can't get location, please check your settings!", Status.GPS_DISABLED
                        )
                    )
                    //EventBus.getDefault().postSticky(LocationException("Can't get location, please check your settings!", Status.GPS_DISABLED))
                }
            }

            PLAY_SERVICES_RESOLUTION_REQUEST -> {

            }

            else -> {

            }
        }
    }

    /**
     * To generate single random location in the radius of current location.
     * @param point current location
     * @param radius radius to generate random location in
     */
    fun getRandomLocation(point: LatLng, radius: Int): LatLng {

        val randomPoints = mutableListOf<LatLng>()
        val randomDistances = mutableListOf<Float>()
        val myLocation = Location("")
        myLocation.latitude = point.latitude
        myLocation.longitude = point.longitude

        //This is to generate 10 random points
        for (i in 0..9) {
            val x0 = point.latitude
            val y0 = point.longitude

            val random = Random()

            // Convert radius from meters to degrees
            val radiusInDegrees = (radius / 111000f).toDouble()

            val u = random.nextDouble() + 0.8
            val v = random.nextDouble() + 0.3
            val w = radiusInDegrees * sqrt(u)
            val t = 3.0 * Math.PI * v
            val x = w * cos(t)
            val y = w * sin(t)

            // Adjust the x-coordinate for the shrinking of the east-west distances
            val newX = x / cos(y0)

            val foundLatitude = newX + x0
            val foundLongitude = y + y0
            val randomLatLng = LatLng(foundLatitude, foundLongitude)
            randomPoints.add(randomLatLng)
            val l1 = Location("")
            l1.latitude = randomLatLng.latitude
            l1.longitude = randomLatLng.longitude
            randomDistances.add(l1.distanceTo(myLocation))
        }
        //Get nearest point to the centre
        val indexOfNearestPointToCentre = randomDistances.indexOf(Collections.min(randomDistances))
        return randomPoints[indexOfNearestPointToCentre]
    }

    /**
     * To generate random locations in the radius of current location.
     * @param point current location
     * @param radius radius to generate random location in
     * @param count number of locations to generate
     */
    fun getRandomLocations(point: LatLng, radius: Int, count: Int): List<LatLng> {
        val randomPoints = mutableListOf<LatLng>()
        for (i in 0..count) {
            randomPoints.add(getRandomLocation(point, radius))
        }
        return randomPoints
    }

    /**
     * To check whether the location permission is granted or not.
     */
    fun isPermissionGranted(callback: (isAvailable: Boolean) -> Unit) {
        callback.invoke(
            ActivityCompat.checkSelfPermission(
                context, Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                context, Manifest.permission.ACCESS_COARSE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        )
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    private fun requestPermission(): Boolean {
        if (activity != null) {
            if (ActivityCompat.checkSelfPermission(
                    activity!!, Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                    activity!!, Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                activity!!.requestPermissions(
                    arrayOf(
                        Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION
                    ), REQUEST_CHECK_PERMISSION
                )
            } else if (ActivityCompat.checkSelfPermission(
                    activity!!, Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                activity!!.requestPermissions(
                    arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION), REQUEST_CHECK_PERMISSION
                )
            } else if (ActivityCompat.checkSelfPermission(
                    activity!!, Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                activity!!.requestPermissions(
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), REQUEST_CHECK_PERMISSION
                )
            } else {
                return true
            }
            return false
        } else return false
    }

    /**
     * Request location permissions from outside of this class with callback
     *
     */
    @RequiresApi(api = Build.VERSION_CODES.M)
    fun requestPermissionCustom(successCallback: ((location: Location?, error: LocationException?) -> Unit)?): Boolean {
        this.callback = successCallback
        if (activity != null) {
            if (ActivityCompat.checkSelfPermission(
                    activity!!, Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                    activity!!, Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                activity!!.requestPermissions(
                    arrayOf(
                        Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION
                    ), REQUEST_CHECK_PERMISSION
                )
            } else if (ActivityCompat.checkSelfPermission(
                    activity!!, Manifest.permission.ACCESS_COARSE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                activity!!.requestPermissions(
                    arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION), REQUEST_CHECK_PERMISSION
                )
            } else if (ActivityCompat.checkSelfPermission(
                    activity!!, Manifest.permission.ACCESS_FINE_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                activity!!.requestPermissions(
                    arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), REQUEST_CHECK_PERMISSION
                )
            } else {
                return true
            }
            return false
        } else return false
    }

    fun requestPermissionPermanentDenied(activity: Activity): Boolean {
        var displayRational = false
        for (permission in permissions) {
            displayRational = displayRational or ActivityCompat.shouldShowRequestPermissionRationale(
                activity, permission
            )
        }
        return displayRational
    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        if (requestCode == REQUEST_CHECK_PERMISSION) {

            // We have requested multiple permissions for contacts, so all of them need to be
            // checked.
            if (PermissionUtil.verifyPermissions(grantResults)) {
                // All required permissions have been granted, display contacts fragment.
                // connectToClient()

                analyticsClient.logEvent(analyticsClient.LOCATION_PERMISSION, Bundle().apply {
                    putString(analyticsClient.PARAM_PERMISSION_TYPE, "allow")
                }, screenName = AnalyticsScreenNames.LocationPermission)

                callback?.let {
                    startLocationUpdates(it, true)
                }
            } else {

                analyticsClient.logEvent(analyticsClient.LOCATION_PERMISSION, Bundle().apply {
                    putString(analyticsClient.PARAM_PERMISSION_TYPE, "deny")
                }, screenName = AnalyticsScreenNames.LocationPermission)

                callback?.let {
                    it.invoke(
                        null, LocationException("Location permission denied!", Status.NO_PERMISSION)
                    )
                }/*if (locationListener != null)
                    locationListener.onFail(LocationListener.Status.PERMISSION_DENIED)*/
            }
        }
    }

    enum class Status {
        GPS_DISABLED, NO_PERMISSION, NO_PLAY_SERVICE, DENIED_LOCATION_SETTING, OTHER
    }
}
