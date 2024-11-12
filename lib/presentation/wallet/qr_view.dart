import 'dart:convert';
import 'package:crypto_app/core/app_export.dart';
import 'package:crypto_app/presentation/wallet/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class ScannerScreen extends StatefulWidget {
  final String blockchain;

  const ScannerScreen({super.key, required this.blockchain});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
  static Widget builder(BuildContext context) {
    final args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: ScannerScreen(blockchain: args['blockchain']),
    );
  }
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    _requestCameraPermission();
  }

  void _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required')),
      );
    }
  }

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
      controller?.resumeCamera();
    }
  }

  void getScannerData(Barcode? rawResult) async {
    if (rawResult != null) {
      final jsonString = json.decode(rawResult.code.toString());
      if (jsonString['toAddress'] != null && jsonString['toAddress'].isNotEmpty) {
        Provider.of<TransactionProvider>(context, listen: false).setAddressController(jsonString['toAddress']);
        await Future.delayed(const Duration(seconds: 2));
        // NavigatorService.pushNamed(AppRoutes.transferScreen, argument: {'toAddress': jsonString['toAddress'], 'cryptoType': 'Ethereum', 'amount': ''});
        NavigatorService.pushNamed(AppRoutes.transferScreen, argument: {'toAddress': jsonString['toAddress'], 'cryptoType': widget.blockchain, 'amount': ''});
      } else {
        showErrorToast("Invalid QR Code. Address is empty.");
      }
    } else {
      showErrorToast("No Result Found, Please Try again");
    }
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            _buildQrView(context),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
                child: const Text(
                  'Scan wallet address',
                  style: TextStyle(fontSize: 16, color: Colors.white,),
                ),

              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.06,
                      color: appTheme.main,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                              onTap: () {
                                NavigatorService.goBack();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: appTheme.white,
                              )),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text(
                            textAlign: TextAlign.start,
                            'CoinSwap',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontFamily: "Poppins"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = 200.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: appTheme.main,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      try {
        // setState(() {
        //   result = scanData;
        //   getScannerData(result);
        // });
        if (scanData.code != null) {
          setState(() {
            result = scanData;
          });
          getScannerData(result);
          controller.pauseCamera(); // Pause the camera after a successful scan
        }
      } catch (e) {
        print('Error processing scan data:::::::::::::::: $e');
      }
      // setState(() {
      //   result = scanData;
      //   getScannerData(result);
      // });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera Permission Denied')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}


