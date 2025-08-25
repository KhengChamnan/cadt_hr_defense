import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import '../../../utils/responsive.dart';
import '../../../services/attendance_statistics_service.dart';
import '../../../providers/attendance/attendance_provider.dart';

class AttendancePieChart extends StatelessWidget {
  const AttendancePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, attendanceProvider, child) {
        // Get chart data from service
        final List<AttendanceData> chartData = _getChartData(attendanceProvider);
        final pieChartData = _getPieChartData(attendanceProvider);

        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: double.infinity,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2C5282),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title section
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Attendance Overview',
                        style: TextStyle( 
                          color: Colors.white,
                          fontSize: MobileResponsive.fontSize(
                            context, 
                            phone: 14, 
                            tablet: 16,
                          ),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pieChartData?.monthYear ?? 'June 2025',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MobileResponsive.fontSize(
                            context, 
                            phone: 12, 
                            tablet: 14,
                          ),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Chart and legend section
              PieChart(chartData: chartData, totalDays: pieChartData?.totalWorkingDays ?? 21),
            ],
          ),
        );
      },
    );
  }

  List<AttendanceData> _getChartData(AttendanceProvider provider) {
    if (provider.attendanceList?.data != null) {
      // Calculate real data from attendance records
      final stats = AttendanceStatisticsService.calculateMonthlyStats(
        provider.attendanceList!.data!,
        targetMonth: DateTime.now(), // May 2023 to match dummy data
      );
      
      return stats.toChartData().map((data) => AttendanceData(
        data.category,
        data.value,
        data.color,
        data.percentage,
        data.icon,
      )).toList();
    } else {
      // Return mock data if no real data available
      return [
        AttendanceData('Early', 15, const Color(0xFF4CAF50), '71.43%', Icons.check_circle),
        AttendanceData('Late', 3, const Color(0xFFFF928A), '14.29%', Icons.watch_later),
        AttendanceData('Ontime', 3, const Color(0xFF3CC3DF), '14.29%', Icons.access_time_filled),
      ];
    }
  }

  AttendancePieChartData? _getPieChartData(AttendanceProvider provider) {
    if (provider.attendanceList?.data != null) {
      return AttendanceStatisticsService.calculateMonthlyStats(
        provider.attendanceList!.data!,
        targetMonth: DateTime.now(), 
      );
    }
    return null;
  }
}

class PieChart extends StatelessWidget {
  const PieChart({
    super.key,
    required this.chartData,
    required this.totalDays,
  });

  final List<AttendanceData> chartData;
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Chart
          Expanded(
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              series: <CircularSeries>[
                DoughnutSeries<AttendanceData, String>(
                  dataSource: chartData,
                  pointColorMapper: (AttendanceData data, _) => data.color,
                  xValueMapper: (AttendanceData data, _) => data.category,
                  yValueMapper: (AttendanceData data, _) => data.value,
                  innerRadius: '50%',
                  radius: '90%',
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    alignment: ChartAlignment.center,
                    angle: 0,
                    labelIntersectAction: LabelIntersectAction.shift,
                    connectorLineSettings: const ConnectorLineSettings(
                      type: ConnectorType.curve,
                    ),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: MobileResponsive.fontSize(context, phone: 10, tablet: 12),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                    useSeriesColor: false,
                  ),
                  dataLabelMapper: (AttendanceData data, _) => data.value > 0 ? data.percentage : '',
                )
              ],
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$totalDays',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MobileResponsive.fontSize(context, phone: 18, tablet: 18),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Days',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MobileResponsive.fontSize(context, phone: 12, tablet: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Right side: Legend
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: chartData.map((data) {
                return LegendItem(data: data);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final AttendanceData data;
  
  const LegendItem({super.key, required this.data});
  
  @override
  Widget build(BuildContext context) {
    // Get responsive font size based on device type
    final fontSize = MobileResponsive.fontSize(context, phone: 10, tablet: 14);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MobileResponsive.responsive(context, phone: 14, tablet: 18),
            alignment: Alignment.centerLeft,
            child: Icon(
              data.icon,
              color: data.color,
              size: MobileResponsive.responsive(context, phone: 12, tablet: 16),
            ),
          ),
          SizedBox(width: MobileResponsive.responsive(context, phone: 4, tablet: 6)),
          SizedBox(
            width: MobileResponsive.responsive(context, phone: 100, tablet: 120),
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontFamily: 'Inter',
                ),
                children: [
                  TextSpan(
                    text: data.category,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: '${data.value}',
                    style: TextStyle(
                      color: data.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceData {
  final String category;
  final int value;
  final Color color;
  final String percentage;
  final IconData icon;

  AttendanceData(this.category, this.value, this.color, this.percentage, this.icon);
} 