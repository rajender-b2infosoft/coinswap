import 'dart:async';
import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/popup_util.dart';
import '../../main.dart';
import '../../routes/routeaprovider.dart';
import '../../services/WebSocketService.dart';
import '../../services/socketService.dart';
import '../auth/provider/auth_provider.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For json decoding
// import 'package:uni_links/uni_links.dart';

import '../transactions/models/transaction.dart';
import '../wallet/provider/wallet.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeScreenProvider homeProvider;
  // late RouteNameProvider routeProvider;
  late AuthProvider authProvider;
  var count = 0;
  final _secureStorage = const FlutterSecureStorage();
  // late WebSocketClient _webSocketClient;
  late SocketIOClient _webSocketClient;
  final WebSocketService _webSocketService = WebSocketService();


  final _linkStream = StreamController<String>();
  var routeName = 'home_screen';
  String walletAddress = '';
  String accessToken = '';
  // Coinbase OAuth2 credentials
  final clientId = '34ba3164-2d6b-46d8-a1e5-59fa7937f45b';
  final clientSecret = 'IPG3MPbrzocGjy9~oX~yrbFVu6';
  // final redirectUri = 'coinswap://callback';
  // final redirectUri = 'https://coinswap.co.in:3000/callback';
  final redirectUri = 'https://coinswap.co.in:3000/auth/coinbase-callback';
  final coinbaseAuthorizeUrl = 'https://www.coinbase.com/oauth/authorize';
  final coinbaseTokenUrl = 'https://api.coinbase.com/oauth/token';

  // Step 1: Initiate Coinbase OAuth2 Flow
  Future<void> loginWithCoinbase() async {
    final authorizationUrl =
        '$coinbaseAuthorizeUrl?response_type=code&client_id=$clientId&redirect_uri=$redirectUri&scope=wallet:user:read';
    try {
      // Open the browser and start the OAuth2 flow
      final result = await FlutterWebAuth.authenticate(
        url: authorizationUrl,
        callbackUrlScheme: 'coinbase-callback', // Custom URI scheme
      );
      // Extract the authorization code from the result
      final code = Uri.parse(result).queryParameters['code'];

      // if (code != null) {
      //   // Step 2: Exchange code for access token
      //   await exchangeCodeForAccessToken(code);
      // }
    } catch (e) {
      print("Error during Coinbase authentication: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during Coinbase authentication')),
      );
    }
  }

  // Step 2: Exchange Authorization Code for Access Token
  Future<void> exchangeCodeForAccessToken(String code) async {
    try {
      final response = await http.post(
        Uri.parse(coinbaseTokenUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'client_id': clientId,
          'client_secret': clientSecret,
          'redirect_uri': redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          accessToken = data['access_token'];
          walletAddress = "Connected to Coinbase Wallet";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully connected to Coinbase Wallet')),
        );
      } else {
        print("Failed to retrieve access token");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to retrieve access token')),
        );
      }
    } catch (e) {
      print("Error exchanging code for token: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // _initUniLinks();

     _webSocketClient = SocketIOClient(flutterLocalNotificationsPlugin); // Pass the instance here

    // _webSocketClient = SocketIOClient();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      homeProvider = Provider.of<HomeScreenProvider>(context, listen: false);
      homeProvider.userWalletData();

      //Get user recent transaction
      homeProvider.recentTransactionsData();

      routeName = Provider.of<RouteNameProvider>(context, listen: false).routeName;
      WidgetsBinding.instance?.addObserver(this);
      _connectWebSocket();
    });
  }

  Future<void> fetchAccountInfo() async {
    final url = 'https://api.coinbase.com/v2/accounts'; // Coinbase API endpoint for accounts
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer TM7cyOCsKHGvVsNPYqx4pDNb53-Rt-S0-HQigJNHpSQ.HR1u6VJPUMNeP126c5h1nJpK3VdM-v933wDIvowZX8A',
        'CB-VERSION': '2024-08-08',
        // 'Authorization': 'Bearer $accessToken',
      },
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Account Information: $data");
      // You can update the UI with account information here
    } else {
      print("Failed to fetch account information");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch account information')),
      );
    }
  }

  // Future<void> _initUniLinks() async {
  //   try {
  //     final initialLink = await getInitialLink();
  //     if (initialLink != null) {
  //       _handleDeepLink(initialLink);
  //     }
  //   } catch (e) {
  //     print('Failed to get initial link: $e');
  //   }
  //
  //   linkStream.listen((String? link) {
  //     if (link != null) {
  //       _handleDeepLink(link);
  //     }
  //   });
  // }

  void _handleDeepLink(String link) {
    // Process the link (e.g., extract parameters)
    print('Received deep link:::::::::::::::::::::::: $link');
    // Navigate or update state based on the deep link
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
    _linkStream.close();
    super.dispose();
  }

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
        key: _scaffoldKey,
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
                                    : (homeProvider.userStatus.toString() == 'Active' || homeProvider.userStatus.toString() == 'active')
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
                        _scaffoldKey.currentState?.openDrawer();
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
                        InkWell(
                          onTap:(){
                            fetchAccountInfo();
                           },
                          child: Text(
                            'Wallet',
                            style: CustomTextStyles.white23,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: (){
                            // Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                            // print('pressed:::::::::::::');
                            //   NavigatorService.pushNamed(AppRoutes.walletPage);
                              NavigatorService.pushNamed(AppRoutes.walletScreen);
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

                  // walletAddress.isNotEmpty
                  //     ? Text('Connected: $walletAddress')
                  //     : const Text('Not connected', style: TextStyle(color: Colors.white)),
                  // const SizedBox(height: 20),
                  // Container(
                  //   color: Colors.green,
                  //   child: ElevatedButton(
                  //     onPressed: loginWithCoinbase,
                  //     child: const Text('Connect Coinbase Wallet', style: TextStyle(color: Colors.white),),
                  //   ),
                  // ),

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
                      '\$00.00',
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
                            onPressed: () {
                              NavigatorService.pushNamed(AppRoutes.transactionScreen);
                            },
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

                      Container(
                        height: SizeUtils.height/4,
                        child: SingleChildScrollView(
                          child: Container(
                            height: SizeUtils.height/4,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Consumer<HomeScreenProvider>(
                                  builder: (context, provider, child) {
                                    if (provider.isLoading) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (provider.recenTransactionData == null || provider.recenTransactionData!.data.isEmpty) {
                                      return Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(0.0),
                                            child: Text('No transaction available', style: CustomTextStyles.gray7272_16),
                                          ));
                                    }
                                    // Accessing transaction data
                                    var data = provider.recenTransactionData!.data;

                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {

                                      final tr = data[index];
                                      var cryptoType = (tr.cryptoType=='bitcoin')?'BTC':(tr.cryptoType=='ethereum')?"ETH":"USDT";
                                      var amount = (tr.transactionType=='dr')?'-${tr.amount}':'${tr.amount}';
                                      DateTime parsedDate = DateTime.parse(tr.createdAt.toString());
                                      String formattedDate = DateFormat('dd-MMM-yyyy').format(parsedDate);

                                      return _buildActivityCard(tr.receiverWalletAddress.toString(), cryptoType, '\$${tr.amount}',
                                          tr.status.toString(), formattedDate);

                                      // return _buildActivityCard('1Lbcfr7sAHTD9CgdQo3', 'BTC', '\$3412',
                                      //     '-123421', '23-Apr-2024', Icons.arrow_downward);
                                    }
                                  );
                                }
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: Container(
          alignment: Alignment.topLeft,
          width: 300,
          decoration: const BoxDecoration(
            color: Colors.transparent
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: 290,
                child: Drawer(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 60,
                                width: 60,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: appTheme.main,
                                ),
                                child: ClipOval(
                                  child: Image.network((homeProvider.selfie!=null)?Constants.imgUrl +homeProvider.selfie.toString(): ImageConstant.iconUser,
                                    width: 75, // Set the desired width
                                    height: 75, // Set the desired height
                                    fit: BoxFit.cover, // Adjust how the image should fit within its box
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${homeProvider.name}',
                                    style: TextStyle(
                                      color: appTheme.color0071D0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins"
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${homeProvider.email}',
                                    style: TextStyle(
                                      color: appTheme.color9898,
                                      fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins"
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Divider(
                          color: appTheme.color0071D0,
                          height: 20,
                          thickness: 2,
                          indent: 0,
                          endIndent: 50,
                        ),
                        const SizedBox(height: 20,),
                        drawerItem('Dashboard',ImageConstant.iconDashboard, AppRoutes.homeScreen),
                        drawerItem('Transactions', ImageConstant.iconTransaction, AppRoutes.transactionScreen),
                        drawerItem('Profile',ImageConstant.iconUser, AppRoutes.profileScreen),
                        drawerItem('Mpin', ImageConstant.iconMpin, AppRoutes.mpinScreen),
                        drawerItem('Wallet', ImageConstant.WalletIcon, AppRoutes.walletScreen),
                        drawerItem('Setting', ImageConstant.setting, AppRoutes.settingScreen),
                        drawerItem('Logout', ImageConstant.iconLogout, AppRoutes.loginScreen),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -10,
                top: 55,
                child: Center(
                  child: InkWell(
                    onTap: (){
                      NavigatorService.goBack();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: appTheme.main,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.arrow_back_ios, color: appTheme.white, size: 18,),
                      ),
                    ),
                  ),
                ),),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem(name, img, redirect){
    return Padding(
      padding: const EdgeInsets.only(right: 50.0),
      child: Container(
        decoration: BoxDecoration(
            color: (homeProvider.isClicked==name)?appTheme.main:Colors.transparent,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(50),
              topRight: Radius.circular(50),
            )
        ),
        child: ListTile(
          splashColor: Colors.transparent,
          leading: CustomImageView(
            imagePath: img,
            height: 25,
            width: 25,
            color: (homeProvider.isClicked==name)?appTheme.white:appTheme.gray7272,
          ),
          title: Text(name, style: (homeProvider.isClicked==name)?CustomTextStyles.sideBarWhite:CustomTextStyles.sideBarGray,),
          onTap: () {
            homeProvider.setIsClicked(name);
            if(name == 'Logout'){
              authProvider.logout();
            }else if(name == 'Transactions'){
              NavigatorService.pushNamed(redirect, argument: {'toAddress': ''});
            }else {
              NavigatorService.pushNamed(redirect);
            }
          },
        ),
      ),
    );
  }

  _button(text, redirect){
    return  InkWell(
      onTap: (){

        if(homeProvider.userStatus.toString() == 'Active' || homeProvider.userStatus.toString() == 'active'){
          if(text == 'Send'){
            NavigatorService.pushNamed(redirect, argument: {'toAddress': '','cryptoType': 'Ethereum','amount': ''});
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
            color: (homeProvider.userStatus.toString() == 'Active' || homeProvider.userStatus.toString() == 'active') ? const Color(0XFF3E91DC) : const Color(0XFF6485A3),
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
    return InkWell(
      onTap: (){
        var cryptoType = (currency=='BTC')?'Bitcoin':(currency=='ETH')?'Ethereum':'USDT';
        NavigatorService.pushNamed(AppRoutes.transferScreen, argument: {'toAddress': '', 'cryptoType': cryptoType, 'amount': ''});
      },
      child: Container(
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
      String status, String date) {
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
                Container(
                  width: 150,
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.gray7272_13,
                  ),
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
                    status.toUpperCase(),
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
