import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingbricks/services/bluetooth_service.dart';

class BluetoothDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bt = Provider.of<BluetoothService>(context);
    return IconButton(
        icon: Icon(
          Icons.bluetooth,
          color: bt.isConnected() ? Colors.blue : Colors.white,
        ),
        onPressed: () {
          if (bt.isConnected()) {
            bt.disconnect();
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(child: Text('Select BLE Device')),
                  content: Container(
                    height: 200,
                    width: 200,
                    child: Consumer<BluetoothService>(
                      builder: (context, bluetooth, child) {
                        if (!bluetooth.isScanning) bluetooth.startScan();
                        final devices = bluetooth.devices;
                        return devices.isEmpty
                            ? Center(child: Text('searching...'))
                            : ListView.separated(
                                itemBuilder: (context, i) {
                                  final device = devices[i];
                                  return ListTile(
                                    title: Text("${device.name} (${device.id.substring(0, 7)})"),
                                    onTap: () {
                                      if (!bluetooth.isConnected()) {
                                        bluetooth.connect(device);
                                        bluetooth.stopScan();
                                      }
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                separatorBuilder: (context, _) => Divider(),
                                itemCount: bluetooth.devices.length,
                              );
                      },
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}
