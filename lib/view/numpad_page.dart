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

enum SlopeType {
  vertical,
  horizontal,
  stepup,
  stepdown,
}


class _KeypadContainer extends StatefulWidget {
  final Function(String a) notifyParent;

  const _KeypadContainer({Key key, this.notifyParent}) : super(key: key);

  @override
  _KeypadContainerState createState() => new _KeypadContainerState();
}

class _KeypadContainerState extends State<_KeypadContainer> {
  // Creation of keypad
  Map<String, GlobalKey> keys = Map();
  Map<String, Number> numberElements = Map();
  List<String> listOfKeys = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
    'C',
    '<'
  ];

  // Swipe key recognition variable
  List<Offset> _storedFingerLocation = <Offset>[];
  List<String> _storedNumber = <String>[];
  int _storedIndex = 0;

  // Painter pointes
  List<Offset> _drawingPoints = <Offset>[];

  addToKeyList(String numberElement, GlobalKey globalKey) {
    keys.putIfAbsent(numberElement, () => globalKey);
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
  _checkOverlappedKeypad(localPosition){
    String hitOnKey = null;
    keys.forEach((key, value) {
      RenderBox renderBox = value.currentContext.findRenderObject();

      bool fingerInNumpad = _checkIfFingerInNumpad(localPosition, renderBox);

      if (fingerInNumpad) {
        hitOnKey = key;
        return;
      }
    });
    return hitOnKey;
  }

  _onPanEnd(DragEndDetails details) {
    setState(() {


      _landOn = _storedNumber[_storedNumber.length -1];
      if(_confirmedNumber[_confirmedNumber.length-1] != _landOn){
        _confirmedNumber.add(_landOn);
      }

      // Display last debug

      String debugText = 'Confiemd Numbers : ' + _confirmedNumber.toString();

      widget.notifyParent(debugText);


      // Calculate bus route end

      _storedIndex = 0;
      _storedFingerLocation = [];
      _storedNumber = [];
      _confirmedNumber = [];

      //Reset painting
      _drawingPoints = [];
      _peaceful = true;
      _landOn = '';
    });
  }

  bool _peaceful = true;
  String _landOn = '';
  List<String> _confirmedNumber = [];



  double _calculateSlope(Offset a, Offset b){
    var divideSon = (b.dy - a.dy);
    var divideMom = (b.dx - a.dx);

    if(divideMom == 0){divideMom = 0.01;}
    if(divideSon == 0){divideSon = 0.01;}
    return divideSon / divideMom;
  }

  int _calculateSlopetype(slope){
    //double slope = _calculateSlope(a, b);
    if (slope > 2) { return 0; }
    else if (slope > 1) { return 1; }
    else if (slope > 0.5) { return 2; }
    else if (slope > 0) { return 3; }
    else if (slope > -0.5) { return 4; }
    else if (slope > -1) { return 5; }
    else if (slope > -2) { return 6; }
    return 7;
//
//    if(slope > 2 || slope > -2){
//      return SlopeType.vertical;
//    } else if (slope < 0.5 && slope > -0.5 ){
//      return SlopeType.horizontal;
//    } else if (slope > 0){
//      return SlopeType.stepup;
//    }
//    return SlopeType.stepdown;
  }
  bool _calculateIfHaveTurn(int a, int b){
    if(
        (b - a).abs() <= 2 ||
        (b+8 - a).abs() <= 2 ||
        (b - (a+8)).abs() <= 2
    ){
      return false;
    }
    return true;

  }
  int _dirThreshold = 1;
  bool _calculateIfDirectionChanged(Offset a, Offset b, Offset c){
    double x1 = (c.dx - b.dx);
    double x2 = (b.dx - a.dx);

    double y1 = (c.dy - b.dy);
    double y2 = (b.dy - a.dy);
    if(x1.sign != x2.sign && x1.abs() > _dirThreshold && x2.abs() > _dirThreshold){
      print('x over!');
      return true;
    }
    else if(y1.sign != y2.sign && y1.abs() > _dirThreshold && y2.abs() > _dirThreshold){
      print('y over!');
      return true;
    }
    return false;
  }

  _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      //////// Keypad /////////////////
      Offset localPosition = details.globalPosition;
      String debugText = "";
      String _position = "\n Coordinate: " +
          localPosition.dx.toString() + ", " + localPosition.dy.toString() ;
      print(_position);

      String hitOnKey = _checkOverlappedKeypad(localPosition);

      if(hitOnKey != null){
        debugText += '\n Clicked on ' + hitOnKey;

      }

      debugText += _position;
      
      //////////// Recognizing point ////////////////////
      _storedIndex++;
      _storedFingerLocation.add(localPosition);
      _storedNumber.add(hitOnKey);
      
      if(_storedIndex == 1){
        _confirmedNumber.add(hitOnKey);
      }
      int slopeRefPoint1 = _storedIndex-5;
      int slopeRefPoint2 = _storedIndex-10;

      int directionRefPoint1 = _storedIndex-3;
      int directionRefPoint2 = _storedIndex-6;
      if(_storedFingerLocation.length >= 10){

        double currentSlope = _calculateSlope(localPosition, _storedFingerLocation[slopeRefPoint1]);
        double previousSlope = _calculateSlope(_storedFingerLocation[slopeRefPoint1], _storedFingerLocation[slopeRefPoint2]);

        double slopeChangeDetector = currentSlope / previousSlope;
        int currentSlopeType = _calculateSlopetype(currentSlope);
        int previousSlopeType = _calculateSlopetype(previousSlope);

        // Rules for capture number
        // 1. direction change
        // 2. Slope change too much
        // 3. Stop for long time
        bool isCaptureNumber =
          _calculateIfDirectionChanged(localPosition, _storedFingerLocation[directionRefPoint1], _storedFingerLocation[directionRefPoint2]) ||
          _calculateIfHaveTurn(currentSlopeType, previousSlopeType);

        if(isCaptureNumber) {
          _peaceful = false;
          _landOn = _storedNumber[slopeRefPoint2];
          if(_confirmedNumber.length <= 0 || _confirmedNumber[_confirmedNumber.length-1] != _landOn){
            _confirmedNumber.add(_landOn);
          }
        }
        //peaceful = true;


        debugText += '\n Current Slope' + currentSlope.toString();
        debugText += '\n Previous Slope ' + previousSlope.toString();
        //debugText += '\n Slope change detector: ' + slopeChangeDetector.toString();

        debugText += '\n Slope type ' + currentSlopeType.toString() + ' | ' + previousSlopeType.toString();
        debugText += '\n Confiemd Numbers : ' + _confirmedNumber.toString();

      } else {
        debugText += '\n Getting data';

      }



//      _storedFingerLocation;
//
//      _storedNumber.add(hitOnKeys)
//      if(_storedIndex > 0){
//        peaceful = true;
//      }
      if(_peaceful){
        debugText += '\n Very peaceful';
      } else {
        debugText += '\n OMG what happened';
      }

      //////////// Painter /////////////////

      RenderBox object = context.findRenderObject();
      Offset _localPosition = object.globalToLocal(details.globalPosition);
      _drawingPoints = new List.from(_drawingPoints)..add(_localPosition);

      ///////// Debug text /////////////////
      widget.notifyParent(debugText);
    });
  }

  @override
  void didChangeDependencies() {
    // In this list of keys, all of the number MUST be used in the chain,
    // otherwise it will failed
    listOfKeys.forEach((numberElement) {
      GlobalKey newKey = new GlobalKey();
      keys.putIfAbsent(numberElement, () => newKey);
      // Number newNumber = new Number(numberElement, newKey, addToKeyList);
      Number newNumber = new Number(key: newKey, text: numberElement);
      numberElements.putIfAbsent(numberElement, () => newNumber);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: <Widget>[
          Container(
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
                            numberElements['1'],
                            numberElements['4'],
                            numberElements['7'],
                            numberElements['C'],
                          ],
                        ))),
                Flexible(
                    child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: <Widget>[
                            numberElements['2'],
                            numberElements['5'],
                            numberElements['8'],
                            numberElements['0'],
                          ],
                        ))),
                Flexible(
                    child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                          children: <Widget>[
                            numberElements['3'],
                            numberElements['6'],
                            numberElements['9'],
                            numberElements['<'],
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          new CustomPaint(
            painter: new Signature(points: _drawingPoints),
            size: Size.infinite,
          ),
        ],
      ),
    );
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
        child: Container(
          key: key1,
          decoration: new BoxDecoration(
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

class Number extends StatefulWidget {
  final String text;

  Number({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  _NumberState createState() => new _NumberState(text);
}

class _NumberState extends State<Number> {
  _NumberState(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    //addToKeyList(num, thiskey);
    return Flexible(
      child: Container(
        //: thiskey2,
        color: Colors.white,
        margin: EdgeInsets.all(8),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.yellowAccent[100].withOpacity(0.5)
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 5;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
