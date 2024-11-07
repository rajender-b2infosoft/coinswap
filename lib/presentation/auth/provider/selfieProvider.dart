import 'dart:io';
// import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common_widget.dart';
import '../../../core/utils/navigation_service.dart';
import '../../../core/utils/size_utils.dart';
import '../../../routes/app_routes.dart';
import '../../../services/api_service.dart';
import '../../../theme/theme_helper.dart';
import '../models/imageDataModel.dart';
import 'package:path/path.dart' as p;


class SelfieProvider with ChangeNotifier {
  final apiService = ApiService();

  String _groupValue = "aadhar";
  String get groupValue => _groupValue;
  void setGroupValue(val){
    _groupValue = val;
    notifyListeners();
  }

  File? _selfieImage;
  bool _isImageSelected = false;

  File? get selfieImage => _selfieImage;
  setselfieImage(val){
    _selfieImage = val;
    notifyListeners();
  }

  bool get isImageSelected => _isImageSelected;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _imageName;
  String? _imageSize;
  List<File> _imageFiles = [];

  List<File> get imageFiles => _imageFiles;
  String? get imageName => _imageName;
  String? get imageSize => _imageSize;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoding(val){
    _isLoading = val;
    notifyListeners();
  }

  List<ImageData> _images = [];
  List<ImageData> get images => _images;

  final ImagePicker _picker = ImagePicker();

  void addImage(File imageFile) {
    final imageName = imageFile.path.split('/').last;
    final imageSize = imageFile.lengthSync();
    _images.add(ImageData(
      imageFile: imageFile,
      name: imageName,
      size: imageSize,
    ));
    notifyListeners();
  }

  // FaceCameraController? _controller;
  // FaceCameraController? get controller => _controller;

  File? _capturedImage;
  File? get capturedImage => _capturedImage;

  bool _isSelfieTaken = false;
  bool get isSelfieTaken => _isSelfieTaken;

  bool _isFaceCentered = false;
  bool get isFaceCentered => _isFaceCentered;

  bool _isFaceGreen = false;
  bool get isFaceGreen => _isFaceGreen;

  bool _isCameraInitialized = false;
  bool get isCameraInitialized => _isCameraInitialized;

  void setisFaceCentered(bool val) {
    _isFaceCentered = val;
    _isFaceGreen = val;
    notifyListeners();
    // if (_isFaceCentered != val) {
    //   _isFaceCentered = val;
    //   _isFaceGreen = val;
    //   notifyListeners();
    // }
  }

  void setIsFaceGreen(bool val) {
    _isFaceGreen = val;
    notifyListeners();
  }


