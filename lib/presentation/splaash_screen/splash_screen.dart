import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../main.dart';
import '../../services/socketService.dart';
import '../auth/provider/auth_provider.dart';
import '../home_screen_page/provider/home_screen_provider.dart';
import 'provider/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashProvider(),
      child: SplashScreen(),
    );
  }
}

class SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver{
  final SocketIOClient _webSocketClient = SocketIOClient(flutterLocalNotificationsPlugin); // Pass the instance here

  // final SocketIOClient _webSocketClient = SocketIOClient();
  late SplashProvider splashProvider;
  late HomeScreenProvider homeProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    _checkAuth();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      splashProvider = Provider.of<SplashProvider>(context, listen: false);
      splashProvider.initialize();
    });

    WidgetsBinding.instance.addObserver(this);
    _reconnectWebSocketIfNecessary();
  }

  Future<void> _checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? type = prefs.getString('role');
    int? user_id = prefs.getInt('user_id');

    // Simulate a delay for splash screen
    await Future.delayed(const Duration(seconds: 1));
    if (accessToken != null && accessToken != '') {
      await authProvider.getUserInfoByID(user_id);
      // User is logged in, navigate to the appropriate screen based on role
      // if (type == 'user') {
      //   NavigatorService.pushNamed(AppRoutes.homeScreen);
      // }else {
      //   NavigatorService.pushNamed(AppRoutes.loginScreen);
      //   // NavigatorService.pushNamed(AppRoutes.getStartedScreen);
      // }
    } else {
      NavigatorService.pushNamed(AppRoutes.loginScreen);
      // NavigatorService.pushNamed(AppRoutes.getStartedScreen);
    }
  }

  // Reconnect WebSocket if credentials are available
  void _reconnectWebSocketIfNecessary() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');
      int? userId = prefs.getInt('user_id');

      if (token != null && userId != null) {
        _webSocketClient.connectSocket(token, userId.toString(), context,homeProvider);
      }
    } catch (e) {
      print("Failed to reconnect WebSocket: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reconnectWebSocketIfNecessary(); // Reconnect when the app resumes
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _webSocketClient.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.main,
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 0,
                  child: CustomImageView(
                    imagePath: ImageConstant.LooperGroup,
                    height: 140.v,
                    width: 120.h,
                    margin: EdgeInsets.only(bottom: 18.v),
                  ),
                ),
                Center(
                  child: CustomImageView(
                    imagePath: ImageConstant.splaashLogo,
                    height: 150.v,
                    // width: 140.h,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CustomImageView(
                    imagePath: ImageConstant.LooperGroupBottom,
                    height: 140.v,
                    width: 170.h,
                    //margin: EdgeInsets.only(bottom: 18.v),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
