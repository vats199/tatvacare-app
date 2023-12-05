package com.mytatva.patient.data.pojo.response

import com.google.gson.annotations.SerializedName


class NotificationReminderFoodResData(
    @SerializedName("everyday_remind")
    val everyday_remind: EverydayRemind? = null,
    @SerializedName("details")
    val details: ArrayList<FoodReminderDetails>? = null,
    @SerializedName("type")
    val type: String? = null,
)

class NotificationReminderOtherResData(
    @SerializedName("everyday_remind")
    val everyday_remind: EverydayRemind? = null,
    @SerializedName("details")
    val details: ArrayList<OtherReminderDetails>? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("frequency")
    val frequency: ArrayList<ReminderFrequency>? = null,
    @SerializedName("days")
    val days: ArrayList<DaysData>? = null,
)

class NotificationReminderReadingsResData(
    @SerializedName("everyday_remind")
    val everyday_remind: EverydayRemind? = null,
    @SerializedName("details")
    val details: ArrayList<ReadingsReminderDetails>? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("frequency")
    val frequency: ArrayList<ReminderFrequency>? = null,
    @SerializedName("days")
    val days: ArrayList<DaysData>? = null,
)

class NotificationReminderWaterResData(
    @SerializedName("everyday_remind")
    val everyday_remind: EverydayRemind? = null,
    @SerializedName("details")
    val details: ArrayList<WaterReminderDetails>? = null,
    @SerializedName("hours_data")
    val hours_data: ArrayList<HoursTimesData>? = null,
    @SerializedName("times_data")
    val times_data: ArrayList<HoursTimesData>? = null,
    @SerializedName("type")
    val type: String? = null,
    @SerializedName("basic_details")
    val basic_details: BasicDetails? = null,
    @SerializedName("days")
    val days: ArrayList<DaysData>? = null,
)

class BasicDetails(
    @SerializedName("notify_from")
    val notify_from: String? = null,
    @SerializedName("notify_to")
    val notify_to: String? = null,
    @SerializedName("remind_type")
    val remind_type: String? = null,
)

class HoursTimesData(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("value")
    val value: String? = null,
)

class EverydayRemind(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("detail_page")
    val detail_page: String? = null,
    @SerializedName("keys")
    val keys: String? = null,
    @SerializedName("is_active")
    val is_active: String? = null,
    @SerializedName("remind_everyday")
    var remind_everyday: String? = null,
    @SerializedName("remind_everyday_time")
    var remind_everyday_time: String? = null,
)

class FoodReminderDetails(
    @SerializedName("meal_type")
    val meal_type: String? = null,
    @SerializedName("keys")
    val keys: String? = null,
    @SerializedName("meal_types_id")
    val meal_types_id: String? = null,
    @SerializedName("is_active")
    var is_active: String? = null,
    @SerializedName("meal_time")
    var meal_time: String? = null,
) {
    var isActive: Boolean
        set(value) {
            is_active = if (value) "Y" else "N"
        }
        get() = is_active == "Y"
}

class OtherReminderDetails(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("value")
    var value: String? = null,
    @SerializedName("value_type") //time,frequency,days (type of enum)
    val value_type: String? = null,
) {
    var valueLabel: String = "" // to display
}

class ReadingsReminderDetails(
    @SerializedName("readings_master_id")
    val readings_master_id: String? = null,
    @SerializedName("reading_name")
    val reading_name: String? = null,
    @SerializedName("keys")
    val keys: String? = null,
    @SerializedName("days_of_week")
    var days_of_week: String? = null,
    @SerializedName("frequency")
    var frequency: String? = null,
    @SerializedName("day_time")
    var day_time: String? = null,
    @SerializedName("is_active")
    var is_active: String? = null,
) {
    var isVisible: Boolean = false

    var isActive: Boolean
        set(value) {
            is_active = if (value) "Y" else "N"
        }
        get() = is_active == "Y"
}

class WaterReminderDetails(
    @SerializedName("title")
    val title: String? = null,
    @SerializedName("value")
    var value: String? = null,
    @SerializedName("value_type") //times,hour
    val value_type: String? = null,
)

class ReminderFrequency(
    @SerializedName("frequency_name")
    val frequency_name: String? = null,
    @SerializedName("key")
    val key: String? = null,
)

/*class ReminderDays(
    @SerializedName("key")
    val key: String? = null,
    @SerializedName("day")
    val day: String? = null,
)*/


/*
{
    "everyday_remind": {
      "title": "Reminder to log diet",
      "detail_page": "Y",
      "keys": "diet",
      "is_active": "Y",
      "remind_everyday": null,
      "remind_everyday_time": null
    },
    "details": [
      {
        "meal_type": "Breakfast",
        "keys": "breakfast",
        "is_active": "N",
        "meal_time": "08:00:00"
      },
      {
        "meal_type": "Morning Snack",
        "keys": "morning_snacks",
        "is_active": "N",
        "meal_time": "11:00:00"
      },
      {
        "meal_type": "Lunch",
        "keys": "lunch",
        "is_active": "N",
        "meal_time": "14:00:00"
      },
      {
        "meal_type": "Evening Snack",
        "keys": "evening_snacks",
        "is_active": "N",
        "meal_time": "17:00:00"
      },
      {
        "meal_type": "Dinner",
        "keys": "dinner",
        "is_active": "N",
        "meal_time": "20:00:00"
      }
    ],
    "type": "diet"
  }
 */