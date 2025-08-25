import 'dart:convert';

import 'package:palm_ecommerce_mobile_app_2/data/Network/api_constant.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_endpoints.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dto/leave_dto.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/leave_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';

class LaravelLeaveRepository implements LeaveRepository {
  final AuthRepository authRepository;

  LaravelLeaveRepository({required this.authRepository});

  @override
  Future<List<LeaveInfo>> getLeaveList() async {
    try {
      final response = await FetchingData.getLeaveData(
        ApiEndpoints.getLeaves,
        {
          "Accept": "application/json",
          "Authorization": "Bearer ${await authRepository.getToken()}"
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return LeaveDto.parseLeaveList(responseBody);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            "Failed to get leave list: ${errorBody['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      // Re-throw with more context
      throw Exception("Error fetching leave list: $e");
    }
  }

  @override
  Future<Map<String, dynamic>> submitLeaveRequest(
      SubmitLeaveRequest leaveRequest) async {
    final response = await FetchingData.postLeave(
      ApiEndpoints.leaves,
      {
        "Accept": "application/json",
        "Authorization": "Bearer ${await authRepository.getToken()}"
      },
      LeaveDto.toJson(leaveRequest),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Success response - return the data
      return {
        "message":
            responseData['message'] ?? 'Leave request submitted successfully'
      };
    } else {
      // Error response (404 or others) - return the error data
      return {
        "error": responseData['message'] ?? 'Failed to submit leave request'
      };
    }
  }
}
