package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class CommentsData(
    @SerializedName("content_comments_id")
    val content_comments_id: String? = null,
    @SerializedName("content_master_id")
    val content_master_id: String? = null,
    @SerializedName("patient_id")
    val patient_id: String? = null,
    @SerializedName("comment")
    val comment: String? = null,
    @SerializedName("reported")
    var reported: String? = null,
    @SerializedName("report_count")
    val report_count: String? = null,
    @SerializedName("visibility")
    val visibility: String? = null,
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
    @SerializedName("commented_by")
    val commented_by: String? = null,
) {
    var isSelected: Boolean = false
    val commentUpdateTime: String
        get() {
            return try {
                //dateUTC
                DateTimeFormatter.date(updated_at, DateTimeFormatter.FORMAT_yyyyMMdd_HHmmss)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_DISPLAY_DATE_TIME)
            } catch (e: Exception) {
                ""
            }
        }
}