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
    selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
    selfieProvider.initializeCamera(context);
    Future.delayed(const Duration(seconds: 1), () {
      // _openCameraBottomSheet();
      selfieProvider.openCameraBottomSheet(context);
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selfieProvider = Provider.of<SelfieProvider>(context);
  }

  // Future<void> _openCameraBottomSheet() async {
  //   final capturedImage = await showModalBottomSheet<File?>(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(50), // Top border radius
  //       ),
  //     ),
  //     builder: (context) {
  //       return Container(
  //         padding: EdgeInsets.zero,
  //         height: SizeUtils.height / 1.5,
  //         width: 500,
  //         child: selfieProvider.isCameraInitialized
  //             ? ClipRRect(
  //           borderRadius: const BorderRadius.only(
  //             topRight: Radius.circular(50),
  //             topLeft: Radius.circular(50),
  //           ),
  //           child: Stack(
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.zero,
  //                 // child: SmartFaceCamera(
  //                 //   controller: selfieProvider.controller,
  //                 //   messageBuilder: (context, face) {
  //                 //     if (face == null) {
  //                 //       return _message('Place your face in the camera');
  //                 //     }
  //                 //     if (!selfieProvider.isFaceCentered) {
  //                 //       return _message('Center your face in the circle');
  //                 //     }
  //                 //     return const SizedBox.shrink();
  //                 //   },
  //                 // ),
  //                 child: selfieProvider.controller != null
  //                     ? SmartFaceCamera(
  //                   controller: selfieProvider.controller!,
  //                   messageBuilder: (context, face) {
  //                     if (face == null) {
  //                       return _message('Place your face in the camera');
  //                     }
  //                     if (!selfieProvider.isFaceCentered) {
  //                       return _message('Center your face in the circle');
  //                     }
  //                     return const SizedBox.shrink();
  //                   },
  //                 )
  //                     : Center(
  //                   child: Text('Error: Camera not initialized'),
  //                 ),
  //               ),
  //               Positioned(
  //                 top: SizeUtils.height / 8,
  //                 left: 20,
  //                 right: 20,
  //                 child: Container(
  //                   width: 250,
  //                   height: 250,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     border: Border.all(
  //                       color: Colors.red,
  //                       // color: selfieProvider.isFaceCentered ? Colors.green : Colors.red,
  //                       width: 4,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //             : const Center(
  //             child: CircularProgressIndicator()), // Show a loading indicator if controller is not initialized
  //       );
  //     },
  //   );
  //
  //   // Set the captured image to a variable and perform any additional actions
  //   if (capturedImage != null) {
  //     setState(() {
  //       selfieProvider.setselfieImage(capturedImage);
  //       selfieProvider.setisFaceCentered(true);
  //     });
  //   }
  // }

  Future<void> _requestPermissions() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      // Handle permission denial
      print('Camera permission not granted');
    }
  }

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
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'The image should be clear and face fully visible',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles.gray12,
                                ),
                              ),
                            ),
                            // uploadSelfie(selfieProvider),

                            const SizedBox(height: 50,),
                            selfieProvider.capturedImage != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selfieProvider.capturedImage!,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
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

  // Widget _message(String msg) => Padding(
  //   padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
  //   child: Text(
  //     msg,
  //     textAlign: TextAlign.center,
  //     style: const TextStyle(
  //         fontSize: 14,
  //         height: 1.5,
  //         fontWeight: FontWeight.w400,
  //         color: Color(0XFFFFFFFF)
  //     ),
  //   ),
  // );

  bool get _controllerInitialized => selfieProvider.controller != null;
}



