import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../core/utils/popup_util.dart';
import '../../services/WebSocketService.dart';
import '../../services/socketService.dart';
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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late HomeScreenProvider homeProvider;
  late AuthProvider authProvider;
  var count = 0;
  final _secureStorage = const FlutterSecureStorage();
  // late WebSocketClient _webSocketClient;
  late SocketIOClient _webSocketClient;
  final WebSocketService _webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    // _webSocketClient = WebSocketClient();
    _webSocketClient = SocketIOClient();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // homeProvider = Provider.of<HomeScreenProvider>(context, listen: false);
      WidgetsBinding.instance?.addObserver(this);
      _connectWebSocket();

    });
    // _connectWebSocket();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _connectWebSocket();
    }
  }



  void _connectWebSocket() async {

    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');
      int? userId = prefs.getInt('user_id');

      if (token != null && userId != null) {
        // _webSocketClient.connectWebSocket(token, userId.toString(), context);
        if (_webSocketClient != null) {
          _webSocketClient?.disconnect(); // Disconnect the existing connection
          _webSocketClient.connectSocket(token, userId.toString(), context, homeProvider);
        }else{
          // WebSocketService().connectSocket(token, userId.toString(), context, homeProvider);
          _webSocketClient.connectSocket(token, userId.toString(), context, homeProvider);
        }
      }
    }catch(e){
      print('Exception'+e.toString());
    }



  }

  @override
  void dispose() {

    // WidgetsBinding.instance?.removeObserver(this);
    // _webSocketService.disconnect();
    super.dispose();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   storeValue();
  // }
  //
  // Future<void> storeValue() async {
  //   await _secureStorage.write(key: 'address', value: '0x14862e4fb263aa9ae3d73f6ca4e62c410c937495');
  //   await _secureStorage.write(key: 'privateKey', value: '0xd5c197409f72b16cf787fa8cbb57a1fa000b1d003c4d17722c2ae3f347a16fe8');
  // }

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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CoinSwap',
                        style: CustomTextStyles.title27_400,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: InkWell(
                          onTap: (){
                            PopupUtil().popUp(context,"${homeProvider.userStatus.toString()}", CustomTextStyles.white17_400,"Your account is currently ${homeProvider.userStatus.toString()}.");
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(5, 1, 5, 2),
                            decoration: BoxDecoration(
                                color: (homeProvider.userStatus.toString() == 'Under Review')
                                    ? appTheme.colorEA96
                                    : (homeProvider.userStatus.toString() == 'Active')
                                    ? appTheme.green
                                    : appTheme.colorE132,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${homeProvider.userStatus.toString()}",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11,
                                      color: appTheme.white,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Icon(Icons.info, color: appTheme.white, size: 15,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: InkWell(
                      onTap: (){
                        // NavigatorService.pushNamed(AppRoutes.conversionScreen);
                       // _webSocketClient.dispose();
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
            ),
            Container(
              color: appTheme.main,
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      children: [
                        Text(
                          'Wallet',
                          style: CustomTextStyles.white23,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: (){
                            // print('pressed:::::::::::::');
                            //   NavigatorService.pushNamed(AppRoutes.walletPage);
                          },
                          child: CustomImageView(
                            imagePath: ImageConstant.wallet,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stack(
                  //   clipBehavior: Clip.none,
                  //   children: [
                  //     Text(
                  //       '92,99,222',
                  //       style: CustomTextStyles.white30,
                  //     ),
                  //     Positioned(
                  //       right: -40,
                  //       top: -5,
                  //       child: Text(
                  //         'PCI',
                  //         style: CustomTextStyles.white20,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      '\$34,333',
                      style: CustomTextStyles.white30,
                      // style: CustomTextStyles.white18,
                    ),
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

                            var bit_price = homeProvider.getPrice('BTC-USD');
                            var eth_price = homeProvider.getPrice('ETH-USD');
                            var usdt_price = homeProvider.getPrice('USDT-USD');

                            var bit_percentage = homeProvider.getPercentage('BTC-USD');
                            var eth_percentage = homeProvider.getPercentage('ETH-USD');
                            var usdt_percentage = homeProvider.getPercentage('USDT-USD');


                            // double ethPrice = double.tryParse(homeProvider.ethPrice.toString()) ?? 0.0;
                            // double btcPrice = double.tryParse(homeProvider.btcPrice.toString()) ?? 0.0;
                            // double usdtPrice = double.tryParse(homeProvider.usdtPrice.toString()) ?? 0.0;
                            //
                            // String percentChangeBTC = homeProvider.btcPercentChange.toString();
                            // String percentChangeETH = homeProvider.ethPercentChange.toString();
                            // String percentChangeUSDT = homeProvider.usdtPercentChange.toString();
                            //
                            // String priceBTC = btcPrice.toStringAsFixed(2);
                            // String priceETH = ethPrice.toStringAsFixed(3);
                            // String priceUSDT = usdtPrice.toStringAsFixed(4);

                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              _buildInfoCard(ImageConstant.bit, 'BTC', bit_price.toString(),
                                  bit_percentage, appTheme.orange, 'btcColor'),
                            _buildInfoCard(ImageConstant.eth, 'ETH', eth_price.toString(),
                                eth_percentage, appTheme.color7CA, 'ethColor'),
                            _buildInfoCard(ImageConstant.t, 'USDT', usdt_price.toString(),
                                usdt_percentage, appTheme.green, 'usdtColor'),
                            ],
                          );
                         // return Row(
                         //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         //      children: [
                         //      _buildInfoCard(ImageConstant.bit, 'BTC', priceBTC,
                         //          percentChangeBTC, appTheme.orange, 'btcColor'),
                         //    _buildInfoCard(ImageConstant.eth, 'ETH', priceETH,
                         //        percentChangeETH, appTheme.color7CA, 'ethColor'),
                         //    _buildInfoCard(ImageConstant.t, 'USDT', priceUSDT,
                         //        percentChangeUSDT, appTheme.green, 'usdtColor'),
                         //    ],
                         //  );
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
        if(homeProvider.userStatus.toString() == 'Active'){
          if(text == 'Send'){
            NavigatorService.pushNamed(redirect, argument: {'toAddress': ''});
          }else{
            NavigatorService.pushNamed(redirect);
          }
        }else{
          // var status = (homeProvider.userStatus.toString() == 'under_review')?'Under Review':homeProvider.userStatus.toString();
          PopupUtil().popUp(context,"${homeProvider.userStatus.toString()}",
              CustomTextStyles.white17_400,
              "Your account is currently ${homeProvider.userStatus.toString()}."
          );
        }
      },
      child: Container(
        height: 45,
        width: SizeUtils.width*0.3,
        // padding: const EdgeInsets.only(left: 15,right: 15,),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: (homeProvider.userStatus.toString() == 'Active') ? const Color(0XFF3E91DC) : const Color(0XFF6485A3),
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
                    // style: CustomTextStyles.size10_7272
                  style: TextStyle(
                    color: appTheme.gray7272,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  )
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
            style: TextStyle(
              color: changeColor,
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10,),
          getChangeIcon(change),
        ],
      ),
    );
  }

  Widget getChangeIcon(String percentChange) {
    double change = double.tryParse(percentChange) ?? 0.0;

    if (change < 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.next,
            width: 25,
            height: 25,
          ),
          Text('${change.toStringAsFixed(2)}%',
            style: TextStyle(
              color: appTheme.red,
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.nextUp,
            width: 25,
            height: 25,
          ),
          Text('${change.toStringAsFixed(2)}%',
            style: TextStyle(
              color: appTheme.green,
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }
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
