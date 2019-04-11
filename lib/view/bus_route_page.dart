import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/view/bus_route_detail_page.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';


class BusRoutePage extends StatefulWidget {
  final Future<List<Bus>> buses ;
  final String region;

  const BusRoutePage({Key key, this.buses, this.region}): super(key: key);

  @override
  _BusRoutePageState createState() => new _BusRoutePageState();
}

class _BusRoutePageState extends State<BusRoutePage>
    with SingleTickerProviderStateMixin {
  Future<List<Bus>> post;



  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    //final buses = fetchBuses();
    final Future<List<Bus>> buses = widget.buses;
    return Center(
      child: FutureBuilder<List<Bus>>(
        future: buses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> listOfRow = new List();
            int routeNumCounter = 0;
            String previousRouteId = "";

            for (Bus bus in snapshot.data) {
              // continue if route didn't match bus
              if (bus.region != widget.region){
                continue;
              }

              String route_id = bus.route_id;

              if (route_id == previousRouteId) {
                routeNumCounter++;
              } else {
                routeNumCounter = 0;
              }
              int currentRouteNumCount = routeNumCounter;
              previousRouteId = route_id;

              //print(route_id +":"+ routeNumCounter.toString());

              // bus.route_id
              String demoText =
                  "route_id: ${bus.route_id}, \n";
              demoText +=
                  "From '${bus.route_start_at_en}' \nTo: '${bus.route_end_at_en}', \n'${bus.route_start_at_tc}' 到 '${bus.route_end_at_tc}'";

              final leftSection = new Container(
                padding: EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  child: Text(
                    bus.route_number,
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.greenAccent[100],
                  radius: 24.0,
                ),
              );
              final middleSection = new Container(
                child: Text(demoText),
              );
              ListTile listTile = new ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
//                      Expanded(
//                        flex: 1,
//                        child: Text(bus.route_number),
//                      ),
//                      Expanded(
//                        flex: 9,
//                        child: Text(demoText),
//                      ),
                    leftSection,
                    middleSection
                  ],
                ),
//                  Row(children: <Widget>[
//
//                    Text(bus.route_number),
//                    Text(demoText),
//                  ],),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BusRouteDetailPage(
                            route_id: route_id,
                            route_num_counter: currentRouteNumCount)),
                  );
                },
              );
              listOfRow.add(listTile);
            }

            final List<Widget> divided = ListTile.divideTiles(
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
    );
  }
}
