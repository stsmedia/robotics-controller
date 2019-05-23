import 'package:flutter/foundation.dart';
import 'package:thingbricks/services/bluetooth_service.dart';

class SmarsService with ChangeNotifier {
  double _right = 0.0;
  double _left = 0.0;
  BluetoothService _bt;

  SmarsService(this._bt);

  double get right => _right;

  double get left => _left;

  void direction(double left, double right) {
    _right = right;
    _left = left;
    notifyListeners();
    if (_bt != null) {
      _bt.send([255, left.toInt(), right.toInt()]);
    }
  }
}
