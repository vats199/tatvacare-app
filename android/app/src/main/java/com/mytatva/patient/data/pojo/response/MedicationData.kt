package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class MedicationMainData(
    @SerializedName("medication")
    val medication: ArrayList<MedicationData>? = null,
    @SerializedName("goal_value")
    val goal_value: String? = null,
    @SerializedName("achieved_value")
    val achieved_value: String? = null,
    @SerializedName("todays_achieved_value")
    val todays_achieved_value: String? = null,
)

class MedicationData(
    @SerializedName("patient_dose_rel_id")
    val patient_dose_rel_id: String? = null,
    @SerializedName("dose_id")
    val dose_id: String? = null,
    @SerializedName("medecine_id")
    val medecine_id: String? = null,
    @SerializedName("medicine_name")
    val medicine_name: String? = null,
    @SerializedName("start_date")
    val start_date: String? = null,
    @SerializedName("end_date")
    val end_date: String? = null,
    @SerializedName("dose_days")
    val dose_days: String? = null,
    @SerializedName("dose_time_slot")
    val dose_time_slot: List<DoseTimeSlotData>? = null,
    @SerializedName("dose_taken")
    val dose_taken: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
)

class DoseTimeSlotData(
    @SerializedName("time")
    val time: String? = null,
    @SerializedName("taken")
    var taken: String? = null,
) {
    val getFormattedTime: String
        get() {
            return try {
                DateTimeFormatter.date(time, DateTimeFormatter.FORMAT_HHMM)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_TIME)
            } catch (e: Exception) {
                ""
            }
        }
}