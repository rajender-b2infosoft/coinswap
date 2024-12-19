import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/get_started/provider/login_register_provider.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginRegisterProvider(),
      child: const GetStartedScreen(),
    );
  }
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  late ThemeProvider themeProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        // Call _onBackPressed and return its result
        bool shouldPop = await _onBackPressed(context);
        return shouldPop;
      },
      child: SafeArea(
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
                      //margin: EdgeInsets.only(bottom: 18.v),
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'Let’s get started',
                              style: CustomTextStyles.pageTitleMain,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'To create ID and verify your identity you need to complete these 3 simple steps.',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles.gray12,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            _buildVerificationStep((themeProvider.themeType == "lightCode" || themeProvider.themeType == "system")?ImageConstant.password:ImageConstant.password_dark,
                                'Verify Email', true, 1),
                            _buildVerificationStep(
                                (themeProvider.themeType == "lightCode" || themeProvider.themeType == "system")?ImageConstant.userWithRounded:ImageConstant.userWithRounded_dark,
                                'Take Selfie',
                                true,
                                2),
                            _buildVerificationStep(
                                (themeProvider.themeType == "lightCode" || themeProvider.themeType == "system")?ImageConstant.passport:ImageConstant.passport_dark, 'Verify ID', false, 3),
                            const SizedBox(
                              height: 40,
                            ),
                            _proceedButton(context),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Exit',
            textAlign: TextAlign.center,
            style: CustomTextStyles.main24,
          ),
          content: Text(
            'Are you sure you want to exit?',
            textAlign: TextAlign.center,
            style: CustomTextStyles.main16,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.main21,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(
                    'Exit',
                    textAlign: TextAlign.center,
                    style: CustomTextStyles.main21,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildVerificationStep(img, title, require, index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: SizeUtils.width / 3,
          child: Column(
            children: [
              (title == 'Verify Email')
                  ? SizedBox(
                      height: 8,
                    )
                  : SizedBox(
                      height: 0,
                    ),
              CustomImageView(
                imagePath: img,
                fit: BoxFit.fitWidth,
                width: (index == 1) ? 74 : 45,
                // height: 45,
              ),
              (title == 'Take Selfie')
                  ? SizedBox(
                      height: 5,
                    )
                  : SizedBox(
                      height: 0,
                    ),
              (require)
                  ? CustomPaint(
                      size: const Size(2, 50),
                      painter: DottedBorderPainter(),
                    )
                  : Container(),
            ],
          ),
        ),
        // const SizedBox(width: 10,),
        SizedBox(
          width: SizeUtils.width / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (title == 'Verify ID')
                  ? SizedBox(
                      height: 5,
                    )
                  : (title == 'Take Selfie')
                      ? SizedBox(
                          height: 10,
                        )
                      : SizedBox(
                          height: 3,
                        ),
              Text(
                title,
                style: CustomTextStyles.gray17,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _proceedButton(BuildContext context) {
    return CustomElevatedButton(
      buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: appTheme.main_mpin,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          elevation: 0),
      buttonTextStyle: CustomTextStyles.white18,
      height: 50,
      width: 250,
      text: "Proceed",
      // margin: EdgeInsets.only(left: 42.h, right: 42.h),
      onPressed: () {
        NavigatorService.pushNamed(AppRoutes.registerScreen);
      },
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = appTheme.main_mpin
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashHeight = 5, dashSpace = 5;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(DottedBorderPainter oldDelegate) => false;
}
