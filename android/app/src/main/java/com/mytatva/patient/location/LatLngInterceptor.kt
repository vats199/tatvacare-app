package com.mytatva.patient.location

import android.animation.TypeEvaluator
import com.google.android.gms.maps.model.LatLng
import java.lang.Math.cos
import java.lang.Math.toDegrees
import java.lang.Math.toRadians
import kotlin.math.pow
import kotlin.math.sign

interface LatLngInterceptor {
    class LatLngEvaluator : TypeEvaluator<LatLng> {
        private val linear: LinearFixed = LinearFixed()

        override fun evaluate(fraction: Float, startValue: LatLng, endValue: LatLng): LatLng {
            return linear.interpolate(fraction, startValue, endValue)
        }
    }


    class LinearFixed : LatLngInterceptor {
        fun interpolate(fraction: Float, a: LatLng, b: LatLng): LatLng {
            val lat = (b.latitude - a.latitude) * fraction + a.latitude
            var lngDelta = b.longitude - a.longitude

            // Take the shortest path across the 180th meridian.
            if (kotlin.math.abs(lngDelta) > 180) {
                lngDelta -= sign(lngDelta) * 360
            }
            val lng = lngDelta * fraction + a.longitude
            return LatLng(lat, lng)
        }
    }

    class Linear : LatLngInterceptor {
        fun interpolate(fraction: Float, a: LatLng, b: LatLng): LatLng {
            val lat = (b.latitude - a.latitude) * fraction + a.latitude
            val lng = (b.longitude - a.longitude) * fraction + a.longitude
            return LatLng(lat, lng)
        }
    }

    class Spherical : LatLngInterceptor {
        /* From github.com/googlemaps/android-maps-utils */
        fun interpolate(fraction: Float, from: LatLng, to: LatLng): LatLng {
            // http://en.wikipedia.org/wiki/Slerp
            val fromLat = toRadians(from.latitude)
            val fromLng = toRadians(from.longitude)
            val toLat = toRadians(to.latitude)
            val toLng = toRadians(to.longitude)
            val cosFromLat = cos(fromLat)
            val cosToLat = cos(toLat)

            // Computes Spherical interpolation coefficients.
            val angle = computeAngleBetween(fromLat, fromLng, toLat, toLng)
            val sinAngle = kotlin.math.sin(angle)
            if (sinAngle < 1E-6) {
                return from
            }
            val a = kotlin.math.sin((1 - fraction) * angle) / sinAngle
            val b = kotlin.math.sin(fraction * angle) / sinAngle

            // Converts from polar to vector and interpolate.
            val x =
                a * cosFromLat * kotlin.math.cos(fromLng) + b * cosToLat * kotlin.math.cos(toLng)
            val y =
                a * cosFromLat * kotlin.math.sin(fromLng) + b * cosToLat * kotlin.math.sin(toLng)
            val z = a * kotlin.math.sin(fromLat) + b * kotlin.math.sin(toLat)

            // Converts interpolated vector back to polar.
            val lat = kotlin.math.atan2(z, kotlin.math.sqrt(x * x + y * y))
            val lng = kotlin.math.atan2(y, x)
            return LatLng(toDegrees(lat), toDegrees(lng))
        }

        private fun computeAngleBetween(
            fromLat: Double,
            fromLng: Double,
            toLat: Double,
            toLng: Double
        ): Double {
            // Haversine's formula
            val dLat = fromLat - toLat
            val dLng = fromLng - toLng
            return 2 * kotlin.math.asin(
                kotlin.math.sqrt(
                    kotlin.math.sin(dLat / 2).pow(2) + kotlin.math.cos(fromLat) * kotlin.math.cos(
                        toLat
                    ) * kotlin.math.sin(
                        dLng / 2
                    ).pow(2)
                )
            )
        }
    }
}