import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/training_status.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A widget that displays a training record in a list format
/// Reuses and improves the UI pattern from LeaveListTile for consistency
class TrainingListTile extends StatelessWidget {
  final Training training;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(TrainingStatus)? onStatusChanged;

  const TrainingListTile({
    super.key,
    required this.training,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStatusChanged,
  });

  /// Get training status from the status field
  String get _trainingStatus => training.status.displayName;

  Color _getStatusColor() {
    return Color(training.status.colorValue);
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
          case 'start':
            onStatusChanged?.call(TrainingStatus.inProgress);
            break;
          case 'complete':
            onStatusChanged?.call(TrainingStatus.completed);
            break;
          case 'pause':
            onStatusChanged?.call(TrainingStatus.paused);
            break;
          case 'resume':
            onStatusChanged?.call(TrainingStatus.inProgress);
            break;
          case 'cancel':
            onStatusChanged?.call(TrainingStatus.cancelled);
            break;
          case 'edit':
            onEdit?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        // Status change options based on current status
        if (training.status == TrainingStatus.planned)
          const PopupMenuItem(
            value: 'start',
            child: Row(
              children: [
                Icon(Icons.play_circle, size: 18, color: Colors.blue),
                SizedBox(width: 8),
                Text('Start Training'),
              ],
            ),
          ),
        if (training.status == TrainingStatus.inProgress) ...[
          const PopupMenuItem(
            value: 'complete',
            child: Row(
              children: [
                Icon(Icons.check_circle, size: 18, color: Colors.green),
                SizedBox(width: 8),
                Text('Mark Complete'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'pause',
            child: Row(
              children: [
                Icon(Icons.pause_circle, size: 18, color: Colors.orange),
                SizedBox(width: 8),
                Text('Pause Training'),
              ],
            ),
          ),
        ],
        if (training.status == TrainingStatus.paused)
          const PopupMenuItem(
            value: 'resume',
            child: Row(
              children: [
                Icon(Icons.play_circle, size: 18, color: Colors.blue),
                SizedBox(width: 8),
                Text('Resume Training'),
              ],
            ),
          ),
        if (training.status != TrainingStatus.cancelled && training.status != TrainingStatus.completed)
          const PopupMenuItem(
            value: 'cancel',
            child: Row(
              children: [
                Icon(Icons.cancel, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Cancel Training'),
              ],
            ),
          ),
        // Divider
        if (training.status != TrainingStatus.cancelled)
          const PopupMenuDivider(),
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
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(
          // Remove all margins and padding for seamless full-width list
        ),
        child: Column(
          children: [
            // Header section - exactly like LeaveListTile
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
                    training.createdAt != null 
                        ? '${training.createdAt!.day}/${training.createdAt!.month}/${training.createdAt!.year}'
                        : 'No date',
                    style: PalmTextStyles.body.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusBadge(_trainingStatus),
                  // Add action menu
                  _buildActionMenu(),
                ],
              ),
            ),
            // Content section - following LeaveListTile pattern exactly
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
                  // Date range row (like leave date range)
                  Row(
                    children: [
                      // Calendar icon
                      Container(
                        width: 15,
                        height: 15,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: PalmColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          size: 11,
                          color: PalmColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Duration: ${training.formattedFromDate} ${training.toDate != null ? '- ${training.formattedToDate}' : '(Ongoing)'}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          training.actualDuration,
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Degree type row (like leave type row)
                  Row(
                    children: [
                      // Degree icon
                      Container(
                        width: 16,
                        height: 16,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: PalmColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.workspace_premium,
                          size: 12,
                          color: PalmColors.success,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Degree: ${training.degree ?? 'Not specified'}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Course of study row (like reason row)
                  Row(
                    children: [
                      // Course icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PalmColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.book,
                          size: 12,
                          color: PalmColors.warning,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          'Course: ${training.mainCourseOfStudy ?? 'Not specified'}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Institution row (consistent with degree/course style)
                  Row(
                    children: [
                      // Institution icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PalmColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.school,
                          size: 12,
                          color: PalmColors.primary,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          'Institution: ${training.universityOrTraining ?? 'Not specified'}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location row (consistent with degree/course style)
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
                          'Location: ${training.place ?? 'Unknown'}, ${training.country ?? 'Unknown'}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                    if (training.description != null && training.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    // Description row (consistent with degree/course style)
                    Row(
                      children: [
                      // Description icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                        color: PalmColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                        Icons.description,
                        size: 12,
                        color: PalmColors.warning,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                        'Description: ${training.description}',
                        style: PalmTextStyles.label.copyWith(
                          color: PalmColors.textLight,
                        ),
                        maxLines: 1,
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
}
