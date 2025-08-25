// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:io';

// class CameraService {
//   static final ImagePicker _imagePicker = ImagePicker();
  
//   // Take photo with camera
//   static Future<String?> takePhoto({
//     int imageQuality = 70,
//     double? maxHeight = 1000,
//     double? maxWidth = 1000,
//   }) async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: imageQuality,
//         maxHeight: maxHeight,
//         maxWidth: maxWidth,
//       );
//       return image?.path;
//     } catch (e) {
//       print('Error taking photo: $e');
//       return null;
//     }
//   }

//   // Pick image from gallery
//   static Future<String?> pickFromGallery({
//     int imageQuality = 70,
//     double? maxHeight = 1000,
//     double? maxWidth = 1000,
//   }) async {
//     try {
//       final XFile? image = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: imageQuality,
//         maxHeight: maxHeight,
//         maxWidth: maxWidth,
//       );
//       return image?.path;
//     } catch (e) {
//       print('Error picking from gallery: $e');
//       return null;
//     }
//   }

//   // Pick PDF file
//   static Future<FilePickerResult?> pickPdfFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         allowMultiple: false,
//       );
//       return result;
//     } catch (e) {
//       print('Error picking PDF: $e');
//       return null;
//     }
//   }

//   // Pick any image file
//   static Future<FilePickerResult?> pickImageFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//         allowMultiple: false,
//       );
//       return result;
//     } catch (e) {
//       print('Error picking image file: $e');
//       return null;
//     }
//   }

//   // Validate file size (optional)
//   static bool isFileSizeValid(String filePath, {int maxSizeInMB = 10}) {
//     try {
//       final file = File(filePath);
//       final fileSizeInMB = file.lengthSync() / (1024 * 1024);
//       return fileSizeInMB <= maxSizeInMB;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Get file size in MB
//   static double getFileSizeInMB(String filePath) {
//     try {
//       final file = File(filePath);
//       return file.lengthSync() / (1024 * 1024);
//     } catch (e) {
//       return 0.0;
//     }
//   }
// }
