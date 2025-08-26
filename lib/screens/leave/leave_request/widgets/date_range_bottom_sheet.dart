import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/animations_util.dart';
import 'package:palm_ecommerce_mobile_app_2/services/holiday_service.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/staff/staff_provder.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

/// A bottom sheet modal for date range selection with slide-up animation
/// This provides a modern mobile UX for date selection
class DateRangeBottomSheet {
  /// Show the date range picker as a bottom sheet modal
  static Future<Map<String, DateTime>?> show(
    BuildContext context, {
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await showModalBottomSheet<Map<String, DateTime>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateRangeBottomSheetContent(
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }

  /// Show the date range picker with custom bottom-to-top animation
  static Future<Map<String, DateTime>?> showWithAnimation(
    BuildContext context, {
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return await Navigator.push<Map<String, DateTime>>(
      context,
      AnimationUtils.createBottomToTopRoute(
        _DateRangeFullScreen(
          initialStartDate: initialStartDate,
          initialEndDate: initialEndDate,
          firstDate: firstDate,
          lastDate: lastDate,
        ),
      ),
    );
  }
}

/// The content widget for the date range bottom sheet
class DateRangeBottomSheetContent extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DateRangeBottomSheetContent({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<DateRangeBottomSheetContent> createState() =>
      _DateRangeBottomSheetContentState();
}

class _DateRangeBottomSheetContentState
    extends State<DateRangeBottomSheetContent>
    with SingleTickerProviderStateMixin {
  DateTime? _startDate;
  DateTime? _endDate;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;

    // Set up slide animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Handle continue button - close modal and return selected dates
  void _onContinue() {
    if (_startDate != null) {
      Navigator.pop(context, {
        'startDate': _startDate!,
        'endDate': _endDate ??
            _startDate!, // Use start date as end date if no end date selected
      });
    }
  }

  /// Handle cancel button - close modal without returning dates
  void _onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _startDate != null; // Can continue with just start date
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, screenHeight * (1 - _animation.value)),
          child: Container(
            height: screenHeight * 0.85, // Take up 85% of screen height
            decoration: BoxDecoration(
              color: PalmColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(PalmSpacings.l),
                topRight: Radius.circular(PalmSpacings.l),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: PalmSpacings.s),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PalmColors.greyLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                _buildHeader(),

                // Calendar content (custom calendar matching the image)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      PalmSpacings.m,
                      PalmSpacings.m,
                      PalmSpacings.m,
                      0,
                    ),
                    child: Column(
                      children: [
                        _buildCustomCalendar(),
                        // Add some bottom padding to ensure content doesn't touch the button
                        const SizedBox(height: PalmSpacings.m),
                      ],
                    ),
                  ),
                ),

                // Bottom action bar (fixed at bottom)
                _buildBottomActionBar(canContinue),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build the header section
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white,
        border: Border(
          bottom: BorderSide(
            color: PalmColors.greyLight.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with X icon button
          Row(
            children: [
              IconButton(
                onPressed: _onCancel,
                icon: Icon(
                  Icons.close,
                  color: PalmColors.textLight,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
              ),
              Expanded(
                child: Text(
                  'Select Dates',
                  textAlign: TextAlign.center,
                  style: PalmTextStyles.title.copyWith(
                    color: PalmColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 40), // Balance the X button
            ],
          ),

          const SizedBox(height: PalmSpacings.m),

          // Selected dates display (if any)
          if (_startDate != null && _endDate != null)
            _buildSelectedDatesHeader()
          else if (_startDate != null)
            _buildSingleDateHeader()
          else
            _buildInstructionText(),
        ],
      ),
    );
  }

  /// Build selected date range header
  Widget _buildSelectedDatesHeader() {
    final days = _endDate!.difference(_startDate!).inDays + 1;
    final holidayAnalysis = HolidayService.analyzeRange(_startDate!, _endDate!);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start date
            Text(
              _formatDate(_startDate!),
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            // Arrow
            Container(
              margin: const EdgeInsets.symmetric(horizontal: PalmSpacings.s),
              child: Icon(
                Icons.arrow_forward,
                color: PalmColors.primary,
                size: 20,
              ),
            ),

            // End date
            Text(
              _formatDate(_endDate!),
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            // Duration info
            Container(
              margin: const EdgeInsets.only(left: PalmSpacings.s),
              padding: const EdgeInsets.symmetric(
                horizontal: PalmSpacings.s,
                vertical: PalmSpacings.xs,
              ),
              decoration: BoxDecoration(
                color: PalmColors.primary,
                borderRadius: BorderRadius.circular(PalmSpacings.s),
              ),
              child: Text(
                '$days day${days > 1 ? 's' : ''}',
                style: PalmTextStyles.caption.copyWith(
                  color: PalmColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        // Holiday warning if any holidays are included
        if (holidayAnalysis.hasHolidays) ...[
          const SizedBox(height: PalmSpacings.s),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: PalmColors.warning,
                size: 16,
              ),
              const SizedBox(width: PalmSpacings.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holidayAnalysis.getHolidaySummary(),
                      style: PalmTextStyles.caption.copyWith(
                        color: PalmColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Working days: ${holidayAnalysis.workingDays}',
                      style: PalmTextStyles.caption.copyWith(
                        color: PalmColors.textLight,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],

        // Annual leave balance display (using Consumer to get StaffProvider)
        const SizedBox(height: PalmSpacings.s),
        Consumer<StaffProvider>(
          builder: (context, staffProvider, child) {
            final balanceText = _calculateRemainingBalance(staffProvider);
            final wouldBeNegative =
                _wouldResultInNegativeBalance(staffProvider);

            if (balanceText.isEmpty) return const SizedBox.shrink();

            return Row(
              children: [
                Icon(
                  wouldBeNegative
                      ? Icons.warning_outlined
                      : Icons.check_circle_outline,
                  color:
                      wouldBeNegative ? PalmColors.danger : PalmColors.success,
                  size: 16,
                ),
                const SizedBox(width: PalmSpacings.xs),
                Expanded(
                  child: Text(
                    balanceText,
                    style: PalmTextStyles.caption.copyWith(
                      color: wouldBeNegative
                          ? PalmColors.danger
                          : PalmColors.success,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Build single date header
  Widget _buildSingleDateHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDate(_startDate!),
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: PalmSpacings.s),
              padding: const EdgeInsets.symmetric(
                horizontal: PalmSpacings.s,
                vertical: PalmSpacings.xs,
              ),
              decoration: BoxDecoration(
                color: PalmColors.primary,
                borderRadius: BorderRadius.circular(PalmSpacings.s),
              ),
              child: Text(
                '1 day',
                style: PalmTextStyles.caption.copyWith(
                  color: PalmColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: PalmSpacings.xs),
        Text(
          'Tap another date for multi-day leave, or continue for single day',
          style: PalmTextStyles.caption.copyWith(
            color: PalmColors.textLight,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),

        // Annual leave balance display for single day
        const SizedBox(height: PalmSpacings.s),
        Consumer<StaffProvider>(
          builder: (context, staffProvider, child) {
            final balanceText = _calculateRemainingBalance(staffProvider);
            final wouldBeNegative =
                _wouldResultInNegativeBalance(staffProvider);

            if (balanceText.isEmpty) return const SizedBox.shrink();

            return Row(
              children: [
                Icon(
                  wouldBeNegative
                      ? Icons.warning_outlined
                      : Icons.check_circle_outline,
                  color:
                      wouldBeNegative ? PalmColors.danger : PalmColors.success,
                  size: 16,
                ),
                const SizedBox(width: PalmSpacings.xs),
                Expanded(
                  child: Text(
                    balanceText,
                    style: PalmTextStyles.caption.copyWith(
                      color: wouldBeNegative
                          ? PalmColors.danger
                          : PalmColors.success,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Build instruction text
  Widget _buildInstructionText() {
    return Text(
      'Select your leave start and end dates from the calendar below',
      style: PalmTextStyles.body.copyWith(
        color: PalmColors.textLight,
      ),
    );
  }

  /// Build bottom action bar with continue button
  Widget _buildBottomActionBar(bool canContinue) {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white,
        border: Border(
          top: BorderSide(
            color: PalmColors.greyLight.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: canContinue ? _onContinue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  canContinue ? PalmColors.primary : PalmColors.greyLight,
              foregroundColor:
                  canContinue ? PalmColors.white : PalmColors.textLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius),
              ),
              elevation: canContinue ? 2 : 0,
            ),
            child: Text(
              'Continue',
              style: PalmTextStyles.button.copyWith(
                color: canContinue ? PalmColors.white : PalmColors.textLight,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build custom calendar matching the image design
  Widget _buildCustomCalendar() {
    final now = DateTime.now();
    final currentYear = now.year;
    final nextYear = currentYear + 1;

    final months = <Widget>[];

    // Add all months from current year (starting from current month)
    for (int month = now.month; month <= 12; month++) {
      final monthDate = DateTime(currentYear, month, 1);
      months.add(_buildMonthCalendar(monthDate));

      // Add spacing between months (except for the last one)
      if (month < 12 || currentYear < nextYear) {
        months.add(const SizedBox(height: PalmSpacings.xl));
      }
    }

    // Add all months from next year
    for (int month = 1; month <= 12; month++) {
      final monthDate = DateTime(nextYear, month, 1);
      months.add(_buildMonthCalendar(monthDate));

      // Add spacing between months (except for the last one)
      if (month < 12) {
        months.add(const SizedBox(height: PalmSpacings.xl));
      }
    }

    return Column(
      children: months,
    );
  }

  /// Build a single month calendar
  Widget _buildMonthCalendar(DateTime month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Column(
      children: [
        // Month header
        Padding(
          padding: const EdgeInsets.only(bottom: PalmSpacings.m),
          child: Text(
            '${monthNames[month.month - 1]} ${month.year}',
            style: PalmTextStyles.title.copyWith(
              color: PalmColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Day headers
        _buildDayHeaders(),

        const SizedBox(height: PalmSpacings.s),

        // Calendar grid
        _buildCalendarGrid(month),
      ],
    );
  }

  /// Build day headers (SUN, MON, TUE, etc.)
  Widget _buildDayHeaders() {
    const dayHeaders = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    return Row(
      children: dayHeaders
          .map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: PalmTextStyles.caption.copyWith(
                      color: PalmColors.textLight,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  /// Build calendar grid for a month
  Widget _buildCalendarGrid(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday
    final daysInMonth = lastDayOfMonth.day;

    // Calculate weeks needed
    final weeks = <Widget>[];

    for (int week = 0; week < 6; week++) {
      final weekDays = <Widget>[];

      for (int day = 0; day < 7; day++) {
        final cellIndex = week * 7 + day;
        final dayNumber = cellIndex - firstWeekday + 1;

        if (dayNumber > 0 && dayNumber <= daysInMonth) {
          final date = DateTime(month.year, month.month, dayNumber);
          weekDays.add(_buildDateCell(date));
        } else {
          weekDays.add(_buildEmptyCell());
        }
      }

      weeks.add(Row(children: weekDays));

      // Stop if we've shown all days of the month
      if ((week + 1) * 7 - firstWeekday >= daysInMonth) {
        break;
      }
    }

    return Column(children: weeks);
  }

  /// Build a date cell
  Widget _buildDateCell(DateTime date) {
    final isSelected = _isDateSelected(date);
    final isInRange = _isDateInRange(date);
    final isToday = _isToday(date);
    final isHoliday = HolidayService.isHoliday(date);
    final isPastDate =
        date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    return Expanded(
      child: GestureDetector(
        onTap: isPastDate ? null : () => _onDateTap(date),
        child: Container(
          height: 48,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: _getDateCellColor(isSelected, isInRange, isToday, isHoliday),
            borderRadius: BorderRadius.circular(24),
            border: isToday && !isSelected
                ? Border.all(
                    color: PalmColors.primary,
                    width: 1,
                  )
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  '${date.day}',
                  style: PalmTextStyles.body.copyWith(
                    color: _getDateTextColor(
                        isSelected, isInRange, isPastDate, isToday, isHoliday),
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build empty cell for days not in current month
  Widget _buildEmptyCell() {
    return Expanded(
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(2),
      ),
    );
  }

  /// Handle date tap
  void _onDateTap(DateTime date) {
    setState(() {
      if (_startDate == null) {
        // First selection - set start date only
        _startDate = date;
        _endDate = null;
      } else if (_endDate == null) {
        // Second selection - set end date
        if (date.isAfter(_startDate!) || _isSameDay(date, _startDate!)) {
          _endDate = date;
        } else {
          // If selected date is before start date, swap them
          _endDate = _startDate;
          _startDate = date;
        }
      } else {
        // Both dates are already selected, start new selection
        _startDate = date;
        _endDate = null;
      }
    });
  }

  /// Check if date is selected (start or end)
  bool _isDateSelected(DateTime date) {
    return _isStartDate(date) || _isEndDate(date);
  }

  /// Check if date is start date
  bool _isStartDate(DateTime date) {
    return _startDate != null && _isSameDay(date, _startDate!);
  }

  /// Check if date is end date
  bool _isEndDate(DateTime date) {
    return _endDate != null && _isSameDay(date, _endDate!);
  }

  /// Check if date is in selected range
  bool _isDateInRange(DateTime date) {
    if (_startDate == null || _endDate == null) return false;
    return date.isAfter(_startDate!) && date.isBefore(_endDate!);
  }

  /// Check if date is today
  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return _isSameDay(date, today);
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get background color for date cell
  Color _getDateCellColor(
      bool isSelected, bool isInRange, bool isToday, bool isHoliday) {
    if (isSelected) {
      return PalmColors.primary; // Blue background for selected dates
    } else if (isInRange) {
      return PalmColors.primary.withOpacity(0.2); // Light blue for range
    } else if (isToday) {
      return Colors.transparent; // Transparent with border for today
    }
    return Colors.transparent;
  }

  /// Get text color for date cell
  Color _getDateTextColor(bool isSelected, bool isInRange, bool isPastDate,
      bool isToday, bool isHoliday) {
    if (isSelected) {
      return PalmColors.white; // White text on blue background
    } else if (isPastDate) {
      return PalmColors.greyLight; // Light grey for past dates
    } else if (isToday) {
      return PalmColors.primary; // Blue text for today
    } else if (isInRange) {
      return PalmColors.primary; // Blue text for range
    }
    return PalmColors.textNormal; // Normal text color
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Calculate remaining annual leave balance after the selected date range
  String _calculateRemainingBalance(StaffProvider staffProvider) {
    if (_startDate == null || _endDate == null) {
      return '';
    }

    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final balance = staffProvider.staffInfo!.data!.balanceAnnually;
      if (balance != null && balance.isNotEmpty) {
        final balanceHours = double.tryParse(balance) ?? 0.0;
        final balanceDays = balanceHours / 8.0;

        // Calculate requested leave days (working days only)
        final holidayAnalysis =
            HolidayService.analyzeRange(_startDate!, _endDate!);
        final requestedDays = holidayAnalysis.workingDays.toDouble();

        // Calculate remaining balance
        final remainingDays = balanceDays - requestedDays;

        // Handle negative balance - show 0 for clean UI
        final displayDays = remainingDays < 0 ? 0.0 : remainingDays;

        return '${displayDays.toStringAsFixed(1)} days remaining after this request';
      }
    }
    return '';
  }

  /// Check if the request would result in negative balance
  bool _wouldResultInNegativeBalance(StaffProvider staffProvider) {
    if (_startDate == null || _endDate == null) {
      return false;
    }

    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final balance = staffProvider.staffInfo!.data!.balanceAnnually;
      if (balance != null && balance.isNotEmpty) {
        final balanceHours = double.tryParse(balance) ?? 0.0;
        final balanceDays = balanceHours / 8.0;

        final holidayAnalysis =
            HolidayService.analyzeRange(_startDate!, _endDate!);
        final requestedDays = holidayAnalysis.workingDays.toDouble();

        return (balanceDays - requestedDays) < 0;
      }
    }
    return false;
  }
}

/// Full screen version of date range picker for use with AnimationUtils
class _DateRangeFullScreen extends StatelessWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const _DateRangeFullScreen({
    this.initialStartDate,
    this.initialEndDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.white,
      body: SafeArea(
        child: DateRangeBottomSheetContent(
          initialStartDate: initialStartDate,
          initialEndDate: initialEndDate,
          firstDate: firstDate,
          lastDate: lastDate,
        ),
      ),
    );
  }
}
