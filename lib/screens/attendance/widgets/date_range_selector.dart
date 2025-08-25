import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';

class DateRangeSelector extends StatelessWidget {
  final String rangeText;
  final Function(String) onRangeSelected;
  final Function(DateTimeRange)? onDateRangeSelected;
  final bool showYearSelector;
  final DateTimeRange? initialDateRange;

  const DateRangeSelector({
    Key? key,
    required this.rangeText,
    required this.onRangeSelected,
    this.onDateRangeSelected,
    this.showYearSelector = true,
    this.initialDateRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m, vertical: PalmSpacings.s),
      child: InkWell(
        onTap: () => _showRangePicker(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m, vertical: PalmSpacings.s),
          decoration: BoxDecoration(
            border: Border.all(color: PalmColors.greyLight),
            borderRadius: BorderRadius.circular(PalmSpacings.radius / 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Range',
                style: PalmTextStyles.body.copyWith(
                  color: PalmColors.textNormal,
                ),
              ),
              Row(
                children: [
                  Text(
                    rangeText,
                    style: PalmTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                      color: PalmColors.primary,
                    ),
                  ),
                  const SizedBox(width: PalmSpacings.s / 1.5),
                  Icon(Icons.calendar_today, size: 18, color: PalmColors.primary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRangePicker(BuildContext context) {
    if (showYearSelector) {
      _showYearRangePicker(context);
    } else {
      _showDateRangePicker(context);
    }
  }

  void _showYearRangePicker(BuildContext context) {
    // Parse the current range
    final years = rangeText.split(' - ');
    int startYear, endYear;
    
    try {
      startYear = int.parse(years[0]);
      endYear = int.parse(years[1]);
    } catch (e) {
      // Default to current year if parsing fails
      startYear = DateTime.now().year;
      endYear = DateTime.now().year;
    }
    
    // Show a custom year range selector
    _showCustomYearRangeSelector(context, startYear, endYear);
  }
  
  void _showCustomYearRangeSelector(BuildContext context, int initialStartYear, int initialEndYear) {
    // Calculate the decade range that includes the initial years
    int startDecade = (initialStartYear ~/ 10) * 10;
    int? selectedStartYear;
    int? selectedEndYear;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool hasSelectedRange = selectedStartYear != null && selectedEndYear != null;
            
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius),
              ),
              content: Container(
                width: 300,
                height: 450,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(PalmSpacings.m),
                      child: Text(
                        'Select Year Range',
                        style: PalmTextStyles.title.copyWith(
                          fontWeight: FontWeight.bold,
                          color: PalmColors.primary,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: PalmSpacings.m),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: PalmColors.primary),
                            onPressed: () {
                              setState(() {
                                startDecade -= 10;
                              });
                            },
                          ),
                          Text(
                            '$startDecade - ${startDecade + 9}',
                            style: PalmTextStyles.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.chevron_right, color: PalmColors.primary),
                            onPressed: () {
                              setState(() {
                                startDecade += 10;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: PalmSpacings.m),
                    Expanded(
                      child: GridView.count(
                        padding: EdgeInsets.symmetric(horizontal: PalmSpacings.m),
                        crossAxisCount: 3,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: PalmSpacings.m,
                        mainAxisSpacing: PalmSpacings.m,
                        shrinkWrap: true,
                        children: List.generate(12, (index) {
                          final int year = startDecade + index;
                          
                          // Determine if this year is in the selected range
                          bool isStartYear = selectedStartYear == year;
                          bool isEndYear = selectedEndYear == year;
                          bool isInRange = false;
                          
                          if (selectedStartYear != null && selectedEndYear != null) {
                            isInRange = year > selectedStartYear! && year < selectedEndYear!;
                          }
                          
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (selectedStartYear == null) {
                                  // First selection
                                  selectedStartYear = year;
                                } else if (selectedEndYear == null) {
                                  // Second selection
                                  if (year < selectedStartYear!) {
                                    // If second selection is before first, swap them
                                    selectedEndYear = selectedStartYear;
                                    selectedStartYear = year;
                                  } else {
                                    selectedEndYear = year;
                                  }
                                  
                                  // Apply the selection after both years are selected
                                  if (selectedStartYear != null && selectedEndYear != null) {
                                    final String range = '$selectedStartYear - $selectedEndYear';
                                    onRangeSelected(range);
                                  }
                                } else {
                                  // Reset and start new selection
                                  selectedStartYear = year;
                                  selectedEndYear = null;
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isStartYear || isEndYear 
                                    ? PalmColors.primary
                                    : isInRange 
                                        ? PalmColors.primaryLight.withOpacity(0.3)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(PalmSpacings.radius / 2),
                                border: Border.all(
                                  color: isStartYear || isEndYear || isInRange
                                      ? PalmColors.primary
                                      : PalmColors.greyLight,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  year.toString(),
                                  style: PalmTextStyles.body.copyWith(
                                    color: isStartYear || isEndYear 
                                        ? PalmColors.white
                                        : isInRange 
                                            ? PalmColors.primary
                                            : PalmColors.textNormal,
                                    fontWeight: isStartYear || isEndYear 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(PalmSpacings.m),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: PalmTextStyles.button.copyWith(
                                color: PalmColors.neutral,
                              ),
                            ),
                          ),
                          SizedBox(width: PalmSpacings.m),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PalmColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(PalmSpacings.radius / 2),
                              ),
                            ),
                            onPressed: hasSelectedRange
                                ? () {
                                    final String range = '$selectedStartYear - $selectedEndYear';
                                    onRangeSelected(range);
                                    Navigator.of(context).pop();
                                  }
                                : null,
                            child: Text(
                              'Apply',
                              style: PalmTextStyles.button.copyWith(
                                color: PalmColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _showDateRangePicker(BuildContext context) {
    // Parse initial date range if available, otherwise use default
    DateTime startDate = DateTime.now().subtract(const Duration(days: 7));
    DateTime endDate = DateTime.now();
    
    if (initialDateRange != null) {
      startDate = initialDateRange!.start;
      endDate = initialDateRange!.end;
    } else {
      // Try to parse from rangeText if it's in date format
      try {
        final DateFormat formatter = DateFormat('MMM d, yyyy');
        final dates = rangeText.split(' - ');
        if (dates.length == 2) {
          startDate = formatter.parse(dates[0]);
          endDate = formatter.parse(dates[1]);
        }
      } catch (e) {
        // Use default dates if parsing fails
      }
    }
    
    // Create a DateRangePickerController
    final DateRangePickerController _controller = DateRangePickerController();
    _controller.selectedRange = PickerDateRange(startDate, endDate);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Date Range'),
          content: SizedBox(
            width: 300,
            height: 400,
            child: SfDateRangePicker(
              controller: _controller,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              minDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
              maxDate: DateTime.now().add(const Duration(days: 365)),
              showNavigationArrow: true,
              enablePastDates: true,
              todayHighlightColor: Theme.of(context).primaryColor,
              selectionColor: Theme.of(context).primaryColor,
              rangeSelectionColor: Theme.of(context).primaryColor.withOpacity(0.2),
              startRangeSelectionColor: Theme.of(context).primaryColor,
              endRangeSelectionColor: Theme.of(context).primaryColor,
              monthViewSettings: const DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1, // Monday
                viewHeaderHeight: 50,
                showTrailingAndLeadingDates: true,
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  final PickerDateRange range = args.value;
                  if (range.startDate != null && range.endDate != null) {
                    final DateFormat formatter = DateFormat('MMM d, yyyy');
                    final String formattedRange = 
                        '${formatter.format(range.startDate!)} - ${formatter.format(range.endDate!)}';
                    onRangeSelected(formattedRange);
                    
                    if (onDateRangeSelected != null) {
                      onDateRangeSelected!(DateTimeRange(
                        start: range.startDate!,
                        end: range.endDate!,
                      ));
                    }
                  }
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
} 