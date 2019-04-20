package com.example.minibus_easy

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.example.minibus_easy.TrackingService.Companion.CHANNEL_ID
import com.example.minibus_easy.TrackingService.Companion.CHANNEL_NAME

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        createNotificationChannel()

        startService()
    }


    fun createNotificationChannel() {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                    CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT
            )

            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(serviceChannel)

        }
    }


    fun startService() {
        val serviceIntent = Intent(this, TrackingService::class.java)
        serviceIntent.putExtra(TrackingService.INTENT_EXTRA, "Something")

        startService(serviceIntent)
    }
}
