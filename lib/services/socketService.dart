import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../core/app_export.dart';
import '../presentation/home_screen_page/provider/home_screen_provider.dart';
import 'api_service.dart';

class SocketIOClient {
  IO.Socket? _socket;
  final _secureStorage = const FlutterSecureStorage();
  final apiService = ApiService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late WebSocketChannel _channel;

  SocketIOClient(this.flutterLocalNotificationsPlugin);

  Future<void> initializeNotifications() async {
    // Initialize the WebSocket connection
    _channel = WebSocketChannel.connect(Uri.parse('ws://your_websocket_url'));

    // Listen for incoming messages
    _channel.stream.listen((message) {
      var data = json.decode(message);
      _showNotification(data['title'], data['body']);
    }, onError: (error) {
      // Handle error if necessary
      print('WebSocket error: $error');
    }, onDone: () {
      // Handle closure of the WebSocket connection
      print('WebSocket connection closed');
    });
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', // Channel ID
      'your_channel_name', // Channel name
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Connect to the Socket.IO server
  void connectSocket(String token, String userId, BuildContext context, HomeScreenProvider provider) {
    const String serverUrl = 'https://coinswap.co.in:8000';
    // Configure the Socket.IO client with reconnection options
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
    _setupSocketListeners(context, provider);
    // Connect the socket
    _socket!.connect();
  }

  // Setup socket event listeners
  void _setupSocketListeners(context, HomeScreenProvider provider) {
    _socket!.on('connect', (_) {
      print('Connected to Socket.IO server...................1111');
    });

    _socket!.on('disconnect', (_) {
      print('Disconnected from Socket.IO server.....................');
      _handleReconnection(); // Handle reconnection when disconnected
    });

    _socket!.on('connect_error', (error) {
      print('Connection error::::::::::::::::::::::::::::: $error');
    });

    _socket!.on('reconnect_attempt', (_) {
      print('Attempting to reconnect.............................');
    });

    _socket!.on('reconnect', (_) {
      print('Reconnected successfully...............................');
    });

    _socket!.on('reconnect_error', (error) {
      print('Reconnection error:::::::::::::::::::::::: $error');
    });

    _socket!.on('reconnect_failed', (_) {
      print('Reconnection failed..............');
    });

    _socket!.on('Wallet_created', (data) {
      print('status_changed::::::::::fffffff:::::::: ${data}');

      storeValue(data['result']['address'], data['result']['key']);

      var userStatus = (data['result']['status'] == 'active')?'Active':(data['result']['status'] == 'under_review')?'Under Review':'Inactive';
      Provider.of<HomeScreenProvider>(context, listen: false)
          .setUserStatus(userStatus);
      // Provider.of<HomeScreenProvider>(context, listen: false)
      //     .setUserStatus(data['result']['status']);
    });

    _socket!.on('status_changed', (data) async {
      print('status_changed:::::::::::::::::: ${data}');

      final status = data['result']['status'];

      print('status_changed:::::::::::::::::: ${data['result']['status']}');

      var userStatus = (status == 'under_review')?'Under Review':(status == 'inactive')?'Inactive':(status == 'active')?'Active':'Suspended';
      Provider.of<HomeScreenProvider>(context, listen: false).setUserStatus(userStatus);

      if(status == 'active'){
        Provider.of<HomeScreenProvider>(context, listen: false).getUserWalets();
      }
      // NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
    });

    _socket!.on('vaultody_webhook', (data) async {
      print('vaultody_webhook:::::::::::::::::: ${data}');

      _showNotification('', data['message'].toString());
    });
  }

  Future<void> storeValue(address, key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _secureStorage.write(key: 'address', value: address);
    await _secureStorage.write(key: 'privateKey', value: key);
    await prefs.setString('status', 'active');
  }

  // Check network connectivity
  Future<bool> _isNetworkAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Handle reconnection manually if needed
  void _handleReconnection() async {
    if (await _isNetworkAvailable()) {
      if (_socket != null && !_socket!.connected) {
        print('Attempting manual reconnection');
        _socket!.connect();
      }
    } else {
      print('No network available, will attempt reconnection later.');
      // Retry after some delay if network is not available
      Future.delayed(Duration(seconds: 5), _handleReconnection);
    }
  }

  // Disconnect from the Socket.IO server
  void disconnect() {
    _socket?.disconnect();
  }

  // Emit an event to the server
  void emitEvent(String eventName, dynamic data) {
    _socket?.emit(eventName, data);
  }

  // Cleanup socket connection
  void dispose() {
    _socket?.close();
  }
}