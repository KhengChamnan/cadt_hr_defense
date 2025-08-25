import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/// An enhanced achievement dashboard widget with multiple SyncFusion charts
/// Shows comprehensive progress analytics with various chart types
class EnhancedAchievementDashboard extends StatelessWidget {
  final double totalTarget;
  final double totalActual;
  final double overallPercentage;
  final int completedCount;
  final int totalCount;
  final List<MonthlyProgress>? monthlyData;

  const EnhancedAchievementDashboard({
    Key? key,
    required this.totalTarget,
    required this.totalActual,
    required this.overallPercentage,
    required this.completedCount,
    required this.totalCount,
    this.monthlyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Progress Card
        Card(
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with animated icon
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: PalmColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.analytics_outlined,
                        color: PalmColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Achievement Analytics',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: PalmColors.white,
                            ),
                          ),
                          Text(
                            'Real-time progress tracking',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: PalmColors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildPerformanceBadge(),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Charts Section
                Row(
                  children: [
                    // Gauge Chart
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            'Overall Progress',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: PalmColors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildGaugeChart(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Doughnut Chart
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            'Completion Status',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: PalmColors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDoughnutChart(),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Progress Comparison Chart
                Text(
                  'Target vs Achievement',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: PalmColors.white,
                  ),
                ),
                const SizedBox(height: 12),
                _buildProgressComparisonChart(),
                
                const SizedBox(height: 24),
                
                // Stats Grid
                _buildStatsGrid(context),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Monthly Trend Chart (if data available)
        if (monthlyData != null && monthlyData!.isNotEmpty)
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Monthly Progress Trend',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMonthlyTrendChart(),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPerformanceBadge() {
    String badgeText;
    Color badgeColor;
    
    if (overallPercentage >= 100) {
      badgeText = 'Excellent';
      badgeColor = Colors.green[600]!;
    } else if (overallPercentage >= 80) {
      badgeText = 'Good';
      badgeColor = Colors.blue[600]!;
    } else if (overallPercentage >= 60) {
      badgeText = 'Average';
      badgeColor = Colors.orange[600]!;
    } else {
      badgeText = 'Needs Focus';
      badgeColor = Colors.red[600]!;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          color: badgeColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGaugeChart() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          SfCircularChart(
            series: <CircularSeries>[
              RadialBarSeries<ChartData, String>(
                dataSource: [
                  ChartData('Progress', overallPercentage, _getProgressColor()),
                ],
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value,
                pointColorMapper: (ChartData data, _) => data.color,
                maximumValue: 100,
                radius: '90%',
                innerRadius: '65%',
                cornerStyle: CornerStyle.bothCurve,
                trackOpacity: 0.3,
                trackColor: Colors.grey[300]!,
                gap: '10%',
                dataLabelSettings: const DataLabelSettings(isVisible: false),
              ),
            ],
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${overallPercentage.toInt()}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: PalmColors.white,
                  ),
                ),
                Text(
                  'Complete',
                  style: TextStyle(
                    fontSize: 12,
                    color: PalmColors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoughnutChart() {
    final completed = (totalCount * overallPercentage / 100).round();
    final remaining = totalCount - completed;
    
    return SizedBox(
      height: 160,
      child: SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<ChartData, String>(
            dataSource: [
              ChartData('Completed', completed.toDouble(), Colors.green[600]!),
              ChartData('Remaining', remaining.toDouble(), Colors.grey[300]!),
            ],
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            pointColorMapper: (ChartData data, _) => data.color,
            innerRadius: '60%',
            explode: true,
            explodeIndex: 0,
            explodeOffset: '10%',
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              useSeriesColor: true,
              textStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: const TextStyle(fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildProgressComparisonChart() {
    return SizedBox(
      height: 120,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(
            width: 0.5,
            color: Colors.grey,
            dashArray: [3, 3],
          ),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
        ),
        plotAreaBorderWidth: 0,
        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: [
              ChartData('Target', totalTarget, Colors.blue[400]!),
              ChartData('Achieved', totalActual, _getProgressColor()),
            ],
            xValueMapper: (ChartData data, _) => data.category,
            yValueMapper: (ChartData data, _) => data.value,
            pointColorMapper: (ChartData data, _) => data.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            width: 0.7,
            spacing: 0.2,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.blue[400]!.withOpacity(0.7),
                Colors.blue[400]!,
              ],
            ),
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              textStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendChart() {
    return SizedBox(
      height: 200,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(
            width: 0.5,
            color: Colors.grey,
            dashArray: [3, 3],
          ),
          axisLine: const AxisLine(width: 0),
        ),
        plotAreaBorderWidth: 0,
        series: <CartesianSeries>[
          SplineAreaSeries<MonthlyProgress, String>(
            dataSource: monthlyData!,
            xValueMapper: (MonthlyProgress data, _) => data.month,
            yValueMapper: (MonthlyProgress data, _) => data.percentage,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _getProgressColor().withOpacity(0.6),
                _getProgressColor().withOpacity(0.1),
              ],
            ),
            borderColor: _getProgressColor(),
            borderWidth: 3,
            markerSettings: MarkerSettings(
              isVisible: true,
              color: _getProgressColor(),
              borderColor: Colors.white,
              borderWidth: 2,
            ),
          ),
        ],
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x: point.y%',
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Target',
            totalTarget.toStringAsFixed(0),
            Icons.flag_outlined,
            Colors.blue[600]!,
            'Total goal to achieve',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Achieved',
            totalActual.toStringAsFixed(0),
            Icons.check_circle_outline,
            Colors.green[600]!,
            'Current achievement',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Tasks',
            '$completedCount/$totalCount',
            Icons.task_alt,
            Colors.purple[600]!,
            'Completed tasks',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PalmColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: PalmColors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: PalmColors.white,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: PalmColors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: PalmColors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: PalmColors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

/// Data model for monthly progress tracking
class MonthlyProgress {
  final String month;
  final double percentage;
  final double target;
  final double actual;

  MonthlyProgress({
    required this.month,
    required this.percentage,
    required this.target,
    required this.actual,
  });
}
