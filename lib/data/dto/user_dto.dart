import 'package:palm_ecommerce_mobile_app_2/models/user_info.dart';
import 'package:palm_ecommerce_mobile_app_2/models/profile/profile.dart';



/// Data Transfer Object for User profile data
class UserDto {
  /// Convert UserInfo model to JSON map
  static Map<String, dynamic> toJson(UserInfo user) {
    return {
      "id": user.id,
      "is_blocked": user.isBlocked,
      "type_app": user.typeApp,
      "profile_id": user.profileId,
      "profile_name": user.profileName,
      "name": user.name,
      "email": user.email,
      "temp": user.temp,
      "position": user.position,
      "profile_image": user.profileImage,
      "phone": user.phone,
      "is_muschange_password": user.isMuschangePassword,
      "is_never_expired": user.isNeverExpired,
      "is_password_expired_age": user.isPasswordExpiredAge,
      "number_password_age": user.numberPasswordAge,
      "last_login": user.lastLogin,
      "login_status": user.loginStatus,
      "created_by": user.createdBy,
      "updated_by": user.updatedBy,
      "created_at": user.createdAt,
      "updated_at": user.updatedAt,
      "status": user.status,
      "background_cover": user.backgroundCover,
      "max_upload": user.maxUpload,
      "branch_id": user.branchId,
      "company_id": user.companyId,
      "warehouse_id": user.warehouseId,
      "officer_id": user.officerId,
      "max_temp": user.maxTemp,
      "mcode": user.mcode,
      "role": user.role,
      "pro_code": user.proCode,
      "user_name": user.userName,
      "pass_word": user.passWord,
      "user_tel": user.userTel,
      "e_mail": user.eMail,
      "landing": user.landing,
      "admin": user.admin,
      "province": user.province,
      "member": user.member,
      "national": user.national,
      "rec_date": user.recDate,
      "verification_code": user.verificationCode,
      "verification_expiry": user.verificationExpiry,
      "gender": user.gender,
      "hsk_id": user.hskId,
      "dob": user.dob,
      "prefix": user.prefix,
      "voucher_date": user.voucherDate,
      "already_give_voucher": user.alreadyGiveVoucher,
      "card_number": user.cardNumber,
      "fb_id": user.fbId,
      "role_id": user.roleId,
    };
  }
  
  /// Convert JSON map to UserInfo model
  static UserInfo fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json["id"] ?? 0,
      isBlocked: json["is_blocked"] ?? "",
      typeApp: json["type_app"] ?? "",
      profileId: json["profile_id"] ?? "",
      profileName: json["profile_name"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      temp: json["temp"] ?? "",
      position: json["position"] ?? "",
      profileImage: json["profile_image"] ?? "",
      phone: json["phone"] ?? "",
      isMuschangePassword: json["is_muschange_password"] ?? "",
      isNeverExpired: json["is_never_expired"] ?? "",
      isPasswordExpiredAge: json["is_password_expired_age"] ?? "",
      numberPasswordAge: json["number_password_age"] ?? "",
      lastLogin: json["last_login"] ?? "",
      loginStatus: json["login_status"] ?? "",
      createdBy: json["created_by"] ?? "",
      updatedBy: json["updated_by"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      status: json["status"] ?? "",
      backgroundCover: json["background_cover"] ?? "",
      maxUpload: json["max_upload"] ?? "",
      branchId: json["branch_id"] ?? "",
      companyId: json["company_id"] ?? "",
      warehouseId: json["warehouse_id"] ?? "",
      officerId: json["officer_id"] ?? "",
      maxTemp: json["max_temp"] ?? "",
      mcode: json["mcode"] ?? "",
      role: json["role"] ?? "",
      proCode: json["pro_code"] ?? "",
      userName: json["user_name"] ?? "",
      passWord: json["pass_word"] ?? "",
      userTel: json["user_tel"] ?? "",
      eMail: json["e_mail"] ?? "",
      landing: json["landing"] ?? "",
      admin: json["admin"] ?? "",
      province: json["province"] ?? "",
      member: json["member"] ?? "",
      national: json["national"] ?? "",
      recDate: json["rec_date"] ?? "",
      verificationCode: json["verification_code"] ?? "",
      verificationExpiry: json["verification_expiry"] ?? "",
      gender: json["gender"] ?? "",
      hskId: json["hsk_id"] ?? "",
      dob: json["dob"] ?? "",
      alreadyGiveVoucher: json["already_give_voucher"] ?? "",
      cardNumber: json["card_number"] ?? "",
      fbId: json["fb_id"] ?? "",
      roleId: json["role_id"] ?? "",
      staffId:json["staff_id"],
      manager:json["manager"],
      supervisor:json["supervisor"],
    );
  }
  
