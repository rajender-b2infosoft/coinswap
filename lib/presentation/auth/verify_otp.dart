import 'dart:async';
import 'dart:math';
import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import 'models/request_otp.dart';

class VerifyOtp extends StatefulWidget {
  final String username;
  final String password;
  final String name;
  final String type;
  final bool privacy_policy;

  const VerifyOtp({super.key, required this.username, required this.password, required this.name, required this.type, required this.privacy_policy});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
  static Widget builder(BuildContext context){
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context)=> AuthProvider(),
      child: VerifyOtp(username: args['username'], password: args['password'], name: args['name'], type: args['type'], privacy_policy: args['privacy_policy']),
    );
  }

}

class _VerifyOtpState extends State<VerifyOtp> {
  late AuthProvider authProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _otpLength = 4;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late Timer _timer;
  int _start = 30;
  double _progress = 1.0;
  bool _isTimerActive = true;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _controllers = List.generate(_otpLength, (index) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());

    for (var node in _focusNodes) {
      node.addListener(() {
        setState(() {});
      });
    }
    for (var controller in _controllers) {
      controller.addListener(() {
        setState(() {});
      });
    }

    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isTimerActive = false;
        });
      } else {
        setState(() {
          _start--;
          _progress  = _start/45;
        });
      }
    });
  }

  void _resendOtp() async {
    setState(() {
      _start = 30;
      _progress = 1.0;
      _isTimerActive = true;
      startTimer();
    });

    if(widget.type == 'login'){
      // await authProvider.login(context, widget.username, widget.password);
      await authProvider.resendLogin(context, widget.username, widget.password);
    }else{
      final requestOtp = RequestOtp(
          username: widget.username,
          name: widget.name,
          password: widget.password,
          privacy_policy: widget.privacy_policy
      );
      Provider.of<AuthProvider>(context, listen: false)
          .resendRequestOtp(context, requestOtp);
      // Provider.of<AuthProvider>(context, listen: false)
      //     .requestOtp(context, requestOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text((widget.type == 'login')?'Enter the OTP':'Verify your email address',style: CustomTextStyles.pageTitleMain,),
                              const SizedBox(height: 8,),
                              (widget.type == 'login')?Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Check your email address',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.gray12,
                                  ),
                                  Text(' ${widget.username}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: appTheme.gray,
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ):Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Enter the OTP sent to ',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.gray12,
                                  ),
                                    Text(' ${widget.username}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: appTheme.gray,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(_otpLength, (index) => _buildOtpField(index)),
                              ),
                              const SizedBox(height: 40),
                              if (_isTimerActive)
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: Size(60, 60), // Size of the circle
                                    painter: GradientCircularProgressPainter(double.parse(_start.toString())),
                                  ),
                                  Text(
                                    '${_start.toInt()}',
                                    style: TextStyle(
                                      color: appTheme.main,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14, // Adjust font size as needed
                                    ),
                                  ),
                                ],
                              ),
                              if (!_isTimerActive) // Display resend button when timer is done
                                InkWell(
                                  onTap: () {
                                    _resendOtp();
                                  },
                                    child: Text('Resend OTP', style: TextStyle(
                                      color: appTheme.gray7272
                                    ),)
                                ),
                              // if (_isTimerActive)
                              // Stack(
                              //   alignment: Alignment.center,
                              //   children: [
                              //     SizedBox(
                              //       height: 50,
                              //       width: 50,
                              //       child: CircularProgressIndicator(
                              //         value: _isTimerActive ? _progress :null,
                              //         backgroundColor: const Color(0XFFFFFFFF),
                              //         strokeWidth: 5.0, // Adjust stroke width as needed
                              //         valueColor: const AlwaysStoppedAnimation<Color>(
                              //           Colors.blue, // Replace with your desired color or a Color from your gradient
                              //         ),
                              //       ),
                              //     ),
                              //     Text('$_start',
                              //       style: TextStyle(
                              //         color: appTheme.main,
                              //         fontWeight: FontWeight.w400,
                              //         fontSize: 14, // Adjust font size as needed
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // if (!_isTimerActive) // Display resend button when timer is done
                              //   InkWell(
                              //     onTap: () {
                              //       _resendOtp();
                              //     },
                              //       child: const Text('Resend OTP')
                              //   ),
                              const SizedBox(height: 40,),
                              _proceedButton(context),
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

  Widget _buildOtpField(int index) {
    final hasFocus = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;
    return SizedBox(
      width: 55,
      height: 60,
      child: RawKeyboardListener(
        focusNode: FocusNode(),  // FocusNode for the RawKeyboardListener
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isNotEmpty) {
              // If the current text field is not empty, delete the text
              _controllers[index].clear();
            } else if (index > 0) {
              // Move to the previous field if the current field is empty
              // Clear text in the previous field and move the cursor
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              _controllers[index - 1].clear();  // Clear text in the previous field
              _controllers[index - 1].selection = TextSelection.fromPosition(
                TextPosition(offset: 0),  // Set cursor position to the start (or you can use length for the end)
              );
            }
          }
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 1,
          textAlign: TextAlign.center,
          textInputAction: index < _otpLength - 1 ? TextInputAction.next : TextInputAction.done,
          decoration: InputDecoration(
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: hasFocus || hasValue ? appTheme.main : appTheme.gray,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: hasFocus || hasValue ? appTheme.main : appTheme.gray,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.h),
              borderSide: BorderSide(
                color: hasFocus || hasValue ? appTheme.main : appTheme.gray,
                width: 1,
              ),
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              // Move to the next field if input is not empty and it's not the last field
              if (index < _otpLength - 1) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              }
            }
          },
          onEditingComplete: () {
            // Hide keyboard when the last field is completed
            if (index == _otpLength - 1) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ),
      // TextField(
      //   controller: _controllers[index],
      //   focusNode: _focusNodes[index],
      //   keyboardType: TextInputType.number,
      //   // keyboardType: TextInputType.numberWithOptions(signed: false),
      //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      //   maxLength: 1,
      //   textAlign: TextAlign.center,
      //   decoration: InputDecoration(
      //     counterText: '',
      //     border: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(8.h),
      //       borderSide: BorderSide(
      //         color: hasFocus || hasValue ? appTheme.main : appTheme.gray,
      //         width: 2,
      //       ),
      //     ),
      //     enabledBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(8.h),
      //       borderSide: BorderSide(
      //         color: hasFocus || hasValue ? appTheme.main : appTheme.gray,
      //         width: 1,
      //       ),
      //     ),
      //     focusedBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(8.h),
      //       borderSide: BorderSide(
      //         color: hasFocus || hasValue ? appTheme.main : appTheme.gray,
      //         width: 1,
      //       ),
      //     ),
      //   ),
      //   onChanged: (value) {
      //     if (value.isNotEmpty) {
      //       if (index < _otpLength - 1) {
      //         // Move to next field if input is not empty and not the last field
      //         FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      //       } else {
      //         // Hide the keyboard when the last field is filled
      //         FocusScope.of(context).unfocus();
      //       }
      //     } else if (index > 0) {
      //       // Move to previous field if input is empty and not the first field
      //       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      //     }
      //   },
      //   onEditingComplete: () {
      //     if (index == _otpLength - 1) {
      //       // Hide keyboard when editing of the last field completes
      //       FocusScope.of(context).unfocus();
      //     }
      //   },
      // ),
    );
  }

  Widget _proceedButton(BuildContext context) {
    return CustomElevatedButton(
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
      text: "Proceed",
      onPressed: () {
        String otp = _controllers.map((controller) => controller.text).join();
          if(otp.length < 4){
            CommonWidget().snackBar(context, appTheme.red, 'Please Enter valid OTP');
          }else{
            if(widget.type == 'login'){
              Provider.of<AuthProvider>(context, listen: false)
                  .verifyLoginOtp(context, widget.username, widget.password, otp);
            }else{
              final requestOtp = RequestOtp(
                  username: widget.username,
                  name: widget.name,
                  password: widget.password,
                  privacy_policy: widget.privacy_policy
              );
              Provider.of<AuthProvider>(context, listen: false)
                  .verifyOtp(context, requestOtp, otp);
            }

          }
      },
    );
  }
}


class GradientCircularProgressPainter extends CustomPainter {
  final double percentage;

  GradientCircularProgressPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 5.0;
    final radius = (size.width / 2) - strokeWidth / 2;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 2 * pi,
      colors: [
        Colors.blue,
        Colors.blue.withOpacity(0.4),
        Colors.blue.withOpacity(0.2),
        Colors.blue.withOpacity(0.1),
      ],
      stops: [0.0, 0.33, 0.66, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Draw the background circle
    canvas.drawCircle(size.center(Offset.zero), radius, backgroundPaint);

    // Draw the animated arc
    final sweepAngle = 4 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: size.center(Offset.zero), radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}