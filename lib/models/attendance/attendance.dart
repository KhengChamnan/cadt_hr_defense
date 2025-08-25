

class Attendance {
  // Fields for both GET and POST
  final String? attendanceDate;
  final String? attendanceTime;
  final String? inOut;
  
  // Fields mainly for GET response
  final String? profileId;
  final String? profileName;
  final String? branchId;
  final String? status;
  
  // Fields mainly for POST request
  final int? workTypeId;
  final double? latitude;
  final double? longitude;
  final String? distant;

  Attendance({
    this.attendanceDate,
    this.attendanceTime,
    this.inOut,
    this.profileId,
    this.profileName,
    this.branchId,
    this.status,
    this.workTypeId,
    this.latitude,
    this.longitude,
    this.distant,
  });


}
