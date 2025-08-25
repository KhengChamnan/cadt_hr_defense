import 'package:flutter/foundation.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  // Auth state for network operations only
  AsyncValue<Map<String, dynamic>> authState;
  AsyncValue<bool>? deviceTokenState;

  // Auth status
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  
  // User role cache
  String? _userRole;
  String? get userRole => _userRole;

  // Constructor
  AuthProvider({required AuthRepository repository})
      : _authRepository = repository,
        authState = AsyncValue.success({});

  // Login method (network operation)
  Future<void> login({required String name, required String password}) async {
    // Set loading state
    authState = AsyncValue.loading();
    notifyListeners();
    
    try {
      // Call repository login method
      final result = await _authRepository.login(
        name: name,
        password: password,
      );

      // Handle result
      authState = AsyncValue.success(result);
      _isLoggedIn = true;
      
      // Check and cache user role after successful login
      _userRole = await _authRepository.checkUserRole();
      
      print('✅ AuthProvider: Login successful, isLoggedIn: $_isLoggedIn, role: $_userRole');
      
    } catch (e) {
      authState = AsyncValue.error(e);
      _isLoggedIn = false;
      _userRole = null;
      print('❌ AuthProvider: Login failed: $e');
    }

    notifyListeners();
  }

  // Check first time user (local operation)
  Future<bool> isFirstTimeUser() async {
    try {
      return await _authRepository.isFirstTimeUser();
    } catch (e) {
      debugPrint('Error checking first time user: $e');
      return true;
    }
  }

  // Set first time user (local operation)
  Future<void> setFirstTimeUser(bool isFirstTime) async {
    try {
      await _authRepository.setFirstTimeUser(isFirstTime);
    } catch (e) {
      debugPrint('Error setting first time user: $e');
    }
    notifyListeners();
  }

  // Save credentials (local operation)
  Future<void> saveCredentials(
      {required String name, required String password}) async {
    try {
      await _authRepository.saveCredentials(name: name, password: password);
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
    notifyListeners();
  }

  // Clear saved credentials (local operation)
  Future<void> clearCredentials() async {
    try {
      await _authRepository.clearCredentials();
    } catch (e) {
      debugPrint('Error clearing credentials: $e');
    }
    notifyListeners();
  }

  // Get saved credentials (local operation)
  Future<Map<String, String?>> getSavedCredentials() async {
    try {
      return await _authRepository.getSavedCredentials();
    } catch (e) {
      debugPrint('Error getting saved credentials: $e');
      return {'email': null, 'password': null};
    }
  }



  // Check user role (local operation)
  Future<String?> checkUserRole() async {
    try {
      _userRole = await _authRepository.checkUserRole();
      notifyListeners();
      return _userRole;
    } catch (e) {
      debugPrint('Error checking user role: $e');
      return null;
    }
  }

  // Check if user has specific role
  bool hasRole(String role) {
    return _userRole == role;
  }

  // Logout (combined operation)
  Future<void> logout() async {
    authState = AsyncValue.loading();
    notifyListeners();
    try {
      await _authRepository.clearToken();
      _isLoggedIn = false;
      _userRole = null;
      authState = AsyncValue.success({});
    } catch (e) {
      authState = AsyncValue.error(e);
    }
    notifyListeners();
  }

  // Enhanced logout - clears all user data for better security
  Future<void> logoutEnhanced() async {
    authState = AsyncValue.loading();
    notifyListeners();
    try {
      // Clear repository data first
      await _authRepository.clearUserData();
      
      // Clear local auth state
      _isLoggedIn = false;
      _userRole = null;
      authState = AsyncValue.success({});
      
      // Clear any other cached auth-related data
      deviceTokenState = null;
      
    } catch (e) {
      authState = AsyncValue.error(e);
    }
    notifyListeners();
  }

  // Get token (local operation)
  Future<String?> getToken() async {
    try {
      return await _authRepository.getToken();
    } catch (e) {
      debugPrint('Error getting token: $e');
      return null;
    }
  }

  // Get admin data (local operation)
  Future<String?> getAdminData() async {
    try {
      return await _authRepository.getAdminData();
    } catch (e) {
      debugPrint('Error getting admin data: $e');
      return null;
    }
  }

  void setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    if (value) {
      // If logging in, check the user role
      checkUserRole();
      print('✅ User logged in, auth state updated');
    } else {
      // If logging out, clear the role
      _userRole = null;
      print('✅ User logged out, auth state cleared');
    }
    notifyListeners();
  }

  /// Get login status for debugging
  void debugAuthState() {
    print('🔍 Auth Debug - isLoggedIn: $_isLoggedIn, userRole: $_userRole');
  }

  /// Check if user has valid authentication
  Future<bool> hasValidAuth() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty && _isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  /// Wait for auth to be ready (used by other providers)
  Future<bool> waitForAuth({Duration timeout = const Duration(seconds: 5)}) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < timeout) {
      if (await hasValidAuth()) {
        print('✅ Auth is ready!');
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    print('❌ Auth timeout - not ready within ${timeout.inSeconds}s');
    return false;
  }

}
