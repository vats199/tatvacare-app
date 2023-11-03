package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName
import com.prolificinteractive.materialcalendarview.CalendarDay

class MonthlyCalData(
    @SerializedName("achieved_date")
    val achieved_date: String? = null,
    @SerializedName("goal_master_id")
    val goal_master_id: String? = null,
    @SerializedName("goal_value")
    val goal_value: String? = null,
    @SerializedName("achieved_value")
    val achieved_value: String? = null,
    @SerializedName("goal_name")
    val goal_name: String? = null,
    @SerializedName("color_code")
    val color_code: String? = null,
    @SerializedName("calories_limit")
    val calories_limit: String? = null,
) {
    val getAsCalendarDay: CalendarDay?
        get() {
            val year = achieved_date?.split("-")?.get(0)?.toIntOrNull() ?: 0
            val month = achieved_date?.split("-")?.get(1)?.toIntOrNull() ?: 0
            val date = achieved_date?.split("-")?.get(2)?.toIntOrNull() ?: 0
            val calendarDay = if (year > 0 && month > 0 && date > 0) {
                CalendarDay.from(year, month, date)
            } else null
            return calendarDay
        }
}