package com.mytatva.patient.data.model

import com.mytatva.patient.R

enum class AppointmentStatus(val statusKey: String, val statusTitle: String, val colorRes: Int) {
    SCHEDULED("Scheduled", "Upcoming", R.color.yellow1),
    CANCELLED("Cancelled", "Cancelled", R.color.excessCalorie),
    COMPLETED("Complete", "Completed", R.color.limitCalorie),
    MISSED("Missed", "Missed", R.color.excessCalorie),
}