import 'package:flutter/material.dart';

import '../models/app_navigation_model.dart';

class AppNavigationProvider extends ChangeNotifier {
  AppNavigationModel appNavigationModel = AppNavigationModel();

  @override
  void dispose(){
    super.dispose();
  }
}