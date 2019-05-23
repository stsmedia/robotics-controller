import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingbricks/services/robotic_arm_service.dart';
import 'package:thingbricks/widgets/bluetooth_dialog.dart';
import 'package:thingbricks/widgets/main_menu.dart';

class RoboticArmControllerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).orientation == Orientation.landscape;
    return ChangeNotifierProvider(
      builder: (context) => RoboticArmService(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Robotic Arm'),
            actions: <Widget>[
              BluetoothDialog(),
            ],
          ),
          drawer: MainMenu(),
          body: Flex(
            direction: isScreenWide ? Axis.horizontal : Axis.vertical,
            children: <Widget>[
              _ArmControl(),
            ],
          )),
    );
  }
}

class _ArmControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final roboticArmService = Provider.of<RoboticArmService>(context);
    return Container();
  }
}
