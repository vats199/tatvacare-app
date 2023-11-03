package com.mytatva.patient.data.model

enum class AppointmentTypes constructor(val typeKey: String, val title: String) {
    CLINIC("clinic", "In Clinic"),
    VIDEO("video", "Virtual"),
}