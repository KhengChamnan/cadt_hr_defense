# Weekly Attendance Service Documentation

This document explains how to use the `WeeklyAttendanceService` to calculate and display weekly attendance data in your Flutter HR application.

## Overview

The service consists of three main components:

1. **WeeklyAttendanceService** - Core calculation logic
2. **WeeklyAttendance Model** - Data structures for weekly attendance
3. **WeeklyAttendanceProvider** - State management integration

## Files Created

- `lib/services/weekly_attendance_service.dart` - Main service class
- `lib/models/attendance/weekly_attendance.dart` - Data models
- `lib/providers/attendance/weekly_attendance_provider.dart` - Provider integration
- `lib/examples/weekly_attendance_example.dart` - Example implementation

## Integration with Existing AttendanceProvider

You can extend your existing `AttendanceProvider` to include weekly calculations:

```dart
// Add to your existing AttendanceProvider
import 'package:palm_ecommerce_mobile_app_2/services/weekly_attendance_service.dart';
import 'package:palm_ecommerce_mobile_app_2/models/attendance/weekly_attendance.dart';

class AttendanceProvider extends ChangeNotifier {
  // ... existing code ...
  
  // Add weekly attendance state
  AsyncValue<WeeklyAttendance>? weeklyAttendance;
  int currentWeek = 1;
  String currentMonth = 'June';

  // Add method to calculate weekly data
  Future<void> calculateWeeklyAttendance({int? week, String? month}) async {
    if (week != null) currentWeek = week;
    if (month != null) currentMonth = month;
    
    weeklyAttendance = AsyncValue.loading();
    notifyListeners();

    try {
      // Use existing attendanceList data
      if (attendanceList?.data != null) {
        final targetDate = _calculateTargetWeekDate(currentWeek, currentMonth);
        
        final weekly = WeeklyAttendance.fromAttendanceRecords(
          attendanceList!.data!,
          targetWeek: targetDate,
        );
        
        weeklyAttendance = AsyncValue.success(weekly);
      }
    } catch (e) {
      weeklyAttendance = AsyncValue.error(e);
    }
    
    notifyListeners();
  }

  // Helper method to calculate target week date
  DateTime _calculateTargetWeekDate(int week, String month) {
    final monthNumber = _monthNameToNumber(month);
    final year = DateTime.now().year;
    final firstDayOfMonth = DateTime(year, monthNumber, 1);
    final firstWeekStart = WeeklyAttendanceService.getWeekStart(firstDayOfMonth, 1);
    return firstWeekStart.add(Duration(days: (week - 1) * 7));
  }

  int _monthNameToNumber(String monthName) {
    const months = {
      'January': 1, 'February': 2, 'March': 3, 'April': 4,
      'May': 5, 'June': 6, 'July': 7, 'August': 8,
      'September': 9, 'October': 10, 'November': 11, 'December': 12
    };
    return months[monthName] ?? 6; // Default to June
  }
}
```

## Usage in Weekly Screen Widget

Update your `WeeklyScreen` to use the service:

```dart
// In your weekly_screen.dart
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/attendance/attendance_provider.dart';

class WeeklyScreen extends StatefulWidget {
  const WeeklyScreen({Key? key}) : super(key: key);

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load attendance data and calculate weekly summary
      final provider = context.read<AttendanceProvider>();
      provider.getAttendanceList().then((_) {
        provider.calculateWeeklyAttendance();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PalmSpacings.m),
              
              // Weekly Summary Card - using calculated data
              _buildWeeklySummaryCard(provider),
              
              const SizedBox(height: PalmSpacings.xl),
              
              // Daily Attendance List - using calculated data
              _buildDailyAttendance(provider),
              
              const SizedBox(height: PalmSpacings.xl),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeklySummaryCard(AttendanceProvider provider) {
    if (provider.weeklyAttendance?.data == null) {
      return const WeeklySummaryCard(); // Your existing static card
    }

    final weeklyData = provider.weeklyAttendance!.data!;
    final summary = weeklyData.summary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.l),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(PalmSpacings.s),
        decoration: BoxDecoration(
          color: PalmColors.secondary,
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 15,
            ),
          ],
        ),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: PalmSpacings.s,
          mainAxisSpacing: PalmSpacings.s,
          childAspectRatio: 1.3,
          padding: EdgeInsets.zero,
          children: [
            InfoCard(
              title: 'Working Hours\nThis Week',
              value: summary.formattedTotalHours,
              subtitle: 'of ${summary.formattedExpectedHours}',
              iconData: Icons.access_time_outlined,
            ),
            InfoCard(
              title: 'Overtime',
              value: summary.formattedOvertimeHours,
              iconData: Icons.trending_up,
            ),
            InfoCard(
              title: 'Attendance Rate',
              value: summary.formattedAttendanceRateFraction,
              subtitle: '${summary.formattedAttendanceRate}',
              iconData: Icons.check_circle_outline,
            ),
            InfoCard(
              title: 'Average Hours',
              value: summary.formattedAverageHours,
              subtitle: 'per day',
              iconData: Icons.bar_chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyAttendance(AttendanceProvider provider) {
    if (provider.weeklyAttendance?.data == null) {
      // Fallback to your existing static data
      return _buildStaticDailyAttendance();
    }

    final dailyRecords = provider.weeklyAttendance!.data!.dailyRecords;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: PalmSpacings.m),
          
          // Weekly attendance cards
          ...dailyRecords.map((record) {
            return Padding(
              padding: const EdgeInsets.only(bottom: PalmSpacings.s),
              child: WeeklyAttendanceCard(
                day: record.dayName,
                date: record.formattedDate,
                checkInTime: record.checkInTime,
                checkOutTime: record.checkOutTime,
                status: record.status.displayName,
                totalHours: record.totalHoursDisplay,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStaticDailyAttendance() {
    // Your existing static implementation
    // ...
  }
}
```

