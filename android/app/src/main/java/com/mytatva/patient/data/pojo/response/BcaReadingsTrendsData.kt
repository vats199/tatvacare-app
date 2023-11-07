package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.data.pojo.request.RangeData

data class BcaReadingsTrendsData(
    @SerializedName("information")
    val information: String? = null,
    @SerializedName("bca_standard_values")
    val bca_standard_values: ArrayList<RangeData>? = null,
    @SerializedName("trend_graph")
    val trend_graph: ChartRecordData? = null,
    @SerializedName("last_reading")
    val last_reading: String? = null,
    @SerializedName("increased_by")
    val increased_by: String? = null,
) {
    val increasedBy: Double
        get() {
            return increased_by?.toDoubleOrNull() ?: 0.0
        }
}