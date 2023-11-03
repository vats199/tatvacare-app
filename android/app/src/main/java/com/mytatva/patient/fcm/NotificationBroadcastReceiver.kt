package com.mytatva.patient.fcm

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import androidx.core.app.RemoteInput

class NotificationBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {

        val message = getReplyMessage(intent)

        Toast.makeText(context,"Test $message",Toast.LENGTH_LONG).show()
        val notificationId = intent.getIntExtra("notificationId", 0)
        // if you want cancel notification
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(notificationId)
    }

    private fun getReplyMessage(intent: Intent): CharSequence? {
        return RemoteInput.getResultsFromIntent(intent)?.getCharSequence("submittedValue")
    }

}