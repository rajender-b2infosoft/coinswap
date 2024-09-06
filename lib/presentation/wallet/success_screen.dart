import 'package:crypto_app/theme/custom_text_style.dart';
import 'package:crypto_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=> HomeScreenProvider(),
      child: const SuccessScreen(),
    );
  }
}

class _SuccessScreenState extends State<SuccessScreen> {
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
            child: Icon(Icons.close, color: appTheme.white,)),
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
        Center(child: Text('Transfer successfull', style: CustomTextStyles.main28,)),
        Center(child: Text('You paid 10 ETH (USD \$241.00) to', style: CustomTextStyles.gray14,)),
        Center(child: Text('rajnishSingh', style: CustomTextStyles.gray14,)),
        const SizedBox(height: 40,),
        Center(
          child: CustomImageView(
            imagePath: ImageConstant.dotLine,
            width: SizeUtils.width-100,
            // height: 90,
          ),
        ),
        const SizedBox(height: 40,),
        Text('Transfer Summary', style: CustomTextStyles.gray7272_16,),
        const SizedBox(height: 10,),
        _buildActivityCard('Abhishek Singh', 'BTC', '\$3412', '-123421', '23-Apr-2024', Icons.arrow_upward),

      ],
    );
  }


  Widget _buildActivityCard(String name, String currency, String amount, String transactionId, String date, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: appTheme.lightBlue),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: appTheme.lightBlue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  )
              ),
              child: CustomImageView(
                fit: BoxFit.contain,
                imagePath: ImageConstant.arrowTop,
                width: 22,
                height: 25,
              ),
            ),
            const SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: CustomTextStyles.gray7272_13,),
                Text('$currency | $amount', style: CustomTextStyles.orange12,),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transactionId,
                    style: CustomTextStyles.gray7272_12,
                  ),
                  Text(date, style: CustomTextStyles.grayA0A0_12,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}