  // Future<void> openCameraBottomSheet(context) async {
  //   // disposeCamera(); // Ensure the old camera is disposed
  //   await initializeCamera(context); // Reinitialize the camera
  //
  //   final capturedImage = await showModalBottomSheet<File?>(
  //     context: context,
  //     enableDrag: false,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     barrierColor: Colors.transparent,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(50), // Top border radius
  //       ),
  //     ),
  //     builder: (context) {
  //       return WillPopScope(
  //         onWillPop: () async{
  //           return false;
  //         },
  //         child: Container(
  //           padding: EdgeInsets.zero,
  //           height: SizeUtils.height / 1.5,
  //           width: 500,
  //           child: _isCameraInitialized
  //               ? ClipRRect(
  //             borderRadius: const BorderRadius.only(
  //               topRight: Radius.circular(50),
  //               topLeft: Radius.circular(50),
  //             ),
  //             child: Stack(
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.zero,
  //                   child: _controller != null
  //                       ? SmartFaceCamera(
  //                     controller: _controller!,
  //                     messageBuilder: (context, face) {
  //                       if (face == null) {
  //                         return Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
  //                           child: Text('Place your face in the camera',
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 fontSize: 14,
  //                                 height: 1.5,
  //                                 fontWeight: FontWeight.w400,
  //                                 color: appTheme.main
  //                             ),
  //                           ),
  //                         );
  //                       }
  //                       if (!face.wellPositioned) {
  //                         _isFaceGreen = false;
  //                         return Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
  //                           child: Text('Center your face in the circle',
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                                 fontSize: 14,
  //                                 height: 1.5,
  //                                 fontWeight: FontWeight.w600,
  //                                 color: appTheme.main
  //                             ),
  //                           ),
  //                         );
  //                       }
  //                       // if (!_isFaceCentered) {
  //                       //   _isFaceGreen = false;
  //                       //   return const Padding(
  //                       //     padding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
  //                       //     child: Text('Center your face in the circle..',
  //                       //       textAlign: TextAlign.center,
  //                       //       style: TextStyle(
  //                       //           fontSize: 14,
  //                       //           height: 1.5,
  //                       //           fontWeight: FontWeight.w400,
  //                       //           color: Color(0XFFFFFFFF)
  //                       //       ),
  //                       //     ),
  //                       //   );
  //                       // }
  //                       return const SizedBox.shrink();
  //                     },
  //                   )
  //                       : const Center(
  //                     child: Text('Error: Camera not initialized'),
  //                   ),
  //                 ),
  //                 Positioned(
  //                   top: SizeUtils.height / 8,
  //                   left: 20,
  //                   right: 20,
  //                   child: Container(
  //                     width: 250,
  //                     height: 250,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       border: Border.all(
  //                         color: appTheme.main,
  //                         width: 4,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //               : const Center(
  //               child: CircularProgressIndicator()),
  //         ),
  //       );
  //     },
  //   );
  //
  //   // Set the captured image to a variable and perform any additional actions
  //   if (capturedImage != null) {
  //     setselfieImage(capturedImage);
  //     _isFaceCentered = false;
  //     _isFaceGreen = false;
  //   }
  // }
  //
  // Future<void> initializeCamera(BuildContext context) async {
  //   try {
  //     await FaceCamera.initialize();
  //     print('FaceCamera initialized');
  //     _controller = FaceCameraController(
  //       autoCapture: false,
  //       defaultCameraLens: CameraLens.front,
  //       onCapture: (File? image) async {
  //         print('$_isFaceCentered @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@1111@@@@ $_isFaceGreen');
  //
  //         if (_isFaceCentered && _isFaceGreen) {
  //           print('Image captured');
  //           _capturedImage = image;
  //           Navigator.of(context).pop(image);
  //           _isFaceCentered = false;
  //           _isFaceGreen = false;
  //         } else {
  //           _isFaceCentered = false;
  //           _isFaceGreen = false;
  //
  //           print('$_isFaceCentered @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ $_isFaceGreen');
  //
  //           Navigator.of(context).pop(image);
  //           CommonWidget.showToastView('Please center your face in the camera.', appTheme.gray8989);
  //           openCameraBottomSheet(context);
  //         }
  //       },
  //       onFaceDetected: (Face? face) async {
  //         print('Face detected callback called');
  //         if (face != null) {
  //           bool isCentered = isFacePositionedCorrectly(face);
  //
  //           _isFaceCentered = isCentered;
  //           _isFaceGreen = isCentered;
  //           // setisFaceCentered(isCentered);
  //           // setIsFaceGreen(isCentered); // Update green state
  //         }
  //         else {
  //           // resetCamera(context);
  //           // await Future.delayed(Duration(seconds: 1));
  //           // initializeCamera(context);
  //           _isFaceCentered = false;
  //           _isFaceGreen = false;
  //         }
  //       },
  //     );
  //     _isCameraInitialized = true;
  //     notifyListeners();
  //     print('FaceCameraController initialized');
  //   } catch (e) {
  //     print('Error initializing FaceCamera: $e');
  //     _isCameraInitialized = false; // Ensure this is set to false on error
  //     notifyListeners();
  //   }
  // }
  //
  // bool isFacePositionedCorrectly(Face face) {
  //   final boundingBox = face.boundingBox;
  //   if (boundingBox == null) {
  //     print('Bounding box is null');
  //     return false;
  //   }
  //
  //   // Face dimensions
  //   final faceWidth = boundingBox.width;
  //   final faceHeight = boundingBox.height;
  //   print('Face Width: $faceWidth, Face Height: $faceHeight');
  //
  //   // Head rotation angles
  //   final headEulerAngleY = face.headEulerAngleY; // Left or right rotation
  //   final headEulerAngleZ = face.headEulerAngleZ; // Tilt angle
  //
  //   // Debugging print statements
  //   print('Head Euler Angle Y (left/right rotation): $headEulerAngleY');
  //   print('Head Euler Angle Z (tilt): $headEulerAngleZ');
  //
  //   // Define thresholds for head rotation
  //   const double maxRotationThresholdY = 15.0; // Allowable left/right rotation in degrees
  //   const double maxRotationThresholdZ = 10.0; // Allowable tilt in degrees
  //
  //   print("#################################################################################");
  //
  //   // Check if the face is centered and facing the camera directly
  //   final isCentered = faceWidth > 200 &&
  //       faceHeight > 200 &&
  //       headEulerAngleY!.abs() <= maxRotationThresholdY &&
  //       headEulerAngleZ!.abs() <= maxRotationThresholdZ;
  //
  //   print('Is Face Centered and Facing Camera: $isCentered');
  //   return isCentered;
  // }
  //
  // Future<void> resetCamera(BuildContext context) async {
  //   if (_controller != null) {
  //     await _controller!.dispose();
  //     _controller = null;
  //     _isFaceCentered = false;
  //     _isFaceGreen = false;
  //   }
  //
  //   try {
  //     // setisFaceCentered(false);
  //     // setIsFaceGreen(false);
  //     _isFaceCentered = false;
  //     _isFaceGreen = false;
  //
  //     initializeCamera(context);
  //     _isCameraInitialized = true;
  //     notifyListeners();
  //   } catch (e) {
  //     print('Error reinitializing FaceCamera: $e');
  //     _isCameraInitialized = false; // Ensure this is set to false on error
  //     notifyListeners();
  //   }
  // }



