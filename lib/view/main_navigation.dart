import 'package:flutter/material.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/bookmark_page.dart';
import 'package:minibus_easy/view/bus_route_navigation.dart';
import 'package:minibus_easy/view/bus_route_page.dart';
import 'package:minibus_easy/view/map_page.dart';
import 'package:minibus_easy/view/numpad_page.dart';
import 'package:minibus_easy/view/test_page.dart';

void main() {
  runApp(new MaterialApp(
      // Title
      title: "Using Tabs",

      // Home
      home: new MainNavigation()));
}

class MainNavigation extends StatefulWidget {
  @override
  MainNavigationState createState() => new MainNavigationState();
}

// SingleTickerProviderStateMixin is used for animation
class MainNavigationState extends State<MainNavigation>
    with SingleTickerProviderStateMixin {
  // Create a tab controller
  TabController controller;

  @override
  void initState() {
    super.initState();

    // Initialize the Tab Controller
    controller = new TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // Appbar
      appBar: PassengerLayout().getAppBar(),
      // Set the TabBar view as the body of the Scaffold
      body: TabBarView(
        // Add tabs as widgets
        children: <Widget>[
          NumpadPage(),
          MapPage(),
          BusRouteNavigation(),
          BookmarkPage(),
          TestPage()
        ],
        // set the controller
        controller: controller,
      ),
      // Set the bottom navigation bar
      bottomNavigationBar: Material(
        // set the color of the bottom navigation bar
        color: Color(0xFFecd98b),
        // set the tab bar as the child of bottom navigation bar
        child: TabBar(
          tabs: <Tab>[
            Tab(
              icon: Icon(Icons.confirmation_number),
              text: 'Numpad',
            ),
            Tab(
              // set icon to the tab
              icon: Icon(Icons.location_on),
              text: 'Map',
            ),
            Tab(
              icon: Icon(Icons.line_weight),
              text: 'Route List',
            ),
            Tab(
              icon: Icon(Icons.bookmark_border),
              text: 'Bookmark',
            ),
            Tab(
              icon: Icon(Icons.new_releases),
              text: 'Testing',
            ),
          ],
          // setup the controller
          controller: controller,
        ),
      ),
    );
  }
}
