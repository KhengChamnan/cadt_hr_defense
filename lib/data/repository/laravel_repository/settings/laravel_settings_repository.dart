import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_constant.dart';
import 'package:palm_ecommerce_mobile_app_2/data/Network/api_endpoints.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dto/settings_dto.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/auth_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/setting_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/settings/settings_model.dart';

class LaravelSettingsRepository implements SettingRepository {
  final AuthRepository authRepository;
  
  // Cache key for storing settings data
  static const String _settingsCacheKey = 'cached_settings_data';
  static const String _settingsTimestampKey = 'settings_cache_timestamp';
  static const int _cacheValidityHours = 24; // Cache for 24 hours
  
  LaravelSettingsRepository({required this.authRepository});

  @override
  Future<SettingsModel> getSetting() async {
    try {
      // Try to get from cache first
      final cachedSettings = await _getCachedSettings();
      if (cachedSettings != null) {
        return cachedSettings;
      }

      // If not in cache, fetch from API
      String? userToken = await authRepository.getToken();
      if (userToken == null || userToken.isEmpty) {
        throw Exception("Invalid or missing authentication token");
      }

      final response = await FetchingData.getHeader(
        ApiEndpoints.getSettings,
        {
          "Accept": "application/json",
          "Authorization": "Bearer $userToken"
        }
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final settings = SettingsDto.fromApiResponse(jsonData);
        
        // Cache the settings
        await _cacheSettings(settings);
        
        return settings;
      } else {
        throw Exception("Failed to fetch settings: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to get settings: ${e.toString()}");
    }
  }

  @override
  Future<ContactUs> getContactUs() async {
    final settings = await getSetting();
    return SettingsDto.getContactInfo(settings);
  }

  @override
  Future<Map<String, String>> getSocialMediaLinks() async {
    final settings = await getSetting();
    return SettingsDto.getSocialMediaLinks(settings);
  }

  @override
  Future<Map<String, double?>> getLocationCoordinates() async {
    final settings = await getSetting();
    return SettingsDto.getLocationCoordinates(settings);
  }

  @override
  Future<AboutUs> getAboutUs() async {
    final settings = await getSetting();
    return SettingsDto.getAboutInfo(settings);
  }

  @override
  Future<String> getCompanyLogo() async {
    final settings = await getSetting();
    return SettingsDto.getPrimaryLogo(settings);
  }

  @override
  Future<Map<String, String>> getCompanyContactInfo() async {
    final settings = await getSetting();
    return SettingsDto.getFormattedContactInfo(settings);
  }

  @override
  Future<String> getTermsAndConditions() async {
    final settings = await getSetting();
    return settings.data.termCondition.termCondition;
  }

  @override
  Future<String> getPrivacyPolicy() async {
    final settings = await getSetting();
    return settings.data.policyPrivacy.policyPrivacy;
  }

  @override
  Future<String> getReturnPolicy() async {
    final settings = await getSetting();
    return settings.data.returnPolicy.returnPolicy;
  }

  @override
  Future<Map<String, String>> getAllPolicies() async {
    final settings = await getSetting();
    return SettingsDto.getPolicyInfo(settings);
  }

  @override
  Future<ArticleCategories> getArticleCategories() async {
    final settings = await getSetting();
    return settings.data.articleCategories;
  }

  @override
  Future<Map<String, String>> getPaymentMethods() async {
    final settings = await getSetting();
    return SettingsDto.getPaymentMethods(settings);
  }

  @override
  Future<bool> isSettingsDataValid() async {
    try {
      final settings = await getSetting();
      return SettingsDto.isValidSettings(settings);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> refreshSettings() async {
    await clearSettingsCache();
    await getSetting(); // This will fetch fresh data from API
  }

  @override
  Future<void> clearSettingsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsCacheKey);
    await prefs.remove(_settingsTimestampKey);
  }

  @override
  Future<void> openSocialMediaLink(String platform) async {
    final socialLinks = await getSocialMediaLinks();
    final url = socialLinks[platform.toLowerCase()];
    
    if (url != null && url.isNotEmpty) {
      await _launchUrl(url);
    } else {
      throw Exception("$platform link not available");
    }
  }

  @override
  Future<void> openWebsite() async {
    final contact = await getContactUs();
    if (contact.website.isNotEmpty) {
      await _launchUrl(contact.website);
    } else {
      throw Exception("Website link not available");
    }
  }

  @override
  Future<void> openContactPhone() async {
    final contact = await getContactUs();
    if (contact.phone.isNotEmpty) {
      await _launchUrl("tel:${contact.phone}");
    } else {
      throw Exception("Phone number not available");
    }
  }

  @override
  Future<void> openContactEmail() async {
    final contact = await getContactUs();
    if (contact.email.isNotEmpty) {
      await _launchUrl("mailto:${contact.email}");
    } else {
      throw Exception("Email address not available");
    }
  }

  @override
  Future<void> openMapLocation() async {
    final coordinates = await getLocationCoordinates();
    final lat = coordinates['latitude'];
    final lng = coordinates['longitude'];
    
    if (lat != null && lng != null) {
      final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
      await _launchUrl(url);
    } else {
      throw Exception("Location coordinates not available");
    }
  }

  // Private helper methods

  /// Cache settings data locally
  Future<void> _cacheSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(SettingsDto.toJson(settings));
    await prefs.setString(_settingsCacheKey, jsonString);
    await prefs.setInt(_settingsTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Get cached settings if valid
  Future<SettingsModel?> _getCachedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_settingsCacheKey);
      final timestamp = prefs.getInt(_settingsTimestampKey);
      
      if (cachedData != null && timestamp != null) {
        final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
        final cacheValidityMs = _cacheValidityHours * 60 * 60 * 1000;
        
        if (cacheAge < cacheValidityMs) {
          final jsonData = json.decode(cachedData);
          return SettingsDto.fromJson(jsonData);
        }
      }
      
      return null;
    } catch (e) {
      // If cache is corrupted, clear it
      await clearSettingsCache();
      return null;
    }
  }

  /// Launch URL with error handling
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception("Cannot launch URL: $url");
      }
    } catch (e) {
      throw Exception("Failed to launch URL: $url - ${e.toString()}");
    }
  }
} 