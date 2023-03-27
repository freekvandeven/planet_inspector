import 'package:flutter/material.dart';

class PlanetController extends ChangeNotifier {
  bool horizontalRotating = true;
  void changePlanetRotation() {
    horizontalRotating = !horizontalRotating;
    notifyListeners();
  }
}
