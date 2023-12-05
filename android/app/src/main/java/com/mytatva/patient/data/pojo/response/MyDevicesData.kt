package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class MyDevicesData(
    @SerializedName("key")
    var key: String? = null,
    @SerializedName("title")
    var title: String? = null,
    @SerializedName("last_sync_date")
    var lastSyncDate: String? = null,
) : Parcelable
