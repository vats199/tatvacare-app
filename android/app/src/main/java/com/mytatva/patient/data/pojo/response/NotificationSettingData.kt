package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class NotificationSettingData(
    @SerializedName("notification_master_id")
    val notification_master_id: String? = null,
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("detail_page")
    val detail_page: String? = null,
    @SerializedName("keys")
    val keys: String? = null,
    @SerializedName("is_active")
    var is_active: String? = null,
) {
    var isActive: Boolean
        set(value) {
            is_active = if (value) "Y" else "N"
        }
        get() = is_active == "Y"

    val isDetailPage: Boolean
        get() = detail_page == "Y"
}