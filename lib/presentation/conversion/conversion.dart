
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../wallet/provider/transaction_provider.dart';

class ConversionScreen extends StatefulWidget {
  const ConversionScreen({super.key});

  @override
  State<ConversionScreen> createState() => _ConversionScreenState();
  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=> TransactionProvider(),
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
    provider =
        Provider.of<TransactionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    provider =
        Provider.of<TransactionProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.main,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: (){
              NavigatorService.goBack();
            },
            child: Icon(Icons.arrow_back_ios, color: appTheme.white,)),
        title: Text('Conversion ',
          style:  CustomTextStyles.headlineMediumRegular,),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: SizeUtils.height,
          decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )
          ),
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
                Text(
                  '1.3981293 BTC | 34,500 USD',
                  style: CustomTextStyles.color9898_13,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Conversion Rate',
                      style: CustomTextStyles.gray7272_16,
                    ),
                    const SizedBox(width: 5),
                    CustomImageView(
                      imagePath: ImageConstant.bit,
                      width: 18,
                      height: 18,
                    )
                  ],
                ),
                Text(
                  '1 ETH = 19.90912 BTC',
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
                          color: appTheme.white,
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
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            ),
                            items:  <String>['ETH', 'BTC', 'USDT']
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
                                    Text(value, style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: appTheme.gray7272,
                                    ),)
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                provider.setChooseCurrency(newValue);
                              });
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
                          color: appTheme.white,

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
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            ),
                            items: <String>['BTC','ETH','USDT']
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
                                    Text(value, style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: appTheme.gray7272,
                                    ),),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                provider.setConversionCurrency(newValue);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30,),
                Text(
                  'Enter Amount',
                  style: CustomTextStyles.gray7272_16,
                ),

                const SizedBox(height: 10,),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: appTheme.white,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          '428.04',
                          style: CustomTextStyles.color549FE3_17,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: appTheme.main,
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: CustomImageView(
                          imagePath: ImageConstant.loop,
                          width: 20,
                          // height: 25,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          '2124.24',
                          style: CustomTextStyles.color549FE3_17,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50,),
                _proceedButton(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _proceedButton() {
    return Center(
      child: CustomElevatedButton(
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: appTheme.main,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0)
          ),
          elevation: 0,
        ),
        buttonTextStyle: CustomTextStyles.white18,
        height: 50,
        width: 250,
        text: "Confirm",
        // margin: EdgeInsets.only(left: 42.h, right: 42.h),
        onPressed: () {
          NavigatorService.pushNamed(AppRoutes.conversionDone);
        },
      ),
    );
  }
}