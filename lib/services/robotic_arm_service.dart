import 'package:flutter/foundation.dart';

class RoboticArmService with ChangeNotifier {
  double _rotation = 0.0;
  double _lift = 0.0;
  double _yaw = 0.0;
  double _grip = 0.0;

  double get rotation => _rotation;

  set rotation(double value) {
    _rotation = value;
    notifyListeners();
  }

  double get lift => _lift;

  set lift(double value) {
    _lift = value;
    notifyListeners();
  }

  double get grip => _grip;

  set grip(double value) {
    _grip = value;
    notifyListeners();
  }

  double get yaw => _yaw;

  set yaw(double value) {
    _yaw = value;
    notifyListeners();
  }
}
