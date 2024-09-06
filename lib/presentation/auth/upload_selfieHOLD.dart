import 'dart:io';
import 'package:crypto_app/presentation/auth/provider/selfieProvider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common_widget.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import 'package:camera/camera.dart';
import 'package:face_camera/face_camera.dart';

class UploadSelfie extends StatefulWidget {
  const UploadSelfie({super.key});

  @override
  State<UploadSelfie> createState() => _UploadSelfieState();
  static Widget builder(BuildContext context){
    return ChangeNotifierProvider(
      create: (context)=> SelfieProvider(),
      child: const UploadSelfie(),
    );
  }
}

class _UploadSelfieState extends State<UploadSelfie> {
  late SelfieProvider selfieProvider;
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;
  File? _selfieImage;
  bool _isSelfieTaken = false;

  @override
  void initState() {
    super.initState();
    selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      var result = await Permission.camera.request();
      if (!result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission required')),
        );
        return;
      }
    }
    // Get available cameras
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      // Find the front camera
      final frontCamera = cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras![0], // Fallback to the first available camera if no front camera is found
      );
      _controller = CameraController(frontCamera, ResolutionPreset.high);
      await _controller?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No camera')),
      );
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selfieProvider = Provider.of<SelfieProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     selfieProvider = Provider.of<SelfieProvider>(context);
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
                            Text('Upload your selfie',style: CustomTextStyles.pageTitleMain,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('The image should be clear and face fully visible',
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles.gray12,
                                ),
                              ),
                            ),
                            // const SizedBox(height: 10,),
                            uploadSelfie(selfieProvider),
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

  Widget uploadSelfie(SelfieProvider selfieProvider){
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: CustomImageView(
                imagePath: ImageConstant.camera,
                width: 275,
                height: 317,
                fit: BoxFit.fill,
                // height: 320,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: appTheme.white,
                  child: _isCameraInitialized && _controller != null
                      ? FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: 230,
                      height: 270,
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        // child: CameraPreview(_controller!),
                        child: _selfieImage != null
                            ? Image.file(
                          _selfieImage!,
                          fit: BoxFit.cover,
                        )
                            : CameraPreview(_controller!),
                      ),
                    ),
                  )
                      : Center(child: CircularProgressIndicator()),
                ),
              ),
            ),

          ],
        ),
        // SizedBox(height: 16),
        // GestureDetector(
        //   onTap: () => context.read<SelfieProvider>().takeSelfie(),
        //   child: Container(
        //     width: 150,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20),
        //       border: Border.all(
        //         color: Colors.blueAccent,
        //         width: 2,
        //       ),
        //     ),
        //     child: context.watch<SelfieProvider>().selfieImage == null
        //         ? Center(
        //       child: Icon(
        //         Icons.camera_alt,
        //         size: 50,
        //         color: Colors.blueAccent,
        //       ),
        //     )
        //         : ClipRRect(
        //       borderRadius: BorderRadius.circular(18), // Apply the same radius here
        //       child: Image.file(
        //         context.watch<SelfieProvider>().selfieImage!,
        //         fit: BoxFit.cover,
        //         width: 150,
        //         height: 150,
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(height: 16),
        const SizedBox(height: 20,),
        _proceedButton(selfieProvider),
      ],
    );
  }

  Widget _proceedButton(SelfieProvider selfieProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomElevatedButton(
          buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(color: appTheme.main)
              ),
              elevation: 0
          ),
          buttonTextStyle: CustomTextStyles.main18_400,
          height: 50,
          width: 150,
          text: _isSelfieTaken ? "Take again" : "Capture",
          onPressed: () async {
            if (_isSelfieTaken) {
              setState(() {
                _selfieImage = null;
                _isSelfieTaken = false;
              });
              await _initializeCamera();
            }else {
              // Capture the selfie
              if (_controller != null && _controller!.value.isInitialized) {
                try {
                  final XFile image = await _controller!.takePicture();
                  // Convert XFile to File
                  final File imageFile = File(image.path);
                  setState(() {
                    _selfieImage = imageFile;
                    _isSelfieTaken = true;
                  });
                  // selfieProvider.addDocument(imageFile, 'selfie');

                  // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
                } catch (e) {
                  CommonWidget.showToastView('Error capturing picture: $e', appTheme.red);
                }
              } else {
                NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
              }
            }

            // if (_controller != null && _controller!.value.isInitialized) {
            //   try {
            //     final XFile image = await _controller!.takePicture();
            //     // Convert XFile to File
            //     final File imageFile = File(image.path);
            //     setState(() {
            //       _selfieImage = imageFile;
            //     });
            //     selfieProvider.addDocument(imageFile,'selfie');
            //     // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
            //   } catch (e) {
            //     CommonWidget.showToastView('Error capturing picture: $e', appTheme.red);
            //   }
            // }else{
            //   NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
            // }


          },
        ),

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

              if (_selfieImage != null) {
                try {
                  // selfieProvider.addDocument(_selfieImage, 'selfie');
                  await Provider.of<SelfieProvider>(context, listen: false).addDocument(_selfieImage, 'selfie');
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
}
