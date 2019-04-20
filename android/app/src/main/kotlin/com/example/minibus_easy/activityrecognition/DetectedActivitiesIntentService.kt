package com.example.minibus_easy.activityrecognition

import android.app.IntentService
import android.content.Intent
import android.preference.PreferenceManager
import android.util.Log

import com.google.android.gms.location.ActivityRecognitionResult
import com.google.android.gms.location.DetectedActivity

import java.util.ArrayList


/**
 * IntentService for handling incoming intents that are generated as a result of requesting
 * activity updates using
 * [com.google.android.gms.location.ActivityRecognitionApi.requestActivityUpdates].
 */
/**
 * This constructor is required, and calls the super IntentService(String)
 * constructor with the name for a worker thread.
 */
class DetectedActivitiesIntentService : IntentService(TAG) {

    override fun onCreate() {
        super.onCreate()
    }

    /**
     * Handles incoming intents.
     * @param intent The Intent is provided (inside a PendingIntent) when requestActivityUpdates()
     * is called.
     */
    override fun onHandleIntent(intent: Intent?) {
        val result = ActivityRecognitionResult.extractResult(intent)

        // Get the list of the probable activities associated with the current state of the
        // device. Each activity is associated with a confidence level, which is an int between
        // 0 and 100.
        val detectedActivities = result.probableActivities as ArrayList<DetectedActivity>

        PreferenceManager.getDefaultSharedPreferences(this)
                .edit()
                .putString(DetectedActivitiesConstants.KEY_DETECTED_ACTIVITIES,
                        DetectedActivitiesUtils.detectedActivitiesToJson(detectedActivities))
                .apply()

        // Log each activity.
        Log.i(TAG, "activities detected")
        for (da in detectedActivities) {
            Log.i(TAG, DetectedActivitiesUtils.getActivityString(
                    applicationContext,
                    da.getType()) + " " + da.getConfidence() + "%"
            )
        }
    }

    companion object {

        protected val TAG = "DetectedActivitiesIS"
    }
}// Use the TAG to name the worker thread.