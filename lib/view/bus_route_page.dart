import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/locale/bloc_provider.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/locale/translations_bloc.dart';
import 'package:minibus_easy/view/bus_route_detail_page.dart';
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/component/bus_route_row.dart';

class BusRoutePage extends StatefulWidget {
  final Future<List<Bus>> buses;

  final String region;

  final String startsWith;

  const BusRoutePage({Key key, this.buses, this.region, this.startsWith}) : super(key: key);

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
    final String language = locale.currentLanguage.toString();

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
              if (widget.region != null
                  && bus.region != widget.region) {
                continue;
              }



              String route_number = bus.route_number;

              if(widget.startsWith != null){
                // Only shows if start with
                if(!route_number.startsWith(widget.startsWith)){
                  continue;
                }
              }

              String route_id = bus.route_id;
              if (route_id == previousRouteId) {
                routeNumCounter++;
              } else {
                routeNumCounter = 0;
              }
              previousRouteId = route_id;

              Widget listTile = BusRouteRow(
                bus: bus,
                currentRouteNumCount: routeNumCounter,
                langauge: language,
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
