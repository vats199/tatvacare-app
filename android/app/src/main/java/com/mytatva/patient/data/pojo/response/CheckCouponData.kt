package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class CheckCouponData(
    @SerializedName("final_price") var finalPrice: String? = null,
    @SerializedName("discount_amount") var discountAmount: String? = null,
    @SerializedName("discount_code") var discountCode: CouponCodeData? = null,
    @SerializedName("sub_heading_message") val subHeadingMessage: String? = null,
) : Parcelable
