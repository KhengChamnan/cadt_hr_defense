/// Account statement model represents individual transaction records
/// with details like amount, date, note, and transaction type.
class AccountStatement {
  final String id;
  final String amount;
  final String balance;
  final String date;
  final String note;
  final String transaction;

  const AccountStatement({
    required this.id,
    required this.amount,
    required this.balance,
    required this.date,
    required this.note,
    required this.transaction,
  });

  /// Creates an AccountStatement from JSON data
  factory AccountStatement.fromJson(Map<String, dynamic> json) {
    return AccountStatement(
      id: json['id']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      balance: json['balance']?.toString() ?? '0',
      date: json['date'] ?? '',
      note: json['note'] ?? '',
      transaction: json['transation'] ?? '',          // Note: API uses 'transation' (typo)
    );
  }

  /// Converts AccountStatement to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'balance': balance,
      'date': date,
      'note': note,
      'transation': transaction,                      // Keep API typo for compatibility
    };
  }

  /// Creates a copy of AccountStatement with updated fields
  AccountStatement copyWith({
    String? id,
    String? amount,
    String? balance,
    String? date,
    String? note,
    String? transaction,
  }) {
    return AccountStatement(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      balance: balance ?? this.balance,
      date: date ?? this.date,
      note: note ?? this.note,
      transaction: transaction ?? this.transaction,
    );
  }

  /// Gets amount as double for calculations
  double get amountAsDouble {
    try {
      return double.parse(amount);
    } catch (e) {
      return 0.0;
    }
  }

  /// Gets balance as double for calculations
  double get balanceAsDouble {
    try {
      return double.parse(balance);
    } catch (e) {
      return 0.0;
    }
  }

  /// Gets formatted date as DateTime object
  DateTime? get dateAsDateTime {
    try {
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }

  /// Gets formatted date string for grouping (YYYY-MM-DD)
  String get dateForGrouping {
    final dateTime = dateAsDateTime;
    if (dateTime != null) {
      return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
    return '';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccountStatement &&
        other.id == id &&
        other.amount == amount &&
        other.balance == balance &&
        other.date == date &&
        other.note == note &&
        other.transaction == transaction;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        balance.hashCode ^
        date.hashCode ^
        note.hashCode ^
        transaction.hashCode;
  }

  @override
  String toString() {
    return 'AccountStatement(id: $id, amount: $amount, balance: $balance, date: $date, note: $note, transaction: $transaction)';
  }
}
