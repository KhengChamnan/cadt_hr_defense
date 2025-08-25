import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A success bottom sheet modal that appears after a leave request is successfully submitted
/// Shows confirmation and navigation guidance to the leave record screen
class LeaveSuccessBottomSheet extends StatelessWidget {
  final VoidCallback onSoundsGood;

  const LeaveSuccessBottomSheet({
    super.key,
    required this.onSoundsGood,
  });

  /// Show the success bottom sheet modal
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onSoundsGood,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      builder: (context) => LeaveSuccessBottomSheet(
        onSoundsGood: onSoundsGood,
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
              // Success icon with check badge
              _buildSuccessIcon(),

              const SizedBox(height: PalmSpacings.xxl),

              // Title
              _buildTitle(),

              const SizedBox(height: PalmSpacings.l),

              // Main message
              _buildMainMessage(),

              const SizedBox(height: PalmSpacings.m),

              // Secondary message with navigation guidance
              _buildNavigationGuidance(),

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

  /// Build success icon with clock and check badge
  Widget _buildSuccessIcon() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: PalmColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Clock icon
          Icon(
            Icons.schedule,
            size: 70,
            color: PalmColors.primary,
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
  Widget _buildTitle() {
    return Text(
      'Your time off request has\nbeen submitted for review.',
      textAlign: TextAlign.center,
      style: PalmTextStyles.title.copyWith(
        color: PalmColors.textNormal,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
    );
  }

  /// Build main confirmation message
  Widget _buildMainMessage() {
    return Text(
      'You can check your leave report screen to see your approval status.',
      textAlign: TextAlign.center,
      style: PalmTextStyles.body.copyWith(
        color: PalmColors.textNormal,
        fontSize: 16,
      ),
    );
  }

  /// Build navigation guidance with icon
  Widget _buildNavigationGuidance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline,
          color: PalmColors.secondary,
          size: 18,
        ),
        const SizedBox(width: PalmSpacings.xs),
        Text(
          'Navigate to Leave Record Screen',
          textAlign: TextAlign.center,
          style: PalmTextStyles.body.copyWith(
            color: PalmColors.secondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build navigation button
  Widget _buildNavigationButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onSoundsGood,
        style: ElevatedButton.styleFrom(
          backgroundColor: PalmColors.primary,
          foregroundColor: PalmColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
          ),
          elevation: 3,
        ),
        child: Text(
          'Click Back To Home',
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
