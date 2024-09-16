import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CryptoWebSocketService {
  final WebSocketChannel _channel;
  final String apiKey;
  final String apiSecret;
  final String passphrase;

  final Map<String, double> _lastPrices = {};
  final Map<String, Map<String, dynamic>> _lastData = {};
  final Map<String, double> _lastPercentageChanges = {};
  final Map<String, String> _lastColors = {};

  CryptoWebSocketService({
    required this.apiKey,
    required this.apiSecret,
    required this.passphrase,
  }) : _channel = WebSocketChannel.connect(
    // Uri.parse('wss://ws-feed.pro.coinbase.com'), // Use public endpoint
    Uri.parse('wss://ws-feed.exchange.coinbase.com'), // Use public endpoint
  ) {
    _authenticate();
  }

  void _authenticate() {
    final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();
    final body = '';
    final message = '$timestamp\n$body\n$apiSecret';
    final signature = Hmac(sha256, utf8.encode(apiSecret))
        .convert(utf8.encode(message))
        .toString();

    final authMessage = {
      'type': 'subscribe',
      'channels': [
        {'name': 'ticker', 'product_ids': ['BTC-USD', 'ETH-USD', 'USDT-USD']},
      ],
      'api_key': apiKey,
      'passphrase': passphrase,
      'signature': signature,
      'timestamp': timestamp,
    };
    _channel.sink.add(jsonEncode(authMessage));
  }

  Stream<Map<String, dynamic>> get stream {
    return _channel.stream.map((data) {
      final decodedData = jsonDecode(data) as Map<String, dynamic>;

      final productId = decodedData['product_id'].toString();
      final price = double.tryParse(decodedData['price'].toString() ?? '');

      double percentageChange = 0.0;
      if (decodedData['percentage_change'] != null) {
        percentageChange = double.tryParse(decodedData['percentage_change'] as String) ?? 0.0;
      }

      if (price != null) {
        if (_lastPrices.containsKey(productId)) {
          final oldPrice = _lastPrices[productId]!;
          final newPercentageChange  = ((price - oldPrice) / oldPrice) * 100;

          final previousPercentageChange = _lastPercentageChanges[productId] ?? 0.0;
          final color = newPercentageChange > previousPercentageChange ? 'green' : 'red';

          decodedData['percentage_change'] = newPercentageChange.toStringAsFixed(2);
          decodedData['color'] = color;
        }

        _lastPrices[productId] = price;
        _lastPercentageChanges[productId] = percentageChange ?? 0.0;
      }

      return decodedData;
    });
  }

  // Map<String, dynamic> getLastDataForSymbol(String symbol) => _lastData[symbol] ?? {};

  void subscribeToSymbols(List<String> symbols) {
    final message = {
      'type': 'subscribe',
      'channels': [
        {
          'name': 'ticker',
          'product_ids': symbols,
        },
      ],
    };
    _channel.sink.add(jsonEncode(message));
  }

  void close() {
    _channel.sink.close();
  }
}
