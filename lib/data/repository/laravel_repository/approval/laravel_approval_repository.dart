import 'dart:convert';

import 'package:palm_ecommerce_mobile_app_2/data/Network/api_constant.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_endpoints.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dto/approval_dto.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/approval_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/approval/approval_info.dart';

class LaravelApprovalRepository implements ApprovalRepository {
  final AuthRepository authRepository;

  LaravelApprovalRepository({required this.authRepository});

  @override
  Future<ApprovalData> getApprovalDashboard() async {
    try {
      final response = await FetchingData.getApprovalData(
        ApiEndpoints.getApproval,
        {
          "Accept": "application/json",
          "Authorization": "Bearer ${await authRepository.getToken()}"
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        return ApprovalDto.parseApprovalData(responseBody);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            "Failed to get approval dashboard: ${errorBody['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      // Re-throw with more context
      throw Exception("Error fetching approval dashboard: $e");
    }
  }

  @override
  Future<bool> submitApprovalAction(ApprovalAction action) async {
    try {
      // Create request body without the role field
      // Role is only used to determine endpoint, not sent to API
      final requestBody = {
        'leave_id': action.leaveId,
        'action': action.action.toString(),
        'comment': action.comment,
      };
      
      // Determine which endpoint to use based on the approval role
      String endpoint;
      switch (action.role) {
        case ApprovalRole.supervisor:
          endpoint = ApiEndpoints.supervisorApproval;
          break;
        case ApprovalRole.manager:
          endpoint = ApiEndpoints.managerApproval;
          break;
      }
      
      final response = await FetchingData.postApprovalAction(
        endpoint,
        {
          "Accept": "application/json",
          "Authorization": "Bearer ${await authRepository.getToken()}"
        },
        requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        // Assuming the API returns a success field or similar
        return responseBody['success'] == true || responseBody['message'] != null;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            "Failed to submit ${action.role} approval action: ${errorBody['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      // Re-throw with more context
      throw Exception("Error submitting ${action.role} approval action: $e");
    }
  }
}
