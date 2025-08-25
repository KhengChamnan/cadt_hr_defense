import 'package:palm_ecommerce_mobile_app_2/services/holiday_service.dart';

// Enum for leave types
enum LeaveType {
  annual('annual'),
  sick('sick'),
  special('special');

  const LeaveType(this.value);
  final String value;

  static LeaveType fromString(String value) {
    return LeaveType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => LeaveType.annual,
    );
  }
}

class LeaveInfo {
  final String? leaveId;
  final String? staffId;
  final LeaveType? leaveType;
  final String? startDate;
  final String? endDate;
  final String? reason;
  final String? totalDays;
  final String? status;
  final String? supervisorId;
  final String? managerId;
  final String? createdAt;
  final String? updatedAt;
  final String? supervisorName;
  final String? managerName;
  final String? supervisorComment;
  final String? supervisorActionDate;
  final String? managerComment;
  final String? managerActionDate;

  LeaveInfo({
    this.leaveId,
    this.staffId,
    this.leaveType,
    this.startDate,
    this.endDate,
    this.reason,
    this.totalDays,
    this.status,
    this.supervisorId,
    this.managerId,
    this.createdAt,
    this.updatedAt,
    this.supervisorName,
    this.managerName,
    this.supervisorComment,
    this.supervisorActionDate,
    this.managerComment,
    this.managerActionDate,
  });

  
  

  // Helper method to get status color
  String getStatusColor() {
    switch (status?.toLowerCase()) {
      case 'approved':
        return '#4CAF50'; // Green
      case 'pending':
        return '#FF9800'; // Orange
      case 'rejected':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // Helper method to check if leave is editable
  bool get isEditable => status?.toLowerCase() == 'pending';

  // Helper method to format date range
  String get dateRange => '${startDate ?? ''} to ${endDate ?? ''}';
}

// Model for submitting leave request
class SubmitLeaveRequest {
  final LeaveType? leaveType;
  final String? startDate;
  final String? endDate;
  final String? reason;

  SubmitLeaveRequest({
    this.leaveType,
    this.startDate,
    this.endDate,
    this.reason,
  });

  

  // Helper method to calculate total days
  int calculateTotalDays() {
    try {
      if (startDate == null || endDate == null) return 0;
      final start = DateTime.parse(startDate!);
      final end = DateTime.parse(endDate!);
      return end.difference(start).inDays + 1;
    } catch (e) {
      return 0;
    }
  }

  // Helper method to calculate working days (excluding holidays)
  int calculateWorkingDays() {
    try {
      if (startDate == null || endDate == null) return 0;
      final start = DateTime.parse(startDate!);
      final end = DateTime.parse(endDate!);
      return HolidayService.calculateWorkingDays(start, end);
    } catch (e) {
      return 0;
    }
  }

  // Helper method to get holiday analysis
  HolidayAnalysis getHolidayAnalysis() {
    try {
      if (startDate == null || endDate == null) {
        return HolidayAnalysis(
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          totalDays: 0,
          workingDays: 0,
          holidayDays: 0,
          holidays: [],
          hasHolidays: false,
        );
      }
      final start = DateTime.parse(startDate!);
      final end = DateTime.parse(endDate!);
      return HolidayService.analyzeRange(start, end);
    } catch (e) {
      return HolidayAnalysis(
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        totalDays: 0,
        workingDays: 0,
        holidayDays: 0,
        holidays: [],
        hasHolidays: false,
      );
    }
  }
}

// Enum for leave status
enum LeaveStatus {
  pending('pending'),
  supervisorApproved('supervisor_approved'),
  approved('approved'),
  supervisorRejected('supervisor_rejected'),
  rejected('rejected');

  const LeaveStatus(this.value);
  final String value;

  static LeaveStatus fromString(String value) {
    return LeaveStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LeaveStatus.pending,
    );
  }
}
