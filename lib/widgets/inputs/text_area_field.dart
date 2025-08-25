import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A multi-line text input field widget
class TextAreaField extends StatelessWidget {
  /// The label text for the field
  final String label;
  
  /// The text controller
  final TextEditingController controller;
  
  /// Hint text to display when empty
  final String? hintText;
  
  /// Maximum number of lines
  final int maxLines;
  
  /// Creates a text area field widget
  const TextAreaField({
    Key? key,
    required this.label,
    required this.controller,
    this.hintText,
    this.maxLines = 5,
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
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
} 