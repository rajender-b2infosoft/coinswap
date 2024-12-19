import 'dart:async';
import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/home_screen_page/provider/home_screen_provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/popup_util.dart';
import '../../main.dart';
import '../../routes/routeaprovider.dart';
import '../../services/socketService.dart';
import '../auth/provider/auth_provider.dart';
import 'models/livePrice.dart';

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
  late ThemeProvider themeProvider;

  late AuthProvider authProvider;
  var count = 0;
  late SocketIOClient _webSocketClient;
  // final WebSocketService _webSocketService = WebSocketService();


  final _linkStream = StreamController<String>();
  var routeName = 'home_screen';
  String walletAddress = '';
  String accessToken = '';
  // Coinbase OAuth2 credentials
  // final clientId = '34ba3164-2d6b-46d8-a1e5-59fa7937f45b';
  // final clientSecret = 'IPG3MPbrzocGjy9~oX~yrbFVu6';
  // final redirectUri = 'https://coinswap.co.in:3000/auth/coinbase-callback';
  // final coinbaseAuthorizeUrl = 'https://www.coinbase.com/oauth/authorize';
  // final coinbaseTokenUrl = 'https://api.coinbase.com/oauth/token';


  @override
  void initState() {
    super.initState();
    // _initUniLinks();

     _webSocketClient = SocketIOClient(flutterLocalNotificationsPlugin); // Pass the instance here

    // _webSocketClient = SocketIOClient();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider = Provider.of<HomeScreenProvider>(context, listen: false);
      themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      //get user info like address, status, balance and other
      homeProvider.userWalletData();
      //create function to get wallet converted balance
      homeProvider.userWalletConvertedBalance();
      //Get user recent transaction
      homeProvider.recentTransactionsData();
      //Get crypto live price
      homeProvider.getCryptoLivePrice();
      routeName = Provider.of<RouteNameProvider>(context, listen: false).routeName;
      WidgetsBinding.instance?.addObserver(this);
      _connectWebSocket();
    });
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
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
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
                child: Consumer<HomeScreenProvider>(
                  builder: (context, homeProvider, child) {

                    return InkWell(
                      onTap: () {
                        //get user info like address, status, balance and other
                        homeProvider.userWalletData();
                        //create function to get wallet converted balance
                        homeProvider.userWalletConvertedBalance();
                        //Get user recent transaction
                        homeProvider.recentTransactionsData();
                        //Get crypto live price
                        homeProvider.getCryptoLivePrice();

                        PopupUtil().popUp(
                          context,
                          "${homeProvider.userStatus}",
                          CustomTextStyles.white17_400,
                          "Your account is currently ${homeProvider.userStatus}.",
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 1, 5, 2),
                        decoration: BoxDecoration(
                          color: (homeProvider.userStatus == 'Under Review')
                              ? appTheme.colorEA96
                              : (homeProvider.userStatus == 'Active' || homeProvider.userStatus == 'active')
                              ? appTheme.green
                              : appTheme.colorE132,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${homeProvider.userStatus}",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: appTheme.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(Icons.info, color: appTheme.white, size: 15),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )

              // Padding(
                      //   padding: const EdgeInsets.only(left: 5),
                      //   child: InkWell(
                      //     onTap: (){
                      //       PopupUtil().popUp(context,"${homeProvider.userStatus.toString()}", CustomTextStyles.white17_400,"Your account is currently ${homeProvider.userStatus.toString()}.");
                      //     },
                      //     child: Container(
                      //       padding: const EdgeInsets.fromLTRB(5, 1, 5, 2),
                      //       decoration: BoxDecoration(
                      //           color: (homeProvider.userStatus.toString() == 'Under Review')
                      //               ? appTheme.colorEA96
                      //               : (homeProvider.userStatus.toString() == 'Active' || homeProvider.userStatus.toString() == 'active')
                      //               ? appTheme.green
                      //               : appTheme.colorE132,
                      //           borderRadius: BorderRadius.circular(10)
                      //       ),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Text("${homeProvider.userStatus.toString()}",
                      //             style: TextStyle(
                      //                 fontFamily: 'Poppins',
                      //                 fontSize: 11,
                      //                 color: appTheme.white,
                      //                 fontWeight: FontWeight.w400
                      //             ),
                      //           ),
                      //           const SizedBox(width: 5,),
                      //           Icon(Icons.info, color: appTheme.white, size: 15,)
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                          onTap:(){},
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
                              NavigatorService.pushNamed(AppRoutes.walletScreen);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(3,),
                            decoration: BoxDecoration(
                              color: appTheme.white,
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: CustomImageView(
                              imagePath: ImageConstant.WalletIcon,
                              width: 20,
                              height: 20,
                              color: appTheme.main_mpin,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: SizedBox(
                      width: SizeUtils.width,
                      child: Text(
                        // '\$${(homeProvider.walletBalance=='null')?'0.0':homeProvider.walletBalance}',
                        '\$${(homeProvider.walletBalance=='null')?'0.0':(double.parse(homeProvider.walletBalance)).toStringAsFixed(5).replaceAll(RegExp(r'0+$'), '')}',
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.white30,
                      ),
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
                    color: appTheme.white1,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information',
                        style: CustomTextStyles.gray7272_17,
                      ),
                      const SizedBox(height: 16),
                            // SizedBox(
                            //   height: 130,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     itemCount: homeProvider.cryptoList.length,
                            //     itemBuilder: (context, index){
                            //
                            //       var cryptoType = (homeProvider.cryptoList[index].cryptoType=='bitcoin')?'BTC':(homeProvider.cryptoList[index].cryptoType=='ethereum')?'ETH':'USDT';
                            //       var color = (homeProvider.cryptoList[index].cryptoType=='bitcoin')?appTheme.orange:(homeProvider.cryptoList[index].cryptoType=='ethereum')?appTheme.color7CA:appTheme.green;
                            //       var img = (homeProvider.cryptoList[index].cryptoType=='bitcoin')?ImageConstant.bit:(homeProvider.cryptoList[index].cryptoType=='ethereum')?ImageConstant.eth:ImageConstant.t;
                            //       var price = double.parse(homeProvider.cryptoList[index].price);
                            //       String formattedPrice = price.toStringAsFixed(3);
                            //
                            //       return Padding(
                            //         padding: EdgeInsets.only(left: (index==1)?8.0:(index==2)?8.0:0.0),
                            //         child: _buildInfoCard(img, cryptoType, formattedPrice,homeProvider.cryptoList[index].usd24hChange, color, 'btcColor', homeProvider.cryptoList[index].cryptoType),
                            //       );
                            //
                            //       // return _buildInfoCard(ImageConstant.bit, 'BTC', bit_price.toString(),
                            //       //           bit_percentage, appTheme.orange, 'btcColor', 'bitcoin');
                            //     }
                            //   ),
                            // ),

                      Consumer<HomeScreenProvider>(
                          builder: (context, homeProvider, child) {

                            var bit_price = homeProvider.getPrice('BTC-USD');
                            var eth_price = homeProvider.getPrice('ETH-USD');
                            var usdt_price = homeProvider.getPrice('USDT-USD');

                            // var bit_percentage = homeProvider.getPercentage('BTC-USD');
                            // var eth_percentage = homeProvider.getPercentage('ETH-USD');
                            // var usdt_percentage = homeProvider.getPercentage('USDT-USD');


                            var bitcoinData = homeProvider.cryptoList.firstWhere(
                                  (crypto) => crypto.cryptoType == 'bitcoin',
                              orElse: () => CryptoLivePriceModel(
                                id: 0,
                                cryptoType: 'bitcoin',
                                price: '0',
                                usd24hChange: '0',
                                createdAt: '',
                                updatedAt: '',
                              ),
                            );

                            var ethereumData = homeProvider.cryptoList.firstWhere(
                                  (crypto) => crypto.cryptoType == 'ethereum',
                              orElse: () => CryptoLivePriceModel(
                                id: 0,
                                cryptoType: 'ethereum',
                                price: '0',
                                usd24hChange: '0',
                                createdAt: '',
                                updatedAt: '',
                              ),
                            );

                            var tetherData = homeProvider.cryptoList.firstWhere(
                                  (crypto) => crypto.cryptoType == 'tether',
                              orElse: () => CryptoLivePriceModel(
                                id: 0,
                                cryptoType: 'tether',
                                price: '0',
                                usd24hChange: '0',
                                createdAt: '',
                                updatedAt: '',
                              ),
                            );

                            // Extract price and usd24hChange
                            var bitcoinPrice = bitcoinData.price;
                            var bitcoinUsdChange = bitcoinData.usd24hChange;
                            var ethereumPrice = ethereumData.price;
                            var ethereumUsdChange = ethereumData.usd24hChange;
                            var tetherPrice = tetherData.price;
                            var tetherUsdChange = tetherData.usd24hChange;

                            var bitPrice = (bit_price==0)?bitcoinPrice:bit_price;
                            var ethPrice = (eth_price==0)?ethereumPrice:eth_price;
                            var usdtPrice = (usdt_price==0)?tetherPrice:usdt_price;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildInfoCard(ImageConstant.bit, 'BTC', bitPrice.toString(),
                                    bitcoinUsdChange, appTheme.orange, 'btcColor'),
                                _buildInfoCard(ImageConstant.eth, 'ETH', ethPrice.toString(),
                                    ethereumUsdChange, appTheme.color7CA, 'ethColor'),
                                _buildInfoCard(ImageConstant.t, 'USDT', usdtPrice.toString(),
                                    tetherUsdChange, appTheme.green, 'usdtColor'),
                              ],
                            );
                          }
                      ),

                          //   var bit_price = homeProvider.getPrice('BTC-USD');
                          //   var eth_price = homeProvider.getPrice('ETH-USD');
                          //   var usdt_price = homeProvider.getPrice('USDT-USD');
                          //
                          //   var bit_percentage = homeProvider.getPercentage('BTC-USD');
                          //   var eth_percentage = homeProvider.getPercentage('ETH-USD');
                          //   var usdt_percentage = homeProvider.getPercentage('USDT-USD');
                          //
                          // return Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       _buildInfoCard(ImageConstant.bit, 'BTC', bit_price.toString(),
                          //           bit_percentage, appTheme.orange, 'btcColor', 'bitcoin'),
                          //       _buildInfoCard(ImageConstant.eth, 'ETH', eth_price.toString(),
                          //         eth_percentage, appTheme.color7CA, 'ethColor', 'ethereum'),
                          //       _buildInfoCard(ImageConstant.t, 'USDT', usdt_price.toString(),
                          //         usdt_percentage, appTheme.green, 'usdtColor', 'tether'),
                          //     ],
                          // );
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent activity',
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
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                    if (provider.recenTransactionData == null || provider.recenTransactionData!.data.isEmpty) {
                                      return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
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
                                      String trxAmount = double.parse(tr.amount.toString()).toStringAsFixed(2);

                                      return _buildActivityCard(tr.receiverWalletAddress.toString(), cryptoType, '${trxAmount}',
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
                  backgroundColor: appTheme.drawerColor,
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
                                  // shape: BoxShape.circle,
                                  // color: appTheme.main,
                                  border: Border.all(width: 1, color: appTheme.main),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: ClipOval(
                                  child: (homeProvider.selfie!=null)? Image.network(Constants.imgUrl +homeProvider.selfie.toString(),
                                    width: 75, // Set the desired width
                                    height: 75, // Set the desired height
                                    fit: BoxFit.cover, // Adjust how the image should fit within its box
                                  ):CustomImageView(
                                    imagePath: ImageConstant.iconUser,
                                    width: 30,
                                    height: 30,
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
                                      // color: appTheme.color0071D0,
                                      color: appTheme.main_mpin,
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
                          color: appTheme.main_mpin,
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
                        color: appTheme.main_mpin,
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
            color: (homeProvider.isClicked==name)?appTheme.main_mpin:Colors.transparent,
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
              // authProvider.logout();
              PopupUtil().logOutPopUp(context, () {
                authProvider.logout();
                NavigatorService.pushNamedAndRemoveUntil(
                    AppRoutes.loginScreen);
              },);
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
            NavigatorService.pushNamed(redirect, argument: {'toAddress': '','cryptoType': 'USDT','amount': ''});
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
            gradient:  (themeProvider.themeType == 'lightCode'|| themeProvider.themeType == "system")?null:const LinearGradient(colors: [
              Color(0XFF5774CA), Color(0XFF445898)
            ])
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

  // Widget _buildInfoCard(
  //     img, String currency, String amount, String change, Color changeColor, percentColor, type) {
  Widget _buildInfoCard(
      img, String currency, String amount, String change, Color changeColor, percentColor) {
    return InkWell(
      onTap: ()async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? currentTheme = prefs.getString('themeData');
        String themeVal = (currentTheme=='darkCode')?'dark':'light';

        NavigatorService.pushNamed(AppRoutes.tradingViewChartPage, argument: {"type": currency, "theme": themeVal});
        // NavigatorService.pushNamed(AppRoutes.lineChartScreen, argument: {"type": type});

        // if(homeProvider.userStatus.toString() == 'Active' || homeProvider.userStatus.toString() == 'active'){
        //   var cryptoType = (currency=='BTC')?'Bitcoin':(currency=='ETH')?'Ethereum':'USDT';
        //   NavigatorService.pushNamed(AppRoutes.transferScreen, argument: {'toAddress': '', 'cryptoType': cryptoType, 'amount': ''});
        // }else{
        //   PopupUtil().popUp(context,"${homeProvider.userStatus.toString()}",
        //       CustomTextStyles.white17_400,
        //       "Your account is currently ${homeProvider.userStatus.toString()}."
        //   );
        // }

      },
      child: Container(
        width: SizeUtils.width / 3.52,
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: appTheme.white1,
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
                    text: '/USD',
                    style: CustomTextStyles.gray8_7272,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              amount,
              overflow: TextOverflow.ellipsis,
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
              fontSize: 11,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w200,
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
              fontSize: 11,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w200,
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
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              child: CustomImageView(
                fit: BoxFit.contain,
                imagePath: ImageConstant.arrowBottom,
                color: (themeProvider.themeType == "lightCode")?appTheme.blueDark:appTheme.white,
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
                  width: 140,
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
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: (status=='created')?appTheme.red:appTheme.green,
                      borderRadius: BorderRadius.circular(20,),
                    ),
                    child: Text(
                    (status=='created')?'PENDING':status.toUpperCase(),
                      style: CustomTextStyles.white_12,
                    ),
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
