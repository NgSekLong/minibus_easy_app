import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/globals.dart';
import 'package:minibus_easy/model/lat_lng_time.dart';
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapSample()
    );
  }

}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Polyline polyline = Polyline(polylineId: PolylineId("placeholder"));

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kHongKong = CameraPosition(
    target: LatLng(22.3193, 114.1694),
    zoom: 10,
  );

  Future _initMarkers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String savedGps = prefs.get(SAVE_GPS_PREF);
    if(savedGps == null){
      savedGps = "[]";
    }
    
    List<LatLngTime> latlngtimeList = LatLngTime.fromJson(json.decode(savedGps));

    latlngtimeList.forEach((latlngtime) {
      _addMarker(latlngtime);
    });
  }
  void _addMarker(LatLngTime latlngtime) {
    double lat = double.parse(latlngtime.lat);
    double lng = double.parse(latlngtime.lng);
    int time = int.parse(latlngtime.time);


    var markerIdVal = 'Marker-$time'; 
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat,lng),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
    );
    
    var polylineIdVal = 'Polyline-$time';
    final PolylineId polylineId = PolylineId(polylineIdVal);

    List<LatLng> latlngs = [];
    markers.forEach((id, marker) => {
      latlngs.add(marker.position)
    });

    final Polyline newPolyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: latlngs,
    );
    if (this.mounted){

      setState(() {
        // adding a new marker to map
        markers[markerId] = marker;
        polyline = newPolyline;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initMarkers();
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kHongKong,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of([polyline]),
      ),
    );
  }
}