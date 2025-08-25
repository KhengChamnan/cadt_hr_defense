import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Reusable widget for report menu items
/// - Displays a menu item with title and navigation arrow
/// - Used in various report screens
class ReportMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ReportMenuItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 61,
        margin: const EdgeInsets.only(bottom: PalmSpacings.m),
        decoration: BoxDecoration(
          color: PalmColors.primary.withOpacity(0.8),
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
          padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m),
          child: Row(
            children: [
              // Menu item title
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