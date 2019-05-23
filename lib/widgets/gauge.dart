import 'dart:math';

import 'package:flutter/material.dart';

class GaugeChart extends StatelessWidget {
  double progress = 0.0;
  double max = double.maxFinite;
  double min = 0;
  Size size = Size(200, 200);
  Text unit;
  Text above;
  Text below;
  VoidCallback onTab;
  static const def = Text('');

  GaugeChart(
      {this.progress, this.max, this.min, this.size, this.unit = def, this.above = def, this.below = def, this.onTab});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
//        padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () {
            onTab();
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CustomPaint(
                painter: CircularCanvas(
                  progress: progress,
                  maxValue: max,
                  minValue: min,
                  color: Theme.of(context).accentColor,
                  backgroundColor: Theme.of(context).accentColor.withOpacity(0.4),
                ),
                size: this.size,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  above,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        progress.round().toString(),
                        textScaleFactor: size.width / 50,
                      ),
                      unit
                    ],
                  ),
                  Container(
                    width: size.width / 2,
                    child: below,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularCanvas extends CustomPainter {
  final double progress;
  final double maxValue;
  final double minValue;
  final Color backgroundColor;
  final Color color;

  CircularCanvas({this.progress, this.maxValue = 100, this.minValue = 0, this.backgroundColor, this.color});

  double scale(unscaledNum, minAllowed, maxAllowed, min, max) {
    return (maxAllowed - minAllowed) * (unscaledNum - min) / (max - min) + minAllowed;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final start = 4 / 5 * pi;
    final end = 7 / 5 * pi;
    final scaled = scale(min(minValue, min(progress, maxValue)), 0, end, minValue, maxValue);
    final color = scale(min(minValue, min(progress, maxValue)), 1, 9, minValue, maxValue).round() * 100;
    var paint = Paint();
    paint
      ..color = backgroundColor
      ..strokeWidth = size.width / 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(Offset(0.0, 0.0) & Size(size.width, size.width), start, end, false, paint);

    paint..strokeWidth = size.width / 8;
    canvas.drawArc(
        Offset(0.0, 0.0) & Size(size.width, size.width), start, scaled, false, paint..color = Colors.orange[color]);
  }

  @override
  bool shouldRepaint(CircularCanvas oldDelegate) {
    return false; //oldDelegate.progress != progress;
  }
}
