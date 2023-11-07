package com.mytatva.patient.data.model

enum class ChartDurations constructor(val durationKey: String, val durationTitle: String) {
    SEVEN_DAYS("7D", "7 Days"),
    FIFTEEN_DAYS("15D", "15 Days"),// 15 Days added in 2023, May Sprint 2 for Readings Only.
    THIRTY_DAYS("30D", "30 Days"),
    NINETY_DAYS("90D", "90 Days"),
    ONE_YEAR("1Y", "1 Year"),
    //ALL("ALL", "All time")
}