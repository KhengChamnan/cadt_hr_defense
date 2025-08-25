import '../models/attendance/attendance.dart';
import '../providers/attendance/attendance_provider.dart';
import '../providers/asyncvalue.dart';

/// Service for processing attendance data and providing business logic
/// related to attendance calculations and summaries
class AttendanceService {
  /// Calculates weekly attendance summary data for the WeeklySummaryCard
  /// for the current week
  /// 
  /// Returns a map containing:
  /// - totalHours: Total working hours for the week
  /// - attendanceRate: Attendance rate for the week (days present / workdays passed)
  /// - averageHours: Average working hours per day
  /// - absentHours: Hours marked as absent
  static Map<String, String> getWeeklySummaryData(
    AttendanceProvider provider,
    {int attendanceType = 1} // Default to Normal attendance type
  ) {
    // Default values in case of loading or error
    Map<String, String> defaultData = {
      'totalHours': '0h 0m',
      'attendanceRate': '0/0',
      'averageHours': '0h 0m',
      'absentHours': '0h 0m',
      'weekendHolidayOT': '0h 0m',
    };
    
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null) {
      return defaultData;
    }
    
    final attendanceList = provider.attendanceList!.data!;
    
    // Filter attendance records for the current week
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    
    return _calculateWeeklySummary(attendanceList, startOfWeekDate, attendanceType: attendanceType);
  }
  
  /// Calculates weekly attendance summary data for the WeeklySummaryCard
  /// based on the selected month and week number
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - monthName: The name of the month (e.g., 'January', 'February')
  /// - weekNumber: The week number in the month (1-5)
  /// - year: Optional year parameter, defaults to current year
  /// 
  /// Returns a map containing:
  /// - totalHours: Total working hours for the week
  /// - attendanceRate: Attendance rate for the week (days present / workdays passed)
  /// - averageHours: Average working hours per day
  /// - absentHours: Hours marked as absent
  static Map<String, String> getWeeklySummaryForSelectedWeek(
    AttendanceProvider provider, 
    String monthName, 
    int weekNumber, 
    int attendanceType, // Default to Normal attendance type
    {int? year}
  ) {
    // Default values in case of loading or error
    Map<String, String> defaultData = {
      'totalHours': '0h 0m',
      'attendanceRate': '0/0',
      'averageHours': '0h 0m',
      'absentHours': '0h 0m',
      'weekendHolidayOT': '0h 0m',
    };
    
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null) {
      return defaultData;
    }
    
    final attendanceList = provider.attendanceList!.data!;
    
    // Convert month name to month number
    int monthNumber = getMonthNumberFromName(monthName);
    if (monthNumber == -1) {
      return defaultData;
    }
    
    // Use current year if not specified
    final currentYear = year ?? DateTime.now().year;
    
    // Calculate the first day of the month
    final firstDayOfMonth = DateTime(currentYear, monthNumber, 1);
    
    // Calculate the first day of the requested week
    // First, find the first Monday of the month
    int daysToAdd = (8 - firstDayOfMonth.weekday) % 7;
    final firstMondayOfMonth = firstDayOfMonth.add(Duration(days: daysToAdd));
    
    // Then add (weekNumber - 1) * 7 days to get to the requested week
    final startOfWeekDate = firstMondayOfMonth.add(Duration(days: (weekNumber - 1) * 7));
    
    return _calculateWeeklySummary(attendanceList, startOfWeekDate, attendanceType: attendanceType);
  }
  
  /// Helper method to calculate weekly summary based on a start date
  static Map<String, String> _calculateWeeklySummary(
    List<Attendance> attendanceList,
    DateTime startOfWeekDate,
    {int attendanceType = 1} // Default to Normal attendance type
  ) {
    // End of the week (Sunday)
    final endOfWeekDate = startOfWeekDate.add(const Duration(days: 6));
    final now = DateTime.now();
    
    // Filter by date range and attendance type
    final weeklyAttendance = attendanceList.where((attendance) {
      if (attendance.attendanceDate == null) return false;
      
      // Filter by attendance type first
      if (attendance.workTypeId != attendanceType) return false;
      
      final attendanceDateTime = DateTime.tryParse(attendance.attendanceDate!);
      if (attendanceDateTime == null) return false;
      
      return (attendanceDateTime.isAfter(startOfWeekDate) || 
             attendanceDateTime.isAtSameMomentAs(startOfWeekDate)) &&
             (attendanceDateTime.isBefore(endOfWeekDate) || 
             attendanceDateTime.isAtSameMomentAs(endOfWeekDate));
    }).toList();
    
    // Calculate total working hours for the week
    int totalMinutes = _calculateTotalWorkingMinutes(weeklyAttendance);
    
    // Calculate weekend/holiday overtime hours for overtime type
    int weekendHolidayMinutes = 0;
    if (attendanceType == 2) { // Overtime type
      weekendHolidayMinutes = _calculateWeekendHolidayMinutes(weeklyAttendance, startOfWeekDate);
    }
    
    // Calculate standard work week (40 hours = 2400 minutes)
    
    // Calculate average working hours per day (assuming 5 working days)
    int avgMinutesPerDay = weeklyAttendance.isEmpty ? 0 : totalMinutes ~/ 5;
    
    // Calculate absent hours and attendance rate
    // Count days with no attendance records as absent
    Set<String> daysWithAttendance = {};
    for (var attendance in weeklyAttendance) {
      if (attendance.attendanceDate != null) {
        daysWithAttendance.add(attendance.attendanceDate!);
      }
    }
    
    // Count workdays (Mon-Fri) in the week that have passed
    int workdaysPassed = 0;
    for (int i = 0; i < 5; i++) {  // Monday to Friday
      final day = startOfWeekDate.add(Duration(days: i));
      // Only count days that are in the past (not including today)
      if (day.isBefore(DateTime(now.year, now.month, now.day))) {
        workdaysPassed++;
      }
    }
    
    // Calculate absent days by checking which past workdays have no attendance
    int absentDays = 0;
    for (int i = 0; i < 5; i++) {  // Monday to Friday
      final day = startOfWeekDate.add(Duration(days: i));
      // Only consider days up to yesterday (not including today or future days)
      if (day.isBefore(DateTime(now.year, now.month, now.day))) {
        // Format date as yyyy-MM-dd to match the format in attendance records
        final dayString = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
        if (!daysWithAttendance.contains(dayString)) {
          absentDays++;
        }
      }
    }
    
    int absentMinutes = absentDays * 8 * 60; // 8 hours per day
    
    // Calculate attendance rate
    String attendanceRate = workdaysPassed > 0 
        ? "${workdaysPassed - absentDays}/$workdaysPassed"
        : "0/0";
    
    // Format the results as strings in the format "XXh YYm"
    return {
      'totalHours': _formatMinutes(totalMinutes),
      'attendanceRate': attendanceRate,
      'averageHours': _formatMinutes(avgMinutesPerDay),
      'absentHours': _formatMinutes(absentMinutes),
      'weekendHolidayOT': _formatMinutes(weekendHolidayMinutes),
    };
  }
  
  /// Helper method to convert month name to month number
  static int getMonthNumberFromName(String monthName) {
    final months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    
    return months[monthName] ?? -1;
  }
  
  /// Helper method to get day name from weekday number (1-7, where 1 is Monday)
  static String getDayName(int weekday) {
    final days = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    
    return days[weekday] ?? 'Unknown';
  }
  
  /// Calculates the total working minutes from a list of attendance records
  static int _calculateTotalWorkingMinutes(List<Attendance> attendanceList) {
    // Group attendance records by date
    Map<String, List<Attendance>> attendanceByDate = {};
    
    for (var attendance in attendanceList) {
      if (attendance.attendanceDate != null) {
        if (!attendanceByDate.containsKey(attendance.attendanceDate)) {
          attendanceByDate[attendance.attendanceDate!] = [];
        }
        attendanceByDate[attendance.attendanceDate!]!.add(attendance);
      }
    }
    
    int totalMinutes = 0;
    
    // For each day, calculate working time based on first check-in and last check-out
    attendanceByDate.forEach((date, records) {
      // Sort records by time
      records.sort((a, b) {
        if (a.attendanceTime == null || b.attendanceTime == null) return 0;
        return a.attendanceTime!.compareTo(b.attendanceTime!);
      });
      
      // Find first check-in
      Attendance? firstCheckIn;
      for (var record in records) {
        if (record.inOut == 'in') {
          firstCheckIn = record;
          break;
        }
      }
      
      // Find last check-out
      Attendance? lastCheckOut;
      for (var i = records.length - 1; i >= 0; i--) {
        if (records[i].inOut == 'out') {
          lastCheckOut = records[i];
          break;
        }
      }
      
      // Calculate working minutes if both check-in and check-out exist
      if (firstCheckIn != null && lastCheckOut != null) {
        final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
        final checkOutTime = _parseTimeToMinutes(lastCheckOut.attendanceTime);
        
        if (checkInTime != null && checkOutTime != null) {
          totalMinutes += checkOutTime - checkInTime;
        }
      }
    });
    
    return totalMinutes;
  }
  
  /// Calculates weekend and holiday overtime minutes from a list of attendance records
  static int _calculateWeekendHolidayMinutes(List<Attendance> attendanceList, DateTime weekStartDate) {
    // Group attendance records by date
    Map<String, List<Attendance>> attendanceByDate = {};
    
    for (var attendance in attendanceList) {
      if (attendance.attendanceDate != null) {
        if (!attendanceByDate.containsKey(attendance.attendanceDate)) {
          attendanceByDate[attendance.attendanceDate!] = [];
        }
        attendanceByDate[attendance.attendanceDate!]!.add(attendance);
      }
    }
    
    int weekendHolidayMinutes = 0;
    
    // For each day, check if it's weekend and calculate working time
    attendanceByDate.forEach((date, records) {
      final workDate = DateTime.tryParse(date);
      if (workDate != null) {
        // Check if it's weekend (Saturday = 6, Sunday = 7)
        bool isWeekend = workDate.weekday == 6 || workDate.weekday == 7;
        // TODO: Add holiday detection here when you have holiday data
        bool isHoliday = false; // Placeholder for holiday detection
        
        if (isWeekend || isHoliday) {
          // Sort records by time
          records.sort((a, b) {
            if (a.attendanceTime == null || b.attendanceTime == null) return 0;
            return a.attendanceTime!.compareTo(b.attendanceTime!);
          });
          
          // Find first check-in
          Attendance? firstCheckIn;
          for (var record in records) {
            if (record.inOut == 'in') {
              firstCheckIn = record;
              break;
            }
          }
          
          // Find last check-out
          Attendance? lastCheckOut;
          for (var i = records.length - 1; i >= 0; i--) {
            if (records[i].inOut == 'out') {
              lastCheckOut = records[i];
              break;
            }
          }
          
          // Calculate working minutes if both check-in and check-out exist
          if (firstCheckIn != null && lastCheckOut != null) {
            final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
            final checkOutTime = _parseTimeToMinutes(lastCheckOut.attendanceTime);
            
            if (checkInTime != null && checkOutTime != null) {
              weekendHolidayMinutes += checkOutTime - checkInTime;
            }
          }
        }
      }
    });
    
    return weekendHolidayMinutes;
  }
  
  /// Parses a time string (HH:MM) to minutes since midnight
  static int? _parseTimeToMinutes(String? timeString) {
    if (timeString == null) return null;
    
    final parts = timeString.split(':');
    if (parts.length < 2) return null;
    
    try {
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      return hours * 60 + minutes;
    } catch (e) {
      return null;
    }
  }
  
  /// Formats minutes as "XXh YYm"
  static String _formatMinutes(int minutes) {
    int hours = minutes ~/ 60;
    int mins = minutes % 60;
    return '${hours}h ${mins}m';
  }
  
  /// Calculates attendance data for weekly attendance cards
  /// Returns a list of maps containing data for each day of the week
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - weekStartDate: The start date of the week
  /// - attendanceType: Type of attendance (1: Normal, 2: Overtime, 3: Part Time)
  static List<Map<String, String?>> getWeeklyAttendanceCardData(
    AttendanceProvider provider,
    DateTime weekStartDate,
    {int attendanceType = 1} // Default to Normal attendance type
  ) {
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null) {
      return _generateEmptyWeekData(weekStartDate);
    }
    
    final attendanceList = provider.attendanceList!.data!;
    final now = DateTime.now();
    
    // Initialize result list for 7 days of the week
    List<Map<String, String?>> weekData = [];
    
    // Process each day of the week
    for (int i = 0; i < 7; i++) {
      final currentDate = weekStartDate.add(Duration(days: i));
      final dateString = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";
      final formattedDate = "${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}";
      
      // Get day name (Mon, Tue, etc.)
      final dayName = getDayName(currentDate.weekday);
      
      // Filter attendance records for this day and by attendance type
      final dayAttendance = attendanceList.where((attendance) => 
        attendance.attendanceDate == dateString && 
        attendance.workTypeId == attendanceType
      ).toList();
      
      if (dayAttendance.isEmpty) {
        // No attendance records for this day
        Map<String, String?> dayData = {
          'day': dayName,
          'date': formattedDate,
          'checkInTime': null,
          'checkOutTime': null,
          'totalHours': currentDate.weekday > 5 ? 'Off' : '0h 0m',
          'status': currentDate.weekday > 5 ? 'Day off' : 
                    (currentDate.isAfter(now) ? 'Upcoming' : 'Absent'),
        };
        weekData.add(dayData);
      } else {
        // Find first check-in and last check-out
        Attendance? firstCheckIn;
        Attendance? lastCheckOut;
        
        // Sort records by time
        dayAttendance.sort((a, b) {
          if (a.attendanceTime == null || b.attendanceTime == null) return 0;
          return a.attendanceTime!.compareTo(b.attendanceTime!);
        });
        
        // Find first check-in
        for (var record in dayAttendance) {
          if (record.inOut == 'in') {
            firstCheckIn = record;
            break;
          }
        }
        
        // Find last check-out
        for (var i = dayAttendance.length - 1; i >= 0; i--) {
          if (dayAttendance[i].inOut == 'out') {
            lastCheckOut = dayAttendance[i];
            break;
          }
        }
        
        // Calculate working time
        int workingMinutes = 0;
        if (firstCheckIn != null && lastCheckOut != null) {
          final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
          final checkOutTime = _parseTimeToMinutes(lastCheckOut.attendanceTime);
          
          if (checkInTime != null && checkOutTime != null) {
            workingMinutes = checkOutTime - checkInTime;
          }
        }
        
        // Determine status based on check-in time
        String status = 'Present';
        if (firstCheckIn != null && firstCheckIn.attendanceTime != null) {
          final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
          if (checkInTime != null) {
            // Assuming standard work hours start at 8:00 AM (480 minutes)
            if (checkInTime <= 480) {
              status = 'On Time';
            } else {
              status = 'Late';
            }
          }
        }
        
        // Format check-in and check-out times for display
        String? formattedCheckIn = firstCheckIn?.attendanceTime != null ? 
                                 _formatTimeForDisplay(firstCheckIn!.attendanceTime!) : null;
        String? formattedCheckOut = lastCheckOut?.attendanceTime != null ? 
                                  _formatTimeForDisplay(lastCheckOut!.attendanceTime!) : null;
        
        Map<String, String?> dayData = {
          'day': dayName,
          'date': formattedDate,
          'checkInTime': formattedCheckIn,
          'checkOutTime': formattedCheckOut,
          'totalHours': _formatMinutes(workingMinutes),
          'status': status,
        };
        weekData.add(dayData);
      }
    }
    
    return weekData;
  }
  
  /// Helper method to generate empty week data when no attendance data is available
  static List<Map<String, String?>> _generateEmptyWeekData(DateTime weekStartDate) {
    List<Map<String, String?>> emptyWeek = [];
    
    for (int i = 0; i < 7; i++) {
      final currentDate = weekStartDate.add(Duration(days: i));
      final formattedDate = "${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}";
      
      emptyWeek.add({
        'day': getDayName(currentDate.weekday),
        'date': formattedDate,
        'checkInTime': null,
        'checkOutTime': null,
        'totalHours': currentDate.weekday > 5 ? 'Off' : '0h 0m',
        'status': currentDate.weekday > 5 ? 'Day off' : 'Upcoming',
      });
    }
    
    return emptyWeek;
  }
  
  /// Helper method to format time string for display (HH:MM AM/PM)
  static String _formatTimeForDisplay(String timeString) {
    final parts = timeString.split(':');
    if (parts.length < 2) return timeString;
    
    try {
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      
      String period = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12;
      if (hours == 0) hours = 12;
      
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeString;
    }
  }
  
  /// Calculates monthly report data for charts
  /// 
  /// Returns a list of five lists containing:
  /// - Working hours data for each month
  /// - Late hours data for each month
  /// - Absent hours data for each month
  /// - Early hours data for each month
  /// - On-time hours data for each month
  static List<List<double>> getMonthlyReportData(AttendanceProvider provider, {int attendanceType = 1, int? year}) {
    // Get current year if not specified
    final int selectedYear = year ?? DateTime.now().year;
    final now = DateTime.now();
    
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null || 
        provider.attendanceList!.data!.isEmpty) {
      
      // Return zeros when no data is available
      return [
        // Working hours data (zeros)
        List.filled(12, 0.0),
        // Late hours data (zeros)
        List.filled(12, 0.0),
        // Absent hours data (zeros)
        List.filled(12, 0.0),
        // Early hours data (zeros)
        List.filled(12, 0.0),
        // On-time hours data (zeros)
        List.filled(12, 0.0),
      ];
    }
    
    final attendanceList = provider.attendanceList!.data!;
    
    // Skip future years completely
    if (selectedYear > now.year) {
      return [
        List.filled(12, 0.0),
        List.filled(12, 0.0),
        List.filled(12, 0.0),
        List.filled(12, 0.0),
        List.filled(12, 0.0),
      ];
    }
      // Initialize result arrays
    List<double> workingHours = List.filled(12, 0.0);
    List<double> absentHours = List.filled(12, 0.0);
    List<double> weekendWorkHours = List.filled(12, 0.0);
    List<double> holidayWorkHours = List.filled(12, 0.0);

    // Group attendance records by month and filter by attendance type
    Map<int, List<Attendance>> attendanceByMonth = {};
    for (var attendance in attendanceList) {
      if (attendance.attendanceDate != null && attendance.workTypeId == attendanceType) {
        final attendanceDate = DateTime.tryParse(attendance.attendanceDate!);
        if (attendanceDate != null && attendanceDate.year == selectedYear) {
          int month = attendanceDate.month - 1; // 0-based index for months
          if (!attendanceByMonth.containsKey(month)) {
            attendanceByMonth[month] = [];
          }
          attendanceByMonth[month]!.add(attendance);
        }
      }
    }

    // If no attendance data found for any month, return appropriate zeros based on type
    if (attendanceByMonth.isEmpty) {
      if (attendanceType == 1) {
        return [
          List.filled(12, 0.0), // Working hours
          List.filled(12, 0.0), // Late hours
          List.filled(12, 0.0), // Absent hours
          List.filled(12, 0.0), // Early hours
          List.filled(12, 0.0), // On-time hours
        ];
      } else if (attendanceType == 2) {
        return [
          List.filled(12, 0.0), // Working hours
          List.filled(12, 0.0), // Weekend work hours
          List.filled(12, 0.0), // Holiday work hours
        ];
      } else {
        return [
          List.filled(12, 0.0), // Working hours only
        ];
      }
    }

    // Calculate working hours for each month
    for (int month = 0; month < 12; month++) {
      // Skip future months in current year
      if (selectedYear == now.year && month > now.month - 1) {
        continue;
      }
      
      if (attendanceByMonth.containsKey(month)) {
        final monthAttendance = attendanceByMonth[month]!;
        
        // Group attendance records by date
        Map<String, List<Attendance>> attendanceByDate = {};
        for (var attendance in monthAttendance) {
          if (attendance.attendanceDate != null) {
            if (!attendanceByDate.containsKey(attendance.attendanceDate)) {
              attendanceByDate[attendance.attendanceDate!] = [];
            }
            attendanceByDate[attendance.attendanceDate!]!.add(attendance);
          }
        }
        
        int totalMinutes = 0;
        int weekendMinutes = 0;
        int holidayMinutes = 0;
        
        // For each day, calculate working time based on first check-in and last check-out
        attendanceByDate.forEach((date, records) {
          // Sort records by time
          records.sort((a, b) {
            if (a.attendanceTime == null || b.attendanceTime == null) return 0;
            return a.attendanceTime!.compareTo(b.attendanceTime!);
          });
          
          // Find first check-in
          Attendance? firstCheckIn;
          for (var record in records) {
            if (record.inOut == 'in') {
              firstCheckIn = record;
              break;
            }
          }
          
          // Find last check-out
          Attendance? lastCheckOut;
          for (var i = records.length - 1; i >= 0; i--) {
            if (records[i].inOut == 'out') {
              lastCheckOut = records[i];
              break;
            }
          }
          
          // Calculate working minutes if both check-in and check-out exist
          if (firstCheckIn != null && lastCheckOut != null) {
            final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
            final checkOutTime = _parseTimeToMinutes(lastCheckOut.attendanceTime);
            
            if (checkInTime != null && checkOutTime != null) {
              int dailyMinutes = checkOutTime - checkInTime;
              totalMinutes += dailyMinutes;
              
              // Check if it's weekend or holiday work (for overtime type)
              if (attendanceType == 2) { // Overtime type
                final workDate = DateTime.tryParse(date);
                if (workDate != null) {
                  if (workDate.weekday == 6 || workDate.weekday == 7) {
                    // Weekend work
                    weekendMinutes += dailyMinutes;
                  }
                  // Note: Holiday detection would require a holiday list
                  // For now, we'll leave holiday minutes as 0
                  // You can implement holiday detection based on your holiday data
                }
              }
            }
          }
        });
        
        // Calculate absent days and hours for this month (only for normal attendance)
        if (attendanceType == 1) { // Normal attendance type
          final actualMonth = month + 1; // Adjust for 0-based indexing
          final daysInMonth = DateTime(selectedYear, actualMonth + 1, 0).day;
          
          // Create a Set of dates with attendance records for this attendance type
          Set<String> daysWithAttendance = {};
          for (var attendance in monthAttendance) {
            if (attendance.attendanceDate != null) {
              daysWithAttendance.add(attendance.attendanceDate!);
            }
          }
          
          // Count workdays (Mon-Fri) in the month that have passed
          int absentDays = 0;
          for (int day = 1; day <= daysInMonth; day++) {
            final date = DateTime(selectedYear, actualMonth, day);
            
            // Only count weekdays (Mon-Fri) that are in the past (not including today)
            if (date.weekday <= 5 && date.isBefore(DateTime(now.year, now.month, now.day))) {
              // Format date as yyyy-MM-dd to match attendance records
              final dayString = "${selectedYear}-${actualMonth.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
              if (!daysWithAttendance.contains(dayString)) {
                absentDays++;
              }
            }
          }
          
          absentHours[month] = absentDays * 8.0; // 8 hours per absent day
        }
        
        // Convert to hours
        workingHours[month] = totalMinutes / 60;
        weekendWorkHours[month] = weekendMinutes / 60;
        holidayWorkHours[month] = holidayMinutes / 60;
      }
    }

    // Return data based on attendance type
    if (attendanceType == 1) {
      // Normal attendance: return working hours, late hours, absent hours, early hours, on-time hours
      List<double> lateHours = getMonthlyLateHours(provider, selectedYear, attendanceType: attendanceType);
      List<double> earlyHours = getMonthlyEarlyHours(provider, selectedYear, attendanceType: attendanceType);
      List<double> onTimeHours = getMonthlyOnTimeHours(provider, selectedYear, attendanceType: attendanceType);
      
      return [workingHours, lateHours, absentHours, earlyHours, onTimeHours];
    } else if (attendanceType == 2) {
      // Overtime: return total working hours, weekend work hours, holiday work hours
      return [workingHours, weekendWorkHours, holidayWorkHours];
    } else {
      // Part-time or other types: return only total working hours
      return [workingHours];
    }
  }
  
  /// Calculates yearly report data for charts
  /// 
  /// Returns a list of lists containing:
  /// - Working hours data for each year
  /// - Late hours data for each year (for normal attendance)
  /// - Absent hours data for each year (for normal attendance)
  /// - Early hours data for each year (for normal attendance)
  /// - On-time hours data for each year (for normal attendance)
  /// - Weekend work hours data for each year (for overtime attendance)
  /// - Holiday work hours data for each year (for overtime attendance)
  static List<List<double>> getYearlyReportData(AttendanceProvider provider, {int attendanceType = 1, required List<int> yearRangeList}) {
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null) {
      // Return appropriate empty data based on attendance type
      if (attendanceType == 1) {
        return [
          List.filled(yearRangeList.length, 0.0), // Working hours
          List.filled(yearRangeList.length, 0.0), // Late hours
          List.filled(yearRangeList.length, 0.0), // Absent hours
          List.filled(yearRangeList.length, 0.0), // Early hours
          List.filled(yearRangeList.length, 0.0), // On-time hours
        ];
      } else if (attendanceType == 2) {
        return [
          List.filled(yearRangeList.length, 0.0), // Working hours
          List.filled(yearRangeList.length, 0.0), // Weekend work hours
          List.filled(yearRangeList.length, 0.0), // Holiday work hours
        ];
      } else {
        return [
          List.filled(yearRangeList.length, 0.0), // Working hours only for part-time
        ];
      }
    }
    
    // Initialize result arrays based on attendance type
    List<double> workingHours = List.filled(yearRangeList.length, 0.0);
    List<double> lateHours = List.filled(yearRangeList.length, 0.0);
    List<double> absentHours = List.filled(yearRangeList.length, 0.0);
    List<double> earlyHours = List.filled(yearRangeList.length, 0.0);
    List<double> onTimeHours = List.filled(yearRangeList.length, 0.0);
    List<double> weekendWorkHours = List.filled(yearRangeList.length, 0.0);
    List<double> holidayWorkHours = List.filled(yearRangeList.length, 0.0);
    
    // Calculate data for each year in the range
    for (int i = 0; i < yearRangeList.length; i++) {
      final year = yearRangeList[i];
      
      // Get monthly report data for this year
      final monthlyData = getMonthlyReportData(provider, attendanceType: attendanceType, year: year);
      
      if (monthlyData.isNotEmpty) {
        // Sum up all monthly data to get yearly totals
        workingHours[i] = monthlyData[0].reduce((a, b) => a + b);
        
        if (attendanceType == 1) {
          // Normal attendance: include late, absent, early, on-time hours
          if (monthlyData.length > 1) lateHours[i] = monthlyData[1].reduce((a, b) => a + b);
          if (monthlyData.length > 2) absentHours[i] = monthlyData[2].reduce((a, b) => a + b);
          if (monthlyData.length > 3) earlyHours[i] = monthlyData[3].reduce((a, b) => a + b);
          if (monthlyData.length > 4) onTimeHours[i] = monthlyData[4].reduce((a, b) => a + b);
        } else if (attendanceType == 2) {
          // Overtime attendance: include weekend and holiday work hours
          if (monthlyData.length > 1) weekendWorkHours[i] = monthlyData[1].reduce((a, b) => a + b);
          if (monthlyData.length > 2) holidayWorkHours[i] = monthlyData[2].reduce((a, b) => a + b);
        }
        // Part-time (attendanceType == 3) only has working hours
      }
    }
    
    // Return data based on attendance type
    if (attendanceType == 1) {
      return [workingHours, lateHours, absentHours, earlyHours, onTimeHours];
    } else if (attendanceType == 2) {
      return [workingHours, weekendWorkHours, holidayWorkHours];
    } else {
      return [workingHours];
    }
  }
  
  /// Calculates late hours for a given month and year
  /// Late hours are calculated as the difference between standard start time (8:00 AM)
  /// and the actual first check-in time for each day
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - month: The month number (1-12)
  /// - year: The year
  /// - attendanceType: Type of attendance to filter by
  /// 
  /// Returns the total late hours for the specified month and year in hours (as double)
  static double calculateLateHours(AttendanceProvider provider, int month, int year, {int attendanceType = 1}) {
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null) {
      return 0.0;
    }
    
    final attendanceList = provider.attendanceList!.data!;
    
    // Filter attendance records for the specified month, year and attendance type
    final monthAttendance = attendanceList.where((attendance) {
      if (attendance.attendanceDate == null) return false;
      if (attendance.workTypeId != attendanceType) return false;
      
      final attendanceDate = DateTime.tryParse(attendance.attendanceDate!);
      if (attendanceDate == null) return false;
      
      return attendanceDate.year == year && attendanceDate.month == month;
    }).toList();
    
    if (monthAttendance.isEmpty) {
      return 0.0;
    }
    
    // Group attendance records by date
    Map<String, List<Attendance>> attendanceByDate = {};
    
    for (var attendance in monthAttendance) {
      if (attendance.attendanceDate != null) {
        if (!attendanceByDate.containsKey(attendance.attendanceDate)) {
          attendanceByDate[attendance.attendanceDate!] = [];
        }
        attendanceByDate[attendance.attendanceDate!]!.add(attendance);
      }
    }
    
    int totalLateMinutes = 0;
    
    // Standard start time: 8:00 AM = 480 minutes
    const int standardStartTimeInMinutes = 8 * 60; // 480 minutes
    
    // Calculate late minutes for each day
    attendanceByDate.forEach((date, records) {
      // Sort records by time
      records.sort((a, b) {
        if (a.attendanceTime == null || b.attendanceTime == null) return 0;
        return a.attendanceTime!.compareTo(b.attendanceTime!);
      });
      
      // Find first check-in
      Attendance? firstCheckIn;
      for (var record in records) {
        if (record.inOut == 'in' && record.attendanceTime != null) {
          firstCheckIn = record;
          break;
        }
      }
      
      // Calculate late minutes if first check-in exists
      if (firstCheckIn != null && firstCheckIn.attendanceTime != null) {
        final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
        
        if (checkInTime != null && checkInTime > standardStartTimeInMinutes) {
          // Calculate how many minutes late (check-in time minus standard start time)
          int lateMinutes = checkInTime - standardStartTimeInMinutes;
          totalLateMinutes += lateMinutes;
        }
      }
    });
    
    // Convert minutes to hours
    return totalLateMinutes / 60.0;
  }
  
  /// Calculates total late hours for each month of a specific year
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - year: The year to calculate late hours for
  /// - attendanceType: Type of attendance to filter by
  /// 
  /// Returns a list of late hours for each month (indexed 0-11 for Jan-Dec)
  static List<double> getMonthlyLateHours(AttendanceProvider provider, int year, {int attendanceType = 1}) {
    List<double> monthlyLateHours = List.filled(12, 0.0);
    
    for (int month = 1; month <= 12; month++) {
      monthlyLateHours[month - 1] = calculateLateHours(provider, month, year, attendanceType: attendanceType);
    }
    
    return monthlyLateHours;
  }
  
  /// Calculates early hours for a given month and year
  /// Early hours are calculated as the difference between standard start time (8:00 AM)
  /// and the actual first check-in time when an employee arrives early
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - month: The month number (1-12)
  /// - year: The year
  /// - attendanceType: Type of attendance to filter by
  /// 
  /// Returns the total early hours for the specified month and year in hours (as double)
  static double calculateEarlyHours(AttendanceProvider provider, int month, int year, {int attendanceType = 1}) {
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null) {
      return 0.0;
    }
    
    final attendanceList = provider.attendanceList!.data!;
    
    // Filter attendance records for the specified month, year and attendance type
    final monthAttendance = attendanceList.where((attendance) {
      if (attendance.attendanceDate == null) return false;
      if (attendance.workTypeId != attendanceType) return false;
      
      final attendanceDate = DateTime.tryParse(attendance.attendanceDate!);
      if (attendanceDate == null) return false;
      
      return attendanceDate.year == year && attendanceDate.month == month;
    }).toList();
    
    if (monthAttendance.isEmpty) {
      return 0.0;
    }
    
    // Group attendance records by date
    Map<String, List<Attendance>> attendanceByDate = {};
    
    for (var attendance in monthAttendance) {
      if (attendance.attendanceDate != null) {
        if (!attendanceByDate.containsKey(attendance.attendanceDate)) {
          attendanceByDate[attendance.attendanceDate!] = [];
        }
        attendanceByDate[attendance.attendanceDate!]!.add(attendance);
      }
    }
    
    int totalEarlyMinutes = 0;
    
    // Standard start time: 8:00 AM = 480 minutes
    const int standardStartTimeInMinutes = 8 * 60; // 480 minutes
    
    // Calculate early minutes for each day
    attendanceByDate.forEach((date, records) {
      // Sort records by time
      records.sort((a, b) {
        if (a.attendanceTime == null || b.attendanceTime == null) return 0;
        return a.attendanceTime!.compareTo(b.attendanceTime!);
      });
      
      // Find first check-in
      Attendance? firstCheckIn;
      for (var record in records) {
        if (record.inOut == 'in' && record.attendanceTime != null) {
          firstCheckIn = record;
          break;
        }
      }
      
      // Calculate early minutes if first check-in exists and is before standard start time
      if (firstCheckIn != null && firstCheckIn.attendanceTime != null) {
        final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
        
        if (checkInTime != null && checkInTime < standardStartTimeInMinutes) {
          // Calculate how many minutes early (standard start time minus check-in time)
          int earlyMinutes = standardStartTimeInMinutes - checkInTime;
          totalEarlyMinutes += earlyMinutes;
        }
      }
    });
    
    // Convert minutes to hours
    return totalEarlyMinutes / 60.0;
  }
  
  /// Calculates total early hours for each month of a specific year
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - year: The year to calculate early hours for
  /// - attendanceType: Type of attendance to filter by
  /// 
  /// Returns a list of early hours for each month (indexed 0-11 for Jan-Dec)
  static List<double> getMonthlyEarlyHours(AttendanceProvider provider, int year, {int attendanceType = 1}) {
    List<double> monthlyEarlyHours = List.filled(12, 0.0);
    
    for (int month = 1; month <= 12; month++) {
      monthlyEarlyHours[month - 1] = calculateEarlyHours(provider, month, year, attendanceType: attendanceType);
    }
    
    return monthlyEarlyHours;
  }
  
  /// Calculates on-time hours for a given month and year
  /// On-time hours are calculated when an employee arrives exactly at 8:00 AM
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - month: The month number (1-12)
  /// - year: The year
  /// - attendanceType: Type of attendance to filter by
  /// 
  /// Returns the total on-time hours for the specified month and year in hours (as double)
  static double calculateOnTimeHours(AttendanceProvider provider, int month, int year, {int attendanceType = 1}) {
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null) {
      return 0.0;
    }
    
    final attendanceList = provider.attendanceList!.data!;
    
    // Filter attendance records for the specified month, year and attendance type
    final monthAttendance = attendanceList.where((attendance) {
      if (attendance.attendanceDate == null) return false;
      if (attendance.workTypeId != attendanceType) return false;
      
      final attendanceDate = DateTime.tryParse(attendance.attendanceDate!);
      if (attendanceDate == null) return false;
      
      return attendanceDate.year == year && attendanceDate.month == month;
    }).toList();
    
    if (monthAttendance.isEmpty) {
      return 0.0;
    }
    
    // Group attendance records by date
    Map<String, List<Attendance>> attendanceByDate = {};
    
    for (var attendance in monthAttendance) {
      if (attendance.attendanceDate != null) {
        if (!attendanceByDate.containsKey(attendance.attendanceDate)) {
          attendanceByDate[attendance.attendanceDate!] = [];
        }
        attendanceByDate[attendance.attendanceDate!]!.add(attendance);
      }
    }
    
    int totalOnTimeMinutes = 0;
    
    // Standard start time: 8:00 AM = 480 minutes
    const int standardStartTimeInMinutes = 8 * 60; // 480 minutes
    
    // Calculate on-time minutes for each day
    attendanceByDate.forEach((date, records) {
      // Sort records by time
      records.sort((a, b) {
        if (a.attendanceTime == null || b.attendanceTime == null) return 0;
        return a.attendanceTime!.compareTo(b.attendanceTime!);
      });
      
      // Find first check-in
      Attendance? firstCheckIn;
      for (var record in records) {
        if (record.inOut == 'in' && record.attendanceTime != null) {
          firstCheckIn = record;
          break;
        }
      }
      
      // Find last check-out
      Attendance? lastCheckOut;
      for (var i = records.length - 1; i >= 0; i--) {
        if (records[i].inOut == 'out' && records[i].attendanceTime != null) {
          lastCheckOut = records[i];
          break;
        }
      }
      
      // Calculate on-time working minutes if check-in is exactly at 8:00 AM
      if (firstCheckIn != null && lastCheckOut != null) {
        final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
        final checkOutTime = _parseTimeToMinutes(lastCheckOut.attendanceTime);
        
        if (checkInTime != null && checkOutTime != null) {
          if (checkInTime == standardStartTimeInMinutes) {
            // On-time arrival (exactly at 8:00 AM)
            totalOnTimeMinutes += (checkOutTime - checkInTime);
          }
        }
      }
    });
    
    // Convert minutes to hours
    return totalOnTimeMinutes / 60.0;
  }
  
  /// Calculates total on-time hours for each month of a specific year
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - year: The year to calculate on-time hours for
  /// - attendanceType: Type of attendance to filter by
  /// 
  /// Returns a list of on-time hours for each month (indexed 0-11 for Jan-Dec)
  static List<double> getMonthlyOnTimeHours(AttendanceProvider provider, int year, {int attendanceType = 1}) {
    List<double> monthlyOnTimeHours = List.filled(12, 0.0);
    
    for (int month = 1; month <= 12; month++) {
      monthlyOnTimeHours[month - 1] = calculateOnTimeHours(provider, month, year, attendanceType: attendanceType);
    }
    
    return monthlyOnTimeHours;
  }
  
  /// Gets all attendance data formatted for display in cards
  /// Returns a list of maps containing attendance information for each day with records
  /// 
  /// Parameters:
  /// - provider: The attendance provider containing attendance data
  /// - attendanceType: Type of attendance (1: Normal, 2: Overtime, 3: Part Time)
  static List<Map<String, String?>> getAllAttendanceCardData(
    AttendanceProvider provider,
    {int attendanceType = 1} // Default to Normal attendance type
  ) {
    // Check if attendance data is available and loaded successfully
    if (provider.attendanceList == null || 
        provider.attendanceList!.state != AsyncValueState.success || 
        provider.attendanceList!.data == null) {
      return [];
    }
    
    final attendanceList = provider.attendanceList!.data!;
    
    // Filter attendance records by attendance type and group by date
    Map<String, List<Attendance>> groupedByDate = {};
    
    for (var attendance in attendanceList) {
      if (attendance.workTypeId == attendanceType && attendance.attendanceDate != null) {
        final dateKey = attendance.attendanceDate!;
        if (!groupedByDate.containsKey(dateKey)) {
          groupedByDate[dateKey] = [];
        }
        groupedByDate[dateKey]!.add(attendance);
      }
    }
    
    // Convert grouped data to card format
    List<Map<String, String?>> allData = [];
    
    // Sort dates in descending order (newest first)
    var sortedDates = groupedByDate.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    for (String dateString in sortedDates) {
      final dayAttendance = groupedByDate[dateString]!;
      
      // Parse date for formatting
      final dateParts = dateString.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);
      final formattedDate = "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
      
      // Sort records by time
      dayAttendance.sort((a, b) {
        if (a.attendanceTime == null || b.attendanceTime == null) return 0;
        return a.attendanceTime!.compareTo(b.attendanceTime!);
      });
      
      // Find first check-in and last check-out
      Attendance? firstCheckIn;
      Attendance? lastCheckOut;
      
      // Find first check-in
      for (var record in dayAttendance) {
        if (record.inOut == 'in') {
          firstCheckIn = record;
          break;
        }
      }
      
      // Find last check-out
      for (var i = dayAttendance.length - 1; i >= 0; i--) {
        if (dayAttendance[i].inOut == 'out') {
          lastCheckOut = dayAttendance[i];
          break;
        }
      }
      
      // Calculate working time
      int workingMinutes = 0;
      if (firstCheckIn != null && lastCheckOut != null) {
        final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
        final checkOutTime = _parseTimeToMinutes(lastCheckOut.attendanceTime);
        
        if (checkInTime != null && checkOutTime != null) {
          workingMinutes = checkOutTime - checkInTime;
        }
      }
      
      // Determine status based on check-in time
      String status = 'Present';
      if (firstCheckIn != null && firstCheckIn.attendanceTime != null) {
        final checkInTime = _parseTimeToMinutes(firstCheckIn.attendanceTime);
        if (checkInTime != null) {
          // Assuming standard work hours start at 8:00 AM (480 minutes)
          if (checkInTime <= 480) {
            status = 'On Time';
          } else {
            status = 'Late';
          }
        }
      }
      
      // Format check-in and check-out times for display
      String? formattedCheckIn = firstCheckIn?.attendanceTime != null ? 
                               _formatTimeForDisplay(firstCheckIn!.attendanceTime!) : null;
      String? formattedCheckOut = lastCheckOut?.attendanceTime != null ? 
                                _formatTimeForDisplay(lastCheckOut!.attendanceTime!) : null;
      
      Map<String, String?> dayData = {
        'date': formattedDate,
        'checkInTime': formattedCheckIn,
        'checkOutTime': formattedCheckOut,
        'totalHours': _formatMinutes(workingMinutes),
        'status': status,
      };
      allData.add(dayData);
    }
    
    return allData;
  }
}