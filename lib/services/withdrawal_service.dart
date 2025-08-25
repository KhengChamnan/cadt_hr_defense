import '../models/payroll/withdrawal_model.dart';
import '../services/account_service.dart';

/// This service handles all withdrawal-related operations.
/// Integrates with AccountService to use consistent account balance data.
/// TODO: Replace mock data with actual API calls when backend is available.
class WithdrawalService {
  
  /// Fetches current account balance and withdrawal eligibility.
  /// Uses data from AccountService for consistency.
  static Future<WithdrawalModel> getAccountInfo() async {
    // Get account balance from the same service used in account screen
    final accountBalance = await AccountService.fetchAccountBalance();
    
    // Convert to WithdrawalModel format
    return WithdrawalModel(
      accountName: accountBalance.accountName,
      accountNo: accountBalance.accountNo,
      currentBalance: accountBalance.currentBalanceAsDouble,
      requestAmount: 0.0,
      isWithdrawalAllowed: accountBalance.isValid,
    );
  }

  /// Submits a withdrawal request to the server.
  /// Returns success status and withdrawal ID.
  static Future<Map<String, dynamic>> submitWithdrawalRequest({
    required double amount,
    String? remark,
  }) async {
    // Validate amount
    if (amount <= 0) {
      throw Exception('Withdrawal amount must be greater than zero');
    }

    // Simulate API loading delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Mock successful withdrawal submission
    return {
      'success': true,
      'message': 'Withdrawal request submitted successfully',
      'withdrawal_id': 'WD-${DateTime.now().millisecondsSinceEpoch}',
      'amount': amount,
      'status': 'pending',
      'request_date': DateTime.now().toIso8601String(),
    };
  }

  /// Validates withdrawal amount against current balance and limits.
  static bool validateWithdrawalAmount(double amount, double currentBalance) {
    if (amount <= 0) return false;                    // Amount must be positive
    if (amount > currentBalance) return false;        // Cannot exceed balance
    return true;                                      // Valid amount
  }

  /// Formats currency amount for display.
  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}
