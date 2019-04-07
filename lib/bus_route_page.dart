import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/bus_route_detail_page.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';

Future<List<Bus>> fetchBuses() async {
  final response =
  await http.post('http://34.92.224.245:80/list_bueses');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List<Bus> post = Bus.fromJson(json.decode(response.body));
    return post;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}



class BusRoutePage extends StatelessWidget {

  Future<List<Bus>> post;
  //BusRoutePage({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final post = fetchBuses();
    // TODO: implement build
    return Scaffold(
      appBar: PassengerLayout().getAppBar(),
      bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
      body: Center(
        child: FutureBuilder<List<Bus>>(
          future: post,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> listOfRow = new List();
              int routeNumCounter = 0;
              String previousRouteId = "";

              for(Bus bus in snapshot.data){
                String route_id = bus.route_id;

                if(route_id == previousRouteId){
                  routeNumCounter++;
                } else {
                  routeNumCounter=0;
                }
                int currentRouteNumCount = routeNumCounter;
                previousRouteId = route_id;

                //print(route_id +":"+ routeNumCounter.toString());

                // bus.route_id
                String demoText = "route_id: ${bus.route_id}, Region: ${bus.region}, \n";
                demoText += "From '${bus.route_start_at_en}' to: '${bus.route_end_at_en}', \n'${bus.route_start_at_tc}' 到 '${bus.route_end_at_tc}'";
                ListTile listTile = new ListTile(
                  title:

                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(bus.route_number),
                      ),
                      Expanded(
                        flex: 9,
                        child: Text(demoText),
                      ),
                    ],
                  ),
//                  Row(children: <Widget>[
//
//                    Text(bus.route_number),
//                    Text(demoText),
//                  ],),

                  onTap: (){

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusRouteDetailPage(route_id: route_id, route_num_counter: currentRouteNumCount)),
                    );
                  },
                );
                listOfRow.add(listTile);
              }

              final List<Widget> divided = ListTile
                  .divideTiles(
                context: context,
                tiles: listOfRow,
                color: Colors.blue,
              ).toList();

              return ListView(children: divided);



            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

}
