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

  Future forgotPassword(context, email, type) async {
    _isLoading = true;
    notifyListeners();
    try{
      final response = await apiService.forgot_password(email, type);
      if (response != null && response['status'] == 'success') {
        NavigatorService.pushNamed(AppRoutes.forgotpasswordotp, argument: {'email': email});
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

  Future verifyForgotPasswordOtp(context, email, otp, type) async{
    try{
      final response = await apiService.verifyForgotPassword(email, otp, type);
      if (response != null && response['status'] == 'success') {
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.forgotPasswordChange, argument: {'email': email});
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

  Future changePassword(context, email, type, newPassword, confirmPassword) async{
    try{
      final response = await apiService.changePassword(email, type, newPassword, confirmPassword);
      if (response != null && response['status'] == 'success') {
        PopupUtil().imgPopUp(context, 'Password Changed !', CustomTextStyles.main22, 'Your password has been changed successfully', ImageConstant.round_done);
        await Future.delayed(const Duration(seconds: 1));
        NavigatorService.pushNamed(AppRoutes.loginScreen);
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
