import 'package:crypto_app/presentation/auth/provider/forgotPassword.dart';
import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
import 'package:crypto_app/presentation/auth/upload_selfie.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/wallet_provider.dart';
import 'package:crypto_app/routes/app_routes.dart';
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
            )

          ],
          child: Consumer<ThemeProvider>(
            builder: (context, provider, child){
              return MaterialApp(
                title: 'CoinSwap',
                debugShowCheckedModeBanner: false,
                theme: theme,
                navigatorKey: NavigatorService.navigatorKey,
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
