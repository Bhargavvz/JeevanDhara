import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImageService extends GetxService {
  static ImageService get to => Get.find();
  
  final ImagePicker _picker = ImagePicker();

  // Convert image to base64 string
  Future<String?> imageToBase64(XFile imageFile) async {
    try {
      Uint8List bytes = await imageFile.readAsBytes();
      
      // Compress image to reduce size
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return null;
      
      // Resize if too large (max 800x800)
      if (image.width > 800 || image.height > 800) {
        image = img.copyResize(image, width: 800, height: 800);
      }
      
      // Convert to JPEG with compression
      List<int> compressedBytes = img.encodeJpg(image, quality: 80);
      
      return base64Encode(compressedBytes);
    } catch (e) {
      debugPrint('Error converting image to base64: $e');
      return null;
    }
  }

  // Convert base64 string back to image bytes
  Uint8List? base64ToImage(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      debugPrint('Error converting base64 to image: $e');
      return null;
    }
  }

  // Pick and convert image to base64
  Future<String?> pickImageAsBase64({ImageSource source = ImageSource.gallery}) async {
    try {
      XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return null;
      
      return await imageToBase64(pickedFile);
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  // Pick multiple images and convert to base64
  Future<List<String>?> pickMultipleImagesAsBase64() async {
    try {
      List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles == null) return null;
      
      List<String> base64Images = [];
      for (XFile file in pickedFiles) {
        String? base64 = await imageToBase64(file);
        if (base64 != null) {
          base64Images.add(base64);
        }
      }
      
      return base64Images;
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      return null;
    }
  }

  // Get image size estimate in KB
  int getBase64SizeKB(String base64String) {
    return (base64String.length * 0.75 / 1024).round();
  }
}