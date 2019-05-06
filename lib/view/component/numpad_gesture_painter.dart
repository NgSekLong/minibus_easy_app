
import 'package:flutter/material.dart';

class NumpadGesturePainter extends CustomPainter {
  List<Offset> points;

  NumpadGesturePainter({this.points});

  Rect rect = new Rect.fromCircle(
    center: new Offset(100.0, 100.0),
    radius: 180.0,
  );
  final Gradient gradient = new RadialGradient(
    colors: <Color>[
      Colors.yellow.withOpacity(0.3),
      Colors.yellow.withOpacity(0.3),
      Colors.green.withOpacity(0.3),
      Colors.green.withOpacity(0.3),
      Colors.blue.withOpacity(0.3),
    ],
    stops: [
      0.0,
      0.5,
      0.7,
      0.9,
      1.0,
    ],
  );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
    //..color = Colors.yellowAccent[100].withOpacity(0.5)
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 5;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);

      }
    }
  }

  @override
  bool shouldRepaint(NumpadGesturePainter oldDelegate) => oldDelegate.points != points;
}
