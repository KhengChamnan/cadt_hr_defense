import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/attendance/monthly_screen/monthly_screen.dart';
import '../weekly_screen/weekly_screen.dart';
import '../yearly_report/yearly_screen.dart';
import '../all_screen/all_screen.dart';
import 'date_range_selector.dart';
import 'date_selector.dart';
import 'selection_dialogs.dart';

class AttendanceTabContent extends StatefulWidget {
  final int tabIndex;
  final int attendanceType; // Type of attendance (1: Normal, 2: Overtime, 3: Part Time)
  
  const AttendanceTabContent({
    super.key,
    required this.tabIndex,
    required this.attendanceType,
  });

  @override
  State<AttendanceTabContent> createState() => _AttendanceTabContentState();
}

class _AttendanceTabContentState extends State<AttendanceTabContent> {
  // Weekly tab state
  String _currentMonth = '';
  int _currentWeek = 1;
  
  // Monthly tab state
  int _currentYear = DateTime.now().year;
  
  // Yearly tab state
  String _yearRange = '${DateTime.now().year - 4} - ${DateTime.now().year}';
  
  @override
  void initState() {
    super.initState();
    _resetValues();
  }
  
  @override
  void didUpdateWidget(AttendanceTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If tab changed, reset values for that tab
    if (oldWidget.tabIndex != widget.tabIndex) {
      _resetValues();
    }
  }
  
  /// Helper function to calculate the current week of the month
  /// Returns a value between 1-4 (or 5 depending on the month)
  int _getCurrentWeekOfMonth() {
    final DateTime now = DateTime.now();
    final int day = now.day;
    
    // Simple calculation based on day of month
    // Week 1: days 1-7, Week 2: days 8-14, Week 3: days 15-21, Week 4: days 22-28, Week 5: days 29-31
    return ((day - 1) ~/ 7) + 1;
  }
  

  
  /// Helper function to get max weeks in a specific month
  int _getMaxWeeksInSpecificMonth(int month, int year) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return ((lastDay - 1) ~/ 7) + 1; // Will return 5 for months with 29+ days
  }
  
  /// Helper function to get max weeks for the currently selected month
  int _getMaxWeeksForCurrentSelection() {
    int monthNumber = SelectionDialogs.getMonthNumber(_currentMonth);
    return _getMaxWeeksInSpecificMonth(monthNumber, _currentYear);
  }
  
  /// Helper function to get the current month name
  String _getCurrentMonthName() {
    return SelectionDialogs.getMonthName(DateTime.now().month);
  }
  
  void _resetValues() {
    // Reset to default values based on current tab
    if (widget.tabIndex == 1) { // Weekly tab (now case 1)
      _currentMonth = _getCurrentMonthName();
      _currentWeek = _getCurrentWeekOfMonth();
    } else if (widget.tabIndex == 2) { // Monthly tab (now case 2)
      _currentYear = DateTime.now().year;
    } else if (widget.tabIndex == 3) { // Yearly tab (now case 3)
      final int currentYear = DateTime.now().year;
      _yearRange = '${currentYear - 4} - $currentYear';
    }
    // Case 0 (All tab) doesn't need any reset values
  }

  @override
  Widget build(BuildContext context) {
    // First build the date selector based on the tab
    Widget dateSelector = _buildSelector();
    
    // Then build the content for the selected tab
    Widget content = _buildContent();
    
    // Return the combined layout
    return Column(
      children: [
        dateSelector,
        Expanded(child: content),
      ],
    );
  }
  
  Widget _buildSelector() {
    switch (widget.tabIndex) {
      case 0: // All
        // Return empty widget for All screen (no date selector needed)
        return const SizedBox.shrink();
        
      case 1: // Weekly
        int maxWeeks = _getMaxWeeksForCurrentSelection();
        
        return DateSelector(
          mainText: 'Week $_currentWeek of ',
          dropdownText: _currentMonth,
          onPrevious: () {
            setState(() {
              if (_currentWeek > 1) {
                _currentWeek--;
              } else {
                // Get max weeks for the current month
                _currentWeek = maxWeeks;
              }
            });
          },
          onNext: () {
            setState(() {
              // Ensure we don't exceed max weeks for the current month
              if (_currentWeek < maxWeeks) {
                _currentWeek++;
              } else {
                _currentWeek = 1;
              }
            });
          },
          onDropdownTap: () => _showMonthPicker(),
        );
        
      case 2: // Monthly
        // Return empty widget to remove month selector for Monthly screen
        return const SizedBox.shrink();
        
      case 3: // Yearly
        return DateRangeSelector(
          rangeText: _yearRange,
          onRangeSelected: (range) {
            setState(() {
              _yearRange = range;
            });
          },
        );
        
      default:
        return const SizedBox.shrink();
    }
  }
  
  void _showMonthPicker() {
    SelectionDialogs.showMonthPicker(
      context: context,
      currentMonth: _currentMonth,
      onMonthSelected: (month) {
        setState(() {
          // Save old month first to handle month change
          String oldMonth = _currentMonth;
          _currentMonth = month;
          
          // Get the month number from the month name
          int monthNumber = SelectionDialogs.getMonthNumber(month);
          
          // Calculate max weeks for the selected month and adjust current week if needed
          int maxWeeks = _getMaxWeeksInSpecificMonth(monthNumber, _currentYear);
          
          // Always reset to week 1 when changing months, or cap at max weeks
          // This ensures February never shows week 5
          if (oldMonth != month) {
            _currentWeek = _currentWeek > maxWeeks ? maxWeeks : _currentWeek;
          }
        });
      },
    );
  }
  
  
  
  Widget _buildContent() {
    switch (widget.tabIndex) {
      case 0:
        return AllScreen(
          attendanceType: widget.attendanceType,
        );
      case 1:
        return WeeklyScreen(
          selectedMonth: _currentMonth,
          selectedWeek: _currentWeek,
          selectedYear: _currentYear,
          attendanceType: widget.attendanceType,
        );
      case 2:
        return MonthlyScreen(
          attendanceType: widget.attendanceType,
        );
      case 3:
        return YearlyScreen(
          yearRange: _yearRange,
          attendanceType: widget.attendanceType,
        );
      default:
        return AllScreen(
          attendanceType: widget.attendanceType,
        );
    }
  }
}