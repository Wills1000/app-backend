import 'package:flutter/material.dart';

class NavController extends ChangeNotifier {
  bool _visible = true;

  bool get visible => _visible;

  void hide() {
    if (!_visible) return;
    _visible = false;
    notifyListeners();
  }

  void show() {
    if (_visible) return;
    _visible = true;
    notifyListeners();
  }
}