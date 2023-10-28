package com.mytatva.patient.data.model

enum class Readings constructor(val readingKey: String, val readingName: String) {
    SPO2("pulseoxy", "SPO2"), //0-100 Percent
    FEV1("lung", "FEV1"),//0-7 L
    PEF("pef", "PEF"),// 60-800 L/min
    BloodPressure("bloodpressure", "Blood Pressure"),//0-300 both
    HeartRate("heartrate", "Heart Rate"),//0-500 BPM
    BodyWeight("bodyweight", "Body Weight"),//1-300 Kg
    BMI("bmi", "BMI"),//10-100
    BloodGlucose("blood_glucose", "Blood Glucose"),//10-1000 both
    HbA1c("hba1c", "HbA1c"),//1-100 Percent
    ACR("acr", "ACR"),
    eGFR("egfr", "eGFR"),
    CAT("cat", "CAT"),//0-60
    SIX_MIN_WALK("six_min_walk", "6 minute walk test"),//0-1000

    // new added readings
    FibroScan("fibro_scan", "Fibro Scan"),//(LSM - 1-100, CAP - 100-400)
    FIB4Score("fib4", "FIB4 Score"),//0-6
    SGOT_AST("sgot", "SGOT/ AST"),//1-2000
    SGPT_ALT("sgpt", "SGPT/ ALT"),//1-2000
    Triglycerides("triglycerides", "Triglycerides"),//1-4000
    TotalCholesterol("total_cholesterol", "Total cholesterol"),//1-4000
    LDL_CHOLESTEROL("ldl_cholesterol", "LDL Cholesterol"),//1-4000
    HDL_CHOLESTEROL("hdl_cholesterol", "HDL Cholesterol"),//1-4000
    WaistCircumference("waist_circumference", "Waist Circumference"),//20-300
    PlateletCount("platelet", "Platelet Count"),//1000-1000000

    // new added readings - Sprint April1 2023
    SerumCreatinine("serum_creatinine", "Serum Creatinine"),
    FattyLiverUSGGrade("fatty_liver_ugs_grade", "Fatty Liver USG Grade"),

    //
    RandomBloodGlucose("random_blood_glucose", "Random Blood Glucose"),//30-2500

    // BCA integration new readings
    BodyFat("body_fat", "Body Fat"),
    Hydration("hydration", "Hydration"),
    MuscleMass("muscle_mass", "Muscle Mass"),
    Protein("protein", "Protein"),
    BoneMass("bone_mass", "Bone Mass"),
    VisceralFat("visceral_fat", "Visceral Fat"),
    BasalMetabolicRate("basel_metabolic_rate", "Basal Metabolic Rate"),
    MetabolicAge("metabolic_age", "Metabolic Age"),
    SubcutaneousFat("subcutaneous_fat", "Subcutaneous Fat"),
    SkeletalMuscle("skeletal_muscle", "Skeletal Muscle"),

    // Spirometer integration new readings
    FVC("fvc", "FVC"),
    FEV1FVC_RATIO("fev1_fvc_ratio", "FEV1/FVC ratio"),
    AQI("aqi", "AQI"),
    HUMIDITY("humidity", "Humidity"),
    TEMPERATURE("temperature", "Temperature"),
}