class StaffInfo {
  final String staffId;
  final String? firstNameEng;
  final String? lastNameEng;
  final String? firstNameKh;
  final String? lastNameKh;
  final String? email;
  final String? phone;
  final String? positionId;
  final String? branchCode;
  final String? balanceAnnually;
  final String? balanceSick;
  final String? balanceSpecial;
  final StaffManager? manager;
  final StaffSupervisor? supervisor;

  StaffInfo({
    required this.staffId,
    this.firstNameEng,
    this.lastNameEng,
    this.firstNameKh,
    this.lastNameKh,
    this.email,
    this.phone,
    this.positionId,
    this.branchCode,
    this.balanceAnnually,
    this.balanceSick,
    this.balanceSpecial,
    this.manager,
    this.supervisor,
  });

  
  @override
  String toString() {
    return 'StaffInfo{staffId: $staffId, firstName: $firstNameEng, email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffInfo &&
          runtimeType == other.runtimeType &&
          staffId == other.staffId;

  @override
  int get hashCode => staffId.hashCode;
}

class StaffManager {
  final String staffId;
  final String? firstNameEng;
  final String? lastNameEng;
  final String? firstNameKh;
  final String? lastNameKh;
  final String? email;
  final String? phone;
  final String? positionId;
  final String? branchCode;

  StaffManager({
    required this.staffId,
    this.firstNameEng,
    this.lastNameEng,
    this.firstNameKh,
    this.lastNameKh,
    this.email,
    this.phone,
    this.positionId,
    this.branchCode,
  });

 
  @override
  String toString() {
    return 'StaffManager{staffId: $staffId, firstName: $firstNameEng, email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffManager &&
          runtimeType == other.runtimeType &&
          staffId == other.staffId;

  @override
  int get hashCode => staffId.hashCode;
}

class StaffSupervisor {
  final String staffId;
  final String? firstNameEng;
  final String? lastNameEng;
  final String? firstNameKh;
  final String? lastNameKh;
  final String? email;
  final String? phone;
  final String? positionId;
  final String? branchCode;

  StaffSupervisor({
    required this.staffId,
    this.firstNameEng,
    this.lastNameEng,
    this.firstNameKh,
    this.lastNameKh,
    this.email,
    this.phone,
    this.positionId,
    this.branchCode,
  });

 
  @override
  String toString() {
    return 'StaffSupervisor{staffId: $staffId, firstName: $firstNameEng, email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffSupervisor &&
          runtimeType == other.runtimeType &&
          staffId == other.staffId;

  @override
  int get hashCode => staffId.hashCode;
}
