package com.mytatva.patient.data.pojo.request

import com.google.gson.annotations.SerializedName

data class UpdateBcaVitalsApiRequest(
    @SerializedName("BMI")
    val BMI: String? = null,
    @SerializedName("BMR")
    val BMR: String? = null,
    @SerializedName("bone_mass")
    val bone_mass: String? = null,
    @SerializedName("device_id")
    val device_id: String? = null,
    @SerializedName("fat_mass")
    val fat_mass: String? = null,
    @SerializedName("fat_mass_kg")
    val fat_mass_kg: String? = null,
    @SerializedName("hydration")
    val hydration: String? = null,
    @SerializedName("hydration_kg")
    val hydration_kg: String? = null,
    @SerializedName("metabolic_age")
    val metabolic_age: String? = null,
    @SerializedName("muscle_mass")
    val muscle_mass: String? = null,
    @SerializedName("muscle_mass_percent")
    val muscle_mass_percent: String? = null,
    @SerializedName("protein")
    val protein: String? = null,
    @SerializedName("protein_kg")
    val protein_kg: String? = null,
    @SerializedName("skeletal_muscle_kg")
    val skeletal_muscle_kg: String? = null,
    @SerializedName("skeletal_muscle_percent")
    val skeletal_muscle_percent: String? = null,
    @SerializedName("subcutaneous_fat_kg")
    val subcutaneous_fat_kg: String? = null,
    @SerializedName("subcutaneous_fat_percent")
    val subcutaneous_fat_percent: String? = null,
    @SerializedName("visceral_fat")
    val visceral_fat: String? = null,
    @SerializedName("weight")
    val weight: String? = null,
    @SerializedName("ranges")
    val ranges: Ranges? = null,
)

data class Ranges(
    @SerializedName("subcutaneous_fat")
    val subcutaneous_fat: ArrayList<RangeData>? = null,
    @SerializedName("visceral_fat")
    val visceral_fat: ArrayList<RangeData>? = null,
    @SerializedName("metabolic_age")
    val metabolic_age: ArrayList<RangeData>? = null,
    @SerializedName("bone_mass")
    val bone_mass: ArrayList<RangeData>? = null,
    @SerializedName("hydration")
    val hydration: ArrayList<RangeData>? = null,
    @SerializedName("protein")
    val protein: ArrayList<RangeData>? = null,
    @SerializedName("fat")
    val fat: ArrayList<RangeData>? = null,
    @SerializedName("weight")
    val weight: ArrayList<RangeData>? = null,
    @SerializedName("muscle_mass")
    val muscle_mass: ArrayList<RangeData>? = null,
    @SerializedName("skeletal_muscle")
    val skeletal_muscle: ArrayList<RangeData>? = null,
    @SerializedName("bmi")
    val bmi: ArrayList<RangeData>? = null,
)

data class RangeData(
    @SerializedName("from")
    val from: String? = null,
    @SerializedName("label")
    val label: String? = null,
    @SerializedName("to")
    val to: String? = null,
) {

    var fromToRangePercentage:Double?=null

    val fromValue: Double
        get() {
            return from?.toDoubleOrNull() ?: 0.0
        }

    val toValue: Double
        get() {
            return to?.toDoubleOrNull() ?: 0.0
        }
}