import 'package:crypto_app/presentation/auth/provider/forgotPassword.dart';
import 'package:flutter/material.dart';

import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_elevated_button.dart';

class ForgotPasswordChange extends StatefulWidget {
  final String email;
  final String page;
  const ForgotPasswordChange({super.key, required this.email, required this.page});

  @override
  State<ForgotPasswordChange> createState() => _ForgotPasswordChangeState();
  static Widget builder(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordProvider(),
      child: ForgotPasswordChange(email: args['email'], page: args['page']),
    );
  }
}

class _ForgotPasswordChangeState extends State<ForgotPasswordChange> {
  late ForgotPasswordProvider provider;

  final _focusNodeNewPassword = FocusNode();
  final _focusNodeConfirmPassword = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _focusNodeNewPassword.addListener(() {
      setState(() {});
    });
    _focusNodeConfirmPassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNodeNewPassword.dispose();
    _focusNodeConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ForgotPasswordProvider>(context, listen: false);
    final hasFocusNew = _focusNodeNewPassword.hasFocus;
    final hasFocusConf = _focusNodeConfirmPassword.hasFocus;
    final hasValueNew = provider.newController.text.isNotEmpty;
    final hasValueConf = provider.confController.text.isNotEmpty;


    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: appTheme.main,
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 0,
                  child: CustomImageView(
                    imagePath: ImageConstant.LooperGroup,
                    height: 120.v,
                    width: 120.h,
                    margin: EdgeInsets.only(bottom: 18.v),
                  ),
                ),
                Positioned(
                  left: (SizeUtils.width-120)/2.2,
                  bottom: SizeUtils.height/1.35,
                  child: CustomImageView(
                    imagePath: ImageConstant.logo,
                    height: 140.v,
                    width: 140.h,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: SizeUtils.height/1.6,
                  child: CustomImageView(
                    imagePath: ImageConstant.LooperGroupBottom,
                    height: 140.v,
                    width: 140.h,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: SizeUtils.height/1.5,
                    decoration: BoxDecoration(
                      color: appTheme.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Consumer<ForgotPasswordProvider>(
                        builder: (context, authProvider, child) => SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Set up new password',style: CustomTextStyles.pageTitleMain,),
                                const SizedBox(height: 8,),
                                Text('Enter your new password below',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles.gray12,
                                ),
                                const SizedBox(height: 40),
                                SizedBox(
                                  child: TextFormField(
                                    focusNode: _focusNodeNewPassword,
                                    controller: provider.newController,
                                    obscureText: provider.obscureTextNew,
                                    style: CustomTextStyles.blue17,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                                      fillColor: hasFocusNew || hasValueNew ? Colors.white : appTheme.f6f6f6,
                                      filled: true,
                                      labelText: 'Enter new password',
                                      labelStyle: TextStyle(
                                          color: hasFocusNew || hasValueNew ? appTheme.blueDark : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: hasFocusNew || hasValueNew ? Colors.blue : const Color(0XFFF6F6F6),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: hasFocusNew || hasValueNew ? Colors.blue : Colors.grey,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: hasFocusNew || hasValueNew ? Colors.blue : const Color(0XFF838383).withOpacity(0.1),
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          provider.obscureTextNew ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: (){
                                          provider.setObscureText('new');
                                        },
                                      ),
                                    ),
                                    validator: (value) => checkEmpty(value, 'Please enter new password'),
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                SizedBox(
                                  child: TextFormField(
                                    focusNode: _focusNodeConfirmPassword,
                                    controller: provider.confController,
                                    obscureText: provider.obscureText,
                                    style: CustomTextStyles.blue17,
                                    onChanged: (value) {
                                      Provider.of<ForgotPasswordProvider>(context, listen: false).updatePassword(value);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                                      fillColor: hasFocusConf || hasValueConf ? Colors.white : appTheme.f6f6f6,
                                      filled: true,
                                      labelText: 'Re-enter new password',
                                      labelStyle: TextStyle(
                                          color: hasFocusConf || hasValueConf ? appTheme.blueDark : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: hasFocusConf || hasValueConf ? Colors.blue : const Color(0XFFF6F6F6),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: hasFocusConf || hasValueConf ? Colors.blue : Colors.grey,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: hasFocusConf || hasValueConf ? Colors.blue : const Color(0XFF838383).withOpacity(0.1),
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          provider.obscureText ? Icons.visibility : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                        onPressed: (){
                                          provider.setObscureText('confirm');
                                        },
                                      ),
                                    ),
                                    validator: (value) => checkEmpty(value, 'Please re enter new password'),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Password must be at least 8 characters long, include:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: provider.isLengthValid  ? appTheme.green : appTheme.gray,),
                                    ),
                                    Text(
                                      '• One number',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: provider.hasNumber ? appTheme.green : appTheme.gray,
                                      ),
                                    ),
                                    Text(
                                      '• One uppercase letter',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: provider.hasUppercase  ? appTheme.green : appTheme.gray,
                                      ),
                                    ),
                                    Text(
                                      '• One special character',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: provider.hasSpecialCharacter  ? appTheme.green : appTheme.gray,
                                      ),
                                    ),
                                    Text(
                                      '• Passwords match',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: provider.isPasswordBeingTyped
                                            ? (provider.doPasswordsMatch ? appTheme.green : appTheme.red)
                                            : appTheme.gray,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30,),
                                _proceedButton(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _proceedButton(BuildContext context) {
    return (provider.isLoading)?Center(
      child: Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: appTheme.main
        ),
        child: provider.isLoading ? const Center(
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5,)) : null,
      ),
    ):Center(
      child: CustomElevatedButton(
        buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: appTheme.main,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)
            ),
            elevation: 0
        ),
        buttonTextStyle: CustomTextStyles.white18,
        height: 50,
        width: 250,
        text: provider.isLoading ? '' : "Finish",  // Empty text if loading
        onPressed: () async {
          if (!provider.isLoading) {
            if (_formKey.currentState!.validate()) {
              var newPass = provider.newController.text;
              var confPass = provider.confController.text;

              if(newPass != confPass){
                CommonWidget().snackBar(context, appTheme.red, 'Password does not match.');
                provider.setLoding(false);
              }else if (provider.confController.text.length < 8) {
                CommonWidget().snackBar(context, appTheme.red, 'Password must be at least 8 characters long');
                provider.setLoding(false);
              } else if (!RegExp(r'\d').hasMatch(provider.confController.text)) {
                CommonWidget().snackBar(context, appTheme.red, 'Password must contain a number');
                provider.setLoding(false);
              } else if (!RegExp(r'[A-Z]').hasMatch(provider.confController.text)) {
                CommonWidget().snackBar(context, appTheme.red, 'Password must contain an uppercase letter');
                provider.setLoding(false);
              }else{
                provider.setLoding(true);
                await Provider.of<ForgotPasswordProvider>(context, listen: false).
                changePassword(context, widget.email, 'change_password', newPass, confPass, widget.page);
                provider.setLoding(false);
              }
            } else {
              provider.setLoding(false);
            }
          }
        },
      ),
    );
  }

}
