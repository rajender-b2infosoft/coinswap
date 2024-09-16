import 'package:crypto_app/presentation/settings/provider/setting.dart';
import 'package:crypto_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SettingProvider(),
      child: const SettingScreen(),
    );
  }
}

class _SettingScreenState extends State<SettingScreen> {
  late SettingProvider provider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<SettingProvider>(context, listen: false);
      provider.getSettings(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SettingProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.main,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              NavigatorService.goBack();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: appTheme.white,
            )),
        title: Text(
          'Settings',
          style: CustomTextStyles.headlineMediumRegular,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: SizeUtils.height,
          width: SizeUtils.width,
          decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )),
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(5),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: appTheme.main,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: CustomImageView(
                            imagePath: ImageConstant.bellWhite,
                            height: 40,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Notifications",
                        style: CustomTextStyles.gray7272_18,
                      ),
                    ],
                  ),
                  FlutterSwitch(
                    width: 70,
                    height: 30,
                    showOnOff: false,
                    toggleSize: 25.0,
                    value: provider.isNotification,
                    inactiveColor: appTheme.colorEFEFEF,
                    activeColor: appTheme.lightGreen,
                    onToggle: (val){
                      provider.toggleSwitch();
                      provider.setNotification(context, val);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(5),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: appTheme.main,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: CustomImageView(
                            imagePath: ImageConstant.theme,
                            height: 40,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Theme",
                        style: CustomTextStyles.gray7272_18,
                      ),
                    ],
                  ),
                  Stack(
                    children: [

                      FlutterSwitch(
                        width: 70,
                        height: 30,
                        showOnOff: false,
                        toggleSize: 25.0,
                        value: provider.isTheme,
                        inactiveColor: appTheme.color2628,
                        activeColor: appTheme.color0072D,
                        onToggle: (val)async{
                          print(val);
                          provider.toggleSwitch1();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if(!val){
                            prefs.setString('themeData', 'lightCode');
                          }else{
                            prefs.setString('themeData', 'darkCode');
                          }

                          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                        },
                          activeIcon:  CustomImageView(
                            imagePath: ImageConstant.sun,
                            height: 20,
                          ),
                          inactiveIcon:  CustomImageView(
                            imagePath: ImageConstant.moon,
                            height: 20,
                          ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: appTheme.main,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: CustomImageView(
                          imagePath: ImageConstant.iconMpin,
                          color: appTheme.white,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Set Mpin",
                        style: CustomTextStyles.gray7272_18,
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: (){
                      NavigatorService.pushNamed(AppRoutes.mpinScreen);
                    },
                      child: Icon(
                        Icons.arrow_forward_ios_rounded, color: appTheme.grayA0A0, weight: 600,))
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
