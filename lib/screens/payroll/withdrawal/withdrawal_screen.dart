import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/payroll/withdrawal_model.dart';
import '../../../services/withdrawal_service.dart';
import '../../../widgets/loading_widget.dart';
import 'widgets/withdrawal_app_bar.dart';
import 'widgets/withdrawal_account_balance_card.dart';
import 'widgets/withdrawal_input_form.dart';

/// This screen allows users to:
/// - View their current account balance and account information.
/// - Enter withdrawal amount and optional remark.
/// - Submit withdrawal requests for processing.
class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  
  WithdrawalModel? _accountData;
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchAccountData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  /// Fetches account balance and withdrawal eligibility from the service.
  Future<void> _fetchAccountData() async {
    try {
      setState(() {
        _isLoading = true;                           // Show loading indicator
      });
      
      final accountData = await WithdrawalService.getAccountInfo();
      
      setState(() {
        _accountData = accountData;
        _isLoading = false;                          // Hide loading indicator
      });
    } catch (error) {
      setState(() {
        _isLoading = false;                          // Hide loading indicator
      });
      
      // Show error message to user
      _showErrorSnackBar('Failed to load account information. Please try again.');
    }
  }

  /// Handles withdrawal request submission with validation.
  Future<void> _onSubmitWithdrawal() async {
    final amountText = _amountController.text.trim();
    
    // 1 - Validate input amount
    if (amountText.isEmpty || amountText == '0') {
      _showErrorSnackBar('Please enter a valid withdrawal amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showErrorSnackBar('Please enter a valid withdrawal amount');
      return;
    }

    // 2 - Validate against current balance
    if (_accountData != null && !WithdrawalService.validateWithdrawalAmount(amount, _accountData!.currentBalance)) {
      _showErrorSnackBar('Withdrawal amount exceeds current balance');
      return;
    }

    try {
      setState(() {
        _isSubmitting = true;                        // Show loading on button
      });

      // 3 - Submit withdrawal request
      final response = await WithdrawalService.submitWithdrawalRequest(
        amount: amount,
        remark: _remarkController.text.trim(),
      );

      setState(() {
        _isSubmitting = false;                       // Hide loading on button
      });

      if (response['success'] == true) {
        // 4 - Clear form and show success message
        _amountController.clear();
        _remarkController.clear();
        
        _showSuccessSnackBar('Withdrawal request submitted successfully!');
      } else {
        _showErrorSnackBar(response['message'] ?? 'Failed to submit withdrawal request');
      }
    } catch (error) {
      setState(() {
        _isSubmitting = false;                       // Hide loading on button
      });
      
      _showErrorSnackBar('Failed to submit withdrawal request. Please try again.');
    }
  }

  /// Shows success message to the user.
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: PalmTextStyles.body.copyWith(color: PalmColors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: PalmColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.s),
        ),
        margin: const EdgeInsets.all(PalmSpacings.m),
      ),
    );
  }

  /// Shows error message to the user.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: PalmTextStyles.body.copyWith(color: PalmColors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: PalmColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.s),
        ),
        margin: const EdgeInsets.all(PalmSpacings.m),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.backgroundAccent,
      appBar: const WithdrawalAppBar(
        title: 'Withdrawal Request',
      ),
      body: _buildBody(),
    );
  }

  /// Builds the main body content based on loading and data states.
  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingWidget();
    }

    if (_accountData == null) {
      return _buildErrorState();
    }

    if (!_accountData!.isWithdrawalAllowed) {
      return _buildWithdrawalNotAllowedState();
    }

    return _buildWithdrawalForm();
  }

  /// Builds error state when data loading fails.
  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: PalmColors.danger,
          ),
          const SizedBox(height: PalmSpacings.l),
          Text(
            'Failed to load account information',
            style: PalmTextStyles.title.copyWith(
              color: PalmColors.textNormal,
            ),
          ),
          const SizedBox(height: PalmSpacings.m),
          ElevatedButton(
            onPressed: _fetchAccountData,
            style: ElevatedButton.styleFrom(
              backgroundColor: PalmColors.primary,
              foregroundColor: PalmColors.white,
            ),
            child: Text(
              'Retry',
              style: PalmTextStyles.button.copyWith(
                color: PalmColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds state when withdrawal is not allowed for the account.
  Widget _buildWithdrawalNotAllowedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.block,
            size: 64,
            color: PalmColors.warning,
          ),
          const SizedBox(height: PalmSpacings.l),
          Text(
            'Withdrawal Not Available',
            style: PalmTextStyles.title.copyWith(
              color: PalmColors.textNormal,
            ),
          ),
          const SizedBox(height: PalmSpacings.s),
          Text(
            'Withdrawal is not currently available for your account.',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the main withdrawal form with balance card and input fields.
  Widget _buildWithdrawalForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Account balance card
          WithdrawalAccountBalanceCard(
            accountData: _accountData!,
          ),
          
          const SizedBox(height: PalmSpacings.m),
          
          // Input form
          WithdrawalInputForm(
            amountController: _amountController,
            remarkController: _remarkController,
            onSubmit: _onSubmitWithdrawal,
            isLoading: _isSubmitting,
          ),
          
          // Bottom padding for better scrolling experience
          const SizedBox(height: PalmSpacings.xl),
        ],
      ),
    );
  }
}
