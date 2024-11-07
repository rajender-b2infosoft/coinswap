// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// import '../core/app_export.dart';
// import '../presentation/home_screen_page/provider/home_screen_provider.dart';
//
// class WebSocketClient {
//   WebSocketChannel? _channel;
//   Timer? _pingTimer;
//   WebSocketChannel? get channel => _channel;
//   final _secureStorage = const FlutterSecureStorage();
//
//   void connectWebSocket(
//       String token, String userId, BuildContext context) async {
//     const int maxRetries = 3;
//     int attempt = 0;
//
//     while (attempt < maxRetries) {
//       try {
//         // Ensure any previous connection is closed
//         _channel?.sink.close();
//         // Adjust protocol based on server setup
//         _channel = WebSocketChannel.connect(
//           // Uri.parse('ws://kafimoto.in:8000?token=$token'),
//           Uri.parse('ws://192.168.1.16:8000?token=$token'),
//         );
//         print('Channel connected:::::::::::::::: $_channel');
//         // Send handshake message
//         _channel?.sink.add(jsonEncode({
//           'event': 'handshake',
//           'message': 'Client connected after login!',
//           'user_id': userId,
//         }));
//
//         // Set up a timer to send ping messages periodically
//         _pingTimer = Timer.periodic(Duration(seconds: 10), (timer) {
//           print('........................pong');
//           if (_channel != null) {
//             _channel?.sink.add(jsonEncode({'event': 'ping'}));
//           }
//         });
//
//         // Listen for incoming messages
//         _channel?.stream.listen(
//           (message) {
//             try {
//               // Decode JSON message
//               final decodedMessage = jsonDecode(message);
//               // Access fields safely
//               final event = decodedMessage['event'];
//               final result = decodedMessage['result'];
//               final responseMessage = decodedMessage['message'];
//
//               print('Received::::::::::::::::::::::: $message');
//               print('Event::::::::::::::::::::::: $event');
//               print('Result::::::::::::::::::::::: $result');
//               print('Result:::::1111:::::::::::::::::: ${result['status']}');
//               print('Message::::::::::::::::::::::: $responseMessage');
//
//               if (event == 'Wallet_created') {
//                 print('11111111111111111111111111111111');
//                 storeValue(result['address'], result['key']);
//                 Provider.of<HomeScreenProvider>(context, listen: false)
//                     .setUserStatus(result['status']);
//               } else if (event == 'status_changed') {
//                 print('22222222222222222222222');
//                 Provider.of<HomeScreenProvider>(context, listen: false)
//                     .setUserStatus(result['status']);
//                 print('3333333333');
//                 NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
//               }
//             } catch (e) {
//               print('Error decoding message: $e');
//             }
//           },
//           onError: (error) {
//             print('WebSocket Error::::::::::::::::::::::: $error');
//           },
//           onDone: () {
//             print(
//                 'WebSocket connection closed::::::::::::::::::::::::::::::::::::;');
//             _pingTimer?.cancel(); // Cancel the timer on connection close
//           },
//         );
//         // Exit loop if connection is successful
//         break;
//       } catch (e) {
//         print('WebSocket connection failed: $e');
//         attempt++;
//         if (attempt < maxRetries) {
//           print('Retrying in 5 seconds...');
//           await Future.delayed(Duration(seconds: 5));
//         } else {
//           print('Max retries reached. Could not connect to WebSocket.');
//         }
//       }
//     }
//   }
//
//   Future<void> storeValue(address, key) async {
//     print('$address+++++++++++++++++++++++++++++++++++++++++++++++$key');
//     await _secureStorage.write(key: 'address', value: address);
//     await _secureStorage.write(key: 'privateKey', value: key);
//   }
//
//   void dispose() {
//     _channel?.sink.close();
//     _pingTimer?.cancel();
//   }
// }
