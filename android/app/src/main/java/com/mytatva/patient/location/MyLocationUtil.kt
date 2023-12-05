package com.mytatva.patient.location

import android.content.Context
import android.location.Address
import android.location.Geocoder
import com.google.android.gms.maps.model.LatLng
import java.io.IOException

object MyLocationUtil {

    fun getCurrantLocation(
        context: Context?,
        latLng: LatLng,
        callback: (address: Address?) -> Unit,
    ) {
        val geocoder: Geocoder = Geocoder(context!!)
        var location: List<Address?>? = null
        try {
            location = geocoder.getFromLocation(latLng.latitude, latLng.longitude, 1)
        } catch (o: IOException) {
            o.printStackTrace()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        if (location != null && location.isNotEmpty()) {
            /*e.onSuccess(location[0])*/
            callback.invoke(location[0])
        } else {
            callback.invoke(null)
        }
    }

    fun getCurrantCityNameToPinCode(
        context: Context?,
        pinCode: String,
        callback: (address: Address?) -> Unit
    ) {
        val geocoder: Geocoder = Geocoder(context!!)
        var location: List<Address?>? = null
        try {
            location = geocoder.getFromLocationName(pinCode, 1)
        } catch (o: IOException) {
            o.printStackTrace()
        } catch (e: Exception) {
            e.printStackTrace()
        }
        if (location != null && location.isNotEmpty()) {
            /*e.onSuccess(location[0])*/
            callback.invoke(location[0])
        } else {
            callback.invoke(null)
        }
    }
}