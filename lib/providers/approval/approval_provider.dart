import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/approval_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/approval/approval_info.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

class ApprovalProvider extends ChangeNotifier {
  final ApprovalRepository approvalRepository;

  AsyncValue<ApprovalData>? approvalDashboard;
  AsyncValue<bool>? approvalActionResult;

  ApprovalProvider({required this.approvalRepository});

  Future<void> getApprovalDashboard() async {
    // Check if we have a valid auth token first
    try {
      final approvalRepo = approvalRepository as dynamic;
      if (approvalRepo.authRepository != null) {
        final token = await approvalRepo.authRepository.getToken();
        if (token == null || token.isEmpty) {
          print('❌ ApprovalProvider: No auth token available, skipping approval load');
          approvalDashboard = AsyncValue.error(Exception('Authentication required'));
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('⚠️ ApprovalProvider: Could not check auth token: $e');
    }

    approvalDashboard = AsyncValue.loading();
    notifyListeners();

    try {
      final dashboard = await approvalRepository.getApprovalDashboard();
      approvalDashboard = AsyncValue.success(dashboard);
      print('✅ ApprovalProvider: Approval dashboard loaded successfully');
    } catch (e) {
      print('❌ ApprovalProvider: Failed to load approval dashboard: $e');
      approvalDashboard = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Clear approval dashboard (useful for logout or refresh)
  void clearApprovalDashboard() {
    print('🧹 ApprovalProvider: Clearing approval data...');
    approvalDashboard = null;
    approvalActionResult = null;
    notifyListeners();
    print('✅ ApprovalProvider: Approval data cleared successfully');
  }

  /// Load approval data after successful authentication
  Future<void> loadApprovalAfterAuth() async {
    print('🔄 ApprovalProvider: Loading approval data after auth...');
    
    // Clear any previous error states
    approvalDashboard = null;
    
    // Wait a bit for auth to settle
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Load approval dashboard
    await getApprovalDashboard();
    
    print('✅ ApprovalProvider: Post-auth approval loading completed');
  }

  /// Refresh the approval dashboard
  Future<void> refreshApprovalDashboard() async {
    await getApprovalDashboard();
  }

  /// Get total pending count
  int get totalPendingCount {
    if (approvalDashboard?.data != null) {
      return approvalDashboard!.data!.totalPending;
    }
    return 0;
  }

  /// Get supervisor pending count
  int get supervisorPendingCount {
    if (approvalDashboard?.data != null) {
      return approvalDashboard!.data!.supervisorPending.count;
    }
    return 0;
  }

  /// Get manager pending count
  int get managerPendingCount {
    if (approvalDashboard?.data != null) {
      return approvalDashboard!.data!.managerPending.count;
    }
    return 0;
  }

  /// Get all supervisor pending requests
  List<LeaveRequest> get supervisorPendingRequests {
    if (approvalDashboard?.data != null) {
      return approvalDashboard!.data!.supervisorPending.requests;
    }
    return [];
  }

  /// Get all manager pending requests
  List<LeaveRequest> get managerPendingRequests {
    if (approvalDashboard?.data != null) {
      return approvalDashboard!.data!.managerPending.requests;
    }
    return [];
  }

  /// Check if there are any pending approvals
  bool get hasPendingApprovals {
    return totalPendingCount > 0;
  }

  /// Check if loading
  bool get isLoading {
    return approvalDashboard?.state == AsyncValueState.loading;
  }

  /// Check if has error
  bool get hasError {
    return approvalDashboard?.state == AsyncValueState.error;
  }

  /// Get error message
  String? get errorMessage {
    if (hasError && approvalDashboard?.error != null) {
      return approvalDashboard!.error.toString();
    }
    return null;
  }

  /// Check if has data
  bool get hasData {
    return approvalDashboard?.state == AsyncValueState.success && 
           approvalDashboard?.data != null;
  }

  // APPROVAL ACTION METHODS

  /// Submit an approval action (approve or reject)
  Future<bool> submitApprovalAction(ApprovalAction action) async {
    approvalActionResult = AsyncValue.loading();
    notifyListeners();

    try {
      final success = await approvalRepository.submitApprovalAction(action);
      approvalActionResult = AsyncValue.success(success);
      
      // Refresh dashboard if action was successful
      if (success) {
        await refreshApprovalDashboard();
      }
      
      notifyListeners();
      return success;
    } catch (e) {
      approvalActionResult = AsyncValue.error(e);
      notifyListeners();
      rethrow;
    }
  }

  /// Approve a leave request
  Future<bool> approveLeave({
    required int leaveId,
    required String comment,
    required ApprovalRole role,
  }) async {
    final action = ApprovalAction(
      leaveId: leaveId,
      action: ApprovalActionType.approve,
      comment: comment,
      role: role,
    );
    
    return await submitApprovalAction(action);
  }

  /// Reject a leave request
  Future<bool> rejectLeave({
    required int leaveId,
    required String comment,
    required ApprovalRole role,
  }) async {
    final action = ApprovalAction(
      leaveId: leaveId,
      action: ApprovalActionType.reject,
      comment: comment,
      role: role,
    );
    
    return await submitApprovalAction(action);
  }

  /// Clear approval action result (useful after showing success/error message)
  void clearApprovalActionResult() {
    approvalActionResult = null;
    notifyListeners();
  }

  // APPROVAL ACTION STATE GETTERS

  /// Check if approval action is loading
  bool get isSubmittingAction {
    return approvalActionResult?.state == AsyncValueState.loading;
  }

  /// Check if approval action has error
  bool get hasActionError {
    return approvalActionResult?.state == AsyncValueState.error;
  }

  /// Get approval action error message
  String? get actionErrorMessage {
    if (hasActionError && approvalActionResult?.error != null) {
      return approvalActionResult!.error.toString();
    }
    return null;
  }

  /// Check if approval action was successful
  bool get hasActionSuccess {
    return approvalActionResult?.state == AsyncValueState.success && 
           approvalActionResult?.data == true;
  }

  /// Get the result of the last approval action
  bool? get lastActionResult {
    if (approvalActionResult?.state == AsyncValueState.success) {
      return approvalActionResult?.data;
    }
    return null;
  }
}
