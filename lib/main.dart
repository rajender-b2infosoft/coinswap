import 'dart:convert';

import 'package:crypto_app/presentation/auth/provider/forgotPassword.dart';
import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
import 'package:crypto_app/presentation/graphs/providers/btcProvider.dart';
import 'package:crypto_app/presentation/mpin/provider/mpin.dart';
import 'package:crypto_app/presentation/profile/provider/profile.dart';
import 'package:crypto_app/presentation/transactions/provider/transaction.dart';
import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:crypto_app/routes/routeaprovider.dart';
import 'package:crypto_app/services/socketService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:crypto_app/core/app_export.dart';
import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High_Importance_Notifications',
    importance: Importance.high,
    playSound: true);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Notification...........7777");
  print("Notification...........8888 ${message.messageId}");

  // Display the notification in the background
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create the SocketIOClient and initialize WebSocket connection
  // final socketClient = SocketIOClient(flutterLocalNotificationsPlugin);
  // await socketClient.initializeNotifications();

}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp (
      options: FirebaseOptions (
        apiKey: 'AIzaSyBHwtnpipMZgQ3_kYZM0lubiDrqgGpVXww',
        appId: '1:705553588831:android:8983288f12e658ba44b1ea',
        messagingSenderId: '705553588831',
        projectId: 'crypto-b9a8f',
        storageBucket: 'crypto-b9a8f.firebasestorage.app',
      )
  );

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create the SocketIOClient and initialize WebSocket connection
  final socketClient = SocketIOClient(flutterLocalNotificationsPlugin);
  await socketClient.initializeNotifications();


  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init()
  ]).then((value) {

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // print("ChannelID"+channel.id);
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);


    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge:  true,
      sound: true,
    );

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
          // Add other providers if needed
        ],
        child: MyApp(socketClient: socketClient),
      ),
        // MyApp(socketClient: socketClient)
    );
    // runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  final SocketIOClient socketClient;
  MyApp({required this.socketClient});
  @override
  State<MyApp> createState() => _MyAppState();
  // State<MyApp> createState() => _MyAppState(socketClient);//background
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  // final SocketIOClient socketClient;//background
  // _MyAppState(this.socketClient);//background


  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentTheme = prefs.getString('themeData');
    String themeVal = (currentTheme==null)?'lightCode':currentTheme;
    prefs.setString('themeData', themeVal);
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    getTheme();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;


      print("Notification...........111"+notification.toString());
      print("Notification...........2222 "+notification.title.toString());
      print("Notification...........333 ");
      print("Notification Body::::::::::::: " + (message.data.toString()));

      print("Notification...........000009999 ");

      if(notification !=null && android != null) {
        flutterLocalNotificationsPlugin.show(
            // notification.hashCode,notification.title,notification.body,
            notification.hashCode,'Transaction Info.',notification.body,
            // notification.hashCode,notification.title,data['message'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  color: Colors.orange,
                  playSound: true,
                  icon:'@mipmap/ic_launcher'

              ),
            ));

        if(notification.title.toString() == 'TRANSACTION_BROADCASTED'){
          var customData = jsonDecode(message.data['customData'] ?? '');

          print(">>>>>>>>>>>>>>>>>>>>>>:::::::::::: " + (customData['transactionId']));

          print('/////////////////////////////');
          //redirect when any notification receive
          NavigatorService.pushNamed(AppRoutes.approvalScreen, argument: {'blockchain': customData['blockchain'], 'page': 'home', 'trxId': customData['transactionId'], 'id': 0});
        }else{
          print('/////////////////////////////else');
          //redirect when any notification receive
          NavigatorService.pushNamed(AppRoutes.homeScreen);
        }


        //change app user status
        // if(notification.title.toString() == 'status_changed'){
        //   final Map<String, dynamic> data = jsonDecode(notification.body!);
        //   final status = data['status'];
        //   var userStatus = (status == 'under_review')?'Under Review':(status == 'inactive')?'Inactive':(status == 'active')?'Active':'Suspended';
        //
        //   if (mounted) {
        //     var homeScreenProvider =
        //     Provider.of<HomeScreenProvider>(context, listen: false);
        //
        //     // final context = NavigatorService.navigatorKey.currentContext;
        //     homeScreenProvider.changeStatus(userStatus);
        //     // NavigatorService.pushNamed(AppRoutes.homeScreen);
        //     // Provider.of<HomeScreenProvider>(context!, listen: false).userWalletData();
        //     if(status == 'active'){
        //       homeScreenProvider.getUserWalets();
        //     }
        //
        //   }
        //
        // }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;

      print("Notification...........444 "+notification.toString());
      print("Notification...........555 "+notification.body.toString());
      print("Notification...........666 "+notification.title.toString());

      // final Map<String, dynamic> data = jsonDecode(notification.body!);

      if(notification !=null && android != null) {

        flutterLocalNotificationsPlugin.show(
            // notification.hashCode,notification.title,notification.body,
            notification.hashCode,'Transaction Info.',notification.body,
            // notification.hashCode,notification.title,data['message'],

            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  color: Colors.orange,
                  playSound: true,
                  icon:'@mipmap/ic_launcher'

              ),

            ));
      }
    });

  }

  @override
  void dispose() {
    widget.socketClient.dispose();
    WidgetsBinding.instance.removeObserver(this);//background
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Sizer(
      builder: (context, orientation, deviceType){
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (context)=>ThemeProvider(),
            ),
            ChangeNotifierProvider<AuthProvider>(
              create: (context)=>AuthProvider(),
            ),
            ChangeNotifierProvider<HomeScreenProvider>(
              create: (context)=>HomeScreenProvider(),
            ),
            ChangeNotifierProvider<SelfieProvider>(
              create: (context)=>SelfieProvider(),
            ),
            ChangeNotifierProvider<ForgotPasswordProvider>(
              create: (context)=>ForgotPasswordProvider(),
            ),
            ChangeNotifierProvider<RouteNameProvider>(
              create: (context)=>RouteNameProvider(),
            ),
            ChangeNotifierProvider<MpinProvider>(
              create: (context)=>MpinProvider(),
            ),
            ChangeNotifierProvider<ProfileProvider>(
              create: (context)=>ProfileProvider(),
            ),
            ChangeNotifierProvider<TransactionProvider>(
              create: (context)=>TransactionProvider(),
            ),
            ChangeNotifierProvider<TransactionScreenProvider>(
              create: (context)=>TransactionScreenProvider(),
            ),
            ChangeNotifierProvider<BtcProvider>(
              create: (context)=>BtcProvider(),
            )
          ],

          child: Consumer<ThemeProvider>(
            builder: (context, provider, child){
              final themeProvider = Provider.of<ThemeProvider>(context);
              final isDarkMode = provider.themeType == 'darkCode';
              final routeNameProvider = Provider.of<RouteNameProvider>(context, listen: false);

              return MaterialApp(
                title: 'CoinSwap',
                debugShowCheckedModeBanner: false,
                // theme: theme,
                theme: ThemeHelper().themeData(), // Light theme
                darkTheme: ThemeHelper().themeData(), // Dark theme
                // themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                themeMode: themeProvider.currentThemeMode,
                navigatorKey: NavigatorService.navigatorKey,
                // navigatorObservers: [RouteObserver()],
                navigatorObservers: [
                  RouteObserver(
                    onRouteChanged: (routeName) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        routeNameProvider.routeName = routeName;
                      });
                    },
                  ),
                ],
                localizationsDelegates: const [
                  AppLocalizationDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en','')],
                initialRoute: AppRoutes.initialRoute,
                routes: AppRoutes.route,
              );
            },
          ),
        );
      },
    );
  }
}


class RouteObserver extends NavigatorObserver {
  final ValueChanged<String> onRouteChanged;

  RouteObserver({required this.onRouteChanged});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRouteChanged(routeName);
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = previousRoute?.settings.name ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRouteChanged(routeName);
    });
  }
}

