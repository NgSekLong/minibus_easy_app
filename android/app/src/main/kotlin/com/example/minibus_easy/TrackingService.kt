package com.example.minibus_easy

import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.IBinder
import android.preference.PreferenceManager
import android.util.Log
import android.widget.Toast

import com.google.android.gms.location.ActivityRecognitionClient
import com.google.android.gms.location.DetectedActivity
import com.google.android.gms.tasks.OnFailureListener
import com.google.android.gms.tasks.OnSuccessListener
import com.google.android.gms.tasks.Task

import java.util.ArrayList
import java.util.Calendar
import java.util.Date
import androidx.core.app.NotificationCompat
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants.NOTIFICATION_CHANNEL_ID
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants.TRACKING_SERVICE_TAG
import com.example.minibus_easy.activityrecognition.DetectedActivitiesIntentService
import com.example.minibus_easy.activityrecognition.DetectedActivitiesUtils

class TrackingService : Service(), SharedPreferences.OnSharedPreferenceChangeListener {


//    companion object {
//
//
//        protected val TAG = "TrackingService"
//        protected val CHANNEL_ID = "minibusEasyChannel"
//    }

    private val mBuilder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)

    //    private NotificationManager mNotificationManager =
    //            (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
    //Different Id's will show up as different notifications
    //Some things we only have to set the first time.
    private var notificationFirstTime = true
    private val mNotificationId = 1

    private lateinit var mContext: Context


    /**
     * The entry point for interacting with activity recognition.
     */
    private lateinit var mActivityRecognitionClient: ActivityRecognitionClient


// We use FLAG_UPDATE_CURRENT so that we get the same pending intent back when calling
    // requestActivityUpdates() and removeActivityUpdates().
    /**
     * Gets a PendingIntent to be sent for each activity detection.
     */
