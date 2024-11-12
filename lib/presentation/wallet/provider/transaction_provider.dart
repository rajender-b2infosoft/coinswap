import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto_app/core/app_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget.dart';
import '../../../services/api_service.dart';
import '../models/commission_settings.dart';
import 'package:http/http.dart' as http;

import '../models/commission_wallets.dart';


class TransactionProvider extends ChangeNotifier{
  final apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();

  bool _isDisposed = false;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;


  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> walletData = [];
  void setWalletData(List<dynamic> data) {
    walletData = data;
    notifyListeners();
  }

  double _commissionAmount = 0.0;
  double get commissionAmount => _commissionAmount;

  CommissionSettingsResponse? _commissionSettingsData;
  CommissionSettingsResponse? get commissionSettingsData => _commissionSettingsData;

  WalletResponse? _commissionWalletData;
  WalletResponse? get commissionWalletData => _commissionWalletData;
  List<Wallet> _walletCommissionData = [];
  List<Wallet> get walletCommissionData => _walletCommissionData;


  List<CommissionData> _commissionData = [];
  double adminCommissionAmount = 0.0;
  String adminAddress = '';
  List<CommissionData> get commissionData => _commissionData;

  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _noteController = TextEditingController();
  late TextEditingController _amountController = TextEditingController();

  TextEditingController get noteController => _noteController;
  TextEditingController get addressController => _addressController;
  TextEditingController get amountController => _amountController;

  double _cryptoCompareUSD = 0.0;
  double get cryptoCompareUSD => _cryptoCompareUSD;

  String _trxUserName = '';
  String get trxUserName => _trxUserName;

  TransactionProvider(){
    _addressController.addListener(() async {
      // var network = (_selectedCurrency == 'Ethereum')?"mainnet":(_selectedCurrency == 'USDT')?"mainnet":"mainnet";
      var network = (_selectedCurrency == 'Ethereum')?"sepolia":(_selectedCurrency == 'USDT')?"nile":"mainnet";
      var blockchain = (_selectedCurrency == 'Ethereum')?"ethereum":(_selectedCurrency == 'USDT')?"tron":"bitcoin";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userName = prefs.getString('userName');
      if(_addressController.text.length > 40){
        //verifying address
        validateAddress(_addressController.text, blockchain, network, userName);
      }
    });
  }

  setAddressController(String val)async{
    _addressController.text = val;
    notifyListeners();
  }

  setNoteController(String val){
    _noteController.text = val;
    notifyListeners();
  }

  dynamic _qrCodeData = '';
  // String _selectedCurrency = 'Ethereum';
  String _selectedCurrency = 'USDT';
  String get selectedCurrency => _selectedCurrency;

  String _chooseCurrency = 'ETH';
  String get chooseCurrency => _chooseCurrency;
  setChooseCurrency(val){
    _chooseCurrency=val;
    notifyListeners();
  }

