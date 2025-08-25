import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/file_picker_util.dart';

/// A file attachment field widget
class FileAttachmentField extends StatelessWidget {
  /// The label text for the field
  final String label;
  
  /// The currently attached file
  final File? attachedFile;
  
  /// The name of the attached file
  final String? attachmentName;
  
  /// Callback when a file is selected
  final Function(File file, String fileName) onFileSelected;
  
  /// Callback when the file is removed
  final VoidCallback onFileRemoved;
  
  /// Allowed file extensions
  final List<String>? allowedExtensions;

  /// Creates a file attachment field widget
  const FileAttachmentField({
    Key? key,
    required this.label,
    required this.attachedFile,
    required this.attachmentName,
    required this.onFileSelected,
    required this.onFileRemoved,
    this.allowedExtensions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PalmTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickFile(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    attachmentName ?? 'Attach File',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: attachmentName != null ? Colors.black : Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.attachment, color: PalmColors.neutral),
              ],
            ),
          ),
        ),
        if (attachmentName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: PalmColors.success, size: 16),
                const SizedBox(width: 8),
                Text(
                  'File attached',
                  style: TextStyle(
                    fontSize: 12,
                    color: PalmColors.success,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onFileRemoved,
                  child: Icon(Icons.close, color: PalmColors.danger, size: 16),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    final file = await FilePickerUtil.pickFile(
      allowedExtensions: allowedExtensions ?? ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      type: FileType.custom,
    );
    
    if (file != null) {
      final fileName = FilePickerUtil.getFileName(file.path);
      onFileSelected(file, fileName);
    }
  }
} 