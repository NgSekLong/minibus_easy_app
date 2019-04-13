
import 'package:flutter/material.dart';
import 'package:minibus_easy/view/bus_route_page.dart';
import 'package:minibus_easy/view/main_navigation.dart';
import 'package:minibus_easy/view/numpad_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainNavigation(),
    );
  }
}