import 'dart:io';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/daily_activies.dart';
import 'package:palm_ecommerce_mobile_app_2/services/daily_activities_service.dart';

/// Utility class for daily activities UI operations
/// - Handles dialog displays
/// - Manages navigation flows
/// - Provides UI helper functions
class DailyActivitiesUIUtils {
  /// Show activity details dialog
  static void showActivityDetails(
    BuildContext context,
    DailyActivity activity,
    Function(DailyActivity, ActivityStatus) onStatusChange,
  ) {
    final service = DailyActivitiesService();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(activity.activityDescription),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Category', activity.activityCategory),
                _buildDetailRow('Key API', activity.keyApi),
                _buildDetailRow('Sub API', activity.subApi),
                _buildDetailRow('Duration', service.formatActivityDuration(activity)),
                _buildDetailRow('Status', activity.status.displayName),
                _buildDetailRow('Remark', activity.remark),
                if (activity.score != null)
                  _buildDetailRow('Score', '${activity.score!.toStringAsFixed(1)}/100'),
                if (activity.photoPath != null)
                  _buildPhotoRow(context, activity.photoPath!),
                if (activity.location != null) ...[
                  _buildDetailRow('Location', activity.location!.address ?? 'GPS Coordinates'),
                  if (activity.location!.clientName != null)
                    _buildDetailRow('Client', activity.location!.clientName!),
                  if (activity.location!.clientCompany != null)
                    _buildDetailRow('Company', activity.location!.clientCompany!),
                ],
              ],
            ),
          ),
          actions: [
            // Status change buttons
            if (activity.status != ActivityStatus.completed)
              TextButton.icon(
                onPressed: () => _showStatusChangeConfirmation(
                  context, 
                  activity, 
                  ActivityStatus.completed,
                  onStatusChange,
                ),
                label: const Text('Mark Completed'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                ),
              ),
            if (activity.status != ActivityStatus.inProgress)
              TextButton.icon(
                onPressed: () => _showStatusChangeConfirmation(
                  context, 
                  activity, 
                  ActivityStatus.inProgress,
                  onStatusChange,
                ),
                label: const Text('Mark Progress'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orange,
                ),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Show status change confirmation dialog
  static void _showStatusChangeConfirmation(
    BuildContext context,
    DailyActivity activity,
    ActivityStatus newStatus,
    Function(DailyActivity, ActivityStatus) onStatusChange,
  ) {
    final service = DailyActivitiesService();
    final statusInfo = service.getStatusInfo(newStatus);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(statusInfo.icon, color: statusInfo.color),
              const SizedBox(width: 8),
              Text('Mark as ${statusInfo.displayName.toUpperCase()}'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Activity: ${activity.activityDescription}'),
              const SizedBox(height: 8),
              Text('Current Status: ${activity.status.displayName}'),
              const SizedBox(height: 8),
              Text('New Status: ${statusInfo.displayName}'),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to mark this activity as ${statusInfo.displayName.toLowerCase()}?',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                onStatusChange(activity, newStatus);
                Navigator.of(context).pop(); // Close confirmation dialog
                Navigator.of(context).pop(); // Close details dialog
              },
              icon: Icon(statusInfo.icon),
              label: Text('Mark ${statusInfo.displayName}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: statusInfo.color,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Show delete confirmation dialog
  static void showDeleteConfirmation(
    BuildContext context,
    DailyActivity activity,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Activity'),
          content: Text(
            'Are you sure you want to delete the activity "${activity.activityDescription}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// Show success snackbar
  static void showSuccessMessage(
    BuildContext context,
    String message, {
    IconData? icon,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon ?? Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor ?? Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show error snackbar
  static void showErrorMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show status change snackbar
  static void showStatusChangeMessage(
    BuildContext context,
    ActivityStatus newStatus,
  ) {
    final service = DailyActivitiesService();
    final statusInfo = service.getStatusInfo(newStatus);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(statusInfo.icon, color: Colors.white),
            const SizedBox(width: 8),
            Text('Activity marked as ${statusInfo.displayName.toLowerCase()}'),
          ],
        ),
        backgroundColor: statusInfo.color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Build detail row widget for activity details
  static Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? 'Not specified'),
          ),
        ],
      ),
    );
  }

  /// Build photo row widget with preview
  static Widget _buildPhotoRow(BuildContext context, String photoPath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 80,
                child: Text(
                  'Photo:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Expanded(
                child: Text('Tap to view'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showFullScreenImage(context, photoPath),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImageWidget(photoPath),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build image widget based on path type
  static Widget _buildImageWidget(String photoPath) {
    if (photoPath.startsWith('http')) {
      return Image.network(
        photoPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageError(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImageLoading(loadingProgress);
        },
      );
    } else if (photoPath.startsWith('assets/')) {
      // For bundled assets
      return Image.asset(
        photoPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageError(),
      );
    } else {
      // For local file paths (captured photos)
      return Image.file(
        File(photoPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildImageError(),
      );
    }
  }

  /// Build image error widget
  static Widget _buildImageError() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[400],
        size: 40,
      ),
    );
  }

  /// Build image loading widget
  static Widget _buildImageLoading(ImageChunkEvent loadingProgress) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  /// Show full screen image viewer
  static void _showFullScreenImage(BuildContext context, String imagePath) {
    // TODO: Navigate to full screen image viewer
    // This would be implemented based on your FullScreenImageViewer widget
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Activity Photo'),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(
                child: _buildImageWidget(imagePath),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
