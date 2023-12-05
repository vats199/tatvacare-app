package com.mytatva.patient.data.pojo.response

import android.os.Parcelable
import com.google.gson.annotations.SerializedName
import kotlinx.parcelize.Parcelize

@Parcelize
data class CouponCodeData(
    @SerializedName("discounts_master_id") var discountsMasterId: String? = null,
    @SerializedName("discount_name") var discountName: String? = null,
    @SerializedName("discount_type") var discountType: String? = null,
    @SerializedName("start_date") var startDate: String? = null,
    @SerializedName("end_date") var endDate: String? = null,
    @SerializedName("min_cart_price") var minCartPrice: String? = null,
    @SerializedName("max_discount_price") var maxDiscountPrice: String? = null,
    @SerializedName("discount_amount") var discountAmount: String? = null,
    @SerializedName("discount_percentage") var discountPercentage: String? = null,
    @SerializedName("discount_limit") var discountLimit: String? = null,
    @SerializedName("description") var description: String? = null,
    @SerializedName("apply_on") var applyOn: String? = null,
    @SerializedName("prefix_keyword") var prefixKeyword: String? = null,
    @SerializedName("discount_available_for") var discountAvailableFor: String? = null,
    @SerializedName("discount_code") var discountCode: String? = null,
    @SerializedName("onlydescription") var onlydescription: String? = null,
    @SerializedName("coupon_name") var couponName: String? = null,
    @SerializedName("is_active") var isActive: String? = null,
    @SerializedName("is_deleted") var isDeleted: String? = null,
    @SerializedName("created_by") var createdBy: String? = null,
    @SerializedName("updated_by") var updatedBy: String? = null,
    @SerializedName("created_at") var createdAt: String? = null,
    @SerializedName("updated_at") var updatedAt: String? = null,
    @SerializedName("label") var label: String? = null
) : Parcelable {
    fun isToSetDisable(payableAmount: Int): Boolean {
        return isActive == "N" || (minCartPrice?.toIntOrNull() ?: 0) > payableAmount
    }
}
