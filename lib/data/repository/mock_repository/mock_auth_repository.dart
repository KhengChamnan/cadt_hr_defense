import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dummydata/user_data.dart';

class MockAuthRepository implements AuthRepository {
  // Keys for SharedPreferences - keeping the same keys as LaravelAuthRepository
  static const String _tokenKey = 'auth_token';
  static const String _nameKey = 'saved_name';
  static const String _passwordKey = 'saved_password';
  static const String _firstTimeKey = 'is_first_time';
  static const String _adminKey = 'admin_data';
  static const String _userRoleKey = 'user_role';

  // Mock token
  final String _mockToken = 'mock_auth_token_12345';

  @override
  Future<Map<String, dynamic>> login({
    required String name,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Check credentials against mock data
    if (name == UserData.user['name'] && password == UserData.user['password']) {
      await saveToken(_mockToken);
      return {
        'success': true,
        'message': 'Login successful',
        'data': {
          'token': _mockToken,
          'user': {
            'id': 1,
            'name': name,
            'phone': '1234567890',
            'profile_image': 'https://via.placeholder.com/150',
          }
        }
      };
    }
    
    // Return error for invalid credentials
    throw Exception('Invalid name or password');
  }

  @override
  Future<bool> registerDeviceToken(String token) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Always return success in mock
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

  @override
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_adminKey);
    await prefs.remove(_userRoleKey);
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
      'name': prefs.getString(_nameKey) ?? UserData.user['name'],
      'password': prefs.getString(_passwordKey) ?? UserData.user['password'],
    };
  }

  @override
  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
    await prefs.remove(_passwordKey);
  }

  Future<Map<String, dynamic>> fetchHelpCenter() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));
    
    return {
      'success': true,
      'data': [
        {
          'id': 1,
          'title': 'How to use the app',
          'content': 'This is a mock help article explaining how to use the app.',
          'created_at': '2023-01-01T00:00:00.000Z',
        },
        {
          'id': 2,
          'title': 'Troubleshooting guide',
          'content': 'This is a mock troubleshooting guide for common issues.',
          'created_at': '2023-01-02T00:00:00.000Z',
        },
      ]
    };
  }

  @override
  Future<String?> getAdminData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminKey) ?? json.encode({
      'id': 999,
      'name': 'Mock Admin',
      'role': 'admin',
      'permissions': ['read', 'write', 'delete']
    });
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
    final email = credentials['email'];
    
    if (email == null) return null;
    
    String? role;
    // Check against dummy data
    if (email == UserData.user['email']) {
      role = UserData.user['role'];
    } else if (email == UserData.hrUser['email']) {
      role = UserData.hrUser['role'];
    } else if (email == UserData.supervisors['email']) {
      role = UserData.supervisors['role'];
    }
    
    // Save the role for future checks
    if (role != null) {
      await prefs.setString(_userRoleKey, role);
    }
    
    return role;
  }
} 