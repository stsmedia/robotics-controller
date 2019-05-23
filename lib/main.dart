import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingbricks/pages/home_page.dart';
import 'package:thingbricks/pages/hover_controller_page.dart';
import 'package:thingbricks/pages/robotic_arm_controller_page.dart';
import 'package:thingbricks/pages/smars_controller_page.dart';
import 'package:thingbricks/services/bluetooth_service.dart';

void main() => runApp(ThingBricksApp());

class ThingBricksApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => BluetoothService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ThingBricks Controller',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
//      showPerformanceOverlay: true,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/smars': (context) => SmarsControllerPage(),
          '/robot': (context) => RoboticArmControllerPage(),
          '/hover': (context) => HoverControllerPage(),
        },
      ),
    );
  }
}
