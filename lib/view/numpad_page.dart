import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:minibus_easy/model/bus.dart';
import 'package:minibus_easy/model/route_info_fetcher.dart';
import 'package:minibus_easy/passenger_layout.dart';
import 'package:minibus_easy/view/bus_route_page.dart';
import 'package:minibus_easy/view/component/numpad_gesture_painter.dart';

enum InputType { TAP, SWIPE, CLEAR, BACK }

class NumpadPage extends StatefulWidget {
  @override
  _NumpadPageState createState() => new _NumpadPageState();
}

class _NumpadPageState extends State<NumpadPage>
    with SingleTickerProviderStateMixin {
  String _debugText = '';
  List<String> _currentNumbers = [];

  inputAction(InputType inputType, [List<String> inputNumbers ]) {
    setState(() {
      switch (inputType) {
        case InputType.SWIPE:
          // When Swipe, replace all currentNumbers
          _currentNumbers = inputNumbers;
          break;
        case InputType.TAP:
          _currentNumbers.addAll(inputNumbers);
          break;
        case InputType.CLEAR:
          _currentNumbers.clear();
          break;
        case InputType.BACK:
          _currentNumbers.removeLast();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    RouteInfoFetcher routeInfoFetcher = RouteInfoFetcher();
    final Future<List<Bus>> buses = routeInfoFetcher.fetchBuses();
    return new Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              child: Column(
                children: <Widget>[
                  _DisplayNumber(
                    displayNumber: _currentNumbers,
                  ),
                  Expanded(
                    child: BusRoutePage(
                      buses: buses,
                      startsWith: _currentNumbers.join(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: _KeypadContainer(notifyParent: inputAction),
          ),
        ],
      ),
    );
  }
}

class _DisplayNumber extends StatefulWidget {
  final List<String> displayNumber;

  const _DisplayNumber({Key key, this.displayNumber}) : super(key: key);

  @override
  _DisplayNumberState createState() => new _DisplayNumberState();
}

class _DisplayNumberState extends State<_DisplayNumber> {
  @override
  Widget build(BuildContext context) {
    String displayText = this.widget.displayNumber.join();
    if(displayText.isEmpty){
      displayText = "Enter Route!";
    }
    return Container(
      color: Theme.of(context).accentColor,
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            displayText,
            style: new TextStyle(
              fontSize: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _KeypadContainer extends StatefulWidget {
  final Function(InputType inputType, [List<String> inputNumbers]) notifyParent;

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

  _checkOverlappedKeypad(localPosition) {
    String hitOnKey;
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
      _landOn = _storedNumber[_storedNumber.length - 1];

      bool _checkIfLastStoredNumberIsValid() {
        // No need check
        if(_confirmedNumber.length == 0){
          return true;
        }
        if(_confirmedNumber[_confirmedNumber.length - 1] != _landOn){
          return true;
        }
        return false;
      }
      if (_checkIfLastStoredNumberIsValid() &&
          _landOn != null &&
          _isDigit(_landOn, 0)) {
        _confirmedNumber.add(_landOn);
      }

      // Display last debug

      String debugText = _confirmedNumber.toString();

      widget.notifyParent(InputType.SWIPE, _confirmedNumber);

      // Calculate bus route end

      _storedIndex = 0;
      _storedFingerLocation = [];
      _storedNumber = [];
      _confirmedNumber = [];

      //Reset painting
      _drawingPoints = [];
      _landOn = '';
    });
  }

  String _landOn = '';
  List<String> _confirmedNumber = [];

  double _calculateSlope(Offset a, Offset b) {
    var divideSon = (b.dy - a.dy);
    var divideMom = (b.dx - a.dx);

    if (divideMom == 0) {
      divideMom = 0.01;
    }
    if (divideSon == 0) {
      divideSon = 0.01;
    }
    return divideSon / divideMom;
  }

  int _calculateSlopetype(slope) {
    //double slope = _calculateSlope(a, b);
    if (slope > 2) {
      return 0;
    } else if (slope > 1) {
      return 1;
    } else if (slope > 0.5) {
      return 2;
    } else if (slope > 0) {
      return 3;
    } else if (slope > -0.5) {
      return 4;
    } else if (slope > -1) {
      return 5;
    } else if (slope > -2) {
      return 6;
    }
    return 7;
  }

  bool _calculateIfHaveTurn(int a, int b) {
    if ((b - a).abs() <= 2 ||
        (b + 8 - a).abs() <= 2 ||
        (b - (a + 8)).abs() <= 2) {
      return false;
    }
    return true;
  }

  int _dirThreshold = 1;

  bool _calculateIfDirectionChanged(Offset a, Offset b, Offset c) {
    double x1 = (c.dx - b.dx);
    double x2 = (b.dx - a.dx);

    double y1 = (c.dy - b.dy);
    double y2 = (b.dy - a.dy);
    if (x1.sign != x2.sign &&
        x1.abs() > _dirThreshold &&
        x2.abs() > _dirThreshold) {
      return true;
    } else if (y1.sign != y2.sign &&
        y1.abs() > _dirThreshold &&
        y2.abs() > _dirThreshold) {
      return true;
    }
    return false;
  }
  bool _isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

  _onTapUp(TapUpDetails details) {
    Offset localPosition = details.globalPosition;

    String hitOnKey = _checkOverlappedKeypad(localPosition);
    switch(hitOnKey){
      case 'C':
        widget.notifyParent(InputType.CLEAR);
        break;
      case '<':
        widget.notifyParent(InputType.BACK);
        break;
      default:
        widget.notifyParent(InputType.TAP, [hitOnKey]);
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      // Keypad
      Offset localPosition = details.globalPosition;
      String debugText = "";
      String _position = "\nCoordinate: " +
          localPosition.dx.toStringAsFixed(1) +
          ", " +
          localPosition.dy.toStringAsFixed(1);
      print(_position);

      String hitOnKey = _checkOverlappedKeypad(localPosition);

      if (hitOnKey != null) {
        debugText += 'Click ' + hitOnKey;
      }

      debugText += _position;

      // Recognizing point
      _storedIndex++;
      _storedFingerLocation.add(localPosition);
      _storedNumber.add(hitOnKey);

      if (_storedIndex == 1 && _isDigit(hitOnKey, 0)) {
        _confirmedNumber.add(hitOnKey);
      }
      int slopeRefPoint1 = _storedIndex - 5;
      int slopeRefPoint2 = _storedIndex - 10;

      int directionRefPoint1 = _storedIndex - 3;
      int directionRefPoint2 = _storedIndex - 6;
      if (_storedFingerLocation.length >= 10) {
        double currentSlope = _calculateSlope(
            localPosition, _storedFingerLocation[slopeRefPoint1]);
        double previousSlope = _calculateSlope(
            _storedFingerLocation[slopeRefPoint1],
            _storedFingerLocation[slopeRefPoint2]);

        double slopeChangeDetector = currentSlope / previousSlope;
        int currentSlopeType = _calculateSlopetype(currentSlope);
        int previousSlopeType = _calculateSlopetype(previousSlope);

        // Rules for capture number
        // 1. direction change
        // 2. Slope change too much
        // 3. Stop for long time
        bool isCaptureNumber = _calculateIfDirectionChanged(
                localPosition,
                _storedFingerLocation[directionRefPoint1],
                _storedFingerLocation[directionRefPoint2]) ||
            _calculateIfHaveTurn(currentSlopeType, previousSlopeType);



        // Add number only when
        // 1. List is not empty
        // 2. the number is not in the last index of the list
        // 3. number is not null
        // 4. And number is digit
        if (isCaptureNumber) {
          _landOn = _storedNumber[slopeRefPoint2];
          if ((_confirmedNumber.length <= 0 ||
                  _confirmedNumber[_confirmedNumber.length - 1] != _landOn) &&
              _landOn != null &&
              _isDigit(_landOn,0)) {
            _confirmedNumber.add(_landOn);
          }
        }

        debugText += '\nSlope type ' +
            currentSlopeType.toString() +
            ' | ' +
            previousSlopeType.toString();
        debugText += '\nNumbers : ' + _confirmedNumber.toString();
      } else {
        debugText += '\nGetting data';
      }

      // Painter

      RenderBox object = context.findRenderObject();
      Offset _localPosition = object.globalToLocal(details.globalPosition);
      _drawingPoints = new List.from(_drawingPoints)..add(_localPosition);

      // Debug text
      widget.notifyParent(InputType.SWIPE, _confirmedNumber);
    });
  }

  @override
  void didChangeDependencies() {
    // In this list of keys, all of the number MUST be used in the chain,
    // otherwise it will failed
    listOfKeys.forEach((numberElement) {
      GlobalKey newKey = new GlobalKey();
      keys.putIfAbsent(numberElement, () => newKey);
      Number newNumber = new Number(key: newKey, text: numberElement);
      numberElements.putIfAbsent(numberElement, () => newNumber);
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 6,
          child: GestureDetector(
            onPanUpdate: _onPanUpdate,
            onTapUp: _onTapUp,
            onPanEnd: _onPanEnd,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisSize: MainAxisSize.max,

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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new CustomPaint(
                  painter: new NumpadGesturePainter(points: _drawingPoints),
                  size: Size.infinite,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
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
          flex: 2,
        ),
      ],
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
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          child: Container(
            decoration: new BoxDecoration(
                color: Colors.white,
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
    return Flexible(
      child: Container(
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
