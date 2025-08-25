import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/column_chart.dart';
import '../../../theme/app_theme.dart';
import '../../../services/attendance_service.dart';
import '../../../providers/attendance/attendance_provider.dart';
import 'dart:math';

class YearlyScreen extends StatefulWidget {
  final String? yearRange;
  final int attendanceType; // Type of attendance (1: Normal, 2: Overtime, 3: Part Time)
  
  const YearlyScreen({
    super.key,
    this.yearRange,
    required this.attendanceType,
  });

  @override
  State<YearlyScreen> createState() => _YearlyScreenState();
}

class _YearlyScreenState extends State<YearlyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Get report titles based on attendance type
  List<String> _getReportTitles(int attendanceType) {
    switch (attendanceType) {
      case 1: // Normal attendance
        return [
          'Working hours',
          'Late hours',
          'Absent hours',
          'Early hours',
          'On-time hours'
        ];
      case 2: // Overtime
        return [
          'Working hours',
          'Weekend work hours',
          'Holiday work hours'
        ];
      case 3: // Part-time
        return [
          'Working hours'
        ];
      default:
        return ['Working hours'];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the attendance provider
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    
    // Parse year range from string
    final years = widget.yearRange?.split(' - ') ?? ['${DateTime.now().year - 4}', '${DateTime.now().year}'];
    List<int> yearRangeList = [];
    List<String> yearLabels = [];
    
    if (years.length == 2) {
      try {
        int startYear = int.parse(years[0]);
        int endYear = int.parse(years[1]);
        
        // Generate list of years in range
        for (int year = startYear; year <= endYear; year++) {
          yearRangeList.add(year);
          yearLabels.add(year.toString());
        }
      } catch (e) {
        // Default to current year if parsing fails
        yearRangeList = [DateTime.now().year];
        yearLabels = [DateTime.now().year.toString()];
      }
    } else {
      // Default to current year if parsing fails
      yearRangeList = [DateTime.now().year];
      yearLabels = [DateTime.now().year.toString()];
    }
    
    // Get report data from attendance service with year range
    final List<List<double>> reportData = AttendanceService.getYearlyReportData(
      attendanceProvider,
      yearRangeList: yearRangeList,
      attendanceType: widget.attendanceType,
    );
    
    // Calculate max Y values for each report type dynamically
    final List<double> maxYValues = reportData.map((dataList) {
      // Find the maximum value in the list and add 20% padding
      double maxValue = dataList.isEmpty ? 0 : dataList.reduce(max);
      return maxValue == 0 ? 10.0 : maxValue * 1.2; // Minimum of 10 for empty charts
    }).toList();
    
    // Report titles based on attendance type
    final List<String> reportTitles = _getReportTitles(widget.attendanceType);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: PalmSpacings.m),
          
          // Check if there's data to display
          if (reportData.isEmpty)
            Padding(
              padding: const EdgeInsets.all(PalmSpacings.l),
              child: Center(
                child: Text(
                  'No attendance data available for ${widget.yearRange}',
                  style: PalmTextStyles.body.copyWith(
                    color: PalmColors.textNormal,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            // Display all reports vertically with section headers
            for (int i = 0; i < reportData.length; i++) ...[
            // Section header
            Padding(
              padding: EdgeInsets.only(
                left: PalmSpacings.l, 
                right: PalmSpacings.l,
                bottom: PalmSpacings.s,
                top: i > 0 ? PalmSpacings.m : 0,
              ),
              child: Text(
                reportTitles[i],
                style: PalmTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: PalmColors.textNormal,
                ),
              ),
            ),
            // Chart
            Padding(
              padding: const EdgeInsets.only(bottom: PalmSpacings.l),
              child: reportData[i].every((value) => value == 0.0)
                  ? Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(horizontal: PalmSpacings.l),
                      decoration: BoxDecoration(
                        border: Border.all(color: PalmColors.greyLight),
                        borderRadius: BorderRadius.circular(PalmSpacings.radius),
                      ),
                      child: Center(
                        child: Text(
                          'No ${reportTitles[i].toLowerCase()} data for ${widget.yearRange}',
                          style: PalmTextStyles.body.copyWith(
                            color: PalmColors.textLight,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  : ColumnChart(
                      barData: reportData[i],
                      maxY: maxYValues[i],
                      title: reportTitles[i],
                      customLabels: yearLabels,
                    ),
            ),
          ],
        ],
      ),
    );
  }
}