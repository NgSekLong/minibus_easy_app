

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/model/globals.dart';
import 'package:minibus_easy/model/route_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteInfoFetcher {

  ///
  /// To fetch buses, it goes through the following stages:
  /// 1. Check if need force update list (maybe after a period of time?)
  /// 2. Check user preference to see if have list available
  /// 3. If no list, or need force update, go to server to fetch the bus list
  /// 4. If use post to update list, save list into shared preference
  ///
  Future<List<Bus>> fetchBuses() async{
    List<Bus> fetchBuses = await fetchBusesFromSharedPreference();
    if(fetchBuses == null){
      fetchBuses = await fetchBusesFromServer();
      saveBusesToSharedPreference(fetchBuses);
    }

    return fetchBuses;
  }


  Future<List<Bus>> fetchBusesFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String fetchBusesJson = prefs.get(LIST_BUS_PREF);

    if(fetchBusesJson == null){
      return null;
    }
    List<Bus> fetchBuses = Bus.fromJson(json.decode(fetchBusesJson));
    return fetchBuses;
  }

  void saveBusesToSharedPreference(List<Bus> fetchedBuses) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(LIST_BUS_PREF, Bus.toJson(fetchedBuses));
  }


  Future<List<Bus>> fetchBusesFromServer() async {
    final response = await http.post('$BACKEND_SERVER_URL/list_bueses');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      List<Bus> post = Bus.fromJson(json.decode(response.body));
      return post;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  ////////////// Fetch Rote Detail ///////////////////////


  ///
  /// To fetch route details, it goes through the following stages:
  /// 1. Check if need force update list (maybe after a period of time?)
  /// 2. Check user preference to see if have list available
  /// 3. If no list, or need force update, go to server to fetch the bus list
  /// 4. If use post to update list, save list into shared preference
  ///
  Future<List<RouteDetail>> fetchRouteDetail(String route_id, int route_num_counter) async{
    List<RouteDetail> fetchRouteDetails = await fetchRouteDetailFromSharedPreference( route_id, route_num_counter);
    if(fetchRouteDetails == null){
      fetchRouteDetails = await fetchRouteDetailFromServer( route_id,  route_num_counter);
      saveRouteDetailToSharedPreference(fetchRouteDetails, route_id,  route_num_counter);
    }

    // TEMP: always fetch from network for now:
    fetchRouteDetails = await fetchRouteDetailFromServer( route_id,  route_num_counter);

    return fetchRouteDetails;
  }

  Future<List<RouteDetail>> fetchRouteDetailFromServer(String route_id, int route_num_counter) async {
    final response = await http.post('$BACKEND_SERVER_URL/passenger_request_arrival_real_time',
        //await http.post('http://10.0.2.2:8000/passenger_request_arrival_real_time',
        // body: {'route_id' : route_id, 'route_num_counter' : route_num_counter}
        body: {'route_id' : route_id, 'route_num_counter' : route_num_counter.toString()}
    );
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON

      List<RouteDetail> listOfRouteDetail = RouteDetail.fromJson(json.decode(response.body));
      return listOfRouteDetail;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }



  Future<List<RouteDetail>> fetchRouteDetailFromSharedPreference(String route_id, int route_num_counter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String fetchRouteDetailsJson = prefs.get("$LIST_ROUTE_DETAIL_PREF:$route_id:$route_num_counter");
    if(fetchRouteDetailsJson == null){
      return null;
    }
    List<RouteDetail> fetchRouteDetails = RouteDetail.fromJson(json.decode(fetchRouteDetailsJson));
    return fetchRouteDetails;
  }

  void saveRouteDetailToSharedPreference(List<RouteDetail> fetchRouteDetails, String route_id, int route_num_counter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("$LIST_ROUTE_DETAIL_PREF:$route_id:$route_num_counter", RouteDetail.toJson(fetchRouteDetails));
  }
}