import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/presentation/auth/provider/forgotPassword.dart';
import 'package:flutter/material.dart';

import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_elevated_button.dart';

class ForgotPassword extends StatefulWidget {
  final String page;
  const ForgotPassword({super.key, required this.page});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
  static Widget builder(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => ForgotPasswordProvider(),
      child: ForgotPassword(page: args['page']),
    );
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late ForgotPasswordProvider provider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _focusNodeEmail = FocusNode();

  @override
  void initState() {
    super.initState();
    provider = Provider.of<ForgotPasswordProvider>(context, listen: false);
    _focusNodeEmail.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<ForgotPasswordProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ForgotPasswordProvider>(context);
    final hasFocus = _focusNodeEmail.hasFocus;
    final hasValue = provider.emailController.text.isNotEmpty;
    // provider.emailController = provider.emailController.text;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text((widget.page == 'profile')?'Reset password':'Forgot password ?',style: CustomTextStyles.pageTitleMain,),
                                const SizedBox(height: 20,),
                                SizedBox(
                                  // height: 50,
                                  child: TextFormField(
                                    focusNode: _focusNodeEmail,
                                    controller: provider.emailController,
                                    style: CustomTextStyles.blue17,
                                    onChanged: (value) {
                                      provider.updateEmail(value);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                                      fillColor: hasFocus || hasValue ? Colors.white : appTheme.f6f6f6,
                                      filled: true,
                                      labelText: 'Enter Email',
                                      labelStyle: TextStyle(
                                          color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: hasFocus || hasValue ? Colors.blue : const Color(0XFFF6F6F6),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: hasFocus || hasValue ? Colors.blue : Colors.grey,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: hasFocus || hasValue ? Colors.blue : const Color(0XFF838383).withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      } else if (!isValidEmail(value.trim())) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
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
    return
    //   (provider.isLoading)?Center(
    //   child: Container(
    //     height: 50,
    //     width: 250,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(50),
    //         color: appTheme.main
    //     ),
    //     child: provider.isLoading ? const Center(
    //         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5,)) : null,
    //   ),
    // ):
    (provider.isLoading)?Center(child: CommonWidget().customAnimation(context, 50.0, 250.0)):
    Center(
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
        text: provider.isLoading ? '' : "Request OTP",  // Empty text if loading
        onPressed: () async {
          if (!provider.isLoading) {
            var email = provider.emailController.text.trim();
            String lowercasedEmail = email.toLowerCase();
            if (_formKey.currentState!.validate()) {
              provider.setLoding(true);
              await Provider.of<ForgotPasswordProvider>(context, listen: false).forgotPassword(context, lowercasedEmail, 'otp', widget.page);
              provider.setLoding(false);
            } else {
              provider.setLoding(false);
            }
          }
        },
      ),
    );
  }
}
