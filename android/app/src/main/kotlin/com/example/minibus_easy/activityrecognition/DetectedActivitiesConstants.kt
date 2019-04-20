package com.example.minibus_easy.activityrecognition

import android.content.Context
import android.content.res.Resources

import com.google.android.gms.location.DetectedActivity
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

import java.lang.reflect.Type
import java.util.ArrayList

/**
 * DetectedActivitiesConstants used in this sample.
 */
internal object DetectedActivitiesConstants {

    private val PACKAGE_NAME = "com.example.minibus_easy.activityrecognition"

    val KEY_ACTIVITY_UPDATES_REQUESTED = "$PACKAGE_NAME.ACTIVITY_UPDATES_REQUESTED"

    val KEY_DETECTED_ACTIVITIES = "$PACKAGE_NAME.DETECTED_ACTIVITIES"

    val NOTIFICATION_CHANNEL_ID = "minibusEasyNotification"
    val NOTIFICATION_CHANNEL_NAME = "Minibus Easy Notification"
    val TRACKING_SERVICE_TAG = "TrackingService"

    /**
     * The desired time between activity detections. Larger values result in fewer activity
     * detections while improving battery life. A value of 0 results in activity detections at the
     * fastest possible rate.
     */
    val DETECTION_INTERVAL_IN_MILLISECONDS = (0 * 1000).toLong() // 60 seconds
    /**
     * List of DetectedActivity types that we monitor in this sample.
     */
    val MONITORED_ACTIVITIES = intArrayOf(DetectedActivity.STILL, DetectedActivity.ON_FOOT, DetectedActivity.WALKING, DetectedActivity.RUNNING, DetectedActivity.ON_BICYCLE, DetectedActivity.IN_VEHICLE, DetectedActivity.TILTING, DetectedActivity.UNKNOWN)
}
