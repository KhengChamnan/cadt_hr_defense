/// API Endpoints
/// Contains all the API endpoints used in the application
class ApiEndpoints {
  // Auth endpoints
  static const String login = "/api/login";
  static const String registerDeviceToken = "/api/device-token";
  
  // User endpoints
  static const String userProfile = "/api/user-profile";
  static const String userInfo = "/api/user-info";

  // Location endpoints
  static const String getUserLocation = "/api/get-user-location";
  static const String deleteLocation = "/api/delete-location";
  static const String getAddressTypes = "/api/get-address-type";
  
  // Notification endpoints
  static const String getAllNotifications = "/api/get-all-notification";
  
  // Help Settings endpoints
  static const String getSettings = "/api/get-help/B0006";



  // Attendance endpoints
  static const String getAttendance = "/api/attendance_list";
  static const String postAttendance = "/api/attendance";

  // Leaves endpoints
  static const String leaves = "/api/submit-leave";
  static const String getLeaves = "/api/leave_list";

  //Approval endpoints
  static const String getApproval = "/api/approvals/dashboard";
  static const String supervisorApproval = "/api/approvals/supervisor-action";
  static const String managerApproval = "/api/approvals/manager-action";
}