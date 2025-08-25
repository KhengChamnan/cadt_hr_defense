import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_data.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A pie chart widget that displays leave data in a visual format
/// - Shows a doughnut chart with leave types and their respective days
/// - Displays a legend with color-coded leave categories
class LeavePieChart extends StatelessWidget {
  const LeavePieChart({
    super.key,
    required this.chartData,
  });

  final List<LeaveData> chartData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: Chart
              Expanded(
                flex: 2,
                child: SfCircularChart(
                  margin: const EdgeInsets.all(4),
                  series: <CircularSeries>[
                    PieSeries<LeaveData, String>(
                      dataSource: chartData,
                      pointColorMapper: (LeaveData data, _) => data.color,
                      xValueMapper: (LeaveData data, _) => data.category,
                      yValueMapper: (LeaveData data, _) => data.value,
                      radius: '65%',
                      explodeAll: false,
                      // Better handling of zero/small values
                      emptyPointSettings: EmptyPointSettings(
                        mode: EmptyPointMode.gap,
                        color: Colors.transparent,
                      ),
                      // Add tooltip for better accessibility
                      enableTooltip: true,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        useSeriesColor: false,
                        showZeroValue:
                            false, // Don't show labels for zero values
                        overflowMode: OverflowMode.hide,
                        labelIntersectAction: LabelIntersectAction.hide,
                        // Dynamic font size based on segment value
                        builder: (dynamic data, dynamic point, dynamic series,
                            int pointIndex, int seriesIndex) {
                          // Calculate percentage for this segment using actual balance
                          double total = chartData.fold(
                              0,
                              (sum, item) =>
                                  sum + (item.actualBalance ?? item.value));
                          double actualValue = data.actualBalance ?? data.value;

                          if (total == 0 || actualValue <= 0) {
                            return Container(); // Don't show label for zero values
                          }

                          double percentage = (actualValue / total) * 100;

                          // Adjust font size based on percentage
                          double fontSize;
                          if (percentage < 12) {
                            fontSize = 8;
                          } else if (percentage < 20) {
                            fontSize = 10;
                          } else if (percentage < 30) {
                            fontSize = 12;
                          } else {
                            fontSize = 14;
                          }

                          return Container(
                            padding: EdgeInsets.all(1),
                            child: Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: PalmTextStyles.label.copyWith(
                                color: PalmColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),

              // Right side: Legend
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: PalmSpacings.xs),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: chartData.map((data) {
                      return LeaveTypeLegendItem(data: data);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Leave balance text at the bottom
        Padding(
          padding: const EdgeInsets.only(
              top: PalmSpacings.xs, bottom: PalmSpacings.xs),
          child: Center(
            child: Text(
              'Leave Balance',
              style: PalmTextStyles.label.copyWith(
                color: PalmColors.white.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A legend item for the leave pie chart
/// - Shows a colored circle representing the leave type
/// - Displays the category name and value
class LeaveTypeLegendItem extends StatelessWidget {
  final LeaveData data;

  const LeaveTypeLegendItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: data.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: PalmColors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          const SizedBox(width: PalmSpacings.s),
          Text(
            data.category,
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: PalmSpacings.s),
          Text(
            '${(data.actualBalance ?? data.value).toInt()}',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage:
/*
final leaveChartData = [
  LeaveData(category: 'Annual', value: 14, color: Colors.blue),
  LeaveData(category: 'Sick', value: 7, color: Colors.red),
  LeaveData(category: 'Special', value: 5, color: Colors.green),
  LeaveData(category: 'Maternity', value: 0, color: Colors.purple),
];

LeavePieChart(chartData: leaveChartData)
*/
