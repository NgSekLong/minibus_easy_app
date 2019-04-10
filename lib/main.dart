
import 'package:flutter/material.dart';
import 'package:minibus_easy/bus_route_page.dart';
import 'package:minibus_easy/gesture_demo_numpad_page.dart';
import 'package:minibus_easy/numpad_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NumpadPage(),
    );
  }
}