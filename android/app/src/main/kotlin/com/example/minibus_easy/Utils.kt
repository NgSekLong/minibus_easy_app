package com.example.minibus_easy
/**
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
 * Utility methods used in this sample.
 */
object Utils {

    /**
     * Returns a human readable String corresponding to a detected activity type.
     */
    internal fun getActivityString(context: Context, detectedActivityType: Int): String {
        val resources = context.resources
        when (detectedActivityType) {
            DetectedActivity.IN_VEHICLE -> return resources.getString(R.string.in_vehicle)
            DetectedActivity.ON_BICYCLE -> return resources.getString(R.string.on_bicycle)
            DetectedActivity.ON_FOOT -> return resources.getString(R.string.on_foot)
            DetectedActivity.RUNNING -> return resources.getString(R.string.running)
            DetectedActivity.STILL -> return resources.getString(R.string.still)
            DetectedActivity.TILTING -> return resources.getString(R.string.tilting)
            DetectedActivity.UNKNOWN -> return resources.getString(R.string.unknown)
            DetectedActivity.WALKING -> return resources.getString(R.string.walking)
            else -> return resources.getString(R.string.unidentifiable_activity, detectedActivityType)
        }
    }

    internal fun detectedActivitiesToJson(detectedActivitiesList: ArrayList<DetectedActivity>): String {
        val type = object : TypeToken<ArrayList<DetectedActivity>>() {

        }.getType()
        return Gson().toJson(detectedActivitiesList, type)
    }

    internal fun detectedActivitiesFromJson(jsonArray: String): ArrayList<DetectedActivity> {
        val listType = object : TypeToken<ArrayList<DetectedActivity>>() {

        }.getType()
        var detectedActivities = Gson().fromJson(jsonArray, listType) as ArrayList<DetectedActivity>
        if (detectedActivities == null) {
            detectedActivities = ArrayList<DetectedActivity>()
        }
        return detectedActivities
    }
}
