abstract class AuthRepository {

  Future<Map<String, dynamic>> login({
    required String name,
    required String password,
  });

  
  /// Register device token for push notifications
  Future<bool> registerDeviceToken(String token);

  /// Check if this is the first time opening the app
  Future<bool> isFirstTimeUser();

  /// Save first time user state
  Future<void> setFirstTimeUser(bool isFirstTime);

  /// Save authentication token
  Future<void> saveToken(String token);
  
  /// Get stored authentication token
  Future<String?> getToken();
  
  /// Clear authentication token (logout)
  Future<void> clearToken();

  /// Clear all user-specific data (enhanced logout for better security)
  Future<void> clearUserData();

  /// Save user credentials (for remember me feature)
  Future<void> saveCredentials({
    required String name,
    required String password,
  });

  /// Get saved user credentials
  Future<Map<String, String?>> getSavedCredentials();
  
  /// Clear saved credentials
  Future<void> clearCredentials();
  

  
  /// Get stored admin data
  Future<String?> getAdminData();
  
  /// Save admin data
  Future<void> saveAdminData(String adminData);

  /// Check user role (returns 'user', 'hr', 'supervisor', or null if not authenticated)
  Future<String?> checkUserRole();
}