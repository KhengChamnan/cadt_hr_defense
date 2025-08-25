import 'package:flutter/material.dart';
import '../models/payroll/account/account_balance.dart';
import '../models/payroll/account/account_statement.dart';
import '../models/payroll/account/statement_detail.dart';
import '../providers/asyncvalue.dart';
import '../services/account_service.dart';

/// Provider for account-related data and operations.
/// Follows the AsyncValue pattern for consistent state management.
class AccountProvider extends ChangeNotifier {
  // Account balance data
  AsyncValue<AccountBalance>? _accountBalance;
  
  // Account statements data
  AsyncValue<List<AccountStatement>>? _accountStatements;
  
  // Statement detail data (for popup dialog)
  AsyncValue<StatementDetail>? _statementDetail;
  
  // Grouped statements for UI display
  Map<String, List<AccountStatement>> _groupedStatements = {};
  List<String> _sortedDates = [];

  // Getters
  AsyncValue<AccountBalance>? get accountBalance => _accountBalance;
  AsyncValue<List<AccountStatement>>? get accountStatements => _accountStatements;
  AsyncValue<StatementDetail>? get statementDetail => _statementDetail;
  Map<String, List<AccountStatement>> get groupedStatements => _groupedStatements;
  List<String> get sortedDates => _sortedDates;

  /// Fetch account balance information
  Future<void> getAccountBalance() async {
    print("💰 AccountProvider: getAccountBalance() called");
    
    // Prevent multiple simultaneous calls
    if (_accountBalance?.state == AsyncValueState.loading) {
      print("💰 AccountProvider: Already loading account balance, returning early");
      return;
    }
    
    print("💰 AccountProvider: Setting loading state for account balance");
    _accountBalance = AsyncValue.loading();
    
    // Use post-frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("💰 AccountProvider: Notifying loading state for account balance");
      notifyListeners();
    });

    try {
      print("💰 AccountProvider: Calling AccountService.fetchAccountBalance()");
      final balance = await AccountService.fetchAccountBalance();
      print("💰 AccountProvider: Account balance loaded successfully: ${balance.accountName}");
      _accountBalance = AsyncValue.success(balance);
    } catch (e) {
      print("💰 AccountProvider: Failed to load account balance: $e");
      _accountBalance = AsyncValue.error(e);
    }
    
    // Use post-frame callback for final notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("💰 AccountProvider: Notifying final state for account balance: ${_accountBalance?.state}");
      notifyListeners();
    });
  }

  /// Fetch account statements and process them for display
  Future<void> getAccountStatements() async {
    print("📋 AccountProvider: getAccountStatements() called");
    
    // Prevent multiple simultaneous calls
    if (_accountStatements?.state == AsyncValueState.loading) {
      print("📋 AccountProvider: Already loading account statements, returning early");
      return;
    }
    
    print("📋 AccountProvider: Setting loading state for account statements");
    _accountStatements = AsyncValue.loading();
    
    // Use post-frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("📋 AccountProvider: Notifying loading state for account statements");
      notifyListeners();
    });

    try {
      print("📋 AccountProvider: Calling AccountService.fetchAccountStatements()");
      final statements = await AccountService.fetchAccountStatements();
      print("📋 AccountProvider: Account statements loaded successfully: ${statements.length} items");
      
      // 1 - Process statements for grouped display
      _groupedStatements = AccountService.groupStatementsByDate(statements);
      _sortedDates = AccountService.getSortedDateKeys(_groupedStatements);
      
      _accountStatements = AsyncValue.success(statements);
    } catch (e) {
      print("📋 AccountProvider: Failed to load account statements: $e");
      _accountStatements = AsyncValue.error(e);
    }
    
    // Use post-frame callback for final notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("📋 AccountProvider: Notifying final state for account statements: ${_accountStatements?.state}");
      notifyListeners();
    });
  }

  /// Fetch statement detail for a specific transaction
  Future<void> getStatementDetail(String statementId) async {
    print("📄 AccountProvider: getStatementDetail() called for ID: $statementId");
    
    // Prevent multiple simultaneous calls
    if (_statementDetail?.state == AsyncValueState.loading) {
      print("📄 AccountProvider: Already loading statement detail, returning early");
      return;
    }
    
    print("📄 AccountProvider: Setting loading state for statement detail");
    _statementDetail = AsyncValue.loading();
    
    // Use post-frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("📄 AccountProvider: Notifying loading state for statement detail");
      notifyListeners();
    });

    try {
      print("📄 AccountProvider: Calling AccountService.fetchStatementDetail()");
      final detail = await AccountService.fetchStatementDetail(statementId);
      print("📄 AccountProvider: Statement detail loaded successfully for ID: $statementId");
      _statementDetail = AsyncValue.success(detail);
    } catch (e) {
      print("📄 AccountProvider: Failed to load statement detail: $e");
      _statementDetail = AsyncValue.error(e);
    }
    
    // Use post-frame callback for final notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("📄 AccountProvider: Notifying final state for statement detail: ${_statementDetail?.state}");
      notifyListeners();
    });
  }

  /// Load all account data (balance and statements)
  Future<void> loadAccountData() async {
    print("🏦 AccountProvider: loadAccountData() called");
    
    // Load both balance and statements concurrently
    await Future.wait([
      getAccountBalance(),
      getAccountStatements(),
    ]);
    
    print("🏦 AccountProvider: All account data loaded successfully");
  }

  /// Clear statement detail data (useful when closing dialog)
  void clearStatementDetail() {
    print("📄 AccountProvider: clearStatementDetail() called");
    _statementDetail = null;
    notifyListeners();
  }

  /// Refresh all account data
  Future<void> refreshAccountData() async {
    print("🔄 AccountProvider: refreshAccountData() called");
    
    // Reset all data
    _accountBalance = null;
    _accountStatements = null;
    _statementDetail = null;
    _groupedStatements.clear();
    _sortedDates.clear();
    
    // Reload data
    await loadAccountData();
    
    print("🔄 AccountProvider: Account data refreshed successfully");
  }

  /// Check if account is valid
  bool get isAccountValid {
    final balance = _accountBalance?.data;
    return balance != null && AccountService.isAccountValid(balance);
  }

  /// Check if any data is currently loading
  bool get isLoading {
    return _accountBalance?.state == AsyncValueState.loading ||
           _accountStatements?.state == AsyncValueState.loading ||
           _statementDetail?.state == AsyncValueState.loading;
  }

  /// Check if there are any errors
  bool get hasError {
    return _accountBalance?.state == AsyncValueState.error ||
           _accountStatements?.state == AsyncValueState.error ||
           _statementDetail?.state == AsyncValueState.error;
  }

  /// Get error message if any
  String? get errorMessage {
    if (_accountBalance?.state == AsyncValueState.error) {
      return _accountBalance?.error.toString();
    }
    if (_accountStatements?.state == AsyncValueState.error) {
      return _accountStatements?.error.toString();
    }
    if (_statementDetail?.state == AsyncValueState.error) {
      return _statementDetail?.error.toString();
    }
    return null;
  }
}
