import '../../models/staff/staff_info.dart';

class StaffDto {
  static StaffInfo fromJson(Map<String, dynamic> json) {
    // Extract staff_info from the nested response structure
    final staffInfoData = json['data']?['staff_info'];
    if (staffInfoData == null) {
      throw Exception('staff_info not found in response');
    }

    return StaffInfo(
      staffId: staffInfoData['StaffID'] ?? '',
      firstNameEng: staffInfoData['FirstNameEng'],
      lastNameEng: staffInfoData['LastNameEng'],
      firstNameKh: staffInfoData['FirstNameKh'],
      lastNameKh: staffInfoData['LastNameKh'],
      email: staffInfoData['email'],
      phone: staffInfoData['Phone'],
      positionId: staffInfoData['PositionID'],
      branchCode: staffInfoData['BranchCode'],
      balanceAnnually: staffInfoData['balance_annually'],
      balanceSick: staffInfoData['balance_sick'],
      balanceSpecial: staffInfoData['balance_special'],
      manager: staffInfoData['manager'] != null
          ? _managerFromJson(staffInfoData['manager'])
          : null,
      supervisor: staffInfoData['supervisor'] != null
          ? _supervisorFromJson(staffInfoData['supervisor'])
          : null,
    );
  }

  static Map<String, dynamic> toJson(StaffInfo staffInfo) {
    return {
      'StaffID': staffInfo.staffId,
      'FirstNameEng': staffInfo.firstNameEng,
      'LastNameEng': staffInfo.lastNameEng,
      'FirstNameKh': staffInfo.firstNameKh,
      'LastNameKh': staffInfo.lastNameKh,
      'email': staffInfo.email,
      'Phone': staffInfo.phone,
      'PositionID': staffInfo.positionId,
      'BranchCode': staffInfo.branchCode,
      'balance_annually': staffInfo.balanceAnnually,
      'balance_sick': staffInfo.balanceSick,
      'balance_special': staffInfo.balanceSpecial,
      'manager': staffInfo.manager != null
          ? _managerToJson(staffInfo.manager!)
          : null,
      'supervisor': staffInfo.supervisor != null
          ? _supervisorToJson(staffInfo.supervisor!)
          : null,
    };
  }

  static StaffInfo parseStaffResponse(Map<String, dynamic> response) {
    return fromJson(response);
  }

  // Private helper methods for manager conversion
  static StaffManager _managerFromJson(Map<String, dynamic> json) {
    return StaffManager(
      staffId: json['StaffID'] ?? '',
      firstNameEng: json['FirstNameEng'],
      lastNameEng: json['LastNameEng'],
      firstNameKh: json['FirstNameKh'],
      lastNameKh: json['LastNameKh'],
      email: json['email'],
      phone: json['Phone'],
      positionId: json['PositionID'],
      branchCode: json['BranchCode'],
    );
  }

  static Map<String, dynamic> _managerToJson(StaffManager manager) {
    return {
      'StaffID': manager.staffId,
      'FirstNameEng': manager.firstNameEng,
      'LastNameEng': manager.lastNameEng,
      'FirstNameKh': manager.firstNameKh,
      'LastNameKh': manager.lastNameKh,
      'email': manager.email,
      'Phone': manager.phone,
      'PositionID': manager.positionId,
      'BranchCode': manager.branchCode,
    };
  }

  // Private helper methods for supervisor conversion
  static StaffSupervisor _supervisorFromJson(Map<String, dynamic> json) {
    return StaffSupervisor(
      staffId: json['StaffID'] ?? '',
      firstNameEng: json['FirstNameEng'],
      lastNameEng: json['LastNameEng'],
      firstNameKh: json['FirstNameKh'],
      lastNameKh: json['LastNameKh'],
      email: json['email'],
      phone: json['Phone'],
      positionId: json['PositionID'],
      branchCode: json['BranchCode'],
    );
  }

  static Map<String, dynamic> _supervisorToJson(StaffSupervisor supervisor) {
    return {
      'StaffID': supervisor.staffId,
      'FirstNameEng': supervisor.firstNameEng,
      'LastNameEng': supervisor.lastNameEng,
      'FirstNameKh': supervisor.firstNameKh,
      'LastNameKh': supervisor.lastNameKh,
      'email': supervisor.email,
      'Phone': supervisor.phone,
      'PositionID': supervisor.positionId,
      'BranchCode': supervisor.branchCode,
    };
  }
}
