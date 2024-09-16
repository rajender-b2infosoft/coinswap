import 'dart:io';
import 'package:crypto_app/presentation/auth/provider/auth_provider.dart';
import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../core/utils/popup_util.dart';
import '../../widgets/custom_elevated_button.dart';

import 'package:camera/camera.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:ui';

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({super.key});

  @override
  State<VerifyIdentity> createState() => _VerifyIdentityState();
  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=> AuthProvider(),
      child: const VerifyIdentity(),
    );
  }
}



class _VerifyIdentityState extends State<VerifyIdentity> {
  late SelfieProvider selfieProvider;

  final ImagePicker _picker = ImagePicker();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  File? _imageFile;
  bool _isLoading = false;
  String? _imageName; // Store the image name
  String? _imageSize; // Store the image size
  bool _isFrontImage = true; // Track if we are capturing the front image
  FlashMode _flashMode = FlashMode.off; // Track the flash mode
  IconData isIcon = Icons.flash_auto;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // homeProvider = Provider.of<HomeScreenProvider>(context, listen: false);
      selfieProvider.resetAllData();
    });
    super.initState();
    _initializeCamera();

  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Toggle flash mode
  void _toggleFlashMode() async {
    try {
      setState(() {
        if (_flashMode == FlashMode.off) {
          _flashMode = FlashMode.auto;
        } else if (_flashMode == FlashMode.auto) {
          _flashMode = FlashMode.always;
        } else if (_flashMode == FlashMode.always) {
          _flashMode = FlashMode.off;
        }
      });
      _getFlashIcon();
      await _controller.setFlashMode(_flashMode);
    } catch (e) {
      print('Error setting flash mode: $e');
    }
  }

  _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.auto:
        setState(() {
          isIcon = Icons.flash_auto;
        });
        // return Icons.flash_auto;
      case FlashMode.always:
        setState(() {
          isIcon = Icons.flash_on;
        });
        // return Icons.flash_on;
      case FlashMode.off:
      default:
      setState(() {
        isIcon = Icons.flash_off;
      });
        // return Icons.flash_off;
    }
  }

  void _showCameraBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0)), // Set top border radius
      ),
      builder: (BuildContext context) {
        return Container(
          height: SizeUtils.height/1.5,
          child: CameraBottomSheet(
            controller: _controller,
            initializeControllerFuture: _initializeControllerFuture,
            onImageCaptured: _onImageCaptured,
            isFrontImage: _isFrontImage,
            imgLength: selfieProvider.images.length,
            onFlashToggle: _toggleFlashMode, // Pass the toggle function
            flashIcon: isIcon, // Pass the current flash icon
            // flashIcon: _getFlashIcon(), // Pass the current flash icon
          ),
        );
      },
    );
  }

  Future<void> _onImageCaptured(File imageFile) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    bool blurry = await checkIfImageIsBlurry(imageFile);

    setState(() {
      _isLoading = false; // Hide loading indicator
    });

    if (!blurry) {
      selfieProvider.addImage(imageFile);
      // setState(() async {
      //   _imageFile = imageFile; // Update the UI with the captured image
      //   _imageName = path.basename(imageFile.path); // Get the image name
      //   _imageSize = _formatFileSize(await imageFile.length());
      // });
      // await uploadImageToServer(imageFile);
      await selfieProvider.addDocument(imageFile, selfieProvider.groupValue);
      // showSnackBar('Image uploaded successfully!');
    } else {
      showSnackBar('Image is blurry, please retake the picture.');
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes bytes';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    }
  }

  bool checkIfImageIsBlurry(File imageFile) {
    final img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

    if (image != null) {
      double variance = calculateVarianceOfLaplacian(image);
      return variance < 100.0; // Threshold value for blurriness
    }
    return true; // Assume blurry if the image couldn't be loaded
  }

  double calculateVarianceOfLaplacian(img.Image image) {
    final img.Image grayscaleImage = img.grayscale(image);

    final List<num> laplacianFilter = [
      0,  1,  0,
      1, -4,  1,
      0,  1,  0,
    ];

    final img.Image laplacianImage = img.convolution(grayscaleImage, filter: laplacianFilter);

    int sum = 0;
    int sumSq = 0;
    int pixelCount = laplacianImage.width * laplacianImage.height;

    for (int y = 0; y < laplacianImage.height; y++) {
      for (int x = 0; x < laplacianImage.width; x++) {
        img.Pixel pixel = laplacianImage.getPixel(x, y);
        int intensity = pixel.r.toInt(); // Convert the red channel value to an int

        sum += intensity;
        sumSq += intensity * intensity;
      }
    }

    double mean = sum / pixelCount;
    double variance = (sumSq / pixelCount) - (mean * mean);
    return variance;
  }

  Future<void> uploadImageToServer(File file) async {
    // Your code to upload the file to the server
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


  @override
  Widget build(BuildContext context) {
     selfieProvider = Provider.of<SelfieProvider>(context, listen: true);
    return  WillPopScope(
      onWillPop: () async {
        bool shouldPop = await PopupUtil().onBackPressed(context);
        return shouldPop;
      },
      child: SafeArea(
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
                    left: (SizeUtils.width-120)/2.2,
                    bottom: SizeUtils.height/1.35,
                    child: CustomImageView(
                      imagePath: ImageConstant.logo,
                      height: 140.v,
                      width: 140.h,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: SizeUtils.height/1.6,
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
                      height: SizeUtils.height/1.5,
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
                              Text('Verify your identity',style: CustomTextStyles.pageTitleMain,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text('Please upload the picture of any of the documents to complete your registration.',
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyles.gray12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 0, right: 20),
                                      decoration: BoxDecoration(
                                        color: (selfieProvider.groupValue == 'aadhar')?const Color(0XFFDEEDFF):appTheme.grayLite,
                                        borderRadius: BorderRadius.circular(10,),
                                        border: Border.all(width: 1, color: (selfieProvider.groupValue == 'aadhar')?const Color(0XFF016FD3).withOpacity(0.5):appTheme.grayEE)
                                      ),
                                        child: radioButton(selfieProvider, 'Aadhar ID','aadhar', (selfieProvider.groupValue == 'aadhar')? appTheme.main:appTheme.gray)
                                    ),
                                    const SizedBox(width: 15,),
                                    CustomImageView(
                                      imagePath: ImageConstant.line,
                                    ),
                                    const SizedBox(width: 15,),
                                    Container(
                                        padding: const EdgeInsets.only(left: 0, right: 20),
                                        decoration: BoxDecoration(
                                            color: (selfieProvider.groupValue == 'passport')?appTheme.main.withOpacity(0.2):appTheme.grayLite,
                                            borderRadius: BorderRadius.circular(10,),
                                            border: Border.all(width: 1, color: (selfieProvider.groupValue == 'passport')?appTheme.main:appTheme.grayEE)
                                        ),
                                        child: radioButton(selfieProvider, 'Passport','passport', (selfieProvider.groupValue == 'passport')? appTheme.main:appTheme.gray)
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40,),
                              // (_groupValue == "aadhaar")?upload():uploadSelfie(),
                              upload(),





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
      ),
    );
  }

  Widget radioButton(SelfieProvider selfieProvider,String name , String value, color){
    return InkWell(
      onTap: (){
        if(selfieProvider.images.length>0 && selfieProvider.groupValue != value){
          CommonWidget.showToastView('If you want to upload $value image first remove image.', appTheme.gray8989);
        }else{
          selfieProvider.setGroupValue(value);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
              activeColor: appTheme.main,
              value: value,
              groupValue: selfieProvider.groupValue,
              onChanged: (val){
                // selfieProvider.setGroupValue(value);
                if(selfieProvider.images.length>0 && selfieProvider.groupValue != value){
                  CommonWidget.showToastView('If you want to upload $value image first remove image.', appTheme.gray8989);
                }else{
                  selfieProvider.setGroupValue(value);
                }
              },
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return appTheme.main;
              }
              return appTheme.gray;
            }),
          ),
          Text(name,style: TextStyle(
            color: color,
          ),)
        ],
      ),
    );
  }

  void popUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the radius here
          ),
          content: const Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text('Your identity verified successfully. Upload your selfie',
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            Center(
              child: CustomElevatedButton(
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: appTheme.main,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)
                    ),
                    elevation: 0
                ),
                buttonTextStyle: CustomTextStyles.white18,
                height: 50,
                width: 200,
                text: "Upload selfie",
                onPressed: () {
                    NavigatorService.pushNamed(AppRoutes.uploadSelfie);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget upload(){
    return Consumer<SelfieProvider>(
        builder: (context, selfieProvider, child) {
        return Column(
          children: [
            InkWell(
              onTap: (){
                if(selfieProvider.images.length < 2) {
                  _showCameraBottomSheet();
                }
                if(selfieProvider.images.length >= 2){
                  // NavigatorService.pushNamed(AppRoutes.uploadSelfie);
                  NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
                }
              },
              child: Container(
                height: 90,
                width: 200,
                decoration: BoxDecoration(
                  color: appTheme.main,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // (selfieProvider.images.length >= 2)?image('proceed'):image('cloud'),
                    // Text((selfieProvider.images.length >= 2)?'Capture Selfie':'Upload',style: CustomTextStyles.white18,)
                    (selfieProvider.images.length >= 2)?image('proceed'):image('cloud'),
                    Text((selfieProvider.images.length >= 2)?'Proceed':'Upload',style: CustomTextStyles.white18,)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            // if (_isLoading)
            //   const CircularProgressIndicator(), // Show a loading spinner
            // if (_imageFile != null && !_isLoading) ...[
              const SizedBox(height: 20),

              SizedBox(
                height: 400,
                child: ListView.builder(
                    itemCount: selfieProvider.images.length,
                    itemBuilder: (context, index) {
                      final image = selfieProvider.images[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          children: [
                            Image.file(
                              image.imageFile!,
                              width: 50.v,
                              height: 50.h,
                            ),
                            const SizedBox(width: 15,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: SizeUtils.width*0.5,
                                    child: Text(image.name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyles.gray7D7D_11
                                    )
                                ),
                                Text(selfieProvider.formatSize(image.size), style: CustomTextStyles.gray11),
                              ],
                            ),
                            const Spacer(),
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(width: 2, color: Colors.green)
                                  ),
                                  child: const Icon(Icons.done, size: 30, color: Colors.green),
                                ),
                                Positioned(
                                  top: 25,
                                  left: 25,
                                  child: InkWell(
                                    onTap:(){
                                      selfieProvider.deleteDocument(image.name.toString(), selfieProvider.groupValue);
                                      selfieProvider.removeImage(image.imageFile);
                                    }, child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.red
                                      ),
                                      child: const Icon(Icons.delete_rounded, size: 10, color: Colors.white)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   // crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Image.file(_imageFile!,
              //       width: 50.v,
              //       height: 40.h,
              //     ),
              //     const SizedBox(width: 5,),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(
              //             width: SizeUtils.width*0.5,
              //             child: Text('$_imageName',
              //                 overflow: TextOverflow.ellipsis,
              //                 style: CustomTextStyles.gray7D7D_11
              //             )
              //         ),
              //         Text('$_imageSize', style: CustomTextStyles.gray11),
              //       ],
              //     ),
              //     const Spacer(),
              //     Stack(
              //       children: [
              //         Container(
              //           padding: const EdgeInsets.all(3.0),
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(50),
              //               border: Border.all(width: 3, color: Colors.green)
              //           ),
              //           child: const Icon(Icons.done, size: 30, color: Colors.green),
              //         ),
              //         Positioned(
              //           top: 22,
              //           left: 22,
              //           child: InkWell(
              //             onTap:(){
              //               // selfieProvider.deleteDocument(image.name.toString(), selfieProvider.groupValue);
              //               // selfieProvider.removeImage(image.imageFile);
              //             }, child: Container(
              //               height: 20,
              //               width: 20,
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(50),
              //                   color: Colors.red
              //               ),
              //               child: const Icon(Icons.delete_rounded, size: 15, color: Colors.white)),
              //           ),
              //         ),
              //       ],
              //     )
              //   ],
              // ),
            // ],
          ],
        );
      }
    );
  }

  Widget image(type){
    if(type == 'proceed'){
      return Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: (selfieProvider.images.length >= 1)?appTheme.white:Colors.transparent,
          borderRadius: BorderRadius.circular(70),
        ),
        child: Icon(Icons.arrow_forward_outlined, size: 20, color: appTheme.main,),
      );
    }else{
      return CustomImageView(
        imagePath: ImageConstant.cloud,
        height: 30.v,
        width: 40.h,
      );
    }
  }


  // Widget uploadSelfie(SelfieProvider selfieProvider){
  //   return Column(
  //     children: [
  //       CustomImageView(
  //         imagePath: ImageConstant.capture,
  //       ),
  //       const SizedBox(height: 40,),
  //       _proceedButton(selfieProvider),
  //     ],
  //   );
  // }
  //
  // Widget _proceedButton(SelfieProvider selfieProvider) {
  //   return CustomElevatedButton(
  //     buttonStyle: ElevatedButton.styleFrom(
  //       backgroundColor: appTheme.main,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(50.0)
  //       ),
  //       elevation: 0
  //     ),
  //     buttonTextStyle: CustomTextStyles.white21,
  //     // height: 41.v,
  //     width: 250,
  //     text: "Capture",
  //     onPressed: () {
  //       // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
  //       if (selfieProvider.selfieImage == null) {
  //         CommonWidget.showToastView('Please take a selfie before proceeding!', appTheme.red);
  //       } else {
  //         var img = selfieProvider.selfieImage;
  //         selfieProvider.addDocument(img, context, 1, 'passport');
  //         // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
  //       }
  //     },
  //   );
  // }
}

class CameraBottomSheet extends StatelessWidget {
  final CameraController controller;
  final Future<void> initializeControllerFuture;
  final Function(File) onImageCaptured;
  final bool isFrontImage;
  final imgLength;
  final VoidCallback onFlashToggle; // Callback for flash toggle
  final IconData  flashIcon; // Flash icon based on the mode

  CameraBottomSheet({
    required this.controller,
    required this.initializeControllerFuture,
    required this.onImageCaptured,
    required this.isFrontImage,
    required this.imgLength,
    required this.onFlashToggle,
    required this.flashIcon,
  });

  Future<void> _takePicture(BuildContext context) async {
    try {
      await initializeControllerFuture;
      final imagePath = path.join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      XFile picture = await controller.takePicture(); // Take the picture without arguments

      final imageFile = File(picture.path); // Create File object from the path
      onImageCaptured(imageFile);
      Navigator.pop(context); // Close the bottom sheet
    } catch (e) {
      print(e);
      Navigator.pop(context); // Close the bottom sheet in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    var cameraSide = (imgLength<=0)?'front':'back';
    return FutureBuilder<void>(
      future: initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: <Widget>[
              SizedBox(
                height: SizeUtils.height/1.5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xff4C4C4C),
                      borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(child: Text('Upload the $cameraSide side of your document',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: appTheme.white
                  ),)),
                ),
              ),

              Positioned(
                bottom: 20,
                left: SizeUtils.width/3.2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: appTheme.main,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 2, color: appTheme.white)
                  ),
                  // child: Icon(Icons.electric_bolt_outlined, color: appTheme.white, size: 30,),
                  child: IconButton(
                    icon: Icon(flashIcon, color: appTheme.white, size: 30,),
                    onPressed: onFlashToggle,
                  ),
                ),
              ),

              Positioned(
                bottom: 20,
                left: SizeUtils.width/1.8,
                child: InkWell(
                  onTap: (){
                    _takePicture(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: appTheme.main,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 2, color: appTheme.white)
                    ),
                    child: Icon(Icons.camera_alt, color: appTheme.white, size: 30,),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}