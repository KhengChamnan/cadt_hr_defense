import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';

class LeaveDto {
  static LeaveInfo fromJson(Map<String, dynamic> json) {
    return LeaveInfo(
      leaveId: json['leave_id']?.toString().trim(),
      staffId: json['staff_id']?.toString().trim(),
      leaveType: json['leave_type'] != null
          ? LeaveType.fromString(json['leave_type'].toString().trim())
          : null,
      startDate: json['start_date']?.toString().trim(),
      endDate: json['end_date']?.toString().trim(),
      reason: json['reason']?.toString().trim(),
      totalDays: json['total_days']?.toString().trim(),
      status: json['status']?.toString().trim(),
      supervisorId: json['supervisor_id']?.toString().trim(),
      managerId: json['manager_id']?.toString().trim(),
      createdAt: json['created_at']?.toString().trim(),
      updatedAt: json['updated_at']?.toString().trim(),
      supervisorName: json['supervisor_name']?.toString().trim(),
      managerName: json['manager_name']?.toString().trim(),
      supervisorComment: json['supervisor_comment']?.toString().trim(),
      supervisorActionDate: json['supervisor_action_date']?.toString().trim(),
      managerComment: json['manager_comment']?.toString().trim(),
      managerActionDate: json['manager_action_date']?.toString().trim(),
    );
  }

  static Map<String, dynamic> toJson(SubmitLeaveRequest leaveRequest) {
    return {
      'leave_type': leaveRequest.leaveType?.value,
      'start_date': leaveRequest.startDate,
      'end_date': leaveRequest.endDate,
      'reason': leaveRequest.reason,
      'total_days': leaveRequest.calculateTotalDays().toString(),
    };
  }

  static List<LeaveInfo> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .where((json) => json != null && json is Map<String, dynamic>)
        .map((json) => fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<LeaveInfo> parseLeaveList(Map<String, dynamic> response) {
    try {
      // Handle the nested structure where leave_requests is inside data object
      if (response['data'] is Map<String, dynamic>) {
        final dataMap = response['data'] as Map<String, dynamic>;
        if (dataMap.containsKey('leave_requests') &&
            dataMap['leave_requests'] is List) {
          final List<dynamic> leaveRequests =
              dataMap['leave_requests'] as List<dynamic>;
          return fromJsonList(leaveRequests);
        } else {
          throw Exception(
              'Response data object does not contain leave_requests array');
        }
      } else if (response['data'] is List<dynamic>) {
        // Fallback: if data is directly a list (for backward compatibility)
        final List<dynamic> data = response['data'] as List<dynamic>;
        return fromJsonList(data);
      } else {
        throw Exception(
            'Invalid response format: expected data to contain leave_requests array');
      }
    } catch (e) {
      throw Exception('Error parsing leave list: $e');
    }
  }
}
