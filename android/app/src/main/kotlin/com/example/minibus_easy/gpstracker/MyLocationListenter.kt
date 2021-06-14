package com.example.minibus_easy.gpstracker

import java.nio.file.Files.size
import android.content.ContentValues.TAG
import android.location.Address
import android.location.Geocoder
import android.location.Location
import android.location.LocationListener
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Toast
import java.io.IOException
import java.util.*


private class MyLocationListener : LocationListener {
    override fun onLocationChanged(location: Location?) {}

    override fun onProviderDisabled(provider: String) {}

    override fun onProviderEnabled(provider: String) {}

    override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}
}