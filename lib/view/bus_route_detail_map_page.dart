import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/globals.dart';
import 'package:minibus_easy/model/lat_lng_time.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/route_detail.dart';
import 'package:minibus_easy/model/route_info_fetcher.dart';
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusRouteDetailMapPage extends StatefulWidget {


  final String route_id;
  final int route_num_counter;

  BusRouteDetailMapPage({Key key, @required this.route_id, this.route_num_counter})
      : super(key: key);


  @override
  State<BusRouteDetailMapPage> createState() => BusRouteDetailMapPageState();
}

class BusRouteDetailMapPageState extends State<BusRouteDetailMapPage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Polyline polyline = Polyline(polylineId: PolylineId("placeholder"));

  //Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kHongKong = CameraPosition(
    target: LatLng(22.3193, 114.1694),
    zoom: 12,
  );




  Future _initMarkers() async {
    RouteInfoFetcher routeInfoFetcher = RouteInfoFetcher();
    final List<RouteDetail> routeDetailList = await routeInfoFetcher.fetchRouteDetail(widget.route_id, widget.route_num_counter);

    int i = 0;
    routeDetailList.forEach((routeDetail) {
      _addMarker(routeDetail, i);
      i++;
    });
    _addLines();
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//    // prefs.setString("SAVE_GPS_PREF", "[]");
//
//    String savedGps = prefs.get(SAVE_GPS_PREF);
//    if(savedGps == null){
//      savedGps = "[]";
//    }
//
//    List<LatLngTime> latlngtimeList = LatLngTime.fromJson(json.decode(savedGps));
//
//    latlngtimeList.forEach((latlngtime) {
//      _addMarker(latlngtime);
//    });
  }
  void _addMarker(RouteDetail routeDetail, int i) {

    final String langauge = locale.currentLanguage.toString();



    String stop_name_en = routeDetail.stop_name_en;
    String stop_name_tc = routeDetail.stop_name_tc;
    int duration_sec = routeDetail.duration_sec;

    int totalDuration = duration_sec; // TODO: make actual arrival time instead of this things.

    String totalDurationInString = new Duration(seconds: totalDuration).toString().split(".")[0];
    //totalDurationInString = totalDurationInString.split(".")[0];
    // bus.route_id

    String stopName = '';
    if(langauge == 'tc'){
      stopName = stop_name_tc;
    } else {
      stopName = stop_name_en;

    }

    final String title = "$i - $stopName";



    var markerIdVal = 'Marker-$i'; //MyWayToGenerateId();
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: routeDetail.latlng,
      infoWindow: InfoWindow(title: title, snippet: totalDurationInString),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );



//    var polylineIdVal = 'Polyline-$i';
//    final PolylineId polylineId = PolylineId(polylineIdVal);
//
//    //markers[0].position
//    //markers.map((marker, v) => marker.value);
//    List<LatLng> latlngs = [];
//    markers.forEach((id, marker) => {
//      latlngs.add(marker.position)
//    });
//
//
////    List<LatLng> latlngs = markers.map((v) => {
////      return v.;
////    });
//
//    final Polyline newPolyline = Polyline(
//      polylineId: polylineId,
//      consumeTapEvents: true,
//      color: Colors.orange,
//      width: 5,
//      points: latlngs,
//      onTap: () {
//        //_onPolylineTapped(polylineId);
//      },
//    );


    if (this.mounted){

      setState(() {
        // adding a new marker to map
        markers[markerId] = marker;
        // polyline = newPolyline;
      });
    }
  }


  void _addLines() {

    var polylineIdVal = 'Polyline';
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
      onTap: () {
        //_onPolylineTapped(polylineId);
      },
    );

    if (this.mounted){
      setState(() {
        polyline = newPolyline;
      });
    }
  }



  @override
  void initState() {
    super.initState();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('I am driving this Route!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(DRIVER_ROUTE_ID_PREF, widget.route_id);
  }
}