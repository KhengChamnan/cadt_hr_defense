import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// An error bottom sheet modal that appears when attendance is blocked
/// Shows error message and navigation guidance back to home
class AttendanceErrorBottomSheet extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;
  final String currentTime;
  final String workType;
  final VoidCallback onBackToHome;

  const AttendanceErrorBottomSheet({
    super.key,
    required this.errorTitle,
    required this.errorMessage,
    required this.currentTime,
    required this.workType,
    required this.onBackToHome,
  });

  /// Show the error bottom sheet modal
  static Future<void> show(
    BuildContext context, {
    required String errorTitle,
    required String errorMessage,
    required String currentTime,
    required String workType,
    required VoidCallback onBackToHome,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      builder: (context) => AttendanceErrorBottomSheet(
        errorTitle: errorTitle,
        errorMessage: errorMessage,
        currentTime: currentTime,
        workType: workType,
        onBackToHome: onBackToHome,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
              // Error icon with warning badge
              _buildErrorIcon(),

              const SizedBox(height: PalmSpacings.xxl),

              // Title
              _buildTitle(),

              const SizedBox(height: PalmSpacings.l),

              // Main error message
              _buildMainMessage(),

              const SizedBox(height: PalmSpacings.l),

              // Error details
              _buildErrorDetails(),

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

  /// Build error icon with warning badge
  Widget _buildErrorIcon() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: PalmColors.danger.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main error icon
          Icon(
            Icons.access_time_outlined,
            size: 70,
            color: PalmColors.danger,
          ),
          // Warning badge
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: PalmColors.warning,
                shape: BoxShape.circle,
                border: Border.all(
                  color: PalmColors.white,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.warning,
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
  Widget _buildTitle() {
    return Text(
      errorTitle,
      style: PalmTextStyles.heading.copyWith(
        color: PalmColors.danger,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build main error message
  Widget _buildMainMessage() {
    return Text(
      'Attendance is currently not allowed',
      style: PalmTextStyles.body.copyWith(
        color: PalmColors.textNormal,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build error details section
  Widget _buildErrorDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PalmSpacings.l),
      decoration: BoxDecoration(
        color: PalmColors.backgroundAccent,
        borderRadius: BorderRadius.circular(PalmSpacings.m),
        border: Border.all(
          color: PalmColors.danger.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error message
          Text(
            'Reason:',
            style: PalmTextStyles.label.copyWith(
              color: PalmColors.textLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: PalmSpacings.xs),
          Text(
            errorMessage,
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textNormal,
              height: 1.4,
            ),
          ),

          const SizedBox(height: PalmSpacings.m),

          // Current time
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: PalmColors.textLight,
              ),
              const SizedBox(width: PalmSpacings.xs),
              Text(
                'Current Time: ',
                style: PalmTextStyles.label.copyWith(
                  color: PalmColors.textLight,
                ),
              ),
              Text(
                currentTime,
                style: PalmTextStyles.label.copyWith(
                  color: PalmColors.textNormal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: PalmSpacings.s),

          // Work type
          Row(
            children: [
              Icon(
                Icons.work_outline,
                size: 16,
                color: PalmColors.textLight,
              ),
              const SizedBox(width: PalmSpacings.xs),
              Text(
                'Work Type: ',
                style: PalmTextStyles.label.copyWith(
                  color: PalmColors.textLight,
                ),
              ),
              Text(
                workType,
                style: PalmTextStyles.label.copyWith(
                  color: PalmColors.textNormal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
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
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalmSpacings.m),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 20,
            ),
            const SizedBox(width: PalmSpacings.s),
            Text(
              'Back to Home',
              style: PalmTextStyles.button.copyWith(
                color: PalmColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
