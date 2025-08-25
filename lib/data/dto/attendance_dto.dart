import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';

class AttendanceDto {
  static Attendance fromJson(Map<String, dynamic> json) {
    return Attendance(
      profileId: json['profile_id'],
      profileName: json['profile_name'],
      branchId: json['branch_id'],
      attendanceDate: json['attendance_date'],
      attendanceTime: json['attendance_time'],
      inOut: json['in_out'],
      status: json['status'],
      workTypeId: json['working_type'] != null
          ? int.tryParse(json['working_type'].toString())
          : null,
    );
  }

  static Map<String, dynamic> toJson(Attendance attendance) {
    return {
      'work_type_id': attendance.workTypeId?.toString(),
      'attend_date': attendance.attendanceDate,
      'time': attendance.attendanceTime,
      'in_out': attendance.inOut,
      'latitude': attendance.latitude?.toString(),
      'longtitude': attendance.longitude?.toString(),
      'distant': attendance.distant,
    };
  }

  static List<Attendance> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }
  
  static List<Attendance> parseAttendanceList(Map<String, dynamic> response) {
    final List<dynamic> data = response['data'] as List<dynamic>;
    return fromJsonList(data);
  }
}

