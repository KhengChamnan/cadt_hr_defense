import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendance();
  Future<Map<String, dynamic>> postAttendance(Attendance attendance);
}

