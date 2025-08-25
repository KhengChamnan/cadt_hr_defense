import 'package:flutter/material.dart';
import '../../widgets/report_selector.dart';

class WeekSelector extends StatefulWidget {
  final Function(int) onWeekChanged;
  final int initialWeek;
  final String month;
  
  const WeekSelector({
    super.key, 
    required this.onWeekChanged,
    this.initialWeek = 1,
    required this.month,
  });

  @override
  State<WeekSelector> createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  late int currentWeek;
  late String currentMonth;
  
  @override
  void initState() {
    super.initState();
    currentWeek = widget.initialWeek;
    currentMonth = widget.month;
  }
  
  void _previousWeek() {
    if (currentWeek > 1) {
      setState(() {
        currentWeek--;
      });
      widget.onWeekChanged(currentWeek);
    }
  }
  
  void _nextWeek() {
    // Assuming 4 weeks in a month for simplicity
    if (currentWeek < 4) {
      setState(() {
        currentWeek++;
      });
      widget.onWeekChanged(currentWeek);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ReportSelector(
      title: 'Week $currentWeek of $currentMonth',
      onPrevious: _previousWeek,
      onNext: _nextWeek,
    );
  }
} 