package com.example.minibus_easy.activityrecognition

import android.content.Context
import android.content.res.Resources
import com.example.minibus_easy.R

import com.google.android.gms.location.DetectedActivity
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

import java.lang.reflect.Type
import java.util.ArrayList

/**
 * Utility methods used in this sample.
 */
class DetectedActivitiesUtils {


    companion object {
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

        internal fun getActivityDescription(context: Context, detectedActivity: DetectedActivity): String {
            return getActivityString(context, detectedActivity.type) + ":" + detectedActivity.confidence
        }

        internal fun getAllActivitiesDescription(context: Context, detectedActivities: ArrayList<DetectedActivity>): String {
            var returnString = ""
            for (detectedActivity in detectedActivities) {
                returnString += getActivityDescription(context, detectedActivity) + "\n"
            }
            return returnString
        }

        internal fun detectedActivitiesToJson(detectedActivitiesList: ArrayList<DetectedActivity>): String {
            val type = object : TypeToken<ArrayList<DetectedActivity>>() {

            }.type
            return Gson().toJson(detectedActivitiesList, type)
        }

        internal fun detectedActivitiesFromJson(jsonArray: String): ArrayList<DetectedActivity> {
            val listType = object : TypeToken<ArrayList<DetectedActivity>>() {

            }.type
            var detectedActivities: ArrayList<DetectedActivity>? = Gson().fromJson<ArrayList<DetectedActivity>>(jsonArray, listType)
            if (detectedActivities == null) {
                detectedActivities = ArrayList()
            }
            return detectedActivities
        }
    }
}
