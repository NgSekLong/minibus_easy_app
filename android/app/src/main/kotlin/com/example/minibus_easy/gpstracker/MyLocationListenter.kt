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
    override fun onLocationChanged(location: Location?) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }
//
//    override fun onLocationChanged(loc: Location) {
//        editLocation.setText("")
//        pb.setVisibility(View.INVISIBLE)
//        Toast.makeText(
//                getBaseContext(),
//                "Location changed: Lat: " + loc.getLatitude() + " Lng: "
//                        + loc.getLongitude(), Toast.LENGTH_SHORT).show()
//        val longitude = "Longitude: " + loc.getLongitude()
//        Log.v(TAG, longitude)
//        val latitude = "Latitude: " + loc.getLatitude()
//        Log.v(TAG, latitude)
//
//        /*------- To get city name from coordinates -------- */
//        var cityName: String? = null
//        val gcd = Geocoder(getBaseContext(), Locale.getDefault())
//        val addresses: List<Address>
//        try {
//            addresses = gcd.getFromLocation(loc.getLatitude(),
//                    loc.getLongitude(), 1)
//            if (addresses.size > 0) {
//                System.out.println(addresses[0].getLocality())
//                cityName = addresses[0].getLocality()
//            }
//        } catch (e: IOException) {
//            e.printStackTrace()
//        }
//
//        val s = (longitude + "\n" + latitude + "\n\nMy Current City is: "
//                + cityName)
//        editLocation.setText(s)
//    }

    override fun onProviderDisabled(provider: String) {}

    override fun onProviderEnabled(provider: String) {}

    override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}
}