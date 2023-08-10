package com.light.cashflowpad

import android.app.Service
import android.content.Intent
import android.os.IBinder

class ReminderBackgroundService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // This method is called when the service is started.
        // You can perform your background tasks here.

        // Make sure to handle tasks on a separate thread.
        // You can use a background thread, AsyncTask, or coroutines.

        return START_STICKY // This indicates that the service should be restarted if killed by the system.
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
