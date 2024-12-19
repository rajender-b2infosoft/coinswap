import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';

class ApprovalScreen extends StatefulWidget {
  final String blockchain;
  final String page;
  final String? trxId;
  final int id;

  ApprovalScreen(
      {super.key, required this.blockchain,required this.page, required this.trxId, required this.id});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
  static Widget builder(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: ApprovalScreen(
          blockchain: args['blockchain'], page: args['page'], trxId: args['trxId'], id: args['id']
      ),
    );
  }
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  late TransactionProvider transactionProvider;

  var img = ImageConstant.approval;
  var statusText = 'Awaiting Approval';
  var content = 'Your transfer request is sent for approval, Kindly wait';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      transactionProvider.cryptocompare(widget.blockchain);
      // transactionProvider.getUserInfoByID(widget.userId);

      print('.................................///////');
      print(widget.trxId);
      print(widget.id);

      if(widget.id>0){
        transactionProvider.trxDetails(widget.id);
      }else{
        transactionProvider.trxDetailsByTransactionId(widget.trxId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    transactionProvider = Provider.of<TransactionProvider>(context);

    // if(widget.status=='created'){
    //   img = ImageConstant.Request;
    //   statusText = 'Request processed';
    //   content = 'Transfer request processed on blockchain; payment status will be updated shortly';
    // }else if(widget.status=='completed'){
    //   double amount = double.parse(widget.amount);
    //   img = ImageConstant.success_green;
    //   statusText = 'Transfer successfully';
    //   content = 'Transfer successful, You paid ${amount.toStringAsFixed(2)} ${widget.blockchain} to ${widget.toAddress}';
    // }else if(widget.status=='rejected'){
    //   img = ImageConstant.Failure;
    //   statusText = 'Request Rejected';
    //   content = 'Your transfer request was declined by the admin.';
    // }
    // print(widget.status);

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
                if(widget.page== 'trx'){
                  Navigator.pop(context);
                }else{
                  NavigatorService.pushNamed(AppRoutes.homeScreen);
                }
              },
              child: Icon(
                Icons.clear,
                color: appTheme.white, size: 30,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 90.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: SizeUtils.height,
            width: SizeUtils.width,
            decoration: BoxDecoration(
                color: appTheme.white1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                child: Consumer<TransactionProvider>(
                    builder: (context, provider, child) {

                      var status = provider.transaction?.status;
                      var amount = provider.transaction?.amount??'';
                      var commissionAmount = provider.transaction?.commissionAmount??'0.0';
                      var blockchain = provider.transaction?.cryptoType??'';
                      var toAddress = provider.transaction?.receiverWalletAddress??'';
                      var fee = provider.transaction?.feePriority??'';
                      var date = provider.transaction?.createdAt??'';
                      var transaction_fee = provider.transaction?.transactionFee??'';


                      content = (status=='created')?'Transfer request processed on blockchain; payment status will be updated shortly':
                      (status=='completed')?'Transfer successful, You paid $amount $blockchain to $toAddress':
                      (status=='rejected')?'Your transfer request was declined by the admin.':
                      'Your transfer request is sent for approval, Kindly wait';

                      statusText = (status=='created')? 'Request processed':(status=='completed')? 'Transfer successfully':
                      (status=='pending')?'Awaiting Approval':'Request Rejected';

                      img = (status=='rejected')? ImageConstant.Failure:(status=='completed')? ImageConstant.success_green:
                      (status=='pending')? ImageConstant.approval:ImageConstant.Request;

                      if(date.toString()!=''){
                        DateTime dateTime = DateTime.parse(date.toString());
                        DateFormat formatter = DateFormat('dd-MMM-yyyy');
                        date=formatter.format(dateTime).toString();
                      }
                       // formatter.format(dateTime);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CustomImageView(
                            imagePath: img,
                            width: 90,
                            height: 90,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                            child: Text(statusText,
                              style: TextStyle(
                                color: (status=='pending')?appTheme.main_mpin
                                    :(status=='rejected')?appTheme.red
                                    :(status=='created')?appTheme.orange
                                    :appTheme.green,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                        ),
                        const SizedBox(height: 10),
                        Text(content,
                          textAlign: TextAlign.center ,style: CustomTextStyles.gray13,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              approvalStatus(status),
                            ],
                          ),
                        ),
                        Text('Transfer Summary', style: CustomTextStyles.gray7272_16,),
                        const SizedBox(height: 10),
                        _buildActivityCard(toAddress, blockchain,amount,fee,date.toString(), status, commissionAmount, transaction_fee),
                        const SizedBox(height: 10),
                        // if(widget.note != '')
                        // Text('Note', style: CustomTextStyles.gray7272_16,),
                        // const SizedBox(height: 10),
                        // if(widget.note != '')
                        // Container(
                        //   width: SizeUtils.width,
                        //   height: 50,
                        //   padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                        //   decoration: BoxDecoration(
                        //     color: appTheme.white,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: appTheme.color549FE3,
                        //         blurRadius: 1.0,
                        //       ),
                        //     ],
                        //     borderRadius: BorderRadius.circular(10),),
                        //   child: Text(widget.note, style: CustomTextStyles.gray7272_12,),
                        // )
                      ],
                    );
                  }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(String address, String currency, String amount,
      String transactionId, String date, status, commissionAmount, transaction_fee) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        // height: 300,
        decoration: BoxDecoration(
          color: appTheme.white1,
          boxShadow: [
            BoxShadow(
              color: appTheme.color549FE3,
              blurRadius: 1.0,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: (status == 'pending')?Colors.transparent:appTheme.lBlue, // Change to your desired color
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        // color: appTheme.lightBlue,
                        color: (status=='completed')?appTheme.colorBFFFBA
                            :(status=='rejected')?appTheme.colorFFB8B8
                            :appTheme.lightBlue,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          // bottomLeft: Radius.circular(10),
                        )),
                    child: CustomImageView(
                      fit: BoxFit.contain,
                      imagePath: ImageConstant.arrowTop,
                      width: 22,
                      height: 25,
                      color: (status=='completed')?appTheme.green
                          :(status=='rejected')?appTheme.red
                          :appTheme.main,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeUtils.width/2.5,
                        child: Text(
                          address,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.gray7272_13,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${currency.toUpperCase()}',
                              style: (currency=='USDT')?CustomTextStyles.green14:(currency=='ETH')?CustomTextStyles.color7CA_14:CustomTextStyles.orange14,
                            ),
                            TextSpan(
                              text: ' | ${amount}',
                              style: CustomTextStyles.grayA0A0_12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Text(
                        //   transactionId,
                        //   style: CustomTextStyles.gray7272_12,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            date,
                            style: CustomTextStyles.grayA0A0_12,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if(status != 'pending')
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tx Hash', style: CustomTextStyles.gray7272_12,),
                  const SizedBox(height: 5,),
                  InkWell(
                    onTap: (){
                      Clipboard.setData(ClipboardData(
                          text:widget.trxId.toString()));
                    },
                      child: Text('${(widget.trxId!=null)?widget.trxId:''}', style: CustomTextStyles.main_mpin10,)),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('From', style: CustomTextStyles.gray7272_12,),
                      InkWell(
                        onTap: (){
                          Clipboard.setData(ClipboardData(
                              text:address.toString()));
                        },
                        child: Container(
                          width: SizeUtils.width/2,
                          child: Text(address,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.main_mpin10,),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Network', style: CustomTextStyles.gray7272_12,),
                      Text(currency.toUpperCase(), style: CustomTextStyles.grayA0A0_12,),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rate', style: CustomTextStyles.gray7272_12,),
                      Text('1 ${widget.blockchain} = ${transactionProvider.cryptoCompareUSD.toString()} USD', style: CustomTextStyles.grayA0A0_12,),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Platform fee', style: CustomTextStyles.gray7272_12,),
                      Text('${double.parse(commissionAmount).toStringAsFixed(2)}/ ${double.parse(commissionAmount)*transactionProvider.cryptoCompareUSD} USD', style: CustomTextStyles.grayA0A0_12,),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transaction fee', style: CustomTextStyles.gray7272_12,),
                      Text('$transaction_fee', style: CustomTextStyles.grayA0A0_12,),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget approvalStatus(status){
    return Row(
      children: [
        Column(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: appTheme.main_mpin,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 1, color: appTheme.main_mpin)
              ),
              child: Center(
                  child: Text('1', style: CustomTextStyles.white17_400)),
            ),
            Text(capitalizeFirstLetter('Approval'),style: CustomTextStyles.main8)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            height: 1,
            width: SizeUtils.width/5.5,
            decoration: BoxDecoration(
              color: (status=='created')?
              appTheme.main_mpin:(status=='completed')?appTheme.main_mpin:appTheme.gray,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: (status=='created')?appTheme.main_mpin
                      :(status=='completed')?appTheme.main_mpin:Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: (status=='created')?appTheme.main:(status=='completed')?appTheme.main:appTheme.gray)
              ),
              child: Center(
                  child: Text('2', style: (status=='created')?CustomTextStyles.white17_400:(status=='completed')?CustomTextStyles.white17_400:CustomTextStyles.gray16,)),
            ),
            Text(capitalizeFirstLetter('Processed'),style: (status=='created')?CustomTextStyles.main8:(status=='completed')?CustomTextStyles.main8:CustomTextStyles.gray8_7272,)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            height: 1,
            width: SizeUtils.width/5.5,
            decoration: BoxDecoration(
              color: (status=='completed')?appTheme.main_mpin:appTheme.gray,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: (status=='completed')?appTheme.main_mpin:Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: (status=='completed')?appTheme.main_mpin:appTheme.gray)
              ),
              child: Center(
                  child: Text('3', style: (status=='completed')?CustomTextStyles.white17_400:CustomTextStyles.gray16,)),
            ),
            Text(capitalizeFirstLetter('Success'),style: (status=='completed')?CustomTextStyles.main8:CustomTextStyles.gray8_7272,)
          ],
        ),
      ],
    );
  }

}
