import 'package:flutter/material.dart';
import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/widgets/custom_elevated_button.dart';
import 'package:crypto_app/widgets/custom_text_form_field.dart';
import '../../core/utils/validation_functions.dart';
import '../../core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const LoginScreen(),
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthProvider authProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _focusNodeEmail = FocusNode();
  final _focusNodePass = FocusNode();


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
    _focusNodePass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Login',style: CustomTextStyles.pageTitleMain,),
                                const SizedBox(height: 20,),
                                _buildInput(_focusNodeEmail, authProvider.emailController, 'Enter Email', 'Please enter email', TextInputType.emailAddress,false),
                                const SizedBox(height: 20,),
                                _buildInput(_focusNodePass, authProvider.passwordController, 'Password', 'Password', TextInputType.text,true),
                                const SizedBox(height: 20,),
                                InkWell(
                                  onTap: (){
                                    NavigatorService.pushNamed(AppRoutes.forgotPassword);
                                  },
                                  child: Center(
                                      child: Text('Forgot Password ?', style: CustomTextStyles.gray11,)
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
                                _registerButton(context),
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

  _registerButton(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 50,
        child:
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
          // foregroundColor: AppColors.headerColor,
          side: const BorderSide(color: Color(0XFF0073D0)),
        ),
          onPressed: () {
            NavigatorService.pushNamed(AppRoutes.getStartedScreen);
            // NavigatorService.pushNamed(AppRoutes.registerScreen);
          },
          child: Text("Register",
            style: CustomTextStyles.main18,
          ),
        ),
      ),
    );
  }

  _proceedButton(BuildContext context) {
    return Center(
      child: CustomElevatedButton(
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: appTheme.main,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
            elevation: 0
        ),
        buttonTextStyle: CustomTextStyles.white18,
        width: 250,
        height: 50,
        text: "Proceed",
        onPressed: ()async {
            var email = authProvider.emailController.text.trim();
            var password = authProvider.passwordController.text;
            String lowercasedEmail = email.toLowerCase();

            // NavigatorService.pushNamed(AppRoutes.verifyOtp,
            //     argument: {
            //       'username': email,
            //       'password': password,
            //       'name': '',
            //       'type': 'login',
            //       'privacy_policy': true
            //     });

            if (_formKey.currentState!.validate()) {
              await authProvider.login(context, lowercasedEmail, password);
            }
          // NavigatorService.pushNamed(AppRoutes.homeScreen);
        },
      ),
    );
  }

  Widget _buildInput(node,TextEditingController controller, String label, String error, TextInputType type,pass) {
    final hasFocus = node.hasFocus;
    final hasValue = controller.text.isNotEmpty;
    return SizedBox(
      // height: 50,
      child: TextFormField(
        focusNode: node,
        controller: controller,
        obscureText: pass,
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
        validator: (value) => checkEmpty(value, error),
      ),
    );
  }

}
