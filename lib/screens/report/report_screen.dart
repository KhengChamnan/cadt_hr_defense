import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/payroll_account/payroll_account_reports_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/personal/personal_reports_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/payroll/payroll_reports_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/attendance/attendance_reports_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/animations_util.dart';

/// Report screen that displays different report categories
/// - Shows a list of available report types
/// - Provides navigation to specific report screens
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports List', style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: PalmColors.backGroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Payroll Account Reports
            ReportCategoryItem(
              title: 'Payroll Account Reports',
              iconPath: 'assets/images/salary_male.png',
              onTap: () {
                // Navigate to Payroll Account Reports with forward animation
                Navigator.push(
                  context, 
                  AnimationUtils.createForwardRoute(
                    const PayrollAccountReportsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // Personal Reports
            ReportCategoryItem(
              title: 'Personal Reports',
              iconPath: 'assets/images/profile.png',
              onTap: () {
                // Navigate to Personal Reports with forward animation
                Navigator.push(
                  context, 
                  AnimationUtils.createForwardRoute(
                    const PersonalReportsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // Payroll Reports
            ReportCategoryItem(
              title: 'Payroll Reports',
              iconPath: 'assets/images/dollar_bag.png',
              onTap: () {
                // Navigate to Payroll Reports with forward animation
                Navigator.push(
                  context, 
                  AnimationUtils.createForwardRoute(
                    const PayrollReportsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            
            // Attendance Reports
            ReportCategoryItem(
              title: 'Attendance Reports',
              iconPath: 'assets/images/day_view.png',
              onTap: () {
                // Navigate to Attendance Reports with forward animation
                Navigator.push(
                  context, 
                  AnimationUtils.createForwardRoute(
                    const AttendanceReportsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable widget for report category items
/// - Displays a report category with icon and title
/// - Includes a right arrow for navigation
class ReportCategoryItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const ReportCategoryItem({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 61,
        decoration: BoxDecoration(
          color: PalmColors.primary.withOpacity(0.85),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Category icon
              Image.asset(
                iconPath,
                width: 30,
                height: 30,
              ),
              const SizedBox(width: 12),
              
              // Category title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Right arrow icon
              Image.asset(
                'assets/images/sort_right.png',
                width: 25,
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}