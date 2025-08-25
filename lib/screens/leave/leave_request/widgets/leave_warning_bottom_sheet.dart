import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A warning bottom sheet modal that appears when a leave request will result in a negative balance
/// Provides options to proceed or cancel the request
class LeaveWarningBottomSheet extends StatelessWidget {
  final VoidCallback onSendRequest;
  final VoidCallback onCancel;

  const LeaveWarningBottomSheet({
    super.key,
    required this.onSendRequest,
    required this.onCancel,
  });

  /// Show the warning bottom sheet modal
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onSendRequest,
    required VoidCallback onCancel,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      builder: (context) => LeaveWarningBottomSheet(
        onSendRequest: onSendRequest,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight, // Full screen height like success sheet
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
              // Warning icon
              _buildWarningIcon(),

              const SizedBox(height: PalmSpacings.xxl),

              // Title
              _buildTitle(),

              const SizedBox(height: PalmSpacings.l),

              // Subtitle
              _buildSubtitle(),

              const SizedBox(height: PalmSpacings.m),

              // Additional info with icon
              _buildAdditionalInfo(),

              const SizedBox(height: PalmSpacings.xxl),

              // Action buttons
              _buildActionButtons(),

              const SizedBox(height: PalmSpacings.l),
            ],
          ),
        ),
      ),
    );
  }

  /// Build warning icon with background
  Widget _buildWarningIcon() {
    return Container(
      width: 140, // Match success sheet size
      height: 140,
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Warning triangle icon
          Icon(
            Icons.warning_amber_rounded,
            size: 70, // Larger icon like success sheet
            color: Colors.orange,
          ),
          // Exclamation badge
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: PalmColors.white,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.priority_high,
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
      'This will leave you\nwith a negative balance.',
      textAlign: TextAlign.center,
      style: PalmTextStyles.title.copyWith(
        color: PalmColors.textNormal,
        fontWeight: FontWeight.w600,
        fontSize: 24, // Match success sheet font size
      ),
    );
  }

  /// Build subtitle question
  Widget _buildSubtitle() {
    return Text(
      'Do you still want to send this request?',
      textAlign: TextAlign.center,
      style: PalmTextStyles.body.copyWith(
        color: PalmColors.textNormal, // Match success sheet text color
        fontSize: 16, // Match success sheet font size
      ),
    );
  }

  /// Build additional info with icon (similar to navigation guidance in success sheet)
  Widget _buildAdditionalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.info_outline,
          color: Colors.orange,
          size: 18,
        ),
        const SizedBox(width: PalmSpacings.xs),
        Text(
          'This action cannot be undone',
          textAlign: TextAlign.center,
          style: PalmTextStyles.body.copyWith(
            color: Colors.orange,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build action buttons (Send Request and Cancel)
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Yes, Send Request button
        SizedBox(
          width: double.infinity,
          height: 56, // Match success sheet button height
          child: ElevatedButton(
            onPressed: onSendRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: PalmColors.primary,
              foregroundColor: PalmColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius),
              ),
              elevation: 3, // Match success sheet elevation
            ),
            child: Text(
              'Yes, Send Request',
              style: PalmTextStyles.button.copyWith(
                color: PalmColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18, // Match success sheet font size
              ),
            ),
          ),
        ),

        const SizedBox(height: PalmSpacings.m), // Increased spacing

        // Cancel button
        SizedBox(
          width: double.infinity,
          height: 56, // Match success sheet button height
          child: TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              foregroundColor: PalmColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius),
                side: BorderSide(
                  color: PalmColors.greyLight, // Add border for better definition
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Cancel',
              style: PalmTextStyles.button.copyWith(
                color: PalmColors.textLight,
                fontWeight: FontWeight.w500,
                fontSize: 18, // Match success sheet font size
              ),
            ),
          ),
        ),
      ],
    );
  }
}
