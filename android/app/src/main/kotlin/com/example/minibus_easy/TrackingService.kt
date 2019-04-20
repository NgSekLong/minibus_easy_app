package com.example.minibus_easy

import android.app.PendingIntent
import android.app.Service
import android.content.ComponentName
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import androidx.core.app.NotificationCompat
import java.util.*
import java.util.concurrent.ScheduledFuture
import androidx.core.os.HandlerCompat.postDelayed
import android.content.ContentValues.TAG
//import com.google.android.gms.common.api.GoogleApiClient


import com.google.android.gms.location.ActivityRecognitionResult;
import com.google.android.gms.location.DetectedActivity;




class TrackingService : Service() {


    companion object {
        const val CHANNEL_ID = "serviceChannel"
        const val CHANNEL_NAME = "Minibus Easy Channel"
        const val INTENT_EXTRA = "intentExtra"
    }
    protected lateinit var timer: Handler


//    private val mGoogleApiClient: GoogleApiClient? = null
//    private val mPendingIntent: PendingIntent? = null
//    private val mFenceReceiver: FenceReceiver? = null

    // The intent action which will be fired when your fence is triggered.
    private val FENCE_RECEIVER_ACTION = BuildConfig.APPLICATION_ID + "FENCE_RECEIVER_ACTION"


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
    }

    override fun onDestroy() {
        super.onDestroy()
        timer.removeCallbacksAndMessages(null)

    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val input = intent?.getStringExtra(INTENT_EXTRA)

//        val notificationIntent = Intent(this, MainActivity::class.java)
//        val pendingIntent = PendingIntent.getActivity(this, 0,
//                notificationIntent, 0)
//
//        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
//                .setContentTitle("Minibus Service")
//                .setContentText(input)
//                .setSmallIcon(R.drawable.notification_icon_background)
//                .setContentIntent(pendingIntent)
//                .build()
//
//        startForeground(1, notification)
        timer = Handler()
        var i = 0
//        timer.postDelayed({
//            i++
//            trackGPSAndAccerometer(i)
//            //doSomethingHere()
//        }, 1000)


        val runnable = object : Runnable {
            override fun run() {
                i++
                trackGPSAndAccerometer(i)
                timer.postDelayed(this, 5000)
            }
        }
        // TODO: Implement ways to kill this runnable
        runnable.run()

//        timer = Timer().scheduleAtFixedRate(object : TimerTask() {
//            override fun run() {
//                i++
//                trackGPSAndAccerometer(i)
//            }
//        }, 0, 5000)


        return START_NOT_STICKY
    }

    fun trackGPSAndAccerometer( i : Int){

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0,
                notificationIntent, 0)

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Minibus Service")
                .setContentText("Counter: " + i.toString())
                .setSmallIcon(R.drawable.notification_icon_background)
                .setContentIntent(pendingIntent)
                .build()

        startForeground(1, notification)

    }

//    override fun startService(service: Intent?): ComponentName? {
//        val serviceIntent = Intent(this, TrackingService::class.java) as Intent
//        serviceIntent.putExtra(INTENT_EXTRA, "Something")
//
//        return super.startService(serviceIntent)
//    }
}