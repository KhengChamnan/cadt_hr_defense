import 'package:palm_ecommerce_mobile_app_2/models/approval/approval_info.dart';

abstract class ApprovalRepository {
  /// Get approval dashboard data
  Future<ApprovalData> getApprovalDashboard();
  
  /// Submit approval action (approve or reject leave request)
  Future<bool> submitApprovalAction(ApprovalAction action);
}
