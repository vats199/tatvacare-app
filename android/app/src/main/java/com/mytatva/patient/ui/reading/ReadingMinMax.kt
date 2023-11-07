package com.mytatva.patient.ui.reading

import android.util.Log
import com.mytatva.patient.data.model.HeightUnit
import com.mytatva.patient.data.model.Readings
import com.mytatva.patient.data.model.WeightUnit
import com.mytatva.patient.data.pojo.User

// all readings min-max values
object ReadingMinMax {

    var MAX_SPO2 = 100
    var MIN_SPO2 = 0
    var MAX_PEF = 800
    var MIN_PEF = 60
    var MAX_HEARTRATE = 500
    var MIN_HEARTRATE = 0
    var MAX_BLOOD_GLUCOSE = 1000
    var MIN_BLOOD_GLUCOSE = 10
    var MAX_BLOOD_PRESSURE = 300
    var MIN_BLOOD_PRESSURE = 0
    var MAX_BODYWEIGHT_KG = 300
    var MIN_BODYWEIGHT_KG = 1
    var MAX_BODYWEIGHT_LBS = 660
    var MIN_BODYWEIGHT_LBS = 66
    var MAX_HBA1C = 100
    var MIN_HBA1C = 1
    var MAX_FEV1 = 7
    var MIN_FEV1 = 0
    var MAX_ACR = 100
    var MIN_ACR = 0
    var MAX_eGFR = 150
    var MIN_eGFR = 0
    var MAX_LSM = 100
    var MIN_LSM = 1
    var MAX_CAP = 400
    var MIN_CAP = 100
    var MAX_HEIGHT_CM = 250
    var MIN_HEIGHT_CM = 50
    var MAX_HEIGHT_FEET = 6
    var MIN_HEIGHT_FEET = 3
    var MAX_HEIGHT_INCH = 11
    var MIN_HEIGHT_INCH = 0
    var MAX_FIB4SCORE = 6
    var MIN_FIB4SCORE = 0
    var MAX_BMI = 100
    var MIN_BMI = 10
    var MAX_SGPT = 2000
    var MIN_SGPT = 1
    var MAX_SGOT = 2000
    var MIN_SGOT = 1
    var MAX_TOTAL_CHOLESTEROL = 4000
    var MIN_TOTAL_CHOLESTEROL = 1
    var MAX_TRIGLYCERIDES = 4000
    var MIN_TRIGLYCERIDES = 1
    var MAX_LDL = 4000
    var MIN_LDL = 1
    var MAX_HDL = 4000
    var MIN_HDL = 1
    var MAX_WAIST = 300
    var MIN_WAIST = 20
    var MAX_PLATELET = 1000000
    var MIN_PLATELET = 1000
    var MAX_6MINWALK = 1000
    var MIN_6MINWALK = 0

    var MIN_SERUM_CREATININE = 0.20
    var MAX_SERUM_CREATININE = 75.0

    var MIN_RANDOM_BG = 30
    var MAX_RANDOM_BG = 2500


    //BCA device new 10 readings min max
    var MAX_BODY_FAT = 45
    var MIN_BODY_FAT = 5

    var MAX_HYDRATION = 80
    var MIN_HYDRATION = 30

    var MAX_MUSCLE_MASS = 85
    var MIN_MUSCLE_MASS = 10

    var MAX_PROTEIN = 30
    var MIN_PROTEIN = 10

    var MAX_BONE_MASS = 5
    var MIN_BONE_MASS = 1

    var MAX_VISCERAL_FAT = 60.0
    var MIN_VISCERAL_FAT = 0.5

    var MAX_BASAL_METABOLIC_RATE = 2100
    var MIN_BASAL_METABOLIC_RATE = 1000

    var MAX_METABOLIC_AGE = 100
    var MIN_METABOLIC_AGE = 1

    var MAX_SUBCUTANEOUS_FAT = 40
    var MIN_SUBCUTANEOUS_FAT = 5

    var MAX_SKELETAL_MUSCLE = 60
    var MIN_SKELETAL_MUSCLE = 10


    //Spirometer device new readings min max
    var MAX_FVC = 0
    var MIN_FVC = 0

    var MAX_FEV1FVC_RATIO = 0
    var MIN_FEV1FVC_RATIO = 0

    var MAX_AQI = 0
    var MIN_AQI = 0

