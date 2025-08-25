/// A service class to handle holiday detection and business logic
/// Currently supports weekends (Saturday and Sunday) as standard holidays
/// Can be extended to support custom holidays, public holidays, etc.
class HolidayService {
  static const List<int> _weekendDays = [DateTime.saturday, DateTime.sunday];
  
  /// Check if a given date is a holiday (weekend for now)
  static bool isHoliday(DateTime date) {
    return _weekendDays.contains(date.weekday);
  }

  /// Check if a given date is a weekend
  static bool isWeekend(DateTime date) {
    return _weekendDays.contains(date.weekday);
  }

  /// Get all holiday dates within a given date range
  static List<DateTime> getHolidaysInRange(DateTime startDate, DateTime endDate) {
    final holidays = <DateTime>[];
    
    for (DateTime date = startDate; 
         date.isBefore(endDate.add(const Duration(days: 1))); 
         date = date.add(const Duration(days: 1))) {
      if (isHoliday(date)) {
        holidays.add(date);
      }
    }
    
    return holidays;
  }

  /// Calculate working days excluding holidays within a date range
  static int calculateWorkingDays(DateTime startDate, DateTime endDate) {
    int totalDays = 0;
    
    for (DateTime date = startDate; 
         date.isBefore(endDate.add(const Duration(days: 1))); 
         date = date.add(const Duration(days: 1))) {
      if (!isHoliday(date)) {
        totalDays++;
      }
    }
    
    return totalDays;
  }

  /// Calculate holiday days within a date range
  static int calculateHolidayDays(DateTime startDate, DateTime endDate) {
    int holidayDays = 0;
    
    for (DateTime date = startDate; 
         date.isBefore(endDate.add(const Duration(days: 1))); 
         date = date.add(const Duration(days: 1))) {
      if (isHoliday(date)) {
        holidayDays++;
      }
    }
    
    return holidayDays;
  }

  /// Get total days including holidays
  static int calculateTotalDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1;
  }

  /// Check if a date range contains any holidays
  static bool hasHolidaysInRange(DateTime startDate, DateTime endDate) {
    for (DateTime date = startDate; 
         date.isBefore(endDate.add(const Duration(days: 1))); 
         date = date.add(const Duration(days: 1))) {
      if (isHoliday(date)) {
        return true;
      }
    }
    return false;
  }

  /// Get holiday analysis for a date range
  static HolidayAnalysis analyzeRange(DateTime startDate, DateTime endDate) {
    final totalDays = calculateTotalDays(startDate, endDate);
    final workingDays = calculateWorkingDays(startDate, endDate);
    final holidayDays = calculateHolidayDays(startDate, endDate);
    final holidays = getHolidaysInRange(startDate, endDate);
    
    return HolidayAnalysis(
      startDate: startDate,
      endDate: endDate,
      totalDays: totalDays,
      workingDays: workingDays,
      holidayDays: holidayDays,
      holidays: holidays,
      hasHolidays: holidays.isNotEmpty,
    );
  }

  /// Get day name for display
  static String getDayName(DateTime date) {
    const dayNames = [
      'Monday',
      'Tuesday', 
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return dayNames[date.weekday - 1];
  }

  /// Get holiday type name
  static String getHolidayTypeName(DateTime date) {
    if (isWeekend(date)) {
      return 'Weekend';
    }
    // Can be extended for other holiday types
    return 'Holiday';
  }
}

/// Class to hold holiday analysis results
class HolidayAnalysis {
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final int workingDays;
  final int holidayDays;
  final List<DateTime> holidays;
  final bool hasHolidays;

  const HolidayAnalysis({
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.workingDays,
    required this.holidayDays,
    required this.holidays,
    required this.hasHolidays,
  });

  /// Get formatted holiday summary
  String getHolidaySummary() {
    if (!hasHolidays) {
      return 'No holidays in selected range';
    }
    
    final weekendCount = holidays.where((date) => HolidayService.isWeekend(date)).length;
    
    if (weekendCount == holidayDays) {
      return '$weekendCount weekend day${weekendCount > 1 ? 's' : ''} included';
    }
    
    return '$holidayDays holiday${holidayDays > 1 ? 's' : ''} included';
  }

  /// Get list of holiday names for display
  List<String> getHolidayNames() {
    return holidays.map((date) {
      final dayName = HolidayService.getDayName(date);
      final holidayType = HolidayService.getHolidayTypeName(date);
      return '$dayName ($holidayType)';
    }).toList();
  }
}