  String _conversionCurrency = 'BTC';
  String get conversionCurrency => _conversionCurrency;
  setConversionCurrency(val){
    _conversionCurrency=val;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isValidWallet = false;
  bool get isValidWallet => _isValidWallet;

  setLoding(val){
    _isLoading = val;
    notifyListeners();
  }

  String _address = '';
  String _privateKey = '';
  String get address => _address;
  String get privateKey => _privateKey;


  bool _isTextEntered = false;
  bool get isTextEntered => _isTextEntered;

  String _ethBalance = '0.00';
  String get ethBalance => _ethBalance;
  String _btcBalance = '0';
  String get btcBalance => _btcBalance;
  String _usdtBalance = '0';
  String get usdtBalance => _usdtBalance;


  setEthBalance(val){
    _ethBalance = val;
    notifyListeners();
  }

  setAddress(val){
    _address = val;
    notifyListeners();
  }

  setPrivateKey(val){
    _privateKey = val;
    notifyListeners();
  }

  String _depositCurrency = 'USDT';
  String get depositCurrency => _depositCurrency;

  dynamic get qrCodeData => _qrCodeData;

  setdepositCurrency(val)async{
    _depositCurrency=val;
    notifyListeners();
  }

  setUserAddress(val)async{
      if(val == 'USDT'){
        _address = (await _secureStorage.read(key: 'tron'))!;
        notifyListeners();
      }else if(val == 'BTC'){
        _address = (await _secureStorage.read(key: 'bitcoin'))!;
        notifyListeners();
      }else if(val == 'ETH'){
        _address = (await _secureStorage.read(key: 'ethereum'))!;
        notifyListeners();
      }
  }

  setAmountController(val){
    _amountController.text += val;
    notifyListeners();
  }

  setCurrency(val){
    _selectedCurrency=val;
    notifyListeners();
  }

  setqrCodeData(val){
    _qrCodeData=val;
    notifyListeners();
  }

  sortCommission(data){

  }

  void onNumberPress(String number) {
    _amountController.text = _amountController.text + number;
    _isTextEntered = _amountController.text.isNotEmpty;
    notifyListeners();
  }

  void removeLastCharacter() {
    final currentText = _amountController.text;
    if (currentText.isNotEmpty) {
      _amountController.text = currentText.substring(0, currentText.length - 1);

      var blockchain = (_selectedCurrency=='Ethereum')?'eth':(_selectedCurrency=='USDT')?'usdt':'btc';
      _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain) ?? 0.0;

      notifyListeners();
    }
  }

