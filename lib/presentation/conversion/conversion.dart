import 'dart:math';

import 'package:crypto_app/theme/custom_text_style.dart';
import 'package:crypto_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=> HomeScreenProvider(),
      child: const ConversionScreen(),
    );
  }
}

class _ConversionScreenState extends State<ConversionScreen> {
  var homeProvider;
  var count = 0;
  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeScreenProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.main,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: (){
              NavigatorService.goBack();
            },
            child: Icon(Icons.arrow_back_ios, color: appTheme.white,)),
        title: Text('Conversion ',
          style:  CustomTextStyles.headlineMediumRegular,),
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
              )
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Available Balance',
                      style: CustomTextStyles.gray7272_16,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.wallet,
                      width: 30,
                      height: 30,
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '1.3981293 BTC | 34,500 USD',
                  style: CustomTextStyles.color9898_13,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Conversion Rate',
                      style: CustomTextStyles.gray7272_16,
                    ),
                    const SizedBox(width: 5),
                    CustomImageView(
                      imagePath: ImageConstant.bit,
                      width: 18,
                      height: 18,
                    )
                  ],
                ),
                Text(
                  '1 ETH = 19.90912 BTC',
                  style: CustomTextStyles.color9898_13,
                ),
                const SizedBox(height: 30),
                Text(
                  'Choose Currency',
                  style: CustomTextStyles.gray7272_16,
                ),
                const SizedBox(height: 10),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: appTheme.white,
                    border: Border.all(width: 1.5, color: appTheme.color549FE3.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10,),
                      ClipOval(
                        child: CustomImageView(
                          imagePath: ImageConstant.eth,
                          width: 36,
                          height: 36,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text('ETH', style: CustomTextStyles.gray7272_14,),
                      const SizedBox(width: 20,),
                      const Spacer(),
                      Transform.rotate(
                          angle: 90 * pi / 180,child: Icon(Icons.arrow_forward_ios, size: 20, color: appTheme.main,)),
                      const SizedBox(width: 10,),

                      const Spacer(),
                      CustomImageView(
                        imagePath: ImageConstant.line,
                        width: 2,
                        color: const Color(0XFF549FE3).withOpacity(0.3),
                        // height: 15,
                      ),
                      const Spacer(),

                      ClipOval(
                        child: CustomImageView(
                          imagePath: ImageConstant.bit,
                          width: 36,
                          height: 36,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text('BTH', style: CustomTextStyles.gray7272_14,),
                      const SizedBox(width: 20,),
                      Transform.rotate(
                          angle: 90 * pi / 180,child: Icon(Icons.arrow_forward_ios, size: 20, color: appTheme.main,)),
                      const SizedBox(width: 20,),


                    ],
                  ),
                ),

                const SizedBox(height: 30,),
                Text(
                  'Enter Amount',
                  style: CustomTextStyles.gray7272_16,
                ),

                const SizedBox(height: 10,),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: const Color(0XFF549FE3).withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          '428.04',
                          style: CustomTextStyles.color549FE3_17,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: appTheme.main,
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: CustomImageView(
                          imagePath: ImageConstant.loop,
                          width: 20,
                          // height: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          '2124.24',
                          style: CustomTextStyles.color549FE3_17,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50,),
                _proceedButton(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _proceedButton() {
    return Center(
      child: CustomElevatedButton(
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: appTheme.main,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
          elevation: 0,
        ),
        buttonTextStyle: CustomTextStyles.white18,
        height: 50,
        width: 250,
        text: "Confirm",
        // margin: EdgeInsets.only(left: 42.h, right: 42.h),
        onPressed: () {
          NavigatorService.pushNamed(AppRoutes.conversionDone);
        },
      ),
    );
  }
}