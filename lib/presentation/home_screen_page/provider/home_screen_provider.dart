import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget.dart';
import '../../../core/utils/navigation_service.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_service.dart';
import '../../../services/cryptoWebSocketServices.dart';
import '../../../services/moralisApiService.dart';
import '../../../services/socketService.dart';
import '../../../theme/theme_helper.dart';
import '../../profile/models/profile.dart';
import '../../transactions/models/transaction.dart';
import '../models/home_screen_model.dart';
import '../models/recentTransaction.dart';

class HomeScreenProvider extends ChangeNotifier {
  final apiService = ApiService();
  HomeScreenModel registerModel = HomeScreenModel();
  late SocketIOClient _webSocketClient;


  RecentTransactionModel? _recenTransactionData;
  RecentTransactionModel? get recenTransactionData => _recenTransactionData;

  UserProfileResponse? _walletData;
  UserProfileResponse? get walletData => _walletData;

  final _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
    _fetchPrices();
    _startPeriodicUpdates();

    sharedPrefData();
    _webSocketService.subscribeToSymbols(['BTC-USD', 'ETH-USD', 'USDT-USD']);
    _webSocketService.stream.listen((data) {

      if (data['type'] == 'ticker') {
        final symbol = data['product_id'];
        final price = double.tryParse(data['price'] ?? '') ?? 0.0;
        final percentageChange = data['percentage_change'] ?? '0.00';
        final color = data['color'] ?? 'red'; // Default color is red
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
    });
  }


  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  Map<String, double> get prices => _prices;
  Map<String, String> get colors => _colors;

  double getPrice(String symbol) => _prices[symbol] ?? 0.0;
  String getColor(String symbol) => _colors[symbol] ?? 'red';
  String getPercentage(String symbol) => _percentages[symbol] ?? '0.00';

  ///////////////////Code for Moralis ////////////////////////////////////
  final MoralisApiService _apiService = MoralisApiService();
  double _ethPrice = 0.0;
  double _btcPrice = 0.0;
  double _usdtPrice = 0.0;
  String? _ethPercentChange = '0.0';
  String? _btcPercentChange = '0.0';
  String? _usdtPercentChange = '0.0';
  Timer? _timer;

  double get ethPrice => _ethPrice;
  double get usdtPrice => _usdtPrice;
  double get btcPrice => _btcPrice;

  String? get ethPercentChange => _ethPercentChange;
  String? get usdtPercentChange => _usdtPercentChange;
  String? get btcPercentChange => _btcPercentChange;

  Future<void> _fetchPrices() async {
    await Future.wait([
      _fetchEthPrice(),
      _getUsdtPrice(),
      _fetchBtcPrice(),
    ]);
  }

  void _startPeriodicUpdates() {
    _timer = Timer.periodic(const Duration(seconds: 50), (timer) async {
      // await _fetchPrices();      // when need to display live data uncomment it
    });
  }

  Future<void> _fetchEthPrice() async {
    try{
      final tokenData = await _apiService.getTokenPrice("0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2");
      _ethPrice = tokenData['usdPrice']?.toDouble() ?? 0.0;
      _ethPercentChange = tokenData['24hrPercentChange']??'0.0';
      // notifyListeners();
      _notifyIfNotDisposed();
    }catch(e){
      _ethPrice = 0.0;
      // notifyListeners();
      _notifyIfNotDisposed();
    }
  }

  Future<void> _getUsdtPrice() async {
    try{
      final tokenData =  await _apiService.getTokenPrice('0xdac17f958d2ee523a2206206994597c13d831ec7');
      _usdtPrice = tokenData['usdPrice']?.toDouble() ?? 0.0;
      _usdtPercentChange = tokenData['24hrPercentChange']??'0.0';
      // notifyListeners();
      _notifyIfNotDisposed();
    }catch(e){
      _usdtPrice = 0.0;
      // notifyListeners();
      _notifyIfNotDisposed();
    }
  }

  Future<void> _fetchBtcPrice() async {
    try{
      final btcData = await _apiService.getBtcPrice();
      _btcPrice = btcData['bitcoin']['usd']?.toDouble() ?? 0.0;
      // notifyListeners();
      _notifyIfNotDisposed();
    }catch(e){
      _btcPrice = 0.0;
      // notifyListeners();
      _notifyIfNotDisposed();
    }
  }

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

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _streamController.close();
    _webSocketService.close();
    super.dispose();
  }

}