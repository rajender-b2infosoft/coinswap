import 'dart:async';
import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class RegisterSuccessScreen extends StatefulWidget {
  const RegisterSuccessScreen({super.key});

  @override
  State<RegisterSuccessScreen> createState() => _RegisterSuccessScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const RegisterSuccessScreen(),
    );
  }
}

class _RegisterSuccessScreenState extends State<RegisterSuccessScreen> {

  late AuthProvider provider;
  late ThemeProvider themeProvider;
  Timer? _timer;
  int _start = 3;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    provider = Provider.of<AuthProvider>(context, listen: false);
    //startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          // Navigate to dashboard
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AuthProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
                    height: 120.v,
                    width: 120.h,
                    margin: EdgeInsets.only(bottom: 18.v),
                  ),
                ),
                Positioned(
                  left: (SizeUtils.width - 120) / 2.2,
                  bottom: SizeUtils.height / 1.35,
                  child: CustomImageView(
                    imagePath: ImageConstant.logo,
                    height: 140.v,
                    width: 140.h,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: SizeUtils.height / 1.6,
                  child: CustomImageView(
                    imagePath: ImageConstant.LooperGroupBottom,
                    height: 140.v,
                    width: 140.h,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: SizeUtils.height / 1.5,
                    decoration: BoxDecoration(
                      color: appTheme.white1,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.completed,
                              height: 250,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Congratulations!',
                              style: (themeProvider.themeType == "lightCode")?CustomTextStyles.gray28:CustomTextStyles.gray28,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                  child: Text(
                                'Welcome to CoinSwap Happy Trading!',
                                textAlign: TextAlign.center,
                                style: CustomTextStyles.gray14,
                              )),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomElevatedButton(
                              buttonStyle: ElevatedButton.styleFrom(
                                  backgroundColor: appTheme.main_mpin,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  elevation: 0),
                              buttonTextStyle: CustomTextStyles.white18,
                              width: 250,
                              height: 50,
                              text: "Continue",
                              onPressed: () async {
                                provider.sendEmail();
                                NavigatorService.pushNamed(
                                    AppRoutes.homeScreen);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
