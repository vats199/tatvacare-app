package com.mytatva.patient.location


/**
 * Created by  on 27/6/18.
 */
class LocationException(
    val message: String? = "Error",
    val status: LocationManager.Status = LocationManager.Status.OTHER
)