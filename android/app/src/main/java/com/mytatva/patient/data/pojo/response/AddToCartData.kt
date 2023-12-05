package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

data class AddToCartData(
    @SerializedName("conflicting_codes_to_remove")
    val conflicting_codes_to_remove: String? = null,
    @SerializedName("cart_info")
    val cart_info: Cart? = null,
)
