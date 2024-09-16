import 'package:flutter/cupertino.dart';
import '../../../common_widget.dart';
import '../../../services/api_service.dart';
import '../../../theme/theme_helper.dart';


class SettingProvider extends ChangeNotifier{
  final apiService = ApiService();


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoding(val){
    _isLoading = val;
    notifyListeners();
  }

  bool _isNotification = false;
  bool get isNotification => _isNotification;

  bool _isTheme = true;
  bool get isTheme => _isTheme;

  void toggleSwitch(){
    _isNotification = !_isNotification;
    notifyListeners();
  }

  void toggleSwitch1(){
    _isTheme = !_isTheme;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future setNotification(context, notification) async{
    try{
      final response = await apiService.setNotificationStatus(notification);
      if (response != null && response['status'] == 'success') {
        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future getSettings(context) async{
    try{
      final response = await apiService.getSettingsData();
      if (response != null && response['status'] == 'success') {
        var result = (response['data']['notification'] == 1)?true:false;
        _isNotification = result;
        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}