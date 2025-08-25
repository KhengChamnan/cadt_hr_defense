import 'package:palm_ecommerce_mobile_app_2/data/Network/api_constant.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_endpoints.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dto/user_dto.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/profile_repository.dart';
import 'dart:convert';

import 'package:palm_ecommerce_mobile_app_2/models/profile/profile.dart';

class LaravelProfileRepository implements ProfileRepository {
  final AuthRepository authRepository;

  LaravelProfileRepository({required this.authRepository});

  @override
  Future<ProfileInfo> getUserInfo() async {
    try {
      String? userToken = await authRepository.getToken();
      if (userToken == null || userToken.isEmpty) {
        throw Exception("Invalid or missing authentication token");
      }
      
      final response = await FetchingData.getHeader(ApiEndpoints.userInfo,
          {"Accept": "application/json", "Authorization": "Bearer $userToken"});
      
      // Parse the response body to JSON
      final Map<String, dynamic> jsonData = json.decode(response.body);
      
      // First convert JSON to UserInfo
      final userInfo = UserDto.fromApiResponse(jsonData);
      
      // Then convert UserInfo to ProfileInfo
      return UserDto.getUserProfileData(userInfo);
    } catch (e) {
      // You can customize error handling based on your app's needs
      throw Exception("Failed to get user profile: ${e.toString()}");
    }
  }

  @override
  Future<ProfileInfo> getFullUserInfo() async {
    print("🔍 LaravelProfileRepository: getFullUserInfo() called");
    
    try {
      String? userToken = await authRepository.getToken();
      if (userToken == null || userToken.isEmpty) {
        print("🔍 LaravelProfileRepository: No valid token found");
        throw Exception("Invalid or missing authentication token");
      }
      
      print("🔍 LaravelProfileRepository: Making API call to userInfo endpoint");
      // Temporarily use same endpoint as getUserInfo to test
      final response = await FetchingData.getHeader(ApiEndpoints.userInfo,
          {"Accept": "application/json", "Authorization": "Bearer $userToken"});
      
      print("🔍 LaravelProfileRepository: API response status: ${response.statusCode}");
      
      // Parse the response body to JSON
      final Map<String, dynamic> jsonData = json.decode(response.body);
      print("🔍 LaravelProfileRepository: Parsed JSON response");
      
      // Directly extract comprehensive profile data from the full API response
      final profileInfo = UserDto.getFullUserProfileDataFromResponse(jsonData);
      print("🔍 LaravelProfileRepository: Profile extracted: ${profileInfo.name}");
      
      return profileInfo;
    } catch (e) {
      print("🔍 LaravelProfileRepository: Error occurred: $e");
      // You can customize error handling based on your app's needs
      throw Exception("Failed to get full user profile: ${e.toString()}");
    }
  }

  

  
}