  /// Convert raw API response to UserInfo model
  static UserInfo fromApiResponse(Map<String, dynamic> response) {
    // Check if response has the expected structure
    if (response.containsKey("data") && response["data"] != null) {
      final data = response["data"];
      
      // Check if data contains user object (Laravel API structure)
      if (data is Map<String, dynamic> && data.containsKey("user")) {
        return fromJson(data["user"]);
      } else {
        // Data is directly the user object
        return fromJson(data);
      }
    }
    
    // Fallback to treating the entire response as user data
    return fromJson(response);
  }

  /// Convert full API response with profile_staff and staff_info to UserInfo model
  static UserInfo fromFullApiResponse(Map<String, dynamic> response) {
    // Check if response has the expected structure
    if (response.containsKey("data") && response["data"] != null) {
      final data = response["data"];
      
      if (data is Map<String, dynamic>) {
        final user = data["user"] ?? {};
        final profileStaff = data["profile_staff"] ?? {};
        final staffInfo = data["staff_info"] ?? {};
        
        return fromJsonCombined(user, profileStaff, staffInfo);
      }
    }
    
    // Fallback to basic parsing
    return fromApiResponse(response);
  }

  /// Convert combined JSON data (user + profile_staff + staff_info) to UserInfo model
  static UserInfo fromJsonCombined(
    Map<String, dynamic> user,
    Map<String, dynamic> profileStaff,
    Map<String, dynamic> staffInfo,
  ) {
    return UserInfo(
      id: user["id"] ?? 0,
      isBlocked: user["is_blocked"] ?? "",
      typeApp: user["type_app"] ?? "",
      profileId: user["profile_id"] ?? profileStaff["profile_id"] ?? "",
      profileName: profileStaff["full_name"] ?? user["profile_name"] ?? "",
      name: profileStaff["full_name"] ?? user["name"] ?? "",
      email: profileStaff["email"] ?? user["email"] ?? "",
      temp: profileStaff["temp_profile"] ?? user["temp"] ?? "",
      position: profileStaff["position_id"] ?? user["position"] ?? "",
      profileImage: profileStaff["temp_profile"] ?? user["profile_image"] ?? "",
      phone: profileStaff["phone1"] ?? user["phone"] ?? "",
      isMuschangePassword: user["is_muschange_password"] ?? "",
      isNeverExpired: user["is_never_expired"] ?? "",
      isPasswordExpiredAge: user["is_password_expired_age"] ?? "",
      numberPasswordAge: user["number_password_age"] ?? "",
      lastLogin: user["last_login"] ?? "",
      loginStatus: user["login_status"] ?? "",
      createdBy: user["created_by"] ?? profileStaff["created_by"] ?? "",
      updatedBy: user["updated_by"] ?? profileStaff["updated_by"] ?? "",
      createdAt: user["created_at"] ?? profileStaff["created_at"] ?? "",
      updatedAt: user["updated_at"] ?? profileStaff["updated_at"] ?? "",
      status: user["status"] ?? profileStaff["status"] ?? "",
      backgroundCover: user["background_cover"] ?? "",
      maxUpload: user["max_upload"] ?? "",
      branchId: user["branch_id"] ?? profileStaff["branch_id"] ?? "",
      companyId: user["company_id"] ?? profileStaff["company_id"] ?? "",
      warehouseId: user["warehouse_id"] ?? "",
      officerId: user["officer_id"] ?? "",
      maxTemp: user["max_temp"] ?? "",
      mcode: user["mcode"] ?? "",
      role: user["role"] ?? "",
      proCode: user["pro_code"] ?? "",
      userName: user["user_name"] ?? profileStaff["user_name"] ?? "",
      passWord: user["pass_word"] ?? "",
      userTel: user["user_tel"] ?? "",
      eMail: user["e_mail"] ?? "",
      landing: user["landing"] ?? "",
      admin: user["admin"] ?? "",
      province: user["province"] ?? "",
      member: user["member"] ?? "",
      national: user["national"] ?? "",
      recDate: user["rec_date"] ?? "",
      verificationCode: user["verification_code"] ?? profileStaff["verification_code"] ?? "",
      verificationExpiry: user["verification_expiry"] ?? profileStaff["verification_expiry"] ?? "",
      gender: staffInfo["isMale"] ?? user["gender"] ?? "",
      hskId: user["hsk_id"] ?? "",
      dob: staffInfo["DOB"] ?? user["dob"] ?? "",
      prefix: user["prefix"] ?? "",
      voucherDate: user["voucher_date"] ?? "",
      alreadyGiveVoucher: user["already_give_voucher"] ?? "",
      cardNumber: user["card_number"] ?? "",
      fbId: profileStaff["facebook"] ?? user["fb_id"] ?? "",
      roleId: user["role_id"] ?? "",
      staffId: profileStaff["staff_id"] ?? "",
    );
  }
  
