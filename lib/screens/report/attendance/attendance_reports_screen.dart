import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/widgets/report_menu_item.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Attendance Reports Screen
/// - Displays attendance related reports
class AttendanceReportsScreen extends StatelessWidget {
  const AttendanceReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Reports', style: TextStyle(color: Colors.white)),
        backgroundColor: PalmColors.backGroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(PalmSpacings.m),
        child: Column(
          children: [
            ReportMenuItem(
              title: 'Daily Attendance List',
              onTap: () {
                // Navigate to Daily Attendance List screen
              },
            ),
            ReportMenuItem(
              title: 'Daily Late Attendance',
              onTap: () {
                // Navigate to Daily Late Attendance screen
              },
            ),
            ReportMenuItem(
              title: 'Daily Leave List',
              onTap: () {
                // Navigate to Daily Leave List screen
              },
            ),
            ReportMenuItem(
              title: 'Summary Attendance List',
              onTap: () {
                // Navigate to Summary Attendance List screen
              },
            ),
            ReportMenuItem(
              title: 'Balance of Annual Leave',
              onTap: () {
                // Navigate to Balance of Annual Leave screen
              },
            ),
            ReportMenuItem(
              title: 'Absent and Late By Month',
              onTap: () {
                // Navigate to Absent and Late By Month screen
              },
            ),
            ReportMenuItem(
              title: 'Penalty Absent and Late By Month',
              onTap: () {
                // Navigate to Penalty Absent and Late By Month screen
              },
            ),
          ],
        ),
      ),
    );
  }
} 