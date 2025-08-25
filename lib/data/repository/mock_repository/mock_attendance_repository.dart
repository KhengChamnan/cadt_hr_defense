import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/attendance_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dummydata/attendace_data.dart';

class MockAttendanceRepository implements AttendanceRepository {
  final AuthRepository authRepository;
  
  MockAttendanceRepository({required this.authRepository});
  
  @override
  Future<List<Attendance>> getAttendance() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check if the user is authenticated
    final token = await authRepository.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    
    // Return mock attendance data
    return AttendanceData.mockAttendanceList;
  }

  @override
  Future<Map<String, dynamic>> postAttendance(Attendance attendance) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Check if the user is authenticated
    final token = await authRepository.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    
    // Simulate successful attendance post
    return {
      'success': true,
      'message': 'Attendance recorded successfully',
      'data': {
        'attendance_date': attendance.attendanceDate,
        'attendance_time': attendance.attendanceTime,
        'in_out': attendance.inOut,
        'status': 'recorded',
      }
    };
  }
} 