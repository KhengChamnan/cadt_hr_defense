class CommissionDetail {
  final String? id;
  final String? description;
  final String? amount;
  final String? date;

  CommissionDetail({
    this.id,
    this.description,
    this.amount,
    this.date,
  });

  factory CommissionDetail.fromJson(Map<String, dynamic> json) {
    return CommissionDetail(
      id: json['id']?.toString(),
      description: json['Description']?.toString(),
      amount: json['Amount']?.toString(),
      date: json['Date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Description': description,
      'Amount': amount,
      'Date': date,
    };
  }

  @override
  String toString() {
    return 'CommissionDetail{id: $id, description: $description, amount: $amount, date: $date}';
  }
}

class CommissionDetailGrouped {
  final String date;
  final List<CommissionDetail> commissions;

  CommissionDetailGrouped({
    required this.date,
    required this.commissions,
  });

  factory CommissionDetailGrouped.fromMapEntry(MapEntry<String, List<dynamic>> entry) {
    return CommissionDetailGrouped(
      date: entry.key,
      commissions: entry.value.map((item) => CommissionDetail.fromJson(item)).toList(),
    );
  }

  @override
  String toString() {
    return 'CommissionDetailGrouped{date: $date, commissions: ${commissions.length} items}';
  }
}
