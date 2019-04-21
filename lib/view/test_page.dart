import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/model/globals.dart';
import 'package:minibus_easy/view/bus_route_detail_navigation.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/driver_login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TestPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            padding: const EdgeInsets.all(10.0),
            child: const Text('Reset to Passenger app'),
            color: Colors.green,
            //elevation: 5.0,
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString(CURRENT_USER_ROLE_PREF, CURRENT_USER_ROLE_PREF_PASSENGER);
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(10.0),
            child: const Text('Simulate login to Driver'),
            color: Colors.blue,
            //elevation: 5.0,
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DriverLoginPage()));
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(10.0),
            child: const Text('Check the user role'),
            color: Colors.greenAccent,
            //elevation: 5.0,
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();

              final String role = prefs.getString(CURRENT_USER_ROLE_PREF);

              Scaffold.of(context).showSnackBar(new SnackBar(
                content: new Text(role),
              ));
            },
          ),
        ],
      )
    );
  }

}
