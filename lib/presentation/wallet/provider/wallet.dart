import 'package:crypto_app/core/app_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget.dart';
import '../../../core/utils/image_constant.dart';
import '../../../core/utils/popup_util.dart';
import '../../../services/api_service.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../profile/models/profile.dart';

class WalletScreenProvider extends ChangeNotifier{
  final apiService = ApiService();

  UserProfileResponse? _walletData;
  UserProfileResponse? get walletData => _walletData;

  bool _isLoading = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  setLoding(val){
    _isLoading = val;
    notifyListeners();
  }

  Future<void> userWalletData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      final response = await apiService.getUserProfile();
      //check response
      if (response != null && response['status'] == 'success') {
        _walletData = UserProfileResponse.fromJson(response);
        CommonWidget.showToastView('Wallets data fetched successfully', appTheme.gray8989);
      }else {
        _errorMessage = "Failed to load data";
      }
    }catch (e) {
      _errorMessage = "An error occurred: $e";
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}