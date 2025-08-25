/// Settings Model for application configuration and content
class SettingsModel {
  final bool success;
  final int status;
  final SettingsData data;



  SettingsModel({
    required this.success,
    required this.status,
    required this.data,

  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      data: SettingsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status': status,
      'data': data.toJson(),

    };
  }
}

/// Main data container for all settings
class SettingsData {
  final ContactUs contactUs;
  final AboutUs aboutUs;
  final TermCondition termCondition;
  final PolicyPrivacy policyPrivacy;
  final ReturnPolicy returnPolicy;
  final ArticleCategories articleCategories;

  SettingsData({
    required this.contactUs,
    required this.aboutUs,
    required this.termCondition,
    required this.policyPrivacy,
    required this.returnPolicy,
    required this.articleCategories,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData(
      contactUs: ContactUs.fromJson(json['contact_us'] ?? {}),
      aboutUs: AboutUs.fromJson(json['about_us'] ?? {}),
      termCondition: TermCondition.fromJson(json['term_condition'] ?? {}),
      policyPrivacy: PolicyPrivacy.fromJson(json['Policy_Pracy'] ?? {}),
      returnPolicy: ReturnPolicy.fromJson(json['Return_Policy'] ?? {}),
      articleCategories: ArticleCategories.fromJson(json['artical_categories'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_us': contactUs.toJson(),
      'about_us': aboutUs.toJson(),
      'term_condition': termCondition.toJson(),
      'Policy_Pracy': policyPrivacy.toJson(),
      'Return_Policy': returnPolicy.toJson(),
      'artical_categories': articleCategories.toJson(),
    };
  }
}

/// Contact information and social media links
class ContactUs {
  final String photo;
  final String stayWithUs;
  final String address;
  final String phone;
  final String latitude;
  final String longitude;
  final String website;
  final String facebook;
  final String instagram;
  final String youtube;
  final String email;
  final String branchEn;
  final String telegram;
  final String tiktok;

  ContactUs({
    required this.photo,
    required this.stayWithUs,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.website,
    required this.facebook,
    required this.instagram,
    required this.youtube,
    required this.email,
    required this.branchEn,
    required this.telegram,
    required this.tiktok,
  });

  factory ContactUs.fromJson(Map<String, dynamic> json) {
    return ContactUs(
      photo: json['photo'] ?? '',
      stayWithUs: json['stay_withus'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      website: json['website'] ?? '',
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      youtube: json['youtube'] ?? '',
      email: json['email'] ?? '',
      branchEn: json['branch_en'] ?? '',
      telegram: json['telegram'] ?? '',
      tiktok: json['tiktok'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'stay_withus': stayWithUs,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'youtube': youtube,
      'email': email,
      'branch_en': branchEn,
      'telegram': telegram,
      'tiktok': tiktok,
    };
  }

  /// Get location coordinates as double values
  double? get latitudeDouble => double.tryParse(latitude);
  double? get longitudeDouble => double.tryParse(longitude);

  /// Check if location coordinates are valid
  bool get hasValidCoordinates => latitudeDouble != null && longitudeDouble != null;
}

/// About us information
class AboutUs {
  final String photo;
  final String whoWeAre;
  final String ourMission;
  final String ourVision;

  AboutUs({
    required this.photo,
    required this.whoWeAre,
    required this.ourMission,
    required this.ourVision,
  });

  factory AboutUs.fromJson(Map<String, dynamic> json) {
    return AboutUs(
      photo: json['photo'] ?? '',
      whoWeAre: json['who_weare'] ?? '',
      ourMission: json['our_mission'] ?? '',
      ourVision: json['our_vission'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'who_weare': whoWeAre,
      'our_mission': ourMission,
      'our_vission': ourVision,
    };
  }
}

/// Terms and conditions information
class TermCondition {
  final String photo;
  final String termCondition;

  TermCondition({
    required this.photo,
    required this.termCondition,
  });

  factory TermCondition.fromJson(Map<String, dynamic> json) {
    return TermCondition(
      photo: json['photo'] ?? '',
      termCondition: json['term_condition'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'term_condition': termCondition,
    };
  }
}

/// Privacy policy information
class PolicyPrivacy {
  final String photo;
  final String policyPrivacy;

  PolicyPrivacy({
    required this.photo,
    required this.policyPrivacy,
  });

  factory PolicyPrivacy.fromJson(Map<String, dynamic> json) {
    return PolicyPrivacy(
      photo: json['photo'] ?? '',
      policyPrivacy: json['Policy_Pracy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'Policy_Pracy': policyPrivacy,
    };
  }
}

/// Return policy information
class ReturnPolicy {
  final String photo;
  final String returnPolicy;

  ReturnPolicy({
    required this.photo,
    required this.returnPolicy,
  });

  factory ReturnPolicy.fromJson(Map<String, dynamic> json) {
    return ReturnPolicy(
      photo: json['photo'] ?? '',
      returnPolicy: json['Return_Policy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo': photo,
      'Return_Policy': returnPolicy,
    };
  }
}

/// Article categories and payment information
class ArticleCategories {
  final String documentation;
  final String payWithWing;
  final String payByOffline;
  final String payWithPipay;

  ArticleCategories({
    required this.documentation,
    required this.payWithWing,
    required this.payByOffline,
    required this.payWithPipay,
  });

  factory ArticleCategories.fromJson(Map<String, dynamic> json) {
    return ArticleCategories(
      documentation: json['documentation'] ?? '',
      payWithWing: json['paywithwing'] ?? '',
      payByOffline: json['paybyoffline'] ?? '',
      payWithPipay: json['paywithpipay'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentation': documentation,
      'paywithwing': payWithWing,
      'paybyoffline': payByOffline,
      'paywithpipay': payWithPipay,
    };
  }
} 