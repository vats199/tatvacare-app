package com.mytatva.patient.utils

import com.mytatva.patient.utils.datetime.DateTimeFormatter
import java.util.*

object TimeAgo {
    private const val SECOND_MILLIS = 1000
    private const val MINUTE_MILLIS = 60 * SECOND_MILLIS
    private const val HOUR_MILLIS = 60 * MINUTE_MILLIS
    private const val DAY_MILLIS = 24 * HOUR_MILLIS
    fun getTimeAgo(time: Long): String? {
        var time = time
        if (time < 1000000000000L) {
            time *= 1000
        }
        val now = System.currentTimeMillis()
        if (time > now || time <= 0) {
            return null
        }
        val diff = now - time
        return if (diff < MINUTE_MILLIS) {
            "just now" //(diff / MINUTE_MILLIS).toString() + " seconds ago"
        } else if (diff < 2 * MINUTE_MILLIS) {
            "1 min ago"
        } else if (diff < 50 * MINUTE_MILLIS) {
            (diff / MINUTE_MILLIS).toString() + " min ago"
        } else if (diff < 90 * MINUTE_MILLIS) {
            "1 hr ago"
        } else if (diff < 24 * HOUR_MILLIS) {
            (diff / HOUR_MILLIS).toString() + " hrs ago"
        } else if (diff < 48 * HOUR_MILLIS) {
            "yesterday"
        } else {
            (diff / DAY_MILLIS).toString() + " days ago"
        }
    }

    fun getTimeAgoElseDate(time: Long, patternForDate: String): String? {
        var time = time
        if (time < 1000000000000L) {
            time *= 1000
        }
        val now = System.currentTimeMillis()
        if (time > now || time <= 0) {
            return null
        }
        val diff = now - time
        return if (diff < MINUTE_MILLIS) {
            "just now"
        } else if (diff < 2 * MINUTE_MILLIS) {
            "1 min ago"
        } else if (diff < 50 * MINUTE_MILLIS) {
            (diff / MINUTE_MILLIS).toString() + " min ago"
        } else if (diff < 90 * MINUTE_MILLIS) {
            "1 hr ago"
        } else if (diff < 24 * HOUR_MILLIS) {
            (diff / HOUR_MILLIS).toString() + " hrs ago"
        } else if (diff < 48 * HOUR_MILLIS) {
            return "yesterday";
        } else {
            val cal = Calendar.getInstance()
            cal.timeInMillis = time
            return DateTimeFormatter.date(cal.time).formatDateToLocalTimeZoneDisplay(patternForDate)
        }
    }
}