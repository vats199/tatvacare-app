package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName

class QueryReasonData(
    @SerializedName("query_reason_master_id")
    val query_reason_master_id: String? = null,
    @SerializedName("query_reason")
    val query_reason: String? = null,
    @SerializedName("created_at")
    val created_at: String? = null,
    @SerializedName("updated_at")
    val updated_at: String? = null
)