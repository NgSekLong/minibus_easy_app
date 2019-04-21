
import 'dart:convert';

class RouteDetail {



  final String stop_name_en;
  final String stop_name_tc;
  final int duration_sec;

  RouteDetail({this.stop_name_en, this.stop_name_tc, this.duration_sec});

  //factory Post.fromJson(Map<String, dynamic> json) {
  static List<RouteDetail> fromJson(List<dynamic> jsons) {
    //Map<String, dynamic> json = jsons[0];
    List<RouteDetail> listOfRouteDetail = new List();

    for(Map<String, dynamic> json in jsons){
      dynamic duration_sec_dynamic = json['duration_sec'];
      int duration_sec;
      if(duration_sec_dynamic is int){
        duration_sec = duration_sec_dynamic;
      } else {
        duration_sec = int.parse(duration_sec_dynamic);
      }


      RouteDetail routeDetail =  RouteDetail(
        stop_name_en : json['stop_name_en'],
        stop_name_tc : json['stop_name_tc'],
        duration_sec : duration_sec,
      );
      listOfRouteDetail.add(routeDetail);
    }
    return listOfRouteDetail;
  }


  static String toJson(List<RouteDetail> listRouteDetail){
    List<Map<String, String>> listJson = [];
    for(RouteDetail routeDetail in listRouteDetail){
      Map<String, String> json = {
        "stop_name_en" : routeDetail.stop_name_en,
        "stop_name_tc" : routeDetail.stop_name_tc,
        "duration_sec" : routeDetail.duration_sec.toString()
      };
      listJson.add(json);
    }
    return json.encode(listJson);

  }
}
