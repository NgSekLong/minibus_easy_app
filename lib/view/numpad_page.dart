import "package:flutter/material.dart";
import 'package:minibus_easy/passenger_layout.dart';

class NumpadPage extends StatefulWidget {
  @override
  _NumpadPageState createState() => new _NumpadPageState();
}

class _NumpadPageState extends State<NumpadPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //appBar: PassengerLayout().getAppBar(),
      //bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
                //color: Colors.green,
                ),
          ),
          Expanded(
            flex: 8,
            child: _KeypadContainer(),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class _KeypadContainer extends StatefulWidget {
  @override
  _KeypadContainerState createState() => new _KeypadContainerState();
}

class _KeypadContainerState extends State<_KeypadContainer> {
  GlobalKey _number1Key = GlobalKey();
  String _position = "";

  //Number _number1 = Number('1');
  _checkIfFingerInNumpad(Offset fingerOffset, Offset numpadOffset, Size numpadSize){
    Offset fingerRelativeOffset = fingerOffset - numpadOffset;
    if(numpadSize.width - fingerRelativeOffset.dx > 0 && numpadSize.height - fingerRelativeOffset.dy > 0){
      return true;
    }
    return false;
  }
  _onDragUpdate(DragUpdateDetails update) {

    setState(() {
      final RenderBox renderBoxRed =_number1Key.currentContext.findRenderObject();
      final sizeRed = renderBoxRed.size;
      final positionRed = renderBoxRed.localToGlobal(Offset.zero);

      print('num1 Size: ');
      print(sizeRed);
      print('num1 Position: ');
      print(positionRed);


      //Offset localPosition = update.globalPosition - positionRed;
      Offset localPosition = update.globalPosition;

      _checkIfFingerInNumpad(localPosition, positionRed, sizeRed);


      _position = "update:\n" +
          localPosition.dx.toString() +
          "\n" +
          localPosition.dy.toString();
      print(_position);
    });
//    print(local.dx.toString() + "|" + local.dy.toString());
//    print("update:" +update.globalPosition.dx.toString() + "|" + update.globalPosition.dy.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: _onDragUpdate,
        child: Container(
            color: Colors.yellow,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    NumberWithKey('1', _number1Key),
                    Number('2', null),
                    Number('3', null),
                    Number('4', null),
                    Number('5', null),
                    Number('6', null),
                    Number('7', null),
                    Number('8', null),
                    Number('9', null),
                    Number('0', null),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Number('1', null),
                    Number('2', null),
                    Number('3', null),
                    Number('4', null),
                    Number('5', null),
                    Number('6', null),
                    Number('7', null),
                    Number('8', null),
                    Number('9', null),
                    Number('0', null),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Number('1', null),
                    Number('2', null),
                    Number('3', null),
                    Number('4', null),
                    Number('5', null),
                    Number('6', null),
                    Number('7', null),
                    Number('8', null),
                    Number('9', null),
                    Number('0', null),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Number('1', null),
                    Number('2', null),
                    Number('3', null),
                    Number('4', null),
                    Number('5', null),
                    Number('6', null),
                    Number('7', null),
                    Number('8', null),
                    Number('9', null),
                    Number('0', null),
                  ],
                ),
              ],
            )));
  }
}

//
//class _NumpadPageState_old extends State<NumpadPage> {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return new Scaffold(
//      appBar: PassengerLayout().getAppBar(),
//      bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
//      body: Container(
//        child: FractionallySizedBox(
//          heightFactor: 0.1,
//          alignment: FractionalOffset.center,
//          //padding: const EdgeInsets.all(2.0),
//          child: Table(
//            //border: TableBorder.all(width: 2.0, color: Colors.black),
//            children: [
//              TableRow(children: [
//                TableCell(child: Numkey('1')),
//                TableCell(child: Numkey('1')),
//                TableCell(child: Numkey('1')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('2')),
//                TableCell(child: Numkey('2')),
//                TableCell(child: Numkey('2')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('3')),
//                TableCell(child: Numkey('3')),
//                TableCell(child: Numkey('3')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('4')),
//                TableCell(child: Numkey('4')),
//                TableCell(child: Numkey('4')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('5')),
//                TableCell(child: Numkey('5')),
//                TableCell(child: Numkey('5')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('6')),
//                TableCell(child: Numkey('6')),
//                TableCell(child: Numkey('6')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('7')),
//                TableCell(child: Numkey('7')),
//                TableCell(child: Numkey('7')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('8')),
//                TableCell(child: Numkey('8')),
//                TableCell(child: Numkey('8')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('9')),
//                TableCell(child: Numkey('9')),
//                TableCell(child: Numkey('9')),
//              ]),
//              TableRow(children: [
//                TableCell(child: Numkey('0')),
//                TableCell(child: Numkey('0')),
//                TableCell(child: Numkey('0')),
//              ]),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}

class NumberWithKey extends StatelessWidget {
  NumberWithKey(this.num, this.key1);

  final String num;

  GlobalKey key1 = new GlobalKey();
//
//  Offset getWidgetPosition() {
//    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
//    final position = renderBoxRed.localToGlobal(Offset.zero);
//    return position;
//  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          key: key1,
//          constraints: BoxConstraints(
//              maxWidth: 30,
//          ),
          //color: Color(0xFFecd98b),
          //height: 40,
          margin: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          decoration: new BoxDecoration(
              color: Color(0xFFecd98b),
              border: new Border.all(color: Colors.blueAccent),
              borderRadius: new BorderRadius.all(const Radius.circular(5))),

          child: FittedBox(
            child: Text(num),
          ),
        ),
      ),
    );
  }
}

class Number extends StatelessWidget {
  Number(this.num, this.key);

  final String num;

  GlobalKey key = new GlobalKey();

  Offset getWidgetPosition() {
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final position = renderBoxRed.localToGlobal(Offset.zero);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.fill,
        child: Container(
//          constraints: BoxConstraints(
//              maxWidth: 30,
//          ),
          //color: Color(0xFFecd98b),
          //height: 40,
          margin: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          decoration: new BoxDecoration(
              color: Color(0xFFecd98b),
              border: new Border.all(color: Colors.blueAccent),
              borderRadius: new BorderRadius.all(const Radius.circular(5))),

          child: FittedBox(
            child: Text(num),
          ),
        ),
      ),
    );
  }
}
//
//class Numkey extends StatelessWidget {
//  const Numkey(this.keys);
//
//  final String keys;
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      //color: Color(0xFFecd98b),
//      //height: 40,
//      margin: EdgeInsets.only(left: 20, right: 50, top: 3, bottom: 3),
//      padding: EdgeInsets.only(top: 5, bottom: 5),
//      decoration: new BoxDecoration(
//          color: Color(0xFFecd98b),
//          border: new Border.all(color: Colors.blueAccent),
//          borderRadius: new BorderRadius.all(const Radius.circular(5))),
//
//      child:
////      FittedBox(
////        fit: BoxFit.contain,
////        child: Text(keys),
////      ),
//          GestureDetector(
//        onTap: () {
//          print("onTap called.");
//        },
//        child: FittedBox(
//          child: Text(keys),
//        ),
//      ),
//    );
//  }
//}
