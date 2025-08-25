/// This model represents detailed sale statement popup information containing:
/// - Transaction parties (direct from, to member, from customer)
/// - Transaction details (remark, original amount)
class SaleStatementPopup {
  final String? directFrom;
  final String? toMember;
  final String? fromCustomer;
  final String? remark;
  final String? originalAmount;

  SaleStatementPopup({
    this.directFrom,
    this.toMember,
    this.fromCustomer,
    this.remark,
    this.originalAmount,
  });

  /// Creates a SaleStatementPopup instance from JSON data
  factory SaleStatementPopup.fromJson(Map<String, dynamic> json) {
    return SaleStatementPopup(
      directFrom: json['direct_from']?.toString(),
      toMember: json['to_member']?.toString(),
      fromCustomer: json['from_customer']?.toString(),
      remark: json['remark']?.toString(),
      originalAmount: json['original_amount']?.toString(),
    );
  }

  /// Converts the SaleStatementPopup instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'direct_from': directFrom,
      'to_member': toMember,
      'from_customer': fromCustomer,
      'remark': remark,
      'original_amount': originalAmount,
    };
  }

  /// Creates a copy of this SaleStatementPopup with some fields replaced
  SaleStatementPopup copyWith({
    String? directFrom,
    String? toMember,
    String? fromCustomer,
    String? remark,
    String? originalAmount,
  }) {
    return SaleStatementPopup(
      directFrom: directFrom ?? this.directFrom,
      toMember: toMember ?? this.toMember,
      fromCustomer: fromCustomer ?? this.fromCustomer,
      remark: remark ?? this.remark,
      originalAmount: originalAmount ?? this.originalAmount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleStatementPopup &&
          runtimeType == other.runtimeType &&
          directFrom == other.directFrom &&
          toMember == other.toMember &&
          fromCustomer == other.fromCustomer &&
          remark == other.remark &&
          originalAmount == other.originalAmount;

  @override
  int get hashCode =>
      directFrom.hashCode ^
      toMember.hashCode ^
      fromCustomer.hashCode ^
      remark.hashCode ^
      originalAmount.hashCode;

  @override
  String toString() {
    return 'SaleStatementPopup{directFrom: $directFrom, toMember: $toMember, fromCustomer: $fromCustomer, remark: $remark, originalAmount: $originalAmount}';
  }
}
