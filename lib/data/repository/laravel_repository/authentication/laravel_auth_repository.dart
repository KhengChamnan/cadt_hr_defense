import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_constant.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_endpoints.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dummydata/user_data.dart';

class LaravelAuthRepository implements AuthRepository {
  // Keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _nameKey = 'saved_name';
  static const String _passwordKey = 'saved_password';
  static const String _firstTimeKey = 'is_first_time';
  static const String _adminKey = 'admin_data';
  static const String _userRoleKey = 'user_role';

  @override
  Future<Map<String, dynamic>> login({
    required String name,
    required String password,
  }) async {
    Map<String, dynamic> body = {
      'name': name,
      'password': password,
    };

    final response = await FetchingData.postData(
      ApiEndpoints.login,
      body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true && data['data'] != null && data['data']['token'] != null) {
        await saveToken(data['data']['token']);
        return data;
      }
    }
    
    throw Exception(json.decode(response.body)['message'] ?? 'Login failed');
  }

  @override
  Future<bool> registerDeviceToken(String token) async {
    final authToken = await getToken();
    if (authToken == null) throw Exception('No authentication token found');

    Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
      'Accept': 'application/json',
    };

    Map<String, dynamic> body = {
      'device_token': token,
    };

    final response = await FetchingData.postHeader(
      ApiEndpoints.registerDeviceToken,
      headers,
      body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register device token');
    }

    return true;
  }

  @override
  Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTimeKey) ?? true;
  }

  @override
  Future<void> setFirstTimeUser(bool isFirstTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, isFirstTime);
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Enhanced logout - clears all user-specific data for better security
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_adminKey);
    await prefs.remove(_userRoleKey);
    
    // Also clear any cached profile or settings data keys
    final allKeys = prefs.getKeys();
    final keysToRemove = <String>[];
    
    for (String key in allKeys) {
      // Clear any user-specific cache data but keep app-level settings
      if (key.contains('profile') || 
          key.contains('settings_cache') || 
          key.contains('cached_settings') ||
          key.contains('user_info') ||
          key.contains('staff_info') ||
          key.contains('full_profile') ||
          key.contains('profile_info') ||
          key.contains('company_profile') ||
          key.startsWith('user_') ||
          key.startsWith('profile_') ||
          key.startsWith('staff_')) {
        keysToRemove.add(key);
      }
    }
    
    // Remove all identified keys
    for (String key in keysToRemove) {
      await prefs.remove(key);
      print('🗑️ Cleared cache key: $key');
    }
    
    print('✅ Cleared ${keysToRemove.length} cached data keys');
    
    // Note: Keep _nameKey and _passwordKey for user convenience
    // Note: Keep _firstTimeKey as it's app-level, not user-specific
  }

  @override
  Future<void> saveCredentials({
    required String name,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_passwordKey, password);
  }

  @override
  Future<Map<String, String?>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey),
      'password': prefs.getString(_passwordKey),
    };
  }

  @override
  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_passwordKey);
  }



  @override
  Future<String?> getAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminKey);
  }

  @override
  Future<void> saveAdminData(String adminData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adminKey, adminData);
  }

  @override
  Future<String?> checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    // First check if we have a saved role
    String? savedRole = prefs.getString(_userRoleKey);
    if (savedRole != null) {
      return savedRole;
    }
    
    // If no saved role, check credentials and compare with dummy data
    final credentials = await getSavedCredentials();
    final name = credentials['name'];
    
    if (name == null) return null;
    
    String? role;
    // Check against dummy data
    if (name == UserData.user['name']) {
      role = UserData.user['role'];
    } else if (name == UserData.hrUser['name']) {
      role = UserData.hrUser['role'];
    } else if (name == UserData.supervisors['name']) {
      role = UserData.supervisors['role'];
    }
    
    // Save the role for future checks
    if (role != null) {
      await prefs.setString(_userRoleKey, role);
    }
    
    return role;
  }
}	
