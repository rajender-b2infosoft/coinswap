import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../core/utils/navigation_service.dart';
import '../routes/app_routes.dart';


class ApiService {
  String access_token = "";
  var encryptKey = '8404f6267a57b05c45195c6b889b487dc13c451ca67d9eb5e6e0fd1f8817b75b';
  final iv = '1234567890abcdef1234567890abcdef';


  //Create common function for post request endpoint name and body data need
  Future<Map<String, dynamic>?> post(String endpoint, data) async {
    try{
      access_token = await getAccessToken();
      var headerData = {
        "device_id": '12345',
        "authorization": "Bearer $access_token",
        "content-type": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials":
        "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      };

      print("$access_token ------------------------>${Constants.baseUrl + endpoint}");
      print(data);

      final response = await http.post(Uri.parse(Constants.baseUrl + endpoint),
          headers: headerData, body: data);

      print("+++++++++++++response++++++++1212++++++${response}");

      print("+++++++++++++response.body++++++++++++++${response.body}");

      // Decode the response body
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }else {
        // Handle validation errors or other errors
        if (responseBody['status'] == 'error') {
          // Collect all error messages
          List<String> errorMessages = [];
          for (var error in responseBody['data']) {
            errorMessages.add(error['message']);
          }
          // Return or handle the error messages
          return {'status': 'error', 'message': errorMessages[0]};
        } else if(responseBody['status'] == 'failure') {
          // Handle other errors
          return {'status': 'error', 'message': responseBody['message']};
        } else if(responseBody['status'] == 'bad_request') {
          // Handle other errors
          return {'status': 'error', 'message': responseBody['message']};
        }else {
          // Handle other errors
          return {'status': 'error', 'message': 'Unknown error occurred'};
        }
      }
    }catch(e){
      return {'status': 'error', 'message': "Server error $e"};
    }
  }

