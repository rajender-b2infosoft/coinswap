import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_app/core/app_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget.dart';
import '../../../services/api_service.dart';
import '../models/commission_settings.dart';


class TransactionProvider extends ChangeNotifier{
  final apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();

  bool _isDisposed = false;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;


  List<dynamic> walletData = [];
  void setWalletData(List<dynamic> data) {
    walletData = data;
    notifyListeners();
  }

  double _commissionAmount = 0.0;
  double get commissionAmount => _commissionAmount;

  CommissionSettingsResponse? _commissionSettingsData;
  CommissionSettingsResponse? get commissionSettingsData => _commissionSettingsData;

  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _noteController = TextEditingController();
  late TextEditingController _amountController = TextEditingController();

  TextEditingController get noteController => _noteController;
  TextEditingController get addressController => _addressController;
  TextEditingController get amountController => _amountController;

  TransactionProvider(){
    _addressController.addListener(() async {
      var network = (_selectedCurrency == 'Ethereum')?"mainnet":(_selectedCurrency == 'USDT')?"mainnet":"mainnet";
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
      _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain)!;

      notifyListeners();
    }
  }

 // Function to handle '0' button click
  void onZeroPress() {
    if (_amountController.text.isEmpty || _amountController.text != '0') {
      _amountController.text += '0';
      _isTextEntered = _amountController.text.isNotEmpty;

      var blockchain = (_selectedCurrency=='Ethereum')?'eth':(_selectedCurrency=='USDT')?'usdt':'btc';
      _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain)!;

      notifyListeners();
    }
  }

  void onDotPress() {
    if (!_amountController.text.contains('.')) {
      var blockchain = (_selectedCurrency=='Ethereum')?'eth':(_selectedCurrency=='USDT')?'usdt':'btc';
      if (_amountController.text.isEmpty) {
        _amountController.text = '0.';
        _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain)!;
      } else {
        _amountController.text += '.';
        _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain)!;
      }
      notifyListeners();
    }
  }

  void appendAmountController(String number) {
    _amountController.text += number;
    var blockchain = (_selectedCurrency=='Ethereum')?'eth':(_selectedCurrency=='USDT')?'usdt':'btc';


    _commissionAmount  = getCommissionRateForAmount(double.parse(_amountController.text), blockchain)!;

    print('::::::::::::::::::::::::::::');
    print(_commissionAmount);
    print(blockchain);

    notifyListeners();
  }

  // Future sendETH(context, toAddress,privateKey,amountInEth) async {
  Future sendETH(context, toAddress,type,amountInEth) async {
    _isLoading = true;
    notifyListeners();
    try{
      // final response = await apiService.sendAmount(toAddress,privateKey,amountInEth);
      final response = await apiService.sendAmount(toAddress,type,amountInEth);

      if (response != null && response['status'] != 'error') {
        CommonWidget().snackBar(context, appTheme.green, response['message']);

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

  Future<void> getEthBalance(
      String address,
      String chain,
      ) async {
    final String apiUrl = 'https://deep-index.moralis.io/api/v2/$address/balance?chain=$chain';
    const String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6ImU3NDNhYzg1LTA5ZTctNGQ3Ni05MmNkLWQ1ZDJkMGEwNTg5ZSIsIm9yZ0lkIjoiNDA0Njk2IiwidXNlcklkIjoiNDE1ODM4IiwidHlwZUlkIjoiN2I1NDdlZTAtNzllZS00OTJmLWE5NTItY2E3MTU5ODY2NjI5IiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3MjM2OTYyOTMsImV4cCI6NDg3OTQ1NjI5M30.aTBXhoxJ1PhDWn7UpVwwImqV7_zgbsiJN8Pq62eaBYs";

    final url = Uri.parse('$apiUrl');
    final headers = {
      'X-API-Key': apiKey,
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _secureStorage.write(key: 'ethBalance', value: data['balance']);
    } else {
      throw Exception('Failed to send ETH. Error: ${response.body}');
    }
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

  Future getCommissionSetting(context) async{
    try{
      final response = await apiService.getCommissionSettings();
      if (response != null && response['status'] == 'success') {
        _commissionSettingsData  = CommissionSettingsResponse.fromJson(response);
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
          var network = (cryptoType == 'Ethereum')?"mainnet":(cryptoType == 'USDT')?"mainnet":"mainnet";

        var finalAmount = double.parse(amount);
        var ethCommission = 0.01;
        double amountAfterCommission = finalAmount;

        var commissionAmount = 0.0;
        var adminAddress = '';

        if(blockchain == 'ethereum'){
          commissionAmount = 0.01;
          // adminAddress = '0x50ad50e334f13d6bdda46ff7d800f2c1f3b3f64a';
          adminAddress = '0x3b5d925d4e229fce9407371507f9f2b5c7eb6621';
          print('11111111111111111111111111111');
          // amountAfterCommission = finalAmount - ethCommission;
          // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
          // await Future.delayed(Duration(seconds: 1));
          // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, ethCommission, 'slow', note, '0x50ad50e334f13d6bdda46ff7d800f2c1f3b3f64a');
        }else if(blockchain == 'tron'){
          if(finalAmount >= 25000){
            commissionAmount = 5;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('22222222222222222222222222');
            // amountAfterCommission = finalAmount - 5;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
            // await Future.delayed(Duration(seconds: 1));
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, 5, 'slow', note, 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw');
          }else if(finalAmount <= 25000 && finalAmount >= 10000){
            commissionAmount = 3.2;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('333333333333333333333333333');
            // amountAfterCommission = finalAmount - 3.2;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
            // await Future.delayed(Duration(seconds: 1));
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, 3.2, 'slow', note, 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw');
          }else if(finalAmount <= 10000 && finalAmount >= 5000){
            commissionAmount = 2.5;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('444444444444444444444');
            // amountAfterCommission = finalAmount - 2.5;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
            // await Future.delayed(Duration(seconds: 1));
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, 2.5, 'slow', note, 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw');
          }else if(finalAmount >= 1000 && finalAmount <= 5000){
            commissionAmount = 1.5;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('55555555555555555555');
            // amountAfterCommission = finalAmount - 1.5;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
            // await Future.delayed(Duration(seconds: 1));
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, 1.5, 'slow', note, 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw');
          }else{
            //we can use it for bitcoin
            commissionAmount = 0.0;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('666666666666666666666666');
            // amountAfterCommission = finalAmount;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
          }
        }

        // await sendETH(context,address,type,amount);
        await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amount, 'slow', note, address, adminAddress, commissionAmount);
        NavigatorService.pushNamed(AppRoutes.approvalScreen, argument: {'blockchain': blockchain,'status': 'pending', 'address': fromAddress, 'amount': amount, 'fee': 'slow', 'note': note, 'date': formattedDate, 'page': 'home'});

        // NavigatorService.pushNamedAndRemoveUntil(AppRoutes.transferScreen, argument: {'toAddress': address, 'cryptoType': cryptoType, 'amount': amount});
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
        // NavigatorService.pushNamedAndRemoveUntil(AppRoutes.transferScreen, argument: {'toAddress': address, 'cryptoType': cryptoType, 'amount': amount});
        // CommonWidget().snackBar(context, appTheme.green, response['message']);
        // var type = (cryptoType == 'Ethereum')?"eth":"usdt";


        // Get the current date
        DateTime now = DateTime.now();
        // Format the date as '23-Apr-2024'
        String formattedDate = DateFormat('dd-MMM-yyyy').format(now);

        var blockchain = (cryptoType == 'Ethereum')?"ethereum":(cryptoType == 'USDT')?"tron":"bitcoin";
        var network = (cryptoType == 'Ethereum')?"mainnet":(cryptoType == 'USDT')?"mainnet":"mainnet";

        var finalAmount = double.parse(amount);
        var ethCommission = 0.01;
        double amountAfterCommission = finalAmount;

        var commissionAmount = 0.0;
        var adminAddress = '';

        if(blockchain == 'ethereum'){
          commissionAmount = 0.01;
          // adminAddress = '0x50ad50e334f13d6bdda46ff7d800f2c1f3b3f64a';
          adminAddress = '0x3b5d925d4e229fce9407371507f9f2b5c7eb6621';
          print('11111111111111111111111111111');
          // amountAfterCommission = finalAmount - ethCommission;
          // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
          // await Future.delayed(Duration(seconds: 1));
          // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, ethCommission, 'slow', note, '0x50ad50e334f13d6bdda46ff7d800f2c1f3b3f64a');
        }else if(blockchain == 'tron'){
          if(finalAmount >= 25000){
            commissionAmount = 5;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('22222222222222222222222222');
            // amountAfterCommission = finalAmount - 5;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
            // await Future.delayed(Duration(seconds: 1));
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, 5, 'slow', note, 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw');
          }else if(finalAmount <= 25000 && finalAmount >= 10000){
            commissionAmount = 3.2;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('333333333333333333333333333');
            // amountAfterCommission = finalAmount - 3.2;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
            // await Future.delayed(Duration(seconds: 1));
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, 3.2, 'slow', note, 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw');
          }else if(finalAmount <= 10000 && finalAmount >= 5000){
            commissionAmount = 2.5;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('444444444444444444444');
            // amountAfterCommission = finalAmount - 2.5;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
            // await Future.delayed(Duration(seconds: 1));
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, 2.5, 'slow', note, 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw');
          }else if(finalAmount >= 1000 && finalAmount <= 5000){
            commissionAmount = 1.5;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('55555555555555555555');
            // amountAfterCommission = finalAmount - 1.5;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
            // await Future.delayed(Duration(seconds: 1));
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, 1.5, 'slow', note, 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw');
          }else{
            //we can use it for bitcoin
            commissionAmount = 0.0;
            // adminAddress = 'TTXeityJb4vsLNDepDi583NwioiYy7ixRw';
            adminAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
            print('666666666666666666666666');
            // amountAfterCommission = finalAmount;
            // await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amountAfterCommission, 'slow', note, address);
          }
        }


        await sendTransactionForAdminApproval(context, fromAddress, blockchain, network, amount, 'slow', note, address, adminAddress, commissionAmount);
        NavigatorService.pushNamed(AppRoutes.approvalScreen, argument: {'blockchain': blockchain,'status': 'pending', 'address': fromAddress, 'amount': amount, 'fee': 'slow', 'note': note, 'date': formattedDate, 'page': 'home'});

        // await sendETH(context,address,type,amount);
        // NavigatorService.pushNamedAndRemoveUntil(AppRoutes.transferScreen, argument: {'toAddress': address, 'cryptoType': cryptoType, 'amount': amount, 'note': note});
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

    print('>>>>>>>>>>>>>>>>>>>>>>>>>>amount');
    print(amount);
    print(amount.runtimeType);
    print(cryptoType);

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