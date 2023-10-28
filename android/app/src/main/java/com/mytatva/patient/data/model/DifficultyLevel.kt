package com.mytatva.patient.data.model

enum class DifficultyLevel constructor(val title: String) {
    Difficult("Difficult"),
    Easy("Easy"),
}

/*
  ** Goals & Readings for Fit SDK
  // Readings ****************

        //Fasting Blood Glucose
        HealthDataTypes.TYPE_BLOOD_GLUCOSE
        HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL
        HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL_FASTING

        //PP Blood Glucose
        HealthDataTypes.TYPE_BLOOD_GLUCOSE
        HealthFields.FIELD_BLOOD_GLUCOSE_LEVEL
        HealthFields.FIELD_TEMPORAL_RELATION_TO_MEAL_AFTER_MEAL

        //SpO2
        HealthDataTypes.TYPE_OXYGEN_SATURATION
        HealthFields.FIELD_OXYGEN_SATURATION//
        HealthFields.FIELD_OXYGEN_SATURATION_AVERAGE//

        //Diastolic BP
        HealthDataTypes.TYPE_BLOOD_PRESSURE//
        HealthFields.FIELD_BLOOD_PRESSURE_DIASTOLIC

        //Systolic BP
        HealthDataTypes.TYPE_BLOOD_PRESSURE//
        HealthFields.FIELD_BLOOD_PRESSURE_SYSTOLIC

        //FEV1- not available

        //Heart Rate
        DataType.TYPE_HEART_RATE_BPM

        //Weight
        DataType.TYPE_WEIGHT
        Field.FIELD_WEIGHT//

        //Height
        DataType.TYPE_HEIGHT
        Field.FIELD_HEIGHT//

        //BMI- not available

        //PEF- not available

        //HbA1c- not available
        //CAT- not available
        //ACR- not available
        //eGFR- not available

        // Goals ****************

        //Medication-not available
        //Pranayama-not available

        //Sleep
        DataType.TYPE_SLEEP_SEGMENT
        Field.FIELD_SLEEP_SEGMENT_TYPE

        //Water
        DataType.TYPE_HYDRATION

        //Steps
        DataType.TYPE_STEP_COUNT_CADENCE
        DataType.TYPE_STEP_COUNT_DELTA
        Field.FIELD_STEPS
 */