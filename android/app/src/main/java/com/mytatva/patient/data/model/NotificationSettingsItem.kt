package com.mytatva.patient.data.model

enum class NotificationSettingsItem constructor(val label: String, val hasDetailScreen: Boolean) {
    ReminderMedicine("Reminder to take medication", false),
    ReminderExercise("Reminder to do exercise", true),
    ReminderFood("Reminder to log diet", true),
    ReminderBreathing("Reminder to log breathing", true),
    ReminderWater("Reminder to log water intake", true),
    ReminderSleep("Reminder to log sleep", true),
    ReminderVitals("Reminder to log vitals", true)
}