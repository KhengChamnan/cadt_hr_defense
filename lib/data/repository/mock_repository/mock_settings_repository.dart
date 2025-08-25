import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dto/settings_dto.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/setting_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/settings/settings_model.dart';

class MockSettingsRepository implements SettingRepository {
  SettingsModel? _cachedSettings;

  @override
  Future<SettingsModel> getSetting() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    try {
      // Load from dummy JSON file
      final String jsonString = await rootBundle.loadString('lib/data/dummydata/setting.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _cachedSettings = SettingsDto.fromApiResponse(jsonData);
      return _cachedSettings!;
    } catch (e) {
      throw Exception("Failed to load mock settings: ${e.toString()}");
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
    _cachedSettings = null;
    await getSetting(); // This will reload from dummy data
  }

  @override
  Future<void> clearSettingsCache() async {
    _cachedSettings = null;
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

  // Private helper method
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