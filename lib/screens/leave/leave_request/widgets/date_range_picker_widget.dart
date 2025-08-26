import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/services/holiday_service.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/staff/staff_provder.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';

/// A custom date range picker widget using Syncfusion that follows the app's theme
/// This widget allows users to select a date range with visual feedback and validation
class DateRangePickerWidget extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime?, DateTime?)? onRangeChanged;
  final String? errorText;
  final bool showHeader;

  const DateRangePickerWidget({
    super.key,
    this.startDate,
    this.endDate,
    this.firstDate,
    this.lastDate,
    this.onRangeChanged,
    this.errorText,
    this.showHeader = true,
  });

  @override
  State<DateRangePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  final DateRangePickerController _controller = DateRangePickerController();
  late DateTime _minDate;
  late DateTime _maxDate;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _setInitialSelection();
  }

  @override
  void didUpdateWidget(DateRangePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _setInitialSelection();
    }
  }

  /// Initialize the min and max dates for the calendar
  void _initializeDates() {
    _minDate = widget.firstDate ?? DateTime.now();
    _maxDate = widget.lastDate ?? DateTime.now().add(const Duration(days: 365));
  }

  /// Set the initial selection if dates are provided
  void _setInitialSelection() {
    if (widget.startDate != null && widget.endDate != null) {
      _controller.selectedRange = PickerDateRange(
        widget.startDate,
        widget.endDate,
      );
    } else if (widget.startDate != null) {
      _controller.selectedDate = widget.startDate;
    }
  }

  /// Handle selection change in the date picker
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final PickerDateRange range = args.value;
      if (widget.onRangeChanged != null) {
        widget.onRangeChanged!(range.startDate, range.endDate);
      }
    }
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

  /// Calculate the number of days between two dates
  int _calculateDays(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  /// Calculate remaining annual leave balance after the selected date range
  String _calculateRemainingBalance(StaffProvider staffProvider) {
    if (widget.startDate == null || widget.endDate == null) {
      return '';
    }

    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final balance = staffProvider.staffInfo!.data!.balanceAnnually;
      if (balance != null && balance.isNotEmpty) {
        final balanceHours = double.tryParse(balance) ?? 0.0;
        final balanceDays = balanceHours / 8.0;

        // Calculate requested leave days (working days only)
        final holidayAnalysis =
            HolidayService.analyzeRange(widget.startDate!, widget.endDate!);
        final requestedDays = holidayAnalysis.workingDays.toDouble();

        // Calculate remaining balance
        final remainingDays = balanceDays - requestedDays;

        // Handle negative balance - show 0 for clean UI
        final displayDays = remainingDays < 0 ? 0.0 : remainingDays;

        return '${displayDays.toStringAsFixed(1)} days remaining after this request';
      }
    }
    return 'Balance not available';
  }

  /// Check if the request would result in negative balance
  bool _wouldResultInNegativeBalance(StaffProvider staffProvider) {
    if (widget.startDate == null || widget.endDate == null) {
      return false;
    }

    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final balance = staffProvider.staffInfo!.data!.balanceAnnually;
      if (balance != null && balance.isNotEmpty) {
        final balanceHours = double.tryParse(balance) ?? 0.0;
        final balanceDays = balanceHours / 8.0;

        final holidayAnalysis =
            HolidayService.analyzeRange(widget.startDate!, widget.endDate!);
        final requestedDays = holidayAnalysis.workingDays.toDouble();

        return (balanceDays - requestedDays) < 0;
      }
    }
    return false;
  }

  /// Calculate remaining balance for specific dates
  String _calculateRemainingBalanceForDates(
      StaffProvider staffProvider, DateTime startDate, DateTime endDate) {
    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final balance = staffProvider.staffInfo!.data!.balanceAnnually;
      if (balance != null && balance.isNotEmpty) {
        final balanceHours = double.tryParse(balance) ?? 0.0;
        final balanceDays = balanceHours / 8.0;

        // Calculate requested leave days (working days only)
        final holidayAnalysis = HolidayService.analyzeRange(startDate, endDate);
        final requestedDays = holidayAnalysis.workingDays.toDouble();

        // Calculate remaining balance
        final remainingDays = balanceDays - requestedDays;

        // Handle negative balance - show 0 for clean UI
        final displayDays = remainingDays < 0 ? 0.0 : remainingDays;

        return '${displayDays.toStringAsFixed(1)} days remaining after this request';
      }
    }
    return 'Balance not available';
  }

  /// Check if specific dates would result in negative balance
  bool _wouldResultInNegativeBalanceForDates(
      StaffProvider staffProvider, DateTime startDate, DateTime endDate) {
    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final balance = staffProvider.staffInfo!.data!.balanceAnnually;
      if (balance != null && balance.isNotEmpty) {
        final balanceHours = double.tryParse(balance) ?? 0.0;
        final balanceDays = balanceHours / 8.0;

        final holidayAnalysis = HolidayService.analyzeRange(startDate, endDate);
        final requestedDays = holidayAnalysis.workingDays.toDouble();

        return (balanceDays - requestedDays) < 0;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with selected dates display
          if (widget.showHeader) _buildHeader(),

          // Main calendar
          _buildCalendar(),

          // Footer with actions
          if (widget.showHeader) _buildFooter(),

          // Error message
          if (widget.errorText != null) _buildErrorMessage(),
        ],
      ),
    );
  }

  /// Build the header with selected range display
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PalmColors.primary,
            PalmColors.primaryLight,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(PalmSpacings.radius),
          topRight: Radius.circular(PalmSpacings.radius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.date_range,
                color: PalmColors.white,
                size: 24,
              ),
              const SizedBox(width: PalmSpacings.s),
              Text(
                'Select Leave Dates',
                style: PalmTextStyles.title.copyWith(
                  color: PalmColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (widget.startDate != null && widget.endDate != null) ...[
            const SizedBox(height: PalmSpacings.m),
            _buildSelectedRangeDisplay(),
          ] else if (widget.startDate != null) ...[
            const SizedBox(height: PalmSpacings.m),
            _buildSingleDateDisplay(),
          ] else ...[
            const SizedBox(height: PalmSpacings.s),
            Text(
              'Tap on dates to select your leave period',
              style: PalmTextStyles.caption.copyWith(
                color: PalmColors.white.withOpacity(0.9),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build the selected range display
  Widget _buildSelectedRangeDisplay() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(PalmSpacings.s),
          decoration: BoxDecoration(
            color: PalmColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(PalmSpacings.s),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _formatDate(widget.startDate!),
                      style: PalmTextStyles.body.copyWith(
                        color: PalmColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: PalmSpacings.xxs),
                    Text(
                      'FROM',
                      style: PalmTextStyles.caption.copyWith(
                        color: PalmColors.white.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(PalmSpacings.xs),
                decoration: BoxDecoration(
                  color: PalmColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: PalmColors.white,
                  size: 16,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _formatDate(widget.endDate!),
                      style: PalmTextStyles.body.copyWith(
                        color: PalmColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: PalmSpacings.xxs),
                    Text(
                      'TO',
                      style: PalmTextStyles.caption.copyWith(
                        color: PalmColors.white.withOpacity(0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Annual leave balance display
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
                  color: wouldBeNegative ? PalmColors.danger : PalmColors.white,
                  size: 16,
                ),
                const SizedBox(width: PalmSpacings.xs),
                Expanded(
                  child: Text(
                    balanceText,
                    style: PalmTextStyles.caption.copyWith(
                      color: wouldBeNegative
                          ? PalmColors.danger
                          : PalmColors.white,
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

  /// Build single date display
  Widget _buildSingleDateDisplay() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(PalmSpacings.s),
          decoration: BoxDecoration(
            color: PalmColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(PalmSpacings.s),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event,
                color: PalmColors.white,
                size: 16,
              ),
              const SizedBox(width: PalmSpacings.s),
              Text(
                _formatDate(widget.startDate!),
                style: PalmTextStyles.body.copyWith(
                  color: PalmColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: PalmSpacings.s),
              Text(
                '(Select end date)',
                style: PalmTextStyles.caption.copyWith(
                  color: PalmColors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),

        // Annual leave balance display for single day
        const SizedBox(height: PalmSpacings.s),
        Consumer<StaffProvider>(
          builder: (context, staffProvider, child) {
            // For single day, use start date as both start and end
            final tempEndDate = widget.startDate!;
            final balanceText = _calculateRemainingBalanceForDates(
                staffProvider, widget.startDate!, tempEndDate);
            final wouldBeNegative = _wouldResultInNegativeBalanceForDates(
                staffProvider, widget.startDate!, tempEndDate);

            if (balanceText.isEmpty) return const SizedBox.shrink();

            return Row(
              children: [
                Icon(
                  wouldBeNegative
                      ? Icons.warning_outlined
                      : Icons.check_circle_outline,
                  color: wouldBeNegative ? PalmColors.danger : PalmColors.white,
                  size: 16,
                ),
                const SizedBox(width: PalmSpacings.xs),
                Expanded(
                  child: Text(
                    balanceText,
                    style: PalmTextStyles.caption.copyWith(
                      color: wouldBeNegative
                          ? PalmColors.danger
                          : PalmColors.white,
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

  /// Build the main calendar widget
  Widget _buildCalendar() {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      child: SfDateRangePicker(
        controller: _controller,
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.range,
        minDate: _minDate,
        maxDate: _maxDate,
        onSelectionChanged: _onSelectionChanged,
        showNavigationArrow: true,
        enablePastDates: DateTime.now().isBefore(_minDate) ? false : true,
        headerStyle: DateRangePickerHeaderStyle(
          backgroundColor: Colors.transparent,
          textAlign: TextAlign.center,
          textStyle: PalmTextStyles.subheading.copyWith(
            color: PalmColors.textNormal,
            fontWeight: FontWeight.w600,
          ),
        ),
        monthViewSettings: DateRangePickerMonthViewSettings(
          weekendDays: const [6, 7], // Saturday and Sunday
          firstDayOfWeek: 1, // Monday
          dayFormat: 'EEE',
          viewHeaderStyle: DateRangePickerViewHeaderStyle(
            backgroundColor: PalmColors.backgroundAccent,
            textStyle: PalmTextStyles.caption.copyWith(
              color: PalmColors.textNormal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
          textStyle: PalmTextStyles.body.copyWith(
            color: PalmColors.textNormal,
          ),
          todayTextStyle: PalmTextStyles.body.copyWith(
            color: PalmColors.primary,
            fontWeight: FontWeight.bold,
          ),
          weekendTextStyle: PalmTextStyles.body.copyWith(
            color: PalmColors.textLight,
          ),
          disabledDatesTextStyle: PalmTextStyles.body.copyWith(
            color: PalmColors.greyLight,
          ),
        ),
        selectionTextStyle: PalmTextStyles.body.copyWith(
          color: PalmColors.white,
          fontWeight: FontWeight.bold,
        ),
        rangeTextStyle: PalmTextStyles.body.copyWith(
          color: PalmColors.textNormal,
          fontWeight: FontWeight.w500,
        ),
        selectionColor: PalmColors.primary,
        startRangeSelectionColor: PalmColors.primary,
        endRangeSelectionColor: PalmColors.primary,
        rangeSelectionColor: PalmColors.primary.withOpacity(0.2),
        todayHighlightColor: PalmColors.primaryLight,
      ),
    );
  }

  /// Build the footer with action buttons
  Widget _buildFooter() {
    final hasSelection = widget.startDate != null && widget.endDate != null;

    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.backgroundAccent,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(PalmSpacings.radius),
          bottomRight: Radius.circular(PalmSpacings.radius),
        ),
      ),
      child: Column(
        children: [
          // Duration display and balance info
          if (hasSelection) ...[
            Builder(
              builder: (context) {
                final days = _calculateDays(widget.startDate!, widget.endDate!);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PalmSpacings.m,
                    vertical: PalmSpacings.s,
                  ),
                  decoration: BoxDecoration(
                    color: PalmColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(PalmSpacings.s),
                    border: Border.all(
                      color: PalmColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.schedule,
                        color: PalmColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: PalmSpacings.s),
                      Text(
                        'Duration: $days day${days > 1 ? 's' : ''}',
                        style: PalmTextStyles.body.copyWith(
                          color: PalmColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Balance display in footer
            const SizedBox(height: PalmSpacings.s),
            Consumer<StaffProvider>(
              builder: (context, staffProvider, child) {
                final balanceText = _calculateRemainingBalance(staffProvider);
                final wouldBeNegative =
                    _wouldResultInNegativeBalance(staffProvider);

                if (balanceText.isEmpty) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PalmSpacings.m,
                    vertical: PalmSpacings.s,
                  ),
                  decoration: BoxDecoration(
                    color: wouldBeNegative
                        ? PalmColors.danger.withOpacity(0.1)
                        : PalmColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(PalmSpacings.s),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        wouldBeNegative
                            ? Icons.warning_outlined
                            : Icons.account_balance_wallet,
                        color: wouldBeNegative
                            ? PalmColors.danger
                            : PalmColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: PalmSpacings.s),
                      Expanded(
                        child: Text(
                          balanceText,
                          textAlign: TextAlign.center,
                          style: PalmTextStyles.body.copyWith(
                            color: wouldBeNegative
                                ? PalmColors.danger
                                : PalmColors.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: PalmSpacings.s),
          ],

          // Action buttons
          Row(
            children: [
              // Clear button
              if (hasSelection) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _controller.selectedRange = null;
                      if (widget.onRangeChanged != null) {
                        widget.onRangeChanged!(null, null);
                      }
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 16,
                      color: PalmColors.textLight,
                    ),
                    label: Text(
                      'Clear',
                      style: PalmTextStyles.button.copyWith(
                        color: PalmColors.textLight,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: PalmColors.greyLight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(PalmSpacings.s),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: PalmSpacings.s),
              ],

              // Info text or confirm button
              Expanded(
                flex: hasSelection ? 2 : 1,
                child: hasSelection
                    ? ElevatedButton.icon(
                        onPressed: () {
                          // This can be used to confirm selection if needed
                          // For now, selection is automatic
                          if (hasSelection) {
                            final selectedDays = _calculateDays(
                                widget.startDate!, widget.endDate!);
                            debugPrint('Selected $selectedDays days');
                          }
                        },
                        icon: Icon(
                          Icons.check,
                          size: 16,
                          color: PalmColors.white,
                        ),
                        label: Text(
                          'Selected',
                          style: PalmTextStyles.button.copyWith(
                            color: PalmColors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PalmColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(PalmSpacings.s),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: PalmSpacings.s,
                        ),
                        child: Text(
                          'Select start and end dates',
                          textAlign: TextAlign.center,
                          style: PalmTextStyles.caption.copyWith(
                            color: PalmColors.textLight,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build error message display
  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.all(PalmSpacings.m),
      padding: const EdgeInsets.all(PalmSpacings.s),
      decoration: BoxDecoration(
        color: PalmColors.danger.withOpacity(0.1),
        borderRadius: BorderRadius.circular(PalmSpacings.s),
        border: Border.all(
          color: PalmColors.danger.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: PalmColors.danger,
            size: 16,
          ),
          const SizedBox(width: PalmSpacings.s),
          Expanded(
            child: Text(
              widget.errorText!,
              style: PalmTextStyles.caption.copyWith(
                color: PalmColors.danger,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// A simplified date range picker screen for full-screen usage
class DateRangePickerScreen extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String title;

  const DateRangePickerScreen({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.firstDate,
    this.lastDate,
    this.title = 'Select Leave Dates',
  });

  @override
  State<DateRangePickerScreen> createState() => _DateRangePickerScreenState();
}

class _DateRangePickerScreenState extends State<DateRangePickerScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  /// Handle range change
  void _onRangeChanged(DateTime? start, DateTime? end) {
    setState(() {
      _startDate = start;
      _endDate = end;
    });
  }

  /// Handle continue button press
  void _onContinue() {
    if (_startDate != null && _endDate != null) {
      Navigator.pop(context, {
        'startDate': _startDate,
        'endDate': _endDate,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _startDate != null && _endDate != null;

    return Scaffold(
      backgroundColor: PalmColors.backgroundAccent,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: PalmTextStyles.title.copyWith(
            color: PalmColors.white,
          ),
        ),
        backgroundColor: PalmColors.primary,
        foregroundColor: PalmColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PalmColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (canContinue)
            TextButton(
              onPressed: _onContinue,
              child: Text(
                'Continue',
                style: PalmTextStyles.button.copyWith(
                  color: PalmColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PalmSpacings.m),
        child: DateRangePickerWidget(
          startDate: _startDate,
          endDate: _endDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onRangeChanged: _onRangeChanged,
          showHeader: true,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(PalmSpacings.m),
        decoration: BoxDecoration(
          color: PalmColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check,
                    color:
                        canContinue ? PalmColors.white : PalmColors.textLight,
                    size: 20,
                  ),
                  const SizedBox(width: PalmSpacings.s),
                  Text(
                    'Continue',
                    style: PalmTextStyles.body.copyWith(
                      color:
                          canContinue ? PalmColors.white : PalmColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
