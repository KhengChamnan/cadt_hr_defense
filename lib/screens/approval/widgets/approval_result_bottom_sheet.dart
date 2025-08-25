import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A result bottom sheet modal that appears after an approval action is performed
/// Shows success or error confirmation and navigation guidance
class ApprovalResultBottomSheet extends StatelessWidget {
  final bool isSuccess;
  final String message;
  final String actionType; // "approve" or "reject"
  final VoidCallback onDone;

  const ApprovalResultBottomSheet({
    super.key,
    required this.isSuccess,
    required this.message,
    required this.actionType,
    required this.onDone,
  });

  /// Show the success bottom sheet modal
  static Future<void> showSuccess(
    BuildContext context, {
    required String actionType, // "approve" or "reject"
    required VoidCallback onDone,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      builder: (context) => ApprovalResultBottomSheet(
        isSuccess: true,
        message: actionType == "approve" 
            ? "Leave request has been approved successfully!"
            : "Leave request has been rejected successfully!",
        actionType: actionType,
        onDone: onDone,
      ),
    );
  }

  /// Show the error bottom sheet modal
  static Future<void> showError(
    BuildContext context, {
    required String message,
    required String actionType,
    required VoidCallback onDone,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      builder: (context) => ApprovalResultBottomSheet(
        isSuccess: false,
        message: message,
        actionType: actionType,
        onDone: onDone,
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
              // Success/Error icon
              _buildResultIcon(),

              const SizedBox(height: PalmSpacings.xxl),

              // Title
              _buildTitle(),

              const SizedBox(height: PalmSpacings.l),

              // Main message
              _buildMainMessage(),

              const SizedBox(height: PalmSpacings.m),

              // Secondary message with guidance
              _buildGuidance(),

              const SizedBox(height: PalmSpacings.xxl),

              // Action button
              _buildActionButton(),

              const SizedBox(height: PalmSpacings.l),
            ],
          ),
        ),
      ),
    );
  }

  /// Build success/error icon
  Widget _buildResultIcon() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: isSuccess 
            ? PalmColors.primary.withOpacity(0.1)
            : PalmColors.danger.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main icon
          Icon(
            isSuccess ? Icons.task_alt : Icons.error_outline,
            size: 70,
            color: isSuccess ? PalmColors.primary : PalmColors.danger,
          ),
          // Badge icon
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSuccess ? PalmColors.primary : PalmColors.danger,
                shape: BoxShape.circle,
                border: Border.all(
                  color: PalmColors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isSuccess ? Icons.check : Icons.close,
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
      isSuccess 
          ? 'Approval Action Completed!'
          : 'Approval Action Failed',
      textAlign: TextAlign.center,
      style: PalmTextStyles.title.copyWith(
        color: isSuccess ? PalmColors.primary : PalmColors.danger,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
    );
  }

  /// Build main confirmation message
  Widget _buildMainMessage() {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: PalmTextStyles.body.copyWith(
        color: PalmColors.textNormal,
        fontSize: 16,
      ),
    );
  }

  /// Build guidance message
  Widget _buildGuidance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isSuccess ? Icons.info_outline : Icons.warning_amber_outlined,
          color: isSuccess ? PalmColors.primary : PalmColors.warning,
          size: 18,
        ),
        const SizedBox(width: PalmSpacings.xs),
        Expanded(
          child: Text(
            isSuccess 
                ? 'The approval list will be updated automatically'
                : 'Please check the details and try again',
            textAlign: TextAlign.center,
            style: PalmTextStyles.body.copyWith(
              color: isSuccess ? PalmColors.primary : PalmColors.warning,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  /// Build action button
  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onDone,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSuccess ? PalmColors.primary : PalmColors.danger,
          foregroundColor: PalmColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: (isSuccess ? PalmColors.primary : PalmColors.danger).withOpacity(0.3),
        ),
        child: Text(
          isSuccess ? 'Back to Approval List' : 'Try Again',
          style: PalmTextStyles.button.copyWith(
            color: PalmColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
