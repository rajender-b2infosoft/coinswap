import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crypto_app/core/app_export.dart';
import 'package:flutter/cupertino.dart';
import '../../../common_widget.dart';
import '../../../services/api_service.dart';


class TransactionProvider extends ChangeNotifier{
  final apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();

  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _amountController = TextEditingController();

  TextEditingController get addressController => _addressController;
  TextEditingController get amountController => _amountController;

  setAddressController(String val){
    _addressController.text = val;
    notifyListeners();
  }

  dynamic _qrCodeData = '';
  String _selectedCurrency = 'Ethereum';
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

  setdepositCurrency(val){
    _depositCurrency=val;
    notifyListeners();
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

  // final Map<String, String> assign_plans = {
  //   'ETH': 'ETH',
  //   'Bit': 'Bit',
  //   'USDT': 'USDT'
  // };

  void onNumberPress(String number) {
    _amountController.text = _amountController.text + number;
    _isTextEntered = _amountController.text.isNotEmpty;
    notifyListeners();
  }

  void removeLastCharacter() {
    final currentText = _amountController.text;
    if (currentText.isNotEmpty) {
      _amountController.text = currentText.substring(0, currentText.length - 1);
      notifyListeners();
    }
  }
// Function to handle '0' button click
  void onZeroPress() {
    if (_amountController.text.isEmpty || _amountController.text != '0') {
      _amountController.text += '0';
      _isTextEntered = _amountController.text.isNotEmpty;
      notifyListeners();
    }
  }

  void onDotPress() {
    if (!_amountController.text.contains('.')) {
      if (_amountController.text.isEmpty) {
        _amountController.text = '0.';
      } else {
        _amountController.text += '.';
      }
      notifyListeners();
    }
  }

  void appendAmountController(String number) {
    _amountController.text += number;
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



  Future<void> scanQRCode() async {
    final scannedData = NavigatorService.pushNamed(AppRoutes.qRView);
    if (scannedData != null) {
      _qrCodeData = scannedData;
    }
  }

}