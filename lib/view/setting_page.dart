import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minibus_easy/view/bus_route_detail_page.dart';
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/passenger_layout.dart';

import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List _cities = [
    "English",
    "中文",
  ];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentCity;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _cities) {
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child:
      Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body:  ListView(
          children: <Widget>[
            ListTile(
              title: Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text("Please choose your language: "),
                  new Container(
                    padding: new EdgeInsets.all(16.0),
                  ),
                  new DropdownButton(
                    value: _currentCity,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  ),
                ],
              ),

            ),
            Divider()
          ],

        ),
      )


//      new Center(
//          child: new Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              new Text("Please choose your city: "),
//              new Container(
//                padding: new EdgeInsets.all(16.0),
//              ),
//              new DropdownButton(
//                value: _currentCity,
//                items: _dropDownMenuItems,
//                onChanged: changedDropDownItem,
//              )
//            ],
//          )
//      ),
    );
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      _currentCity = selectedCity;
    });
  }
}

//class SettingsPage extends StatelessWidget {
//
//
//  @override
//  Widget build(BuildContext context) {
//
////    final List<Widget> divided = ListTile
////        .divideTiles(
////      context: context,
////      tiles: listOfRow,
////      color: Colors.blue,
////    ).toList();
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Settings'),
//      ),
//      body: ListView(
//        children: <Widget>[
//          ListTile(
//            title: Text('OK'),
//          ),
//        ],
//      ),
//    );
//  }
//
//}
