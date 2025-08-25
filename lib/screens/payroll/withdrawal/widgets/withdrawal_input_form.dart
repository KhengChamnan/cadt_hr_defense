import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../theme/app_theme.dart';

/// This widget provides input fields for withdrawal amount and remark.
/// Uses consistent styling and validation according to the app's design system.
class WithdrawalInputForm extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController remarkController;
  final VoidCallback onSubmit;
  final bool isLoading;

  const WithdrawalInputForm({
    super.key,
    required this.amountController,
    required this.remarkController,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PalmSpacings.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Amount input field
          _buildAmountTextField(),
          
          const SizedBox(height: PalmSpacings.l),
          
          // Remark input field
          _buildRemarkTextField(),
          
          const SizedBox(height: PalmSpacings.xl),
          
          // Submit button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  /// Builds the amount input text field with proper styling and validation.
  Widget _buildAmountTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Withdrawal Amount',
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.textNormal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: PalmSpacings.xs),
        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          style: PalmTextStyles.body.copyWith(color: PalmColors.textNormal),
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '\$ ',
            prefixStyle: PalmTextStyles.body.copyWith(
              color: PalmColors.textLight,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PalmSpacings.s),
              borderSide: BorderSide(color: PalmColors.greyLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PalmSpacings.s),
              borderSide: BorderSide(color: PalmColors.greyLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PalmSpacings.s),
              borderSide: BorderSide(color: PalmColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(PalmSpacings.m),
            filled: true,
            fillColor: PalmColors.white,
          ),
        ),
      ],
    );
  }

  /// Builds the remark input text field with multiline support.
  Widget _buildRemarkTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Remark (Optional)',
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.textNormal,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: PalmSpacings.xs),
        TextField(
          controller: remarkController,
          maxLines: 4,
          style: PalmTextStyles.body.copyWith(color: PalmColors.textNormal),
          decoration: InputDecoration(
            hintText: 'Enter withdrawal reason or additional notes...',
            hintStyle: PalmTextStyles.body.copyWith(
              color: PalmColors.textLight,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PalmSpacings.s),
              borderSide: BorderSide(color: PalmColors.greyLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PalmSpacings.s),
              borderSide: BorderSide(color: PalmColors.greyLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(PalmSpacings.s),
              borderSide: BorderSide(color: PalmColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(PalmSpacings.m),
            filled: true,
            fillColor: PalmColors.white,
          ),
        ),
      ],
    );
  }

  /// Builds the submit button with loading state and proper styling.
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: PalmColors.primary,
        foregroundColor: PalmColors.white,
        padding: const EdgeInsets.symmetric(vertical: PalmSpacings.m),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.s),
        ),
        elevation: 0,
        disabledBackgroundColor: PalmColors.disabled,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(PalmColors.white),
              ),
            )
          : Text(
              'SUBMIT WITHDRAWAL',
              style: PalmTextStyles.button.copyWith(
                color: PalmColors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
    );
  }
}
