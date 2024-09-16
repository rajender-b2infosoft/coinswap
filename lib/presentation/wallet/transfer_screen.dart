import 'dart:math';
import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:crypto_app/presentation/wallet/qr_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_elevated_button.dart';

class TransferScreen extends StatefulWidget {
  final String toAddress;
  const TransferScreen({super.key, required this.toAddress});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
  static Widget builder(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: TransferScreen(toAddress: args['toAddress']),
    );
  }
}

class _TransferScreenState extends State<TransferScreen> {
  late TransactionProvider transactionProvider;

  final _secureStorage = const FlutterSecureStorage();
  final _focusNodeAddress = FocusNode();
  String qrCodeData = '';

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    transactionProvider.getEthBalance('0x5dfa1d664e0c7fef9cebbc7650950a244d96a210', '0x1');
    _focusNodeAddress.addListener(() {
      setState(() {});
    });
    transactionProvider.addressController.text = widget.toAddress;
  }

  Future<void> getValue() async {
    transactionProvider.setEthBalance(await _secureStorage.read(key: 'ethBalance'));
  }

  @override
  void dispose() {
    _focusNodeAddress.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    transactionProvider =
        Provider.of<TransactionProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.main,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              NavigatorService.pushNamed(AppRoutes.homeScreen);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: appTheme.white,
            )),
        title: Text(
          'Transfer ',
          style: CustomTextStyles.headlineMediumRegular,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: SizeUtils.height,
          decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transfer to:',
                    style: CustomTextStyles.gray7272_16,
                  ),
                  const SizedBox(height: 10),
                  _buildInput(
                      _focusNodeAddress,
                      transactionProvider.addressController,
                      'Enter Address',
                      'Please enter address',
                      TextInputType.text),
                  const SizedBox(height: 10),
                  _buildInfoCard(),
                  // const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _proceedButton() {
    return (transactionProvider.isLoading)?Center(
      child: Container(
        height: 50,
        width: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: appTheme.main
        ),
        child: transactionProvider.isLoading ? const Center(
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
        text: transactionProvider.isLoading ? '' : "Confirm",  // Empty text if loading
        onPressed: () async {

          // print('.................... ${transactionProvider.selectedCurrency}');

          if(transactionProvider.selectedCurrency == 'Bitcoin'){
            CommonWidget.showToastView('Bitcoin not enabled yet, please select ETH OR USDT', appTheme.red);
            return;
          }

          if (!transactionProvider.isLoading) {
            transactionProvider.setLoding(true);

            String? privateKey = await _secureStorage.read(key: 'privateKey');
            if(transactionProvider.addressController.text == ''){
              CommonWidget.showToastView('Please enter address', appTheme.gray8989);
              transactionProvider.setLoding(false);
            }else if(transactionProvider.amountController.text == ''){
              CommonWidget.showToastView('Please enter amount', appTheme.gray8989);
              transactionProvider.setLoding(false);
            }else{
              var toAddress = transactionProvider.addressController.text;
              var amount = transactionProvider.amountController.text;
              // var privateKey = '0x5db75d21a84510c5aad7f7c431cd1c45acd6ce9b94ba9a824b74351f85920c18';

              var type = (transactionProvider.selectedCurrency == 'Ethereum')?"eth":"usdt";

              await Provider.of<TransactionProvider>(context, listen: false)
                  .sendETH(context,toAddress,type,amount);

              // await Provider.of<TransactionProvider>(context, listen: false)
              //     .sendETH(context,toAddress,privateKey,amount);
              transactionProvider.setLoding(false);
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

  // _proceedButton() {
  //   return Center(
  //     child: CustomElevatedButton(
  //       buttonStyle: ElevatedButton.styleFrom(
  //         backgroundColor: appTheme.main,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
  //         elevation: 0,
  //       ),
  //       buttonTextStyle: CustomTextStyles.white18,
  //       height: 50,
  //       width: 250,
  //       text: "Confirm",
  //       // margin: EdgeInsets.only(left: 42.h, right: 42.h),
  //       onPressed: () async {
  //         String? privateKey = await _secureStorage.read(key: 'privateKey');
  //         if(transactionProvider.addressController.text == ''){
  //           CommonWidget.showToastView('Please enter address', appTheme.gray8989);
  //         }else if(transactionProvider.amountController.text == ''){
  //           CommonWidget.showToastView('Please enter amount', appTheme.gray8989);
  //         }else{
  //           var toAddress = transactionProvider.addressController.text;
  //           var amount = transactionProvider.amountController.text;
  //           // var privateKey = '0x5db75d21a84510c5aad7f7c431cd1c45acd6ce9b94ba9a824b74351f85920c18';
  //           Provider.of<TransactionProvider>(context, listen: false)
  //               .sendETH(context,toAddress,privateKey,amount);
  //         }
  //
  //       },
  //     ),
  //   );
  // }

  Widget _buildInput(node, TextEditingController controller, String label,
      String error, TextInputType type) {
    final hasFocus = node.hasFocus;
    final hasValue = controller.text.isNotEmpty;
    return Container(
      // height: 50,
      child: TextFormField(
        focusNode: node,
        controller: controller,
        style: CustomTextStyles.blue17,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () {
              transactionProvider.scanQRCode();
            },
            child: CustomImageView(
              imagePath: ImageConstant.scanner,
              width: 30,
              height: 30,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
          fillColor: Colors.white,
          filled: true,
          labelText: label,
          labelStyle: TextStyle(
              color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.normal),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: appTheme.color549FE3.withOpacity(0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: appTheme.color549FE3.withOpacity(0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: appTheme.color549FE3.withOpacity(0.2),
            ),
          ),
        ),
        validator: (value) => checkEmpty(value, error),
          onChanged: (value) {
            transactionProvider.setqrCodeData(value);
          }
      ),
    );
  }

  Widget _buildInfoCard() {
    return Column(
      children: [
        // Container(
        //   decoration: BoxDecoration(
        //     color: appTheme.white,
        //     border: Border.all(width: 1.5, color: appTheme.color549FE3.withOpacity(0.2)),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Padding(
        //         padding: const EdgeInsets.only(left: 8,top: 8,bottom: 8),
        //         child: Container(
        //           padding: const EdgeInsets.all(2),
        //           height: 50,
        //           width: 50,
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: appTheme.lightBlue,
        //           ),
        //           child: ClipOval(
        //             child: CustomImageView(
        //               imagePath: ImageConstant.eth,
        //               width: 15,
        //               height: 15,
        //             ),
        //           ),
        //         ),
        //       ),
        //       const SizedBox(width: 10,),
        //       Expanded(
        //         child: Column(
        //           //mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Padding(
        //               padding: const EdgeInsets.only(top: 13.0),
        //               child: Text('Etherirum Balance', style: CustomTextStyles.gray7272_12,),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.only(bottom: 8.0),
        //               child: Wrap(
        //                 children: [
        //                   Text("\$1245.21",
        //                       maxLines: 2,
        //                       overflow: TextOverflow.ellipsis,
        //                       style: CustomTextStyles.size8C8C_12),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         children: [
        //           Padding(
        //             padding:  const EdgeInsets.only(right: 10.0, top: 20),
        //             child: Transform.rotate(
        //                 angle: 90 * pi / 180,child: Icon(Icons.arrow_forward_ios, size: 20, color: appTheme.main,)),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),

        // Container(
        //   width: SizeUtils.width,
        //   height: 60,
        //   decoration: BoxDecoration(
        //     color: appTheme.white,
        //     border: Border.all(width: 1.5, color: appTheme.main.withOpacity(0.2)),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   padding: EdgeInsets.only(right: 10),
        //   child:    DropdownButtonHideUnderline(
        //     child: DropdownButton2<String>(
        //       // style: CustomTextStyles(context).font17Winebold,
        //       value: transactionProvider.selectedCurrency,
        //       isExpanded: true,
        //       iconStyleData: IconStyleData(
        //         icon: Icon(
        //           Icons.keyboard_arrow_down,
        //           color: appTheme.main,
        //         ),
        //         iconSize: 30,
        //       ),
        //       dropdownStyleData:
        //       DropdownStyleData(
        //         // width: double.infinity,
        //         padding: const EdgeInsets.symmetric(
        //             horizontal: 0),
        //         decoration: BoxDecoration(
        //           borderRadius:
        //           BorderRadius.circular(15),
        //         ),
        //       ),
        //       menuItemStyleData:
        //       const MenuItemStyleData(
        //         padding: EdgeInsets.symmetric(
        //             horizontal: 10,vertical: 4),
        //       ),
        //       items: <String>['Ethereum', 'Bitcoin', 'USDT'].map<DropdownMenuItem<String>>((String value) {
        //         return DropdownMenuItem<String>(
        //           value: value,
        //           child: LayoutBuilder(
        //               builder: (context,constraints) {
        //                 print(constraints);
        //                 return Row(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   children: [
        //                     CustomImageView(
        //                       imagePath: (transactionProvider.selectedCurrency == 'Ethereum')?ImageConstant.eth:(transactionProvider.selectedCurrency == 'Bitcoin')?ImageConstant.bit:ImageConstant.t,
        //                       width: 30,
        //                       height: 30,
        //                     ),
        //                     const SizedBox(width: 10),
        //                     SingleChildScrollView(
        //                       child: Column(
        //                         // direction: Axis.vertical,
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           Text('$value Balance',style: const TextStyle(
        //                             fontSize: 14,
        //                             fontFamily: 'Poppins',
        //                             fontWeight: FontWeight.w400,
        //                             color: Color(0xff727272)
        //                           ),),
        //                           Text(transactionProvider.ethBalance,style: const TextStyle(
        //                           fontSize: 14,
        //                           fontFamily: 'Poppins',
        //                           fontWeight: FontWeight.w400,
        //                           color: Color(0xff989898)
        //                           ) ),
        //                         ],
        //                       ),
        //                     ),
        //                   ],
        //                 );
        //               }
        //           ),
        //         );
        //       }).toList(),
        //       onChanged: (String? newValue) {
        //         transactionProvider.setCurrency(newValue);
        //       },
        //     ),
        //   ),
        // ),

        Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.07, // Set a max height as needed
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1.5,
              color: appTheme.color549FE3.withOpacity(0.2),
              // color: Colors.grey.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.only(right: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: transactionProvider.selectedCurrency,
              isExpanded: true,
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: appTheme.mainTitle,
                ),
                iconSize: 30,
              ),
              dropdownStyleData: DropdownStyleData(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2, // Reduce vertical padding
                ),
              ),
              items: <String>['Ethereum', 'Bitcoin', 'USDT']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        (value == 'Ethereum')
                            ? '${ImageConstant.eth}'
                            : (value == 'Bitcoin')
                            ? '${ImageConstant.bit}'
                            : '${ImageConstant.t}',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Prevent overflow
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$value Balance',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: Color(0xff727272),
                              ),
                            ),
                            Text((value=='Ethereum' || value=='USDT')?'${transactionProvider.ethBalance}  (ethereum-mainnet)':'${transactionProvider.ethBalance}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: Color(0xff989898),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                transactionProvider.setCurrency(newValue);
              },
            ),
          ),
        ),

        // Container(
        //   width: SizeUtils.width,
        //   height: 70,
        //   decoration: BoxDecoration(
        //     color: appTheme.white,
        //     border: Border.all(width: 1.5, color: appTheme.color549FE3.withOpacity(0.2)),
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: DropdownButtonFormField<String>(
        //     value: transactionProvider.selectedCurrency,
        //     decoration: InputDecoration(
        //       border: InputBorder.none, // Removes the default border
        //       contentPadding: EdgeInsets.symmetric(horizontal: 12), // Adjust padding as needed
        //     ),
        //     items: <String>['Ethereum', 'Bitcoin', 'USDT']
        //         .map<DropdownMenuItem<String>>((String value) {
        //       return DropdownMenuItem<String>(
        //         value: value,
        //         child: Row(
        //           children: [
        //             CustomImageView(
        //               imagePath: (transactionProvider.selectedCurrency == 'Ethereum')?ImageConstant.eth:(transactionProvider.selectedCurrency == 'Bitcoin')?ImageConstant.bit:ImageConstant.t,
        //               // width: 30,
        //               height: 60,
        //             ),
        //             SizedBox(width: 10),
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text('$value Balance'),
        //                 Text('0.00'),
        //               ],
        //             ),
        //           ],
        //         ),
        //       );
        //     }).toList(),
        //     onChanged: (String? newValue) {
        //       transactionProvider.setCurrency(newValue);
        //     },
        //   ),
        // ),

        const SizedBox(
          height: 30,
        ),

        Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: (transactionProvider.amountController.text=='')?appTheme.colorc3c3:appTheme.main),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 150,
          // height: 60,
          child: TextFormField(
            controller: transactionProvider.amountController,
            style: CustomTextStyles.blue24_300,
            keyboardType: TextInputType.none,
            cursorColor: (transactionProvider.amountController.text=='')?appTheme.colorc3c3:appTheme.main,
            decoration: const InputDecoration(
              hintText: "00.00",
              hintStyle: TextStyle(
                color: Color(0xffB6B6B6),
                fontSize: 24,
                fontWeight: FontWeight.w300,
                fontFamily: 'Poppins'
              ),
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            ),
          ),
        ),

        const SizedBox(
          height: 30,
        ),

        SizedBox(
          height: SizeUtils.height / 2.5,
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                onPressed = transactionProvider.onDotPress;
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
                onPressed = transactionProvider.onZeroPress;
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
                onPressed = transactionProvider.removeLastCharacter;
                buttonContent = Image.asset(ImageConstant.clear,
                  width: 30, // Adjust width if necessary
                  height: 30, // Adjust height if necessary
                );
              } else {
                buttonText = (index + 1).toString();
                onPressed = () =>
                    transactionProvider.appendAmountController(buttonText);
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
        ),

        _proceedButton(),

        // SizedBox(
        //   height: SizeUtils.height / 3,
        //   child: GridView.builder(
        //     padding: EdgeInsets.zero,
        //     // itemCount: 12,
        //     itemCount: 11,
        //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 3,
        //       mainAxisSpacing: 10.0,
        //       crossAxisSpacing: 10.0,
        //       childAspectRatio: 1.9,
        //     ),
        //     itemBuilder: (context, index) {
        //       if (index < 9) {
        //         return NumberButton(
        //           label: (index + 1).toString(),
        //           onButtonPressed: (value) => setState(() {
        //             transactionProvider.setAmountController(value);
        //           }),
        //         );
        //       } else if (index == 9) {
        //         return NumberButton(
        //           label: '0',
        //           onButtonPressed: (value) => setState(() {
        //             transactionProvider.setAmountController(value);
        //           }),
        //         );
        //       } else {
        //         return NumberButton(
        //           label: 'X',
        //           buttonType: ButtonType.backspace,
        //           onButtonPressed: (value) => setState(() {
        //             transactionProvider.removeLastCharacter(); // Function to remove last character
        //           }),
        //         );
        //       }
        //
        //     },
        //   ),
        // ),
      ],
    );
  }
}

//
// enum ButtonType { number, backspace }
//
// class NumberButton extends StatelessWidget {
//   final String label;
//   final ButtonType buttonType;
//   final Function(String) onButtonPressed;
//
//   NumberButton({
//     required this.label,
//     required this.onButtonPressed,
//     this.buttonType = ButtonType.number,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Color backgroundColor;
//     Color textColor;
//     String displayText;
//
//     if (buttonType == ButtonType.backspace) {
//       backgroundColor = appTheme.f6f6f6;
//       textColor = appTheme.color9999;
//       // displayText = '←';
//       displayText = label;
//     } else {
//       backgroundColor = appTheme.f6f6f6;
//       textColor = appTheme.color9999;
//       displayText = label;
//     }
//
//     return ElevatedButton(
//       onPressed: () => onButtonPressed(label),
//       style: ElevatedButton.styleFrom(
//         foregroundColor: Colors.black,
//         backgroundColor: backgroundColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         elevation: 0, // Remove default elevation
//         side: BorderSide(color: appTheme.color8383.withOpacity(0.2), width: 1.3),
//       ),
//       child: Text(
//         displayText,
//         style: TextStyle(fontSize: 24, color: textColor),
//       ),
//     );
//   }
// }
