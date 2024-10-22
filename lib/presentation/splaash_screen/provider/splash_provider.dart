import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/splaash_screen/models/splash_model.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashProvider extends ChangeNotifier {
  SplashModel splashModelObj = SplashModel();

  Future<bool> initialize() async {
    bool permissionsGranted = await checkPermissions();

    if (permissionsGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  @override
  void dispose(){
    super.dispose();
  }
}