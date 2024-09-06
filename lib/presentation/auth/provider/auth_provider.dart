import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../common_widget.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/navigation_service.dart';
import '../../../routes/app_routes.dart';
import '../../../services/encryption_service.dart';
import '../../../services/socketService.dart';
import '../../../services/webSocketClient.dart';
import '../../../theme/theme_helper.dart';
import '../../home_screen_page/provider/home_screen_provider.dart';
import '../models/login_screen_model.dart';
import '../models/request_otp.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';


class AuthProvider with ChangeNotifier {
  final apiService = ApiService();
  late HomeScreenProvider homeProvider;

  final EncryptionService _encryptionService = EncryptionService();
  late LoginModel _loginModel;
  LoginModel? get loginModel => _loginModel;
  // final WebSocketClient _webSocketClient = WebSocketClient();
  final SocketIOClient _webSocketClient = SocketIOClient();

  AuthProvider() {
    _initializeEncryptionService();
  }

  Future<void> _initializeEncryptionService() async {
    try {
      await _encryptionService.initialize();
      notifyListeners();
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  bool _isLoading = false;
  bool _privacy_policy = false;
  bool get isLoading => _isLoading;
  bool get privacy_policy => _privacy_policy;

  setLoding(val){
    _isLoading = val;
    notifyListeners();
  }

  bool _obscureText = true;
  bool get obscureText => _obscureText;
  void setObscureText() {
    _obscureText = !_obscureText;;
    notifyListeners();
  }

  void setPrivacyPolicy(val) {
    _privacy_policy = val;
    notifyListeners();
  }

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get nameController => _nameController;

  Future verifyLoginOtp(context, email, password, otp) async{
    try{
      final response = await apiService.verifyLoginOtp(email, password, otp);

      print('............response..................$response');

      if(response['status'] == 'success'){
        LoginModel loginData = LoginModel.fromJson(response);

        CommonWidget.showToastView(response['message'], appTheme.gray8989);
        var decryptUsername = apiService.decryptData(loginData.data!.username!, apiService.encryptKey, apiService.iv);
        var decryptEmail = apiService.decryptData(loginData.data!.email!, apiService.encryptKey, apiService.iv);

        // Save login details to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', loginData.data!.token!);
        await prefs.setString('role', loginData.data!.role!);
        // await prefs.setString('userName', loginData.data!.username!);
        // await prefs.setString('email', loginData.data!.email!);
        await prefs.setString('userName', decryptUsername);
        await prefs.setString('email', decryptEmail);

        print('::::::::::::::::::loginData.data:::::::::::::::::::::::++++');
        print(loginData.data!.status!);

        var status = (loginData.data!.status! == 'under_review')?'Under Review':(loginData.data!.status! == 'inactive')?'Inactive':(loginData.data!.status! == 'active')?'Active':'Suspended';

        await prefs.setString('status', status);
        // await prefs.setString('status', loginData.data!.status!);
        await prefs.setInt('user_id', loginData.data!.userId!);

        print('result===nnneeewwww=>>>>>1212121${loginData.data!.role}');

        // Navigate to the next screen or perform actions based on role
        if (loginData.data!.role == 'user') {
          // NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
          await getUserInfoByID(loginData.data!.userId!);

          _webSocketClient.connectSocket(loginData.data!.token!,loginData.data!.userId!.toString(), context, homeProvider);
        } else {
          NavigatorService.pushNamed(AppRoutes.loginScreen);
        }
      }else{
        print('result====>>>>>');
        print('result====>>>>>1212121');

        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future login(context, String email, String password) async {
    _isLoading = true;
    try{
      final response = await apiService.userLogin(email, password);

      print('${response['message']}+++++++++++++++++++++++++++++++++++++${response}');

      if (response != null && response['status'] == 'success') {

        CommonWidget().snackBar(context, appTheme.green, response['message']);
        print(response);
        // Future.delayed(Duration(seconds: 2), () {
          NavigatorService.pushNamed(AppRoutes.verifyOtp,
              argument: {
                'username': email,
                'password': password,
                'name': '',
                'type': 'login',
                'privacy_policy': true
              });
        // });
      }else{
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch (e) {
      // _errorMessage = "An error occurred: $e";
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future resendLogin(context, String email, String password) async {
    _isLoading = true;
    try{
      final response = await apiService.userLogin(email, password);
      if (response != null && response['status'] == 'success') {
        CommonWidget().snackBar(context, appTheme.green, response['message']);
      }else{
        CommonWidget().snackBar(context, appTheme.red, response['message']);
      }
    }catch (e) {
      // _errorMessage = "An error occurred: $e";
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future requestOtp(context, RequestOtp requestOtp) async {
    _isLoading = true;
    notifyListeners();
    var data = requestOtp.toJson();
    try{
      final response = await apiService.requestOtp(data);
      if (response != null && response['status'] != 'error') {
        CommonWidget().snackBar(context, appTheme.green, response['message']);
        // Future.delayed(const Duration(seconds: 1), () {
          NavigatorService.pushNamed(AppRoutes.verifyOtp,
              argument: {'username': data['username'], 'password': data['password'], 'name': data['name'], 'type': 'register', 'privacy_policy': data['privacy_policy']});
        // });
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
  Future resendRequestOtp(context, RequestOtp requestOtp) async {
    _isLoading = true;
    notifyListeners();
    var data = requestOtp.toJson();
    try{
      final response = await apiService.requestOtp(data);
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

  Future verifyOtp(context, RequestOtp requestOtp, otp) async{
    var data = requestOtp.toJson();
    try{
      final response = await apiService.verifyOtp(data, otp);

      if(response['status'] == 'success'){

        LoginModel loginData = LoginModel.fromJson(response);
        CommonWidget.showToastView(response['message'], appTheme.gray8989);

        HtmlUnescape unescape = HtmlUnescape();
        String decodedData = unescape.convert(loginData.data!.email!.replaceAll('&#x2F;', '/'));

        var decryptUsername = apiService.decryptData(loginData.data!.username!, apiService.encryptKey, apiService.iv);
        var decryptEmail = apiService.decryptData(decodedData, apiService.encryptKey, apiService.iv);

        // Save login details to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', loginData.data!.token!);
        await prefs.setString('role', loginData.data!.role!);
        // await prefs.setString('userName', loginData.data!.username!);
        // await prefs.setString('email', loginData.data!.email!);
        await prefs.setString('userName', decryptUsername);
        await prefs.setString('email', decryptEmail);
        await prefs.setString('status', 'Under Review');
        await prefs.setInt('user_id', loginData.data!.userId!);

        NavigatorService.pushNamed(AppRoutes.verifyIdentity);
       _webSocketClient.connectSocket(loginData.data!.token!,loginData.data!.userId!.toString(), context, homeProvider);
      }else{
        CommonWidget.showToastView(response['message'], appTheme.gray8989);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getUserInfoByID(id) async{
    try{
      final response = await apiService.getUserInfoByID(id);
      if(response['status'] == 'success'){
        List<dynamic> documents = response['data'];
        // Check if 'aadhar', 'passport', and 'selfie' document types exist
        bool hasAadhar = documents.any((doc) => doc['document_type'] == 'aadhar');
        bool hasPassport = documents.any((doc) => doc['document_type'] == 'passport');
        bool hasSelfie = documents.any((doc) => doc['document_type'] == 'selfie');
        // Redirect based on the conditions
        if (!hasAadhar && !hasPassport) {
          // If neither 'aadhar' nor 'passport' is uploaded, redirect to the document upload page
          NavigatorService.pushNamed(AppRoutes.verifyIdentity);
        } else if (!hasSelfie) {
          // If 'selfie' is not uploaded, redirect to the selfie upload page
          NavigatorService.pushNamed(AppRoutes.uploadSelfie);
        } else {
          // If all required documents are uploaded, redirect to the home screen
          NavigatorService.pushNamed(AppRoutes.homeScreen);
        }
      }else{
        NavigatorService.pushNamed(AppRoutes.loginScreen);
      }
    }catch(e){
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  //Function for logout remove all data from shared preferences
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
    NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

}
