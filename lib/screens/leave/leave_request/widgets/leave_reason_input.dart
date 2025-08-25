import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A comprehensive reason input widget for leave requests
/// Provides validation, error states, and guidance text
class LeaveReasonInput extends StatelessWidget {
  final TextEditingController controller;
  final bool showValidationError;
  final Function(String)? onChanged;
  final VoidCallback? onFieldSubmitted;

  const LeaveReasonInput({
    super.key,
    required this.controller,
    this.showValidationError = false,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radius),
        boxShadow: [
          BoxShadow(
            color: PalmColors.dark.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          _buildSectionHeader(),

          const SizedBox(height: PalmSpacings.m),

          // Reason text field
          _buildReasonTextField(context),

          const SizedBox(height: PalmSpacings.s),

          // Validation warning
          if (showValidationError) _buildValidationWarning(),

          // Helper text
          _buildHelperText(),
        ],
      ),
    );
  }

  /// Build section header with icon and title
  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(PalmSpacings.xs),
          decoration: BoxDecoration(
            color: PalmColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(PalmSpacings.xs),
          ),
          child: Icon(
            Icons.description_outlined,
            color: PalmColors.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: PalmSpacings.s),
        Text(
          'REASON FOR LEAVE',
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.textLight,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  /// Build the main text field for reason input
  Widget _buildReasonTextField(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      maxLength: 500,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      onFieldSubmitted: (value) {
        // Dismiss keyboard when user presses enter/done
        FocusScope.of(context).unfocus();
        onFieldSubmitted?.call();
      },
      decoration: InputDecoration(
        hintText: 'Please provide a detailed reason for your leave request...',
        hintStyle: PalmTextStyles.body.copyWith(
          color: PalmColors.textLight,
        ),
        // Dynamic border styling based on validation state
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          borderSide: showValidationError
              ? BorderSide(color: PalmColors.danger, width: 1.5)
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          borderSide: showValidationError
              ? BorderSide(color: PalmColors.danger, width: 1.5)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          borderSide: showValidationError
              ? BorderSide(color: PalmColors.danger, width: 2)
              : BorderSide(color: PalmColors.primary, width: 2),
        ),
        filled: true,
        fillColor: showValidationError
            ? PalmColors.danger.withOpacity(0.05)
            : PalmColors.greyLight.withOpacity(0.1),
        contentPadding: const EdgeInsets.all(PalmSpacings.m),
        counterStyle: PalmTextStyles.caption.copyWith(
          color: PalmColors.textLight,
        ),
      ),
      style: PalmTextStyles.body.copyWith(
        color: PalmColors.textNormal,
      ),
    );
  }

  /// Build validation warning when field is empty
  Widget _buildValidationWarning() {
    return Padding(
      padding: const EdgeInsets.only(bottom: PalmSpacings.xs),
      child: Row(
        children: [
          Icon(
            Icons.warning_outlined,
            color: PalmColors.danger,
            size: 16,
          ),
          const SizedBox(width: PalmSpacings.xs),
          Text(
            'Please provide a reason for your leave request',
            style: PalmTextStyles.caption.copyWith(
              color: PalmColors.danger,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build helper text with guidance
  Widget _buildHelperText() {
    return Text(
      'Be specific about your reason for the leave request. This information will be reviewed by your supervisor and manager.',
      style: PalmTextStyles.caption.copyWith(
        color: PalmColors.textLight,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