  /// Convert API response for leaves to UserInfo model
  static UserInfo fromApiResponseForLeaves(Map<String, dynamic> response) {
    // Check if response has the expected structure
    if (response.containsKey("data") && response["data"] != null) {
      final data = response["data"];
      
      // Check if data contains profile_staff object
      if (data is Map<String, dynamic> && data.containsKey("profile_staff")) {
        return fromJson2(data["profile_staff"]);
      } else {
        // Data is directly the profile_staff object
        return fromJson2(data);
      }
    }
    
    // Fallback to treating the entire response as profile_staff data
    return fromJson2(response);
  }

  /// Convert profile_staff JSON data to UserInfo model
  static UserInfo fromJson2(Map<String, dynamic> profileStaff) {
    return UserInfo(
      id: int.tryParse(profileStaff["id"]?.toString() ?? "0") ?? 0,
      isBlocked: "", // Not available in profile_staff
      typeApp: "", // Not available in profile_staff
      profileId: profileStaff["profile_id"] ?? "",
      profileName: profileStaff["full_name"] ?? "",
      name: profileStaff["full_name"] ?? "",
      email: profileStaff["email"] ?? "",
      temp: profileStaff["temp_profile"] ?? "",
      position: profileStaff["position_id"] ?? "",
      profileImage: profileStaff["temp_profile"] ?? "",
      phone: profileStaff["phone1"] ?? "",
      isMuschangePassword: "", // Not available in profile_staff
      isNeverExpired: "", // Not available in profile_staff
      isPasswordExpiredAge: "", // Not available in profile_staff
      numberPasswordAge: "", // Not available in profile_staff
      lastLogin: "", // Not available in profile_staff
      loginStatus: "", // Not available in profile_staff
      createdBy: profileStaff["created_by"] ?? "",
      updatedBy: profileStaff["updated_by"] ?? "",
      createdAt: profileStaff["created_at"] ?? "",
      updatedAt: profileStaff["updated_at"] ?? "",
      status: profileStaff["status"] ?? "",
      backgroundCover: "", // Not available in profile_staff
      maxUpload: "", // Not available in profile_staff
      branchId: profileStaff["branch_id"] ?? "",
      companyId: profileStaff["company_id"] ?? "",
      warehouseId: "", // Not available in profile_staff
      officerId: "", // Not available in profile_staff
      maxTemp: "", // Not available in profile_staff
      mcode: profileStaff["staff_id"] ?? "",
      role: "", // Not available in profile_staff
      proCode: "", // Not available in profile_staff
      userName: profileStaff["user_name"] ?? "",
      passWord: "", // Not available in profile_staff
      userTel: profileStaff["phone1"] ?? "",
      eMail: profileStaff["email"] ?? "",
      landing: "", // Not available in profile_staff
      admin: "", // Not available in profile_staff
      province: "", // Not available in profile_staff
      member: "", // Not available in profile_staff
      national: "", // Not available in profile_staff
      recDate: "", // Not available in profile_staff
      verificationCode: profileStaff["verification_code"] ?? "",
      verificationExpiry: profileStaff["verification_expiry"] ?? "",
      gender: profileStaff["title"] ?? "", // Using title as gender placeholder
      hskId: "", // Not available in profile_staff
      dob: "", // Not available in profile_staff
      prefix: profileStaff["title"] ?? "",
      voucherDate: "", // Not available in profile_staff
      alreadyGiveVoucher: "", // Not available in profile_staff
      cardNumber: "", // Not available in profile_staff
      fbId: profileStaff["facebook"] ?? "",
      roleId: "", // Not available in profile_staff
      staffId: profileStaff["staff_id"] ?? "",
    );
  }
  

  
  /// Get detailed user profile data for profile screen
  static ProfileInfo getUserProfileData(UserInfo user) {
    return ProfileInfo(
      profileId: user.profileId,
      name: user.name,
      email: user.email,
      phone: user.phone,
      profileImage: user.profileImage,
      backgroundCover: user.backgroundCover,
      gender: user.gender == "1" ? "Male" : user.gender == "2" ? "Female" : "Other",
      dob: user.dob,
      status: user.status == "1" ? "Active" : "Inactive",
      memberSince: _calculateMembershipDuration(user.createdAt),
      position: _formatPosition(user.position),
      department: null,
      managerId: null,
      managerName: user.manager,
      supervisorId: null,
      supervisorName: user.supervisor,
      branchId: user.branchId,
      branchName: null,
      companyId: user.companyId,
      companyName: null,
      employeeId: _formatEmployeeId(user.mcode, user.id),
      roleId: user.roleId,
      roleName: user.role,
      isActive: user.status == "1",
      lastLogin: user.lastLogin,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      staffId: user.staffId,
    );
  }

