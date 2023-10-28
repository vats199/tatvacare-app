package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class HealthCoachData(
    @SerializedName("tag_name")
    val tag_name: String? = null,
    @SerializedName("health_coach_id")
    val health_coach_id: String? = null,
    @SerializedName("first_name")
    val first_name: String? = null,
    @SerializedName("last_name")
    val last_name: String? = null,
    @SerializedName("role")
    val role: String? = null,
    @SerializedName("profile_pic")
    val profile_pic: String? = null,
    @SerializedName("contact_no")
    val contact_no: String? = null,
    @SerializedName("password")
    val password: String? = null,
    @SerializedName("state")
    val state: String? = null,
    @SerializedName("city")
    val city: String? = null,
    @SerializedName("language_spoken")
    val language_spoken: String? = null,
    @SerializedName("qualification")
    val qualification: String? = null,
    @SerializedName("institute")
    val institute: String? = null,
    @SerializedName("degree")
    val degree: String? = null,
    @SerializedName("date_of_completion")
    val date_of_completion: String? = null,
    @SerializedName("years_of_experience")
    val years_of_experience: String? = null,
    @SerializedName("about_me")
    val about_me: String? = null,
    @SerializedName("start_date")
    val start_date: String? = null,
    @SerializedName("health_coach_guid")
    val health_coach_guid: String? = null,
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
    @SerializedName("skill_name")
    val skill_name: String? = null,
) {
    val fullName: String
        get() = first_name?.plus(" ")?.plus(last_name ?: "") ?: ""
}