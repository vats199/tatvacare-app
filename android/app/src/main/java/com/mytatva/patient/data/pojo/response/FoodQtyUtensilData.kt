package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class FoodQtyUtensilData(
    @SerializedName("utensil_list_id")
    val utensil_list_id: String? = null,
    @SerializedName("utensil_name")
    val utensil_name: String? = null,
    @SerializedName("quantity")
    val quantity: String? = null,
    @SerializedName("key")
    val key: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    @SerializedName("image_url")
    val image_url: String? = null,
)