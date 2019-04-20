package com.example.minibus_easy

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants.NOTIFICATION_CHANNEL_ID
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants.NOTIFICATION_CHANNEL_NAME
import io.flutter.app.FlutterApplication

class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()

    }

    fun createNotificationChannel() {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                    NOTIFICATION_CHANNEL_ID, NOTIFICATION_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT
            )

            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(serviceChannel)

        }
    }

}