package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class GetMedicineResData(
    @SerializedName("medicine_id")
    val medicine_id: String? = null,
    @SerializedName("medicine_name")
    val medicine_name: String? = null,
    @SerializedName("medicine_Image")
    val medicine_Image: String? = null,
    var isSelected: Boolean = false,
)