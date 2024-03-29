
import 'dart:collection';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Class representing detail of route like arrival time and lat lng
class RouteDetail {
  final String stop_name_en;
  final String stop_name_tc;
  final int duration_sec;
  final LatLng latlng;
  final List<int> arrival_times;

  RouteDetail({this.stop_name_en, this.stop_name_tc, this.duration_sec, this.latlng, this.arrival_times});

  static List<RouteDetail> fromJson(List<dynamic> jsons) {
    List<RouteDetail> listOfRouteDetail = new List();

    for(Map<String, dynamic> json in jsons){
      dynamic duration_sec_dynamic = json['duration_sec'];
      int duration_sec;
      if(duration_sec_dynamic is int){
        duration_sec = duration_sec_dynamic;
      } else {
        duration_sec = int.parse(duration_sec_dynamic);
      }

      LatLng latlng;
      if(json.containsKey('latlng')){
        final LinkedHashMap<String, dynamic> latlngInput = json['latlng'];
         latlng = LatLng(latlngInput['lat'], latlngInput['lng']);
      }

      List<int> arrivalTimes = List<int>();
      if(json.containsKey('arrival_times')){
        final List<dynamic> arrivalTimesInput = json['arrival_times'];

        arrivalTimes = new List<int>.from(arrivalTimesInput);

      }
      
      RouteDetail routeDetail =  RouteDetail(
        stop_name_en : json['stop_name_en'],
        stop_name_tc : json['stop_name_tc'],
        duration_sec : duration_sec,
        latlng: latlng,
        arrival_times : arrivalTimes,
      );
      listOfRouteDetail.add(routeDetail);
    }
    return listOfRouteDetail;
  }


  static String toJson(List<RouteDetail> listRouteDetail){
    List<Map<String, dynamic>> listJson = [];
    for(RouteDetail routeDetail in listRouteDetail){
      Map<String, double> latlng;
      if(routeDetail.latlng != null){
        latlng = {
          "lat" : routeDetail.latlng.latitude,
          "lng" : routeDetail.latlng.longitude
        };
      }

      Map<String, dynamic> json = {
        "stop_name_en" : routeDetail.stop_name_en,
        "stop_name_tc" : routeDetail.stop_name_tc,
        "duration_sec" : routeDetail.duration_sec.toString(),
        "latlng" : latlng,
      };
      listJson.add(json);
    }
    return json.encode(listJson);
  }
}
