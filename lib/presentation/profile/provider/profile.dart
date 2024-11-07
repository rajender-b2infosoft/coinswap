import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget.dart';
import '../../../services/api_service.dart';
import '../../../theme/theme_helper.dart';
import '../models/profile.dart';


class ProfileProvider extends ChangeNotifier{
  final apiService = ApiService();

  ProfileProvider(){
    getUserInfo();
  }


  String _totalBalance = '0';
  String get totalBalance => _totalBalance;
  String _ethBalance = '0';
  String get ethBalance => _ethBalance;
  String _btcBalance = '0';
  String get btcBalance => _btcBalance;
  String _usdtBalance = '0';
  String get usdtBalance => _usdtBalance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserProfileResponse? _profileData;
  UserProfileResponse? get profileData => _profileData;

  String? _name = '';
  String? get name => _name;
  String? _email = '';
  String? get email => _email;
  String? _selfie = '';
  String? get selfie => _selfie;
  int? _user_id = 0;
  int? get user_id => _user_id;

  getUserInfo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('userName');
    _email = prefs.getString('email');
    _selfie = prefs.getString('profileImage');
    _user_id = prefs.getInt('user_id');
    notifyListeners();
  }


  Future<void> userProfileData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      final response = await apiService.getUserProfile();
      //check response
      if (response != null && response['status'] == 'success') {
        await userWalletConvertedBalance();
        _profileData = UserProfileResponse.fromJson(response);
        // CommonWidget.showToastView(response?['message'], appTheme.gray8989);
      }else {
        _errorMessage = "Failed to load data";
        CommonWidget.showToastView(response?['message'], appTheme.gray8989);
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
          _totalBalance = response['data'][0]['totalAmount'].toString();
          _ethBalance = response['data'][0]['eth'].toString();
          _btcBalance = response['data'][0]['btc'].toString();
          _usdtBalance = response['data'][0]['usdt'].toString();
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