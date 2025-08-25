import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Utility class for displaying notifications to the user:
/// - Error messages
/// - Success messages
/// - Information messages
/// - Warning messages
class NotificationUtil {
  /// Show an error message in a snackbar
  void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: PalmColors.danger,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Show a success message in a snackbar
  void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: PalmColors.success,
      duration: const Duration(seconds: 2),
    );
  }
  
  /// Show an info message in a snackbar
  void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: PalmColors.primary,
      duration: const Duration(seconds: 2),
    );
  }
  
  /// Show a warning message in a snackbar
  void showWarning(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: PalmColors.warning,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Private method to show a snackbar with custom styling
  void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 