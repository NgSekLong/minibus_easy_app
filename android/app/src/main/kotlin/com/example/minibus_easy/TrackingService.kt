package com.example.minibus_easy

import android.Manifest
import android.app.PendingIntent
import android.app.Service
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.preference.PreferenceManager
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat

import java.util.ArrayList
import java.util.Date
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants.NOTIFICATION_CHANNEL_ID
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants.NOTIFICATION_ID
import com.example.minibus_easy.activityrecognition.DetectedActivitiesConstants.TRACKING_SERVICE_TAG
import com.example.minibus_easy.activityrecognition.DetectedActivitiesIntentService
import com.example.minibus_easy.activityrecognition.DetectedActivitiesUtils
import com.example.minibus_easy.gpstracker.GPSTrackerConstant.FASTEST_INTERVAL
import com.example.minibus_easy.gpstracker.GPSTrackerConstant.UPDATE_INTERVAL
import com.github.kittinunf.fuel.Fuel
import com.github.kittinunf.fuel.httpGet
import com.github.kittinunf.fuel.httpPost
import com.github.kittinunf.result.Result

//import com.example.minibus_easy.gpstracker.LatLngTime
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.api.GoogleApiClient
import com.google.android.gms.location.*
import org.json.JSONArray
import java.text.SimpleDateFormat

//
import kotlinx.serialization.*
import kotlinx.serialization.json.Json
import java.io.File

