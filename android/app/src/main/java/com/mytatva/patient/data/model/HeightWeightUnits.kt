package com.mytatva.patient.data.model

enum class HeightUnit constructor(val unitKey: String, var unitName: String) {
    CM("cm", "cm"),
    FEET_INCHES("feet_inch", "ft/in"),
}

enum class WeightUnit constructor(val unitKey: String, var unitName: String) {
    KG("kg", "kg"),
    LBS("lbs", "lbs"),
}