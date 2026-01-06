import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  // Private constructor
  ImagePickerService._privateConstructor();

  // Singleton instance
  static final ImagePickerService _instance =
      ImagePickerService._privateConstructor();

  // Getter
  static ImagePickerService get instance => _instance;

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } catch (e) {
      print("Gallery pick error: $e");
      return null;
    }
  }

  /// Take photo from camera
  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (pickedFile == null) return null;
      return File(pickedFile.path);
    } catch (e) {
      print("Camera pick error: $e");
      return null;
    }
  }
}
