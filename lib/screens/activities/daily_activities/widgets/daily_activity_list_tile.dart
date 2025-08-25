import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/daily_activies.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Daily Activity List Tile Widget
/// - Displays daily activity information in a list format
/// - Provides action buttons for view, edit, and delete
/// - Follows the same design pattern as TrainingListTile and AchievementListTile
class DailyActivityListTile extends StatelessWidget {
  final DailyActivity activity;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(ActivityStatus)? onStatusChanged;

  const DailyActivityListTile({
    super.key,
    required this.activity,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChanged,
  });

  /// Get activity status from the status field
  String get _activityStatus => activity.status.displayName;

  Color _getStatusColor() {
    switch (activity.status) {
      case ActivityStatus.pending:
        return Colors.orange;
      case ActivityStatus.inProgress:
        return Colors.blue;
      case ActivityStatus.completed:
        return PalmColors.success;
      case ActivityStatus.cancelled:
        return Colors.grey;
      case ActivityStatus.approved:
        return PalmColors.success;
      case ActivityStatus.rejected:
        return PalmColors.danger;
    }
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      width: 89,
      height: 31,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        // Remove border radius for seamless connection to header
      ),
      child: Center(
        child: Text(
          status,
          style: PalmTextStyles.button.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  /// Build action menu
  Widget _buildActionMenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
        size: 18,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        // Regular options
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: PalmSpacings.s),
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
          // Remove all margins and padding for seamless full-width list
        ),
        child: Column(
          children: [
            // Header section - exactly like TrainingListTile and AchievementListTile
            Container(
              width: double.infinity,
              height: 31,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: PalmColors.primary.withOpacity(0.8),
                // Remove border radius for seamless connection
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Text(
                    '${activity.fromDate.day}/${activity.fromDate.month}/${activity.fromDate.year}',
                    style: PalmTextStyles.body.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusBadge(_activityStatus),
                  // Add action menu
                  _buildActionMenu(),
                ],
              ),
            ),
            // Content section - following TrainingListTile pattern exactly
            Container(
              width: double.infinity,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                // Remove border radius for seamless connection
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Activity category row
                  Row(
                    children: [
                      // Category icon
                      Container(
                        width: 15,
                        height: 15,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: PalmColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.category,
                          size: 11,
                          color: PalmColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          activity.activityCategory,
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Activity description row
                  Row(
                    children: [
                      // Description icon
                      Container(
                        width: 16,
                        height: 16,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: PalmColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.description,
                          size: 12,
                          color: PalmColors.success,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          activity.activityDescription,
                          style: PalmTextStyles.body.copyWith(
                            color: PalmColors.textNormal,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Time range row
                  Row(
                    children: [
                      // Time icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PalmColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.access_time,
                          size: 12,
                          color: PalmColors.warning,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          'Time: ${_formatTimeRange()}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Score row
                  Row(
                    children: [
                      // Score icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: activity.score != null 
                              ? PalmColors.primary.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          activity.score != null ? Icons.star : Icons.star_outline,
                          size: 12,
                          color: activity.score != null 
                              ? PalmColors.primary 
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          activity.score != null 
                              ? 'Score: ${activity.score!.toStringAsFixed(1)}/100'
                              : 'Score: Not evaluated',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location row
                  if (activity.location != null)
                    Row(
                      children: [
                        // Location icon
                        Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: PalmColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: 12,
                            color: PalmColors.success,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            'Location: ${activity.location!.address ?? 'Location recorded'}',
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  // Photo row
                  if (activity.photoPath != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Photo icon
                        Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: PalmColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 12,
                            color: PalmColors.warning,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            'Photo: Attached',
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Remarks row
                  if (activity.remark.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Remarks icon
                        Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: PalmColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Icon(
                            Icons.comment,
                            size: 12,
                            color: PalmColors.warning,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            'Remarks: ${activity.remark}',
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.textLight,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Format time range display
  String _formatTimeRange() {
    final fromTime = _formatTime(activity.fromDate);
    
    // Show "--" for activities that are not completed yet
    if (activity.status != ActivityStatus.completed) {
      return '$fromTime - --';
    }
    
    final toTime = _formatTime(activity.toDate);
    return '$fromTime - $toTime';
  }

  /// Format time to HH:mm
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
