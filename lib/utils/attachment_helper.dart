// // attachment_helper.dart - Helper class for UI interactions
// import 'package:flutter/material.dart';
// import 'package:palm_ecommerce_mobile_app_2/services/camera_services.dart';

// class AttachmentHelper {
//   static void showAttachmentOptions({
//     required BuildContext context,
//     required Function(String path, String name) onFileSelected,
//     required Function(String message) onError,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: false,
//       enableDrag: true,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.black87,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildAttachmentOption(
//                   context: context,
//                   title: 'Take Photo',
//                   icon: Icons.camera_alt,
//                   onTap: () => _handleCameraPhoto(context, onFileSelected, onError),
//                 ),
//                 const Divider(height: 1, color: Colors.grey),
//                 _buildAttachmentOption(
//                   context: context,
//                   title: 'Choose from Gallery',
//                   icon: Icons.photo_library,
//                   onTap: () => _handleGalleryPhoto(context, onFileSelected, onError),
//                 ),
//                 const Divider(height: 1, color: Colors.grey),
//                 _buildAttachmentOption(
//                   context: context,
//                   title: 'Select PDF File',
//                   icon: Icons.picture_as_pdf,
//                   onTap: () => _handlePdfFile(context, onFileSelected, onError),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   static Widget _buildAttachmentOption({
//     required BuildContext context,
//     required String title,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 24),
//             const SizedBox(width: 16),
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static Future<void> _handleCameraPhoto(
//     BuildContext context,
//     Function(String path, String name) onFileSelected,
//     Function(String message) onError,
//   ) async {
//     Navigator.of(context).pop(); // Close bottom sheet
    
//     _showLoadingDialog(context);
    
//     try {
//       final imagePath = await CameraService.takePhoto();
      
//       _hideLoadingDialog(context);
      
//       if (imagePath != null) {
//         // Validate file size
//         if (!CameraService.isFileSizeValid(imagePath, maxSizeInMB: 10)) {
//           onError('Image size is too large. Maximum size is 10MB.');
//           return;
//         }
        
//         final fileName = 'Camera_Photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
//         onFileSelected(imagePath, fileName);
//       }
//     } catch (e) {
//       _hideLoadingDialog(context);
//       onError('Could not access camera. Please try again.');
//     }
//   }

//   static Future<void> _handleGalleryPhoto(
//     BuildContext context,
//     Function(String path, String name) onFileSelected,
//     Function(String message) onError,
//   ) async {
//     Navigator.of(context).pop(); // Close bottom sheet
    
//     try {
//       final result = await CameraService.pickImageFile();
      
//       if (result != null && result.files.isNotEmpty) {
//         final file = result.files.first;
//         if (file.path != null) {
//           // Validate file size
//           if (!CameraService.isFileSizeValid(file.path!, maxSizeInMB: 10)) {
//             onError('Image size is too large. Maximum size is 10MB.');
//             return;
//           }
          
//           onFileSelected(file.path!, file.name);
//         }
//       }
//     } catch (e) {
//       onError('Could not access photo gallery.');
//     }
//   }

//   static Future<void> _handlePdfFile(
//     BuildContext context,
//     Function(String path, String name) onFileSelected,
//     Function(String message) onError,
//   ) async {
//     Navigator.of(context).pop(); // Close bottom sheet
    
//     try {
//       final result = await CameraService.pickPdfFile();
      
//       if (result != null && result.files.isNotEmpty) {
//         final file = result.files.first;
//         if (file.path != null) {
//           // Validate file size
//           if (!CameraService.isFileSizeValid(file.path!, maxSizeInMB: 25)) {
//             onError('PDF size is too large. Maximum size is 25MB.');
//             return;
//           }
          
//           onFileSelected(file.path!, file.name);
//         }
//       }
//     } catch (e) {
//       onError('Could not access PDF files.');
//     }
//   }

//   static void _showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }

//   static void _hideLoadingDialog(BuildContext context) {
//     if (Navigator.canPop(context)) {
//       Navigator.of(context).pop();
//     }
//   }
// }