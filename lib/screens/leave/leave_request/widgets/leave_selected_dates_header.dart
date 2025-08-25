import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/services/holiday_service.dart';

/// A widget that displays selected leave dates in an interactive header format
/// This allows users to view and edit their selected date range
class LeaveSelectedDatesHeader extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback? onEditTap;

  const LeaveSelectedDatesHeader({
    super.key,
    required this.startDate,
    required this.endDate,
    this.onEditTap,
  });

  /// Format date for display (e.g., "Feb 12")
  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  /// Get day of week (e.g., "Mon")
  String _getDayOfWeek(DateTime date) {
    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final holidayAnalysis = HolidayService.analyzeRange(startDate, endDate);

    return GestureDetector(
      onTap: onEditTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PalmSpacings.l,
          vertical: PalmSpacings.m,
        ),
        decoration: BoxDecoration(
          color: PalmColors.white,
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          boxShadow: [
            BoxShadow(
              color: PalmColors.dark.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Date range row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start date
                Column(
                  children: [
                    Text(
                      _formatDate(startDate),
                      style: PalmTextStyles.title.copyWith(
                        color: PalmColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: PalmSpacings.xxs),
                    Text(
                      _getDayOfWeek(startDate),
                      style: PalmTextStyles.caption.copyWith(
                        color: PalmColors.textLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                // Arrow
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: PalmSpacings.l),
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: PalmColors.secondary,
                        size: 24,
                      ),
                      const SizedBox(height: PalmSpacings.xs),
                      Text(
                        '${holidayAnalysis.workingDays} days',
                        style: PalmTextStyles.caption.copyWith(
                          color: PalmColors.success,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // End date
                Column(
                  children: [
                    Text(
                      _formatDate(endDate),
                      style: PalmTextStyles.title.copyWith(
                        color: PalmColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: PalmSpacings.xxs),
                    Text(
                      _getDayOfWeek(endDate),
                      style: PalmTextStyles.caption.copyWith(
                        color: PalmColors.textLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Edit indication
            if (onEditTap != null) ...[
              const SizedBox(height: PalmSpacings.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    color: PalmColors.textLight,
                    size: 14,
                  ),
                  const SizedBox(width: PalmSpacings.xxs),
                  Text(
                    'Tap to edit dates',
                    style: PalmTextStyles.caption.copyWith(
                      color: PalmColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
