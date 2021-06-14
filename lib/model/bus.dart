
import 'dart:convert';

/// Class to represent a Bus
class Bus {
  final String route_id;
  final String route_number;
  final String region;
  final String route_start_at_en;
  final String route_start_at_tc;
  final String route_end_at_en;
  final String route_end_at_tc;

  Bus({this.route_id, this.route_number, this.region, this.route_start_at_en, this.route_start_at_tc, this.route_end_at_en, this.route_end_at_tc});

  static List<Bus> fromJson(List<dynamic> jsons) {
    List<Bus> listOfPost = new List();

    for(Map<String, dynamic> json in jsons){

      Bus bus =  Bus(
        route_id : json['route_id'],
        route_number : json['route_number'],
        region : json['region'],
        route_start_at_en : json['route_start_at_en'],
        route_start_at_tc : json['route_start_at_tc'],
        route_end_at_en : json['route_end_at_en'],
        route_end_at_tc : json['route_end_at_tc'],
      );
      listOfPost.add(bus);
    }

    return listOfPost;
  }

  static String toJson(List<Bus> listBuses){
    List<Map<String, String>> listJson = [];
    for(Bus bus in listBuses){
       Map<String, String> json = {
        "route_id" : bus.route_id,
        "route_number" : bus.route_number,
        "region" : bus.region,
        "route_start_at_en" : bus.route_start_at_en,
        "route_start_at_tc" : bus.route_start_at_tc,
        "route_end_at_en" : bus.route_end_at_en,
        "route_end_at_tc" : bus.route_end_at_tc,
      };
       listJson.add(json);
    }
    return json.encode(listJson);
  }
}
