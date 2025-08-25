import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A specialized submit button for leave requests
/// Provides different states and styling based on form completion and submission status
class LeaveSubmitButton extends StatelessWidget {
  final bool canContinue;
  final bool isSubmitting;
  final bool hasSelectedLeaveType;
  final VoidCallback? onPressed;

  const LeaveSubmitButton({
    super.key,
    required this.canContinue,
    required this.isSubmitting,
    required this.hasSelectedLeaveType,
    this.onPressed,
  });

  /// Get the appropriate button text based on current state
  String get _buttonText {
    if (isSubmitting) {
      return 'Submitting...';
    } else if (hasSelectedLeaveType) {
      return 'Submit';
    } else {
      return 'Continue';
    }
  }

  /// Get the appropriate icon based on current state
  Widget? get _buttonIcon {
    if (isSubmitting) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          color: PalmColors.white,
          strokeWidth: 2,
        ),
      );
    } else if (hasSelectedLeaveType) {
      return Icon(
        Icons.send,
        color: (canContinue && !isSubmitting)
            ? PalmColors.white
            : PalmColors.textLight,
        size: 18,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white,
        boxShadow: [
          BoxShadow(
            color: PalmColors.dark.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: (canContinue && !isSubmitting) ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: (canContinue && !isSubmitting)
                  ? PalmColors.primary
                  : PalmColors.disabled,
              foregroundColor: (canContinue && !isSubmitting)
                  ? PalmColors.white
                  : PalmColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius),
              ),
              elevation: (canContinue && !isSubmitting) ? 2 : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_buttonIcon != null) _buttonIcon!,
                if (hasSelectedLeaveType && _buttonIcon != null)
                  const SizedBox(width: PalmSpacings.xs),
                Text(
                  _buttonText,
                  style: PalmTextStyles.button.copyWith(
                    color: (canContinue && !isSubmitting)
                        ? PalmColors.white
                        : PalmColors.textLight,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
