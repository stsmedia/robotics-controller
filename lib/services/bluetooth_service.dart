import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Device {
  String name;
  String id;

  Device(this.name, this.id);
}

class BluetoothService with ChangeNotifier {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> _scanSubscription;
  StreamSubscription<BluetoothDeviceState> _deviceState;
  List<Device> _devices = [];
  List<BluetoothDevice> _intDevices = [];
  bool isScanning = false;
  bool _isConnected = false;
  BluetoothDevice _btDevice = null;
  BluetoothCharacteristic _characteristic = null;

  List<Device> get devices => List.unmodifiable(_devices);

  void startScan() {
    /// Start scanning
    _scanSubscription = _flutterBlue.scan().where((r) => r.device.name.isNotEmpty).listen((scanResult) {
      print('found ${scanResult.device.name}');
      _devices.add(Device(scanResult.device.name, scanResult.device.id.id));
      _intDevices.add(scanResult.device);
      notifyListeners();
    });
    isScanning = true;
  }

  void stopScan() {
    _scanSubscription.cancel();
    isScanning = false;
  }

  bool isConnected() {
    return _isConnected;
  }

  void connect(Device device) {
    print('connecting to ${device.name}');
    _btDevice = _intDevices.firstWhere((d) => d.id.id == device.id);
    _deviceState = _flutterBlue.connect(_btDevice).listen((s) {
      if (s == BluetoothDeviceState.connected) {
        _isConnected = true;
        _btDevice.discoverServices().then((services) {
          print('found ${services.length} services');
          final service =
              services.firstWhere((service) => service.uuid.toString() == '0000ffe0-0000-1000-8000-00805f9b34fb');
          if (service != null) {
            print('service: ${service.uuid}');
            service.characteristics.forEach((c) => print('characteristic: ${c.uuid}'));
            _characteristic = service.characteristics.first;
            print('BT connected');
            notifyListeners();
          }
        });
      }
    });
  }

  void disconnect() {
    _deviceState.cancel();
    _isConnected = false;
    notifyListeners();
    print('BT disconnected');
  }

  void send(List<int> data) {
    if (_isConnected && _btDevice != null && _characteristic != null) {
      print('sending ${data} to BT');
      _btDevice.writeCharacteristic(
        _characteristic,
        data,
        type: CharacteristicWriteType.withResponse,
      );
    }
  }
}
