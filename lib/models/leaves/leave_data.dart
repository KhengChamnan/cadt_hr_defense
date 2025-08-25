import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';
import 'package:palm_ecommerce_mobile_app_2/models/staff/staff_info.dart';

/// Data class for representing leave chart data
class LeaveData {
  final String category;
  final double value;
  final Color color;
  final double? actualBalance; // Store the real balance value for display

  LeaveData({
    required this.category,
    required this.value,
    required this.color,
    this.actualBalance,
  });

  /// Generate chart data from staff info (leave balances)
  static List<LeaveData> generateChartDataFromStaff(StaffInfo? staffInfo) {
    if (staffInfo == null) {
      return _getDefaultChartData();
    }

    List<LeaveData> chartData = [];

    // Annual Leave - convert hours to days (assuming 8 hours = 1 day)
    final annualBalanceHours =
        double.tryParse(staffInfo.balanceAnnually ?? '0') ?? 0;
    final annualBalanceDays = annualBalanceHours / 8.0;

    // Sick Leave - convert hours to days (assuming 8 hours = 1 day)
    final sickBalanceHours = double.tryParse(staffInfo.balanceSick ?? '0') ?? 0;
    final sickBalanceDays = sickBalanceHours / 8.0;

    // Special Leave - convert hours to days (assuming 8 hours = 1 day)
    final specialBalanceHours =
        double.tryParse(staffInfo.balanceSpecial ?? '0') ?? 0;
    final specialBalanceDays = specialBalanceHours / 8.0;

    // Always add all leave types to show complete balance overview
    chartData.add(LeaveData(
      category: 'Annual',
      value: annualBalanceDays > 0
          ? annualBalanceDays
          : 0.1, // Minimum value for chart visibility
      actualBalance: annualBalanceDays, // Store real balance for display
      color: const Color(0xFF4285F4),
    ));

    chartData.add(LeaveData(
      category: 'Sick',
      value: sickBalanceDays > 0
          ? sickBalanceDays
          : 0.1, // Minimum value for chart visibility
      actualBalance: sickBalanceDays, // Store real balance for display
      color: const Color(0xFFEA4335),
    ));

    chartData.add(LeaveData(
      category: 'Special',
      value: specialBalanceDays > 0
          ? specialBalanceDays
          : 0.1, // Minimum value for chart visibility
      actualBalance: specialBalanceDays, // Store real balance for display
      color: const Color(0xFF34A853),
    ));

    return chartData;
  }

  /// Generate chart data from leave history (shows used leave days by type)
  static List<LeaveData> generateChartDataFromLeaves(List<LeaveInfo> leaves) {
    if (leaves.isEmpty) {
      return _getDefaultChartData();
    }

    Map<String, double> leaveTotals = {
      'Annual': 0,
      'Sick': 0,
      'Special': 0,
    };

    // Count used leave days by type
    for (final leave in leaves) {
      if (leave.leaveType != null && leave.totalDays != null) {
        final days = double.tryParse(leave.totalDays!) ?? 0;
        switch (leave.leaveType!) {
          case LeaveType.annual:
            leaveTotals['Annual'] = (leaveTotals['Annual'] ?? 0) + days;
            break;
          case LeaveType.sick:
            leaveTotals['Sick'] = (leaveTotals['Sick'] ?? 0) + days;
            break;
          case LeaveType.special:
            leaveTotals['Special'] = (leaveTotals['Special'] ?? 0) + days;
            break;
        }
      }
    }

    List<LeaveData> chartData = [];

    // Add only categories with actual data
    if (leaveTotals['Annual']! > 0) {
      chartData.add(LeaveData(
        category: 'Annual',
        value: leaveTotals['Annual']!,
        color: const Color(0xFF4285F4),
      ));
    }

    if (leaveTotals['Sick']! > 0) {
      chartData.add(LeaveData(
        category: 'Sick',
        value: leaveTotals['Sick']!,
        color: const Color(0xFFEA4335),
      ));
    }

    if (leaveTotals['Special']! > 0) {
      chartData.add(LeaveData(
        category: 'Special',
        value: leaveTotals['Special']!,
        color: const Color(0xFF34A853),
      ));
    }

    return chartData.isEmpty ? _getDefaultChartData() : chartData;
  }

  /// Default chart data when no actual data is available
  static List<LeaveData> _getDefaultChartData() {
    return [
      LeaveData(
          category: 'Annual',
          value: 1,
          actualBalance: 0,
          color: const Color(0xFF4285F4)),
      LeaveData(
          category: 'Sick',
          value: 1,
          actualBalance: 0,
          color: const Color(0xFFEA4335)),
      LeaveData(
          category: 'Special',
          value: 1,
          actualBalance: 0,
          color: const Color(0xFF34A853)),
    ];
  }
}
