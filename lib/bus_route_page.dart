import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:minibus_easy/model/bus_route_json.dart';

Future<BusRouteJson> fetchPost() async {
  final response = await http.post('http://127.0.0.1:8000/passenger_request_arrival_real_time');

  if(response.statusCode == 200){
    return BusRouteJson.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}


class BusRoutePage extends StatelessWidget {
  final Future<BusRouteJson> busRouteJson;

  BusRoutePage({Key key, this.busRouteJson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Minibus Easy'),
        ),
        //body: BusRoute()
        body: Center (
          child: FutureBuilder <BusRouteJson>(
              future: busRouteJson,
              builder: (context, snapshot) {

                if ( snapshot.hasData) {
                  return Text(snapshot.data.stopNameEn);
                } else if (snapshot.hasError){
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return CircularProgressIndicator();
              }

          )
        )
    );
  }
}

class BusRoute extends StatefulWidget {



  @override
  _BusRouteState createState() => _BusRouteState();
}

class _BusRouteState extends State<BusRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('OK'),

      ),
      body: Text('Is Body!')
    );
  }

}