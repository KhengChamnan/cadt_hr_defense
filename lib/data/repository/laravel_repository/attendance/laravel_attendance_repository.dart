import 'dart:convert';

import 'package:palm_ecommerce_mobile_app_2/data/Network/api_constant.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_endpoints.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dto/attendance_dto.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/attendance_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';

class LaravelAttendanceRepository implements AttendanceRepository {
  final AuthRepository authRepository;
  LaravelAttendanceRepository({required this.authRepository});
  @override
  Future<List<Attendance>> getAttendance() async {
    final response =
        await FetchingData.getAttendanceData(ApiEndpoints.getAttendance, {
      "Accept": "application/json",
      "Authorization": "Bearer ${await authRepository.getToken()}"
    });
    if (response.statusCode == 200) {
      return AttendanceDto.parseAttendanceList(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get attendance");
    }
  }

  @override
  Future<Map<String, dynamic>> postAttendance(Attendance attendance) async {
    final response = await FetchingData.postAttendanceData(
      ApiEndpoints.postAttendance,
      {
        "Accept": "application/json",
        "Authorization": "Bearer ${await authRepository.getToken()}"
      },
      AttendanceDto.toJson(attendance),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Success response - return the data
      return responseData;
    } else {
      // Error response (404 or others) - return the error data
      return responseData;
    }
  }
}
