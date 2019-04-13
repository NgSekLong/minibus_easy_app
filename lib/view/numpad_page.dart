import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:minibus_easy/passenger_layout.dart';

class NumpadPage extends StatefulWidget {
  @override
  _NumpadPageState createState() => new _NumpadPageState();
}

class _NumpadPageState extends State<NumpadPage>
    with SingleTickerProviderStateMixin {
  String _debugText = '';

  refresh(String text) {
    setState(() {
      _debugText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //appBar: PassengerLayout().getAppBar(),
      //bottomNavigationBar: PassengerLayout().getBottomNavigationBar(),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              //color: Colors.green,
              child: Text(_debugText),
            ),
          ),
          Expanded(
            flex: 5,
            child: _KeypadContainer(notifyParent: refresh),
          ),
        ],
      ),
    );
  }
}

class _KeypadContainer extends StatefulWidget {
  //final ValueListenable<String> debugText;

  final Function(String a) notifyParent;

  const _KeypadContainer({Key key, this.notifyParent}) : super(key: key);

  @override
  _KeypadContainerState createState() => new _KeypadContainerState();
}

class _KeypadContainerState extends State<_KeypadContainer> {
  GlobalKey<State<StatefulWidget>> _number1Key = GlobalKey();
  Map<String, GlobalKey> keys = Map();
  List<String> listOfKeys = ['1','2','3','4','5','6','7','8','9','0','C','<'];

  addToKeyList(String numberElement, GlobalKey globalKey) {
    keys.putIfAbsent(numberElement, ()=> globalKey );
//    setState(() {
//    });
  }
  _checkIfFingerInNumpad(Offset fingerOffset, RenderBox renderBox) {
    Size numpadSize = renderBox.size;
    Offset numpadOffset = renderBox.localToGlobal(Offset.zero);

    double x = fingerOffset.dx;
    double y = fingerOffset.dy;
    if (numpadOffset.dx < x &&
        x < numpadSize.width + numpadOffset.dx &&
        numpadOffset.dy < y &&
        y < numpadSize.height + numpadOffset.dy) {
      return true;
    }
    return false;
  }


  _onDragUpdate(DragUpdateDetails update) {
    setState(() {

      //RenderBox renderBox;
      Offset localPosition = update.globalPosition;
      keys.forEach((key, value) {
          RenderBox renderBox = value.currentContext.findRenderObject();
//          Size size = renderBox.size;
//          Offset position = renderBox.localToGlobal(Offset.zero);

          bool fingerInNumpad = _checkIfFingerInNumpad(localPosition, renderBox);

          String _position = "update:\n" +
              localPosition.dx.toString() +
              "\n" +
              localPosition.dy.toString() +
              "\n";
          print(_position);

          String _debugText = _position ;
          widget.notifyParent(_debugText);
          if(fingerInNumpad){
            _debugText += '\n Clicked on ' + key;
          } else {
            _debugText += '\n Clicked on nothing' ;
          }
          widget.notifyParent(_debugText);
      });



//      final RenderBox renderBoxRed =
//          _number1Key.currentContext.findRenderObject();
//      final sizeRed = renderBoxRed.size;
//      final positionRed = renderBoxRed.localToGlobal(Offset.zero);
//
//      print('num1 Size: ');
//      print(sizeRed);
//      print('num1 Position: ');
//      print(positionRed);
//
//      _checkIfFingerInNumpad(localPosition, positionRed, sizeRed);
//
//      String _position = "update:\n" +
//          localPosition.dx.toString() +
//          "\n" +
//          localPosition.dy.toString() +
//          "\n";
//      print(_position);
//
//      String _check_figner =
//          _checkIfFingerInNumpad(localPosition, positionRed, sizeRed)
//              ? 'Is in box'
//              : 'Not in box';
//      String _debugText = _position + _check_figner;
//      widget.notifyParent(_debugText);
    });
  }

