package com.mytatva.patient.utils.calendar

import android.app.Activity
import android.content.Intent
import android.provider.CalendarContract
import java.text.SimpleDateFormat
import java.util.*


object CalendarUtil {

  /*  fun writeEventToCalendar(activity: Activity) {
        val cr: ContentResolver = activity.contentResolver
        val values = ContentValues()

        values.put(CalendarContract.Events.DTSTART, dtstart)//
        values.put(CalendarContract.Events.TITLE, "title")
        values.put(CalendarContract.Events.DESCRIPTION, "comment")

        val timeZone = TimeZone.getDefault()
        values.put(CalendarContract.Events.EVENT_TIMEZONE, timeZone.id)

        values.put(CalendarContract.Events.CALENDAR_ID, 1)

        values.put(CalendarContract.Events.RRULE, "FREQ=DAILY;UNTIL=$dtUntill")
        values.put(CalendarContract.Events.DURATION, "+P1H")

        values.put(CalendarContract.Events.HAS_ALARM, 1)

        val uri: Uri? = cr.insert(CalendarContract.Events.CONTENT_URI, values)

    }*/

    fun writeEventToCalendarIntent(activity: Activity) {
        val startMillis: Long = Calendar.getInstance().run {
            set(2012, 0, 19, 7, 30)
            timeInMillis
        }
        val endMillis: Long = Calendar.getInstance().run {
            set(2012, 0, 19, 8, 30)
            timeInMillis
        }
        val intent = Intent(Intent.ACTION_INSERT)
            .setData(CalendarContract.Events.CONTENT_URI)
            .putExtra(CalendarContract.EXTRA_EVENT_BEGIN_TIME, startMillis)
            .putExtra(CalendarContract.EXTRA_EVENT_END_TIME, endMillis)
            .putExtra(CalendarContract.Events.TITLE, "Yoga")
            .putExtra(CalendarContract.Events.DESCRIPTION, "Group class")
            .putExtra(CalendarContract.Events.EVENT_LOCATION, "The gym")
            .putExtra(CalendarContract.Events.AVAILABILITY,
                CalendarContract.Events.AVAILABILITY_BUSY)
            .putExtra(Intent.EXTRA_EMAIL, "rowan@example.com,trevor@example.com")
        activity.startActivity(intent)
    }

