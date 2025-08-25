import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/attendance/attendance_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/attendance/weekly_screen/widgets/weekly_summary_card.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/attendance/weekly_screen/widgets/weekly_attendance_card.dart';
import '../../../services/attendance_service.dart';
import '../../../theme/app_theme.dart';

class WeeklyScreen extends StatefulWidget {
  final String? selectedMonth;
  final int? selectedWeek;
  final int? selectedYear;
  final int attendanceType; // Type of attendance (1: Normal, 2: Overtime, 3: Part Time)
  
  const WeeklyScreen({
    super.key, 
    this.selectedMonth,
    this.selectedWeek,
    this.selectedYear,
    required this.attendanceType,
  });

  @override
  State<WeeklyScreen> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> with SingleTickerProviderStateMixin {
  late String currentMonth;
  late int currentWeek;
  late int currentYear;
  late TabController _tabController;
  String _currentFilter = 'All';

  @override
  void initState() {
    super.initState();
    _updateValues();
    
    // Initialize tab controller with animation duration
    _tabController = TabController(length: 4, vsync: this, animationDuration: const Duration(milliseconds: 200));
    
    // Fetch attendance data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
      if (attendanceProvider.attendanceList == null) {
        attendanceProvider.getAttendanceList();
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(WeeklyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth ||
        oldWidget.selectedWeek != widget.selectedWeek ||
        oldWidget.selectedYear != widget.selectedYear) {
      _updateValues();
    }
  }
  
  void _updateValues() {
    // Use provided values or defaults
    currentMonth = widget.selectedMonth ?? 'June';
    currentWeek = widget.selectedWeek ?? 1;
    currentYear = widget.selectedYear ?? DateTime.now().year;
  }
  
  // Calculate the start date of the selected week
  DateTime _getWeekStartDate() {
    // Convert month name to month number
    int monthNumber = AttendanceService.getMonthNumberFromName(currentMonth);
    
    // Calculate the first day of the month
    final firstDayOfMonth = DateTime(currentYear, monthNumber, 1);
    
    // Calculate the first Monday of the month
    int daysToAdd = (8 - firstDayOfMonth.weekday) % 7;
    final firstMondayOfMonth = firstDayOfMonth.add(Duration(days: daysToAdd));
    
    // Calculate the start of the selected week
    return firstMondayOfMonth.add(Duration(days: (currentWeek - 1) * 7));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: PalmSpacings.m),
          WeeklySummaryCard(
            attendanceType: widget.attendanceType,
            monthName: currentMonth,
            weekNumber: currentWeek,
            year: currentYear,
          ),
          const SizedBox(height: PalmSpacings.xl),
          _buildFilterTabs(),
          const SizedBox(height: PalmSpacings.m),
          _buildDailyAttendance(),
          // Add bottom padding for scrolling
          const SizedBox(height: PalmSpacings.xl),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 40,
      // Removed horizontal margin to allow full width
      decoration: BoxDecoration(
        color: PalmColors.greyLight,
        borderRadius: BorderRadius.circular(0), // No border radius for full-width appearance
      ),
      child: Material(
        color: Colors.transparent,
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: PalmColors.primary,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: PalmColors.dark,
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.symmetric(horizontal: 4),
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  _currentFilter = 'All';
                  break;
                case 1:
                  _currentFilter = 'Late';
                  break;
                case 2:
                  _currentFilter = 'Early';
                  break;
                case 3:
                  _currentFilter = 'On Time';
                  break;
              }
            });
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Late'),
            Tab(text: 'Early'),
            Tab(text: 'On Time'),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyAttendance() {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final weekStartDate = _getWeekStartDate();
    final isLoading = attendanceProvider.attendanceList?.state == AsyncValueState.loading;
    
    // Generate fake data for skeleton loading
    final List<Map<String, String>> skeletonData = List.generate(5, (index) {
      final day = DateTime.now().add(Duration(days: index));
      return {
        'day': AttendanceService.getDayName(day.weekday),
        'date': '${day.day}/${day.month}/${day.year}',
        'checkInTime': '09:00 AM',
        'checkOutTime': '05:00 PM',
        'status': index % 3 == 0 ? 'Early' : (index % 3 == 1 ? 'Late' : 'On time'),
        'totalHours': '8h 0m',
      };
    });
    
    // Get weekly attendance data using the new service function
    final weeklyData = isLoading 
        ? skeletonData 
        : AttendanceService.getWeeklyAttendanceCardData(
            attendanceProvider,
            weekStartDate,
            attendanceType: widget.attendanceType,
          );
    
    // Filter the data based on the selected tab
    final filteredData = _currentFilter == 'All' 
        ? weeklyData 
        : weeklyData.where((dayData) => 
            dayData['status'] == _currentFilter || 
            (_currentFilter == 'On Time' && dayData['status'] == 'On time')).toList();
    
    // Removed horizontal padding to allow full width cards
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Reduced top spacing
        const SizedBox(height: PalmSpacings.s),
        
        // Weekly attendance cards
        filteredData.isEmpty 
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: PalmSpacings.xl),
                  child: Text(
                    'No $_currentFilter attendance records found',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            : Column(
                children: filteredData.map((dayData) {
                  // Removed Padding wrapper to eliminate spacing between cards
                  return WeeklyAttendanceCard(
                    day: dayData['day']!,
                    date: dayData['date'],
                    checkInTime: dayData['checkInTime'],
                    checkOutTime: dayData['checkOutTime'],
                    status: dayData['status']!,
                    totalHours: dayData['totalHours']!,
                  );
                }).toList(),
              ),
      ],
    );
  }
}
