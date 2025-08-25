import 'package:flutter/material.dart';

/// This model represents a withdrawal request in the payroll system.
/// It contains all necessary information for processing withdrawal requests
/// including account details, request information, and status tracking.
class WithdrawalModel {
  final String? id;
  final String accountName;
  final String accountNo;
  final double currentBalance;
  final double requestAmount;
  final String? remark;
  final WithdrawalStatus status;
  final DateTime? requestDate;
  final DateTime? processedDate;
  final bool isWithdrawalAllowed;

  const WithdrawalModel({
    this.id,
    required this.accountName,
    required this.accountNo,
    required this.currentBalance,
    required this.requestAmount,
    this.remark,
    this.status = WithdrawalStatus.pending,
    this.requestDate,
    this.processedDate,
    this.isWithdrawalAllowed = true,
  });

  /// Creates a copy of this withdrawal model with the given fields replaced with new values.
  WithdrawalModel copyWith({
    String? id,
    String? accountName,
    String? accountNo,
    double? currentBalance,
    double? requestAmount,
    String? remark,
    WithdrawalStatus? status,
    DateTime? requestDate,
    DateTime? processedDate,
    bool? isWithdrawalAllowed,
  }) {
    return WithdrawalModel(
      id: id ?? this.id,
      accountName: accountName ?? this.accountName,
      accountNo: accountNo ?? this.accountNo,
      currentBalance: currentBalance ?? this.currentBalance,
      requestAmount: requestAmount ?? this.requestAmount,
      remark: remark ?? this.remark,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      processedDate: processedDate ?? this.processedDate,
      isWithdrawalAllowed: isWithdrawalAllowed ?? this.isWithdrawalAllowed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WithdrawalModel &&
        other.id == id &&
        other.accountName == accountName &&
        other.accountNo == accountNo &&
        other.currentBalance == currentBalance &&
        other.requestAmount == requestAmount &&
        other.remark == remark &&
        other.status == status &&
        other.requestDate == requestDate &&
        other.processedDate == processedDate &&
        other.isWithdrawalAllowed == isWithdrawalAllowed;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      accountName,
      accountNo,
      currentBalance,
      requestAmount,
      remark,
      status,
      requestDate,
      processedDate,
      isWithdrawalAllowed,
    );
  }

  @override
  String toString() {
    return 'WithdrawalModel(id: $id, accountName: $accountName, accountNo: $accountNo, currentBalance: $currentBalance, requestAmount: $requestAmount, remark: $remark, status: $status, requestDate: $requestDate, processedDate: $processedDate, isWithdrawalAllowed: $isWithdrawalAllowed)';
  }

  /// Converts the model to a JSON map for API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_name': accountName,
      'account_no': accountNo,
      'current_balance': currentBalance,
      'request_amount': requestAmount,
      'remark': remark,
      'status': status.name,
      'request_date': requestDate?.toIso8601String(),
      'processed_date': processedDate?.toIso8601String(),
      'is_withdrawal_allowed': isWithdrawalAllowed,
    };
  }

  /// Creates a model from a JSON map received from API responses.
  factory WithdrawalModel.fromJson(Map<String, dynamic> json) {
    return WithdrawalModel(
      id: json['id'],
      accountName: json['account_name'] ?? '',
      accountNo: json['account_no'] ?? '',
      currentBalance: (json['current_balance'] is String) 
          ? double.tryParse(json['current_balance']) ?? 0.0
          : (json['current_balance'] ?? 0.0).toDouble(),
      requestAmount: (json['request_amount'] is String)
          ? double.tryParse(json['request_amount']) ?? 0.0
          : (json['request_amount'] ?? 0.0).toDouble(),
      remark: json['remark'],
      status: WithdrawalStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => WithdrawalStatus.pending,
      ),
      requestDate: json['request_date'] != null 
          ? DateTime.tryParse(json['request_date'])
          : null,
      processedDate: json['processed_date'] != null
          ? DateTime.tryParse(json['processed_date'])
          : null,
      isWithdrawalAllowed: json['is_withdrawal_allowed'] ?? true,
    );
  }
}

/// Represents the status of a withdrawal request.
enum WithdrawalStatus {
  pending,
  approved,
  rejected,
  processing,
  completed,
}

/// Extension to provide display names for withdrawal statuses.
extension WithdrawalStatusExtension on WithdrawalStatus {
  String get displayName {
    switch (this) {
      case WithdrawalStatus.pending:
        return 'Pending';
      case WithdrawalStatus.approved:
        return 'Approved';
      case WithdrawalStatus.rejected:
        return 'Rejected';
      case WithdrawalStatus.processing:
        return 'Processing';
      case WithdrawalStatus.completed:
        return 'Completed';
    }
  }

  /// Returns appropriate color for the status display.
  Color get statusColor {
    switch (this) {
      case WithdrawalStatus.pending:
        return const Color(0xFFED8936); // Warning color
      case WithdrawalStatus.approved:
        return const Color(0xFF38A169); // Success color
      case WithdrawalStatus.rejected:
        return const Color(0xFFE53E3E); // Danger color
      case WithdrawalStatus.processing:
        return const Color(0xFF4299E1); // Secondary color
      case WithdrawalStatus.completed:
        return const Color(0xFF38A169); // Success color
    }
  }
}
