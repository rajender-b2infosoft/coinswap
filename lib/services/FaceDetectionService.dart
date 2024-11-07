import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetectionService {
  static const MethodChannel _channel = MethodChannel('face_detection_channel');

  final FaceDetector _faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
    ),
  );

   Future<bool> detectFaceInImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      return faces.isNotEmpty; // Returns true if any face is detected
    } catch (e) {
      print("Error detecting face: $e");
      return false;
    }
  }

  void dispose() {
    _faceDetector.close();
  }

 static  Future<Map<dynamic, dynamic>> getSatelliteInfo() async {
   final Map<dynamic, dynamic> satelliteInfo = await _channel.invokeMethod('getSatelliteInfo');
   print("CameraActivity Received file path: "+satelliteInfo.toString());
   return satelliteInfo;
 }

}
