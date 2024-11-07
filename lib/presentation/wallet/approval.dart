import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class ApprovalScreen extends StatefulWidget {
  final String blockchain;
  final String status;
  final String address;
  final String amount;
  final String fee;
  final String note;
  final String date;
  final String page;

  const ApprovalScreen(
      {super.key, required this.blockchain, required this.status, required this.address, required this.amount, required this.fee, required this.note, required this.date, required this.page});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
  static Widget builder(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: ApprovalScreen(
          blockchain: args['blockchain'], status: args['status'], address: args['address'], amount: args['amount'], fee: args['fee'], note: args['note'], date: args['date'], page: args['page']
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
  }

  @override
  Widget build(BuildContext context) {
    transactionProvider = Provider.of<TransactionProvider>(context);

    print('lllllllllllllllllllllppp');
    print(widget.status);

    if(widget.status=='created'){
      img = ImageConstant.Request;
      statusText = 'Request processed';
      content = 'Transfer request processed on blockchain; payment status will be updated shortly';
    }else if(widget.status=='completed'){
      img = ImageConstant.success_green;
      statusText = 'Transfer successfully';
      content = 'Trasnfer successful, You paid ${widget.amount} ${widget.blockchain} to rajnishSingh';
    }else if(widget.status=='rejected'){
      img = ImageConstant.Failure;
      statusText = 'Request Rejected';
      content = 'Your transfer request was declined by the admin.';
    }
    print(widget.status);

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
                            color: (widget.status=='pending')?appTheme.main
                                :(widget.status=='rejected')?appTheme.red
                                :(widget.status=='created')?appTheme.orange
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
                          approvalStatus(),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 10.0),
                          //   child: Container(
                          //     height: 1,
                          //     width: SizeUtils.width/5.5,
                          //     decoration: BoxDecoration(
                          //       color: (widget.status=='processed')?appTheme.main:appTheme.gray,
                          //     ),
                          //   ),
                          // ),
                          // approvalStatus('2', 'processed'),
                          // Padding(
                          //   padding: const EdgeInsets.only(bottom: 10.0),
                          //   child: Container(
                          //     height: 1,
                          //     width: SizeUtils.width/5.5,
                          //     decoration: BoxDecoration(
                          //       color: (widget.status=='completed')?appTheme.main:appTheme.gray,
                          //     ),
                          //   ),
                          // ),
                          // approvalStatus('3', 'completed'),
                        ],
                      ),
                    ),
                    Text('Transfer Summary', style: CustomTextStyles.gray7272_16,),
                    const SizedBox(height: 10),
                    _buildActivityCard(widget.address, widget.blockchain,widget.amount,
                        widget.fee, widget.date),
                    const SizedBox(height: 10),
                    if(widget.note != '')
                    Text('Note', style: CustomTextStyles.gray7272_16,),
                    const SizedBox(height: 10),
                    if(widget.note != '')
                    Container(
                      width: SizeUtils.width,
                      height: 50,
                      padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                      decoration: BoxDecoration(
                        color: appTheme.white,
                        boxShadow: [
                          BoxShadow(
                            color: appTheme.color549FE3,
                            blurRadius: 1.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),),
                      child: Text(widget.note, style: CustomTextStyles.gray7272_12,),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(String address, String currency, String amount,
      String transactionId, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.white,
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
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  // color: appTheme.lightBlue,
                  color: (widget.status=='completed')?appTheme.colorBFFFBA
                      :(widget.status=='rejected')?appTheme.colorFFB8B8
                      :appTheme.lightBlue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  )),
              child: CustomImageView(
                fit: BoxFit.contain,
                imagePath: ImageConstant.arrowTop,
                width: 22,
                height: 25,
                color: (widget.status=='completed')?appTheme.green
                    :(widget.status=='rejected')?appTheme.red
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
                        text: '$currency',
                        style: (currency=='USDT')?CustomTextStyles.green14:(currency=='ETH')?CustomTextStyles.color7CA_14:CustomTextStyles.orange14,
                      ),
                      TextSpan(
                        text: ' | $amount',
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
                  Text(
                    transactionId,
                    style: CustomTextStyles.gray7272_12,
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
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget approvalStatus(){
    return Row(
      children: [
        Column(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: appTheme.main,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 1, color: appTheme.main)
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
              color: (widget.status=='created')?appTheme.main:(widget.status=='completed')?appTheme.main:appTheme.gray,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: (widget.status=='created')?appTheme.main:(widget.status=='completed')?appTheme.main:Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: (widget.status=='created')?appTheme.main:(widget.status=='completed')?appTheme.main:appTheme.gray)
              ),
              child: Center(
                  child: Text('2', style: (widget.status=='created')?CustomTextStyles.white17_400:(widget.status=='completed')?CustomTextStyles.white17_400:CustomTextStyles.gray16,)),
            ),
            Text(capitalizeFirstLetter('Processed'),style: (widget.status=='created')?CustomTextStyles.main8:(widget.status=='completed')?CustomTextStyles.main8:CustomTextStyles.gray8_7272,)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            height: 1,
            width: SizeUtils.width/5.5,
            decoration: BoxDecoration(
              color: (widget.status=='completed')?appTheme.main:appTheme.gray,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: (widget.status=='completed')?appTheme.main:Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: (widget.status=='completed')?appTheme.main:appTheme.gray)
              ),
              child: Center(
                  child: Text('3', style: (widget.status=='completed')?CustomTextStyles.white17_400:CustomTextStyles.gray16,)),
            ),
            Text(capitalizeFirstLetter('Success'),style: (widget.status=='completed')?CustomTextStyles.main8:CustomTextStyles.gray8_7272,)
          ],
        ),
      ],
    );
  }

}
