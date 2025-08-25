/// This model represents an individual sale statement detail item containing:
/// - Sale transaction ID and description
/// - Sale amount and date information
class SaleStatementDetail {
  final String? id;
  final String? description;
  final String? amount;
  final String? date;

  SaleStatementDetail({
    this.id,
    this.description,
    this.amount,
    this.date,
  });

  /// Creates a SaleStatementDetail instance from JSON data
  factory SaleStatementDetail.fromJson(Map<String, dynamic> json) {
    return SaleStatementDetail(
      id: json['Id']?.toString() ?? json['id']?.toString(),
      description: json['Description']?.toString(),
      amount: json['Amount']?.toString(),
      date: json['Date']?.toString(),
    );
  }

  /// Converts the SaleStatementDetail instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Description': description,
      'Amount': amount,
      'Date': date,
    };
  }

  /// Creates a copy of this SaleStatementDetail with some fields replaced
  SaleStatementDetail copyWith({
    String? id,
    String? description,
    String? amount,
    String? date,
  }) {
    return SaleStatementDetail(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleStatementDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          description == other.description &&
          amount == other.amount &&
          date == other.date;

  @override
  int get hashCode => id.hashCode ^ description.hashCode ^ amount.hashCode ^ date.hashCode;

  @override
  String toString() {
    return 'SaleStatementDetail{id: $id, description: $description, amount: $amount, date: $date}';
  }
}

/// This model groups sale statement details by date for organized display
class SaleStatementDetailGrouped {
  final String date;
  final List<SaleStatementDetail> sales;

  SaleStatementDetailGrouped({
    required this.date,
    required this.sales,
  });

  /// Creates a SaleStatementDetailGrouped instance from map entry with grouped data
  factory SaleStatementDetailGrouped.fromMapEntry(MapEntry<String, List<dynamic>> entry) {
    return SaleStatementDetailGrouped(
      date: entry.key,
      sales: entry.value.map((item) => SaleStatementDetail.fromJson(item)).toList(),
    );
  }

  /// Creates a copy of this SaleStatementDetailGrouped with some fields replaced
  SaleStatementDetailGrouped copyWith({
    String? date,
    List<SaleStatementDetail>? sales,
  }) {
    return SaleStatementDetailGrouped(
      date: date ?? this.date,
      sales: sales ?? this.sales,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleStatementDetailGrouped &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          sales == other.sales;

  @override
  int get hashCode => date.hashCode ^ sales.hashCode;

  @override
  String toString() {
    return 'SaleStatementDetailGrouped{date: $date, sales: ${sales.length} items}';
  }
}
