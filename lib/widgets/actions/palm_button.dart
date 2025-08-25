import 'package:flutter/material.dart';

/// A customized button widget for the Palm HR app that follows the design system.
/// 
/// This button provides consistent styling and behavior across the app with:
/// - Customizable text
/// - Default styling from the design system
/// - Optional onPressed callback
/// - Configurable width
class PalmButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// The callback function when the button is pressed
  final VoidCallback? onPressed;
  
  /// Whether the button should expand to fill available width
  final bool expandWidth;
  
  /// Custom background color (optional - uses default if not provided)
  final Color? backgroundColor;
  
  /// Custom text color (optional - uses default if not provided)
  final Color? textColor;
  
  /// Creates a Palm button widget
  const PalmButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.expandWidth = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: expandWidth ? double.infinity : null,
      // Apply drop shadow effect
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color(0xFFD9D9D9),
          foregroundColor: textColor ?? const Color.fromRGBO(0, 0, 0, 0.7),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0, // No elevation as we're using custom shadow
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
