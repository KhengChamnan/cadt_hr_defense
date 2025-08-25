import 'package:palm_ecommerce_mobile_app_2/models/approval/approval_info.dart';

class ApprovalDto {
  static ApprovalData fromJson(Map<String, dynamic> json) {
    return ApprovalData(
      staffId: json['staff_id'] ?? '',
      supervisorPending: PendingApprovalsDto.fromJson(json['supervisor_pending'] ?? {}),
      managerPending: PendingApprovalsDto.fromJson(json['manager_pending'] ?? {}),
      totalPending: json['total_pending'] ?? 0,
    );
  }

  static Map<String, dynamic> toJson(ApprovalData data) {
    return {
      'staff_id': data.staffId,
      'supervisor_pending': PendingApprovalsDto.toJson(data.supervisorPending),
      'manager_pending': PendingApprovalsDto.toJson(data.managerPending),
      'total_pending': data.totalPending,
    };
  }

  static List<ApprovalData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static ApprovalData parseApprovalData(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>;
    return fromJson(data);
  }
}

class PendingApprovalsDto {
  static PendingApprovals fromJson(Map<String, dynamic> json) {
    return PendingApprovals(
      count: json['count'] ?? 0,
      requests: LeaveRequestDto.fromJsonList(json['requests'] ?? []),
    );
  }

  static Map<String, dynamic> toJson(PendingApprovals pending) {
    return {
      'count': pending.count,
      'requests': LeaveRequestDto.toJsonList(pending.requests),
    };
  }
}

class LeaveRequestDto {
  static LeaveRequest fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      leaveId: json['leave_id'] ?? '',
      staffId: json['staff_id'] ?? '',
      requestBy: json['request_by'] ?? '',
      leaveType: json['leave_type'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      totalDays: json['total_days'] ?? '',
      reason: json['reason'] ?? '',
      supervisorId: json['supervisor_id'] ?? '',
      managerId: json['manager_id'] ?? '',
      status: json['status'] ?? '',
      supervisorComment: json['supervisor_comment'],
      supervisorActionDate: json['supervisor_action_date'],
      managerComment: json['manager_comment'],
      managerActionDate: json['manager_action_date'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      firstNameEng: json['FirstNameEng'] ?? '',
      lastNameEng: json['LastNameEng'] ?? '',
      approvalRole: json['approval_role'] ?? '',
    );
  }

  static Map<String, dynamic> toJson(LeaveRequest request) {
    return {
      'leave_id': request.leaveId,
      'staff_id': request.staffId,
      'request_by': request.requestBy,
      'leave_type': request.leaveType,
      'start_date': request.startDate,
      'end_date': request.endDate,
      'total_days': request.totalDays,
      'reason': request.reason,
      'supervisor_id': request.supervisorId,
      'manager_id': request.managerId,
      'status': request.status,
      'supervisor_comment': request.supervisorComment,
      'supervisor_action_date': request.supervisorActionDate,
      'manager_comment': request.managerComment,
      'manager_action_date': request.managerActionDate,
      'created_at': request.createdAt,
      'updated_at': request.updatedAt,
      'FirstNameEng': request.firstNameEng,
      'LastNameEng': request.lastNameEng,
      'approval_role': request.approvalRole,
    };
  }

  static List<LeaveRequest> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<LeaveRequest> requests) {
    return requests.map((request) => toJson(request)).toList();
  }
}

class ApprovalActionDto {
  /// Convert JSON to ApprovalAction model
  /// Note: Role is included when receiving data from API responses
  static ApprovalAction fromJson(Map<String, dynamic> json) {
    return ApprovalAction(
      leaveId: json['leave_id'] ?? 0,
      action: ApprovalActionType.fromString(json['action'] ?? 'approve'),
      comment: json['comment'] ?? '',
      role: ApprovalRole.fromString(json['role'] ?? 'supervisor'),
    );
  }

  /// Convert ApprovalAction to JSON for API requests
  /// Note: Role is NOT included in request body - it's only used for endpoint selection
  /// This method should generally not be used - use direct JSON creation in repository instead
  @deprecated
  static Map<String, dynamic> toJson(ApprovalAction action) {
    return {
      'leave_id': action.leaveId,
      'action': action.action.toString(),
      'comment': action.comment,
      // 'role' is intentionally excluded from API requests
    };
  }

  static List<ApprovalAction> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<ApprovalAction> actions) {
    return actions.map((action) => toJson(action)).toList();
  }
}