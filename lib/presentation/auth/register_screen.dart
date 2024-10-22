import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/widgets/custom_elevated_button.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import 'models/request_otp.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=> AuthProvider(),
      child: const RegisterScreen(),
    );
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  late AuthProvider authProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _focusNodeName = FocusNode();
  final _focusNodeEmail = FocusNode();
  final _focusNodePass = FocusNode();

  bool isApiCallInProgress = false;


  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    _focusNodeEmail.addListener(() {
      setState(() {});
    });
    _focusNodePass.addListener(() {
      setState(() {});
    });
    _focusNodeName.addListener(() {
      setState(() {});
    });
    authProvider.nameController.addListener(() {
      setState(() {});
    });
    authProvider.emailController.addListener(() {
      setState(() {});
    });
    authProvider.passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodeName.dispose();
    _focusNodePass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);
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
                    // padding: const EdgeInsets.all(20),
                    height: SizeUtils.height/1.5,
                    decoration: BoxDecoration(
                      color: appTheme.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Register',style: CustomTextStyles.pageTitleMain,),
                                    const SizedBox(height: 20,),
                                    _buildInput(_focusNodeName, authProvider.nameController, 'Enter Name', 'Please enter name', TextInputType.text),
                                    const SizedBox(height: 20,),
                                    _buildEmailInput(_focusNodeEmail, authProvider.emailController, 'Enter Email', 'Please enter email', TextInputType.emailAddress),
                                    const SizedBox(height: 20,),
                                    _buildInputPass(_focusNodePass, authProvider.passwordController, 'Password', 'Please enter Password', TextInputType.text),
                                    const SizedBox(height: 10,),
                                    Text(
                                      'Password must be at least 8 characters long, include:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: authProvider.isLengthValid  ? appTheme.green : appTheme.gray,),
                                    ),
                                    Text(
                                      '• One number',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: authProvider.hasNumber ? appTheme.green : appTheme.gray,
                                      ),
                                    ),
                                    Text(
                                      '• One uppercase letter',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: authProvider.hasUppercase  ? appTheme.green : appTheme.gray,
                                      ),
                                    ),
                                    Text(
                                      '• One special character',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: authProvider.hasSpecialCharacter  ? appTheme.green : appTheme.gray,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, ),
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 1.4,
                                      child: Checkbox(
                                        value: authProvider.privacy_policy,
                                        activeColor: Colors.blue,
                                        checkColor: Colors.white,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            authProvider.setPrivacyPolicy(value);
                                          });
                                        },
                                        side: const BorderSide(
                                          color: Color(0XFFC2C2C2),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text('I have read and agreed to the CoinSwap agreement and privacy policy',
                                        style: CustomTextStyles.gray12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),



                              const SizedBox(height: 20,),
                              _proceedButton(context),
                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: appTheme.gray,
                                      thickness: 1,
                                      indent: 70,
                                      endIndent: 0,
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Text(
                                    'or',
                                    style: CustomTextStyles.gray14,
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    child: Divider(
                                      color: appTheme.gray,
                                      thickness: 1,
                                      indent: 0,
                                      endIndent: 70,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              _loginButton(context),
                              const SizedBox(height: 10,),
                            ],
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

  _loginButton(BuildContext context) {
    return InkWell(
      onTap: (){
        NavigatorService.pushNamed(AppRoutes.loginScreen);
      },
      child: Center(
        child: Container(
          width: 250,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: appTheme.main),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(child: Text('Login', style: CustomTextStyles.main18,)),
        ),
      ),
    );
  }

  _proceedButton(BuildContext context) {
    return (authProvider.isLoading)?Center(child: CommonWidget().customAnimation(context, 50.0, 250.0)):Center(
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
        text: authProvider.isLoading ? '' : "Request OTP",  // Empty text if loading
        onPressed: () async {
          if (!authProvider.isLoading) {
              authProvider.setLoding(true);

            if (_formKey.currentState!.validate()) {
              if (!authProvider.privacy_policy) {
                CommonWidget().snackBar(context, appTheme.red, 'Please check privacy policy');
                authProvider.setLoding(false);
              } else if (authProvider.passwordController.text.length < 8) {
                CommonWidget().snackBar(context, appTheme.red, 'Password must be at least 8 characters long');
                authProvider.setLoding(false);
              } else if (!RegExp(r'\d').hasMatch(authProvider.passwordController.text)) {
                CommonWidget().snackBar(context, appTheme.red, 'Password must contain a number');
                authProvider.setLoding(false);
              } else if (!RegExp(r'[A-Z]').hasMatch(authProvider.passwordController.text)) {
                CommonWidget().snackBar(context, appTheme.red, 'Password must contain an uppercase letter');
                authProvider.setLoding(false);
              } else {
                final requestOtp = RequestOtp(
                  username: authProvider.emailController.text.trim(),
                  name: authProvider.nameController.text.trim(),
                  password: authProvider.passwordController.text.trim(),
                  privacy_policy: authProvider.privacy_policy,
                );

                // Call your API or any async task
                await Provider.of<AuthProvider>(context, listen: false).requestOtp(context, requestOtp);

                // Navigate or perform other actions upon success

                authProvider.setLoding(false);
              }
            } else {
              authProvider.setLoding(false);
            }
          }
        },
        // text: "Request OTP",
        // onPressed: () async {
        //
        //   // if (!isApiCallInProgress) {
        //     // setState(() {
        //     //   isApiCallInProgress = true;
        //     // });
        //     if (_formKey.currentState!.validate()) {
        //       if(!authProvider.privacy_policy){
        //         CommonWidget().snackBar(context, appTheme.red, 'Please check privacy policy');
        //       } else if (authProvider.passwordController.text.length < 8) {
        //         CommonWidget().snackBar(context, appTheme.red, 'Password must be at least 8 characters long');
        //
        //       } else if (!RegExp(r'\d').hasMatch(authProvider.passwordController.text)) {
        //         CommonWidget().snackBar(context, appTheme.red, 'Password must contain a number');
        //
        //       } else if (!RegExp(r'[A-Z]').hasMatch(authProvider.passwordController.text)) {
        //         CommonWidget().snackBar(context, appTheme.red, 'Password must contain an uppercase letter');
        //
        //       }else{
        //         final requestOtp = RequestOtp(
        //             username: authProvider.emailController.text.trim(),
        //             name: authProvider.nameController.text.trim(),
        //             password: authProvider.passwordController.text.trim(),
        //             privacy_policy: authProvider.privacy_policy
        //         );
        //
        //         // NavigatorService.pushNamed(AppRoutes.verifyOtp,
        //         //     argument: {'username': authProvider.emailController.text,
        //         //       'password': authProvider.passwordController.text,
        //         //       'name': authProvider.nameController.text, 'type': 'register',
        //         //       'privacy_policy': authProvider.privacy_policy});
        //
        //         Provider.of<AuthProvider>(context, listen: false)
        //             .requestOtp(context, requestOtp);
        //       }
        //     }
        //   // }
        //
        // },
      ),
    );
  }

  Widget _buildInput(node,TextEditingController controller, String label, String error, TextInputType type) {
    final hasFocus = node.hasFocus;
    final hasValue = controller.text.isNotEmpty;
    return Container(
      // height: 50,
      child: TextFormField(
        focusNode: node,
        controller: controller,
        style: CustomTextStyles.blue17,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
          fillColor: hasFocus || hasValue ? Colors.white : appTheme.f6f6f6,
          filled: true,
          labelText: label,
          labelStyle: TextStyle(
            color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.normal
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasFocus || hasValue ? appTheme.blueDark : const Color(0XFFF6F6F6),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: hasFocus || hasValue ? Colors.blue : const Color(0XFF838383).withOpacity(0.1),
            ),
          ),
        ),
        validator: (value) => checkEmpty(value, error),
      ),
    );
  }

  Widget _buildInputPass(node,TextEditingController controller, String label, String error, TextInputType type) {
    final hasFocus = node.hasFocus;
    final hasValue = controller.text.isNotEmpty;
    return Container(
      // height: 50,
      child: TextFormField(
        focusNode: node,
        controller: controller,
        obscureText: authProvider.obscureText,
        onChanged: (value) {
          Provider.of<AuthProvider>(context, listen: false).updatePassword(value);
        },
        style: CustomTextStyles.blue17,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
          fillColor: hasFocus || hasValue ? Colors.white : appTheme.f6f6f6,
          filled: true,
          labelText: label,
          labelStyle: TextStyle(
            color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.normal
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasFocus || hasValue ? appTheme.blueDark : const Color(0XFFF6F6F6),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: hasFocus || hasValue ? Colors.blue : const Color(0XFF838383).withOpacity(0.1),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              authProvider.obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: (){
              authProvider.setObscureText();
            },
          ),
        ),
        validator: (value) => checkEmpty(value, error),
      ),
    );
  }

  Widget _buildEmailInput(node,TextEditingController controller, String label, String error, TextInputType type) {
    final hasFocus = node.hasFocus;
    final hasValue = controller.text.isNotEmpty;
    return Container(
      // height: 50,
      child: TextFormField(
        focusNode: node,
        controller: controller,
        style: CustomTextStyles.blue17,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
          fillColor: hasFocus || hasValue ? Colors.white : appTheme.f6f6f6,
          filled: true,
          labelText: label,
          labelStyle: TextStyle(
              color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.normal
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasFocus || hasValue ? appTheme.blueDark : const Color(0XFFF6F6F6),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
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
    );
  }

}
