package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class RecordData(
        @SerializedName("patient_records_id")
        val patient_records_id: String? = null,
        @SerializedName("patient_id")
        val patient_id: String? = null,
        @SerializedName("test_type_id")
        val test_type_id: String? = null,
        @SerializedName("title")
        val title: String? = null,
        @SerializedName("description")
        val description: String? = null,
        @SerializedName("added_by")
        val added_by: String? = null,
        @SerializedName("is_active")
        val is_active: String? = null,
        @SerializedName("is_deleted")
        val is_deleted: String? = null,
        @SerializedName("updated_by")
        val updated_by: String? = null,
        @SerializedName("created_at")
        val created_at: String? = null,
        @SerializedName("updated_at")
        val updated_at: String? = null,
        @SerializedName("document_name")
        val document_name: String? = null,
        @SerializedName("test_name")
        val test_name: String? = null,
        @SerializedName("document_url")
        val document_url: ArrayList<String>? = null,
) {
        val getFormattedDate:String
        get() {
                return try {
                        DateTimeFormatter.date(updated_at,DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                                .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
                }catch (e:Exception){
                        ""
                }
        }
}