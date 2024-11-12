import 'package:crypto_app/presentation/auth/provider/forgotPassword.dart';
import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
import 'package:crypto_app/presentation/graphs/providers/btcProvider.dart';
import 'package:crypto_app/presentation/mpin/provider/mpin.dart';
import 'package:crypto_app/presentation/profile/provider/profile.dart';
import 'package:crypto_app/presentation/transactions/provider/transaction.dart';
import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:crypto_app/routes/routeaprovider.dart';
import 'package:crypto_app/services/socketService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:crypto_app/core/app_export.dart';
import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    runApp(MyApp(socketClient: socketClient));
    // runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  final SocketIOClient socketClient;
  MyApp({required this.socketClient});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.socketClient.dispose();
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

