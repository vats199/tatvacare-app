package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName


class MedicationSummaryData(
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
    val dose_time_slot: String? = null,
    @SerializedName("dose_taken")
    val dose_taken: String? = null,
    @SerializedName("dose_taken_date")
    val dose_taken_date: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("dose_taken_data")
    val dose_taken_data: ArrayList<DoseTakenData>? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
)

class DoseTakenData(
    @SerializedName("dose_day")
    val dose_day: String? = null,
    @SerializedName("achieved_value")
    val achieved_value: String? = null,
    @SerializedName("goal_value")
    val goal_value: String? = null,
)
