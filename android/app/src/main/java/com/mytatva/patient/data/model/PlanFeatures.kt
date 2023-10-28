package com.mytatva.patient.data.model

object PlanFeatures {
    const val Home = "Home"

    const val reading_logs = "reading_logs"//done Android
    const val eGFR = "eGFR"
    const val HeartRate = "Heart Rate"
    const val FEV1 = "FEV1"
    const val SpO2 = "SpO2"
    const val BodyWeight = "Body weight"
    const val BloodGlucose = "Blood Glucose"
    const val HbA1c = "HbA1c"
    const val PEF = "PEF"
    const val CAT = "CAT"
    const val ACR = "ACR"
    const val BMI = "BMI"
    const val BloodPressure = "Blood Pressure"
    const val activity_logs = "activity_logs"//done Android
    const val Diet = "Diet"
    const val Exercise = "Exercise"
    const val Sleep = "Sleep"
    const val Steps = "Steps"
    const val Water = "Water"
    const val Breathing = "Breathing"
    const val Medication = "Medication"

    //const val food_logs = "food_logs"//done Food logging - detailed insights screen Android
    //const val food_dairy = "food_dairy"//done food diary screen Android

    const val bookmarks = "bookmarks"//done Android
    const val incident_records_history = "incident_records_history"//done Android
    const val prescription_book_test = "prescription_book_test"//done Android --- conf query
    const val add_medication = "add_medication"//done Android --- conf query

    const val diet_plan = "diet_plan"//no such feature

    // main key & sub keys
    const val book_appointments = "book_appointments"//on hold
    const val book_appointments_doctor = "book_appointments_doctor"
    const val book_appointments_hc = "book_appointments_hc"

    const val add_records_history_records = "add_records_history_records"//done ---

    //    const val EngageArticleType – trial, premium = "engage_article_trial_premium"
//    const val trial = "trial"
//    const val premium = "premium"
//    const val Engage article type – each genre = "engage_article_genre"
//    const val Lifestyle = "Lifestyle"
//    const val Okra = "Okra"

    const val engage_article_selection_of_language = "engage_article_selection_of_language" //---
    const val Hindi = "Hindi"
    const val English = "English"

    const val commenting_on_articles = "commenting_on_articles"//done Android
    const val chatbot = "chatbot"//done Android
    const val chat_healthcoach = "chat_healthcoach"//done Android

    const val chat_support = "chat_support"//on hold/ no such feature

    const val exercise_my_routine_breathing = "exercise_my_routine_breathing"//done Android
    const val exercise_my_routine_exercise = "exercise_my_routine_exercise"//done Android

    //    const val Exercise - Explore tab – Video by genre = "exercise_explore_by_genre"
//    const val Breathing = "Breathing"
//    const val Strength and Cardio = "Strength and Cardio"
//    const val Yoga = "Yoga"
//    const val Exercise – explore tab – video by level = "exercise_explore_video_by_level"
//    const val Exercise – explore tab – video by exercise tool = "exercise_explore_by_exercise_tool"
//    const val Exercise – explore tab – exercise of the day = "exercise_explore_exercise_of_the_day"

    const val history_payments = "history_payments"//done Android
    const val coach_list = "coach_list"//done Android - stop coach list API

    const val doctor_says = "doctor_says"
    const val ask_an_expert = "ask_an_expert"
}