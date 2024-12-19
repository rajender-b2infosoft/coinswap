import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget.dart';
import '../../../services/api_service.dart';
import '../../../services/cryptoWebSocketServices.dart';
import '../../../services/socketService.dart';
import '../../../theme/theme_helper.dart';
import '../../profile/models/profile.dart';
import '../models/home_screen_model.dart';
import '../models/livePrice.dart';
import '../models/recentTransaction.dart';

class HomeScreenProvider extends ChangeNotifier {
  final apiService = ApiService();
  HomeScreenModel registerModel = HomeScreenModel();
  late SocketIOClient _webSocketClient;

  List<CryptoLivePriceModel> _cryptoList = [];
  List<CryptoLivePriceModel> get cryptoList => _cryptoList;

  DateTime? _lastUpdate;

  RecentTransactionModel? _recenTransactionData;
  RecentTransactionModel? get recenTransactionData => _recenTransactionData;

  UserProfileResponse? _walletData;
  UserProfileResponse? get walletData => _walletData;

  final _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _walletBalance = '0.0';
  String get walletBalance => _walletBalance;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _isClicked = 'Dashboard';
  String? get isClicked => _isClicked;
  setIsClicked(val){
    _isClicked = val;
    notifyListeners();
  }

  bool _isDisposed = false;

  String? _userStatus = '';
  String? get userStatus => _userStatus;

  changeStatus(val){
    _userStatus = val;
    print('UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU111UUUUUUUUUUUUUU_userStatusUUUU$_userStatus');
    notifyListeners();
  }

  setUserStatus(val)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('status', val);
    _userStatus = val;
    // notifyListeners();
    _notifyIfNotDisposed();
  }

  sharedPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? status = prefs.getString('status');
    _userStatus = status;
  }

  final CryptoWebSocketService _webSocketService = CryptoWebSocketService(
      apiKey: '892f03857a58a0e4e9d7ab9721ba0a80',
      apiSecret: 'dFj8fhnuuvtQKhKoErr2Hbo/cABByGV/YxnE4DltS8AzEDzbMmovTwSBJiQGav9NROvfcwwkth3yx05+RJv+5w==',
      passphrase: '7qzkaq49eqg'
  );

  final StreamController<Map<String, dynamic>> _streamController = StreamController.broadcast();

  Map<String, double> _prices = {};
  Map<String, String> _colors = {};
  Map<String, String> _percentages = {};


  String? _name = '';
  String? get name => _name;
  String? _email = '';
  String? get email => _email;
  String? _selfie = '';
  String? get selfie => _selfie;

  getUserInfo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('userName');
    _email = prefs.getString('email');
    _selfie = prefs.getString('profileImage');
  }

  HomeScreenProvider() {
    getUserInfo();
    // _fetchPrices();
    _startPeriodicUpdates();

    sharedPrefData();
    _webSocketService.subscribeToSymbols(['BTC-USD', 'ETH-USD', 'USDT-USD']);
    _webSocketService.stream.listen((data) {

      if (data['type'] == 'ticker') {

          final symbol = data['product_id'];
          final price = double.tryParse(data['price'] ?? '') ?? 0.0;
          final percentageChange = data['percentage_change'] ?? '0.00';
          final color = data['color'] ?? 'red'; // Default color is red

          final currentTime = DateTime.now();
          // Change interval from 24 hour
          if (_lastUpdate == null || currentTime.difference(_lastUpdate!).inMinutes >= 1) {
            _lastUpdate = currentTime;
            if (price != 0.0) {
              _prices[symbol] = price;
              _colors[symbol] = color;
              _percentages[symbol] = percentageChange;
              _streamController.add(data);
              // notifyListeners();
              _notifyIfNotDisposed();
            }
            // notifyListeners();
            _notifyIfNotDisposed();
          }

      }
    });
  }

  void _startPeriodicUpdates() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      // await _fetchPrices();      // when need to display live data uncomment it
    });
  }

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  Map<String, double> get prices => _prices;
  Map<String, String> get colors => _colors;

  double getPrice(String symbol) => _prices[symbol] ?? 0.0;
  String getColor(String symbol) => _colors[symbol] ?? 'red';
  String getPercentage(String symbol) => _percentages[symbol] ?? '0.00';
  Timer? _timer;

  Future<void> getUserWalets() async{
    _isLoading = true;
    notifyListeners();
    try{
      final response = await apiService.userWalletData();
      // Check if the response status is 'success'
      if (response?['status'] == 'success') {
        List<dynamic> walletData = response?['data'];
        for (var wallet in walletData) {
          String walletAddress = wallet['wallet_address'];
          String cryptoType = wallet['crypto_type'];
          // Store wallet address in secure storage based on the crypto type
          await _secureStorage.write(key: cryptoType, value: walletAddress);
        }
      } else {
        print("Error: ${response?['message']}");
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> userWalletData() async {
    _isLoading = true;
    notifyListeners();
    try{
      final response = await apiService.getUserProfile();
      //check response
      if (response != null && response['status'] == 'success') {

        SharedPreferences prefs = await SharedPreferences.getInstance();

        if(response['data'].length>0){
          //get user all 3 wallets total to display on home page
          _walletBalance = response['data'][0]['total_amount_sum'].toString();

          var status = response['data'][0]['status'];
          var userStatus = (status == 'active')?'Active':(status == 'under_review')?'Under Review':'Inactive';

          await prefs.setString('status', userStatus);

          //in home page set user wallet address in secure storage
          for (var wallet in response['data']) {
            String walletAddress = wallet['wallet_address'];
            String cryptoType = wallet['crypto_type'];
            // Store wallet address in secure storage based on the crypto type
            await _secureStorage.write(key: cryptoType, value: walletAddress);
          }
          notifyListeners();
        }
        // _walletBalance
        _walletData = UserProfileResponse.fromJson(response);



        // CommonWidget.showToastView('Wallets data fetched successfully', appTheme.gray8989);
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

  Future<void> userWalletConvertedBalance() async {
    _isLoading = true;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    try{
      final response = await apiService.getUserBalance(userId);
      //check response
      if (response != null && response['status'] == 'success') {
        //get user all 3 wallets total to display on home page
        _walletBalance = response['data'][0]['totalAmount'].toString();
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

  // Future<void> transactionsData(type, status, date) async {
  Future<void> recentTransactionsData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      final response = await apiService.getRecentTransactions();

      //check response
      if (response != null && response['status'] == 'success') {
        _recenTransactionData = RecentTransactionModel.fromJson(response);
        // CommonWidget.showToastView(response?['message'], appTheme.gray8989);
        notifyListeners();
      }else {
        _errorMessage = response?['message'];
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

  void _notifyIfNotDisposed() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> getCryptoLivePrice() async {
    _isLoading = true;
    notifyListeners();

    try{
      final response = await apiService.livePrice();

      if (response != null && response['status'] == 'success') {
        _cryptoList = (response['data'] as List)
            .map((crypto) => CryptoLivePriceModel.fromJson(crypto))
            .toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = 'Failed to fetch data. Status code: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
      }
    }catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _streamController.close();
    _webSocketService.close();
    super.dispose();
  }

}