import 'package:flutter/material.dart';
import '../presentation/app_navigation_screen/app_navingation_screen.dart';
import '../presentation/auth/forgotPasswordChange.dart';
import '../presentation/auth/forgotPasswordOtp.dart';
import '../presentation/auth/forgot_password.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/auth/register_screen.dart';
import '../presentation/auth/register_success_screen.dart';
import '../presentation/auth/upload_selfie.dart';
import '../presentation/auth/verify_identity.dart';
import '../presentation/auth/verify_otp.dart';
import '../presentation/conversion/conversion.dart';
import '../presentation/conversion/conversion_done.dart';
import '../presentation/home_screen_page/home_screen.dart';
import '../presentation/get_started/get_started.dart';
import '../presentation/home_screen_page/wallet_page.dart';
import '../presentation/splaash_screen/splash_screen.dart';
import '../presentation/wallet/qr_view.dart';
import '../presentation/wallet/receive_screen.dart';
import '../presentation/wallet/success_screen.dart';
import '../presentation/wallet/transfer_screen.dart';

class AppRoutes{
  static const String splashScreen = '/splash_screen';
  static const String getStartedScreen = '/getStartedScreen';
  static const String verifyOtp = '/verifyOtp';
  static const String verifyIdentity = '/verifyIdentity';
  static const String registerSuccessScreen = '/registerSuccessScreen';
  static const String receiveScreen = '/receiveScreen';
  static const String transferScreen = '/TransferScreen';
  static const String qRView = '/qRView';
  static const String successScreen = '/successScreen';
  static const String conversionScreen = '/conversionScreen';
  static const String conversionDone = '/conversionDone';
  static const String uploadSelfie = '/uploadSelfie';
  static const String forgotPassword = '/forgotPassword';
  static const String forgotpasswordotp = '/forgotpasswordotp';
  static const String forgotPasswordChange = '/forgotPasswordChange';

  static const String loginScreen = '/login_screen';
  static const String registerScreen = '/register_screen';
  static const String homeScreen = '/home_screen';
  static const String walletPage = '/walletPage';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get route => {
    splashScreen: SplashScreen.builder,
    getStartedScreen: GetStartedScreen.builder,
    verifyOtp: VerifyOtp.builder,
    verifyIdentity: VerifyIdentity.builder,
    registerSuccessScreen: RegisterSuccessScreen.builder,
    receiveScreen: ReceiveScreen.builder,
    transferScreen: TransferScreen.builder,
    qRView: ScannerScreen.builder,
    successScreen: SuccessScreen.builder,
    conversionScreen: ConversionScreen.builder,
    conversionDone: ConversionDone.builder,
    uploadSelfie: UploadSelfie.builder,
    forgotPassword: ForgotPassword.builder,
    forgotpasswordotp: ForgotPasswordOtp.builder,
    forgotPasswordChange: ForgotPasswordChange.builder,

    loginScreen: LoginScreen.builder,
    registerScreen: RegisterScreen.builder,
    homeScreen: HomeScreen.builder,
    walletPage: WalletPage.builder,
    appNavigationScreen: AppNavigationScreen.builder,
    initialRoute: SplashScreen.builder
  };
}