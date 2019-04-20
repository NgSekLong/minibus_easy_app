import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/route_detail.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/bus_route_detail_page.dart';
import 'package:minibus_easy/view/bus_route_reference_page.dart';


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
    controller = new TabController(length: 2, vsync: this);
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
//            labelColor: Colors.black,
//            indicatorColor: Colors.black,
            tabs: <Tab>[
              new Tab(
                text: 'ROUTE',
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
      // Add tabs as widgets
      children: tabs,
      // set the controller
      controller: controller,
    );
  }


  @override
  Widget build(BuildContext context) {

//    final String langauge = locale.currentLanguage.toString();
//    final routeDetail = fetchRouteDetail(widget.route_id, widget.route_num_counter);
    return Scaffold(
      appBar: PassengerLayout().getAppBar(context),

      body: Scaffold(
        appBar: AppBar(
          leading: Text(''),
          //leading: new Icon(Icons.android),
          titleSpacing: 0.0,
          //automaticallyImplyLeading: false, // Don't show the leading button
          title: getTabBar(),
          backgroundColor: Color(0xFFe7e2dd),
          //bottom: getTabBar(),
        ),
        body:
        getTabBarView(<Widget>[
          BusRouteDetailPage(route_id: widget.route_id ,route_num_counter: widget.route_num_counter,),
          BusRouteReferencePage(route_id: widget.route_id ),
        ])


      )
//      bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
      //body: Center(child: Text('Route ID: ' + route_id + routeDetail)),
    );
  }

}
