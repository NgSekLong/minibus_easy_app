import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/locale/global_translations.dart';
import 'package:minibus_easy/model/route_detail.dart';
import 'package:minibus_easy/model/route_info_fetcher.dart';
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/bus_route_page.dart';

class BusRouteDetailPage extends StatefulWidget {
  final String route_id;
  final int route_num_counter;

  BusRouteDetailPage({Key key, @required this.route_id, this.route_num_counter})
      : super(key: key);

  @override
  _BusRouteDetailPageState createState() => new _BusRouteDetailPageState();
}

class _BusRouteDetailPageState extends State<BusRouteDetailPage> {
  Future<List<RouteDetail>> routeDetail;
  Future<List<Bus>> post;
  Timer timer;

  Map<int, String> _listTextMap = {};

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fetchRouteListDetailAgain());
  }

  void fetchRouteListDetailAgain(){
    setState(() {
      RouteInfoFetcher routeInfoFetcher = RouteInfoFetcher();
      routeDetail = routeInfoFetcher.fetchRouteDetail(widget.route_id, widget.route_num_counter);
    });
  }

  @override
  Widget build(BuildContext context) {

    RouteInfoFetcher routeInfoFetcher = RouteInfoFetcher();

    final String langauge = locale.currentLanguage.toString();
    routeDetail = routeInfoFetcher.fetchRouteDetail(widget.route_id, widget.route_num_counter);
    return Scaffold(
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

                    String demoText = '';
                    if(langauge == 'tc'){
                      demoText += "'${stop_name_tc}'";
                    } else {
                      demoText += "'${stop_name_en}'";
                    }
                    demoText += "\n";
                    if(routeDetail.arrival_times.length > 0){
                      routeDetail.arrival_times.forEach((arrivalTime) {
                        String arrivalTimeInString = new Duration(seconds: arrivalTime).toString().split(".")[0];
                        demoText += "${arrivalTimeInString} | ";
                      });
                    } else {
                      demoText += "Estimated time to here from 1: > ${totalDurationInString}";
                    }

                    _listTextMap[i] = demoText;

                    ListTile listTile = new ListTile(
                      title: Row(children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(i.toString()),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Text(_listTextMap[i]),
                        ),

                      ]),

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
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
