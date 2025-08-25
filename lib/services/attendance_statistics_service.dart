import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';
import 'package:palm_ecommerce_mobile_app_2/data/dummydata/attendace_data.dart';

/// Service for calculating attendance statistics and pie chart data
/// Processes raw attendance data from the repository into meaningful statistics
class AttendanceStatisticsService {
  
  /// Calculates pie chart data from raw attendance records
  /// Groups attendance by date and analyzes timing patterns
  static AttendancePieChartData calculateMonthlyStats( 
    List<Attendance> attendanceRecords, {
    DateTime? targetMonth,
    TimeOfDay? expectedCheckInTime,
    int earlyThresholdMinutes = 15,
    int lateThresholdMinutes = 15,
  }) {
    final month = targetMonth ?? DateTime.now();
    // Use 8:00 AM as standard work start time (8 AM to 5 PM schedule)
    final expectedTime = expectedCheckInTime ?? const TimeOfDay(hour: 8, minute: 0);
    
    // For testing: Use dummy data instead of passed attendanceRecords
    // TODO: Replace with attendanceRecords when connecting to provider
    //final testData = AttendanceData.mockAttendanceList;
  
    
    // Filter records for the target month
    final monthlyRecords = attendanceRecords.where((record) {
      if (record.attendanceDate == null) return false;
      final recordDate = DateTime.parse(record.attendanceDate!);
      return recordDate.year == month.year && recordDate.month == month.month;
    }).toList();
    
    // Group by date and get first check-in for each day
    final Map<String, Attendance> dailyFirstCheckIn = {};
    
    for (final record in monthlyRecords) {
      if (record.inOut == 'in' && record.attendanceDate != null) {
        final date = record.attendanceDate!;
        
        if (!dailyFirstCheckIn.containsKey(date) || 
            (record.attendanceTime != null && 
             dailyFirstCheckIn[date]!.attendanceTime != null &&
             record.attendanceTime!.compareTo(dailyFirstCheckIn[date]!.attendanceTime!) < 0)) {
          dailyFirstCheckIn[date] = record;
        }
      }
    }
    
    // Analyze each day's timing
    int earlyCount = 0;
    int lateCount = 0;
    int onTimeCount = 0;
    
    for (final entry in dailyFirstCheckIn.entries) {
      final attendance = entry.value;
      if (attendance.attendanceTime == null) continue;
      
      final timing = _analyzeAttendanceTiming(
        attendance.attendanceTime!,
        expectedTime,
        earlyThresholdMinutes,
        lateThresholdMinutes,
      );
      
      switch (timing) {
        case AttendanceTimingStatus.early:
          earlyCount++;
          break;
        case AttendanceTimingStatus.late:
          lateCount++;
          break;
        case AttendanceTimingStatus.onTime:
          onTimeCount++;
          break;
      }
    }
    
    final totalDays = dailyFirstCheckIn.length;
    
    return AttendancePieChartData(
      earlyCount: earlyCount,
      lateCount: lateCount,
      onTimeCount: onTimeCount,
      totalWorkingDays: totalDays,
      monthYear: "${_getMonthName(month.month)} ${month.year}",
    );
  }
  
  /// Analyzes individual attendance timing
  static AttendanceTimingStatus _analyzeAttendanceTiming(
    String attendanceTime,
    TimeOfDay expectedTime,
    int earlyThresholdMinutes,
    int lateThresholdMinutes,
  ) {
    try {
      final timeParts = attendanceTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      final actualTime = TimeOfDay(hour: hour, minute: minute);
      final actualMinutes = actualTime.hour * 60 + actualTime.minute;
      final expectedMinutes = expectedTime.hour * 60 + expectedTime.minute;
      final difference = actualMinutes - expectedMinutes;
      
      if (difference < -earlyThresholdMinutes) {
        return AttendanceTimingStatus.early;
      } else if (difference > lateThresholdMinutes) {
        return AttendanceTimingStatus.late;
      } else {
        return AttendanceTimingStatus.onTime;
      }
    } catch (e) {
      // Default to on-time if parsing fails
      return AttendanceTimingStatus.onTime;
    }
  }
  

  
  /// Get month name from number
  static String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }


}

/// Data model for pie chart display
class AttendancePieChartData {
  final int earlyCount;
  final int lateCount;
  final int onTimeCount;
  final int totalWorkingDays;
  final String monthYear;
  
  AttendancePieChartData({
    required this.earlyCount,
    required this.lateCount,
    required this.onTimeCount,
    required this.totalWorkingDays,
    required this.monthYear,
  });
  
  /// Convert to the format expected by your pie chart widget
  List<AttendanceChartData> toChartData() {
    return [
      AttendanceChartData(
        'Early', 
        earlyCount, 
        const Color(0xFF4CAF50), 
        '${_calculatePercentage(earlyCount)}%', 
        Icons.check_circle
      ),
      AttendanceChartData(
        'Late', 
        lateCount, 
        const Color(0xFFFF928A), 
        '${_calculatePercentage(lateCount)}%', 
        Icons.watch_later
      ),
      AttendanceChartData(
        'Ontime', 
        onTimeCount, 
        const Color(0xFF3CC3DF), 
        '${_calculatePercentage(onTimeCount)}%', 
        Icons.access_time_filled
      ),
    ];
  }
  
  String _calculatePercentage(int count) {
    if (totalWorkingDays == 0) return '0.00';
    return ((count / totalWorkingDays) * 100).toStringAsFixed(2);
  }
}

/// Data model for chart items (matching your existing AttendanceData class)
class AttendanceChartData {
  final String category;
  final int value;
  final Color color;
  final String percentage;
  final IconData icon;

  AttendanceChartData(this.category, this.value, this.color, this.percentage, this.icon);
}

/// Enum for attendance timing status
enum AttendanceTimingStatus {
  early,
  onTime,
  late,
}


