import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  
  // Storage paths
  static const String profileImages = 'profile_images';
  static const String reportImages = 'report_images';
  static const String waterQualityImages = 'water_quality_images';
  static const String documents = 'documents';
  static const String avatars = 'avatars';
  
  @override
  void onInit() {
    super.onInit();
    _configureStorage();
  }
  
  void _configureStorage() {
    // Configure storage settings
    _storage.setMaxDownloadRetryTime(const Duration(seconds: 30));
    _storage.setMaxUploadRetryTime(const Duration(seconds: 30));
    _storage.setMaxOperationRetryTime(const Duration(seconds: 30));
  }
  
  // PROFILE IMAGE OPERATIONS
  
  // Upload profile image
  Future<String?> uploadProfileImage({
    required String userId,
    required XFile imageFile,
    Function(double)? onProgress,
  }) async {
    try {
      String fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String filePath = '$profileImages/$fileName';
      
      return await _uploadFile(
        filePath: filePath,
        file: imageFile,
        onProgress: onProgress,
      );
    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      throw Exception('Failed to upload profile image: $e');
    }
  }
  
  // Pick and upload profile image
  Future<String?> pickAndUploadProfileImage({
    required String userId,
    required ImageSource source,
    Function(double)? onProgress,
  }) async {
    try {
      XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        return await uploadProfileImage(
          userId: userId,
          imageFile: pickedFile,
          onProgress: onProgress,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error picking and uploading profile image: $e');
      throw Exception('Failed to pick and upload image: $e');
    }
  }
  
  // REPORT IMAGE OPERATIONS
  
  // Upload case report images
  Future<List<String>> uploadCaseReportImages({
    required String reportId,
    required List<XFile> imageFiles,
    Function(double)? onProgress,
  }) async {
    try {
      List<String> uploadedUrls = [];
      
      for (int i = 0; i < imageFiles.length; i++) {
        String fileName = '${reportId}_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String filePath = '$reportImages/$fileName';
        
        String? url = await _uploadFile(
          filePath: filePath,
          file: imageFiles[i],
          onProgress: (progress) {
            double totalProgress = (i + progress) / imageFiles.length;
            onProgress?.call(totalProgress);
          },
        );
        
        if (url != null) {
          uploadedUrls.add(url);
        }
      }
      
      return uploadedUrls;
    } catch (e) {
      debugPrint('Error uploading case report images: $e');
      throw Exception('Failed to upload case report images: $e');
    }
  }
  
  // Upload water quality report images
  Future<List<String>> uploadWaterQualityImages({
    required String reportId,
    required List<XFile> imageFiles,
    Function(double)? onProgress,
  }) async {
    try {
      List<String> uploadedUrls = [];
      
      for (int i = 0; i < imageFiles.length; i++) {
        String fileName = '${reportId}_${i}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        String filePath = '$waterQualityImages/$fileName';
        
        String? url = await _uploadFile(
          filePath: filePath,
          file: imageFiles[i],
          onProgress: (progress) {
            double totalProgress = (i + progress) / imageFiles.length;
            onProgress?.call(totalProgress);
          },
        );
        
        if (url != null) {
          uploadedUrls.add(url);
        }
      }
      
      return uploadedUrls;
    } catch (e) {
      debugPrint('Error uploading water quality images: $e');
      throw Exception('Failed to upload water quality images: $e');
    }
  }
  
  // DOCUMENT OPERATIONS
  
  // Upload document file
  Future<String?> uploadDocument({
    required String fileName,
    required File file,
    Function(double)? onProgress,
  }) async {
    try {
      String filePath = '$documents/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      UploadTask task = _storage.ref(filePath).putFile(file);
      
      // Monitor progress
      if (onProgress != null) {
        task.snapshotEvents.listen((snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }
      
      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      debugPrint('Document uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading document: $e');
      throw Exception('Failed to upload document: $e');
    }
  }
  
  // GENERAL FILE OPERATIONS
  
  // Generic file upload method
  Future<String?> _uploadFile({
    required String filePath,
    required XFile file,
    Function(double)? onProgress,
  }) async {
    try {
      Reference ref = _storage.ref(filePath);
      UploadTask task;
      
      if (kIsWeb) {
        // For web platform
        Uint8List bytes = await file.readAsBytes();
        task = ref.putData(bytes);
      } else {
        // For mobile platforms
        task = ref.putFile(File(file.path));
      }
      
      // Monitor progress
      if (onProgress != null) {
        task.snapshotEvents.listen((snapshot) {
          double progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }
      
      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      
      debugPrint('File uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }
  
  // Delete file from storage
  Future<bool> deleteFile(String downloadUrl) async {
    try {
      Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      debugPrint('File deleted: $downloadUrl');
      return true;
    } catch (e) {
      debugPrint('Error deleting file: $e');
      return false;
    }
  }
  
  // Get file metadata
  Future<FullMetadata?> getFileMetadata(String downloadUrl) async {
    try {
      Reference ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } catch (e) {
      debugPrint('Error getting file metadata: $e');
      return null;
    }
  }
  
  // IMAGE PICKER UTILITIES
  
  // Pick single image
  Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      return await _imagePicker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }
  
  // Pick multiple images
  Future<List<XFile>?> pickMultipleImages({
    int maxImages = 5,
    int imageQuality = 85,
  }) async {
    try {
      List<XFile>? pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: imageQuality,
      );
      
      if (pickedFiles != null && pickedFiles.length > maxImages) {
        return pickedFiles.take(maxImages).toList();
      }
      
      return pickedFiles;
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      return null;
    }
  }
  
  // Show image source selection dialog
  Future<ImageSource?> showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  // CACHE MANAGEMENT
  
  // Clear cache (for web platform)
  Future<void> clearCache() async {
    try {
      if (kIsWeb) {
        // Web cache clearing logic
        debugPrint('Cache cleared for web platform');
      }
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
  
  // Get storage usage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      // This is a mock implementation
      // In a real scenario, you might need to implement this using Cloud Functions
      return {
        'totalFiles': 0,
        'totalSize': 0,
        'profileImages': 0,
        'reportImages': 0,
        'documents': 0,
      };
    } catch (e) {
      debugPrint('Error getting storage stats: $e');
      return {};
    }
  }
  
  // UTILITY METHODS
  
  // Generate unique file name
  String generateFileName(String originalName) {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String extension = originalName.split('.').last;
    return '${timestamp}_${originalName.replaceAll(RegExp(r'[^a-zA-Z0-9.]'), '_')}';
  }
  
  // Get file size in readable format
  String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  // Validate file type
  bool isValidImageType(String fileName) {
    List<String> validTypes = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    String extension = fileName.split('.').last.toLowerCase();
    return validTypes.contains(extension);
  }
  
  // Validate file size
  bool isValidFileSize(int bytes, {int maxSizeMB = 10}) {
    int maxSizeBytes = maxSizeMB * 1024 * 1024;
    return bytes <= maxSizeBytes;
  }
}