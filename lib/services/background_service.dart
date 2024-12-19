// import 'dart:ui';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// void startBackgroundService() {
//   FlutterBackgroundService().configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       onForeground: onStart,
//       autoStart: true,
//     ),
//   );
//   FlutterBackgroundService().startService();
// }
//
// void onStart(ServiceInstance service) async {
//   // Setup Local Notification
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//   // Create and Connect Socket
//   IO.Socket socket = IO.io(
//     'https://your-server-url',
//     IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .disableAutoConnect()
//         .build(),
//   );
//
//   socket.connect();
//
//   socket.onConnect((_) {
//     print('Socket Connected!');
//   });
//
//   socket.on('your_event', (data) {
//     print('Received background notification: $data');
//     showNotification(data['title'], data['message']);
//   });
// }
//
// // Function to show notification
// void showNotification(String title, String body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails(
//     'your_channel_id',
//     'your_channel_name',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//   const NotificationDetails platformChannelSpecifics =
//   NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     title,
//     body,
//     platformChannelSpecifics,
//   );
// }
