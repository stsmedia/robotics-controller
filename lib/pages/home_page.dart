import 'package:flutter/material.dart';
import 'package:thingbricks/widgets/main_menu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text('ThingBricks'),
      ),
      drawer: MainMenu(),
      body: GridView.count(
        padding: EdgeInsets.all(10),
        crossAxisCount: isScreenWide ? 4 : 2,
        children: <Widget>[
          buildTab(context, 'SMARS', '/smars'),
          buildTab(context, 'Hover Craft', '/hover'),
          buildTab(context, 'Robotic Arm', '/robot'),
        ],
      ),
    );
  }

  InkWell buildTab(BuildContext context, String label, String nav) {
    return InkWell(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(label),
          ),
        ),
        onTap: () => Navigator.pushReplacementNamed(context, nav));
  }
}
