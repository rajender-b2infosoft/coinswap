import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../../common_widget.dart';
import '../../../services/api_service.dart';
import '../../../theme/theme_helper.dart';
import '../models/transaction.dart';


class TransactionScreenProvider extends ChangeNotifier{
  final apiService = ApiService();

  Transaction? _transactionData;
  Transaction? get transactionData => _transactionData;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String _isButton = 'sent';
  String get isButton => _isButton;

  setIsButton(val){
    _isButton = val;
    if(val=='sent'){
      transactionsData('dr','','');
    }else{
      transactionsData('cr','','');
    }
    notifyListeners();
  }

  String _type = 'Select Type';
  String get type => _type;

  setType(val){
    _type = val;
    notifyListeners();
  }

  String _status = 'Pending';
  String get status => _status;

  setStatus(val){
    _status = val;
    notifyListeners();
  }

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }


  Future<void> transactionsData(type, status, date) async {
    String formattedDate ='';
    if(date != ''){
      DateTime parsedDate = DateFormat('yyyy-dd-MM').parse(date); // Parse the date
      formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    }
    _isLoading = true;
    _errorMessage = null;
    _transactionData = null;
    notifyListeners();

    try{
      final response = await apiService.getTransactions(type, status, formattedDate);
      //check response
      if (response != null && response['status'] == 'success') {

        _transactionData = Transaction.fromJson(response);

        // CommonWidget.showToastView(response?['message'], appTheme.gray8989);
        notifyListeners();
      }else {
        _errorMessage = response?['message'];
        // CommonWidget.showToastView(response?['message'], appTheme.gray8989);
      }
    }catch (e) {
      _errorMessage = "An error occurred: $e";
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}