package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class DoctorData(
    @SerializedName("patient_doctor_rel_id")
    val patient_doctor_rel_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("doctor_id")
    val doctor_id: String? = null,
    @SerializedName("doctor_uniq_id")
    val doctor_uniq_id: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("is_deleted")
    val is_deleted: String? = null,
    @SerializedName("updated_by")
    val updated_by: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("languages_id")
    val languages_id: String? = null,
    @SerializedName("access_code")
    val access_code: String? = null,
    @SerializedName("name")
    val name: String? = null,
    @SerializedName("tier")
    val tier: String? = null,
    @SerializedName("country_code")
    val country_code: String? = null,
    @SerializedName("contact_no")
    val contact_no: String? = null,
    @SerializedName("email")
    val email: String? = null,
    @SerializedName("region")
    val region: String? = null,
    @SerializedName("user_name")
    val user_name: String? = null,
    @SerializedName("password")
    val password: String? = null,
    @SerializedName("gender")
    val gender: String? = null,
    @SerializedName("city")
    val city: String? = null,
    @SerializedName("state")
    val state: String? = null,
    @SerializedName("country")
    val country: String? = null,
    @SerializedName("kyd_status")
    val kyd_status: String? = null,
    @SerializedName("qualification")
    val qualification: String? = null,
    @SerializedName("experience")
    val experience: String? = null,
    @SerializedName("membership")
    val membership: String? = null,
    @SerializedName("registrations")
    val registrations: String? = null,
    @SerializedName("state_medical_councils")
    val state_medical_councils: String? = null,
    @SerializedName("dob")
    val dob: String? = null,
    @SerializedName("plan")
    val plan: String? = null,
    @SerializedName("speciality")
    val speciality: String? = null,
    @SerializedName("division")
    val division: String? = null,
    @SerializedName("language_spoken")
    val language_spoken: String? = null,
    @SerializedName("profile_pic")
    val profile_pic: String? = null,
    @SerializedName("whatsapp_optin")
    val whatsapp_optin: String? = null,
    @SerializedName("email_optin")
    val email_optin: String? = null,
    @SerializedName("sms_optin")
    val sms_optin: String? = null,
    @SerializedName("push_optin")
    val push_optin: String? = null,
    @SerializedName("email_verified")
    val email_verified: String? = null,
    @SerializedName("last_login_datetime")
    val last_login_datetime: String? = null,
    @SerializedName("clinic_id")
    val clinic_id: String? = null,
    @SerializedName("business_id")
    val business_id: String? = null,
    @SerializedName("specialization")
    val specialization: String? = null,
    @SerializedName("profile_image")
    val profile_image: String? = null,
    @SerializedName("about")
    val about: String? = null,
    @SerializedName("deep_link")
    val deep_link: String? = null,
)