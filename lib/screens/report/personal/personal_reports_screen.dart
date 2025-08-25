import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/report/widgets/report_menu_item.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Personal Reports Screen
/// - Displays personal related reports
class PersonalReportsScreen extends StatelessWidget {
  const PersonalReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Reports', style: TextStyle(color: Colors.white)),
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
              title: 'Basic Information',
              onTap: () {
                // Navigate to Personal Report screen
              },
            ),
            ReportMenuItem(
              title: 'Spouse ',
              onTap: () {
                // Navigate to Personal Report screen
              },
            ),
            ReportMenuItem(
              title: 'Dependance',
              onTap: () {
                // Navigate to Personal Report screen
              },
            ),
            
            
          ],
        ),
      ),
    );
  }
} 