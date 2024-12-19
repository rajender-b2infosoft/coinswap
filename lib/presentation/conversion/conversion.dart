import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../wallet/provider/transaction_provider.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: const ConversionScreen(),
    );
  }
}

class _ConversionScreenState extends State<ConversionScreen> {
  late TransactionProvider provider;
  var count = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<TransactionProvider>(context, listen: false);
      provider.getSettings(context);
      provider.userWalletData();
      provider.cryptoConvert(
          provider.chooseCurrency, provider.conversionCurrency);
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<TransactionProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          'Conversion ',
          style: CustomTextStyles.headlineMediumRegular,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: SizeUtils.height,
          decoration: BoxDecoration(
              color: appTheme.white1,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Available Balance',
                      style: CustomTextStyles.gray7272_16,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.wallet,
                      width: 30,
                      height: 30,
                    )
                  ],
                ),
                const SizedBox(height: 5),
                availableBalance(
                    ImageConstant.bit,
                    provider.ethereumWalletBalance,
                    'BTC',
                    provider.bitcoinConvertedBalance),
                const SizedBox(
                  height: 8,
                ),
                availableBalance(ImageConstant.t, provider.tronWalletBalance,
                    'USDT', provider.tronConvertedBalance),
                const SizedBox(
                  height: 8,
                ),
                availableBalance(
                    ImageConstant.eth,
                    provider.ethereumWalletBalance,
                    'ETH',
                    provider.ethereumConvertedBalance),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Conversion Rate',
                      style: CustomTextStyles.gray7272_16,
                    ),
                    const SizedBox(width: 5),
                    CustomImageView(
                      imagePath: (provider.conversionCurrency == 'BTC')
                          ? ImageConstant.bit
                          : (provider.conversionCurrency == 'ETH')
                              ? ImageConstant.eth
                              : ImageConstant.t,
                      width: 18,
                      height: 18,
                    )
                  ],
                ),
                Text(
                  '1 ${provider.chooseCurrency} = ${provider.convertedAmount} ${provider.conversionCurrency}',
                  style: CustomTextStyles.color9898_13,
                ),
                const SizedBox(height: 30),
                Text(
                  'Choose Currency',
                  style: CustomTextStyles.gray7272_16,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: appTheme.white1,
                          boxShadow: [
                            BoxShadow(
                              color: appTheme.color549FE3,
                              blurRadius: 1.0,
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            style: CustomTextStyles.main13,
                            value: provider.chooseCurrency,
                            isExpanded: true,
                            iconStyleData: IconStyleData(
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: appTheme.color549FE3,
                                ),
                              ),
                              iconSize: 30,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                            ),
                            items: <String>['ETH', 'BTC', 'USDT']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value, // Ensure unique value
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomImageView(
                                      imagePath: value == 'ETH'
                                          ? ImageConstant.eth
                                          : value == 'BTC'
                                              ? ImageConstant.bit
                                              : ImageConstant.t,
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: appTheme.gray7272,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              provider.cryptoConvert(
                                  newValue!, provider.conversionCurrency);
                              provider.setChooseCurrency(newValue);
                              provider.setInputAmount('0', 0);
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: appTheme.white1,
                          boxShadow: [
                            BoxShadow(
                              color: appTheme.color549FE3,
                              blurRadius: 1.0,
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            style: CustomTextStyles.main13,
                            value: provider.conversionCurrency,
                            isExpanded: true,
                            iconStyleData: IconStyleData(
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: appTheme.color549FE3,
                                ),
                              ),
                              iconSize: 30,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                            ),
                            items: <String>['BTC', 'ETH', 'USDT']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value, // Ensure unique value
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomImageView(
                                      imagePath: value == 'ETH'
                                          ? ImageConstant.eth
                                          : value == 'BTC'
                                              ? ImageConstant.bit
                                              : ImageConstant.t,
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: appTheme.gray7272,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              provider.cryptoConvert(
                                  provider.chooseCurrency, newValue!);
                              provider.setConversionCurrency(newValue);
                              provider.setInputAmount('0', 0);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Amount',
                  style: CustomTextStyles.gray7272_16,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: appTheme.white1,
                    // border: Border.all(width: 2, color: const Color(0XFF549FE3).withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: appTheme.color549FE3,
                        blurRadius: 1.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // Editable Input Field
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: provider.fromController,
                          keyboardType: TextInputType.number,
                          style: CustomTextStyles.color549FE3_17_conversion,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            hintText: '0.0',
                            hintStyle: TextStyle(color: appTheme.blueLight),
                          ),
                          onChanged: (val) {
                            print(val);
                            provider.setInputAmount(
                                val, provider.convertedAmount);
                            // provider.toController.text = (double.parse(provider.fromController.text)*double.parse(provider.convertedAmount));
                          },
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: appTheme.main_mpin,
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: CustomImageView(
                          imagePath: ImageConstant.loop,
                          width: 15,
                          // height: 25,
                        ),
                      )),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: provider.toController,
                          readOnly: true,
                          style: CustomTextStyles.color549FE3_17_conversion,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              border: InputBorder.none,
                              hintText: provider.toController.text,
                              hintStyle: TextStyle(color: appTheme.blueLight)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                _proceedButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget availableBalance(img, amount, type, convertedAmount) {
    return Row(
      children: [
        CustomImageView(
          imagePath: img,
          height: 15,
          width: 15,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          '$amount $type | ${amount * convertedAmount} USD',
          style: CustomTextStyles.color9898_13,
        ),
      ],
    );
  }

  _proceedButton() {
    return Center(
      child: CustomElevatedButton(
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: appTheme.mainTitle,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          elevation: 0,
        ),
        buttonTextStyle: CustomTextStyles.white18,
        height: 50,
        width: 250,
        text: "Confirm",
        // margin: EdgeInsets.only(left: 42.h, right: 42.h),
        onPressed: () async {
          NavigatorService.pushNamed(AppRoutes.conversionDone,
              argument: {'page': 'convert'});
          return;
          var fromAmount = (provider.fromController.text == '')
              ? '0.0'
              : provider.fromController.text;
          if (double.parse(fromAmount) > 0) {
            var isOtp = provider.userData;
            var cryptoType = (provider.chooseCurrency == 'ETH')
                ? 'Ethereum'
                : (provider.chooseCurrency == 'USDT')
                    ? 'USDT'
                    : 'bitcoin';
            // set user and user wallet data in walletData list
            await provider.userWalletData();
            //call function to set admin address in provider.adminAddress setter function
            await provider.getCommissionWallets(cryptoType.toLowerCase());
            //find the login user address according to selected crypto type
            final wallet = provider.walletData.firstWhere(
              (element) => element['crypto_type'] == cryptoType.toLowerCase(),
              orElse: () => {},
            );
            var fromAddress = wallet['wallet_address'];

            if (isOtp?['default_security'] == 1) {
              //1 means user proceed with m-pin
              NavigatorService.pushNamed(AppRoutes.walletPin, argument: {
                'toAddress': provider.adminAddress,
                'cryptoType': cryptoType,
                'amount': fromAmount,
                "note": 'note type',
                'fromAddress': fromAddress,
                'page': 'convert'
              });
            } else {
              // await provider.sendOtp(
              //   context,
              //   email,
              //   'otp',
              //   'transfer',
              //   toAddress,
              //   transactionProvider.selectedCurrency,
              //   amount,
              //   'note not added',
              //   fromAddress,
              // );
              provider.setLoding(false);
            }
            provider.setLoding(false);
          } else {
            CommonWidget.showToastView('Please enter amount', appTheme.red);
            provider.setLoding(false);
          }
          // NavigatorService.pushNamed(AppRoutes.conversionDone);
        },
      ),
    );
  }
}
