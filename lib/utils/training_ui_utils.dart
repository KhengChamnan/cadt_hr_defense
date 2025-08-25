import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training_status.dart';
import 'package:palm_ecommerce_mobile_app_2/services/training_service.dart';

/// Utility class for training UI operations
/// - Handles dialog displays
/// - Manages navigation flows
/// - Provides UI helper functions
class TrainingUIUtils {
  /// Show training details dialog
  static void showTrainingDetails(
    BuildContext context,
    Training training,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(training.universityOrTraining ?? 'Training Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Institution', training.universityOrTraining),
                _buildDetailRow('Place', training.place),
                _buildDetailRow('Country', training.country),
                _buildDetailRow('Duration', training.durationText),
                _buildDetailRow('Actual Duration', training.actualDuration),
                _buildDetailRow('Degree', training.degree),
                _buildDetailRow('Course of Study', training.mainCourseOfStudy),
                if (training.description != null && training.description!.isNotEmpty)
                  _buildDetailRow('Description', training.description),
                _buildDetailRow('Status', _getTrainingStatus(training)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Show delete confirmation dialog
  static void showDeleteConfirmation(
    BuildContext context,
    Training training,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Training'),
          content: Text(
            'Are you sure you want to delete this training record from ${training.universityOrTraining}?',
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

  /// Show training statistics dialog
  static void showTrainingStatistics(
    BuildContext context,
    TrainingStatistics stats,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Training Statistics'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatRow('Total Trainings', stats.total.toString()),
                _buildStatRow('Completed', stats.completed.toString()),
                _buildStatRow('Ongoing', stats.ongoing.toString()),
                _buildStatRow('Completion Rate', '${stats.completionRate.toStringAsFixed(1)}%'),
                const SizedBox(height: 16),
                _buildStatRow('Unique Institutions', stats.uniqueInstitutions.toString()),
                _buildStatRow('Unique Countries', stats.uniqueCountries.toString()),
                _buildStatRow('Unique Degrees', stats.uniqueDegrees.toString()),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Show validation error dialog
  static void showValidationError(
    BuildContext context,
    String errorMessage,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Validation Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
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

  /// Show info snackbar
  static void showInfoMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show search dialog
  static void showSearchDialog(
    BuildContext context,
    Function(String) onSearch,
  ) {
    final TextEditingController searchController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Trainings'),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Enter search keyword...',
              prefixIcon: Icon(Icons.search),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSearch(searchController.text);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  /// Show filter options dialog
  static void showFilterDialog(
    BuildContext context,
    Function(String) onFilterApplied,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Trainings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: const Text('All Trainings'),
                onTap: () {
                  Navigator.of(context).pop();
                  onFilterApplied('all');
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Completed'),
                onTap: () {
                  Navigator.of(context).pop();
                  onFilterApplied('completed');
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule, color: Colors.orange),
                title: const Text('Ongoing'),
                onTap: () {
                  Navigator.of(context).pop();
                  onFilterApplied('ongoing');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Show status change confirmation dialog
  static void showStatusChangeDialog(
    BuildContext context,
    Training training,
    Function(Training, TrainingStatus) onStatusChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Training Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current status: ${training.status.displayName}'),
              const SizedBox(height: 16),
              const Text('Select new status:'),
              const SizedBox(height: 8),
              ...TrainingStatus.values.map((status) {
                if (status == training.status) return const SizedBox.shrink();
                return ListTile(
                  leading: Icon(
                    _getIconForStatus(status),
                    color: Color(status.colorValue),
                  ),
                  title: Text(status.displayName),
                  onTap: () {
                    Navigator.of(context).pop();
                    onStatusChanged(training, status);
                  },
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Show status change message
  static void showStatusChangeMessage(BuildContext context, TrainingStatus status) {
    final message = 'Training status changed to ${status.displayName}';
    showSuccessMessage(context, message);
  }

  /// Show training details with status actions
  static void showTrainingDetailsWithActions(
    BuildContext context,
    Training training,
    Function(Training, TrainingStatus) onStatusChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(training.universityOrTraining ?? 'Training Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status display with color
                Row(
                  children: [
                    Icon(
                      getStatusIcon(training),
                      color: getStatusColor(training),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Status: ${training.status.displayName}',
                      style: TextStyle(
                        color: getStatusColor(training),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Institution', training.universityOrTraining),
                _buildDetailRow('Place', training.place),
                _buildDetailRow('Country', training.country),
                _buildDetailRow('Duration', training.durationText),
                _buildDetailRow('Actual Duration', training.actualDuration),
                _buildDetailRow('Degree', training.degree),
                _buildDetailRow('Course of Study', training.mainCourseOfStudy),
                if (training.description != null && training.description!.isNotEmpty)
                  _buildDetailRow('Description', training.description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showStatusChangeDialog(context, training, onStatusChanged);
              },
              child: const Text('Change Status'),
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

  /// Build detail row widget for training details
  static Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  /// Build statistics row widget
  static Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Get training status text
  static String _getTrainingStatus(Training training) {
    return training.status.displayName;
  }

  /// Get status color for training
  static Color getStatusColor(Training training) {
    return Color(training.status.colorValue);
  }

  /// Get status icon for training
  static IconData getStatusIcon(Training training) {
    return _getIconForStatus(training.status);
  }

  /// Get icon for specific training status
  static IconData _getIconForStatus(TrainingStatus status) {
    switch (status) {
      case TrainingStatus.inProgress:
        return Icons.schedule;
      case TrainingStatus.completed:
        return Icons.check_circle;
      case TrainingStatus.planned:
        return Icons.event;
      case TrainingStatus.paused:
        return Icons.pause_circle;
      case TrainingStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
