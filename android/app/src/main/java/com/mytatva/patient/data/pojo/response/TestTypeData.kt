package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class TestTypeResData(
    @SerializedName("test_type")
    val test_type: ArrayList<TestTypeData>? = null,
    @SerializedName("title")
    val title: ArrayList<RecordTitleData>? = null,
)

class TestTypeData(
    @SerializedName("test_type_id")
    val test_type_id: String? = null,
    @SerializedName("test_name")
    val test_name: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
)

class RecordTitleData(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("records_title_master_id")
    val records_title_master_id: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null,
    var labelToAddAsCustom:String="",
    var isSelected: Boolean = false,
)