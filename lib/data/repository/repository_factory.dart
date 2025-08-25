import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/approval_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/attendance_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/leave_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/profile_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/setting_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/staff_repository.dart';

import 'package:palm_ecommerce_mobile_app_2/data/repository/laravel_repository/approval/laravel_approval_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/laravel_repository/authentication/laravel_auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/laravel_repository/attendance/laravel_attendance_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/laravel_repository/leave/laravel_leave_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/laravel_repository/profile/laravel_profile_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/laravel_repository/settings/laravel_settings_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/laravel_repository/staff/laravel_staff_repository.dart';

import 'package:palm_ecommerce_mobile_app_2/data/repository/mock_repository/mock_approval_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/mock_repository/mock_auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/mock_repository/mock_attendance_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/mock_repository/mock_leave_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/mock_repository/mock_profile_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/mock_repository/mock_settings_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/mock_repository/mock_staff_repository.dart';

/// Factory class to create repository instances
/// This allows easily switching between mock and real implementations
class RepositoryFactory {
  // Singleton instance
  static final RepositoryFactory _instance = RepositoryFactory._internal();
  
  // Factory constructor
  factory RepositoryFactory() {
    return _instance;
  }
  
  // Private constructor
  RepositoryFactory._internal();
  
  // Whether to use mock repositories
  bool _useMockRepositories = false;
  bool _useMockLeavesRepository = false; // Use Laravel leave repository by default
  
  /// Set whether to use mock repositories
  void setUseMockRepositories(bool useMock) {
    _useMockRepositories = useMock;
  }
  
  /// Set whether to use mock leaves repository specifically
  void setUseMockLeavesRepository(bool useMock) {
    _useMockLeavesRepository = useMock;
  }
  
  /// Get whether mock repositories are being used
  bool get useMockRepositories => _useMockRepositories;
  
  /// Get whether mock leaves repository is being used
  bool get useMockLeavesRepository => _useMockLeavesRepository;
  
  /// Get an authentication repository instance
  AuthRepository getAuthRepository() {
    if (_useMockRepositories) {
      return MockAuthRepository();
    } else {
      return LaravelAuthRepository();
    }
  }
  
  /// Get an attendance repository instance
  AttendanceRepository getAttendanceRepository() {
    final authRepo = getAuthRepository();
    
    if (_useMockRepositories) {
      return MockAttendanceRepository(authRepository: authRepo);
    } else {
      return LaravelAttendanceRepository(authRepository: authRepo);
    }
  }

  //get staff repository
  StaffRepository getStaffRepository() {
    final authRepo = getAuthRepository();
    
    if (_useMockRepositories) {
      return MockStaffRepository(authRepository: authRepo);
    } else {
      return LaravelStaffRepository(authRepository: authRepo);
    }
  }
  
  /// Get a profile repository instance
  ProfileRepository getProfileRepository() {
    final authRepo = getAuthRepository();
    
    if (_useMockRepositories) {
      return MockProfileRepository(authRepository: authRepo);
    } else {
      return LaravelProfileRepository(authRepository: authRepo);
    }
  }
  
 
  /// Get a settings repository instance
  SettingRepository getSettingsRepository() {
    final authRepo = getAuthRepository();
    
    if (_useMockRepositories) {
      return MockSettingsRepository();
    } else {
      return LaravelSettingsRepository(authRepository: authRepo);
    }
  }

  /// Get a leave repository instance
  LeaveRepository getLeaveRepository() {
    final authRepo = getAuthRepository();
    
    if (_useMockLeavesRepository) {
      return MockLeaveRepository(authRepository: authRepo);
    } else {
      return LaravelLeaveRepository(authRepository: authRepo);
    }
  }

  /// Get an approval repository instance
  ApprovalRepository getApprovalRepository() {
    final authRepo = getAuthRepository();
    
    if (_useMockRepositories) {
      return MockApprovalRepository(authRepository: authRepo);
    } else {
      return LaravelApprovalRepository(authRepository: authRepo);
    }
  }
} 