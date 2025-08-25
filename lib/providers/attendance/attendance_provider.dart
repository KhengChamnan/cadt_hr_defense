import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/abstract/attendance_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceRepository attendanceRepository;

  AsyncValue<List<Attendance>>? attendanceList;
  AsyncValue<Map<String, dynamic>>? postAttendanceStatus;

  AttendanceProvider({required this.attendanceRepository});

  Future<void> getAttendanceList() async {
    // Check if we have a valid auth token first
    try {
      final attendanceRepo = attendanceRepository as dynamic;
      if (attendanceRepo.authRepository != null) {
        final token = await attendanceRepo.authRepository.getToken();
        if (token == null || token.isEmpty) {
          print('❌ AttendanceProvider: No auth token available, skipping attendance load');
          attendanceList = AsyncValue.error(Exception('Authentication required'));
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('⚠️ AttendanceProvider: Could not check auth token: $e');
    }

    attendanceList = AsyncValue.loading();
    notifyListeners();

    try {
      final attendances = await attendanceRepository.getAttendance();
      attendanceList = AsyncValue.success(attendances);
      print('✅ AttendanceProvider: Attendance loaded successfully');
    } catch (e) {
      print('❌ AttendanceProvider: Failed to load attendance: $e');
      attendanceList = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> submitAttendance(Attendance attendance) async {
    // Check if we have a valid auth token first
    try {
      final attendanceRepo = attendanceRepository as dynamic;
      if (attendanceRepo.authRepository != null) {
        final token = await attendanceRepo.authRepository.getToken();
        if (token == null || token.isEmpty) {
          print('❌ AttendanceProvider: No auth token available for attendance submission');
          postAttendanceStatus = AsyncValue.error({'message': 'Authentication required'});
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('⚠️ AttendanceProvider: Could not check auth token for submission: $e');
    }

    postAttendanceStatus = AsyncValue.loading();
    notifyListeners();

    try {
      final responseData = await attendanceRepository.postAttendance(attendance);
      
      // Check if the response indicates success
      if (responseData['success'] == true) {
        // API request was successful
        postAttendanceStatus = AsyncValue.success(responseData);
        
        // Automatically refresh attendance list to keep data in sync
        await getAttendanceList();
        print('✅ AttendanceProvider: Attendance submitted successfully');
      } else {
        // API returned a failure response
        postAttendanceStatus = AsyncValue.error(responseData);
        print('❌ AttendanceProvider: Attendance submission failed: ${responseData['message']}');
      }
    } catch (e) {
      // Exception during API call
      postAttendanceStatus = AsyncValue.error({'message': e.toString()});
      print('❌ AttendanceProvider: Exception during attendance submission: $e');
    }
    notifyListeners();
  }
}
