import 'package:crypto_app/core/app_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget.dart';
import '../../../core/utils/image_constant.dart';
import '../../../core/utils/popup_util.dart';
import '../../../services/api_service.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';


class MpinProvider extends ChangeNotifier{
  final apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoding(val){
    _isLoading = val;
    notifyListeners();
  }

  int _otpLength = 4;
  int get otpLength => _otpLength;

  int _reotpLength = 4;
  int get reotpLength => _reotpLength;

   late List<TextEditingController> _controllers;
   List<TextEditingController> get controllers => _controllers;

  late List<FocusNode> _focusNodes;
   List<FocusNode> get focusNodes => _focusNodes;

  late List<TextEditingController> _reenterControllers;
  List<TextEditingController> get reenterControllers => _reenterControllers;

  late List<FocusNode> _reenterFocusNodes;
  List<FocusNode> get reenterFocusNodes => _reenterFocusNodes;

  bool _isConfirmed = false;
  bool get isConfirmed => _isConfirmed;

  setIsConfirmed(val){
    _isConfirmed = val;
    notifyListeners();
  }

  bool _mpinToggle = false;
  bool get mpinToggle => _mpinToggle;

  String _mpin = '';
  String get mpin => _mpin;

  MpinProvider() {
    // Initialize controllers and focus nodes here
    _controllers = List.generate(_otpLength, (index) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());
    // Initialize controllers and focus nodes for Re-enter OTP
    _reenterControllers = List.generate(_reotpLength, (index) => TextEditingController());
    _reenterFocusNodes = List.generate(_reotpLength, (index) => FocusNode());
  }

  setMpinToggle(val){
    _mpinToggle = val;
    notifyListeners();
  }

  Future setMpin(context, pin) async{
    try{
      final response = await apiService.setMpinMobile(pin);
      if (response != null && response['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mpin', pin);
        PopupUtil().imgPopUp(context, 'Pin set successfully', CustomTextStyles.main18, 'Your Mpin has been set successfully. You can unlock the app using Mpin', ImageConstant.round_done);
        await Future.delayed(const Duration(seconds: 2));
        NavigatorService.pushNamed(AppRoutes.mpinScreen);
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

  Future getMpinData(context) async{
    try{
      final response = await apiService.getMpinData();
      if (response != null && response['status'] == 'success') {
        var result = (response['data'][0]['mpin_active'] == 1)?true:false;
        _mpinToggle = result;
        _mpin = response['data'][0]['mpin'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mpin', (response['data'][0]['mpin'].toString()==null)?'':response['data'][0]['mpin'].toString());
        await prefs.setString('mpin_active', response['data'][0]['mpin_active'].toString());
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


  Future setMpinStatus(context, status) async{
    try{
      final response = await apiService.setMpinStatus(status);
      if (response != null && response['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mpin_active', status.toString());
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

  // Handle keyboard tap
  void onKeyboardTap(String value) {
    if(!_isConfirmed){
      int focusedIndex = _focusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1 && focusedIndex < _otpLength) {
        _controllers[focusedIndex].text = value;
        if (focusedIndex + 1 < _otpLength) {
          _focusNodes[focusedIndex + 1].requestFocus();
        }
        notifyListeners();
      }
    }else{
      int focusedIndex = _reenterFocusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1 && focusedIndex < _reotpLength) {
        _reenterControllers[focusedIndex].text = value;
        if (focusedIndex + 1 < _reotpLength) {
          _reenterFocusNodes[focusedIndex + 1].requestFocus();
        }
        notifyListeners();
      }
    }
  }

  // Handle backspace press
  void onBackspacePressed() {
    if(!_isConfirmed){
      int focusedIndex = _focusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1) {
        _controllers[focusedIndex].clear();
        if (focusedIndex > 0) {
          _focusNodes[focusedIndex - 1].requestFocus();
        }
        notifyListeners();
      }
    }else{
      int focusedIndex = _reenterFocusNodes.indexWhere((node) => node.hasFocus);
      if (focusedIndex != -1) {
        _reenterControllers[focusedIndex].clear();
        if (focusedIndex > 0) {
          _reenterFocusNodes[focusedIndex - 1].requestFocus();
        }
        notifyListeners();
      }
    }
  }

  // Get the entered OTP value
  String getEnteredOtp() {
    return _controllers.map((c) => c.text).join('');
  }

  // // Set OTP value to auto-fill fields
  // void setOtp(String otp) {
  //   for (int i = 0; i < _otpLength && i < otp.length; i++) {
  //     _controllers[i].text = otp[i];
  //   }
  //   notifyListeners();
  // }

  // Get the re-entered OTP value
  String getReenteredOtp() {
    return _reenterControllers.map((c) => c.text).join('');
  }

  // Check if both OTPs match
  bool isOtpMatching() {
    return getEnteredOtp() == getReenteredOtp();
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _reenterFocusNodes) {
      node.dispose();
    }
    for (var controller in _reenterControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}