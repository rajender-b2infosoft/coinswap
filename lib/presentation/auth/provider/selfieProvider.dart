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


  @override
  void dispose() {
    // _controller?.dispose();
    super.dispose();
  }

}
