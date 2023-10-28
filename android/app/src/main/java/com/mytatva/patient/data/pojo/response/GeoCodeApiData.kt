package com.mytatva.patient.data.pojo.response


import com.google.gson.annotations.SerializedName

data class GeoCodeApiData(
    @SerializedName("results")
    var results: List<Result?>? = listOf(),
    @SerializedName("status")
    var status: String? = ""
) {
    data class Result(
        @SerializedName("address_components")
        var addressComponents: List<AddressComponent?>? = listOf(),
        @SerializedName("formatted_address")
        var formattedAddress: String? = "",
        @SerializedName("geometry")
        var geometry: Geometry? = Geometry(),
        @SerializedName("place_id")
        var placeId: String? = "",
        @SerializedName("postcode_localities")
        var postcodeLocalities: List<String?>? = listOf(),
        @SerializedName("types")
        var types: List<String?>? = listOf()
    ) {
        data class AddressComponent(
            @SerializedName("long_name")
            var longName: String? = "",
            @SerializedName("short_name")
            var shortName: String? = "",
            @SerializedName("types")
            var types: List<String?>? = listOf()
        )

        data class Geometry(
            @SerializedName("bounds")
            var bounds: Bounds? = Bounds(),
            @SerializedName("location")
            var location: Location? = Location(),
            @SerializedName("location_type")
            var locationType: String? = "",
            @SerializedName("viewport")
            var viewport: Viewport? = Viewport()
        ) {
            data class Bounds(
                @SerializedName("northeast")
                var northeast: Northeast? = Northeast(),
                @SerializedName("southwest")
                var southwest: Southwest? = Southwest()
            ) {
                data class Northeast(
                    @SerializedName("lat")
                    var lat: Double? = 0.0,
                    @SerializedName("lng")
                    var lng: Double? = 0.0
                )

                data class Southwest(
                    @SerializedName("lat")
                    var lat: Double? = 0.0,
                    @SerializedName("lng")
                    var lng: Double? = 0.0
                )
            }

            data class Location(
                @SerializedName("lat")
                var lat: Double? = 0.0,
                @SerializedName("lng")
                var lng: Double? = 0.0
            )

            data class Viewport(
                @SerializedName("northeast")
                var northeast: Northeast? = Northeast(),
                @SerializedName("southwest")
                var southwest: Southwest? = Southwest()
            ) {
                data class Northeast(
                    @SerializedName("lat")
                    var lat: Double? = 0.0,
                    @SerializedName("lng")
                    var lng: Double? = 0.0
                )

                data class Southwest(
                    @SerializedName("lat")
                    var lat: Double? = 0.0,
                    @SerializedName("lng")
                    var lng: Double? = 0.0
                )
            }
        }
    }
}