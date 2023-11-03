package com.mytatva.patient.data.model

import com.google.gson.annotations.SerializedName
import java.io.Serializable

data class CommonSelectItemData(
        @SerializedName("state_master_id")
        val state_master_id: String? = null,
        @SerializedName("created_at")
        val created_at: String? = null,
        @SerializedName("is_active")
        val is_active: String? = null,
        @SerializedName("updated_by")
        val updated_by: String? = null,
        @SerializedName("is_deleted")
        val is_deleted: String? = null,
        @SerializedName("updated_at")
        val updated_at: String? = null,
        @SerializedName("state_name")
        val state_name: String? = null,
        @SerializedName("state_id")
        val state_id: String? = null,
        @SerializedName("city_master_id")
        val city_master_id: String? = null,
        @SerializedName("city_name")
        val city_name: String? = null
) : Serializable
