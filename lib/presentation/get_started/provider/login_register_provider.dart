import 'package:flutter/material.dart';

import '../models/login_register_model.dart';


class LoginRegisterProvider extends ChangeNotifier {
  LoginRegisterModel loginRegisterModel = LoginRegisterModel();

  @override
  void dispose(){
    super.dispose();
  }
}