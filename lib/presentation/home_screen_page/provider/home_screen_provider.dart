import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';
import '../../../services/cryptoWebSocketServices.dart';
import '../../../services/moralisApiService.dart';
import '../../../services/socketService.dart';
import '../models/home_screen_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  final apiService = ApiService();
  HomeScreenModel registerModel = HomeScreenModel();
  late SocketIOClient _webSocketClient;

  bool _isDisposed = false;

  String? _userStatus = '';
  String? get userStatus => _userStatus;

  setUserStatus(val)async{
    print('////////////////////////////////////////--');
    print(val);
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

  HomeScreenProvider() {
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