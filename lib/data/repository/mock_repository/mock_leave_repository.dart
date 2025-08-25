import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/leave_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';

class MockLeaveRepository implements LeaveRepository {
  final AuthRepository authRepository;
  
  MockLeaveRepository({required this.authRepository});
  
  @override
  Future<List<LeaveInfo>> getLeaveList() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check if the user is authenticated
    final token = await authRepository.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    
    // Return mock leave data
    return [
      LeaveInfo(
        leaveId: 'LV001',
        staffId: 'S001',
        leaveType: LeaveType.annual,
        startDate: '2024-08-15',
        endDate: '2024-08-18',
        reason: 'Family vacation',
        totalDays: '4',
        status: 'approved',
        supervisorId: 'S200',
        managerId: 'S100',
        supervisorName: 'Supervisor Johnson',
        managerName: 'Manager Smith',
        createdAt: '2024-08-01 10:00:00',
        updatedAt: '2024-08-02 14:30:00',
      ),
      LeaveInfo(
        leaveId: 'LV002',
        staffId: 'S001',
        leaveType: LeaveType.sick,
        startDate: '2024-07-20',
        endDate: '2024-07-21',
        reason: 'Medical checkup',
        totalDays: '2',
        status: 'pending',
        supervisorId: 'S200',
        managerId: 'S100',
        supervisorName: 'Supervisor Johnson',
        managerName: 'Manager Smith',
        createdAt: '2024-07-19 09:15:00',
        updatedAt: '2024-07-19 09:15:00',
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> submitLeaveRequest(SubmitLeaveRequest leaveRequest) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Check if the user is authenticated
    final token = await authRepository.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    
    // Simulate successful leave submission
    return {
      'message': 'Leave request submitted successfully',
      'data': {
        'leave_id': 'LV${DateTime.now().millisecondsSinceEpoch}',
        'status': 'pending',
        'leave_type': leaveRequest.leaveType?.value,
        'start_date': leaveRequest.startDate,
        'end_date': leaveRequest.endDate,
        'total_days': leaveRequest.calculateTotalDays().toString(),
        'reason': leaveRequest.reason,
      }
    };
  }
}