class TrackingService : Service(), SharedPreferences.OnSharedPreferenceChangeListener,
        GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener,
        com.google.android.gms.location.LocationListener,
        ActivityCompat.OnRequestPermissionsResultCallback {

    /**
     * General variables
     */
    private lateinit var mContext: Context


    /**
     * Variables for Notification
     */
    private val mBuilder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
    //Different Id's will show up as different notifications
    //Some things we only have to set the first time.
    private var notificationFirstTime = true

    private var detectedActivitiesShortText = ""
    private var detectedActivitiesLongText = ""

    private var gpsTrackerText = ""



    /**
     * Variables for GPS tracking
     */
    private lateinit var mGoogleApiClient: GoogleApiClient
    private lateinit var mLocation: Location
    private lateinit var locationManager: LocationManager
    private lateinit var mLocationRequest: LocationRequest
    private lateinit var mLocationProvider : FusedLocationProviderApi

    @Serializable
    data class LatLngTime(val lat : String, val lng: String, val time: String)

    /**
     * The entry point for interacting with activity recognition.
     */
    private lateinit var mActivityRecognitionClient: ActivityRecognitionClient

    /**
     * GPS Permission checker
     */
    private val FLUTTER_PERMISSION_LIBRARY_CODE = 25

    // We use FLAG_UPDATE_CURRENT so that we get the same pending intent back when calling
    // requestActivityUpdates() and removeActivityUpdates().
    /**
     * Gets a PendingIntent to be sent for each activity detection.
     */

    /**
     * Save GPS Pref
     */
    private val SAVE_GPS_PREF = "SAVE_GPS_PREF"
    private val DRIVER_ROUTE_ID_PREF = "DRIVER_ROUTE_ID_PREF"
    private val SHARED_PREFERENCES_NAME = "FlutterSharedPreferences"
    private val SHARED_PREFERENCES_PREFIX = "flutter."

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

        // Detected Activities
//        val detectedActivities = DetectedActivitiesUtils.detectedActivitiesFromJson(
//                PreferenceManager.getDefaultSharedPreferences(this).getString(
//                        DetectedActivitiesConstants.KEY_DETECTED_ACTIVITIES, ""))


        PreferenceManager.getDefaultSharedPreferences(this)
                .registerOnSharedPreferenceChangeListener(this)
        mActivityRecognitionClient = ActivityRecognitionClient(this)
        requestActivityUpdatesButtonHandler()




        // GPS Tracker logic
        mGoogleApiClient = GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(LocationServices.API)
                .build()

        mLocationProvider = LocationServices.FusedLocationApi;


        mLocationRequest = LocationRequest.create()
                .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
                .setInterval(UPDATE_INTERVAL)
                .setFastestInterval(FASTEST_INTERVAL)


    }

    override fun onDestroy() {
        PreferenceManager.getDefaultSharedPreferences(this)
                .unregisterOnSharedPreferenceChangeListener(this)

        // GPS Tracker

        if (mGoogleApiClient.isConnected()) {
            mGoogleApiClient.disconnect()
        }
        super.onDestroy()
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {

        //
        mGoogleApiClient.connect()
        return START_NOT_STICKY
    }

    private fun createNotificationForDetectedActivities(chosenString: String, activitiesString: String){
        detectedActivitiesShortText = chosenString
        detectedActivitiesLongText = activitiesString
        createNotification()
    }

    private fun createNotificationForGPSTracker(gpsString: String){
        gpsTrackerText = gpsString
        createNotification()

    }



    private fun createNotification() {

        val currentTime = SimpleDateFormat("HH:mm:ss").format(Date())

        val title = "Tracking on: $currentTime in $gpsTrackerText "
        val contentText = detectedActivitiesShortText
        val bigText = detectedActivitiesLongText


        // String input = intent.getStringExtra("inputExtra");
        if (notificationFirstTime) {
            val notificationIntent = Intent(this, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(this,
                    0, notificationIntent, 0)
            mBuilder
                    .setSmallIcon(R.drawable.notification_icon_background)
                    .setContentIntent(pendingIntent).build()
            notificationFirstTime = false
        }
        mBuilder
                .setContentTitle(title)
                .setContentText(contentText)
                .setStyle(NotificationCompat.BigTextStyle()
                        .bigText(bigText))

        startForeground(NOTIFICATION_ID, mBuilder.build())
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
        if (chosenActivity == null) {
            return
        }
        chosenActivity = chosenActivity!!

        val chosenString = DetectedActivitiesUtils.getActivityDescription(mContext, chosenActivity)
        val activitiesString = DetectedActivitiesUtils.getAllActivitiesDescription(mContext, detectedActivities)
        createNotificationForDetectedActivities(chosenString, activitiesString)
    }

    ////////////////////////GPS//////////////////////////////


    override fun onConnected(bundle: Bundle?) {

//        if (ActivityCompat.checkSelfPermission(this,
//                Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED ) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient,
                mLocationRequest, this)
        //startLocationUpdates()

        // TODO: Instead of just quitting after seeing no GPS, make something different

        if(!isLocationServicesAvailable(mContext)){
            return
        }

        locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager

        // GPS Tracker
//        if(mGoogleApiClient == null){
//            buildGoogleApiClient()
//            mGoogleApiClient.connect()
//        }

        //mGoogleApiClient.connect()
        mLocation = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient)
        if (mLocation == null) {
            startLocationUpdates()
        }
        if (mLocation != null) {
            val latitude = mLocation.getLatitude()
            val longitude = mLocation.getLongitude()
            Toast.makeText(this, "Latitude:$latitude, Longtitude: $longitude", Toast.LENGTH_SHORT).show()
        } else {
             Toast.makeText(this, "Location not Detected", Toast.LENGTH_SHORT).show()
        }
    }

    fun buildGoogleApiClient(){
        mGoogleApiClient = GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(LocationServices.API)
                .build()
    }
    fun  isLocationServicesAvailable(context: Context): Boolean {

        var locationMode = 0
        val locationProviders: String
        var isAvailable = false

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT){
            try {
                locationMode = Settings.Secure.getInt(context.contentResolver, Settings.Secure.LOCATION_MODE)
            } catch (e: Settings.SettingNotFoundException) {
                e.printStackTrace()
            }

            isAvailable = (locationMode != Settings.Secure.LOCATION_MODE_OFF);
        }
        else {
            locationProviders = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.LOCATION_PROVIDERS_ALLOWED);
            isAvailable = !TextUtils.isEmpty(locationProviders);
        }

        val coarsePermissionCheck = ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION) === PackageManager.PERMISSION_GRANTED
        val finePermissionCheck = ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) === PackageManager.PERMISSION_GRANTED


        return isAvailable && (coarsePermissionCheck || finePermissionCheck)
    }



    /**
     * TODO: make this work.....
     */
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if(requestCode == FLUTTER_PERMISSION_LIBRARY_CODE) {
            startLocationUpdates()
            Toast.makeText(mContext, "Permission Granted!", Toast.LENGTH_SHORT).show()
            //return true
        } else {
            Toast.makeText(mContext, "Permission Denied!", Toast.LENGTH_SHORT).show()
            //return false
        }

    }

    protected fun startLocationUpdates() {
        // Create the location request
        mLocationRequest = LocationRequest.create()
                .setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY)
                .setInterval(UPDATE_INTERVAL)
                .setFastestInterval(FASTEST_INTERVAL)
        // Request location updates
        if (ActivityCompat.checkSelfPermission(this,
                        Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {

            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient,
                mLocationRequest, this)

        //LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, this)
        Log.d("reque", "--->>>>")
    }

    override fun onConnectionSuspended(i: Int) {
        Log.i(ContentValues.TAG, "Connection Suspended")
        mGoogleApiClient.connect()
    }

    override fun onConnectionFailed(connectionResult: ConnectionResult) {
        Log.i(ContentValues.TAG, "Connection failed. Error: " + connectionResult.errorCode)
    }

    override fun onLocationChanged(location: Location) {

//        val msg = "Updated Location: " +
//                java.lang.Double.toString(location.latitude) + "," +
//                java.lang.Double.toString(location.longitude)
        val latitude = location.latitude.toString()
        val longitude = location.longitude.toString()
        val gpsText = "[GPS: $latitude, $longitude]"
        saveGpsPref(latitude, longitude)
        createNotificationForGPSTracker(gpsText)
        // Toast.makeText(this, msg, Toast.LENGTH_SHORT).show()
    }



    fun saveGpsPref(appendLat : String, appendLng : String){
        val prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
        val saveGpsPref = prefs.getString("$SHARED_PREFERENCES_PREFIX$SAVE_GPS_PREF", "[]")

        val latlngJsonArray  = JSONArray(saveGpsPref)
        //val latlngArray: MutableList<Map<String, String>> = ArrayList()
        val latlngArray: MutableList<LatLngTime> = ArrayList()

        for(i in 0..latlngJsonArray.length() -1 ){
            val latitudeLongtitude = latlngJsonArray.getJSONObject(i)

            val lat = latitudeLongtitude.getString("lat")
            val lng = latitudeLongtitude.getString("lng")
            val time = latitudeLongtitude.getString("time")

            val latlng = LatLngTime(lat,lng,time)

            latlngArray.add(latlng)
        }
        val currentUnixTime = System.currentTimeMillis() / 1000
        val currentUnixTimeString = currentUnixTime.toString()
        val appendlatlng = LatLngTime(appendLat,appendLng, currentUnixTimeString)

        sentLatLngToServer(appendlatlng)

        latlngArray.add(appendlatlng)


        val jsonData = Json.stringify(LatLngTime.serializer().list, latlngArray)

//
        // val jsonData = Json.stringify(Map<String,String>.serializer().list, latlngArray)
//
//
//
//        if (restoredText != null) {
//            val name = prefs.getString("name", "No name defined")//"No name defined" is the default value.
//            val idName = prefs.getInt("idName", 0) //0 is the default value.
//        }

        val editor = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE).edit()
        editor.putString("$SHARED_PREFERENCES_PREFIX$SAVE_GPS_PREF", jsonData)
        editor.apply()
        // getAllGPSPrefForLols()
    }
    fun sentLatLngToServer(latLngTime: LatLngTime) {


        val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        val wInfo = wifiManager.getConnectionInfo()
        val macAddress = wInfo.getMacAddress()
        /*
        mac_address:1234
lat:123.3
lng:123.4
time:1557669212
route_id:2001
         */

        val prefs = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE)
        var driverRouteIdPref = prefs.getString("$SHARED_PREFERENCES_PREFIX$DRIVER_ROUTE_ID_PREF", null)
        if(driverRouteIdPref.isNullOrEmpty()){
            // No route_id specified, skiped
            return
        }


        Fuel.post("http://35.229.213.37:80/submit_gps",
            listOf(
                "mac_address" to macAddress,
                "route_id" to driverRouteIdPref,
                "lat" to latLngTime.lat,
                "lng" to latLngTime.lng,
                "time" to latLngTime.time
            )
        )
        .responseString { request, response, result ->
            when (result) {
                is Result.Failure -> {
                    val ex = result.getException()
                }
                is Result.Success -> {
                    val data = result.get()
                }
            }
        }


//        "https://httpbin.org/get"
//            .httpPost()
//            .responseString { request, response, result ->
//                when (result) {
//                    is Result.Failure -> {
//                        val ex = result.getException()
//                    }
//                    is Result.Success -> {
//                        val data = result.get()
//                    }
//                }
//            }

//        "https://httpbin.org/get"
//        .httpPost()
//        .responseString { request, response, result ->
//            when (result) {
//                is Result.Failure -> {
//                    val ex = result.getException()
//                }
//                is Result.Success -> {
//                    val data = result.get()
//                }
//            }
//        }
    }

//    fun resetGpsPref(){
//        val editor = getSharedPreferences(SHARED_PREFERENCES_NAME, Context.MODE_PRIVATE).edit()
//        editor.putString(SAVE_GPS_PREF, "[]")
//        editor.apply()
//    }

}