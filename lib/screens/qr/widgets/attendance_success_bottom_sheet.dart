import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A success bottom sheet modal that appears after attendance is successfully recorded
/// Shows confirmation and navigation guidance back to home
class AttendanceSuccessBottomSheet extends StatelessWidget {
  final VoidCallback onBackToHome;
  final String attendanceStatus; // 'in' or 'out'

  const AttendanceSuccessBottomSheet({
    super.key,
    required this.onBackToHome,
    required this.attendanceStatus,
  });

  /// Show the success bottom sheet modal
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onBackToHome,
    required String attendanceStatus,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      builder: (context) => AttendanceSuccessBottomSheet(
        onBackToHome: onBackToHome,
        attendanceStatus: attendanceStatus,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isCheckIn = attendanceStatus == 'in';
    final statusColor = PalmColors
        .primary; // Use consistent primary color for both check-in and check-out

    return Container(
      height: screenHeight, // Full screen height
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(PalmSpacings.l),
          topRight: Radius.circular(PalmSpacings.l),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(PalmSpacings.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon with check badge
              _buildSuccessIcon(statusColor, isCheckIn),

              const SizedBox(height: PalmSpacings.xxl),

              // Title
              _buildTitle(isCheckIn),

              const SizedBox(height: PalmSpacings.l),

              // Main message
              _buildMainMessage(isCheckIn),

              const SizedBox(height: PalmSpacings.xxl),

              // Navigation button
              _buildNavigationButton(),

              const SizedBox(height: PalmSpacings.l),
            ],
          ),
        ),
      ),
    );
  }

  /// Build success icon with attendance status icon and check badge
  Widget _buildSuccessIcon(Color statusColor, bool isCheckIn) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Attendance status icon (login/logout)
          Icon(
            isCheckIn ? Icons.login : Icons.logout,
            size: 70,
            color: statusColor,
          ),
          // Check badge
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: PalmColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: PalmColors.white,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.check,
                color: PalmColors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build main title text
  Widget _buildTitle(bool isCheckIn) {
    return Text(
      isCheckIn
          ? 'Your check-in has been\nrecorded successfully!'
          : 'Your check-out has been\nrecorded successfully!',
      textAlign: TextAlign.center,
      style: PalmTextStyles.title.copyWith(
        color: PalmColors.textNormal,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
    );
  }

  /// Build main confirmation message
  Widget _buildMainMessage(bool isCheckIn) {
    return Text(
      isCheckIn
          ? 'Your attendance has been marked. Have a productive day!'
          : 'Your work session has been logged. Thank you for your dedication!',
      textAlign: TextAlign.center,
      style: PalmTextStyles.body.copyWith(
        color: PalmColors.textNormal,
        fontSize: 16,
      ),
    );
  }

  /// Build navigation button
  Widget _buildNavigationButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onBackToHome,
        style: ElevatedButton.styleFrom(
          backgroundColor: PalmColors.primary,
          foregroundColor: PalmColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
          ),
          elevation: 3,
        ),
        child: Text(
          'Back To Home',
          style: PalmTextStyles.button.copyWith(
            color: PalmColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
