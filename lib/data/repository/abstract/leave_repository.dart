import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';

abstract class LeaveRepository {
  /// Submit leave request
  Future<Map<String, dynamic>> submitLeaveRequest(SubmitLeaveRequest leaveRequest);

  /// Get leave list
  Future<List<LeaveInfo>> getLeaveList();
}