  Future<void> takeSelfie() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      _selfieImage = File(pickedImage.path);
      _isImageSelected = true;
      notifyListeners();
    }
  }

  Future<void> pickImage(BuildContext context, type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      addImage(File(pickedFile.path));
      final imageFile = File(pickedFile.path);
      await addDocument(imageFile, type);
    }
  }


  void resetAllData() {
    _images.clear();
    notifyListeners();
  }

  void removeImage(File imageFile) {
    _images.removeWhere((imageData) => imageData.imageFile == imageFile);
    notifyListeners();
  }

  String formatSize(int bytes) {
    final megabytes = bytes / (1024 * 1024);
    return '${megabytes.toStringAsFixed(2)} MB';
  }

  Future addDocument(File? image, type) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await apiService.uploadSelfie(image!, type);

      print('>>>>>>>>>>>>>>1231231213123123>>>>>>>>>>>>>>>>>response $response');


      if(response?['status'] == 'success') {
        CommonWidget.showToastView(response?['message'], appTheme.gray8989);
        await Future.delayed(const Duration(seconds: 1));
        if(type == 'selfie'){
          // NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String fileName = p.basename(image.toString());
          // Remove the single quote if present at the end
          if (fileName.endsWith("'")) {
            fileName = fileName.substring(0, fileName.length - 1);
          }

          await prefs.setString('profileImage', fileName.toString());

          NavigatorService.pushNamed(AppRoutes.verifyIdentity);
        }
      }else{
        CommonWidget.showToastView(response?['error'], appTheme.red);
      }
    }catch(e) {
      print(e);
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future deleteDocument(imgName, type) async {
    try {
      var response = await apiService.deleteImage(imgName, type);

      if(response?['status'] == 'success') {
        CommonWidget.showToastView(response?['message'], appTheme.gray8989);
        await Future.delayed(const Duration(seconds: 1));
        if(type == 'selfie'){
          NavigatorService.pushNamed(AppRoutes.registerSuccessScreen);
        }
      }else{
        CommonWidget.showToastView(response?['error'], appTheme.red);
      }
    }catch(e) {
      print(e);
    }finally{
      notifyListeners();
    }
  }

  void resetValidation() {
    _isImageSelected = false; // Reset validation
    notifyListeners();
  }

  void clearImage() {
    _images.clear();
    _imageName = null;
    _imageSize = null;
    notifyListeners();
  }


  // void disposeCamera() {
  //   if (_controller != null) {
  //     _controller!.dispose().then((_) {
  //       _controller = null;
  //       _isCameraInitialized = false;
  //       notifyListeners();
  //       print('FaceCamera disposed');
  //     }).catchError((error) {
  //       print('Error disposing FaceCamera: $error');
  //     });
  //   }
  // }

  @override
  void dispose() {
    // _controller?.dispose();
    super.dispose();
  }

}
