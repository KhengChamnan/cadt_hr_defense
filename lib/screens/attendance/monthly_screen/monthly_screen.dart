import 'package:flutter/material.dart';
import '../widgets/column_chart.dart';
import '../widgets/report_selector.dart';
import '../../../theme/app_theme.dart';
import '../../../services/attendance_service.dart';
import '../../../providers/attendance/attendance_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class MonthlyScreen extends StatefulWidget {
  final int attendanceType; // Type of attendance (1: Normal, 2: Overtime, 3: Part Time)
  
  const MonthlyScreen({
    super.key,
    required this.attendanceType,
  });

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  int selectedYear = DateTime.now().year;

  void _incrementYear() {
    setState(() {
      selectedYear++;
    });
  }

  void _decrementYear() {
    setState(() {
      selectedYear--;
    });
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
    // Get attendance provider
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    
    // Get report data from attendance service with selected year
    final List<List<double>> reportData = AttendanceService.getMonthlyReportData(
      attendanceProvider,
      attendanceType: widget.attendanceType,
      year: selectedYear,
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
          // Year selector
          ReportSelector(
            title: "$selectedYear",
            onPrevious: _decrementYear,
            onNext: _incrementYear,
          ),
          
          const SizedBox(height: PalmSpacings.m),
          
          // Check if there's data to display
          if (reportData.isEmpty)
            Padding(
              padding: const EdgeInsets.all(PalmSpacings.l),
              child: Center(
                child: Text(
                  'No attendance data available for $selectedYear',
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
            ),              // Chart
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
                            'No ${reportTitles[i].toLowerCase()} data for $selectedYear',
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
                      ),
              ),
          ],
        ],
      ),
    );
  }
}