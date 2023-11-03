package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class ChartRecordData(
    @SerializedName("color_code_1")
    val color_code_1: String? = null,
    @SerializedName("color_code_2")
    val color_code_2: String? = null,
    @SerializedName("readings_data")
    val readings_data: List<GoalReadingData>? = null,
    @SerializedName("goal_data")
    val goal_data: List<GoalReadingData>? = null,
    @SerializedName("last_reading_date")
    val last_reading_date: String? = null,
    @SerializedName("average")
    val average: Average? = null,

    @SerializedName("threshold_show")
    val threshold_show: String? = null, //N/Y

    @SerializedName("standard_max")
    val standard_max: String? = null,
    @SerializedName("standard_min")
    val standard_min: String? = null,

    @SerializedName("diastolic_standard_max")
    val diastolic_standard_max: String? = null,
    @SerializedName("diastolic_standard_min")
    val diastolic_standard_min: String? = null,
    @SerializedName("systolic_standard_max")
    val systolic_standard_max: String? = null,
    @SerializedName("systolic_standard_min")
    val systolic_standard_min: String? = null,

    @SerializedName("lsm_standard_min")
    val lsm_standard_min: String? = null,
    @SerializedName("lsm_standard_max")
    val lsm_standard_max: String? = null,
    @SerializedName("cap_standard_min")
    val cap_standard_min: String? = null,
    @SerializedName("cap_standard_max")
    val cap_standard_max: String? = null,

    @SerializedName("fast_standard_max")
    val fast_standard_max: String? = null,
    @SerializedName("fast_standard_min")
    val fast_standard_min: String? = null,
    @SerializedName("pp_standard_min")
    val pp_standard_min: String? = null,
    @SerializedName("pp_standard_max")
    val pp_standard_max: String? = null,
) {
    val formattedLastReadingTime: String
        get() {
            return try {
                DateTimeFormatter.date(last_reading_date, DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            } catch (e: Exception) {
                ""
            }
        }
    val formattedLastReadingDate: String
        get() {
            return try {
                DateTimeFormatter.date(last_reading_date, DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            } catch (e: Exception) {
                ""
            }
        }
}

class Average(
    @SerializedName("reading_value")
    val reading_value: String? = null,
    @SerializedName("lsm")
    val lsm: String? = null,
    @SerializedName("cap")
    val cap: String? = null,
    @SerializedName("fast")
    val fast: String? = null,
    @SerializedName("pp")
    val pp: String? = null,
    @SerializedName("diastolic")
    val diastolic: String? = null,
    @SerializedName("systolic")
    val systolic: String? = null,
    @SerializedName("weight")
    val weight: String? = null,
    @SerializedName("height")
    val height: String? = null,
    @SerializedName("goal_value")
    val goal_value: String? = null,
)