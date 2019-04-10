import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/model/route_detail.dart';
import 'package:minibus_easy/passenger_layout.dart';


Future<List<RouteDetail>> fetchRouteDetail(String route_id, int route_num_counter) async {
  final response =
  // await http.post('http://34.92.224.245:80/list_bueses');
  await http.post('http://34.92.224.245:80/passenger_request_arrival_real_time',
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


class BusRouteDetailPage extends StatelessWidget {
  Future<List<RouteDetail>> routeDetail;

  final String route_id;
  final int route_num_counter;
  BusRouteDetailPage({Key key, @required this.route_id, this.route_num_counter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    routeDetail = fetchRouteDetail(route_id, route_num_counter);
    // TODO: implement build
    return Scaffold(
      appBar: PassengerLayout().getAppBar(),

      body: Center(
        child: FutureBuilder <List<RouteDetail>>(
            future: routeDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {


                List<Widget> listOfRow = new List();
                int i = 1;
                int totalDuration = 0;

                for(RouteDetail routeDetail in snapshot.data){
                  String stop_name_en = routeDetail.stop_name_en;
                  String stop_name_tc = routeDetail.stop_name_tc;
                  int duration_sec = routeDetail.duration_sec;
                  totalDuration += duration_sec;

                  String totalDurationInString = new Duration(seconds: totalDuration).toString().split(".")[0];
                  //totalDurationInString = totalDurationInString.split(".")[0];
                  // bus.route_id
                  String demoText = "Stop Name: ${stop_name_en} ( ${stop_name_tc} ) \n Estimated time to station from main station: ${totalDurationInString}";

                  ListTile listTile = new ListTile(
                    title: Row(children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(i.toString()),
                        ),
                        Expanded(
                          flex: 9,
                          child: Text(demoText),
                        ),

                      ]
                    ),


//                    onTap: (){
//                      print(route_id);
//
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => BusRouteDetailPage(route_id: route_id)),
//                      );
//                    },
                  );
                  listOfRow.add(listTile);
                  i++;
                }

                final List<Widget> divided = ListTile
                    .divideTiles(
                  context: context,
                  tiles: listOfRow,
                  color: Colors.blue,
                ).toList();

                return ListView(children: divided);








                return Text("${snapshot.data}");

              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
        )
      )
//      bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
      //body: Center(child: Text('Route ID: ' + route_id + routeDetail)),
    );
  }

}
