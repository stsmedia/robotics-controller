import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'package:thingbricks/services/bluetooth_service.dart';
import 'package:thingbricks/services/hover_service.dart';
import 'package:thingbricks/widgets/bluetooth_dialog.dart';
import 'package:thingbricks/widgets/gauge.dart';
import 'package:thingbricks/widgets/main_menu.dart';
import 'package:thingbricks/widgets/touchpad.dart';

class HoverControllerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bt = Provider.of<BluetoothService>(context);
    return ChangeNotifierProvider(
      builder: (context) => HoverService(bt),
      child: _Scaffold(),
    );
  }
}

class _Scaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hover Craft'),
        actions: <Widget>[
          BluetoothDialog(),
        ],
      ),
      drawer: MainMenu(),
      body: Flex(
        direction: isScreenWide ? Axis.horizontal : Axis.vertical,
        children: <Widget>[
          _HoverGauges(),
          _HoverSteering(),
          _LiftSlider(),
        ],
      ),
    );
  }
}

class _HoverSteering extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hoverService = Provider.of<HoverService>(context);
    return Expanded(
      child: TouchPad(
        gyroEnabled: false,
        gridStyle: GridStyle.FORWARD_ONLY,
        onChanged: (offset) {
          final thrust = ((255 - offset.dy) / 5) * 0.9;
          final left = offset.dx <= 0 ? thrust + (offset.dx / 2.5 * 0.3).abs() : thrust;
          final right = offset.dx > 0 ? thrust + (offset.dx / 2.5 * 0.3) : thrust;
          hoverService.direction(left, right);
        },
        onReset: () {
          print('reset called');
          hoverService.direction(45, 45);
        },
      ),
    );
  }
}

class _LiftSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).orientation == Orientation.landscape;
    final hoverService = Provider.of<HoverService>(context);
    return Container(
      height: isScreenWide ? double.infinity : 100,
      width: isScreenWide ? 100 : double.infinity,
      child: FlutterSlider(
        values: [hoverService.lift],
        min: 0.0,
        max: 100.0,
        axis: isScreenWide ? Axis.vertical : Axis.horizontal,
        rtl: isScreenWide ? true : false,
        onDragCompleted: (i, value, _) {
          hoverService.lift = value;
        },
      ),
    );
  }
}

class _HoverGauges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).orientation == Orientation.landscape;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double size = isScreenWide ? height / 4 : width / 4;
    final hoverService = Provider.of<HoverService>(context);
    return Container(
      height: isScreenWide ? height : width / 3,
      width: isScreenWide ? height / 3 : width,
      child: Flex(
        direction: isScreenWide ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GaugeChart(
            size: Size(size, size),
            progress: hoverService.right,
            max: 100,
            min: 0,
            unit: Text("%"),
            above: Text("Right"),
            onTab: () => hoverService.direction(0, 0),
          ),
          GaugeChart(
            size: Size(size, size),
            progress: hoverService.lift,
            max: 100,
            min: 0,
            unit: Text("%"),
            above: Text("Lift"),
            onTab: () {
              hoverService.lift = 0.0;
            },
          ),
          GaugeChart(
            size: Size(size, size),
            progress: hoverService.left,
            max: 100,
            min: 0,
            unit: Text("%"),
            above: Text("Left"),
            onTab: () => hoverService.direction(0, 0),
          ),
        ],
      ),
    );
  }
}
