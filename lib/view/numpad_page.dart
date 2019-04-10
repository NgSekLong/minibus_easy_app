import "package:flutter/material.dart";
import 'package:minibus_easy/passenger_layout.dart';

class NumpadPage extends StatefulWidget {
  @override
  _NumpadPageState createState() => new _NumpadPageState();
}

class _NumpadPageState extends State<NumpadPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: PassengerLayout().getAppBar(),
      bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.green,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.yellow,
              child: Container(
                  child: Row(
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Number('1'),
                          Number('2'),
                          Number('3'),
                          Number('4'),
                          Number('5'),
                          Number('6'),
                          Number('7'),
                          Number('8'),
                          Number('9'),
                          Number('0'),
                        ],
                      )),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Number('1'),
                          Number('2'),
                          Number('3'),
                          Number('4'),
                          Number('5'),
                          Number('6'),
                          Number('7'),
                          Number('8'),
                          Number('9'),
                          Number('0'),
                        ],
                      )),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumpadPageState_old extends State<NumpadPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: PassengerLayout().getAppBar(),
      bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
      body: Container(
        child: FractionallySizedBox(
          heightFactor: 0.1,
          alignment: FractionalOffset.center,
          //padding: const EdgeInsets.all(2.0),
          child: Table(
            //border: TableBorder.all(width: 2.0, color: Colors.black),
            children: [
              TableRow(children: [
                TableCell(child: Key('1')),
                TableCell(child: Key('1')),
                TableCell(child: Key('1')),
              ]),
              TableRow(children: [
                TableCell(child: Key('2')),
                TableCell(child: Key('2')),
                TableCell(child: Key('2')),
              ]),
              TableRow(children: [
                TableCell(child: Key('3')),
                TableCell(child: Key('3')),
                TableCell(child: Key('3')),
              ]),
              TableRow(children: [
                TableCell(child: Key('4')),
                TableCell(child: Key('4')),
                TableCell(child: Key('4')),
              ]),
              TableRow(children: [
                TableCell(child: Key('5')),
                TableCell(child: Key('5')),
                TableCell(child: Key('5')),
              ]),
              TableRow(children: [
                TableCell(child: Key('6')),
                TableCell(child: Key('6')),
                TableCell(child: Key('6')),
              ]),
              TableRow(children: [
                TableCell(child: Key('7')),
                TableCell(child: Key('7')),
                TableCell(child: Key('7')),
              ]),
              TableRow(children: [
                TableCell(child: Key('8')),
                TableCell(child: Key('8')),
                TableCell(child: Key('8')),
              ]),
              TableRow(children: [
                TableCell(child: Key('9')),
                TableCell(child: Key('9')),
                TableCell(child: Key('9')),
              ]),
              TableRow(children: [
                TableCell(child: Key('0')),
                TableCell(child: Key('0')),
                TableCell(child: Key('0')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class Number extends StatelessWidget {
  const Number(this.num);

  final String num;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          //color: Color(0xFFecd98b),
          //height: 40,
          margin: EdgeInsets.only(left: 20, right: 20, top: 3, bottom: 3),
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
          decoration: new BoxDecoration(
              color: Color(0xFFecd98b),
              border: new Border.all(color: Colors.blueAccent),
              borderRadius: new BorderRadius.all(const Radius.circular(5))),

          child: GestureDetector(
            onTap: () {
              print("onTap called.");
            },
            child: FittedBox(
              child: Text(num),
            ),
          ),
        ),
      ),
    );
  }
}

class Key extends StatelessWidget {
  const Key(this.keys);

  final String keys;

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Color(0xFFecd98b),
      //height: 40,
      margin: EdgeInsets.only(left: 20, right: 50, top: 3, bottom: 3),
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: new BoxDecoration(
          color: Color(0xFFecd98b),
          border: new Border.all(color: Colors.blueAccent),
          borderRadius: new BorderRadius.all(const Radius.circular(5))),

      child:
//      FittedBox(
//        fit: BoxFit.contain,
//        child: Text(keys),
//      ),
          GestureDetector(
        onTap: () {
          print("onTap called.");
        },
        child: FittedBox(
          child: Text(keys),
        ),
      ),
    );
  }
}