    fun getDate(milliSeconds: Long): String? {
        val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH)
        val calendar = Calendar.getInstance()
        calendar.timeInMillis = milliSeconds
        formatter.timeZone = TimeZone.getTimeZone("UST")
        return formatter.format(calendar.time)
    }

    /*fun getDeviceReminders(activity: Activity, userId: String): ArrayList<CalTask> {

        val list = arrayListOf<CalTask>()

        val cr: ContentResolver = activity.contentResolver
        var cursor: Cursor? = null
        try {
            cursor = cr.query(
                Uri.parse("content://com.android.calendar/events"),
                arrayOf(
                    "_id",
                    "title",
                    "description",
                    "dtstart",
                    "dtend",
                    "eventLocation",
                    "original_id",
                    "isOrganizer",
                    "accessLevel",
                    "rrule",
                    "rdate",
                    "exrule",
                    "exdate"
                ),
                null,
                null,
                null
            )

            Log.i("Sample Activity", "Cursor size " + cursor?.getCount())
            var add: String? = null
            cursor?.moveToFirst()
            val CalNames = arrayOfNulls<String>(cursor?.count!!)
            val CalIds = IntArray(cursor.count)
            for (i in CalNames.indices) {
                CalIds[i] = cursor?.getInt(0) ?: 0

                val accessLevel = cursor.getInt(8)

                var reminderType: String? = cursor.getString(9)
                if (reminderType?.contains("FREQ") == true) {
                    if (reminderType.contains("DAILY", ignoreCase = true)) {
                        reminderType = "daily"
                    } else if (reminderType.contains("WEEKLY", ignoreCase = true)) {
                        reminderType = "weekly"
                    } else if (reminderType.contains("MONTHLY", ignoreCase = true)) {
                        reminderType = "monthly"
                    } else if (reminderType.contains("YEARLY", ignoreCase = true)) {
                        reminderType = "yearly"
                    } else {
                        reminderType = "once"
                    }
                } else {
                    reminderType = "once"
                }

                // do not add public events
                if (accessLevel != 3) {
                    list.add(
                        CalTask(
                            location = cursor.getString(5),
                            reminder = cursor.getLong(3).let { getDate(it) },
                            reminder_repeat = reminderType,
                            date_time = cursor.getLong(3).let { getDate(it) },
                            user_id = userId,
                            type = "Normal",
                            content = cursor.getString(1),
                            location_lng = null,
                            location_lat = null,
                            map_image = null,
                            cal_id = cursor.getInt(0).toString()
                        )
                    )

                    CalNames[i] = """
            Event${cursor?.getInt(0)}
            Title: ${cursor?.getString(1)}
            Description: ${cursor?.getString(2)}
            Start Date: ${cursor?.getLong(3)?.let { Date(it).toString() }}
            End Date : ${cursor?.getLong(4)?.let { Date(it).toString() }}
            Location : ${cursor?.getString(5)}
            Original Id : ${cursor?.getString(6)}
            is Organiser : ${cursor?.getString(7)}
            accessLevel : ${cursor?.getInt(8)} :: 0 def 1 confidential 2 private 3 public
            rrule : ${cursor?.getString(9)}
            rdate : ${cursor?.getString(10)}
            exrule : ${cursor?.getString(11)}
            exdate : ${cursor?.getString(12)}
            =================================
            """.trimIndent()
                    if (add == null) {
                        add = CalNames[i]
                    } else {
                        add += CalNames[i]
                    }
                }

                //((TextView)findViewById(R.id.calendars)).setText(add);
                cursor.moveToNext()
            }
            Log.e("CAL", "=============================================")
            Log.e("SAmple Reminder****", "events from calendar $add")
            Log.e("CAL", "=============================================")
            cursor.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        cursor?.close()

        return list
    }*/

    /*fun getDeviceCalendars(activity: Activity) {

        val cr: ContentResolver = activity.contentResolver
        var cursor: Cursor? = null
        try {
            cursor = cr.query(
                Uri.parse("content://com.android.calendar/calendars"),
                arrayOf(
                    "_id",
                    "allowedAvailability",
                    "allowedReminders",
                    "calendar_access_level",
                    "calendar_displayName",
                    "isPrimary"
                ),
                null,
                null,
                null
            )

            //Cursor cursor = cr.query(Uri.parse("content://calendar/calendars"), new String[]{ "_id", "name" }, null, null, null);

            Log.i("Sample Activity", "Cursor size " + cursor?.getCount())
            var add: String? = null
            cursor?.moveToFirst()
            val CalNames = arrayOfNulls<String>(cursor?.count!!)
            val CalIds = IntArray(cursor.count)
            for (i in CalNames.indices) {
                CalIds[i] = cursor?.getInt(0) ?: 0
                CalNames[i] = """
                    
            Event${cursor?.getInt(0)}
            Title: ${cursor?.getString(1)}
            Description: ${cursor?.getString(2)}
            Start Date: ${cursor?.getLong(3)?.let { Date(it).toString() }}
            End Date : ${cursor?.getLong(4)?.let { Date(it).toString() }}
            Location : ${cursor?.getString(5)}
            Original Id : ${cursor?.getString(6)}
            is Organiser : ${cursor?.getString(7)}
            accessLevel : ${cursor?.getInt(8)} :: 0 def 1 confidential 2 private 3 public
            """.trimIndent()
                if (add == null) {
                    add = CalNames[i]
                } else {
                    add += CalNames[i]
                }
                //        ((TextView)findViewById(R.id.calendars)).setText(add);
                cursor.moveToNext()
            }
            Log.e("CAL", "=============================================")
            Log.e("SAmple Reminder****", "events from calendar $add")
            Log.e("CAL", "=============================================")
            cursor.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }

        cursor?.close()
    }*/


}
/*
 {
    "location": "Hyperlink Infosystem Block C, 106/B, Ganesh Meredian, Sarkhej - Gandhinagar Hwy, Opp Gujarat high court, Vishwas City 1, Sola, Ahmedabad, Gujarat 380061, India",
    "location_lng": "72.5261408",
    "reminder": "once",
    "location_lat": "23.0755316",
    "map_image": "https://hlink-bucket-office1.s3-eu-west-1.amazonaws.com/timecraft/address/7YewejK8tx1587366810.jpeg",
    "reminder_repeat": "2020-05-20 09:00:00",
    "user_id": "17",
    "type": "Normal",
    "content": "Test with other",
    "cal_id": "6AE0FD30-EC48-4499-B23D-5C673A1BE166"
  }
 */