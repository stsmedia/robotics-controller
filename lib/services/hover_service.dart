import 'package:flutter/foundation.dart';
import 'package:thingbricks/services/bluetooth_service.dart';

class HoverService with ChangeNotifier {
  double _lift = 0.0;
  double _right = 0.0;
  double _left = 0.0;

  BluetoothService _bt;

  HoverService(this._bt);

  double get lift => _lift;

  set lift(double value) {
    _lift = value;
    notifyListeners();
    if (_bt != null) {
      _bt.send([255, _right.toInt(), _left.toInt(), _lift.toInt()]);
    }
  }

  double get right => _right;

  double get left => _left;

  void direction(double left, double right) {
    _right = right;
    _left = left;
    notifyListeners();
    if (_bt != null) {
      _bt.send([255, _right.toInt(), _left.toInt(), _lift.toInt()]);
    }
  }
}
