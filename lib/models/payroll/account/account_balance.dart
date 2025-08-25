/// Account balance model represents the master account information
/// containing account details like name, number, and current balance.
class AccountBalance {
  final String accountName;
  final String accountNo;
  final String currentBalance;
  final String status;

  const AccountBalance({
    required this.accountName,
    required this.accountNo,
    required this.currentBalance,
    required this.status,
  });

  /// Creates an AccountBalance from JSON data
  factory AccountBalance.fromJson(Map<String, dynamic> json) {
    return AccountBalance(
      accountName: json['account_name'] ?? '',
      accountNo: json['account_no'] ?? '',
      currentBalance: json['current_balance'] ?? '0',
      status: json['01'] ?? '0',                // API returns '01' field for validation
    );
  }

  /// Converts AccountBalance to JSON
  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'account_no': accountNo,
      'current_balance': currentBalance,
      '01': status,
    };
  }

  /// Creates a copy of AccountBalance with updated fields
  AccountBalance copyWith({
    String? accountName,
    String? accountNo,
    String? currentBalance,
    String? status,
  }) {
    return AccountBalance(
      accountName: accountName ?? this.accountName,
      accountNo: accountNo ?? this.accountNo,
      currentBalance: currentBalance ?? this.currentBalance,
      status: status ?? this.status,
    );
  }

  /// Checks if account is valid based on status
  bool get isValid => status != "0";

  /// Gets formatted current balance as double
  double get currentBalanceAsDouble {
    try {
      return double.parse(currentBalance);
    } catch (e) {
      return 0.0;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccountBalance &&
        other.accountName == accountName &&
        other.accountNo == accountNo &&
        other.currentBalance == currentBalance &&
        other.status == status;
  }

  @override
  int get hashCode {
    return accountName.hashCode ^
        accountNo.hashCode ^
        currentBalance.hashCode ^
        status.hashCode;
  }

  @override
  String toString() {
    return 'AccountBalance(accountName: $accountName, accountNo: $accountNo, currentBalance: $currentBalance, status: $status)';
  }
}
