import 'package:crypto_app/presentation/mpin/provider/mpin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter_switch/flutter_switch.dart';

class MpinScreen extends StatefulWidget {
  const MpinScreen({super.key});

  @override
  State<MpinScreen> createState() => _MpinScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MpinProvider(),
      child: const MpinScreen(),
    );
  }
}

class _MpinScreenState extends State<MpinScreen> {
  late MpinProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<MpinProvider>(context, listen: false);
      provider.getMpinData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MpinProvider>(context, listen: true);

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.main,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: InkWell(
              onTap: () {
                NavigatorService.pushNamed(AppRoutes.homeScreen);
                // NavigatorService.goBack();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: appTheme.white,
              )),
          title: Text(
            'M - Pin ',
            style: CustomTextStyles.headlineMediumRegular,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: SizeUtils.height,
            decoration: BoxDecoration(
                color: appTheme.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'M-Pin',
                    style: CustomTextStyles.gray7272_17,
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: appTheme.white,
                      boxShadow: [
                        BoxShadow(
                          color: appTheme.color549FE3,
                          blurRadius: 1.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Enable M - Pin', style: CustomTextStyles.gray7272_16,),
                            FlutterSwitch(
                              width: 55,
                              height: 25,
                              showOnOff: false,
                              toggleSize: 25.0,
                              value: provider.mpinToggle,
                              inactiveColor: appTheme.colorB6B6B6,
                              activeColor: appTheme.main,
                              onToggle: (val){
                                provider.setMpinToggle(val);
                                var active_status = (val)?1:0;
                                provider.setMpinStatus(context, active_status);
                              },
                              inactiveTextColor: appTheme.white,
                              activeTextColor: appTheme.white,
                            )
                          ],
                        ),
                        const SizedBox(height: 5,),
                        SizedBox(
                          width: SizeUtils.width/1.55,
                            child: Text('App will use the Mpin on your device to unlock the application', style: CustomTextStyles.color9898_13,)
                        ),
                        const SizedBox(height: 30,),
                        if(provider.mpinToggle)
                        _button(),
                      ],
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

  _button() {
    return (provider.isLoading)?Center(
      child: Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: appTheme.main
        ),
        child: provider.isLoading ? const Center(
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5,)) : null,
      ),
    ):Center(
      child: CustomElevatedButton(
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: appTheme.main,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)
          ),
          elevation: 0,
        ),
        buttonTextStyle: CustomTextStyles.white18,
        height: 50,
        width: SizeUtils.width,
        text: (provider.mpin=='null' || provider.mpin=='')?"Generate Mpin":"Edit mpin",
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? email = prefs.getString('email');
          provider.forgotPassword(context, email, 'otp', 'mpin');
          // NavigatorService.pushNamed(AppRoutes.forgotpasswordotp, argument: {'email': email, 'page': 'mpin'});
            // NavigatorService.pushNamed(AppRoutes.generateMpin);
        },
      ),
    );
  }

}