  /// Get full detailed user profile data for entity details screen
  static ProfileInfo getFullUserProfileData(UserInfo user) {
    return ProfileInfo(
      profileId: user.profileId,
      name: user.name,
      email: user.email,
      phone: user.phone,
      profileImage: user.profileImage,
      backgroundCover: user.backgroundCover,
      gender: _formatGender(user.gender),
      dob: _formatDate(user.dob),
      status: user.status == "1" ? "Active" : "Inactive",
      memberSince: _calculateMembershipDuration(user.createdAt),
      position: _formatPosition(user.position),
      department: null, // Could be enhanced if department data is available
      managerId: null, // Could be enhanced if manager data is available
      managerName: null, // Could be enhanced if manager data is available
      supervisorId: null, // Could be enhanced if supervisor data is available
      supervisorName: null, // Could be enhanced if supervisor data is available
      branchId: user.branchId,
      branchName: null, // Could be enhanced if branch name is available
      companyId: user.companyId,
      companyName: null, // Could be enhanced if company name is available
      employeeId: _formatEmployeeId(user.mcode, user.id),
      roleId: user.roleId,
      roleName: user.role,
      isActive: user.status == "1",
      lastLogin: user.lastLogin,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      staffId: user.staffId,
      // Extended fields - these will be populated when we have the full response
      title: null,
      firstName: null,
      lastName: null,
      nickName: null,
      phone2: null,
      address: null,
      facebook: user.fbId,
      dateOfEmployment: null,
      warehouseId: user.warehouseId,
      maxUpload: user.maxUpload,
    );
  }

  /// Get comprehensive profile data directly from API response
  static ProfileInfo getFullUserProfileDataFromResponse(Map<String, dynamic> response) {
    if (response.containsKey("data") && response["data"] != null) {
      final data = response["data"];
      
      if (data is Map<String, dynamic>) {
        final user = data["user"] ?? {};
        final profileStaff = data["profile_staff"] ?? {};
        final staffInfo = data["staff_info"] ?? {};
        
        return ProfileInfo(
          profileId: user["profile_id"] ?? profileStaff["profile_id"] ?? "",
          name: profileStaff["full_name"] ?? user["name"] ?? "",
          email: profileStaff["email"] ?? user["email"] ?? "",
          phone: profileStaff["phone1"] ?? user["phone"] ?? "",
          profileImage: profileStaff["temp_profile"] ?? user["profile_image"] ?? "",
          backgroundCover: user["background_cover"],
          gender: _formatGender(staffInfo["isMale"] ?? user["gender"] ?? ""),
          dob: _formatDate(staffInfo["DOB"] ?? user["dob"] ?? ""),
          status: user["status"] == "1" ? "Active" : "Inactive",
          memberSince: _calculateMembershipDuration(user["created_at"] ?? ""),
          position: _getPositionName(profileStaff),
          department: null,
          managerId: null,
          managerName: null,
          supervisorId: null,
          supervisorName: null,
          branchId: user["branch_id"] ?? profileStaff["branch_id"],
          branchName: null,
          companyId: user["company_id"] ?? profileStaff["company_id"],
          companyName: null,
          employeeId: _formatEmployeeId(user["mcode"], user["id"]),
          roleId: user["role_id"],
          roleName: user["role"],
          isActive: user["status"] == "1",
          lastLogin: user["last_login"],
          createdAt: user["created_at"],
          updatedAt: user["updated_at"],
          staffId: profileStaff["staff_id"],
          // Extended fields from profile_staff and staff_info
          title: _formatTitle(profileStaff["title"] ?? staffInfo["Title"]),
          firstName: profileStaff["first_name"] ?? staffInfo["FistNameEng"],
          lastName: profileStaff["last_name"] ?? staffInfo["LastNameEng"],
          nickName: profileStaff["nick_name"],
          phone2: profileStaff["phone2"],
          address: profileStaff["address"],
          facebook: profileStaff["facebook"],
          dateOfEmployment: _getEmploymentDate(profileStaff),
          warehouseId: user["warehouse_id"],
          maxUpload: user["max_upload"],
        );
      }
    }
    
    // Fallback to basic profile if parsing fails
    final userInfo = fromFullApiResponse(response);
    return getFullUserProfileData(userInfo);
  }

