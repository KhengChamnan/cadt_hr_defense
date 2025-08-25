import 'dart:io';
import 'package:file_picker/file_picker.dart';

/// Utility class for file picking operations
class FilePickerUtil {
  /// Pick a single file and return the file path
  /// 
  /// Returns null if the user cancels the operation or if there's an error
  static Future<File?> pickFile({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : type,
        allowedExtensions: allowedExtensions,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final path = result.files.first.path;
        if (path != null) {
          return File(path);
        }
      }
      return null;
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }
  
  /// Get the file name from a file path
  static String getFileName(String filePath) {
    return filePath.split('/').last;
  }
  
  /// Get the file extension from a file path
  static String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }
} 