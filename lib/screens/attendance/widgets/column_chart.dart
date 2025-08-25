import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ColumnChart extends StatelessWidget {
  final List<double> barData;
  final double maxY;
  final String title;
  final List<String>? customLabels;

  const ColumnChart({
    super.key, 
    required this.barData,
    required this.maxY,
    required this.title,
    this.customLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      margin: const EdgeInsets.symmetric(horizontal: PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      height: 350, // Fixed height to prevent layout issues
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Chart area
          Expanded(
            child: CustomBarChart(
              barData: barData,
              maxY: maxY,
              customLabels: customLabels,
            ),
          ),
          
          // Legend
          Padding(
            padding: const EdgeInsets.only(top: PalmSpacings.m),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8979FF),
                    border: Border.all(color: PalmColors.white),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: PalmTextStyles.label.copyWith(
                    color: PalmColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  final List<double> barData;
  final double maxY;
  final List<String> months = const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final List<String>? customLabels;
  
  const CustomBarChart({
    super.key,
    required this.barData,
    required this.maxY,
    this.customLabels,
  });

  @override
  Widget build(BuildContext context) {
    // Determine if we're showing monthly or yearly data based on custom labels
    final bool isYearlyData = customLabels != null;
    
    // Use provided custom labels or default month labels
    final labels = isYearlyData ? customLabels! : months.sublist(0, barData.length);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Y-axis labels
        SizedBox(
          width: 30,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${maxY.toInt()}', style: PalmTextStyles.label.copyWith(color: PalmColors.textLight)),
              Text('${(maxY * 0.8).toInt()}', style: PalmTextStyles.label.copyWith(color: PalmColors.textLight)),
              Text('${(maxY * 0.6).toInt()}', style: PalmTextStyles.label.copyWith(color: PalmColors.textLight)),
              Text('${(maxY * 0.4).toInt()}', style: PalmTextStyles.label.copyWith(color: PalmColors.textLight)),
              Text('${(maxY * 0.2).toInt()}', style: PalmTextStyles.label.copyWith(color: PalmColors.textLight)),
              Text('0', style: PalmTextStyles.label.copyWith(color: PalmColors.textLight)),
            ],
          ),
        ),
        
        const SizedBox(width: 4), // Add spacing after Y-axis labels
        
        // Chart area
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bars area
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: BarChartPainter(
                        barData: barData,
                        maxY: maxY,
                      ),
                    );
                  }
                ),
              ),
              
              // X-axis labels
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: labels.map((label) => 
                      Text(
                        label,
                        style: PalmTextStyles.label.copyWith(
                          color: PalmColors.textLight,
                          fontSize: 10, // Slightly smaller font for better fit
                        ),
                      )
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> barData;
  final double maxY;
  
  BarChartPainter({
    required this.barData,
    required this.maxY,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    
    final barWidth = 15.0; // Slightly narrower bars
    final availableWidth = size.width * 0.95; // Use 95% of available width for better margins
    final barSpacing = (availableWidth - barWidth * barData.length) / (barData.length - 1);
    final leftPadding = (size.width - availableWidth) / 2; // Center the bars
    
    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    final dashWidth = 2.0;
    final dashSpace = 2.0;
    
    // Horizontal grid lines
    for (int i = 0; i <= 5; i++) {
      final y = size.height - (size.height * i / 5);
      
      final path = Path();
      path.moveTo(0, y);
      
      double distance = 0;
      bool draw = true;
      
      while (distance < size.width) {
        if (draw) {
          path.lineTo(distance + dashWidth, y);
          distance += dashWidth;
        } else {
          path.moveTo(distance + dashSpace, y);
          distance += dashSpace;
        }
        draw = !draw;
      }
      
      canvas.drawPath(path, gridPaint);
    }
    
    // Draw bars with new color
    final barPaint = Paint()
      ..color = const Color(0xFF8979FF) // New color 8979FF
      ..style = PaintingStyle.fill;
    
    final textStyle = PalmTextStyles.label.copyWith(
      color: PalmColors.textLight,
      fontSize: 10,
    );
    
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    for (int i = 0; i < barData.length; i++) {
      final x = leftPadding + i * (barWidth + barSpacing);
      
      // Skip drawing the bar if the value is 0
      if (barData[i] <= 0) {
        // Only draw the value text
        textPainter.text = TextSpan(text: '0', style: textStyle);
        textPainter.layout();
        
        textPainter.paint(
          canvas, 
          Offset(x + (barWidth - textPainter.width) / 2, size.height - textPainter.height - 4)
        );
        continue;
      }
      
      final barHeight = (barData[i] / maxY) * size.height * 0.85; // Use 85% of height for better visualization
      final top = size.height - barHeight;
      
      // Draw bar
      canvas.drawRect(
        Rect.fromLTWH(x, top, barWidth, barHeight),
        barPaint,
      );
      
      // Draw value label
      final valueText = barData[i].toStringAsFixed(
        barData[i].truncateToDouble() == barData[i] ? 0 : 1
      );
      textPainter.text = TextSpan(text: valueText, style: textStyle);
      textPainter.layout();
      
      textPainter.paint(
        canvas, 
        Offset(x + (barWidth - textPainter.width) / 2, top - textPainter.height - 4)
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 