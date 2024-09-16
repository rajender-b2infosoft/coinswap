import 'dart:io';
import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
import 'package:crypto_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:face_camera/face_camera.dart';

class UploadSelfie extends StatefulWidget {
  const UploadSelfie({super.key});

  @override
  State<UploadSelfie> createState() => _UploadSelfieState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelfieProvider(),
      child: const UploadSelfie(),
    );
  }
}

class _UploadSelfieState extends State<UploadSelfie> {
  late SelfieProvider selfieProvider;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    // selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
    // selfieProvider.initializeCamera(context);
    // Future.delayed(const Duration(seconds: 1), () {
    //   // _openCameraBottomSheet();
    //   selfieProvider.openCameraBottomSheet(context);
    // });
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      // Initialize camera only after permissions are granted
      selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
      // selfieProvider.initializeCamera(context);
      // Future.delayed(const Duration(seconds: 1), () {
      //   selfieProvider.openCameraBottomSheet(context);
      // });
    } else {
      print('Camera permission not granted');
      // Handle permission denial (e.g., show an alert to the user)
    }
  }

  Future<void> _captureSelfie() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      // Initialize camera only after permissions are granted
      selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
      selfieProvider.initializeCamera(context);
      Future.delayed(const Duration(seconds: 1), () {
        selfieProvider.openCameraBottomSheet(context);
      });
    } else {
      print('Camera permission not granted');
      // Handle permission denial (e.g., show an alert to the user)
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selfieProvider = Provider.of<SelfieProvider>(context);
  }

  // Future<void> _requestPermissions() async {
  //   final status = await Permission.camera.request();
  //   if (!status.isGranted) {
  //     // Handle permission denial
  //     print('Camera permission not granted');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.main,
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 0,
                  child: CustomImageView(
                    imagePath: ImageConstant.LooperGroup,
                    height: 120.v,
                    width: 120.h,
                    margin: EdgeInsets.only(bottom: 18.v),
                  ),
                ),
                Positioned(
                  left: (SizeUtils.width - 120) / 2.2,
                  bottom: SizeUtils.height / 1.35,
                  child: CustomImageView(
                    imagePath: ImageConstant.logo,
                    height: 140.v,
                    width: 140.h,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: SizeUtils.height / 1.6,
                  child: CustomImageView(
                    imagePath: ImageConstant.LooperGroupBottom,
                    height: 140.v,
                    width: 140.h,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: SizeUtils.height / 1.5,
                    decoration: BoxDecoration(
                      color: appTheme.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Upload your selfie',
                              style: CustomTextStyles.pageTitleMain,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
                              child: Center(
                                child: Text(
                                  '${(selfieProvider.capturedImage == null)?'The image should be clear and face fully visible':'Your image has been captured. Would you like to proceed or take another selfie?'}',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles.gray12,
                                ),
                              ),
                            ),
                            if(selfieProvider.capturedImage == null)
                            uploadSelfie(),
                            const SizedBox(height: 50,),
                            selfieProvider.capturedImage != null
                                ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 3, color: appTheme.main),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                  selfieProvider.capturedImage!,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                )
                                : Container(),
                            const SizedBox(height: 50,),
                            if(selfieProvider.capturedImage != null)
                              _proceedButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadSelfie(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7.0),
          child: CustomImageView(
            imagePath: ImageConstant.camera,
            width: 250,
            height: 250,
            fit: BoxFit.fill,
            // height: 320,
          ),
        ),
        const SizedBox(height: 50,),
        _capyureButton(),
      ],
    );
  }

  Widget _capyureButton() {
    return CustomElevatedButton(
      buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: appTheme.main,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(color: appTheme.main)
          ),
          elevation: 0
      ),
      buttonTextStyle: CustomTextStyles.white21,
      height: 50,
      width: 200,
      text: "Capture",
      onPressed: () async {
        _captureSelfie();
      },
    );
  }

  Widget _proceedButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: (){
            selfieProvider.resetCamera(context);
            selfieProvider.initializeCamera(context);
            selfieProvider.setisFaceCentered(false);
            selfieProvider.setIsFaceGreen(false);
            Future.delayed(const Duration(seconds: 1), () {
              selfieProvider.openCameraBottomSheet(context);
            });
          },
          child: Container(
              height: 50,
              width: 150,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 1, color: appTheme.main),
            ),
            child: Center(child: Text(selfieProvider.capturedImage != null ? "Take again" : "Capture"))
          ),
        ),
        // CustomElevatedButton(
        //   buttonStyle: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.transparent,
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(50.0),
        //           side: BorderSide(color: appTheme.main)
        //       ),
        //       elevation: 0
        //   ),
        //   buttonTextStyle: CustomTextStyles.main18_400,
        //   height: 50,
        //   width: 150,
        //   text: selfieProvider.capturedImage != null ? "Take again" : "Capture",
        //   onPressed: () async {
        //     selfieProvider.resetCamera(context);
        //     selfieProvider.initializeCamera(context);
        //     selfieProvider.setisFaceCentered(false);
        //     selfieProvider.setIsFaceGreen(false);
        //     Future.delayed(const Duration(seconds: 1), () {
        //       selfieProvider.openCameraBottomSheet(context);
        //     });
        //   },
        // ),

        (selfieProvider.isLoading)?Center(
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: appTheme.main
            ),
            child: selfieProvider.isLoading ? const Center(
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5,)) : null,
          ),
        ):CustomElevatedButton(
          buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: appTheme.main,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)
              ),
              elevation: 0
          ),
          buttonTextStyle: CustomTextStyles.white18,
          height: 50,
          width: 150,
          text: selfieProvider.isLoading ? '' :"Submit",
          onPressed: () async {
            if (!selfieProvider.isLoading) {
              selfieProvider.setLoding(true);

              if (selfieProvider.selfieImage != null) {
                try {
                  // selfieProvider.addDocument(_selfieImage, 'selfie');
                  await Provider.of<SelfieProvider>(context, listen: false).addDocument(selfieProvider.selfieImage, 'selfie');
                  selfieProvider.setLoding(false);
                  // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
                } catch (e) {
                  CommonWidget.showToastView(
                      'Error capturing picture: $e', appTheme.red);
                  selfieProvider.setLoding(false);
                }
              } else {
                CommonWidget.showToastView('Please take selfie first', appTheme.red);
                selfieProvider.setLoding(false);
                // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
              }
            }
          },
        ),
      ],
    );
  }

  bool get _controllerInitialized => selfieProvider.controller != null;
}

