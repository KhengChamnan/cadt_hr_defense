import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/setting_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/settings/settings_model.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

class SettingsProvider with ChangeNotifier {
  final SettingRepository _settingsRepository;
  
  // Constructor
  SettingsProvider({required SettingRepository settingRepository})
      : _settingsRepository = settingRepository;

  // State management using AsyncValue
  AsyncValue<SettingsModel>? settingsValue;
  AsyncValue<ContactUs>? contactInfoValue;
  AsyncValue<AboutUs>? aboutInfoValue;
  AsyncValue<Map<String, String>>? policiesValue;
  AsyncValue<Map<String, String>>? socialMediaLinksValue;
  AsyncValue<Map<String, String>>? companyContactInfoValue;
  AsyncValue<Map<String, dynamic>>? actionStatus;

  // Getters for backwards compatibility
  SettingsModel? get settings => settingsValue?.data;
  bool get isLoading => settingsValue?.state == AsyncValueState.loading;
  String? get error => settingsValue?.error?.toString();
  bool get hasData => settingsValue?.data != null;

  /// Load settings data
  Future<void> loadSettings() async {
    // Check if we have a valid auth token first
    try {
      final settingsRepo = _settingsRepository as dynamic;
      if (settingsRepo.authRepository != null) {
        final token = await settingsRepo.authRepository.getToken();
        if (token == null || token.isEmpty) {
          print('❌ SettingsProvider: No auth token available, skipping settings load');
          settingsValue = AsyncValue.error(Exception('Authentication required'));
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('⚠️ SettingsProvider: Could not check auth token: $e');
    }
    
    settingsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final settings = await _settingsRepository.getSetting();
      settingsValue = AsyncValue.success(settings);
      print('✅ SettingsProvider: Settings loaded successfully');
    } catch (e) {
      print('❌ SettingsProvider: Failed to load settings: $e');
      settingsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Refresh settings data from API
  Future<void> refreshSettings() async {
    settingsValue = AsyncValue.loading();
    notifyListeners();

    try {
      await _settingsRepository.refreshSettings();
      final settings = await _settingsRepository.getSetting();
      settingsValue = AsyncValue.success(settings);
    } catch (e) {
      settingsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Get contact information
  Future<void> getContactInfo() async {
    contactInfoValue = AsyncValue.loading();
    notifyListeners();

    try {
      if (settingsValue?.data == null) await loadSettings();
      final contactInfo = await _settingsRepository.getContactUs();
      contactInfoValue = AsyncValue.success(contactInfo);
    } catch (e) {
      contactInfoValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Get about us information
  Future<void> getAboutInfo() async {
    aboutInfoValue = AsyncValue.loading();
    notifyListeners();

    try {
      if (settingsValue?.data == null) await loadSettings();
      final aboutInfo = await _settingsRepository.getAboutUs();
      aboutInfoValue = AsyncValue.success(aboutInfo);
    } catch (e) {
      aboutInfoValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Get all policies
  Future<void> getAllPolicies() async {
    policiesValue = AsyncValue.loading();
    notifyListeners();

    try {
      if (settingsValue?.data == null) await loadSettings();
      final policies = await _settingsRepository.getAllPolicies();
      policiesValue = AsyncValue.success(policies);
    } catch (e) {
      policiesValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Get social media links
  Future<void> getSocialMediaLinks() async {
    socialMediaLinksValue = AsyncValue.loading();
    notifyListeners();

    try {
      if (settingsValue?.data == null) await loadSettings();
      final socialLinks = await _settingsRepository.getSocialMediaLinks();
      socialMediaLinksValue = AsyncValue.success(socialLinks);
    } catch (e) {
      socialMediaLinksValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Get company contact information
  Future<void> getCompanyContactInfo() async {
    companyContactInfoValue = AsyncValue.loading();
    notifyListeners();

    try {
      if (settingsValue?.data == null) await loadSettings();
      final companyInfo = await _settingsRepository.getCompanyContactInfo();
      companyContactInfoValue = AsyncValue.success(companyInfo);
    } catch (e) {
      companyContactInfoValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Open social media link
  Future<void> openSocialMediaLink(String platform) async {
    actionStatus = AsyncValue.loading();
    notifyListeners();

    try {
      await _settingsRepository.openSocialMediaLink(platform);
      actionStatus = AsyncValue.success({'message': 'Social media link opened successfully'});
    } catch (e) {
      actionStatus = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Open website
  Future<void> openWebsite() async {
    actionStatus = AsyncValue.loading();
    notifyListeners();

    try {
      await _settingsRepository.openWebsite();
      actionStatus = AsyncValue.success({'message': 'Website opened successfully'});
    } catch (e) {
      actionStatus = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Open contact phone
  Future<void> openContactPhone() async {
    actionStatus = AsyncValue.loading();
    notifyListeners();

    try {
      await _settingsRepository.openContactPhone();
      actionStatus = AsyncValue.success({'message': 'Phone opened successfully'});
    } catch (e) {
      actionStatus = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Open contact email
  Future<void> openContactEmail() async {
    actionStatus = AsyncValue.loading();
    notifyListeners();

    try {
      await _settingsRepository.openContactEmail();
      actionStatus = AsyncValue.success({'message': 'Email opened successfully'});
    } catch (e) {
      actionStatus = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Open map location
  Future<void> openMapLocation() async {
    actionStatus = AsyncValue.loading();
    notifyListeners();

    try {
      await _settingsRepository.openMapLocation();
      actionStatus = AsyncValue.success({'message': 'Map location opened successfully'});
    } catch (e) {
      actionStatus = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Clear settings cache
  Future<void> clearCache() async {
    actionStatus = AsyncValue.loading();
    notifyListeners();

    try {
      await _settingsRepository.clearSettingsCache();
      settingsValue = null;
      contactInfoValue = null;
      aboutInfoValue = null;
      policiesValue = null;
      socialMediaLinksValue = null;
      companyContactInfoValue = null;
      actionStatus = AsyncValue.success({'message': 'Cache cleared successfully'});
    } catch (e) {
      actionStatus = AsyncValue.error(e);
    }
    notifyListeners();
  }

  /// Clear all provider data (used during logout)
  void clearAllData() {
    print('🧹 SettingsProvider: Clearing all settings data...');
    settingsValue = null;
    contactInfoValue = null;
    aboutInfoValue = null;
    policiesValue = null;
    socialMediaLinksValue = null;
    companyContactInfoValue = null;
    actionStatus = null;
    notifyListeners();
    print('✅ SettingsProvider: All settings data cleared successfully');
  }

  /// Load settings after successful authentication
  Future<void> loadSettingsAfterAuth() async {
    print('🔄 SettingsProvider: Loading settings after auth...');
    
    // Clear any previous error states
    settingsValue = null;
    
    // Wait a bit for auth to settle
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Load settings
    await loadSettings();
    
    print('✅ SettingsProvider: Post-auth settings loading completed');
  }
} 