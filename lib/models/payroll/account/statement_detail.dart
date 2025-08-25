/// Statement detail model represents detailed popup information
/// for a specific transaction including additional fields for PDF generation.
class StatementDetail {
  final String originalAmount;
  final String toMemberId;
  final String remark;
  final String amount;

  const StatementDetail({
    required this.originalAmount,
    required this.toMemberId,
    required this.remark,
    required this.amount,
  });

  /// Creates a StatementDetail from JSON data
  factory StatementDetail.fromJson(Map<String, dynamic> json) {
    return StatementDetail(
      originalAmount: json['original_amount']?.toString() ?? '0',
      toMemberId: json['to_member_id']?.toString() ?? '',
      remark: json['remark'] ?? '',
      amount: json['amount']?.toString() ?? '0',
    );
  }

  /// Converts StatementDetail to JSON
  Map<String, dynamic> toJson() {
    return {
      'original_amount': originalAmount,
      'to_member_id': toMemberId,
      'remark': remark,
      'amount': amount,
    };
  }

  /// Creates a copy of StatementDetail with updated fields
  StatementDetail copyWith({
    String? originalAmount,
    String? toMemberId,
    String? remark,
    String? amount,
  }) {
    return StatementDetail(
      originalAmount: originalAmount ?? this.originalAmount,
      toMemberId: toMemberId ?? this.toMemberId,
      remark: remark ?? this.remark,
      amount: amount ?? this.amount,
    );
  }

  /// Gets original amount as double for calculations
  double get originalAmountAsDouble {
    try {
      return double.parse(originalAmount);
    } catch (e) {
      return 0.0;
    }
  }

  /// Gets amount as double for calculations
  double get amountAsDouble {
    try {
      return double.parse(amount);
    } catch (e) {
      return 0.0;
    }
  }

  /// Gets formatted original amount with 2 decimal places
  String get formattedOriginalAmount {
    return originalAmountAsDouble.toStringAsFixed(2);
  }

  /// Gets formatted amount with 2 decimal places
  String get formattedAmount {
    return amountAsDouble.toStringAsFixed(2);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StatementDetail &&
        other.originalAmount == originalAmount &&
        other.toMemberId == toMemberId &&
        other.remark == remark &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return originalAmount.hashCode ^
        toMemberId.hashCode ^
        remark.hashCode ^
        amount.hashCode;
  }

  @override
  String toString() {
    return 'StatementDetail(originalAmount: $originalAmount, toMemberId: $toMemberId, remark: $remark, amount: $amount)';
  }
}
