import 'package:flutter/material.dart';
import '../../../../models/activities/achievements.dart';
import '../../../../theme/app_theme.dart';

/// A list tile widget for displaying achievement information
/// Shows achievement details with progress indicator and action buttons
/// Follows the same design pattern as TrainingListTile and DailyActivityListTile
class AchievementListTile extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onQuickUpdate;
  final bool canEdit;

  const AchievementListTile({
    Key? key,
    required this.achievement,
    this.onTap,
    this.onEdit,
    this.onQuickUpdate,
    this.canEdit = false,
  }) : super(key: key);

  /// Get achievement status from the progress
  String get _achievementStatus => achievement.getProgressStatus();

  Color _getStatusColor() {
    final percentage = achievement.calculatePercentage();
    if (percentage >= 100) {
      return PalmColors.success;
    } else if (percentage >= 80) {
      return PalmColors.secondary;
    } else if (percentage >= 50) {
      return PalmColors.warning;
    } else {
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
          '${achievement.calculatePercentage().toStringAsFixed(0)}%',
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
          case 'quick_update':
            onQuickUpdate?.call();
            break;
          case 'edit':
            onEdit?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        // Quick update option
        if (canEdit && onQuickUpdate != null)
          const PopupMenuItem(
            value: 'quick_update',
            child: Row(
              children: [
                Icon(Icons.add_task, size: 18, color: Colors.blue),
                SizedBox(width: 8),
                Text('Quick Update'),
              ],
            ),
          ),
        // Regular options
        if (canEdit && onEdit != null)
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
            // Header section - exactly like TrainingListTile
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
                    achievement.createdAt != null 
                        ? '${achievement.createdAt!.day}/${achievement.createdAt!.month}/${achievement.createdAt!.year}'
                        : 'No date',
                    style: PalmTextStyles.body.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusBadge(_achievementStatus),
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
                  // Achievement description (like training title)
                  Row(
                    children: [
                      // Achievement icon
                      Container(
                        width: 15,
                        height: 15,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: PalmColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.star,
                          size: 11,
                          color: PalmColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          achievement.achievementDescription ?? 'No description',
                          style: PalmTextStyles.body.copyWith(
                            color: PalmColors.textNormal,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Achievement index row
                  if (achievement.achievementIndex?.isNotEmpty == true)
                    Row(
                      children: [
                        // Index icon
                        Container(
                          width: 16,
                          height: 16,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: PalmColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Icon(
                            Icons.numbers,
                            size: 12,
                            color: PalmColors.success,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Index: ${achievement.achievementIndex}',
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
                  // Progress row
                  Row(
                    children: [
                      // Progress icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PalmColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.trending_up,
                          size: 12,
                          color: PalmColors.warning,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Progress: ${achievement.actualAchievement?.toStringAsFixed(0) ?? '0'} / ${achievement.targetAmount?.toStringAsFixed(0) ?? '0'}',
                              style: PalmTextStyles.label.copyWith(
                                color: PalmColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: (achievement.calculatePercentage() / 100).clamp(0.0, 1.0),
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation(_getStatusColor()),
                              minHeight: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Key API row
                  if (achievement.keyApi?.isNotEmpty == true)
                    Row(
                      children: [
                        // API icon
                        Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: PalmColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Icon(
                            Icons.api,
                            size: 12,
                            color: PalmColors.primary,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            'Key API: ${achievement.keyApi}',
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Sub API row
                  if (achievement.subApi?.isNotEmpty == true)
                    Row(
                      children: [
                        // Sub API icon
                        Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: PalmColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Icon(
                            Icons.api,
                            size: 12,
                            color: PalmColors.success,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            'Sub API: ${achievement.subApi}',
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Date range row
                  if (achievement.fromDate != null && achievement.toDate != null)
                    Row(
                      children: [
                        // Date icon
                        Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: PalmColors.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Icon(
                            Icons.date_range,
                            size: 12,
                            color: PalmColors.warning,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Text(
                            'Duration: ${achievement.fromDate!.toString().split(' ')[0]} - ${achievement.toDate!.toString().split(' ')[0]}',
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.textLight,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  // Remarks row
                  if (achievement.remark?.isNotEmpty == true) ...[
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
                            'Remarks: ${achievement.remark}',
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
}
