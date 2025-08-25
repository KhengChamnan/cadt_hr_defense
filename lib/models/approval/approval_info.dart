class ApprovalData {
  final String staffId;
  final PendingApprovals supervisorPending;
  final PendingApprovals managerPending;
  final int totalPending;

  ApprovalData({
    required this.staffId,
    required this.supervisorPending,
    required this.managerPending,
    required this.totalPending,
  });

  @override
  String toString() {
    return 'ApprovalData{staffId: $staffId, supervisorPending: $supervisorPending, managerPending: $managerPending, totalPending: $totalPending}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApprovalData &&
        other.staffId == staffId &&
        other.supervisorPending == supervisorPending &&
        other.managerPending == managerPending &&
        other.totalPending == totalPending;
  }

  @override
  int get hashCode {
    return staffId.hashCode ^
        supervisorPending.hashCode ^
        managerPending.hashCode ^
        totalPending.hashCode;
  }
}

class PendingApprovals {
  final int count;
  final List<LeaveRequest> requests;

  PendingApprovals({
    required this.count,
    required this.requests,
  });

  @override
  String toString() {
    return 'PendingApprovals{count: $count, requests: $requests}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PendingApprovals &&
        other.count == count &&
        _listEquals(other.requests, requests);
  }

  @override
  int get hashCode {
    return count.hashCode ^ requests.hashCode;
  }
}

class LeaveRequest {
  final String leaveId;
  final String staffId;
  final String requestBy;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String totalDays;
  final String reason;
  final String supervisorId;
  final String managerId;
  final String status;
  final String? supervisorComment;
  final String? supervisorActionDate;
  final String? managerComment;
  final String? managerActionDate;
  final String createdAt;
  final String updatedAt;
  final String firstNameEng;
  final String lastNameEng;
  final String approvalRole;

  LeaveRequest({
    required this.leaveId,
    required this.staffId,
    required this.requestBy,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.supervisorId,
    required this.managerId,
    required this.status,
    this.supervisorComment,
    this.supervisorActionDate,
    this.managerComment,
    this.managerActionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.firstNameEng,
    required this.lastNameEng,
    required this.approvalRole,
  });

  @override
  String toString() {
    return 'LeaveRequest{leaveId: $leaveId, staffId: $staffId, requestBy: $requestBy, leaveType: $leaveType, startDate: $startDate, endDate: $endDate, totalDays: $totalDays, reason: $reason, supervisorId: $supervisorId, managerId: $managerId, status: $status, supervisorComment: $supervisorComment, supervisorActionDate: $supervisorActionDate, managerComment: $managerComment, managerActionDate: $managerActionDate, createdAt: $createdAt, updatedAt: $updatedAt, firstNameEng: $firstNameEng, lastNameEng: $lastNameEng, approvalRole: $approvalRole}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LeaveRequest &&
        other.leaveId == leaveId &&
        other.staffId == staffId &&
        other.requestBy == requestBy &&
        other.leaveType == leaveType &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.totalDays == totalDays &&
        other.reason == reason &&
        other.supervisorId == supervisorId &&
        other.managerId == managerId &&
        other.status == status &&
        other.supervisorComment == supervisorComment &&
        other.supervisorActionDate == supervisorActionDate &&
        other.managerComment == managerComment &&
        other.managerActionDate == managerActionDate &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.firstNameEng == firstNameEng &&
        other.lastNameEng == lastNameEng &&
        other.approvalRole == approvalRole;
  }

  @override
  int get hashCode {
    return leaveId.hashCode ^
        staffId.hashCode ^
        requestBy.hashCode ^
        leaveType.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        totalDays.hashCode ^
        reason.hashCode ^
        supervisorId.hashCode ^
        managerId.hashCode ^
        status.hashCode ^
        supervisorComment.hashCode ^
        supervisorActionDate.hashCode ^
        managerComment.hashCode ^
        managerActionDate.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        firstNameEng.hashCode ^
        lastNameEng.hashCode ^
        approvalRole.hashCode;
  }
}

enum ApprovalActionType {
  approve,
  reject;

  @override
  String toString() {
    switch (this) {
      case ApprovalActionType.approve:
        return 'approve';
      case ApprovalActionType.reject:
        return 'reject';
    }
  }

  static ApprovalActionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'approve':
        return ApprovalActionType.approve;
      case 'reject':
        return ApprovalActionType.reject;
      default:
        throw ArgumentError('Invalid approval action type: $value');
    }
  }
}

enum ApprovalRole {
  supervisor,
  manager;

  @override
  String toString() {
    switch (this) {
      case ApprovalRole.supervisor:
        return 'supervisor';
      case ApprovalRole.manager:
        return 'manager';
    }
  }

  static ApprovalRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'supervisor':
        return ApprovalRole.supervisor;
      case 'manager':
        return ApprovalRole.manager;
      default:
        throw ArgumentError('Invalid approval role: $value');
    }
  }
}

class ApprovalAction {
  final int leaveId;
  final ApprovalActionType action;
  final String comment;
  final ApprovalRole role;

  ApprovalAction({
    required this.leaveId,
    required this.action,
    required this.comment,
    required this.role,
  });

  @override
  String toString() {
    return 'ApprovalAction{leaveId: $leaveId, action: $action, comment: $comment, role: $role}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApprovalAction &&
        other.leaveId == leaveId &&
        other.action == action &&
        other.comment == comment &&
        other.role == role;
  }

  @override
  int get hashCode {
    return leaveId.hashCode ^ action.hashCode ^ comment.hashCode ^ role.hashCode;
  }
}

// Helper function for list equality comparison
bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
