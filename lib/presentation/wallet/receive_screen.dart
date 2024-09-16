import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/app_export.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({super.key});

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: ReceiveScreen(),
    );
  }
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  late TransactionProvider transactionProvider;
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    getValue();
  }

  Future<void> getValue() async {
    transactionProvider.setAddress(await _secureStorage.read(key: 'address'));
    transactionProvider
        .setPrivateKey(await _secureStorage.read(key: 'privateKey'));
  }

  @override
  Widget build(BuildContext context) {
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

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
          'Receive ',
          style: CustomTextStyles.headlineMediumRegular,
        ),
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
              )),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Deposit currency',
                      style: CustomTextStyles.gray7272_19,
                    ),
                    // Container(
                    //   width: SizeUtils.width * 0.3,
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     color: appTheme.f6f6f6,
                    //     border: Border.all(
                    //         width: 1.5,
                    //         color: appTheme.color8383.withOpacity(0.2)),
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton2<String>(
                    //       value: transactionProvider.depositCurrency,
                    //       isExpanded: true,
                    //       iconStyleData: IconStyleData(
                    //         icon: Icon(
                    //           Icons.arrow_drop_down,
                    //           color: appTheme.gray8989,
                    //         ),
                    //         iconSize: 24,
                    //       ),
                    //       dropdownStyleData: DropdownStyleData(
                    //         padding: const EdgeInsets.symmetric(horizontal: 0),
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(15),
                    //         ),
                    //       ),
                    //       menuItemStyleData: const MenuItemStyleData(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 5, vertical: 4),
                    //       ),
                    //       // items: <String>['ETH', 'Bit', 'USDT'].map<DropdownMenuItem<String>>((String value) {
                    //       items: transactionProvider.assign_plans.entries
                    //           .map((MapEntry<String, String> entry) {
                    //         return DropdownMenuItem<String>(
                    //           value: entry.key,
                    //           child: LayoutBuilder(
                    //               builder: (context, constraints) {
                    //             return Row(
                    //               crossAxisAlignment: CrossAxisAlignment.center,
                    //               children: [
                    //                 CustomImageView(
                    //                   imagePath: (transactionProvider
                    //                               .depositCurrency ==
                    //                           'ETH')
                    //                       ? ImageConstant.eth
                    //                       : (transactionProvider
                    //                                   .depositCurrency ==
                    //                               'Bit')
                    //                           ? ImageConstant.bit
                    //                           : ImageConstant.t,
                    //                   width: 25,
                    //                   height: 25,
                    //                 ),
                    //                 const SizedBox(width: 5),
                    //                 SingleChildScrollView(
                    //                   child: Column(
                    //                     // direction: Axis.vertical,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(
                    //                         '${entry.key}',
                    //                         style: TextStyle(
                    //                             color: appTheme.green,
                    //                             fontFamily: 'Poppins',
                    //                             fontSize: 14,
                    //                             fontWeight: FontWeight.w400),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             );
                    //           }),
                    //         );
                    //       }).toList(),
                    //       onChanged: (String? newValue) {
                    //         transactionProvider.setdepositCurrency(newValue);
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: SizeUtils.width * 0.3,
                      height: 40,
                      decoration: BoxDecoration(
                        color: appTheme.f6f6f6,
                        border: Border.all(
                            width: 1.5,
                            color: appTheme.color8383.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          value: transactionProvider.depositCurrency,
                          isExpanded: true,
                          iconStyleData: IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: appTheme.gray8989,
                            ),
                            iconSize: 24,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 4, // Reduce vertical padding
                            ),
                          ),
                          // items: transactionProvider.assign_plans.entries
                          // .map((MapEntry<String, String> entry) {
                          items: <String>['ETH', 'BIT', 'USDT']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    (value ==
                                        'ETH')
                                        ? '${ImageConstant.eth}'
                                        : (value ==
                                        'BIT')
                                        ? '${ImageConstant.bit}'
                                        : '${ImageConstant.t}',
                                    width: 25,
                                    height: 25,
                                  ),
                                  const SizedBox(width: 5),
                                  SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$value',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                              color: appTheme.green
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
                            transactionProvider.setdepositCurrency(newValue);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        width: SizeUtils.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(width: 1, color: appTheme.blueLight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Network',
              style: CustomTextStyles.main14,
            ),
            Text(
              '${transactionProvider.depositCurrency} Classic',
              style: CustomTextStyles.gray7272_17,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Address',
              style: CustomTextStyles.main14,
            ),
            Row(
              children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    transactionProvider.address.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyles.gray7272_17,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: transactionProvider.address.toString()));
                  },
                  child: CustomImageView(
                    imagePath: ImageConstant.Copy,
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: QrImageView(
                // data: '{"toAddress":"${transactionProvider.address}","privateKey":"${transactionProvider.privateKey}"}',
                data: '{"toAddress":"${transactionProvider.address}"}',
                version: QrVersions.auto,
                size: 150.0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: appTheme.gray,
                    thickness: 1,
                    indent: 100,
                    endIndent: 0,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Scan ',
                  style: CustomTextStyles.gray14,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Divider(
                    color: appTheme.gray,
                    thickness: 1,
                    indent: 0,
                    endIndent: 100,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
