import 'package:palm_ecommerce_mobile_app_2/data/dummydata/profile_data.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/profile_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/profile/profile.dart';

class MockProfileRepository implements ProfileRepository {
  final AuthRepository authRepository;

  MockProfileRepository({required this.authRepository});

  @override
  Future<ProfileInfo> getUserInfo() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check if the user is authenticated
    final token = await authRepository.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    
    // Return mock profile data
    return ProfileData.profile;
  }

  @override
  Future<ProfileInfo> getFullUserInfo() async {
    // Simulate network delay for full profile data (slightly longer)
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // Check if the user is authenticated
    final token = await authRepository.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('User not authenticated');
    }
    
    // Return mock full profile data (same as regular profile for mock)
    // In a real scenario, this would contain more detailed information
    return ProfileData.profile;
  }
} 