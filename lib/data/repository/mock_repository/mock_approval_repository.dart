import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/approval_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/approval/approval_info.dart';

class MockApprovalRepository implements ApprovalRepository {
  final AuthRepository authRepository;

  MockApprovalRepository({required this.authRepository});

  @override
  Future<ApprovalData> getApprovalDashboard() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data matching your JSON structure
    return ApprovalData(
      staffId: "S168",
      supervisorPending: PendingApprovals(
        count: 0,
        requests: [],
      ),
      managerPending: PendingApprovals(
        count: 1,
        requests: [
          LeaveRequest(
            leaveId: "2",
            staffId: "S001",
            requestBy: "S001",
            leaveType: "annual",
            startDate: "2024-01-15",
            endDate: "2024-01-17",
            totalDays: "3",
            reason: "Family vacation and personal time off",
            supervisorId: "S169",
            managerId: "S168",
            status: "supervisor_approved",
            supervisorComment: "Okay tv tv",
            supervisorActionDate: "2025-08-10 14:07:50",
            managerComment: null,
            managerActionDate: null,
            createdAt: "2025-08-07 16:28:48",
            updatedAt: "2025-08-10 14:07:50",
            firstNameEng: "Buntheuorn",
            lastNameEng: "Admin",
            approvalRole: "manager",
          ),
        ],
      ),
      totalPending: 1,
    );
  }

  @override
  Future<bool> submitApprovalAction(ApprovalAction action) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock the actual request body (without role - role is only for endpoint selection)
    final mockRequestBody = {
      'leave_id': action.leaveId,
      'action': action.action.toString(),
      'comment': action.comment,
    };
    
    // Mock success response
    print('Mock: Using ${action.role} endpoint for leave ${action.leaveId}');
    print('Mock: Request body - $mockRequestBody');
    
    // Simulate different scenarios based on leave ID for testing
    switch (action.leaveId) {
      case 999: // Simulate failure case
        throw Exception('Mock: Leave request not found');
      case 998: // Simulate unauthorized
        throw Exception('Mock: Unauthorized to perform this action');
      default:
        // Simulate success
        return true;
    }
  }
}
