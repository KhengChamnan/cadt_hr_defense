import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/auto_dismiss_dialog.dart';

/// Utility class for handling error responses and displaying appropriate dialogs
class ErrorHandler {
  /// Parses an error object and returns a user-friendly error message and title
  static Map<String, String> parseErrorResponse(dynamic errorData) {
    String errorTitle = 'Error';
    String errorMessage = '';
    
    // Check if it's a location error and format accordingly
    if (errorData is Map<String, dynamic> && 
        errorData['message'] == 'Location Error' && 
        errorData['data'] != null) {
      
      final locationData = errorData['data'] as Map<String, dynamic>;
      errorTitle = 'Location Error';
      errorMessage = 'You are too far from the office to check in/out.\n\n'
          'Current distance: ${locationData['current_distance']}\n'
          'Maximum allowed: ${locationData['max_allowed']}\n'
          'Distance exceeded: ${locationData['distance_exceeded']}';
    } else {
      // For other errors, just use the raw message
      errorMessage = errorData.toString();
    }
    
    return {
      'title': errorTitle,
      'message': errorMessage,
    };
  }
  
  /// Shows an error dialog that auto-dismisses after a specified duration
  static Future<void> showErrorDialog({
    required BuildContext context, 
    required String title, 
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) async {
    return AutoDismissDialog.showError(
      context: context,
      title: title,
      message: message,
      duration: duration,
    );
  }
  
  /// Combines parsing and showing error dialog in one convenient method
  static Future<void> handleError({
    required BuildContext context,
    required dynamic errorData,
    Duration duration = const Duration(seconds: 2),
  }) async {
    final errorInfo = parseErrorResponse(errorData);
    return showErrorDialog(
      context: context,
      title: errorInfo['title']!,
      message: errorInfo['message']!,
      duration: duration,
    );
  }
  
  /// Convert technical error messages to user-friendly messages
  /// Used for authentication and other generic errors
  static String getUserFriendlyErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    
    if (errorStr.contains('unauthorized') || errorStr.contains('401')) {
      return 'Incorrect email or password. Please try again.';
    } else if (errorStr.contains('not found') || errorStr.contains('404')) {
      return 'Account not found. Please check your email or sign up.';
    } else if (errorStr.contains('network') || errorStr.contains('connection')) {
      return 'Network error. Please check your internet connection.';
    } else if (errorStr.contains('timeout')) {
      return 'Request timed out. Please try again later.';
    } else if (errorStr.contains('invalid') && errorStr.contains('email')) {
      return 'Invalid email format. Please enter a valid email.';
    } else if (errorStr.contains('password') && (errorStr.contains('weak') || errorStr.contains('short'))) {
      return 'Password is too weak. Please use a stronger password.';
    } else if (errorStr.contains('too many') || errorStr.contains('attempts')) {
      return 'Too many login attempts. Please try again later.';
    }
    
    // Default fallback message
    return 'Login failed. Please try again.';
  }
} 