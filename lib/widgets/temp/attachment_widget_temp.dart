import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A temporary stateful widget for file attachment functionality
/// This widget allows users to select and attach files (PDF, DOC, DOCX, JPG, JPEG, PNG)
class AttachmentWidget extends StatefulWidget {
  final File? attachmentFile;
  final String? attachmentName;
  final Function(File, String) onAttachmentChanged;

  const AttachmentWidget({
    super.key,
    required this.onAttachmentChanged,
    this.attachmentFile,
    this.attachmentName,
  });

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Attachment Label
        Text(
          'Attachment',
          style: PalmTextStyles.body.copyWith(
            color: PalmColors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: PalmSpacings.xs),
        
        // Attachment Picker
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
            );
            
            if (result != null) {
              widget.onAttachmentChanged(
                File(result.files.single.path!),
                result.files.single.name,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m, vertical: PalmSpacings.m),
            decoration: BoxDecoration(
              color: PalmColors.white,
              borderRadius: BorderRadius.circular(PalmSpacings.radius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.attachmentName ?? 'Attach File',
                  style: PalmTextStyles.body.copyWith(
                    color: widget.attachmentName == null ? PalmColors.textLight : PalmColors.textNormal,
                  ),
                ),
                Icon(Icons.attachment, color: PalmColors.iconNormal, size: PalmIcons.size),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
