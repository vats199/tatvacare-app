package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class GetAppointmentListResData(
    @SerializedName("link_doctor_details")
    val link_doctor_details: LinkDoctorDetails? = null,
    @SerializedName("appointment_list")
    val appointment_list: ArrayList<AppointmentData>? = null,
)

class LinkDoctorDetails(
    @SerializedName("doctor_unique_id")
    val doctor_unique_id: String? = null,
    @SerializedName("business_id")
    val business_id: String? = null,
    @SerializedName("clinic_id")
    val clinic_id: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("clinic_name")
    val clinic_name: String? = null,
    @SerializedName("specialization")
    val specialization: String? = null,
    @SerializedName("qualification")
    val qualification: String? = null,
    @SerializedName("clinic_address")
    val clinic_address: String? = null,
    @SerializedName("about_doctor")
    val about_doctor: String? = null,
    @SerializedName("profile_image")
    val profile_image: String? = null,
    @SerializedName("email")
    val email: String? = null,
)