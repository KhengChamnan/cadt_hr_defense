import 'package:flutter/material.dart';

/// A dialog that automatically dismisses after a specified duration
class AutoDismissDialog extends StatelessWidget {
  final String title;
  final String message;
  final Duration duration;
  final Color? titleColor;
  final Widget? icon;
  final Function? onDismiss;

  const AutoDismissDialog({
    Key? key,
    required this.title,
    required this.message,
    this.duration = const Duration(seconds: 2),
    this.titleColor,
    this.icon,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Auto-dismiss after the specified duration
    Future.delayed(duration, () {
      if (context.mounted) {
        Navigator.of(context).pop();
        if (onDismiss != null) {
          onDismiss!();
        }
      }
    });

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  /// Shows a success dialog that auto-dismisses
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    Function? onDismiss,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AutoDismissDialog(
        title: title,
        message: message,
        duration: duration,
        titleColor: Colors.green,
        icon: const Icon(Icons.check_circle, color: Colors.green),
        onDismiss: onDismiss,
      ),
    );
  }

  /// Shows an error dialog that auto-dismisses
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 2),
    Function? onDismiss,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AutoDismissDialog(
        title: title,
        message: message,
        duration: duration,
        titleColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.red),
        onDismiss: onDismiss,
      ),
    );
  }
} 