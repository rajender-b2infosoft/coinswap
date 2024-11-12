import 'package:crypto_app/presentation/transactions/provider/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import 'models/transaction.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionScreenProvider(),
      child: const TransactionScreen(),
    );
  }
}

class _TransactionScreenState extends State<TransactionScreen> {
  late TransactionScreenProvider provider;
  late TextEditingController _dateController;

  String status = 'Pending';

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<TransactionScreenProvider>(context, listen: false);
      provider.transactionsData('','','');
    });
  }

  @override
  void dispose() {
    _dateController.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<TransactionScreenProvider>(context, listen: false);

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transactions',
              style: CustomTextStyles.headlineMediumRegular,
            ),
            // if(provider.transactionData != null)
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: (){
                  _showBottomSheet(context);
                },
                child: CustomImageView(
                  fit: BoxFit.contain,
                  imagePath: ImageConstant.filter,
                  width: 22,
                  height: 25,
                ),
              ),
            )
          ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                // if(provider.transactionData != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Consumer<TransactionScreenProvider>(
                      builder: (context, provider, child) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: appTheme.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: appTheme.color549FE3,
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap:(){
                                provider.setIsButton('sent');
                              },
                              child: Container(
                                width:140,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: (provider.isButton=='sent')?appTheme.main:Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(child: Text('Sent',style: (provider.isButton=='sent')?CustomTextStyles.white18:CustomTextStyles.main18,))
                              ),
                            ),
                            InkWell(
                              onTap:(){
                                provider.setIsButton('received');
                              },
                              child: Container(
                                  width:140,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: (provider.isButton=='received')?appTheme.main:Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(child: Text('Received',style: (provider.isButton=='received')?CustomTextStyles.white18:CustomTextStyles.main18,))),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
                const SizedBox(height: 30,),
                Container(
                  height: SizeUtils.height/1.5,
                  child: Consumer<TransactionScreenProvider>(
                      builder: (context, provider, child) {

                        if (provider.isLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (provider.transactionData == null || provider.transactionData!.data.isEmpty) {
                          return Center(
                              child: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Text('No transaction available', style: CustomTextStyles.gray7272_16),
                              ));
                        }
                        // Accessing transaction data
                        final List<TransactionData> data = provider.transactionData!.data;
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final tr = data[index];
                          var cryptoType = (tr.cryptoType=='bitcoin')?'BTC':(tr.cryptoType=='ethereum')?"ETH":"USDT";
                          var amount = (tr.transactionType=='dr')?'-${tr.amount}':'${tr.amount}';
                          var toAddress = (tr.transactionType=='dr')?tr.receiverWalletAddress:tr.senderWalletAddress;
                          DateTime parsedDate = DateTime.parse(tr.createdAt.toString());
                          String formattedDate = DateFormat('dd-MMM-yyyy').format(parsedDate);

                          return _buildActivityCard(tr.receiverWalletAddress.toString(), cryptoType, '${tr.amount}',
                              amount, formattedDate, tr.transactionType, tr.note, tr.status, tr.transactionId, toAddress);
                        }
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter', style: CustomTextStyles.main_20,),
                  InkWell(
                    onTap: (){
                      _dateController.text='';
                      provider.setStatus('Select Status');
                      provider.setType('Select Type');
                    },
                    child: Text('Reset', style: CustomTextStyles.gray18_color747474,)
                  ),
                ],
              ),
              const SizedBox(height: 40,),
              Text('Date', style: CustomTextStyles.main16,),
              const SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.color549FE3,
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                    fillColor: appTheme.lightBlue,
                    filled: true,
                    hintText: 'DD/MM/YY',
                    hintStyle: CustomTextStyles.gray18_color747474,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  controller: _dateController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    print(pickedDate);
                    if (pickedDate != null) {
                      provider.setDate(pickedDate);
                      setState(() {
                        // _dateController.text = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                        _dateController.text = "${pickedDate.year}-${pickedDate.day}-${pickedDate.month}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 40,),
              // Text('Type', style: CustomTextStyles.main16,),
              // const SizedBox(height: 10,),
              // typeButton(),
              // const SizedBox(height: 20,),
              Text('Status', style: CustomTextStyles.main16,),
              const SizedBox(height: 10,),
              statusButton(),
              const SizedBox(height: 40,),
              Center(
                  child: CustomElevatedButton(
                    buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: appTheme.main,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        elevation: 0
                    ),
                    buttonTextStyle: CustomTextStyles.white18,
                    height: 50,
                    width: 200,
                    text: 'Apply',
                    onPressed: () async {
                      var type = (provider.isButton=='sent')?'dr':'cr';
                      provider.transactionsData(type,status.toLowerCase(),_dateController.text);
                      Navigator.pop(context);
                    },
                  )
              )
            ],
          ),
        );
      },
    );
  }

  Widget typeButton(){
    return Container(
      padding: const EdgeInsets.only(left: 10),
      width: double.infinity,
      decoration: BoxDecoration (
        color: appTheme.lightBlue,
        boxShadow: [
          BoxShadow(
            color: appTheme.color549FE3,
            blurRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),

      child: Consumer<TransactionScreenProvider>(
          builder: (context, provider, child) {
            return DropdownButton<String>(
              value: provider.type,
              icon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: appTheme.gray7272,
                ),
              ),
              isExpanded: true,
              underline: const SizedBox(),
              items: <String>[
                'Select Type',
                'Send',
                'Received',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style:CustomTextStyles.gray18_color747474,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                provider.setType(newValue);
              },
            );
          }
      ),
    );
  }

  Widget statusButton() {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.lightBlue,
        boxShadow: [
          BoxShadow(
            color: appTheme.color549FE3,
            blurRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return DropdownButton<String>(
            value: status, // Bind the status variable
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: appTheme.gray7272,
              ),
            ),
            isExpanded: true,
            underline: const SizedBox(),
            items: <String>['Pending', 'Completed', 'Created'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: CustomTextStyles.gray18_color747474,
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                print('New value selected: $newValue');
                status = newValue!; // Update the status
                print('Updated status: $status');
              });
            },
          );
        }
      ),
    );
  }


  Widget _buildActivityCard(String address, String currency, String amount,
      String transactionId, String date, type, note, status, trxId, toAddress) {

    return InkWell(
      onTap: (){
        NavigatorService.pushNamed(AppRoutes.approvalScreen,
            argument: {'blockchain': currency,'status': status, 'address': address, 'amount': amount,
              'fee': 'slow', 'note': note, 'date': date, 'page': 'trx', 'trxId': (status!='pending')?trxId:'', 'toAddress':toAddress });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, right: 1, left: 3, top: 3),
        child: Container(
          decoration: BoxDecoration(
              color: appTheme.white,
              boxShadow: [
                BoxShadow(
                  color: appTheme.color549FE3,
                  blurRadius: 1.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: (type=='cr')?appTheme.colorBFFFBA:appTheme.colorFFB8B8,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
                child: CustomImageView(
                  fit: BoxFit.contain,
                  imagePath: (type=='cr')?ImageConstant.arrowBottom:ImageConstant.arrowTop,
                  width: 22,
                  height: 25,
                  color: (type=='cr')?appTheme.color2D9224:appTheme.red,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeUtils.width/2.3,
                    child: Text(
                      address,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.gray7272_13,
                    ),
                  ),
                  Row(
                    children: [
                      Text('$currency',
                        style: (currency=='USDT')?CustomTextStyles.green14:(currency=='ETH')?CustomTextStyles.color7CA_14:CustomTextStyles.orange14,
                      ),
                      SizedBox(
                        width: SizeUtils.width/4,
                        child: Text(' | $amount',
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.grayA0A0_12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: SizeUtils.width/5,
                      child: Text(
                        transactionId,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.gray7272_12,
                      ),
                    ),
                    Text(
                      date,
                      style: CustomTextStyles.grayA0A0_12,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
