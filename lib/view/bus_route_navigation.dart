import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/bus_route_page.dart';

Future<List<Bus>> fetchBuses() async {
  final response = await http.post('http://34.92.224.245:80/list_bueses');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List<Bus> post = Bus.fromJson(json.decode(response.body));
    return post;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class BusRouteNavigation extends StatefulWidget {
  @override
  _BusRouteNavigationState createState() => new _BusRouteNavigationState();
}

class _BusRouteNavigationState extends State<BusRouteNavigation>
    with SingleTickerProviderStateMixin {
  Future<List<Bus>> post;

  //BusRoutePage({Key key, this.post}) : super(key: key);

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

//  TabBar getTabBar() {
//    return new TabBar(
//      tabs: <Tab>[
//        new Tab(
//          text: 'HK ISLAND',
//        ),
//        new Tab(
//          text: 'KOWLOON',
//        ),
//        new Tab(
//          text: 'NEW TERRITORIES',
//        ),
//      ],
//      // setup the controller
//      controller: controller,
//    );
//  }

  Container getTabBar() {
    return Container(
        child: Material(
      color: Theme.of(context).bottomAppBarColor,
      child: new TabBar(
        //labelColor: Colors.black,
        //indicatorColor: Colors.black,
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
    final Future<List<Bus>> buses = fetchBuses();
    return Scaffold(
        appBar: AppBar(
          //leading: new Icon(Icons.android),
          titleSpacing: 0.0,
          //automaticallyImplyLeading: false, // Don't show the leading button
          title: getTabBar(),
          backgroundColor: Color(0xFFe7e2dd),
          //bottom: getTabBar(),
        ),
        //bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
        body: getTabBarView(<Widget>[
          BusRoutePage(buses: buses, region: 'Hong Kong Island'),
          BusRoutePage(buses: buses, region: 'Kowloon'),
          BusRoutePage(buses: buses, region: 'New Territories'),
        ]));
  }
}
