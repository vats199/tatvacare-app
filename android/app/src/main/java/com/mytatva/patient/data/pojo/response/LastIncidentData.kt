package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.mytatva.patient.utils.datetime.DateTimeFormatter

class LastIncidentData(
    @SerializedName("last_incident_date")
    val last_incident_date: String? = null,
    @SerializedName("days")
    val days: String? = null,
) {
    val getFormattedLastDate: String
        get() {
            return try {
                DateTimeFormatter.date(last_incident_date, DateTimeFormatter.FORMAT_yyyyMMdd)
                    .formatDateToLocalTimeZoneDisplay(DateTimeFormatter.FORMAT_ddMMMyyyy)
            } catch (e: Exception) {
                ""
            }
        }
}