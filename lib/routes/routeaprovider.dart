import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteNameProvider extends ChangeNotifier {
  String _routeName = '';

  String get routeName => _routeName;

  set routeName(String value) {
    _routeName = value;
    notifyListeners();
  }
}