import 'package:flutter/cupertino.dart';
import '../../../common_widget.dart';
import '../../../services/api_service.dart';
import '../../../theme/theme_helper.dart';

class SettingProvider extends ChangeNotifier {
  final apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoding(val) {
    _isLoading = val;
    notifyListeners();
  }

  bool _isNotification = false;
  bool get isNotification => _isNotification;

  bool _isTheme = true;
  bool get isTheme => _isTheme;

  bool _isMpin = false;
  bool get isMpin => _isMpin;

  String? _isPin = '';
  String? get isPin => _isPin;

  void toggleSwitch() {
    _isNotification = !_isNotification;
    notifyListeners();
  }

  void mpinToggle() {
    _isMpin = !_isMpin;
    notifyListeners();
  }

  void toggleSwitch1(val) {
    _isTheme = val;
    // _isTheme = !_isTheme;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future setSettingsData(context, status, type) async {
    try {
      final response = await apiService.setSettings(status, type);
      if (response != null && response['status'] == 'success') {
        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future getSettings(context) async {
    try {
      final response = await apiService.getSettingsData();
      if (response != null && response['status'] == 'success') {
        _isNotification =
            (response['data']['notification'] == 1) ? true : false;
        _isMpin = (response['data']['default_security'] == 0) ? false : true;
        _isPin = response['data']['mpin'];
        // _isNotification = result;
        // _isMpin = result;
        // CommonWidget.showToastView(response['message'], appTheme.gray8989);
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