## Week Navigation

Add week navigation methods to your `AttendanceTabContent`:

```dart
// In attendance_tab_content.dart
class _AttendanceTabContentState extends State<AttendanceTabContent> {
  // ... existing code ...

  void _navigateWeek(bool isNext) {
    if (widget.tabIndex == 0) { // Weekly tab
      final provider = context.read<AttendanceProvider>();
      
      if (isNext) {
        // Next week logic
        if (_currentWeek < 4) { // Assuming 4 weeks per month max
          setState(() {
            _currentWeek++;
          });
        } else {
          // Next month, week 1
          setState(() {
            _currentWeek = 1;
            _currentMonth = _getNextMonth(_currentMonth);
          });
        }
      } else {
        // Previous week logic
        if (_currentWeek > 1) {
          setState(() {
            _currentWeek--;
          });
        } else {
          // Previous month, last week
          setState(() {
            _currentMonth = _getPreviousMonth(_currentMonth);
            _currentWeek = 4; // Assuming 4 weeks per month
          });
        }
      }
      
      // Recalculate weekly data
      provider.calculateWeeklyAttendance(
        week: _currentWeek, 
        month: _currentMonth
      );
    }
  }

  String _getNextMonth(String currentMonth) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December'];
    final currentIndex = months.indexOf(currentMonth);
    return months[(currentIndex + 1) % 12];
  }

  String _getPreviousMonth(String currentMonth) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                   'July', 'August', 'September', 'October', 'November', 'December'];
    final currentIndex = months.indexOf(currentMonth);
    return months[(currentIndex - 1 + 12) % 12];
  }
}
```

## Key Features

### 1. Automatic Calculations
- **Total Working Hours**: Sum of all hours worked in the week
- **Overtime Hours**: Hours worked beyond standard 8-hour days
- **Attendance Rate**: Percentage of working days attended
- **Average Hours**: Average hours worked per attended day
- **Absent Hours**: Expected hours minus actual hours worked

### 2. Status Detection
- **On Time**: Check-in within 15 minutes of 8:00 AM
- **Late**: Check-in more than 15 minutes after 8:00 AM
- **Early**: Check-in more than 15 minutes before 8:00 AM
- **Day Off**: Weekend days
- **Absent**: Working days with no check-in

### 3. Data Formatting
- Hours displayed as "8h 30m" format
- Attendance rates as both percentages and fractions
- Consistent date formatting across components

### 4. Flexible Configuration
- Configurable work start/end times
- Adjustable early/late thresholds
- Customizable week start day (Monday/Sunday)

## Error Handling

The service includes comprehensive error handling:

```dart
// Error states are handled through AsyncValue
if (provider.weeklyAttendance?.state == AsyncValueState.error) {
  return Column(
    children: [
      Text('Failed to calculate weekly attendance'),
      ElevatedButton(
        onPressed: () => provider.calculateWeeklyAttendance(),
        child: Text('Retry'),
      ),
    ],
  );
}
```

## Testing

You can test the service with mock data:

```dart
// Create test attendance records
final testRecords = [
  Attendance(
    attendanceDate: '2025-06-23', // Monday
    attendanceTime: '08:30:00',
    inOut: 'in',
  ),
  Attendance(
    attendanceDate: '2025-06-23',
    attendanceTime: '17:30:00',
    inOut: 'out',
  ),
  // Add more test records...
];

// Calculate weekly summary
final summary = WeeklyAttendanceService.calculateWeeklySummary(testRecords);
print('Total hours: ${summary.formattedTotalHours}');
print('Attendance rate: ${summary.formattedAttendanceRate}');
```

## Benefits

1. **Centralized Logic**: All weekly calculations in one service
2. **Type Safety**: Strongly typed models and enums
3. **Reusable**: Can be used across multiple screens
4. **Testable**: Pure functions that are easy to unit test
5. **Consistent**: Uniform data formatting across the app
6. **Extensible**: Easy to add new calculations or modify existing ones

This service provides a robust foundation for weekly attendance tracking while integrating seamlessly with your existing provider pattern and UI components.
