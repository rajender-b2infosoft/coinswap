import 'package:crypto_app/presentation/mpin/provider/mpin.dart';
import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';

class WalletPin extends StatefulWidget {
  final String toAddress;
  final String cryptoType;
  final String amount;
  final String note;
  final String fromAddress;
  const WalletPin({super.key, required this.toAddress, required this.cryptoType, required this.amount, required this.note, required this.fromAddress});

  @override
  State<WalletPin> createState() => _WalletPinState();
  static Widget builder(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => MpinProvider(),
      child: WalletPin(toAddress: args['toAddress'], cryptoType: args['cryptoType'], amount: args['amount'], note: args['note'], fromAddress: args['fromAddress']),
    );
  }
}

class _WalletPinState extends State<WalletPin> {
  late MpinProvider provider;
  late TransactionProvider transactionProvider;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<MpinProvider>(context);
    transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.main,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              NavigatorService.goBack();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: appTheme.white,
            )),
        title: Text(
          'Verify m-pin',
          style: CustomTextStyles.headlineMediumRegular,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: SizeUtils.height,
          width: SizeUtils.width,
          decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Consumer<MpinProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Enter your Mpin',
                          style: CustomTextStyles.pageTitleMain,
                        ),
                        const SizedBox(height: 5,),
                        Text('Enter a 4 digit number', style: CustomTextStyles.gray12,),
                        const SizedBox(height: 50,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(provider.otpLength, (index) => _buildOtpField(index, provider)),
                        ),
                        const SizedBox(height: 50,),
                        keyboard(),
                        const SizedBox(height: 50,),
                        _confirmButton()
                      ],
                    );
                  }
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget keyboard(){
    return  SizedBox(
      height: SizeUtils.height / 2.5,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.6,
        ),
        itemBuilder: (context, index) {
          String buttonText;
          VoidCallback onPressed;
          Widget buttonContent; // Widget for button content (text or image)

          if (index == 9) {
            buttonText = '.';
            onPressed = () {};
            buttonContent = Text(
              buttonText,
              style: TextStyle(
                color: appTheme.color8383,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            );
          } else if (index == 10) {
            buttonText = '0';
            // onPressed = provider.onZeroPress;
            onPressed = () => provider.onKeyboardTap('0');
            buttonContent = Text(
              '0',
              style: TextStyle(
                color: appTheme.color8383,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            );
          } else if (index == 11) {
            buttonText = 'C';
            // onPressed = provider.removeLastCharacter;
            onPressed = provider.onBackspacePressed;
            buttonContent = Image.asset(ImageConstant.clear,
              width: 30, // Adjust width if necessary
              height: 30, // Adjust height if necessary
            );
          } else {
            buttonText = (index + 1).toString();
            onPressed = () => provider.onKeyboardTap(buttonText);
            // onPressed = () =>
            //     provider.appendAmountController(buttonText);
            buttonContent = Text(
              buttonText,
              style: TextStyle(
                color: appTheme.color8383,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            );
          }

          return InkWell(
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.all(SizeUtils.width * 0.022),
              child: Container(
                decoration: BoxDecoration(
                  color: appTheme.f6f6f6,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.color8383,
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Center(
                  child: buttonContent, // Use buttonContent widget
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpField(int index, MpinProvider provider) {
    final hasFocus = provider.focusNodes[index].hasFocus;
    final hasValue = provider.controllers[index].text.isNotEmpty;
    return SizedBox(
      width: 55,
      height: 60,
      child: RawKeyboardListener(
        focusNode: FocusNode(),  // FocusNode for the RawKeyboardListener
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
            if (provider.controllers[index].text.isNotEmpty) {
              provider.controllers[index].clear();
            } else if (index > 0) {
              FocusScope.of(context).requestFocus(provider.focusNodes[index - 1]);
              provider.controllers[index - 1].clear();  // Clear text in the previous field
              provider.controllers[index - 1].selection = TextSelection.fromPosition(
                const TextPosition(offset: 0),
              );
            }
          }
        },
        child: TextField(
          controller: provider.controllers[index],
          focusNode: provider.focusNodes[index],
          keyboardType: TextInputType.none,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 1,
          textAlign: TextAlign.center,
          textInputAction: index < provider.otpLength - 1 ? TextInputAction.next : TextInputAction.done,
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
              if (index < provider.otpLength - 1) {
                FocusScope.of(context).requestFocus(provider.focusNodes[index + 1]);
              }
            }
          },
          onEditingComplete: () {
            // Hide keyboard when the last field is completed
            if (index == provider.otpLength - 1) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ),
    );
  }

  _confirmButton() {
    return (transactionProvider.isLoading)
        ? CommonWidget().customAnimation(context, 50.0, 250.0)
        : Center(
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
        text: 'Proceed',
        onPressed: () async {
          final enteredOtp = provider.getEnteredOtp();
          if(enteredOtp.length !< 4) {
            CommonWidget.showToastView('Please Enter valid pin', appTheme.red);
          }else if(enteredOtp.length == 4){
            transactionProvider.checkMpin(context, enteredOtp, widget.toAddress, widget.cryptoType, widget.amount, widget.note, widget.fromAddress);
          }
        },
      ),
    );
  }
}
