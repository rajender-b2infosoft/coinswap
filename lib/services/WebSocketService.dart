import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  late IO.Socket _socket;
  bool _isConnected = false;

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  void connectSocket(String token, String userId, BuildContext context) {
    const String serverUrl = 'https://coinswap.co.in:8000';

    if (_isConnected) {
      print('Already connected');
      return;
    }

    _socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {
        'token': token,
        'user_id': userId
      },
      'reconnection': true,             // Enable automatic reconnection
      'reconnectionAttempts': 5,        // Number of reconnection attempts before giving up
      'reconnectionDelay': 2000,        // Initial delay before a reconnection attempt (milliseconds)
      'reconnectionDelayMax': 10000,    // Maximum delay between reconnection attempts (milliseconds)
      'timeout': 5000                   // Connection timeout (milliseconds)
    });

    // Setup event listeners
    _setupSocketListeners(context);
    _socket.connect();
  }

  void _setupSocketListeners(BuildContext context) {
    _socket.onConnect((_) {
      print('Connected to WebSocket server');
      _isConnected = true;
    });

    _socket.onDisconnect((_) {
      print('Disconnected from WebSocket server');
      _isConnected = false;
    });

    _socket.onError((error) {
      print('Error occurred: $error');
    });

    _socket.on('your_custom_event', (data) {
      print('Received custom event data: $data');
    });
  }

  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      _isConnected = false;
      print('Socket disconnected');
    }
  }

  bool get isConnected => _isConnected;
}
