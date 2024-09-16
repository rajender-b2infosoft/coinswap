import 'package:flutter/services.dart';

class CoinbaseService {
  static const MethodChannel _channel = MethodChannel('coinbase_channel');

  Future<void> login() async {
    await _channel.invokeMethod('login');
  }

  Future<void> logout() async {
    await _channel.invokeMethod('logout');
  }

  Future<String?> getAddress() async {
    return await _channel.invokeMethod('getAddress');
  }
}
