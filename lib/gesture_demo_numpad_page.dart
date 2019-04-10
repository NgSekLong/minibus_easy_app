import "package:flutter/material.dart";

class Test extends StatefulWidget {
  @override
  _TestState createState() => new _TestState();
}

class _TestState extends State<Test> {


  GlobalKey _key = GlobalKey();
  String _position = "";


  _onDragStart(BuildContext context, DragStartDetails start) {
    print(start.globalPosition.toString());
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(start.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
  }

  _onDragUpdate( DragUpdateDetails update) {
    //print(update.globalPosition.toString());
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(update.globalPosition);
    setState(() {
      final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
      final positionRed = renderBoxRed.localToGlobal(Offset.zero);

      Offset localPosition = update.globalPosition - positionRed;

      _position = "update:\n" +localPosition.dx.toString() + "\n" + localPosition.dy.toString();

    });
//    print(local.dx.toString() + "|" + local.dy.toString());
//    print("update:" +update.globalPosition.dx.toString() + "|" + update.globalPosition.dy.toString());
  }


  GlobalKey _keyRed = GlobalKey();

  _getSizes() {
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    print("SIZE of Red: $sizeRed");
  }

  _getPositions(){

    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    print("POSITION of Red: $positionRed ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(8),
              child:

              GestureDetector(
                onPanUpdate: _onDragUpdate,
                child: Container(
                  key: _keyRed,
                  color: Colors.red,
                ),
              )

            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.purple,
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.green,
              child: Text('position: ' + _position),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  elevation: 5.0,
                  padding: EdgeInsets.all(15.0),
                  color: Colors.grey,
                  child: Text("Get Sizes"),
                  onPressed: _getSizes,
                ),
                MaterialButton(
                  elevation: 5.0,
                  color: Colors.grey,
                  padding: EdgeInsets.all(15.0),
                  child: Text("Get Positions"),
                  onPressed: _getPositions,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//import 'dart:async';
//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:minibus_easy/bus_route_detail_page.dart';
//import 'package:minibus_easy/model/bus.dart';
//import 'package:minibus_easy/passenger_layout.dart';
//
//
//
//
//class NumpadPage extends StatefulWidget {
//
//  NumpadPage({Key key}) : super(key: key);
//
//  @override
//  _NumpadState createState() => new _NumpadState();
//
////  @override
////  Widget build(BuildContext context) {
////    // TODO: implement build
////    return Scaffold(
////      appBar: PassengerLayout().getAppBar(),
////      bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
////      body: GestureDetector(
////        child: Container(
////          color: Colors.yellow,
////          child: Text('TURN LIGHTS ON'),
////        ),
////      )
////    );
////  }
//
//}
//
//class _NumpadState extends State<NumpadPage> {
//
//  bool _tapInProgress;
//  String _position;
//  _NumpadState() {
//    _tapInProgress = false;
//    _position = "";
//  }
//
//  void _tapDown(TapDownDetails details){
//    setState(() {
//      _tapInProgress = true;
//    });
//  }
//
//
//  void _tapUp(TapUpDetails details){
//    setState(() {
//      _tapInProgress = false;
//    });
//  }
//
//  void _padUpdate(BuildContext context, DragUpdateDetails details){
//    setState(() {
//
//
//      RenderBox getBox = context.findRenderObject();
//      Offset local = getBox.globalToLocal(details.globalPosition);
//      _position = local.dx.toString() + "\n|" + local.dy.toString();
//    });
//  }
//
//  void _tapCancel() {
//    setState(() {
//      _tapInProgress = false;
//    });
//  }
//
//  void _onTap() {
//    // TODO: Some code
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    Widget redSection = new GestureDetector(
//      onTapDown: _tapDown,
//      onTapUp: _tapUp,
//      onTap: _onTap,
//      onTapCancel: _tapCancel,
//      onPanUpdate: (DragUpdateDetails update) =>
//          _padUpdate(context, update),
//      child:
//      new Container(
//        color: _tapInProgress? Colors.redAccent : Colors.red,
//        child: new Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//            new Text("Launch Search"),
//            new Text("Drap position: " + _position),
//            new IconButton(
//              icon: new Icon(Icons.search),
//              onPressed: null,
//            ),
//            new Text(
//                "Tapping this text, the icon, or the title, will launch search"),
//          ],
//        ),
//      ),
//    );
//
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Gesture Detector Example"),
//      ),
//      body: new Padding(
//        padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
//        child: redSection,
//      ),
//    );
//  }
//}
