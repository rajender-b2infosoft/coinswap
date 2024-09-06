
import 'package:crypto_app/core/app_export.dart';

bool isValidPhone(String? inputString, {bool isRequired = false}){
  bool isInputStringValid = false;
  if(!isRequired && (inputString == null ? true : inputString.isEmpty)){
    isInputStringValid = true;
  }
  if(inputString != null && inputString.isNotEmpty){
    if(inputString.length > 16 || inputString.length < 6) return false;
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}


String? validatePhoneNumber(String? value) {
  final phoneRegExp = RegExp(r'^\+?1?\d{9,15}$');
  if (value == null || value.isEmpty) {
    return 'Please enter phone number';
  } else if (!phoneRegExp.hasMatch(value)) {
    return 'Please enter valid phone number';
  }
  return null;
}

bool isValidPassword(String? inputString, {bool isRequired = false}){
  bool isInputStringValid = false;
  if(!isRequired && (inputString == null ? true : inputString.isEmpty)){
    isInputStringValid = true;
  }
  if(inputString != null && inputString.isNotEmpty){
    const pattern = r'^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}

bool isText(String? inputString, {bool isRequired = false}){
  bool isInputStringValid = false;
  if(!isRequired && (inputString == '' ? true : inputString!.isEmpty)){
    isInputStringValid = true;
  }
  if(inputString != null && inputString.isNotEmpty){
    const pattern = r'^[a-zA-Z]+$';
    final regExp = RegExp(pattern);
    isInputStringValid = regExp.hasMatch(inputString);
  }
  return isInputStringValid;
}

String? checkEmpty(String? value, String error) {
  if (value == null || value.isEmpty) {
    return error;
  } else {
    return null;
  }
}

bool isValidEmail(String email) {
  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  return emailRegExp.hasMatch(email);
}