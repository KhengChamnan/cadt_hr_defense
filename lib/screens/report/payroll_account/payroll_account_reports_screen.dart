import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/models/report/payroll_account_report.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/widgets/report_menu_item.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/animations_util.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/payroll_account/detail/report_detail_screen.dart';

/// Payroll Account Reports Screen
/// - Displays payroll account related reports menu items
/// - Allows navigation to specific report screens
class PayrollAccountReportsScreen extends StatelessWidget {
  const PayrollAccountReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll Account', style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: PalmColors.backGroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(PalmSpacings.m),
        child: ListView.builder(
          itemCount: PayrollAccountReports.reports.length,
          itemBuilder: (context, index) {
            final report = PayrollAccountReports.reports[index];
            return ReportMenuItem(
              title: report.reportType,
              onTap: () => _navigateToReportDetail(context, report),
            );
          },
        ),
      ),
    );
  }

  /// Navigate to the appropriate report detail screen
  /// - Uses the report type to determine which screen to show
  void _navigateToReportDetail(BuildContext context, PayrollAccountReport report) {
    // Create a placeholder content widget for the report
    final content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${report.reportType} Details',
            style: PalmTextStyles.title.copyWith(color: PalmColors.textNormal),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PalmSpacings.m),
          Text(
            'This is a placeholder for the ${report.reportType} content.',
            style: PalmTextStyles.body.copyWith(color: PalmColors.textLight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    // Navigate to the detail screen with forward animation
    Navigator.push(
      context,
      AnimationUtils.createForwardRoute(
        ReportDetailScreen(
          title: report.reportType,
          content: content,
        ),
      ),
    );
  }
} 