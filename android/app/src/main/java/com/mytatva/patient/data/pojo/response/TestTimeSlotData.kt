package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class TestTimeSlotData(
    @SerializedName("id")
    val id: String? = null,
    @SerializedName("slotMasterId")
    val slotMasterId: String? = null,
    @SerializedName("slot")
    val slot: String? = null,
) : Parcelable