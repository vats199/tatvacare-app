package com.mytatva.patient.data.model

enum class WeekDaysData constructor(val dayName: String,var isSelected:Boolean=false) {
    SUN("Sunday"),
    MON("Monday"),
    TUE("Tuesday"),
    WED("Wednesday"),
    THU("Thursday"),
    FRI("Friday"),
    SAT("Saturday"),
    ALL("All day")
}