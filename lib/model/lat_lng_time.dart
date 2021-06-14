
import 'dart:convert';

/// Class representing a combination of Latitude, Longtitude and time use for displaying bus stop
class LatLngTime {
  final String lat;
  final String lng;
  final String time;

  LatLngTime({this.lat, this.lng, this.time});

  static List<LatLngTime> fromJson(List<dynamic> jsons) {
    List<LatLngTime> listOfRouteDetail = new List();

    for(Map<String, dynamic> json in jsons){
      LatLngTime routeDetail =  LatLngTime(
        lat : json['lat'],
        lng : json['lng'],
        time : json['time'],
      );
      listOfRouteDetail.add(routeDetail);
    }
    return listOfRouteDetail;
  }


  static String toJson(List<LatLngTime> listRouteDetail){
    List<Map<String, String>> listJson = [];
    for(LatLngTime routeDetail in listRouteDetail){
      Map<String, String> json = {
        "lat" : routeDetail.lat,
        "lng" : routeDetail.lng,
        "time" : routeDetail.time
      };
      listJson.add(json);
    }
    return json.encode(listJson);

  }
}
