import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashProvider extends ChangeNotifier {
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
  void dispose() {
    super.dispose();
  }
}
