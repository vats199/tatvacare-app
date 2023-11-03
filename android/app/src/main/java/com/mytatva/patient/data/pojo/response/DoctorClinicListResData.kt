package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class DoctorClinicListResData(
    @SerializedName("Response Code")
    val responseCode: String? = null,
    @SerializedName("status_update")
    val status_update: String? = null,
    @SerializedName("result")
    val result: ArrayList<ClinicData>? = null,
)

class ClinicData(
    @SerializedName("clinic_id")
    val clinic_id: String? = null,
    @SerializedName("clinic_name")
    val clinic_name: String? = null,
    @SerializedName("doctor_details")
    val doctor_details: ArrayList<DoctorDetails>? = null,
)

class DoctorDetails(
    @SerializedName("doctor_uniq_id")
    val doctor_uniq_id: String? = null,
    @SerializedName("doctor_name")
    val doctor_name: String? = null,
    @SerializedName("speciality")
    val speciality: String? = null,
)