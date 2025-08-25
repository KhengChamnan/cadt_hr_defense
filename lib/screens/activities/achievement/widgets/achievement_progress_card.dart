import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// A card widget that displays achievement progress summary
/// Shows total target vs actual with percentage and visual progress indicator
class AchievementProgressCard extends StatelessWidget {
  final double totalTarget;
  final double totalActual;
  final double overallPercentage;
  final int completedCount;
  final int totalCount;

  const AchievementProgressCard({
    Key? key,
    required this.totalTarget,
    required this.totalActual,
    required this.overallPercentage,
    required this.completedCount,
    required this.totalCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              PalmColors.primary,
              PalmColors.primary.withOpacity(0.8),
              PalmColors.primary.withOpacity(0.6),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: PalmColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: PalmColors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Overall Progress',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: PalmColors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Progress Charts Section
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${overallPercentage.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: PalmColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Achievement Rate',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PalmColors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildRadialBarChart(),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: _buildProgressColumnChart(),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Target',
                    totalTarget.toStringAsFixed(0),
                    Icons.flag_outlined,
                    Colors.blue[600]!,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Actual',
                    totalActual.toStringAsFixed(0),
                    Icons.check_circle_outline,
                    Colors.green[600]!,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Completed',
                    '$completedCount/$totalCount',
                    Icons.task_alt,
                    Colors.purple[600]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildRadialBarChart() {
    return SizedBox(
      height: 120,
      child: SfCircularChart(
        series: <CircularSeries>[
          RadialBarSeries<ChartData, String>(
            dataSource: [
              ChartData('Progress', overallPercentage, _getProgressColor()),
            ],
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            pointColorMapper: (ChartData data, _) => data.color,
            maximumValue: 100,
            radius: '100%',
            innerRadius: '70%',
            cornerStyle: CornerStyle.bothCurve,
            trackOpacity: 0.3,
            trackColor: Colors.grey[300]!,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.inside,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              builder: (data, point, series, pointIndex, seriesIndex) {
                return Text(
                  '${overallPercentage.toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressColumnChart() {
    return SizedBox(
      height: 150,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          labelStyle: const TextStyle(fontSize: 12),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(
            width: 0.5,
            color: Colors.grey,
            dashArray: [3, 3],
          ),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          labelStyle: const TextStyle(fontSize: 12),
        ),
        plotAreaBorderWidth: 0,
        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: [
              ChartData('Target', totalTarget, Colors.blue[600]!),
              ChartData('Actual', totalActual, Colors.green[600]!),
            ],
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            pointColorMapper: (ChartData data, _) => data.color,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            width: 0.6,
            spacing: 0.3,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x: point.y',
          textStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: PalmColors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: PalmColors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: PalmColors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Color _getProgressColor() {
    if (overallPercentage >= 100) {
      return Colors.green[600]!;
    } else if (overallPercentage >= 80) {
      return Colors.blue[600]!;
    } else if (overallPercentage >= 50) {
      return Colors.orange[600]!;
    } else {
      return Colors.red[600]!;
    }
  }
}

/// Data model for chart data
class ChartData {
  final String category;
  final double value;
  final Color color;

  ChartData(this.category, this.value, this.color);
}
