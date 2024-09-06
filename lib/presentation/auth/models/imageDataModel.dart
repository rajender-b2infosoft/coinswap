import 'dart:io';

class ImageData {
  final File imageFile;
  final String name;
  final int size;

  ImageData({
    required this.imageFile,
    required this.name,
    required this.size,
  });
}
