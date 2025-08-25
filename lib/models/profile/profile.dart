/// Simple profile data class with only essential information
class ProfileInfo {
  final String name;
  final String? profileId;
  final String email;
  final String phone;
  final String profileImage;
  final String? backgroundCover;
  final String gender;
  final String dob;
  final String status;
  final String memberSince;
  // Additional fields for UI
  final dynamic position;
  final String? department;
  final dynamic managerId;
  final String? managerName;
  final dynamic supervisorId;
  final String? supervisorName;
  final String? branchId;
  final String? branchName;
  final String? companyId;
  final String? companyName;
  final String? employeeId;
  final String? staffId;
  final dynamic roleId;
  final dynamic roleName;
  final bool isActive;
  final String? lastLogin;
  final String? createdAt;
  final String? updatedAt;
  // Extended fields for comprehensive details
  final String? title;
  final String? firstName;
  final String? lastName;
  final String? nickName;
  final String? phone2;
  final String? address;
  final String? facebook;
  final String? dateOfEmployment;
  final String? warehouseId;
  final String? maxUpload;

  ProfileInfo({
    required this.profileId,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    this.backgroundCover,
    required this.gender,
    required this.dob,
    required this.status,
    required this.memberSince,
    // Additional fields for UI
    this.position,
    this.department,
    this.managerId,
    this.managerName,
    this.supervisorId,
    this.supervisorName,
    this.branchId,
    this.branchName,
    this.companyId,
    this.companyName,
    this.employeeId,
    this.staffId,
    this.roleId,
    this.roleName,
    this.isActive = false,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
    // Extended fields
    this.title,
    this.firstName,
    this.lastName,
    this.nickName,
    this.phone2,
    this.address,
    this.facebook,
    this.dateOfEmployment,
    this.warehouseId,
    this.maxUpload,
  });
}