import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

/// Weekly Attendance Card Widget
/// - Displays weekly attendance information in a list format
/// - Follows the same design pattern as DailyActivityListTile
class WeeklyAttendanceCard extends StatelessWidget {
  final String day;
  final String? checkInTime;
  final String? checkOutTime;
  final String status;
  final String totalHours;
  final String? date;
  final VoidCallback? onTap;
  
  const WeeklyAttendanceCard({
    super.key,
    required this.day,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    required this.totalHours,
    this.date,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'On Time':
        return PalmColors.success;
      case 'Late':
        return PalmColors.danger;
      case 'Early':
        return PalmColors.primary;
      case 'Day off':
        return PalmColors.neutralLight;
      default:
        return PalmColors.secondary;
    }
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      width: 89,
      height: 31,
      decoration: BoxDecoration(
        color: _getStatusColor(),
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

  @override
  Widget build(BuildContext context) {
    // Convert day to three-letter abbreviation
    String dayAbbreviation = _getThreeLetterDay(day);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.zero, // Removed bottom margin for seamless connection
        padding: EdgeInsets.zero,
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            // Header section - matching DailyActivityListTile pattern
            Container(
              width: double.infinity,
              height: 31,
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: PalmColors.primary.withOpacity(0.8),
                // No border radius for seamless connection
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  // Day and date combined
                  Row(
                    children: [
                      Text(
                        dayAbbreviation,
                        style: PalmTextStyles.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date ?? '',
                        style: PalmTextStyles.body.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _buildStatusBadge(status),
                ],
              ),
            ),
            // Content section - following DailyActivityListTile pattern
            Container(
              width: double.infinity,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                // No border radius for seamless connection
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Check in time row
                  Row(
                    children: [
                      // Check in icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PalmColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.login,
                          size: 12,
                          color: PalmColors.success,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Text(
                        'Check in:',
                        style: PalmTextStyles.label.copyWith(
                          color: PalmColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        checkInTime ?? '-',
                        style: PalmTextStyles.label.copyWith(
                          color: checkInTime == null ? PalmColors.neutralLighter : PalmColors.textNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Check out time row
                  Row(
                    children: [
                      // Check out icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PalmColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.logout,
                          size: 12,
                          color: PalmColors.warning,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Text(
                        'Check out:',
                        style: PalmTextStyles.label.copyWith(
                          color: PalmColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        checkOutTime ?? '-',
                        style: PalmTextStyles.label.copyWith(
                          color: checkOutTime == null ? PalmColors.neutralLighter : PalmColors.textNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Total hours row
                  Row(
                    children: [
                      // Hours icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PalmColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.access_time,
                          size: 12,
                          color: PalmColors.primary,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Text(
                        'Total Hours:',
                        style: PalmTextStyles.label.copyWith(
                          color: PalmColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        totalHours == 'Off' ? '-' : totalHours,
                        style: PalmTextStyles.label.copyWith(
                          color: totalHours == 'Off' ? PalmColors.neutralLighter : PalmColors.textNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get three-letter day abbreviation
  String _getThreeLetterDay(String fullDay) {
    switch (fullDay.toLowerCase()) {
      case 'monday':
        return 'Mon';
      case 'tuesday':
        return 'Tue';
      case 'wednesday':
        return 'Wed';
      case 'thursday':
        return 'Thu';
      case 'friday':
        return 'Fri';
      case 'saturday':
        return 'Sat';
      case 'sunday':
        return 'Sun';
      default:
        // If already in correct format or unknown, return as is
        return fullDay.length > 3 ? fullDay.substring(0, 3) : fullDay;
    }
  }
}