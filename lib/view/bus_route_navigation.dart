import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/globals.dart';
import 'package:minibus_easy/model/route_info_fetcher.dart';
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/bus_route_page.dart';


class BusRouteNavigation extends StatefulWidget {
  @override
  _BusRouteNavigationState createState() => new _BusRouteNavigationState();
}

class _BusRouteNavigationState extends State<BusRouteNavigation>
    with SingleTickerProviderStateMixin {
  Future<List<Bus>> post;

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
            text: 'HK ISLAND',
          ),
          new Tab(
            text: 'KOWLOON',
          ),
          new Tab(
            text: 'N.T.',
          ),
        ],
        // setup the controller
        controller: controller,
      ),
    ));
  }

  TabBarView getTabBarView(var tabs) {
    return new TabBarView(
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    RouteInfoFetcher routeInfoFetcher = RouteInfoFetcher();
    final Future<List<Bus>> buses = routeInfoFetcher.fetchBuses();
    return Scaffold(

        appBar: AppBar(
          titleSpacing: 0.0,
          title: getTabBar(),
          backgroundColor: Color(0xFFe7e2dd),
        ),
        body: getTabBarView(<Widget>[
          BusRoutePage(buses: buses, region: 'Hong Kong Island'),
          BusRoutePage(buses: buses, region: 'Kowloon'),
          BusRoutePage(buses: buses, region: 'New Territories'),
        ]));
  }
}