    var MAX_HUMIDITY = 0
    var MIN_HUMIDITY = 0

    var MAX_TEMPERATURE = 0
    var MIN_TEMPERATURE = 0
    var MAX_CALORIES_BURNED = 0
    var MIN_CALORIES_BURNED = 0

    var MAX_SEDENTARY_TIME = 0
    var MIN_SEDENTARY_TIME = 0

    fun updateMinMaxValues(user: User) {
        Log.d("ReadingMinMax", "updateMinMaxValues: ")

        user.unit_data?.forEachIndexed { index, unitData ->

            when (unitData.reading_key) {
                Readings.SPO2.readingKey -> {
                    MAX_SPO2 = unitData.maxValue ?: MAX_SPO2
                    MIN_SPO2 = unitData.minValue ?: MIN_SPO2
                }
                Readings.FEV1.readingKey -> {
                    MAX_FEV1 = unitData.maxValue ?: MAX_FEV1
                    MIN_FEV1 = unitData.minValue ?: MIN_FEV1
                }
                Readings.PEF.readingKey -> {
                    MAX_PEF = unitData.maxValue ?: MAX_PEF
                    MIN_PEF = unitData.minValue ?: MIN_PEF
                }
                Readings.BloodPressure.readingKey -> {
                    MAX_BLOOD_PRESSURE = unitData.maxValue ?: MAX_BLOOD_PRESSURE
                    MIN_BLOOD_PRESSURE = unitData.minValue ?: MIN_BLOOD_PRESSURE
                }
                Readings.HeartRate.readingKey -> {
                    MAX_HEARTRATE = unitData.maxValue ?: MAX_HEARTRATE
                    MIN_HEARTRATE = unitData.minValue ?: MIN_HEARTRATE
                }
                /*Readings.BodyWeight.readingKey -> {
                    MAX_BODYWEIGHT = unitData.maxValue ?: MAX_BODYWEIGHT
                    MIN_BODYWEIGHT = unitData.minValue ?: MIN_BODYWEIGHT
                }*/
                /*Readings.CAT.readingKey -> {
                    MAX_eGFR = unitData.maxValue ?: MAX_eGFR
                    MIN_eGFR = unitData.minValue ?: MIN_eGFR
                }*/
                Readings.BMI.readingKey -> {
                    MAX_BMI = unitData.maxValue ?: MAX_BMI
                    MIN_BMI = unitData.minValue ?: MIN_BMI
                }
                Readings.BloodGlucose.readingKey -> {
                    MAX_BLOOD_GLUCOSE = unitData.maxValue ?: MAX_BLOOD_GLUCOSE
                    MIN_BLOOD_GLUCOSE = unitData.minValue ?: MIN_BLOOD_GLUCOSE
                }
                Readings.HbA1c.readingKey -> {
                    MAX_HBA1C = unitData.maxValue ?: MAX_HBA1C
                    MIN_HBA1C = unitData.minValue ?: MIN_HBA1C
                }
                Readings.ACR.readingKey -> {
                    MAX_ACR = unitData.maxValue ?: MAX_ACR
                    MIN_ACR = unitData.minValue ?: MIN_ACR
                }
                Readings.eGFR.readingKey -> {
                    MAX_eGFR = unitData.maxValue ?: MAX_eGFR
                    MIN_eGFR = unitData.minValue ?: MIN_eGFR
                }
                Readings.SIX_MIN_WALK.readingKey -> {
                    MAX_6MINWALK = unitData.maxValue ?: MAX_6MINWALK
                    MIN_6MINWALK = unitData.minValue ?: MIN_6MINWALK
                }
                Readings.FibroScan.readingKey -> {
                    if (unitData.sub_reading_key == "lsm") {
                        MAX_LSM = unitData.maxValue ?: MAX_LSM
                        MIN_LSM = unitData.minValue ?: MIN_LSM
                    } else if (unitData.sub_reading_key == "cap") {
                        MAX_CAP = unitData.maxValue ?: MAX_CAP
                        MIN_CAP = unitData.minValue ?: MIN_CAP
                    }
                }
                Readings.FIB4Score.readingKey -> {
                    MAX_FIB4SCORE = unitData.maxValue ?: MAX_FIB4SCORE
                    MIN_FIB4SCORE = unitData.minValue ?: MIN_FIB4SCORE
                }
                Readings.SGOT_AST.readingKey -> {
                    MAX_SGOT = unitData.maxValue ?: MAX_SGOT
                    MIN_SGOT = unitData.minValue ?: MIN_SGOT
                }
                Readings.SGPT_ALT.readingKey -> {
                    MAX_SGPT = unitData.maxValue ?: MAX_SGPT
                    MIN_SGPT = unitData.minValue ?: MIN_SGPT
                }
                Readings.Triglycerides.readingKey -> {
                    MAX_TRIGLYCERIDES = unitData.maxValue ?: MAX_TRIGLYCERIDES
                    MIN_TRIGLYCERIDES = unitData.minValue ?: MIN_TRIGLYCERIDES
                }
                Readings.TotalCholesterol.readingKey -> {
                    MAX_TOTAL_CHOLESTEROL = unitData.maxValue ?: MAX_TOTAL_CHOLESTEROL
                    MIN_TOTAL_CHOLESTEROL = unitData.minValue ?: MIN_TOTAL_CHOLESTEROL
                }
                Readings.LDL_CHOLESTEROL.readingKey -> {
                    MAX_LDL = unitData.maxValue ?: MAX_LDL
                    MIN_LDL = unitData.minValue ?: MIN_LDL
                }
                Readings.HDL_CHOLESTEROL.readingKey -> {
                    MAX_HDL = unitData.maxValue ?: MAX_HDL
                    MIN_HDL = unitData.minValue ?: MIN_HDL
                }
                Readings.WaistCircumference.readingKey -> {
                    MAX_WAIST = unitData.maxValue ?: MAX_WAIST
                    MIN_WAIST = unitData.minValue ?: MIN_WAIST
                }
                Readings.PlateletCount.readingKey -> {
                    MAX_PLATELET = unitData.maxValue ?: MAX_PLATELET
                    MIN_PLATELET = unitData.minValue ?: MIN_PLATELET
                }
                //
                Readings.SerumCreatinine.readingKey -> {
                    MIN_SERUM_CREATININE = unitData.minValueDecimal ?: MIN_SERUM_CREATININE
                    MAX_SERUM_CREATININE = unitData.maxValueDecimal ?: MAX_SERUM_CREATININE
                }
                Readings.FattyLiverUSGGrade.readingKey -> {
                    //no min max
                }
                //
                Readings.RandomBloodGlucose.readingKey -> {
                    MAX_RANDOM_BG = unitData.maxValue ?: MAX_RANDOM_BG
                    MIN_RANDOM_BG = unitData.minValue ?: MIN_RANDOM_BG
                }

                Readings.BodyFat.readingKey -> {
                    MAX_BODY_FAT = unitData.maxValue ?: MAX_BODY_FAT
                    MIN_BODY_FAT = unitData.minValue ?: MIN_BODY_FAT
                }
                Readings.Hydration.readingKey -> {
                    MAX_HYDRATION = unitData.maxValue ?: MAX_HYDRATION
                    MIN_HYDRATION = unitData.minValue ?: MIN_HYDRATION
                }
                Readings.MuscleMass.readingKey -> {
                    MAX_MUSCLE_MASS = unitData.maxValue ?: MAX_MUSCLE_MASS
                    MIN_MUSCLE_MASS = unitData.minValue ?: MIN_MUSCLE_MASS
                }
                Readings.Protein.readingKey -> {
                    MAX_PROTEIN = unitData.maxValue ?: MAX_PROTEIN
                    MIN_PROTEIN = unitData.minValue ?: MIN_PROTEIN
                }
                Readings.BoneMass.readingKey -> {
                    MAX_BONE_MASS = unitData.maxValue ?: MAX_BONE_MASS
                    MIN_BONE_MASS = unitData.minValue ?: MIN_BONE_MASS
                }
                Readings.VisceralFat.readingKey -> {
                    MAX_VISCERAL_FAT = unitData.maxValueDecimal ?: MAX_VISCERAL_FAT
                    MIN_VISCERAL_FAT = unitData.minValueDecimal ?: MIN_VISCERAL_FAT
                }
                Readings.BasalMetabolicRate.readingKey -> {
                    MAX_BASAL_METABOLIC_RATE = unitData.maxValue ?: MAX_BASAL_METABOLIC_RATE
                    MIN_BASAL_METABOLIC_RATE = unitData.minValue ?: MIN_BASAL_METABOLIC_RATE
                }
                Readings.MetabolicAge.readingKey -> {
                    MAX_METABOLIC_AGE = unitData.maxValue ?: MAX_METABOLIC_AGE
                    MIN_METABOLIC_AGE = unitData.minValue ?: MIN_METABOLIC_AGE
                }
                Readings.SubcutaneousFat.readingKey -> {
                    MAX_SUBCUTANEOUS_FAT = unitData.maxValue ?: MAX_SUBCUTANEOUS_FAT
                    MIN_SUBCUTANEOUS_FAT = unitData.minValue ?: MIN_SUBCUTANEOUS_FAT
                }
                Readings.SkeletalMuscle.readingKey -> {
                    MAX_SKELETAL_MUSCLE = unitData.maxValue ?: MAX_SKELETAL_MUSCLE
                    MIN_SKELETAL_MUSCLE = unitData.minValue ?: MIN_SKELETAL_MUSCLE
                }

                // new added spirometer readings
                Readings.FVC.readingKey -> {
                    MAX_FVC = unitData.maxValue ?: MAX_FVC
                    MIN_FVC = unitData.minValue ?: MIN_FVC
                }
                Readings.FEV1FVC_RATIO.readingKey -> {
                    MAX_FEV1FVC_RATIO = unitData.maxValue ?: MAX_FEV1FVC_RATIO
                    MIN_FEV1FVC_RATIO = unitData.minValue ?: MIN_FEV1FVC_RATIO
                }
                Readings.AQI.readingKey -> {
                    MAX_AQI = unitData.maxValue ?: MAX_AQI
                    MIN_AQI = unitData.minValue ?: MIN_AQI
                }
                Readings.HUMIDITY.readingKey -> {
                    MAX_HUMIDITY = unitData.maxValue ?: MAX_HUMIDITY
                    MIN_HUMIDITY = unitData.minValue ?: MIN_HUMIDITY
                }
                Readings.TEMPERATURE.readingKey -> {
                    MAX_TEMPERATURE = unitData.maxValue ?: MAX_TEMPERATURE
                    MIN_TEMPERATURE = unitData.minValue ?: MIN_TEMPERATURE
                }
                Readings.CaloriesBurned.readingKey -> {
                    MAX_CALORIES_BURNED = unitData.maxValue ?: MAX_CALORIES_BURNED
                    MIN_CALORIES_BURNED = unitData.minValue ?: MIN_CALORIES_BURNED
                }
                Readings.SedentaryTime.readingKey -> {
                    MAX_SEDENTARY_TIME = unitData.maxValue ?: MAX_SEDENTARY_TIME
                    MIN_SEDENTARY_TIME = unitData.minValue ?: MIN_SEDENTARY_TIME
                }
            }

            when (unitData.unit_key) {
                HeightUnit.FEET_INCHES.unitKey -> {
                    MAX_HEIGHT_FEET = unitData.maxFeet ?: MAX_HEIGHT_FEET
                    MIN_HEIGHT_FEET = unitData.minFeet ?: MIN_HEIGHT_FEET

                    MAX_HEIGHT_INCH = unitData.maxInch ?: MAX_HEIGHT_INCH
                    MIN_HEIGHT_INCH = unitData.minInch ?: MIN_HEIGHT_INCH
                }
                HeightUnit.CM.unitKey -> {
                    MAX_HEIGHT_CM = unitData.maxValue ?: MAX_HEIGHT_CM
                    MIN_HEIGHT_CM = unitData.minValue ?: MIN_HEIGHT_CM
                }
                WeightUnit.LBS.unitKey -> {
                    MAX_BODYWEIGHT_LBS = unitData.maxValue ?: MAX_BODYWEIGHT_LBS
                    MIN_BODYWEIGHT_LBS = unitData.minValue ?: MIN_BODYWEIGHT_LBS
                }
                WeightUnit.KG.unitKey -> {
                    MAX_BODYWEIGHT_KG = unitData.maxValue ?: MAX_BODYWEIGHT_KG
                    MIN_BODYWEIGHT_KG = unitData.minValue ?: MIN_BODYWEIGHT_KG
                }
            }

        }

        Log.d("ReadingMinMax", "updateMinMaxValues: ")
    }
}