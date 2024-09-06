import 'package:flutter/material.dart';
import '../app_export.dart';

class NavigatorService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed(
    String routeName, {
    dynamic argument,
  }) async {
    return navigatorKey.currentState?.pushNamed(routeName, arguments: argument);
  }

  static void goBack() {
    return navigatorKey.currentState?.pop();
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
      String routeName, {
        bool routePredicate = false,
        dynamic argument,
      }) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => routePredicate, arguments: argument);
  }

  static Future<dynamic> popAndPushNamed(
    String routeName, {
    dynamic arguments,
  }) async {
    return navigatorKey.currentState
        ?.popAndPushNamed(routeName, arguments: arguments);
  }
}
