import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BtcProvider with ChangeNotifier {
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

    final url =
        'https://api.coingecko.com/api/v3/simple/price?ids=$type&vs_currencies=usd&include_market_cap=true&include_24hr_vol=true&include_24hr_change=true&include_last_updated_at=true';
    const headers = {
      'accept': 'application/json',
      'x-cg-pro-api-key': 'CG-KqynxDQYcXJmSvq8MRe7xy7n',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        usdPrice = data[type]['usd'];
        marketCap = data[type]['usd_market_cap'];
        volume24h = data[type]['usd_24h_vol'];
        change24h = data[type]['usd_24h_change'];
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(data[type]['last_updated_at'] * 1000);
        lastUpdated = DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
      } else {
        _errorMessage = 'Failed to fetch data. Status code: ${response.statusCode}';
      }
    } catch (error) {
      _errorMessage = 'An error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
