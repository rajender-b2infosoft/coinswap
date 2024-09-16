import 'package:crypto_app/presentation/auth/provider/forgotPassword.dart';
import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
import 'package:crypto_app/presentation/auth/upload_selfie.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/wallet_provider.dart';
import 'package:crypto_app/presentation/mpin/provider/mpin.dart';
import 'package:crypto_app/presentation/profile/provider/profile.dart';
import 'package:crypto_app/presentation/transactions/provider/transaction.dart';
import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:crypto_app/routes/app_routes.dart';
import 'package:crypto_app/routes/routeaprovider.dart';
import 'package:crypto_app/services/socketService.dart';
import 'package:crypto_app/services/webSocketClient.dart';
import 'package:crypto_app/theme/provider/theme_provider.dart';
import 'package:crypto_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:crypto_app/core/app_export.dart';
import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/navigation_service.dart';
import 'core/utils/pref_utils.dart';
import 'core/utils/size_utils.dart';
import 'localization/app_localization.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    PrefUtils().init()
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  // final WebSocketClient _webSocketClient = WebSocketClient();
  // final SocketIOClient _webSocketClient = SocketIOClient();
  // late HomeScreenProvider homeProvider;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    // _reconnectWebSocketIfNecessary();
  }

  // // Reconnect WebSocket if credentials are available
  // void _reconnectWebSocketIfNecessary() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('accessToken');
  //     int? userId = prefs.getInt('user_id');
  //
  //     if (token != null && userId != null) {
  //       _webSocketClient.connectSocket(token, userId.toString(), context);
  //     }
  //   } catch (e) {
  //     print("Failed to reconnect WebSocket: $e");
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _reconnectWebSocketIfNecessary(); // Reconnect when the app resumes
  //   }
  // }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    // _webSocketClient.dispose();
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
            ChangeNotifierProvider<WalletProvider>(
              create: (context)=>WalletProvider(),
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

