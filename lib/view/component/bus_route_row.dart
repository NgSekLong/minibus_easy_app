import 'package:flutter/material.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';

class BusRouteRow extends StatelessWidget {
  final Bus bus;
  final int currentRouteNumCount;
  final String langauge;

  BusRouteRow({this.bus, this.currentRouteNumCount, this.langauge});

  @override
  Widget build(BuildContext context) {
    String route_id = bus.route_id;

    // bus.route_id
    String demoText = "debug: route_id: ${bus.route_id}, \n";

    if (langauge == 'tc') {
      demoText += "由: '${bus.route_start_at_tc}' \n到: '${bus.route_end_at_tc}'";
    } else {
      demoText +=
          "From: '${bus.route_start_at_en}' \nTo: '${bus.route_end_at_en}'";
    }

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
      child: Flexible(child: Text(demoText)),
    );

    ListTile listTile = new ListTile(
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[leftSection, middleSection],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusRouteDetailNavigation(
                route_id: route_id, route_num_counter: currentRouteNumCount),
          ),
        );
      },
    );

    return listTile;
  }
}
