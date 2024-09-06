import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/splaash_screen/models/splash_model.dart';

class SplashProvider extends ChangeNotifier {
  SplashModel splashModelObj = SplashModel();

  @override
  void dispose(){
    super.dispose();
  }
}