package com.example.minibus_easy

import com.google.android.gms.location.ActivityRecognitionResult
import com.google.android.gms.location.DetectedActivity

import android.app.IntentService
import android.content.Intent
import android.util.Log

class ActivityRecognitionService : IntentService("My Activity Recognition Service") {

    private val TAG = this.javaClass.simpleName

    override fun onHandleIntent(intent: Intent?) {
        if (ActivityRecognitionResult.hasResult(intent)) {
            val result = ActivityRecognitionResult.extractResult(intent)
            Log.i(TAG, getType(result.mostProbableActivity.type) + "\t" + result.mostProbableActivity.confidence)
            val i = Intent("com.example.minibus_easy.ACTIVITY_RECOGNITION_DATA")
            i.putExtra("Activity", getType(result.mostProbableActivity.type))
            i.putExtra("Confidence", result.mostProbableActivity.confidence)
            sendBroadcast(i)
        }
    }

    private fun getType(type: Int): String {
        return if (type == DetectedActivity.UNKNOWN)
            "Unknown"
        else if (type == DetectedActivity.IN_VEHICLE)
            "In Vehicle"
        else if (type == DetectedActivity.ON_BICYCLE)
            "On Bicycle"
        else if (type == DetectedActivity.ON_FOOT)
            "On Foot"
        else if (type == DetectedActivity.STILL)
            "Still"
        else if (type == DetectedActivity.TILTING)
            "Tilting"
        else
            ""
    }

}
