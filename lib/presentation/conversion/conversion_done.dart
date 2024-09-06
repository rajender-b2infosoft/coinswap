import 'package:crypto_app/theme/custom_text_style.dart';
import 'package:crypto_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class ConversionDone extends StatefulWidget {
  const ConversionDone({super.key});

  @override
  State<ConversionDone> createState() => _ConversionDoneState();
  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=> HomeScreenProvider(),
      child: const ConversionDone(),
    );
  }
}

class _ConversionDoneState extends State<ConversionDone> {
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
                _buildInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40,),
        Center(
          child: CustomImageView(
            imagePath: ImageConstant.round_done,
            width: 90,
            height: 90,
          ),
        ),
        const SizedBox(height: 20,),
        Center(child: Text('Well done!', style: CustomTextStyles.main28,)),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Text('9812.2312 (USDT) has been added to your wallet.',
            textAlign: TextAlign.center,
            style: CustomTextStyles.gray14,),
        ),
        const SizedBox(height: 70,),
        _proceedButton(),
      ],
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
        text: "Convert more",
        onPressed: () {
          NavigatorService.pushNamed(AppRoutes.conversionDone);
        },
      ),
    );
  }

}