  /// Extract position name from profile_staff data
  static String _getPositionName(Map<String, dynamic> profileStaff) {
    // First try to get position_en directly from profile_staff
    if (profileStaff.containsKey("position_en") && profileStaff["position_en"] != null) {
      return profileStaff["position_en"].toString();
    }
    
    // Then try to get position_en from nested position object
    if (profileStaff.containsKey("position") && profileStaff["position"] != null) {
      final position = profileStaff["position"];
      if (position is Map<String, dynamic> && position.containsKey("position_en")) {
        return position["position_en"]?.toString() ?? "Not Specified";
      }
    }
    
    // Fallback to position_id formatting
    return _formatPosition(profileStaff["position_id"]);
  }

  /// Extract employment date from position data
  static String? _getEmploymentDate(Map<String, dynamic> profileStaff) {
    // First try to get date_of_employement from profile_staff
    if (profileStaff.containsKey("date_of_employement") && profileStaff["date_of_employement"] != null) {
      return _formatDate(profileStaff["date_of_employement"]);
    }
    
    // Then try to get created_at from nested position object
    if (profileStaff.containsKey("position") && profileStaff["position"] != null) {
      final position = profileStaff["position"];
      if (position is Map<String, dynamic> && position.containsKey("created_at")) {
        return _formatDate(position["created_at"]);
      }
    }
    
    // Fallback to start_date from profile_staff
    if (profileStaff.containsKey("start_date") && profileStaff["start_date"] != null) {
      return _formatDate(profileStaff["start_date"]);
    }
    
    return null;
  }

  /// Format position data with proper fallback
  static String _formatPosition(dynamic position) {
    if (position == null) return "Not Specified";
    String positionStr = position.toString();
    return positionStr.isEmpty ? "Not Specified" : positionStr;
  }
  
  /// Format employee ID with proper fallback to user ID
  static String _formatEmployeeId(String? mcode, int id) {
    if (mcode != null && mcode.isNotEmpty) {
      return mcode;
    }
    return id.toString();
  }
  
  /// Calculate how long a user has been a member
  static String _calculateMembershipDuration(String createdAtStr) {
    try {
      DateTime createdAt = DateTime.parse(createdAtStr);
      DateTime now = DateTime.now();
      int years = now.year - createdAt.year;
      int months = now.month - createdAt.month;
      
      if (months < 0) {
        years--;
        months += 12;
      }
      
      if (years > 0) {
        return "$years ${years == 1 ? 'year' : 'years'}";
      } else if (months > 0) {
        return "$months ${months == 1 ? 'month' : 'months'}";
      } else {
        return "Less than a month";
      }
    } catch (e) {
      return "Unknown";
    }
  }

  /// Format gender data with proper fallback
  static String _formatGender(String? gender) {
    if (gender == null || gender.isEmpty) return "Not Specified";
    
    // Handle numeric gender codes
    switch (gender) {
      case "1":
        return "Male";
      case "2":
        return "Female";
      default:
        return gender.isEmpty ? "Not Specified" : gender;
    }
  }
  
  /// Format date with proper fallback
  static String _formatDate(String? date) {
    if (date == null || date.isEmpty || date == "0000-00-00") {
      return "Not Available";
    }
    
    try {
      DateTime parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return date; // Return original if parsing fails
    }
  }

  /// Format title with proper fallback
  static String? _formatTitle(String? title) {
    if (title == null || title.isEmpty) return null;
    
    switch (title) {
      case "1":
        return "Mss.";
      case "2":
        return "Mr.";
      case "3":
        return "Mrs.";
      default:
        return title;
    }
  }
}