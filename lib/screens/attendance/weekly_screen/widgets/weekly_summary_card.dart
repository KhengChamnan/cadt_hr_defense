import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../providers/attendance/attendance_provider.dart';
import '../../../../services/attendance_service.dart';
import '../../../../theme/app_theme.dart';

class WeeklySummaryCard extends StatelessWidget {
  final String? monthName;
  final int? weekNumber;
  final int? year;
  final int attendanceType; // Type of attendance (1: Normal, 2: Overtime, 3: Part Time)
  
  const WeeklySummaryCard({
    super.key, 
    this.monthName,
    this.weekNumber,
    this.year,
    required this.attendanceType,
  });

  @override
  Widget build(BuildContext context) {
    // Get the attendance provider
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    
    // Get weekly summary data from the service based on selected month and week
    final Map<String, String> summaryData;
    
    if (monthName != null && weekNumber != null) {
      // Use selected month and week
      summaryData = AttendanceService.getWeeklySummaryForSelectedWeek(
        attendanceProvider,
        monthName!,
        weekNumber!,
        attendanceType,
        year: year,
      );
    } else {
      // Use current week
      summaryData = AttendanceService.getWeeklySummaryData(
        attendanceProvider,
        attendanceType: attendanceType
      );
    }

    // Extract data for progress calculations
    final hoursWorked = double.tryParse(summaryData['totalHours']?.replaceAll('h', '').split(' ')[0] ?? '0') ?? 0;
    final targetHours = attendanceType == 2 ? 20.0 : 40.0; // 20 hours target for overtime, 40 for normal
    final progressValue = (hoursWorked / targetHours).clamp(0.0, 1.0);
    
    // Get attendance rate from the service
    final attendanceRateParts = summaryData['attendanceRate']?.split('/') ?? ['0', '0'];
    final daysPresent = int.tryParse(attendanceRateParts[0]) ?? 0;
    final totalWorkDays = int.tryParse(attendanceRateParts[1]) ?? 5;
    final attendanceRate = totalWorkDays > 0 ? ((daysPresent / totalWorkDays) * 100).round() : 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.l),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(PalmSpacings.m),
        decoration: BoxDecoration(
          color: const Color(0xFF2C5282), // Deep blue background from Figma
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            // Top row with two cards
            attendanceType == 2 
                ? _buildOvertimeCardRow(summaryData, progressValue, attendanceRate)
                : _buildCardRow(
                    card1: _buildHoursThisWeekCard(summaryData, progressValue),
                    card2: _buildAttendanceRateCard(summaryData, attendanceRate),
                  ),
            const SizedBox(height: PalmSpacings.s),
            // Bottom row with two cards
            attendanceType == 2
                ? _buildOvertimeBottomRow(summaryData)
                : _buildCardRow(
                    card1: _buildAverageHoursCard(summaryData),
                    card2: _buildAbsentHoursCard(summaryData),
                  ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCardRow({required Widget card1, required Widget card2}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: card1),
          const SizedBox(width: PalmSpacings.s),
          Expanded(child: card2),
        ],
      ),
    );
  }
  
  Widget _buildHoursThisWeekCard(Map<String, String> summaryData, double progressValue) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hours this week:',
            style: PalmTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            summaryData['totalHours'] ?? '0 hours',
            style: PalmTextStyles.title.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Of 40 hours',
            style: PalmTextStyles.label.copyWith(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          _buildProgressBar(progressValue),
        ],
      ),
    );
  }
  
  // Overtime-specific card row
  Widget _buildOvertimeCardRow(Map<String, String> summaryData, double progressValue, int attendanceRate) {
    return _buildCardRow(
      card1: _buildOvertimeThisWeekCard(summaryData, progressValue),
      card2: _buildEligibleDaysCard(summaryData, attendanceRate),
    );
  }
  
  Widget _buildOvertimeBottomRow(Map<String, String> summaryData) {
    return _buildCardRow(
      card1: _buildAverageOTHoursCard(summaryData),
      card2: _buildWeekendHolidayOTCard(summaryData),
    );
  }
  
  Widget _buildOvertimeThisWeekCard(Map<String, String> summaryData, double progressValue) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overtime this week:',
            style: PalmTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            summaryData['totalHours'] ?? '0h 0m',
            style: PalmTextStyles.title.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Of 20 hours',
            style: PalmTextStyles.label.copyWith(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          // Progress bar
          _buildProgressBar(progressValue),
        ],
      ),
    );
  }
  
  Widget _buildEligibleDaysCard(Map<String, String> summaryData, int attendanceRate) {
    return _buildGlassCard(
      opacity: 0.16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eligible days:',
            style: PalmTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              // SyncFusion Circular Chart
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(top: 8),
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  series: <CircularSeries>[
                    DoughnutSeries<_ChartData, String>(
                      dataSource: [
                        _ChartData('Eligible', attendanceRate.toDouble()),
                        _ChartData('Remaining', 100 - attendanceRate.toDouble()),
                      ],
                      pointColorMapper: (_ChartData data, _) => 
                        data.x == 'Eligible' ? const Color(0xFF28B463) : Colors.transparent,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      innerRadius: '70%',
                      radius: '100%',
                    )
                  ],
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Text(
                        '$attendanceRate%',
                        style: PalmTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summaryData['attendanceRate'] ?? '0/0',
                    style: PalmTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Days with\novertime',
                    style: PalmTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAverageOTHoursCard(Map<String, String> summaryData) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Average OT hours:',
            style: PalmTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summaryData['averageHours'] ?? '0h 0m',
            style: PalmTextStyles.title.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeekendHolidayOTCard(Map<String, String> summaryData) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Weekend/Holiday OT:',
            style: PalmTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            // For now, using absentHours as placeholder for weekend/holiday OT
            // You'll need to add this data to your service
            summaryData['weekendHolidayOT'] ?? '0h 0m',
            style: PalmTextStyles.title.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttendanceRateCard(Map<String, String> summaryData, int attendanceRate) {
    return _buildGlassCard(
      opacity: 0.16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance rate:',
            style: PalmTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              // SyncFusion Circular Chart
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(top: 8),
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  series: <CircularSeries>[
                    DoughnutSeries<_ChartData, String>(
                      dataSource: [
                        _ChartData('Attended', attendanceRate.toDouble()),
                        _ChartData('Remaining', 100 - attendanceRate.toDouble()),
                      ],
                      pointColorMapper: (_ChartData data, _) => 
                        data.x == 'Attended' ? const Color(0xFF28B463) : Colors.transparent,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      innerRadius: '70%',
                      radius: '100%',
                    )
                  ],
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Text(
                        '$attendanceRate%',
                        style: PalmTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    summaryData['attendanceRate'] ?? '0/0',
                    style: PalmTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Days present',
                    style: PalmTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildAverageHoursCard(Map<String, String> summaryData) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Average working\nhours:',
            style: PalmTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summaryData['averageHours'] ?? '0 Hours',
            style: PalmTextStyles.title.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAbsentHoursCard(Map<String, String> summaryData) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Absent hours:',
            style: PalmTextStyles.label.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summaryData['absentHours'] ?? '0 Hours',
            style: PalmTextStyles.title.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGlassCard({required Widget child, double opacity = 0.1}) {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.s),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(15),
        
      ),
      child: child,
    );
  }
  
  Widget _buildProgressBar(double progress) {
    return Container(
      width: 131,
      height: 3,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 131 * progress,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF28B463), // Green color from Figma
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}