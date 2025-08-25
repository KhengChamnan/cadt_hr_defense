import 'dart:convert';

import 'package:palm_ecommerce_mobile_app_2/data/Network/api_constant.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_endpoints.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dto/staff_dto.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/staff_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/staff/staff_info.dart';

class LaravelStaffRepository implements StaffRepository {
  final AuthRepository authRepository;
  LaravelStaffRepository({required this.authRepository});

  @override
  Future<StaffInfo> getStaffInfo() async {
    final response =
        await FetchingData.getAttendanceData(ApiEndpoints.userInfo, {
      "Accept": "application/json",
      "Authorization": "Bearer ${await authRepository.getToken()}"
    });
    
    if (response.statusCode == 200) {
      return StaffDto.parseStaffResponse(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get staff info");
    }
  }
}
