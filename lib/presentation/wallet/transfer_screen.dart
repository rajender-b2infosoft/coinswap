import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_elevated_button.dart';

class TransferScreen extends StatefulWidget {
  final String toAddress;
  final String cryptoType;
  final String amount;
  const TransferScreen(
      {super.key,
      required this.toAddress,
      required this.cryptoType,
      required this.amount});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
  static Widget builder(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: TransferScreen(
          toAddress: args['toAddress'],
          cryptoType: args['cryptoType'],
          amount: args['amount']),
    );
  }
}

class _TransferScreenState extends State<TransferScreen> {
  late TransactionProvider transactionProvider;

  final _secureStorage = const FlutterSecureStorage();
  final _focusNodeAddress = FocusNode();
  String qrCodeData = '';
  final int _characterLimit = 50;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      //function for check wallet sufficient balance to make transaction
      transactionProvider.userWalletData();
      //function for get converted balance
      transactionProvider.userWalletConvertedBalance();
      transactionProvider.getSettings(context);
      transactionProvider.getCommissionSetting(context);
      transactionProvider.addressController.text = widget.toAddress;
      transactionProvider.setCurrency(widget.cryptoType);
      // transactionProvider.setCurrency('USDT');
      transactionProvider.amountController.text = widget.amount;
      transactionProvider.setUserAddress('USDT');

