package com.example.minibus_easy.gpstracker


internal object GPSTrackerConstant {
    const val UPDATE_INTERVAL : Long = 10 * 1000 // milliseconds, Our basica update interval
    const val FASTEST_INTERVAL : Long = 10 * 1000 // Our update interval if other app used faster interval
}