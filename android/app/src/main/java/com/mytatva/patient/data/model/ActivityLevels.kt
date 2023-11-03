package com.mytatva.patient.data.model

enum class ActivityLevels constructor(
    val title: String,
    val description: String,
    val activityKey: String,
) {
    LittleOrNoActivity("Little or No Activity",
        "Mostly sitting through the day (eg. desk job, Bank Teller)", "S"),
    LightlyActive("Lightly Active",
        "Mostly standing through the day (eg. Teacher, Sales associate)", "L"),
    ModeratelyActive("Moderately Active",
        "Mostly walking or doing physical activities through the day (eg. Tour guide, waiter)",
        "M"),
    VeryActive("Very Active",
        "Mostly doing heavy physical activities through the day (eg. Gym Instructor, Construction worker)",
        "V"),
}