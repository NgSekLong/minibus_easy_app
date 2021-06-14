import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/model/globals.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/route_detail.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/bus_route_detail_map_page.dart';
import 'package:minibus_easy/view/bus_route_detail_page.dart';
import 'package:minibus_easy/view/bus_route_reference_page.dart';


class BusRouteDetailNavigation extends StatefulWidget {
  final String route_id;
  final int route_num_counter;
  BusRouteDetailNavigation({Key key, @required this.route_id, this.route_num_counter}) : super(key: key);
  @override
  _BusRouteDetailNavigationState createState() => new _BusRouteDetailNavigationState();
}

class _BusRouteDetailNavigationState extends State<BusRouteDetailNavigation> with SingleTickerProviderStateMixin  {
  Future<List<RouteDetail>> routeDetail;


  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  Container getTabBar() {
    return Container(
        child: Material(
          color: Theme.of(context).bottomAppBarColor,
          child: new TabBar(
            tabs: <Tab>[
              new Tab(
                text: 'ROUTE',
              ),
              new Tab(
                text: 'MAP',
              ),
              new Tab(
                text: 'PRICE / INFO',
              ),
            ],
            // setup the controller
            controller: controller,
          ),
        ));
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
      physics: NeverScrollableScrollPhysics(),
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PassengerLayout().getAppBar(context),

      body: Scaffold(
        appBar: AppBar(
          leading: Text(''),
          titleSpacing: 0.0,
          title: getTabBar(),
          backgroundColor: Color(0xFFe7e2dd),
        ),
        body:
        getTabBarView(<Widget>[
          BusRouteDetailPage(route_id: widget.route_id ,route_num_counter: widget.route_num_counter,),
          BusRouteDetailMapPage(route_id: widget.route_id ,route_num_counter: widget.route_num_counter,),
          BusRouteReferencePage(route_id: widget.route_id ),
        ])
      )
    );
  }

}
