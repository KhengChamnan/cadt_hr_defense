/// This model represents the master sale statement data containing:
/// - Summary counts for direct and indirect sales
/// - Total amounts for direct and indirect sales
class SaleStatementMaster {
  final String? countSellDirect;
  final String? countSellIndirect;
  final String? amountDirect;
  final String? amountIndirect;

  SaleStatementMaster({
    this.countSellDirect,
    this.countSellIndirect,
    this.amountDirect,
    this.amountIndirect,
  });

  /// Creates a SaleStatementMaster instance from JSON data
  factory SaleStatementMaster.fromJson(Map<String, dynamic> json) {
    return SaleStatementMaster(
      countSellDirect: json['count_sell_direct']?.toString(),
      countSellIndirect: json['count_sell_indirect']?.toString(),
      amountDirect: json['amount_direct']?.toString(),
      amountIndirect: json['amount_indirect']?.toString(),
    );
  }

  /// Converts the SaleStatementMaster instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'count_sell_direct': countSellDirect,
      'count_sell_indirect': countSellIndirect,
      'amount_direct': amountDirect,
      'amount_indirect': amountIndirect,
    };
  }

  /// Creates a copy of this SaleStatementMaster with some fields replaced
  SaleStatementMaster copyWith({
    String? countSellDirect,
    String? countSellIndirect,
    String? amountDirect,
    String? amountIndirect,
  }) {
    return SaleStatementMaster(
      countSellDirect: countSellDirect ?? this.countSellDirect,
      countSellIndirect: countSellIndirect ?? this.countSellIndirect,
      amountDirect: amountDirect ?? this.amountDirect,
      amountIndirect: amountIndirect ?? this.amountIndirect,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleStatementMaster &&
          runtimeType == other.runtimeType &&
          countSellDirect == other.countSellDirect &&
          countSellIndirect == other.countSellIndirect &&
          amountDirect == other.amountDirect &&
          amountIndirect == other.amountIndirect;

  @override
  int get hashCode =>
      countSellDirect.hashCode ^
      countSellIndirect.hashCode ^
      amountDirect.hashCode ^
      amountIndirect.hashCode;

  @override
  String toString() {
    return 'SaleStatementMaster{countSellDirect: $countSellDirect, countSellIndirect: $countSellIndirect, amountDirect: $amountDirect, amountIndirect: $amountIndirect}';
  }
}