 // Function to handle '0' button click
  void onZeroPress() {
    if (_amountController.text.isEmpty || _amountController.text != '0') {
      _amountController.text += '0';
      _isTextEntered = _amountController.text.isNotEmpty;

      var blockchain = (_selectedCurrency=='Ethereum')?'eth':(_selectedCurrency=='USDT')?'usdt':'btc';
      _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain) ?? 0.0;

      notifyListeners();
    }
  }

  void onDotPress() {
    if (!_amountController.text.contains('.')) {
      var blockchain = (_selectedCurrency=='Ethereum')?'eth':(_selectedCurrency=='USDT')?'usdt':'btc';
      if (_amountController.text.isEmpty) {
        _amountController.text = '0.';
        _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain) ?? 0.0;
      } else {
        _amountController.text += '.';
        _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain) ?? 0.0;
      }
      notifyListeners();
    }
  }

  void appendAmountController(String number) {
    _amountController.text += number;
    var blockchain = (_selectedCurrency=='Ethereum')?'eth':(_selectedCurrency=='USDT')?'usdt':'btc';
    _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain) ?? 0.0;
    notifyListeners();
  }

  Future<void> scanQRCode(blockchain) async {
    final scannedData = NavigatorService.pushNamed(AppRoutes.qRView, argument: {'blockchain': blockchain});
    if (scannedData != null) {
      _qrCodeData = scannedData;
    }
  }

  Future getSettings(context) async{
    try{
      final response = await apiService.getSettingsData();
      if (response != null && response['status'] == 'success') {
        _userData  = response['data'];
        // CommonWidget.showToastView(response['message'], appTheme.gray8989);
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // // New Function to get or update admin commission address based on wallet type
  // void updateAdminAddress(String walletType) {
  //   // Filter the wallets to find the one that matches the walletType and has default set to 1
  //   Wallet? matchedWallet = _walletCommissionData.firstWhere(
  //         (wallet) => wallet.walletType.toLowerCase() == walletType.toLowerCase() && wallet.defaultWallet == 1,
  //     orElse: () => Wallet(
  //       id: 0,
  //       userId: 0,
  //       vaultId: '',
  //       walletType: '',
  //       walletAddress: '',
  //       balance: '0.0',
  //       defaultWallet: 0,
  //       createdAt: DateTime.now(),
  //     ),
  //   );
  //
  //   // Set the admin address based on the filtered wallet
  //   if (matchedWallet.id != 0) {
  //     adminAddress = matchedWallet.walletAddress;
  //   } else {
  //     adminAddress = ''; // Set a default value if no matching wallet is found
  //   }
  //
  //   notifyListeners();
  // }

  // Function to determine commission amount based on blockchain and final amount
  void calculateCommission(String blockchain, double finalAmount) {
    if (blockchain == 'ethereum') {
      // Handle Ethereum case
      final ethCommission = _commissionData.firstWhere(
            (commission) => commission.cryptoType.toLowerCase() == 'eth',
        orElse: () => CommissionData(
          id: 0,
          cryptoType: 'eth',
          fromRange: 0,
          toRange: 0,
          commissionRate: 0.01,
          createdAt: '',
          updatedAt: null,
          deletedAt: null,
        ),
      );
      adminCommissionAmount = ethCommission.commissionRate;
      adminAddress = '0x50ad50e334f13d6bdda46ff7d800f2c1f3b3f64a'; // testing
    } else if (blockchain == 'tron') {
      // Handle Tron case dynamically using the API data
      final usdtCommission = _commissionData.firstWhere(
            (commission) =>
        commission.cryptoType.toLowerCase() == 'usdt' &&
            finalAmount >= commission.fromRange &&
            finalAmount < commission.toRange,
        orElse: () => CommissionData(
          id: 0,
          cryptoType: 'usdt',
          fromRange: 0,
          toRange: 0,
          commissionRate: 0.0,
          createdAt: '',
          updatedAt: null,
          deletedAt: null,
        ),
      );

      adminCommissionAmount = usdtCommission.commissionRate;
      adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw'; // testing
    } else {
      // Default case for other blockchains
      adminCommissionAmount = 0.0;
      adminAddress = '';
    }
    notifyListeners();
  }

  //Function for get admin commission wallet
  Future getCommissionWallets(type) async{
    try{
      final response = await apiService.getAdminCommissionWallets(type);
      if (response != null && response['status'] == 'success') {
        adminAddress = response['data'][0]['wallet_address'];
        notifyListeners();
      } else {
        print(response['message']);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future getCommissionSetting(context) async{
    try{
      final response = await apiService.getCommissionSettings();
      if (response != null && response['status'] == 'success') {
        final commissionSettings = CommissionSettingsResponse.fromJson(response);
        _commissionData = commissionSettings.data;
        notifyListeners();
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future sendOtp(context, email, type, page, walletAddress, cryptoType, cryptoAmount, note, fromAddress) async {
    _isLoading = true;
    notifyListeners();
    try{
      final response = await apiService.forgot_password(email, type);
      if (response != null && response['status'] == 'success') {
       NavigatorService.pushNamed(AppRoutes.transferOtp,
           argument: {'email': email, 'page': page, 'walletAddress': walletAddress, 'cryptoType': cryptoType, 'cryptoAmount': cryptoAmount, "note": note, "fromAddress": fromAddress}
       );
        // CommonWidget().snackBar(context, appTheme.green, response['message']);
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future verifyOtp(context, email, otp, type, address, cryptoType, amount, note, fromAddress) async{
    _isLoading = true;
    notifyListeners();
    try{
      final response = await apiService.verifyForgotPassword(email, otp, type);
      if (response != null && response['status'] == 'success') {

        // Get the current date
        DateTime now = DateTime.now();
        // Format the date as '23-Apr-2024'
        String formattedDate = DateFormat('dd-MMM-yyyy').format(now);

          var blockchain = (cryptoType == 'Ethereum')?"ethereum":(cryptoType == 'USDT')?"tron":"bitcoin";
          // var network = (cryptoType == 'Ethereum')?"mainnet":(cryptoType == 'USDT')?"mainnet":"mainnet";
          var network = (cryptoType == 'Ethereum')?"sepolia":(cryptoType == 'USDT')?"nile":"mainnet";

        var finalAmount = double.parse(amount);
        var ethCommission = 0.01;
        double amountAfterCommission = finalAmount;

        // var commissionAmount = 0.0;
        // var adminAddress = '';

        // var blockchain = "tron";
        //call function to calculate admin commission
        calculateCommission(blockchain, finalAmount);
        await getCommissionWallets(blockchain);

        // if(blockchain == 'ethereum'){
        //   commissionAmount = 0.01;
        //   adminAddress = '0x50ad50e334f13d6bdda46ff7d800f2c1f3b3f64a';  //testing
        //   // adminAddress = '0x3b5d925d4e229fce9407371507f9f2b5c7eb6621'; // live
        // }else if(blockchain == 'tron'){
        //   if(finalAmount >= 25000){
        //     commissionAmount = 5;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';   //live
        //   }else if(finalAmount <= 25000 && finalAmount >= 10000){
        //     commissionAmount = 3.2;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }else if(finalAmount <= 10000 && finalAmount >= 5000){
        //     commissionAmount = 2.5;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }else if(finalAmount >= 1000 && finalAmount <= 5000){
        //     commissionAmount = 1.5;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }else{
        //     //we can use it for bitcoin
        //     commissionAmount = 0.0;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }
        // }

        await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amount, 'slow', note, address, adminAddress, adminCommissionAmount);
        NavigatorService.pushNamed(AppRoutes.approvalScreen, argument: {'blockchain': blockchain,'status': 'pending',
          'address': fromAddress, 'amount': amount, 'fee': 'slow', 'note': note, 'date': formattedDate, 'page': 'home', 'trxId': '', 'toAddress':''});
      } else {
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyIfNotDisposed();
      // notifyListeners();
    }
  }

  Future checkMpin(context, pin, address, cryptoType, amount, note, fromAddress) async{
    try{
      final response = await apiService.verifyMpin(pin);
      if (response != null && response['status'] == 'success') {
        // Get the current date
        DateTime now = DateTime.now();
        // Format the date as '23-Apr-2024'
        String formattedDate = DateFormat('dd-MMM-yyyy').format(now);

        var blockchain = (cryptoType == 'Ethereum')?"ethereum":(cryptoType == 'USDT')?"tron":"bitcoin";
        // var network = (cryptoType == 'Ethereum')?"mainnet":(cryptoType == 'USDT')?"mainnet":"mainnet";
        var network = (cryptoType == 'Ethereum')?"sepolia":(cryptoType == 'USDT')?"nile":"mainnet";

        var finalAmount = double.parse(amount);
        var ethCommission = 0.01;
        double amountAfterCommission = finalAmount;

        var commissionAmount = 0.0;
        // var adminAddress = '';

        //call function to calculate admin commission
        calculateCommission(blockchain, finalAmount);
        await getCommissionWallets(blockchain);

        // updateAdminAddress(blockchain);

        // if(blockchain == 'ethereum'){
        //   commissionAmount = 0.01;
        //   adminAddress = '0x50ad50e334f13d6bdda46ff7d800f2c1f3b3f64a'; //testng
        //   // adminAddress = '0x3b5d925d4e229fce9407371507f9f2b5c7eb6621'; //live
        // }else if(blockchain == 'tron'){
        //   if(finalAmount >= 25000){
        //     commissionAmount = 5;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }else if(finalAmount <= 25000 && finalAmount >= 10000){
        //     commissionAmount = 3.2;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }else if(finalAmount <= 10000 && finalAmount >= 5000){
        //     commissionAmount = 2.5;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }else if(finalAmount >= 1000 && finalAmount <= 5000){
        //     commissionAmount = 1.5;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }else{
        //     //we can use it for bitcoin
        //     commissionAmount = 0.0;
        //     adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';  //testing
        //     // adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';  //live
        //   }
        // }


        await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amount, 'slow', note, address, adminAddress, adminCommissionAmount);
        // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amount, 'slow', note, address, adminAddress, commissionAmount);
        NavigatorService.pushNamed(AppRoutes.approvalScreen, argument: {'blockchain': blockchain,'status': 'pending', 'address': fromAddress, 'amount': amount,
          'fee': 'slow', 'note': note, 'date': formattedDate, 'page': 'home', 'trxId': '', 'toAddress':''});
      } else {
        CommonWidget.showToastView(response['message'], appTheme.red);
        // CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amount, fee, note, toAddress, adminAddress, commissionAmount) async{
    try{
      final response = await apiService.sendTransactioToAdmin(fromAddress, blockchain, network, amount, fee, note, toAddress, adminAddress, commissionAmount);
      if (response != null && response['status'] == 'success') {
        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      } else {
        CommonWidget.showToastView(response['message'], appTheme.red);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> validateAddress(address, blockchain, network, userName) async{
    try{
      final response = await apiService.verifyAddress(address, blockchain, network, userName);

      if (response != null && response['status'] == 'success') {
        if(!response['data']['data']['item']['isValid']){
          _isValidWallet = false;
          CommonWidget.showToastView('Please enter valid wallet address.', appTheme.red);
        }else{
          _isValidWallet = true;
        }
        notifyListeners();
        // CommonWidget.showToastView(response['message'], appTheme.gray8989);
      } else {
        CommonWidget.showToastView(response['message'], appTheme.red);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Function to get commission rate based on the input amount
  double? getCommissionRateForAmount(double amount, String cryptoType) {


    if (_commissionSettingsData == null || _commissionSettingsData!.data.isEmpty) {
      return null; // Return null if data is not available
    }

    // Loop through the list of commission settings
    for (var setting in _commissionSettingsData!.data) {
      // Check the crypto type
      if (setting.cryptoType == cryptoType) {
        if (cryptoType == 'btc' || cryptoType == 'eth') {
          // For btc and eth, return the commission rate directly without range check
          return setting.commissionRate;
        } else if (cryptoType == 'usdt') {
          if(amount <= 1000){
            return 0.0;
          }
          // For usdt, check if the amount is within the range
          if (amount >= setting.fromRange && amount < setting.toRange) {
            return setting.commissionRate;
          }
        }
      }
    }

    return null; // Return null if no matching range or crypto_type is found
  }

  Future<void> userWalletData() async {
    _isLoading = true;
    notifyListeners();
    try{
      final response = await apiService.getUserProfile();
      //check response
      if (response != null && response['status'] == 'success') {
        //get wallet data and set in list
        if(response['data'].length > 0){
          setWalletData(response['data']);
        }
      }else {
        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      }
    }catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Check balance for a specific crypto_type
  bool checkBalance(String cryptoType, double amountToSend) {
    try {
      cryptoType = (cryptoType=='usdt')?'tron':cryptoType;
      final wallet = walletData.firstWhere(
            (wallet) => wallet['crypto_type'] == cryptoType,
      );
      // double userBalance = double.parse(wallet['balance']);

      // Check if `balance` is an int or double, then convert to double
      double userBalance;
      if (wallet['balance'] is int) {
        userBalance = (wallet['balance'] as int).toDouble();
      } else if (wallet['balance'] is String) {
        userBalance = double.parse(wallet['balance']);
      } else {
        userBalance = wallet['balance']; // Already a double
      }

      return userBalance >= amountToSend;
    } catch (e) {
      print('---------------catch-----------userBalance$e');
      // If no wallet found, return false
      return false;
    }
  }

  Future<void> userWalletConvertedBalance() async {
    _isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    try{
      final response = await apiService.getUserBalance(userId);
      //check response
      if (response != null && response['status'] == 'success') {
        //get user all 3 wallets total to display on home page
        if(response['data'].length > 0){
          //get user all 3 wallets total to display on home page
          _ethBalance = response['data'][0]['eth'].toString();
          _btcBalance = response['data'][0]['btc'].toString();
          _usdtBalance = response['data'][0]['usdt'].toString();
        }
      }else {
        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      }
    }catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cryptocompare(String type) async {
    final url = Uri.parse(
        'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Update the price if the API returns the correct data
        if (data['USD'] != null) {
          _cryptoCompareUSD = data['USD'];
        } else {
          _cryptoCompareUSD = 0.0;
        }
      } else {
        throw Exception('Failed to load price');
      }
    } catch (error) {
      print('Error fetching ETH price: $error');
      _cryptoCompareUSD = 0.0;
    }
    // Notify listeners about the data change
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void notifyIfNotDisposed() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
}