import 'package:crypto_app/core/app_export.dart';
import 'package:flutter/material.dart';
import '../../../common_widget.dart';
import '../../../core/utils/popup_util.dart';
import '../../../services/encryption_service.dart';
import '../../../theme/theme_helper.dart';
import '../../../services/api_service.dart';


class ForgotPasswordProvider with ChangeNotifier {
  final apiService = ApiService();
  final EncryptionService _encryptionService = EncryptionService();

  ForgotPasswordProvider() {
    _initializeEncryptionService();
  }


  String _password = '';
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialCharacter = false;
  bool _isLengthValid = false;
  bool _doPasswordsMatch = false;
  bool _isPasswordBeingTyped = false;

  String get password => _password;
  bool get hasUppercase => _hasUppercase;
  bool get hasNumber => _hasNumber;
  bool get hasSpecialCharacter => _hasSpecialCharacter;
  bool get isLengthValid => _isLengthValid;
  bool get doPasswordsMatch => _doPasswordsMatch;
  bool get isPasswordBeingTyped => _isPasswordBeingTyped;

  void updatePassword(String newPassword) {
    _password = newPassword;
    _isPasswordBeingTyped = newPassword.isNotEmpty;
    _hasUppercase = newPassword.contains(RegExp(r'[A-Z]'));
    _hasNumber = newPassword.contains(RegExp(r'[0-9]'));
    _hasSpecialCharacter = newPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    _isLengthValid = newPassword.length >= 8;
    _doPasswordsMatch = newController.text == confController.text ;
    notifyListeners();
  }

  bool _obscureTextNew = true;
  bool get obscureTextNew => _obscureTextNew;
  bool _obscureText = true;
  bool get obscureText => _obscureText;
  void setObscureText(type) {
    if(type == 'new'){
      _obscureTextNew = !_obscureTextNew;
    }else{
      _obscureText = !_obscureText;
    }
    notifyListeners();
  }

  Future<void> _initializeEncryptionService() async {
    try {
      await _encryptionService.initialize();
      notifyListeners();
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoding(val){
    _isLoading = val;
    notifyListeners();
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get newController => _newController;
  TextEditingController get confController => _confController;

  void updateEmail(String newEmail) {
    _emailController.text = newEmail;
    notifyListeners();
  }

  Future forgotPassword(context, email, type, page) async {
    _isLoading = true;
    notifyListeners();
    try{
      final response = await apiService.forgot_password(email, type);
      if (response != null && response['status'] == 'success') {
        NavigatorService.pushNamed(AppRoutes.forgotpasswordotp, argument: {'email': email, 'page': page});
        CommonWidget().snackBar(context, appTheme.green, response['message']);
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future verifyForgotPasswordOtp(context, email, otp, type, page) async{
    try{
      final response = await apiService.verifyForgotPassword(email, otp, type);
      if (response != null && response['status'] == 'success') {

        if(page.trim() != 'mpin'){
          NavigatorService.pushNamedAndRemoveUntil(AppRoutes.forgotPasswordChange, argument: {'email': email, 'page': page});
        }else if(page.trim() == 'mpin'){
          NavigatorService.pushNamedAndRemoveUntil(AppRoutes.generateMpin);
        }
        // else{
        //   print('++++++++++++++++else++++++++++++++++++');
        //   // NavigatorService.pushNamedAndRemoveUntil(AppRoutes.forgotPasswordChange, argument: {'email': email, 'page': page});
        // }
        CommonWidget().snackBar(context, appTheme.green, response['message']);
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

  Future changePassword(context, email, type, newPassword, confirmPassword, page) async{
    try{
      final response = await apiService.changePassword(email, type, newPassword, confirmPassword);
      if (response != null && response['status'] == 'success') {
        PopupUtil().forgorPopUp(context, 'Password Changed !', CustomTextStyles.main22, 'Your password has been changed successfully', ImageConstant.round_done, page);
        // await Future.delayed(const Duration(seconds: 1));
        // NavigatorService.pushNamed(AppRoutes.loginScreen);
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

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

}