//    private val activityDetectionPendingIntent: PendingIntent
//        get() {
//            val intent = Intent(this, DetectedActivitiesIntentService::class.java)
//            return PendingIntent.getService(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
//        }

    private fun getActivityDetectionPendingIntent(): PendingIntent {
        val intent = Intent(this, DetectedActivitiesIntentService::class.java)

        // We use FLAG_UPDATE_CURRENT so that we get the same pending intent back when calling
        // requestActivityUpdates() and removeActivityUpdates().
        return PendingIntent.getService(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        mContext = this

        val detectedActivities = DetectedActivitiesUtils.detectedActivitiesFromJson(
                PreferenceManager.getDefaultSharedPreferences(this).getString(
                        DetectedActivitiesConstants.KEY_DETECTED_ACTIVITIES, ""))


        PreferenceManager.getDefaultSharedPreferences(this)
                .registerOnSharedPreferenceChangeListener(this)
        mActivityRecognitionClient = ActivityRecognitionClient(this)
        requestActivityUpdatesButtonHandler()
    }

    override fun onDestroy() {
        PreferenceManager.getDefaultSharedPreferences(this)
                .unregisterOnSharedPreferenceChangeListener(this)
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {

        return Service.START_NOT_STICKY
    }

    fun createNotification(chosenString: String, activitiesString: String) {

        val currentTime = Calendar.getInstance().time
        val timeString = currentTime.hours.toString() + ":" + currentTime.minutes + ":" + currentTime.seconds

        // String input = intent.getStringExtra("inputExtra");
        if (notificationFirstTime) {
            val notificationIntent = Intent(this, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(this,
                    0, notificationIntent, 0)
            mBuilder
                    .setContentTitle("Tracking on: $timeString")
                    .setContentText(chosenString)
                    .setSmallIcon(R.drawable.notification_icon_background)
                    .setContentIntent(pendingIntent).build()
            notificationFirstTime = false
        }
        mBuilder
                .setStyle(NotificationCompat.BigTextStyle()
                        .bigText(activitiesString))
        //        Intent notificationIntent = new Intent(this, MainActivity.class);
        //        PendingIntent pendingIntent = PendingIntent.getActivity(this,
        //                0, notificationIntent, 0);
        //
        //        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
        //                .setContentTitle("Tracking on: " + timeString)
        //                .setContentText(chosenString)
        //                .setSmallIcon(R.drawable.ic_launcher)
        //
        //                .setStyle(new NotificationCompat.BigTextStyle()
        //                        .bigText(activitiesString))
        //
        //                .setContentIntent(pendingIntent).build();

        startForeground(mNotificationId, mBuilder.build())

    }


    /**
     * Registers for activity recognition updates using
     * [ActivityRecognitionClient.requestActivityUpdates].
     * Registers success and failure callbacks.
     */
    fun requestActivityUpdatesButtonHandler() {
        val task = mActivityRecognitionClient.requestActivityUpdates(
                DetectedActivitiesConstants.DETECTION_INTERVAL_IN_MILLISECONDS,
                getActivityDetectionPendingIntent())

        task.addOnSuccessListener {
            Toast.makeText(mContext,
                    getString(R.string.activity_updates_enabled),
                    Toast.LENGTH_SHORT)
                    .show()
            setUpdatesRequestedState(true)
            updateDetectedActivitiesList()
        }

        task.addOnFailureListener {
            Log.w(TRACKING_SERVICE_TAG, getString(R.string.activity_updates_not_enabled))
            Toast.makeText(mContext,
                    getString(R.string.activity_updates_not_enabled),
                    Toast.LENGTH_SHORT)
                    .show()
            setUpdatesRequestedState(false)
        }
    }

    /**
     * Sets the boolean in SharedPreferences that tracks whether we are requesting activity
     * updates.
     */
    private fun setUpdatesRequestedState(requesting: Boolean) {
        PreferenceManager.getDefaultSharedPreferences(this)
                .edit()
                .putBoolean(DetectedActivitiesConstants.KEY_ACTIVITY_UPDATES_REQUESTED, requesting)
                .apply()
    }

    /**
     * Processes the list of freshly detected activities. Asks the adapter to update its list of
     * DetectedActivities with new `DetectedActivity` objects reflecting the latest detected
     * activities.
     */
    protected fun updateDetectedActivitiesList() {
        val detectedActivities = DetectedActivitiesUtils.detectedActivitiesFromJson(
                PreferenceManager.getDefaultSharedPreferences(mContext)
                        .getString(DetectedActivitiesConstants.KEY_DETECTED_ACTIVITIES, ""))

        //mAdapter.updateActivities(detectedActivities);

        updateActivities(detectedActivities)
    }

    override fun onSharedPreferenceChanged(sharedPreferences: SharedPreferences, s: String) {
        if (s == DetectedActivitiesConstants.KEY_DETECTED_ACTIVITIES) {
            updateDetectedActivitiesList()
        }
    }


    internal fun updateActivities(detectedActivities: ArrayList<DetectedActivity>) {
        // Find the most sensitive activity:

        var chosenActivity: DetectedActivity? = null

        for (i in detectedActivities.indices) {
            val detectedActivity = detectedActivities[i]
            if (chosenActivity == null) {
                chosenActivity = detectedActivity
            } else if (detectedActivity.confidence > chosenActivity.confidence) {
                chosenActivity = detectedActivity
            }
        }
        if(chosenActivity == null){
            return
        }
        chosenActivity = chosenActivity!!

        //HashMap<Integer, Integer> detectedActivitiesMap = new HashMap<>();
        //        for (DetectedActivity activity : detectedActivities) {
        //            detectedActivitiesMap.put(activity.getType(), activity.getConfidence());
        //        }
        //        // Every time we detect new activities, we want to reset the confidence level of ALL
        //        // activities that we monitor. Since we cannot directly change the confidence
        //        // of a DetectedActivity, we use a temporary list of DetectedActivity objects. If an
        //        // activity was freshly detected, we use its confidence level. Otherwise, we set the
        //        // confidence level to zero.
        //        ArrayList<DetectedActivity> tempList = new ArrayList<>();
        //        for (int i = 0; i < DetectedActivitiesConstants.MONITORED_ACTIVITIES.length; i++) {
        //            int confidence = detectedActivitiesMap.containsKey(DetectedActivitiesConstants.MONITORED_ACTIVITIES[i]) ?
        //                    detectedActivitiesMap.get(DetectedActivitiesConstants.MONITORED_ACTIVITIES[i]) : 0;
        //
        //            tempList.add(new DetectedActivity(DetectedActivitiesConstants.MONITORED_ACTIVITIES[i],
        //                    confidence));
        //        }
        //
        //        // Remove all items.
        //        this.clear();
        //
        //        // Adding the new list items notifies attached observers that the underlying data has
        //        // changed and views reflecting the data should refresh.
        //        for (DetectedActivity detectedActivity: tempList) {
        //            this.add(detectedActivity);
        //        }
        val chosenString = DetectedActivitiesUtils.getActivityDescription(mContext, chosenActivity)
        val activitiesString = DetectedActivitiesUtils.getAllActivitiesDescription(mContext, detectedActivities)

        createNotification(chosenString, activitiesString)


    }


}