// import 'dart:io';
// import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../common_widget.dart';
// import '../../core/app_export.dart';
// import '../../widgets/custom_elevated_button.dart';
// import 'package:face_camera/face_camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
//
// class UploadSelfie extends StatefulWidget {
//   const UploadSelfie({super.key});
//
//   @override
//   State<UploadSelfie> createState() => _UploadSelfieState();
//   static Widget builder(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => SelfieProvider(),
//       child: UploadSelfie(),
//     );
//   }
// }
//
// class _UploadSelfieState extends State<UploadSelfie> with WidgetsBindingObserver {
//   late SelfieProvider selfieProvider;
//
//
//   File? _selfieImage;
//   File? _capturedImage;
//   late FaceCameraController _controller;
//   bool _isFaceCentered = false;
//   bool _isFaceGreen = false;
//   bool _isCameraInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _requestPermissions();
//     selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
//     initializeCamera(context);
//     Future.delayed(const Duration(seconds: 1), () {
//       if (_isCameraInitialized) {
//         _openCameraBottomSheet();
//       } else {
//         print('Camera initialization failed............');
//       }
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     selfieProvider = Provider.of<SelfieProvider>(context);
//   }
//
//   @override
//   void dispose() {
//     selfieProvider.disposeCamera();
//     WidgetsBinding.instance.removeObserver(this); // Unregister the observer
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (_controller != null) {
//       if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
//         // Dispose of the controller to release camera resources
//         disposeCamera();
//       } else if (state == AppLifecycleState.resumed) {
//         // Reinitialize the camera when the app is resumed
//         initializeCamera(context);
//       }
//     }
//     super.didChangeAppLifecycleState(state);
//   }
//
//   void disposeCamera() {
//     if (_isCameraInitialized) {
//       _controller.dispose();
//       _isCameraInitialized = false;
//       print('FaceCamera disposed');
//     }
//   }
//
//   Future<void> _openCameraBottomSheet() async {
//     await initializeCamera(context);
//
//     final capturedImage = await showModalBottomSheet<File?>(
//       context: context,
//       isScrollControlled: true,
//       barrierColor: Colors.transparent,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(50), // Top border radius
//         ),
//       ),
//       builder: (context) {
//         return Material(
//           type: MaterialType.transparency,
//           child: Container(
//             padding: EdgeInsets.zero,
//             height: SizeUtils.height / 1.5,
//             width: double.infinity,
//             child: _isCameraInitialized
//                 ? ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(50),
//                 topLeft: Radius.circular(50),
//               ),
//               child: Stack(
//                 children: [
//                   Positioned.fill(
//                     child: SmartFaceCamera(
//                       controller: _controller,
//                       messageBuilder: (context, face) {
//                         if (face == null) {
//                           return _message('Place your face in the camera');
//                         }
//                         if (!_isFaceCentered) {
//                           return _message('Center your face in the camera');
//                         }
//                         return const SizedBox.shrink();
//                       },
//                     ),
//                   ),
//                   Positioned(
//                     top: SizeUtils.height / 8,
//                     left: 20,
//                     right: 20,
//                     child: Container(
//                       width: 250,
//                       height: 250,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: _isFaceCentered ? Colors.green : Colors.red,
//                           width: 4,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//                 : const Center(child: CircularProgressIndicator()), // Show a loading indicator if controller is not initialized
//           ),
//         );
//       },
//     );
//     if (capturedImage != null) {
//       setState(() {
//         _selfieImage = capturedImage;
//         _isFaceCentered = true;
//         _isFaceGreen = true;
//       });
//       // selfieProvider.setselfieImage(capturedImage);
//       // selfieProvider.setisFaceCentered(true);
//     }
//   }
//
//   Future<void> _requestPermissions() async {
//     final status = await Permission.camera.request();
//     if (!status.isGranted) {
//       print('Camera permission not granted');
//     }
//   }
//
//   Future<void> initializeCamera(context) async {
//     try {
//       await FaceCamera.initialize();
//       print('FaceCamera initialized');
//       _controller = FaceCameraController(
//         autoCapture: false,
//         defaultCameraLens: CameraLens.front,
//         onCapture: (File? image) {
//           // if (_isFaceCentered && _isFaceGreen) {
//           if (_isFaceCentered) {
//             setState(() {
//               _capturedImage = image;
//             });
//             Navigator.of(context).pop(image); // Close the bottom sheet and return the image
//           } else {
//             CommonWidget.showToastView('Please center your face in the camera.', appTheme.gray8989);
//           }
//         },
//         onFaceDetected: (Face? face) {
//           if (face != null) {
//             bool isCentered = isFacePositionedCorrectly(face.boundingBox);
//             setState(() {
//               _isFaceCentered = isCentered;
//               _isFaceGreen = isCentered;
//             });
//           } else {
//             setState(() {
//               _isFaceCentered = false;
//               _isFaceGreen = false;
//             });
//           }
//         },
//       );
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     } catch (e) {
//       print('Error initializing FaceCamera: $e');
//     }
//   }
//
//   bool isFacePositionedCorrectly(Rect faceRect) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height * 0.6;
//
//     final centerRegion = Rect.fromLTWH(
//       screenWidth * 0.25,
//       screenHeight * 0.25,
//       screenWidth * 0.5,
//       screenHeight * 0.5,
//     );
//     return centerRegion.contains(faceRect.center);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: appTheme.main,
//         body: ConstrainedBox(
//           constraints: BoxConstraints(
//             minHeight: MediaQuery.of(context).size.height,
//           ),
//           child: IntrinsicHeight(
//             child: Stack(
//               children: <Widget>[
//                 Positioned(
//                   left: 0,
//                   top: 0,
//                   child: CustomImageView(
//                     imagePath: ImageConstant.LooperGroup,
//                     height: 120.v,
//                     width: 120.h,
//                     margin: EdgeInsets.only(bottom: 18.v),
//                   ),
//                 ),
//                 Positioned(
//                   left: (SizeUtils.width - 120) / 2.2,
//                   bottom: SizeUtils.height / 1.35,
//                   child: CustomImageView(
//                     imagePath: ImageConstant.logo,
//                     height: 140.v,
//                     width: 140.h,
//                   ),
//                 ),
//                 Positioned(
//                   right: 0,
//                   bottom: SizeUtils.height / 1.6,
//                   child: CustomImageView(
//                     imagePath: ImageConstant.LooperGroupBottom,
//                     height: 140.v,
//                     width: 140.h,
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     height: SizeUtils.height / 1.5,
//                     decoration: BoxDecoration(
//                       color: appTheme.white,
//                       borderRadius: const BorderRadius.only(
//                         topRight: Radius.circular(50),
//                         topLeft: Radius.circular(50),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 15.0),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Upload your selfie',
//                               style: CustomTextStyles.pageTitleMain,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Center(
//                                 child: Text(
//                                   'The image should be clear and face fully visible',
//                                   textAlign: TextAlign.center,
//                                   style: CustomTextStyles.gray12,
//                                 ),
//                               ),
//                             ),
//                             // uploadSelfie(selfieProvider),
//
//                             SizedBox(height: 50),
//                             _capturedImage != null
//                                 ? ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.file(
//                                 _capturedImage!,
//                                 height: 200,
//                                 width: 200,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                                 : Container(),
//                             SizedBox(height: 50),
//                             if (_capturedImage == null)
//                               InkWell(
//                                 onTap: () {
//                                   _openCameraBottomSheet();
//                                 },
//                                 child: Container(
//                                   height: 50,
//                                   child: Text("Capture Selfie",),
//                                 ),
//                               ),
//
//
//                             // SizedBox(height: 50,),
//                             // _capturedImage != null
//                             //     ? ClipRRect(
//                             //   borderRadius: BorderRadius.circular(10),
//                             //       child: Image.file(
//                             //         _capturedImage!,
//                             //           height: 200,
//                             //           width: 200,
//                             //           fit: BoxFit.cover,
//                             //         ),
//                             //     )
//                             //     : Container(),
//                             // SizedBox(height: 50,),
//                             // if(_capturedImage != null)
//                             // _proceedButton(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _proceedButton() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         CustomElevatedButton(
//           buttonStyle: ElevatedButton.styleFrom(
//               backgroundColor: Colors.transparent,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50.0),
//                   side: BorderSide(color: appTheme.main)
//               ),
//               elevation: 0
//           ),
//           buttonTextStyle: CustomTextStyles.main18_400,
//           height: 50,
//           width: 150,
//           text: selfieProvider.capturedImage != null ? "Take again" : "Capture",
//           onPressed: () async {
//             _openCameraBottomSheet();
//           },
//         ),
//
//         (selfieProvider.isLoading)?Center(
//           child: Container(
//             height: 50,
//             width: 150,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//                 color: appTheme.main
//             ),
//             child: selfieProvider.isLoading ? const Center(
//                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5,)) : null,
//           ),
//         ):CustomElevatedButton(
//           buttonStyle: ElevatedButton.styleFrom(
//               backgroundColor: appTheme.main,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(50.0)
//               ),
//               elevation: 0
//           ),
//           buttonTextStyle: CustomTextStyles.white18,
//           height: 50,
//           width: 150,
//           text: selfieProvider.isLoading ? '' :"Submit",
//           onPressed: () async {
//             if (!selfieProvider.isLoading) {
//               selfieProvider.setLoding(true);
//
//               if (selfieProvider.selfieImage != null) {
//                 try {
//                   // selfieProvider.addDocument(_selfieImage, 'selfie');
//                   await Provider.of<SelfieProvider>(context, listen: false).addDocument(selfieProvider.selfieImage, 'selfie');
//                   selfieProvider.setLoding(false);
//                   // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
//                 } catch (e) {
//                   CommonWidget.showToastView(
//                       'Error capturing picture: $e', appTheme.red);
//                   selfieProvider.setLoding(false);
//                 }
//               } else {
//                 CommonWidget.showToastView('Please take selfie first', appTheme.red);
//                 selfieProvider.setLoding(false);
//                 // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
//               }
//             }
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _message(String msg) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
//         child: Text(
//           msg,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 14,
//             height: 1.5,
//             fontWeight: FontWeight.w400,
//             color: Color(0XFFFFFFFF)
//           ),
//         ),
//       );
//
//   bool get _controllerInitialized => selfieProvider.controller != null;
// }
//
//
//