  // Get access token from shared preferences
  Future getAccessToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      if(accessToken == null){
        return "";
      }else{
        return accessToken;
      }

    } catch (e) {
      print("Error(Function getAccessToken): $e");
      return '';
    }
  }

  Future userLogin(String email, String password) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        // 'username': email,
        'username': encryptData(email, encryptKey, iv),
        'password': password
      });
      final response = await post('auth/login', data);
      return response;
    } catch (e) {
      print("Error(Function userLogin):$e");
      return e.toString();
    }
  }

  Future requestOtp(req) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        // 'username': req['username'],
        'username': encryptData(req['username'], encryptKey, iv),
        'password': req['password'],
        'name': encryptData(req['name'], encryptKey, iv),
        'privacy_policy': req['privacy_policy']
      });
      final response = await post('auth/request_otp', data);
      return response;
    } catch (e) {
      print("Error(Function requestOtp):$e");
      return e.toString();
    }
  }

  Future forgot_password(email, type) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        'username': encryptData(email, encryptKey, iv),
        'type': type
      });
      final response = await post('auth/forgot-password', data);
      return response;
    } catch (e) {
      print("Error(Function forgot_password):$e");
      return e.toString();
    }
  }

  Future verifyForgotPassword(email, otp, type) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        'username': encryptData(email, encryptKey, iv),
        'otp': otp,
        'type': type
      });
      final response = await post('auth/forgot-password', data);
      return response;
    } catch (e) {
      print("Error(Function verifyForgotPassword):$e");
      return e.toString();
    }
  }

  Future changePassword(email, type, newPassword, confirmPassword) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        'username': encryptData(email, encryptKey, iv),
        'type': type,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });
      final response = await post('auth/forgot-password', data);
      return response;
    } catch (e) {
      print("Error(Function changePassword):$e");
      return e.toString();
    }
  }

  Future setMpinMobile(pin) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        // 'mpin': pin,
        'mpin': encryptData(pin, encryptKey, iv),
        'type': 'set_pin',
      });
      final response = await post('api/set-Mpin', data);
      return response;
    } catch (e) {
      print("Error(Function setMpinMobile):$e");
      return e.toString();
    }
  }


  Future verifyMpin(pin) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        'pin': encryptData(pin, encryptKey, iv),
      });
      final response = await post('api/check-mpin', data);
      return response;
    } catch (e) {
      print("Error(Function setMpinMobile):$e");
      return e.toString();
    }
  }

  Future getMpinData() async {
    try {
      final response = await get('api/get-Mpin');
      return response;
    } catch (e) {
      print("Error(Function getMpinStatus):$e");
      return e.toString();
    }
  }

  Future setMpinStatus(status) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        'status': status,
        'type': 'active_pin',
      });
      final response = await post('api/set-Mpin', data);
      return response;
    } catch (e) {
      print("Error(Function setMpinStatus):$e");
      return e.toString();
    }
  }

  Future getTransactions(type, status, date) async {
    try {
      final response = await get('api/transactions?type=$type&status=$status&date=$date');
      return response;
    } catch (e) {
      print("Error(Function getTransactions):$e");
      return e.toString();
    }
  }

  Future getRecentTransactions() async {
    try {
      final response = await get('api/recent-transactions-list');
      return response;
    } catch (e) {
      print("Error(Function getRecentTransactions):$e");
      return e.toString();
    }
  }

  Future getUserProfile() async {
    try {
      final response = await get('api/user-profile');
      return response;
    } catch (e) {
      print("Error(Function getUserProfile):$e");
      return e.toString();
    }
  }

  Future setSettings(status, type) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        'status': status,
        'type': type,
      });
      final response = await post('api/user-setting', data);
      return response;
    } catch (e) {
      print("Error(Function setMpinStatus):$e");
      return e.toString();
    }
  }

  Future getSettingsData() async {
    try {
      final response = await get('api/user-setting');
      return response;
    } catch (e) {
      print("Error(Function getSettingsData):$e");
      return e.toString();
    }
  }

  Future getCommissionSettings() async {
    try {
      final response = await get('api/commission-setting');
      return response;
    } catch (e) {
      print("Error(Function getCommissionSettings):$e");
      return e.toString();
    }
  }

  Future sendAmount(toAddress,type,amountInEth) async {
    try {
      // dynamic data = jsonEncode(<dynamic, dynamic>{
      //   'toAddress': toAddress,
      //   'privateKey': privateKey,
      //   'amountInEth': amountInEth
      // });

      dynamic data = jsonEncode(<dynamic, dynamic>{
        'destinationAddressId': toAddress,
        'assetType': type,
        'amount': amountInEth,
        "gasless": true
      });
      final response = await post('api/sendETH', data);
      return response;
    } catch (e) {
      print("Error(Function sendAmount):$e");
      return e.toString();
    }
  }

  Future verifyOtp(req, otp) async {

    print('EncryData'+encryptData(req['username'], encryptKey, iv).toString());

    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        // 'username': req['username'],
        'username': encryptData(req['username'], encryptKey, iv),
        'password': req['password'],
        // 'name': req['name'],
        'name': encryptData(req['name'], encryptKey, iv),
        'privacy_policy': req['privacy_policy'],
        'otp': otp
      });

      print('EncryData'+data.toString());

      final response = await post('auth/verify-otp', data);
      return response;
    } catch (e) {
      print("Error(Function verify-otp): $e");
      return e.toString();
    }
  }

  Future verifyLoginOtp(email, password, otp) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        // 'username': email,
        'username': encryptData(email, encryptKey, iv),
        'password': password,
        'otp': otp
      });
      final response = await post('auth/verify-login', data);
      return response;
    } catch (e) {
      print("Error(Function verifyLoginOtp): $e");
      return e.toString();
    }
  }

  Future<Map<String, dynamic>?> uploadSelfie(File file, type) async {
    try {
      var accessToken = await getAccessToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.baseUrl}auth/upload-document'),
      );
      // Add headers to the request
      request.headers.addAll({
        "device_id": '12345',
        "authorization": "Bearer $accessToken",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      });
      // Add userId to the request
      // request.fields['userId'] = userId.toString();
      request.fields['document_type'] = type;
      request.fields['status'] = 'pending';


      if (file != null) {
        final mimeType = lookupMimeType(file.path);
        request.files.add(
          await http.MultipartFile.fromPath('file', file.path, contentType: MediaType.parse(mimeType!)),
        );
      }

      // Send the request
      final streamedResponse  = await request.send();


      // Convert the streamed response into a regular HTTP response
      final response = await http.Response.fromStream(streamedResponse);


      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error uploading selfie: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> uploadImages(List<File> images) async {
    var accessToken = await getAccessToken();
    final uri = Uri.parse('${Constants.baseUrl}auth/upload-document');
    final request = http.MultipartRequest('POST', uri);
    // Add headers to the request
    request.headers.addAll({
      "device_id": '12345',
      "authorization": "Bearer $accessToken",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    });
    for (var image in images) {
      final fileStream = http.ByteStream(image.openRead());
      final length = await image.length();
      if (image != null) {
        final mimeType = lookupMimeType(image.path);
        request.files.add(
          await http.MultipartFile.fromPath('file', image.path, contentType: MediaType.parse(mimeType!)),
        );
      }
    }
    try {
      final streamedResponse = await request.send();
      // Convert the streamed response into a regular HTTP response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // final responseBody = await response.stream.bytesToString();
        return json.decode(response.body);
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Upload failed: $e');
    }
  }

  Future<Map<String, dynamic>?> deleteImage(String filename, String type) async {
    var accessToken = await getAccessToken();
    final url = '${Constants.baseUrl}auth/delete-image/$filename?type=$type';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "device_id": '12345',
          "authorization": "Bearer $accessToken",
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else if (response.statusCode == 404) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        return json.decode(response.body);
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

  String encryptData(String plaintext, String hexKey, String hexIv) {
    final keyBytes = encrypt.Key.fromBase16(hexKey);
    final ivBytes = encrypt.IV.fromBase16(hexIv); // Use the same IV for both encryption and decryption

    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc)); // Ensure using CBC mode

    final encrypted = encrypter.encrypt(plaintext, iv: ivBytes);
    return encrypted.base64;
  }

  String decryptData(String encryptedBase64, String hexKey, String hexIv) {
    try {
      // Correct any HTML entities in the encrypted string
      final correctedEncryptedBase64 = correctEncryptedString(encryptedBase64);

      final keyBytes = encrypt.Key.fromBase16(hexKey);
      final ivBytes = encrypt.IV.fromBase16(hexIv); // Use the same IV for decryption as used for encryption

      final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc)); // Ensure using CBC mode

      final decrypted = encrypter.decrypt64(correctedEncryptedBase64, iv: ivBytes);
      return decrypted;
    } catch (e) {
      // Handle the error and optionally log it
      print('Error decrypting data: $e');
      // You can return a default value or rethrow the exception based on your needs
      return 'Decryption failed $e';
    }
  }

  String correctEncryptedString(String encryptedString) {
    return encryptedString.replaceAll('&#x2F;', '/').replaceAll('+', '+');
  }

  Future<Map<String, dynamic>?> get(String endpoint) async {
    try {
      final accessToken = await getAccessToken();
      final headerData = {
        "Authorization": "Bearer $accessToken",
      };

      final uri = Uri.parse('${Constants.baseUrl}$endpoint');
      final response = await http.get(uri, headers: headerData);
      print("+++++++++++++response++++++++++++++$uri");
      print("+++++++++++++response++++++++++++++${response.body}");

      if(response.statusCode == 403){
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.loginScreen);
      }
      else if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final responseBody = json.decode(response.body);
        return {
          "status": "Error",
          "message": responseBody['message'] ?? 'An unknown error occurred'
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        "status": "Server error",
        "message": e.toString()
      };
    }
  }

  Future getUserInfoByID(id) async {
    try {
      final response = await get('auth/user/$id');
      return response;
    } catch (e) {
      print("Error(Function getUserInfoByID): $e");
      return e.toString();
    }
  }

  Future userWalletData() async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{});
      final response = await post('api/wallet', data);
      return response;
    } catch (e) {
      print("Error(Function userWalletData): $e");
      return e.toString();
    }
  }

  Future sendTransactioToAdmin(fromAddress, blockchain, network, amount, fee, note, toAddress, adminAddress, commissionAmount) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        "address": fromAddress,
        "blockchain": blockchain,
        "network": network,
        "amount": amount,
        "feePriority": fee,
        "note": note,
        "recipientAddress": toAddress,
        "adminAddress": adminAddress,
        "commissionAmount": commissionAmount
      });
      final response = await post('api/admin-approval', data);
      return response;
    } catch (e) {
      print("Error(Function sendTransactioToAdmin):$e");
      return e.toString();
    }
  }

  Future verifyAddress(address, blockchain, network, userName) async {
    try {
      dynamic data = jsonEncode(<dynamic, dynamic>{
        "address": address,
        "blockchain": blockchain,
        "network": network,
      });
      final response = await post('api/validate-address?network=$blockchain&context=$userName-$blockchain', data);
      return response;
    } catch (e) {
      print("Error(Function verifyAddress):$e");
      return e.toString();
    }
  }

}