  @override
  Widget build(BuildContext context) {
    //keys
    //['2','3'].forEach((element) => keys.putIfAbsent(element, new GlobalKey()));
    listOfKeys.forEach((numberElement) => keys.putIfAbsent(numberElement, ()=> GlobalKey() ));
    //keys.putIfAbsent('58', ()=> GlobalKey() );

    return GestureDetector(
        onPanUpdate: _onDragUpdate,
        child: Container(
          color: Colors.grey[200],
          child: Row(
            mainAxisSize: MainAxisSize.max,

//              mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                  child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Number('1', keys['1'], addToKeyList),
                          Number('4', keys['4'], addToKeyList),
                          Number('7', keys['7'], addToKeyList),
                          Number('Cancel', keys['c'], addToKeyList),
                        ],
                      ))),
              Flexible(
                  child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Number('2', keys['2'], addToKeyList),
                          Number('5', keys['5'], addToKeyList),
                          Number('8', keys['8'], addToKeyList),
                          Number('0', keys['0'], addToKeyList),
                        ],
                      ))),
              Flexible(
                  child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        children: <Widget>[
                          Number('3', keys['3'], addToKeyList),
                          Number('6', keys['6'], addToKeyList),
                          Number('9', keys['9'], addToKeyList),
                          Number('<', keys['<'], addToKeyList),
                        ],
                      ))),
              Flexible(
                  child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Container(
                        color: Colors.grey[400],
                        child: ListView(
                          children: <Widget>[
                            SpecialNumber('A', null),
                            SpecialNumber('B', null),
                            SpecialNumber('C', null),
                            SpecialNumber('D', null),
                            SpecialNumber('E', null),
                            SpecialNumber('F', null),
                            SpecialNumber('G', null),
                            SpecialNumber('H', null),
                          ],
                        ),
                      ))),
            ],
          ),
        ));
  }
}

class NumberWithKey extends StatelessWidget {
  NumberWithKey(this.num, this.key1);

  final String num;

  GlobalKey key1 = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        //fit: BoxFit.fill,
        child: Container(
          key: key1,
//          constraints: BoxConstraints(
//              maxWidth: 30,
//          ),
          //color: Color(0xFFecd98b),
          //height: 40,
//          margin: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
//          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          decoration: new BoxDecoration(
              //color: Color(0xFFecd98b),
              //border: new Border.all(color: Colors.blueAccent),
              borderRadius: new BorderRadius.all(const Radius.circular(5))),

          child: FittedBox(
            child: Text(num),
          ),
        ),
      ),
    );
  }
}

class SpecialNumber extends StatelessWidget {
  SpecialNumber(this.num, this.key);

  final String num;

  GlobalKey key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          //fit: BoxFit.fill,
          child: Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                //border: new Border.all(color: Colors.blueAccent),
                borderRadius: new BorderRadius.all(const Radius.circular(2))),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: FittedBox(
              child: Text(num),
            ),
          ),
        ),
      ),
    );
  }
}

class Number extends StatelessWidget {


  final Function(String numberElement, GlobalKey globalKey) addToKeyList;

  Number(this.num, this.thiskey2, this.addToKeyList);

  final String num;
  GlobalKey thiskey2 = new GlobalKey();
  GlobalKey thiskey = new GlobalKey();

  //LocalKey a;


  @override
  Widget build(BuildContext context) {

    addToKeyList(num, thiskey);
    return Flexible(
        child: Container(
            key: thiskey2,
            color: Colors.white,
            margin: EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text(num),
                ),
              ),
            )));
    return SizedBox.expand(
      child: Text('1'),
    );
    return Expanded(
      child: FittedBox(
        fit: BoxFit.cover,
        child: Container(
//          constraints: BoxConstraints(
//              maxWidth: 30,
//          ),
          //color: Color(0xFFecd98b),
          //height: 40,
//          margin: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
//          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          decoration: new BoxDecoration(
              color: Color(0xFFecd98b),
              border: new Border.all(color: Colors.blueAccent),
              borderRadius: new BorderRadius.all(const Radius.circular(5))),

          child: FittedBox(
            fit: BoxFit.cover,
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