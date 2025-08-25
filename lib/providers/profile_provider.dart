import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/profile_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/profile/profile.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository profileRepository;

  AsyncValue<ProfileInfo>? profileInfo;
  AsyncValue<ProfileInfo>? fullProfileInfo;

  ProfileProvider({required this.profileRepository});

  Future<void> getProfileInfo() async {
    // Prevent multiple simultaneous calls
    if (profileInfo?.state == AsyncValueState.loading) return;
    
    // Check if we have a valid auth token first
    try {
      final profileRepo = profileRepository as dynamic;
      if (profileRepo.authRepository != null) {
        final token = await profileRepo.authRepository.getToken();
        if (token == null || token.isEmpty) {
          print('❌ ProfileProvider: No auth token available, skipping profile load');
          profileInfo = AsyncValue.error(Exception('Authentication required'));
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('⚠️ ProfileProvider: Could not check auth token: $e');
    }
    
    profileInfo = AsyncValue.loading();
    
    // Use post-frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      final profile = await profileRepository.getUserInfo();
      profileInfo = AsyncValue.success(profile);
      print('✅ ProfileProvider: Profile loaded successfully');
    } catch (e) {
      print('❌ ProfileProvider: Failed to load profile: $e');
      profileInfo = AsyncValue.error(e);
    }
    
    // Use post-frame callback for final notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> getFullProfileInfo() async {
    print("🔍 ProfileProvider: getFullProfileInfo() called");
    
    // Prevent multiple simultaneous calls
    if (fullProfileInfo?.state == AsyncValueState.loading) {
      print("🔍 ProfileProvider: Already loading, returning early");
      return;
    }
    
    // Check if we have a valid auth token first
    try {
      final profileRepo = profileRepository as dynamic;
      if (profileRepo.authRepository != null) {
        final token = await profileRepo.authRepository.getToken();
        if (token == null || token.isEmpty) {
          print('❌ ProfileProvider: No auth token available for full profile, skipping load');
          fullProfileInfo = AsyncValue.error(Exception('Authentication required'));
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('⚠️ ProfileProvider: Could not check auth token for full profile: $e');
    }
    
    print("🔍 ProfileProvider: Setting loading state");
    fullProfileInfo = AsyncValue.loading();
    
    // Use post-frame callback to ensure we're not in build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🔍 ProfileProvider: Notifying loading state");
      notifyListeners();
    });

    try {
      print("🔍 ProfileProvider: Calling repository.getFullUserInfo()");
      final profile = await profileRepository.getFullUserInfo();
      print("🔍 ProfileProvider: Repository call successful, profile name: ${profile.name}");
      fullProfileInfo = AsyncValue.success(profile);
    } catch (e) {
      print("🔍 ProfileProvider: Repository call failed: $e");
      fullProfileInfo = AsyncValue.error(e);
    }
    
    // Use post-frame callback for final notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🔍 ProfileProvider: Notifying final state: ${fullProfileInfo?.state}");
      notifyListeners();
    });
  }

  /// Safe method to get profile info that can be called during build
  void getProfileInfoSafe() {
    // Only proceed if not already loading or loaded
    if (profileInfo?.state == AsyncValueState.loading) return;
    if (profileInfo?.state == AsyncValueState.success) return;
    
    // Schedule the actual call after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfileInfo();
    });
  }

  /// Safe method to get full profile info that can be called during build
  void getFullProfileInfoSafe() {
    // Only proceed if not already loading or loaded
    if (fullProfileInfo?.state == AsyncValueState.loading) return;
    if (fullProfileInfo?.state == AsyncValueState.success) return;
    
    // Schedule the actual call after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getFullProfileInfo();
    });
  }

  /// Load profile data after successful authentication
  Future<void> loadProfileAfterAuth() async {
    print('🔄 ProfileProvider: Loading profile after auth...');
    
    // Clear any previous error states
    profileInfo = null;
    fullProfileInfo = null;
    
    // Wait a bit for auth to settle
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Load both profile types
    await getProfileInfo();
    await getFullProfileInfo();
    
    print('✅ ProfileProvider: Post-auth profile loading completed');
  }

  /// Reset profile info (useful for logout/login scenarios)
  void clearProfileInfo() {
    print('🧹 ProfileProvider: Clearing profile data...');
    
    // Clear all profile data
    profileInfo = null;
    fullProfileInfo = null;
    
    // Force immediate notification to update UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hasListeners) {
        notifyListeners();
      }
    });
    
    print('✅ ProfileProvider: Profile data cleared successfully');
  }

  /// Force refresh profile data (for new login sessions)
  void forceRefreshProfile() {
    print('🔄 ProfileProvider: Force refreshing profile...');
    profileInfo = null;
    fullProfileInfo = null;
    
    // Trigger immediate refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfileInfoSafe();
      getFullProfileInfoSafe();
    });
  }
}