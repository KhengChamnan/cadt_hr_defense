import 'package:palm_ecommerce_mobile_app_2/models/settings/settings_model.dart';

/// Data Transfer Object for Settings data
class SettingsDto {
  /// Convert SettingsModel to JSON map
  static Map<String, dynamic> toJson(SettingsModel settings) {
    return settings.toJson();
  }
  
  /// Convert JSON map to SettingsModel
  static SettingsModel fromJson(Map<String, dynamic> json) {
    return SettingsModel.fromJson(json);
  }
  
  /// Convert raw API response to SettingsModel
  static SettingsModel fromApiResponse(Map<String, dynamic> response) {
    // Check if response has the expected structure
    if (response.containsKey("data") && response["data"] != null) {
      final data = response["data"];
      
      // If data is wrapped in another object, extract it
      if (data is Map<String, dynamic> && data.containsKey("settings")) {
        return SettingsModel.fromJson(data["settings"]);
      } else {
        // Data is directly the settings object, reconstruct full response
        return SettingsModel(
          success: response["success"] ?? true,
          status: response["status"] ?? 200,
          data: SettingsData.fromJson(data),
    
        );
      }
    }
    
    // Fallback to treating the entire response as settings data
    return SettingsModel.fromJson(response);
  }
  
  /// Extract contact information for quick access
  static ContactUs getContactInfo(SettingsModel settings) {
    return settings.data.contactUs;
  }
  
  /// Extract about us information for quick access
  static AboutUs getAboutInfo(SettingsModel settings) {
    return settings.data.aboutUs;
  }
  
  /// Extract policy information for quick access
  static Map<String, String> getPolicyInfo(SettingsModel settings) {
    return {
      'terms_conditions': settings.data.termCondition.termCondition,
      'privacy_policy': settings.data.policyPrivacy.policyPrivacy,
      'return_policy': settings.data.returnPolicy.returnPolicy,
    };
  }
  
  /// Extract social media links for quick access
  static Map<String, String> getSocialMediaLinks(SettingsModel settings) {
    final contact = settings.data.contactUs;
    return {
      'facebook': contact.facebook,
      'instagram': contact.instagram,
      'youtube': contact.youtube,
      'telegram': contact.telegram,
      'tiktok': contact.tiktok,
      'website': contact.website,
    };
  }
  
  /// Extract payment method information
  static Map<String, String> getPaymentMethods(SettingsModel settings) {
    final articles = settings.data.articleCategories;
    return {
      'wing': articles.payWithWing,
      'pipay': articles.payWithPipay,
      'offline': articles.payByOffline,
    };
  }
  
  /// Get company location coordinates
  static Map<String, double?> getLocationCoordinates(SettingsModel settings) {
    final contact = settings.data.contactUs;
    return {
      'latitude': contact.latitudeDouble,
      'longitude': contact.longitudeDouble,
    };
  }
  
  /// Check if location data is available and valid
  static bool hasValidLocation(SettingsModel settings) {
    return settings.data.contactUs.hasValidCoordinates;
  }
  
  /// Get all company photos/logos
  static List<String> getCompanyPhotos(SettingsModel settings) {
    final data = settings.data;
    return [
      data.contactUs.photo,
      data.aboutUs.photo,
      data.termCondition.photo,
      data.policyPrivacy.photo,
      data.returnPolicy.photo,
    ].where((photo) => photo.isNotEmpty).toSet().toList();
  }
  
  /// Get primary company logo (from contact us)
  static String getPrimaryLogo(SettingsModel settings) {
    return settings.data.contactUs.photo;
  }
  
  /// Format contact information for display
  static Map<String, String> getFormattedContactInfo(SettingsModel settings) {
    final contact = settings.data.contactUs;
    return {
      'address': contact.address,
      'phone': contact.phone,
      'email': contact.email,
      'branch': contact.branchEn,
      'stay_with_us': contact.stayWithUs,
    };
  }
  

  
  /// Check if settings data is valid and complete
  static bool isValidSettings(SettingsModel settings) {
    return settings.success && 
           settings.status == 200 && 
           settings.data.contactUs.email.isNotEmpty &&
           settings.data.contactUs.phone.isNotEmpty;
  }
  
  /// Create a minimal settings object for testing/fallback
  
} 