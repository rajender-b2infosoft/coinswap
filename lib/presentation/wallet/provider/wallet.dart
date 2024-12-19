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

  String _ethBalance = '0';
  String get ethBalance => _ethBalance;
  String _btcBalance = '0';
  String get btcBalance => _btcBalance;
  String _usdtBalance = '0';
  String get usdtBalance => _usdtBalance;
  String _usdtTronBalance = '0';
  String get usdtTronBalance => _usdtTronBalance;

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
        //function for convert user wallet amount
        // await userWalletConvertedBalance();
        _walletData = UserProfileResponse.fromJson(response);
        // CommonWidget.showToastView('Wallets data fetched successfully', appTheme.gray8989);
      }else {
        _errorMessage = "Failed to load data";
        CommonWidget.showToastView('Wallets data fetched successfully', appTheme.gray8989);
      }
    }catch (e) {
      _errorMessage = "An error occurred: $e";
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> userWalletConvertedBalance() async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    try{
      final response = await apiService.getUserBalance(userId);
      //check response
      if (response != null && response['status'] == 'success') {
        if(response['data'].length > 0){
          //get user all 3 wallets total to display on home page
          _ethBalance = response['data'][0]['eth'].toString();
          _btcBalance = response['data'][0]['btc'].toString();
          _usdtBalance = response['data'][0]['usdt'].toString();
          _usdtTronBalance = response['data'][0]['usdtTron'].toString();
        }
      }else {
        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      }
    }catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}