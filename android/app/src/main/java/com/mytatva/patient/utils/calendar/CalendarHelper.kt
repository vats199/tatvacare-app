package com.mytatva.patient.utils.calendar

import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.Context
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.CalendarContract
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import java.util.*

object CalendarHelper {
    //Remember to initialize this activityObj first, by calling initActivityObj(this) from
    //your activity
    private const val TAG = "CalendarHelper"
    const val CALENDARHELPER_PERMISSION_REQUEST_CODE = 99
    fun makeNewCalendarEntry(
        caller: Activity,
        title: String?,
        description: String?,
        startTime: Long,
        endTime: Long,
        allDay: Boolean = false,
        hasAlarm: Boolean = false,
        selectedReminderValue: Int,
    ) {
        val cr = caller.contentResolver
        val values = ContentValues()
        values.put(CalendarContract.Events.DTSTART, startTime)
        values.put(CalendarContract.Events.DTEND, endTime)
        values.put(CalendarContract.Events.TITLE, title)
        values.put(CalendarContract.Events.DESCRIPTION, description)

        // id, We need to choose from our mobile for primary its 1
        values.put(CalendarContract.Events.CALENDAR_ID, 1)

        values.put(CalendarContract.Events.STATUS, CalendarContract.Events.STATUS_CONFIRMED)
        //values.put(CalendarContract.Events.VISIBLE, description)
        if (allDay) {
            values.put(CalendarContract.Events.ALL_DAY, true)
        }
        if (hasAlarm) {
            values.put(CalendarContract.Events.HAS_ALARM, true)
        }

        //Get current timezone//
        values.put(CalendarContract.Events.EVENT_TIMEZONE, TimeZone.getDefault().id)
        Log.i(TAG, "Timezone retrieved=>" + TimeZone.getDefault().id)
        val uri = cr.insert(CalendarContract.Events.CONTENT_URI, values)
        Log.i(TAG, "Uri returned=>" + uri.toString())

        // get the event ID that is the last element in the Uri
        val eventID = uri!!.lastPathSegment!!.toLong()
        if (hasAlarm) {
            val reminders = ContentValues()
            reminders.put(CalendarContract.Reminders.EVENT_ID, eventID)
            reminders.put(CalendarContract.Reminders.METHOD,
                CalendarContract.Reminders.METHOD_ALERT)
            reminders.put(CalendarContract.Reminders.MINUTES, selectedReminderValue)
            val uri2 = cr.insert(CalendarContract.Reminders.CONTENT_URI, reminders)
        }
    }


    fun listCalendarId(c: Context): Hashtable<*, *>? {
        if (haveCalendarReadWritePermissions(c as Activity)) {
            val projection = arrayOf("_id", "calendar_displayName")
            val calendars: Uri
            calendars = Uri.parse("content://com.android.calendar/calendars")
            val contentResolver = c.getContentResolver()
            val managedCursor = contentResolver.query(calendars, projection, null, null, null)
            if (managedCursor!!.moveToFirst()) {
                var calName: String
                var calID: String
                var cont = 0
                val nameCol = managedCursor.getColumnIndex(projection[1])
                val idCol = managedCursor.getColumnIndex(projection[0])
                val calendarIdTable = Hashtable<String, String>()
                do {
                    calName = managedCursor.getString(nameCol)
                    calID = managedCursor.getString(idCol)
                    Log.v(TAG, "CalendarName:$calName ,id:$calID")
                    calendarIdTable[calName] = calID
                    cont++
                } while (managedCursor.moveToNext())
                managedCursor.close()
                return calendarIdTable
            }
        }
        return null
    }

    fun requestCalendarWritePermission(caller: Activity?) {
        val permissionList: MutableList<String> = ArrayList()
        if (ContextCompat.checkSelfPermission(caller!!,
                Manifest.permission.WRITE_CALENDAR) != PackageManager.PERMISSION_GRANTED
        ) {
            permissionList.add(Manifest.permission.WRITE_CALENDAR)
        }
        if (permissionList.size > 0) {
            val permissionArray = arrayOfNulls<String>(permissionList.size)
            for (i in permissionList.indices) {
                permissionArray[i] = permissionList[i]
            }
            ActivityCompat.requestPermissions(caller,
                permissionArray,
                CALENDARHELPER_PERMISSION_REQUEST_CODE)
        }
    }

    fun haveCalendarWritePermissions(caller: Activity?): Boolean {
        val permissionCheck = ContextCompat
            .checkSelfPermission(caller!!, Manifest.permission.WRITE_CALENDAR)
        if (permissionCheck == PackageManager.PERMISSION_GRANTED) {
            return true
        }
        return false
    }

    fun requestCalendarReadWritePermission(caller: Activity?) {
        val permissionList: MutableList<String> = ArrayList()
        if (ContextCompat.checkSelfPermission(caller!!,
                Manifest.permission.WRITE_CALENDAR) != PackageManager.PERMISSION_GRANTED
        ) {
            permissionList.add(Manifest.permission.WRITE_CALENDAR)
        }
        if (ContextCompat.checkSelfPermission(caller,
                Manifest.permission.READ_CALENDAR) != PackageManager.PERMISSION_GRANTED
        ) {
            permissionList.add(Manifest.permission.READ_CALENDAR)
        }
        if (permissionList.size > 0) {
            val permissionArray = arrayOfNulls<String>(permissionList.size)
            for (i in permissionList.indices) {
                permissionArray[i] = permissionList[i]
            }
            ActivityCompat.requestPermissions(caller,
                permissionArray,
                CALENDARHELPER_PERMISSION_REQUEST_CODE)
        }
    }

    fun haveCalendarReadWritePermissions(caller: Activity?): Boolean {
        var permissionCheck = ContextCompat.checkSelfPermission(caller!!,
            Manifest.permission.READ_CALENDAR)
        if (permissionCheck == PackageManager.PERMISSION_GRANTED) {
            permissionCheck = ContextCompat.checkSelfPermission(caller,
                Manifest.permission.WRITE_CALENDAR)
            if (permissionCheck == PackageManager.PERMISSION_GRANTED) {
                return true
            }
        }
        return false
    }
}