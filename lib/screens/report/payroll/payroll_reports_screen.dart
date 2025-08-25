import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/widgets/report_menu_item.dart';

/// Payroll Reports Screen
/// - Displays payroll related reports
class PayrollReportsScreen extends StatelessWidget {
  const PayrollReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll Reports', style: TextStyle(color: Colors.white)),
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
              title: 'Current Salary List',
              onTap: () {
                // Navigate to Current Salary List screen
              },
            ),
            ReportMenuItem(
              title: 'Wage List By Type',
              onTap: () {
                // Navigate to Wage List By Type screen
              },
            ),
            ReportMenuItem(
              title: 'Penalty AL & Absent List',
              onTap: () {
                // Navigate to Penalty AL & Absent List screen
              },
            ),
          ],
        ),
      ),
    );
  }
} 