      checkAddress();

    });
    _focusNodeAddress.addListener(() {
      setState(() {});
    });
  }

  // Future<void> getValue() async {
  //   transactionProvider
  //       .setEthBalance(await _secureStorage.read(key: 'ethBalance'));
  // }

  Future<void> checkAddress() async {
    var network = (transactionProvider.selectedCurrency == 'Ethereum')?"mainnet":(transactionProvider.selectedCurrency == 'USDT')?"mainnet":"mainnet";
    var blockchain = (transactionProvider.selectedCurrency == 'Ethereum')?"ethereum":(transactionProvider.selectedCurrency == 'USDT')?"tron":"bitcoin";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('userName');

    if(transactionProvider.addressController.text != ''){
      transactionProvider.validateAddress(transactionProvider.addressController.text, blockchain, network, userName);
    }
  }

  @override
  void dispose() {
    _focusNodeAddress.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // transactionProvider =
    //     Provider.of<TransactionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    transactionProvider = Provider.of<TransactionProvider>(context, listen: true);

    return PopScope(
      canPop: false,
      child: Scaffold(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _proceedButton() {
    return (transactionProvider.isLoading)
        ? CommonWidget().customAnimation(context, 50.0, 250.0)
        : Center(
            child:  CustomElevatedButton(
                  buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.main,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      elevation: 0),
                  buttonTextStyle: CustomTextStyles.white18,
                  height: 50,
                  width: 250,
                  text: "Confirm",
                  // text: transactionProvider.isLoading ? '' : "Confirm",
                  onPressed: () async {

                    // var commissionSetting = transactionProvider.sortCommission(transactionProvider.commissionSettingsData!.data);
                    //
                    // print(':::::::::::::::::::::::::commissionSetting::::::::::)');
                    // print(commissionSetting);

                    if (transactionProvider.selectedCurrency == 'Bitcoin') {
                      CommonWidget.showToastView(
                          'Bitcoin not enabled yet, please select ETH OR USDT',
                          appTheme.red);
                      return;
                    }

                    if (!transactionProvider.isLoading) {
                      transactionProvider.setLoding(true);

                      if (transactionProvider.addressController.text == '') {
                        CommonWidget.showToastView(
                            'Please enter address', appTheme.red);
                        transactionProvider.setLoding(false);
                      } else if (transactionProvider.amountController.text == '') {
                        CommonWidget.showToastView(
                            'Please enter amount', appTheme.red);
                        transactionProvider.setLoding(false);
                      }
                      else if (!transactionProvider.isValidWallet) {
                        CommonWidget.showToastView(
                            'Please enter valid wallet address', appTheme.red);
                        transactionProvider.setLoding(false);
                      }
                      else {
                        var fromAddress = transactionProvider.address;
                        var toAddress = transactionProvider.addressController.text;
                        var amount = transactionProvider.amountController.text;

                        //Check user balance exist or not to make payment
                        double amountToSend = double.tryParse(transactionProvider.amountController.text) ?? 0;
                        bool isBalanceSufficient = transactionProvider.checkBalance(transactionProvider.selectedCurrency.toLowerCase(), amountToSend);
                        //Display error message if Insufficient balance
                        if(!isBalanceSufficient){
                          CommonWidget.showToastView('Insufficient balance!', appTheme.gray8989);
                          transactionProvider.setLoding(false);
                          return;
                        }

                        //check minimum amount
                        if(double.parse(amount) > 0.02){

                          if(transactionProvider.selectedCurrency == 'USDT'){
                            fromAddress = (await _secureStorage.read(key: 'tron'))!;
                          }else if(transactionProvider.selectedCurrency == 'BIT'){
                            fromAddress = (await _secureStorage.read(key: 'bitcoin'))!;
                          }else if(transactionProvider.selectedCurrency == 'ETH'){
                            fromAddress = (await _secureStorage.read(key: 'ethereum'))!;
                          }

                          var type =
                          (transactionProvider.selectedCurrency == 'Ethereum')
                              ? "eth"
                              : "usdt";

                          var isOtp = transactionProvider.userData;

                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          String? email = prefs.getString('email');

                          if (isOtp?['default_security'] == 1) {
                            //1 means user proceed with m-pin
                            NavigatorService.pushNamed(AppRoutes.walletPin,
                                argument: {'toAddress': toAddress, 'cryptoType': transactionProvider.selectedCurrency,
                                  'amount': amount, "note": 'note type', 'fromAddress': fromAddress}
                            );
                          } else {
                            await transactionProvider.sendOtp(
                              context,
                              email,
                              'otp',
                              'transfer',
                              toAddress,
                              transactionProvider.selectedCurrency,
                              amount,
                              'note not added',
                              fromAddress,
                            );
                            transactionProvider.setLoding(false);
                          }
                          transactionProvider.setLoding(false);
                        }
                        else{
                          CommonWidget.showToastView('The entered amount is below the minimum required. Please enter an amount greater than or equal to the minimum limit', appTheme.gray8989);
                          transactionProvider.setLoding(false);
                        }
                      }
                    }
                  },
                ),
          );
  }

  Widget _note(){
    return  IntrinsicWidth(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),  // Set max width to avoid expanding beyond screen
        child: Container(
          decoration: BoxDecoration(
            color: appTheme.lightBlue,  // Background color of the text field
            boxShadow: [
              BoxShadow(
                color: appTheme.color549FE3,
                blurRadius: 1.0,
              ),
            ],
            borderRadius: BorderRadius.circular(8),  // Rounded corners
          ),
          child: TextFormField(
            controller: transactionProvider.noteController,
            decoration: InputDecoration(
              border: InputBorder.none,  // Remove the border
              hintText: 'Add Note',
              hintStyle: CustomTextStyles.main16color2E92ED,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),  // Padding inside the field
            ),
            maxLines: 1,
            maxLength: _characterLimit,
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,  // Hide counter text
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              transactionProvider.setNoteController(value);
            },
          ),
        ),
      ),
    );
  }

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
                transactionProvider.scanQRCode(transactionProvider.selectedCurrency);
              },
              child: CustomImageView(
                imagePath: ImageConstant.scanner,
                width: 30,
                height: 30,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
            fillColor: Colors.white,
            filled: true,
            hintText: label,
            hintStyle: TextStyle(
              color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.normal),
            // labelText: label,
            // labelStyle: TextStyle(
            //     color: hasFocus || hasValue ? appTheme.blueDark : Colors.grey,
            //     fontSize: 16,
            //     fontWeight: FontWeight.normal),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: appTheme.color549FE3.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: appTheme.color549FE3.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color: appTheme.color549FE3.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) => checkEmpty(value, error),
          onChanged: (value) async {
            transactionProvider.setqrCodeData(value);
            // var network = (transactionProvider.selectedCurrency == 'Ethereum')?"sepolia":(transactionProvider.selectedCurrency == 'USDT')?"nail":"testnet";
            var network = (transactionProvider.selectedCurrency == 'Ethereum')?"mainnet":(transactionProvider.selectedCurrency == 'USDT')?"mainnet":"mainnet";
            var blockchain = (transactionProvider.selectedCurrency == 'Ethereum')?"ethereum":(transactionProvider.selectedCurrency == 'USDT')?"tron":"bitcoin";
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var userName = prefs.getString('userName');

            //verifying address
            if(value.length > 25){
              print('.................................=');
              print(value);
              transactionProvider.validateAddress(value, blockchain, network, userName);
            }
          },
      ),
    );
  }

  void _showTooltip(BuildContext context) {
    var amount = (transactionProvider.amountController.text == '')?'0.0':transactionProvider.amountController.text;
    var afterCommission = double.parse(amount)-transactionProvider.commissionAmount;
    showDialog (
      context: context,
      builder: (BuildContext context) {
        return Dialog (
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
          ),
          backgroundColor: Colors.transparent,
          child: Container (
            color: Colors.transparent,
            width: SizeUtils.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            color: appTheme.main,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                          child: Text('Transaction summary',
                            textAlign: TextAlign.center, // Center the text
                            style: CustomTextStyles.white14,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Amount',
                                  textAlign: TextAlign.center, // Center the text
                                  style: CustomTextStyles.gray7272_14,
                                ),
                                Text((transactionProvider.amountController.text!='')?transactionProvider.amountController.text:'0.0',
                                  textAlign: TextAlign.center, // Center the text
                                  style: CustomTextStyles.gray7272_14,
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Platform fee',
                                  textAlign: TextAlign.center, // Center the text
                                  style: CustomTextStyles.gray7272_14,
                                ),
                                Text(transactionProvider.commissionAmount.toString(),
                                  textAlign: TextAlign.center, // Center the text
                                  style: CustomTextStyles.orange14,
                                ),
                              ],
                            ),
                            SizedBox(height: 15,),
                            CustomImageView(
                              imagePath: ImageConstant.dotLine,
                              width: SizeUtils.width-50,
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Final Amount',
                                  textAlign: TextAlign.center, // Center the text
                                  style: CustomTextStyles.gray7272_16Bold,
                                ),
                                Text(afterCommission.toString(),
                                  textAlign: TextAlign.center, // Center the text
                                  style: CustomTextStyles.green14,
                                ),
                              ],
                            ),
                            Container(
                                width: SizeUtils.width/2.5,
                                child: Text('(Amount received by the receiver)', style: CustomTextStyles.gray12,))
                          ],
                        ),
                      ),
                      //  SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Close button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CustomImageView(
                    height: 50.v,
                    width: 50.v,
                    fit: BoxFit.fill,
                    color: Colors.white,
                    imagePath: ImageConstant.close,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
    //       ),
    //       contentPadding: EdgeInsets.zero,
    //       content: Stack(
    //         children: [
    //           Container(
    //             width: SizeUtils.width,
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Container(
    //                   width: 200,
    //                   padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
    //                   decoration: BoxDecoration(
    //                       color: appTheme.main,
    //                       borderRadius: const BorderRadius.only(
    //                         bottomLeft: Radius.circular(20),
    //                         bottomRight: Radius.circular(20),
    //                       )),
    //                   child: Text('Transaction summary',
    //                     textAlign: TextAlign.center, // Center the text
    //                     style: CustomTextStyles.white14,
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text('Total Amount',
    //                             textAlign: TextAlign.center, // Center the text
    //                             style: CustomTextStyles.gray7272_14,
    //                           ),
    //                           Text((transactionProvider.amountController.text!='')?transactionProvider.amountController.text:'0.0',
    //                             textAlign: TextAlign.center, // Center the text
    //                             style: CustomTextStyles.gray7272_14,
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 10,),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text('Platform fee',
    //                             textAlign: TextAlign.center, // Center the text
    //                             style: CustomTextStyles.gray7272_14,
    //                           ),
    //                           Text(transactionProvider.commissionAmount.toString(),
    //                             textAlign: TextAlign.center, // Center the text
    //                             style: CustomTextStyles.orange14,
    //                           ),
    //                         ],
    //                       ),
    //                       SizedBox(height: 15,),
    //                       CustomImageView(
    //                         imagePath: ImageConstant.dotLine,
    //                         width: SizeUtils.width-50,
    //                       ),
    //                       SizedBox(height: 15,),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text('Final Amount',
    //                             textAlign: TextAlign.center, // Center the text
    //                             style: CustomTextStyles.gray7272_16Bold,
    //                           ),
    //                           Text(afterCommission.toString(),
    //                             textAlign: TextAlign.center, // Center the text
    //                             style: CustomTextStyles.green14,
    //                           ),
    //                         ],
    //                       ),
    //                       Container(
    //                         width: SizeUtils.width/2.5,
    //                           child: Text('(Amount received by the receiver)', style: CustomTextStyles.gray12,))
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Positioned(
    //             top: 200,
    //             left: 0,
    //             right: 0,
    //             child: GestureDetector(
    //               onTap: () {
    //                 Navigator.pop(context);
    //               },
    //               child: CustomImageView(
    //                 height: 50,
    //                 width: 50,
    //                 // fit: BoxFit.fill,
    //                 color: Colors.red,
    //                 imagePath: ImageConstant.clear,
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //       actions: <Widget>[],
    //     );
    //   },
    //);
  }

  Widget _buildInfoCard() {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.07,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1.5,
              color: appTheme.color549FE3.withOpacity(0.2),
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
              items: <String>['USDT', 'Ethereum', 'Bitcoin']
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
                            Text(
                              (value == 'Ethereum')
                                  ? '${transactionProvider.ethBalance}  (ERC-20)': (value == 'USDT')?'${transactionProvider.usdtBalance}  (TRC-20)'
                                  : '${transactionProvider.btcBalance}',
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
              onChanged: (String? newValue) async {
                var blockchain = (newValue == 'Ethereum')?'ETH':(newValue == 'Bitcoin')?'BIT':'USDT';

                transactionProvider.setCurrency(newValue);
                transactionProvider.setUserAddress(blockchain);
                ///for change pop rate
                // transactionProvider.appendAmountController(transactionProvider.amountController.text);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                var userName = prefs.getString('userName');

                var bloc = (blockchain=='USDT')?'tron':(blockchain=='ETH')?'ethereum':'bitcoin';
                var net = (blockchain=='USDT')?'mainnet':(blockchain=='ETH')?'mainnet':'mainnet';

                if(transactionProvider.addressController.text != ''){
                  transactionProvider.validateAddress(transactionProvider.addressController.text, bloc, net, userName);
                }

              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
         Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const Text('Commission Rate',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: Color(0xff989898),
              ),
            ),
            InkWell(
              onTap: (){
                _showTooltip(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(Icons.info_outlined, size: 25, color: Color(0xff989898),),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: (transactionProvider.amountController.text == '')
                    ? appTheme.colorc3c3
                    : appTheme.main),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 150,
          // height: 60,
          child: TextFormField(
            controller: transactionProvider.amountController,
            style: CustomTextStyles.blue24_300,
            keyboardType: TextInputType.none,
            cursorColor: (transactionProvider.amountController.text == '')
                ? appTheme.colorc3c3
                : appTheme.main,
            decoration: const InputDecoration(
              hintText: "00.00",
              hintStyle: TextStyle(
                  color: Color(0xffB6B6B6),
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Poppins'),
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // _note(),
        // const SizedBox(
        //   height: 30,
        // ),
        SizedBox(
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
                buttonContent = Image.asset(
                  ImageConstant.clear,
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
      ],
    );
  }
}
