package com.example.minibus_easy

/*
 * Copyright 2017 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



import android.content.Context
import android.content.res.Resources

import com.google.android.gms.location.DetectedActivity
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

import java.lang.reflect.Type
import java.util.ArrayList

/**
 * Constants used in this sample.
 */
internal object Constants {

    private val PACKAGE_NAME = "com.google.android.gms.location.activityrecognition"

    val KEY_ACTIVITY_UPDATES_REQUESTED = "$PACKAGE_NAME.ACTIVITY_UPDATES_REQUESTED"

    val KEY_DETECTED_ACTIVITIES = "$PACKAGE_NAME.DETECTED_ACTIVITIES"

    /**
     * The desired time between activity detections. Larger values result in fewer activity
     * detections while improving battery life. A value of 0 results in activity detections at the
     * fastest possible rate.
     */
    val DETECTION_INTERVAL_IN_MILLISECONDS = (30 * 1000).toLong() // 30 seconds
    /**
     * List of DetectedActivity types that we monitor in this sample.
     */
    val MONITORED_ACTIVITIES = intArrayOf(DetectedActivity.STILL, DetectedActivity.ON_FOOT, DetectedActivity.WALKING, DetectedActivity.RUNNING, DetectedActivity.ON_BICYCLE, DetectedActivity.IN_VEHICLE, DetectedActivity.TILTING, DetectedActivity.UNKNOWN)
}