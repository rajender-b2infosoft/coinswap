import 'package:crypto_app/theme/custom_text_style.dart';
import 'package:crypto_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../auth/provider/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeScreenProvider(),
      child: const HomeScreen(),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenProvider homeProvider;
  late AuthProvider authProvider;
  var count = 0;


  @override
  Widget build(BuildContext context) {
    homeProvider = Provider.of<HomeScreenProvider>(context, listen: true);
    authProvider = Provider.of<AuthProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () async {
        // Call _onBackPressed and return its result
        bool shouldPop = await _onBackPressed(context);
        return shouldPop;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.main,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              children: [
                Text(
                  'CoinSwap',
                  style: CustomTextStyles.title27_400,
                ),
                const SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text((homeProvider.userStatus.toString() == 'under_review')?"(Under Review)": "(${homeProvider.userStatus.toString()})",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: appTheme.red,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: (){
                  // NavigatorService.pushNamed(AppRoutes.conversionScreen);
                  authProvider.logout();
                },
                child: CustomImageView(
                  imagePath: ImageConstant.navbar,
                  width: 44,
                  height: 20,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: appTheme.main,
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Wallet',
                        style: CustomTextStyles.white23,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.wallet,
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        '92,99,222',
                        style: CustomTextStyles.white30,
                      ),
                      Positioned(
                        right: -40,
                        top: -5,
                        child: Text(
                          'PCI',
                          style: CustomTextStyles.white20,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$34,333',
                    style: CustomTextStyles.white18,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _button('Send', AppRoutes.transferScreen),
                      const SizedBox(width: 5),
                      CustomImageView(
                        imagePath: ImageConstant.line,
                        color: appTheme.white,
                      ),
                      const SizedBox(width: 5),
                      _button('Receive', AppRoutes.receiveScreen),
                      const SizedBox(width: 5),
                      CustomImageView(
                        imagePath: ImageConstant.line,
                        color: appTheme.white,
                      ),
                      const SizedBox(width: 5),
                      _button('Convert', AppRoutes.conversionScreen),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Information',
                            style: CustomTextStyles.gray7272_17,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View more',
                              style: CustomTextStyles.gray11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Consumer<HomeScreenProvider>(
                          builder: (context, homeProvider, child) {
                            return StreamBuilder<Map<String, dynamic>>(
                                stream: homeProvider.stream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }
                                  if (!snapshot.hasData) {
                                    return const Center(child: Text('No data available'));
                                  }

                                  final btcPrice = homeProvider.getPrice('BTC-USD');
                                  final ethPrice = homeProvider.getPrice('ETH-USD');
                                  final usdtPrice = homeProvider.getPrice('USDT-USD');

                                  final btcChange = homeProvider.getPercentage('BTC-USD');
                                  final ethChange = homeProvider.getPercentage('ETH-USD');
                                  final usdtChange = homeProvider.getPercentage('USDT-USD');

                                  final btcColor = homeProvider.getColor('BTC-USD');
                                  final ethColor = homeProvider.getColor('ETH-USD');
                                  final usdtColor = homeProvider.getColor('USDT-USD');

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoCard(ImageConstant.bit, 'BTC', btcPrice.toStringAsFixed(4),
                                        '$btcChange%', appTheme.orange, btcColor),
                                    _buildInfoCard(ImageConstant.eth, 'ETH', ethPrice.toStringAsFixed(4),
                                        '$ethChange%', appTheme.color7CA, ethColor),
                                    _buildInfoCard(ImageConstant.t, 'USDT', usdtPrice.toStringAsFixed(5),
                                        '$usdtChange%', appTheme.green, usdtColor),
                                    // _buildInfoCard(ImageConstant.bit, 'BTC', btcPrice.toStringAsFixed(4),
                                    //     '14.07%', appTheme.orange),
                                    // _buildInfoCard(ImageConstant.eth, 'ETH', ethPrice.toStringAsFixed(4),
                                    //     '3.45%', appTheme.color7CA),
                                    // _buildInfoCard(ImageConstant.t, 'USDT', usdtPrice.toStringAsFixed(5),
                                    //     '5.10%', appTheme.green),
                                  ],
                                );
                              }
                            );


                        }
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Recent activity',
                        style: CustomTextStyles.gray7272_17,
                      ),
                      const SizedBox(height: 16),
                      _buildActivityCard('1Lbcfr7sAHTD9CgdQo3', 'BTC', '\$3412',
                          '-123421', '23-Apr-2024', Icons.arrow_downward),
                      _buildActivityCard('413fr7sTH2313FCgdQo3', 'USDT', '\$3412',
                          '-123421', '23-Apr-2024', Icons.arrow_upward),
                      _buildActivityCard('1Lbcfr7sAHTD9CgdQo3', 'ETH', '\$3412',
                          '-123421', '23-Apr-2024', Icons.arrow_downward),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _button(text, redirect){
    return  InkWell(
      onTap: (){
        NavigatorService.pushNamed(redirect);
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(left: 20,right: 20,),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0XFF3E91DC)
        ),
        child: Center(child: Text(text, style: CustomTextStyles.white17,)),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Exit', textAlign: TextAlign.center, style: CustomTextStyles.main24,),
          content: Text('Are you sure you want to exit?', textAlign: TextAlign.center, style: CustomTextStyles.main16,),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('Cancel', textAlign: TextAlign.center, style: CustomTextStyles.main21,),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Exit', textAlign: TextAlign.center, style: CustomTextStyles.main21,),
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

  Widget _buildInfoCard(
      img, String currency, String amount, String change, Color changeColor, percentColor) {
    final percentage = double.tryParse(change) ?? 0.0;
    final isPositive = percentage >= 0;
    final percentageColor = isPositive ? appTheme.green : appTheme.red;
    return Container(
      width: SizeUtils.width / 3.5,
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(width: 0.8, color: appTheme.blueLight)
      ),
      child: Column(
        children: [
          CustomImageView(
            imagePath: img,
            width: 30,
            height: 30,
          ),
          const SizedBox(height: 5,),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: currency,
                  style: CustomTextStyles.size10_7272
                ),
                TextSpan(
                  text: '/USDT',
                  style: CustomTextStyles.gray8_7272,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            amount,
            // style: CustomTextStyles.orange11,
            style: TextStyle(
              color: changeColor,
              fontSize: 11,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: (percentColor=='green')?ImageConstant.nextUp:ImageConstant.next,
                width: 25,
                height: 25,
              ),
              Text(
                change,
                // style: CustomTextStyles.red11,
                style: TextStyle(
                  color: (percentColor=='green')?appTheme.green:appTheme.red,
                  fontSize: 8,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String name, String currency, String amount,
      String transactionId, String date, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        // padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: appTheme.lightBlue),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: appTheme.lightBlue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
              child: CustomImageView(
                fit: BoxFit.contain,
                imagePath: ImageConstant.arrowBottom,
                width: 22,
                height: 25,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: CustomTextStyles.gray7272_13,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$currency',
                        style: (currency=='USDT')?CustomTextStyles.green14:(currency=='ETH')?CustomTextStyles.color7CA_14:CustomTextStyles.orange14,
                      ),
                      TextSpan(
                        text: ' | $amount',
                        style: CustomTextStyles.grayA0A0_12,
                      ),
                    ],
                  ),
                ),
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
                  Text(
                    date,
                    style: CustomTextStyles.grayA0A0_12,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
