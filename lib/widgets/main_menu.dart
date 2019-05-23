import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text('stefan@thingbricks.com'),
            accountName: Text('Stefan'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('http://i.pravatar.cc/300'),
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () => {
                  Navigator.of(context).pop(),
                  Navigator.pushReplacementNamed(context, '/'),
                },
          ),
          ListTile(
            title: Text('SMARS Controller'),
            onTap: () => {
                  Navigator.of(context).pop(),
                  Navigator.pushReplacementNamed(context, '/smars'),
                },
          ),
          ListTile(
            title: Text('Hover Craft'),
            onTap: () => {
                  Navigator.of(context).pop(),
                  Navigator.pushReplacementNamed(context, '/hover'),
                },
          ),
          ListTile(
            title: Text('Robotic Arm'),
            onTap: () => {
                  Navigator.of(context).pop(),
                  Navigator.pushReplacementNamed(context, '/robot'),
                },
          ),
        ],
      ),
    );
  }
}
