import 'package:flutter/material.dart';
import 'package:flutter_widget_builder/core/pubsub.dart';

class ThemeState extends Pub {
  ThemeMode _mode = ThemeMode.dark;

  ThemeMode get mode => get(_mode);
  bool get isDark => get(_mode == ThemeMode.dark);

  void toggleTheme() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
