import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingbricks/services/bluetooth_service.dart';
import 'package:thingbricks/services/smars_service.dart';
import 'package:thingbricks/widgets/bluetooth_dialog.dart';
import 'package:thingbricks/widgets/gauge.dart';
import 'package:thingbricks/widgets/main_menu.dart';
import 'package:thingbricks/widgets/touchpad.dart';

class SmarsControllerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).orientation == Orientation.landscape;
    final bt = Provider.of<BluetoothService>(context);
    return ChangeNotifierProvider(
      builder: (context) => SmarsService(bt),
      child: Scaffold(
          appBar: AppBar(
            title: Text('SMARS'),
            actions: <Widget>[
              BluetoothDialog(),
            ],
          ),
          drawer: MainMenu(),
          body: Flex(
            direction: isScreenWide ? Axis.horizontal : Axis.vertical,
            children: <Widget>[
              _SmarsGauges(),
              _SmarsSteering(),
            ],
          )),
    );
  }
}

class _SmarsSteering extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final smarsService = Provider.of<SmarsService>(context);
    return Expanded(
      child: TouchPad(
        gyroEnabled: false,
        gridStyle: GridStyle.ALL_DIRECTIONS,
        onChanged: (offset) {
          print(offset);
          final thrust = offset.dy / 3 * -1;
          final left = offset.dx <= 0 ? thrust + (offset.dx / 2.5 * 0.3).abs() : thrust;
          final right = offset.dx > 0 ? thrust + (offset.dx / 2.5 * 0.3) : thrust;
          smarsService.direction(left, right);
        },
        onReset: () {
          print('reset called');
          smarsService.direction(0, 0);
        },
      ),
    );
  }
}

class _SmarsGauges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).orientation == Orientation.landscape;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double size = isScreenWide ? height / 3 : width / 3;
    final smarsService = Provider.of<SmarsService>(context);
    return Container(
      height: isScreenWide ? height : width / 2,
      width: isScreenWide ? height / 2 : width,
      child: Flex(
        direction: isScreenWide ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GaugeChart(
            size: Size(size, size),
            progress: smarsService.right,
            max: 100,
            unit: Text("%"),
            above: Text("Right"),
            onTab: () {
              smarsService.direction(0, 0);
            },
          ),
          GaugeChart(
            size: Size(size, size),
            progress: smarsService.left,
            max: 100,
            unit: Text("%"),
            above: Text("Left"),
            onTab: () {
              smarsService.direction(0, 0);
            },
          ),
        ],
      ),
    );
  }
}
