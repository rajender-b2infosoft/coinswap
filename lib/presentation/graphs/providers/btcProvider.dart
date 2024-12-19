import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../services/api_service.dart';

class BtcProvider with ChangeNotifier {
  final apiService = ApiService();
  dynamic? usdPrice;
  dynamic? marketCap;
  dynamic? volume24h;
  dynamic? change24h;
  String? lastUpdated;

  List<FlSpot> _dataPoints = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<FlSpot> get dataPoints => _dataPoints;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  bool _isPageLoading = true;
  get isPageLoading => _isPageLoading;
  setIsPageLoading(val){
    _isPageLoading=val;
    notifyListeners();
  }

  Future<void> fetchPriceData(String type) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/$type/market_chart?vs_currency=usd&days=30&interval=daily&precision=5'),
        headers: {
          'accept': 'application/json',
          'x-cg-demo-api-key': 'CG-KqynxDQYcXJmSvq8MRe7xy7n',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _dataPoints = parsePriceData(data['prices']);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load data';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<FlSpot> parsePriceData(List<dynamic> prices) {
    return prices.asMap().entries.map((entry) {
      int index = entry.key;
      var price = entry.value;
      double x = index.toDouble(); // Index-based x-axis for sequential display
      double y = price[1].toDouble();
      return FlSpot(x, y);
    }).toList();
  }

  Future<void> fetchStatsData(String type) async {
    _isLoading = true;
    notifyListeners();
    try{
      final response = await apiService.livePrice();

      if (response != null && response['status'] == 'success') {

        final List<dynamic> data = response['data'];
        // Find the crypto object that matches the specified type
        final crypto = data.firstWhere(
              (item) => item['crypto_type'] == type,
          orElse: () => null,
        );

        if (crypto != null) {
          usdPrice = crypto['price'] ?? 0.0;
          marketCap = crypto['usd_market_cap'] ?? 0.0;
          volume24h = crypto['usd_24h_vol'] ?? 0.0;
          change24h = crypto['usd_24h_change'] ?? 0.0;
          // Convert the timestamp to DateTime
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            crypto['last_updated_at'] * 1000,
          );
          lastUpdated = DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
        } else {
          _errorMessage = 'No data found for the specified type: $type';
        }

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

}
