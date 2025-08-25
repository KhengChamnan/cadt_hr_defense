import 'package:flutter_test/flutter_test.dart';
import 'package:palm_ecommerce_mobile_app_2/services/holiday_service.dart';

void main() {
  group('HolidayService Tests', () {
    test('should identify weekends as holidays', () {
      // Saturday
      final saturday = DateTime(2025, 8, 23);
      expect(HolidayService.isHoliday(saturday), true);
      expect(HolidayService.isWeekend(saturday), true);

      // Sunday
      final sunday = DateTime(2025, 8, 24);
      expect(HolidayService.isHoliday(sunday), true);
      expect(HolidayService.isWeekend(sunday), true);
    });

    test('should identify weekdays as non-holidays', () {
      // Monday
      final monday = DateTime(2025, 8, 25);
      expect(HolidayService.isHoliday(monday), false);
      expect(HolidayService.isWeekend(monday), false);

      // Friday
      final friday = DateTime(2025, 8, 22);
      expect(HolidayService.isHoliday(friday), false);
      expect(HolidayService.isWeekend(friday), false);
    });

    test('should calculate working days correctly', () {
      // Thursday to Monday (includes weekend)
      final startDate = DateTime(2025, 8, 21); // Thursday
      final endDate = DateTime(2025, 8, 25);   // Monday
      
      final workingDays = HolidayService.calculateWorkingDays(startDate, endDate);
      expect(workingDays, 3); // Thursday, Friday, Monday
    });

    test('should calculate total days correctly', () {
      // Thursday to Monday
      final startDate = DateTime(2025, 8, 21); // Thursday
      final endDate = DateTime(2025, 8, 25);   // Monday
      
      final totalDays = HolidayService.calculateTotalDays(startDate, endDate);
      expect(totalDays, 5); // Thursday, Friday, Saturday, Sunday, Monday
    });

    test('should get holidays in range', () {
      // Thursday to Monday
      final startDate = DateTime(2025, 8, 21); // Thursday
      final endDate = DateTime(2025, 8, 25);   // Monday
      
      final holidays = HolidayService.getHolidaysInRange(startDate, endDate);
      expect(holidays.length, 2); // Saturday and Sunday
      expect(holidays[0].weekday, DateTime.saturday);
      expect(holidays[1].weekday, DateTime.sunday);
    });

    test('should analyze range correctly', () {
      // Thursday to Monday
      final startDate = DateTime(2025, 8, 21); // Thursday
      final endDate = DateTime(2025, 8, 25);   // Monday
      
      final analysis = HolidayService.analyzeRange(startDate, endDate);
      expect(analysis.totalDays, 5);
      expect(analysis.workingDays, 3);
      expect(analysis.holidayDays, 2);
      expect(analysis.hasHolidays, true);
      expect(analysis.holidays.length, 2);
    });

    test('should handle range with no holidays', () {
      // Tuesday to Thursday (no weekends)
      final startDate = DateTime(2025, 8, 26); // Tuesday
      final endDate = DateTime(2025, 8, 28);   // Thursday
      
      final analysis = HolidayService.analyzeRange(startDate, endDate);
      expect(analysis.totalDays, 3);
      expect(analysis.workingDays, 3);
      expect(analysis.holidayDays, 0);
      expect(analysis.hasHolidays, false);
      expect(analysis.holidays.isEmpty, true);
    });

    test('should generate holiday summary correctly', () {
      // Range with weekends
      final startDate = DateTime(2025, 8, 21); // Thursday
      final endDate = DateTime(2025, 8, 25);   // Monday
      
      final analysis = HolidayService.analyzeRange(startDate, endDate);
      final summary = analysis.getHolidaySummary();
      expect(summary, '2 weekend days included');
    });

    test('should get holiday names correctly', () {
      // Range with weekends
      final startDate = DateTime(2025, 8, 23); // Saturday
      final endDate = DateTime(2025, 8, 24);   // Sunday
      
      final analysis = HolidayService.analyzeRange(startDate, endDate);
      final holidayNames = analysis.getHolidayNames();
      expect(holidayNames.length, 2);
      expect(holidayNames[0], 'Saturday (Weekend)');
      expect(holidayNames[1], 'Sunday (Weekend)');
    });
  });
}
