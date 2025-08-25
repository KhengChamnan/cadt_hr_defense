import 'package:palm_ecommerce_mobile_app_2/models/settings/settings_model.dart';

abstract class SettingRepository {
  // Main settings data
  Future<SettingsModel> getSetting();
  
  // Contact information functions
  Future<ContactUs> getContactUs();
  Future<Map<String, String>> getSocialMediaLinks();
  Future<Map<String, double?>> getLocationCoordinates();
  
  // Company information functions  
  Future<AboutUs> getAboutUs();
  Future<String> getCompanyLogo();
  Future<Map<String, String>> getCompanyContactInfo();
  
  // Policy and legal information functions
  Future<String> getTermsAndConditions();
  Future<String> getPrivacyPolicy(); 
  Future<String> getReturnPolicy();
  Future<Map<String, String>> getAllPolicies();
  
  // Payment and article functions
  Future<ArticleCategories> getArticleCategories();
  Future<Map<String, String>> getPaymentMethods();
  
  // Utility functions
  Future<bool> isSettingsDataValid();
  Future<void> refreshSettings();
  Future<void> clearSettingsCache();
  
  // URL launching functions for social media
  Future<void> openSocialMediaLink(String platform);
  Future<void> openWebsite();
  Future<void> openContactPhone();
  Future<void> openContactEmail();
  Future<void> openMapLocation();
}

