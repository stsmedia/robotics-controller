import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sensors/sensors.dart';

enum GridStyle { NONE, ALL_DIRECTIONS, FORWARD_ONLY }

/**
 * Steteful widget
 */
class TouchPad extends StatefulWidget {
  final ValueChanged<Offset> onChanged;
  final Function onReset;
  final bool gyroEnabled;
  final GridStyle gridStyle;

  const TouchPad({Key key, this.gridStyle = GridStyle.NONE, this.onChanged, this.onReset, this.gyroEnabled = false})
      : super(key: key);

  @override
  _TouchPadState createState() => _TouchPadState();
}

/**
 * Draws a circle at supplied position.
 *
 */
class _TouchPadState extends State<TouchPad> {
  double xPos = 0.0;
  double yPos = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.gyroEnabled) {
      gyroscopeEvents.listen((GyroscopeEvent event) {
        final newX = xPos + event.y;
        final newY = yPos + event.x;

        setState(() {
          yPos = newY;
          xPos = newX;
        });
      });
    }
  }

  void _onReset() {
    setState(() {
      yPos = 0.0;
      xPos = 0.0;
    });
    widget.onReset();
  }

  void onChanged(Offset offset) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset position = referenceBox.globalToLocal(offset);

    double width = referenceBox.size.width;
    double height = referenceBox.size.height;

    double x = position.dx;
    double y = position.dy;

    if (x > width) {
      x = width;
    } else if (x < 0) {
      x = 0.0;
    }

    if (y > height) {
      y = height;
    } else if (y < 0) {
      y = 0.0;
    }

    // Update state.
    setState(() {
      xPos = x - (width / 2);
      yPos = y - (height / 2);
    });
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {}
  }

  void _handlePanStart(DragStartDetails details) {
    onChanged(details.globalPosition);
  }

  void _handlePanEnd(DragEndDetails details) {
    print('x: $xPos, y: $yPos');
    widget.onChanged(Offset(xPos, yPos));
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    onChanged(details.globalPosition);
  }

  @override
  Widget build(BuildContext context) {
    CustomPainter gridPainter;
    switch (widget.gridStyle) {
      case GridStyle.NONE:
        {
          gridPainter = NoGridPainter();
          break;
        }
      case GridStyle.ALL_DIRECTIONS:
        {
          gridPainter = AlldirectionsGridPainter();
          break;
        }
      case GridStyle.FORWARD_ONLY:
        {
          gridPainter = ForwardOnlyGridPainter();
          break;
        }
    }
    ;

    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _handlePanStart,
        onPanEnd: _handlePanEnd,
        onPanUpdate: _handlePanUpdate,
        onDoubleTap: _onReset,
        child: CustomPaint(
          painter: gridPainter,
          child: Center(
            child: CustomPaint(
              painter: TouchPadPainter(xPos, yPos),
            ),
          ),
        ),
      ),
    );
  }
}

/**
 * Painter.
 *
 */
class TouchPadPainter extends CustomPainter {
  static const markerRadius = 35.0;

  Offset position;

  TouchPadPainter(final double x, final double y) {
    this.position = Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange[400]
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(position.dx, position.dy), markerRadius, paint);
  }

  @override
  bool shouldRepaint(TouchPadPainter old) => position.dx != old.position.dx && position.dy != old.position.dy;
}

/**
 * Grid Painter.
 *
 */
class AlldirectionsGridPainter extends CustomPainter {
  Offset position;

  AlldirectionsGridPainter() {
    this.position = Offset(0.0, 0.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Offset centreLeft = size.centerLeft(position);
    Offset centreRight = size.centerRight(position);

    canvas.drawLine(centreLeft, centreRight, paint);

    Offset topCentre = size.topCenter(position);
    Offset bottomCentre = size.bottomCenter(position);

    canvas.drawLine(topCentre, bottomCentre, paint);
    canvas.drawCircle(size.center(position), size.height / 6, paint..color = Colors.green);
    canvas.drawCircle(size.center(position), size.height / 3, paint..color = Colors.orange);
    canvas.drawCircle(size.center(position), size.height / 2, paint..color = Colors.red);
  }

  @override
  bool shouldRepaint(AlldirectionsGridPainter old) => position.dx != old.position.dx && position.dy != old.position.dy;
}

class NoGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ForwardOnlyGridPainter extends CustomPainter {
  Offset position;

  ForwardOnlyGridPainter() {
    this.position = Offset(0.0, 0.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Offset topRight = size.topRight(position);
    Offset topLeft = size.topLeft(position);
    Offset bottom = size.bottomCenter(position);

    canvas.drawLine(bottom, topRight, paint);
    canvas.drawLine(bottom, topLeft, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
