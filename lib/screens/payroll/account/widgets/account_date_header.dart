import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_theme.dart';

/// Widget that displays date header for grouping account statements
/// Shows formatted date with proper styling and background.
class AccountDateHeader extends StatelessWidget {
  final String date;

  const AccountDateHeader({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: PalmColors.backgroundAccent,
        border: Border(
          bottom: BorderSide(
            color: PalmColors.greyLight,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m),
      alignment: Alignment.centerLeft,
      child: Text(
        _formatDate(date),
        style: PalmTextStyles.body.copyWith(
          color: PalmColors.textNormal,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Formats date string to display format
  /// Converts YYYY-MM-DD to readable format like "Monday, Aug 04 2025"
  String _formatDate(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('EEEE, MMM dd yyyy').format(dateTime);
    } catch (e) {
      return dateString;                                  // Return original if parsing fails
    }
  }
}
