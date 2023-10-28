package com.mytatva.patient.data.model

/*
 * Ethnicity(RACE CODE) - for Spirometer
 */
enum class Ethnicity constructor(val ethnicityKey: String, val ethnicityName: String) {
    CAUCASIAN("CAUCASIAN", "Caucasian"),
    AFRICAN_AMERICAN("AFRICAN_AMERICAN", "African American"),
    NORTH_EAST_ASIAN("NORTH_EAST_ASIAN", "North East Asian"),
    SOUTH_EAST_ASIAN("SOUTH_EAST_ASIAN", "South East Asian"),
    OTHER_MIXED("OTHER_MIXED", "Other Mixed"),
    NORTH_INDIAN("NORTH_INDIAN", "North Indian"),
    SOUTH_INDIAN("SOUTH_INDIAN", "South Indian"),
}