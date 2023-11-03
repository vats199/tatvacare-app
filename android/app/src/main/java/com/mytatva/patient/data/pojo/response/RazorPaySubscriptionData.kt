package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class RazorPaySubscriptionData(
    @SerializedName("id")
    val id: String? = null,
    @SerializedName("entity")
    val entity: String? = null,
    @SerializedName("plan_id")
    val plan_id: String? = null,
    @SerializedName("status")
    val status: String? = null,
    @SerializedName("current_start")
    val current_start: String? = null,
    @SerializedName("current_end")
    val current_end: String? = null,
    @SerializedName("ended_at")
    val ended_at: String? = null,
    @SerializedName("quantity")
    val quantity: String? = null,
    @SerializedName("charge_at")
    val charge_at: String? = null,
    @SerializedName("start_at")
    val start_at: String? = null,
    @SerializedName("end_at")
    val end_at: String? = null,
    @SerializedName("auth_attempts")
    val auth_attempts: String? = null,
    @SerializedName("total_count")
    val total_count: String? = null,
    @SerializedName("paid_count")
    val paid_count: String? = null,
    @SerializedName("customer_notify")
    val customer_notify: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("expire_by")
    val expire_by: String? = null,
    @SerializedName("short_url")
    val short_url: String? = null,
    @SerializedName("has_scheduled_changes")
    val has_scheduled_changes: String? = null,
    @SerializedName("change_scheduled_at")
    val change_scheduled_at: String? = null,
    @SerializedName("source")
    val source: String? = null,
    @SerializedName("remaining_count")
    val remaining_count: String? = null,
)