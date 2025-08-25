import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';

class AttendanceData {
  // Mock attendance data for May 2023 (31 days)
  static final List<Attendance> mockAttendanceList = [
    // Week 1 (May 1-7, 2023)
    // May 1 - Monday (On time)
    Attendance(
      attendanceDate: '2023-05-01',
      attendanceTime: '08:00:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-01',
      attendanceTime: '17:00:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 2 - Tuesday (Slightly late)
    Attendance(
      attendanceDate: '2023-05-02',
      attendanceTime: '08:20:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-02',
      attendanceTime: '17:15:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 3 - Wednesday (Early arrival)
    Attendance(
      attendanceDate: '2023-05-03',
      attendanceTime: '07:45:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-03',
      attendanceTime: '17:30:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 4 - Thursday (Late arrival)
    Attendance(
      attendanceDate: '2023-05-04',
      attendanceTime: '08:45:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-04',
      attendanceTime: '17:45:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 5 - Friday (On time)
    Attendance(
      attendanceDate: '2023-05-05',
      attendanceTime: '08:05:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-05',
      attendanceTime: '17:00:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 6-7 Weekend (No attendance)
    
    // Week 2 (May 8-14, 2023)
    // May 8 - Monday (On time)
    Attendance(
      attendanceDate: '2023-05-08',
      attendanceTime: '07:58:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-08',
      attendanceTime: '17:10:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 9 - Tuesday (Very late)
    Attendance(
      attendanceDate: '2023-05-09',
      attendanceTime: '09:15:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-09',
      attendanceTime: '18:15:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 10 - Wednesday (Early)
    Attendance(
      attendanceDate: '2023-05-10',
      attendanceTime: '07:30:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-10',
      attendanceTime: '16:30:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 11 - Thursday (Sick day - no attendance)
    
    // May 12 - Friday (Late)
    Attendance(
      attendanceDate: '2023-05-12',
      attendanceTime: '08:30:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-12',
      attendanceTime: '17:30:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 13-14 Weekend (No attendance)
    
    // Week 3 (May 15-21, 2023)
    // May 15 - Monday (On time)
    Attendance(
      attendanceDate: '2023-05-15',
      attendanceTime: '08:00:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-15',
      attendanceTime: '17:00:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 16 - Tuesday (Slightly early)
    Attendance(
      attendanceDate: '2023-05-16',
      attendanceTime: '07:50:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-16',
      attendanceTime: '17:20:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 17 - Wednesday (Late)
    Attendance(
      attendanceDate: '2023-05-17',
      attendanceTime: '08:25:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-17',
      attendanceTime: '17:25:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 18 - Thursday (On time)
    Attendance(
      attendanceDate: '2023-05-18',
      attendanceTime: '08:05:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-18',
      attendanceTime: '17:05:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 19 - Friday (Very early)
    Attendance(
      attendanceDate: '2023-05-19',
      attendanceTime: '07:15:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-19',
      attendanceTime: '16:15:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 20-21 Weekend (No attendance)
    
    // Week 4 (May 22-28, 2023)
    // May 22 - Monday (Late)
    Attendance(
      attendanceDate: '2023-05-22',
      attendanceTime: '08:35:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-22',
      attendanceTime: '17:35:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 23 - Tuesday (On time)
    Attendance(
      attendanceDate: '2023-05-23',
      attendanceTime: '08:00:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-23',
      attendanceTime: '17:00:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 24 - Wednesday (Half day - early departure)
    Attendance(
      attendanceDate: '2023-05-24',
      attendanceTime: '08:10:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-24',
      attendanceTime: '13:00:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 25 - Thursday (Early)
    Attendance(
      attendanceDate: '2023-05-25',
      attendanceTime: '07:40:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-25',
      attendanceTime: '17:40:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 26 - Friday (Very late)
    Attendance(
      attendanceDate: '2023-05-26',
      attendanceTime: '09:30:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-26',
      attendanceTime: '18:30:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 27-28 Weekend (No attendance)
    
    // Week 5 (May 29-31, 2023)
    // May 29 - Monday (On time)
    Attendance(
      attendanceDate: '2023-05-29',
      attendanceTime: '08:02:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-29',
      attendanceTime: '17:02:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 30 - Tuesday (Slightly late)
    Attendance(
      attendanceDate: '2023-05-30',
      attendanceTime: '08:18:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-30',
      attendanceTime: '17:18:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    
    // May 31 - Wednesday (Early)
    Attendance(
      attendanceDate: '2023-05-31',
      attendanceTime: '07:55:00',
      inOut: 'in',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
    Attendance(
      attendanceDate: '2023-05-31',
      attendanceTime: '16:55:00',
      inOut: 'out',
      profileId: '1',
      profileName: 'Mock User',
      branchId: '1',
      status: 'present',
    ),
  ];
}