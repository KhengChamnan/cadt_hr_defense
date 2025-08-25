import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/attendance_tab_content.dart';
import '../../theme/app_theme.dart';

class AttendanceScreen extends StatefulWidget {
  final int type;
  const AttendanceScreen({super.key,required this.type});
  
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String get _currentDate => DateFormat('MMMM, d').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = _currentDate;
    // Add type indicator to title
    if (widget.type == 1) {
      title = 'Normal Attendance - $title';
    } else if (widget.type == 2) {
      title = 'Overtime - $title';
    } else if (widget.type == 3) {
      title = 'Part Time - $title';
    }

    return Scaffold(
      backgroundColor: PalmColors.white,
      appBar: AppBar(
        title: Text(
          title,
          style: PalmTextStyles.title.copyWith(color: Colors.white),
        ),
        backgroundColor: PalmColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Tab
          AttendanceTabContent(
            tabIndex: 0,
            attendanceType: widget.type,
          ),
          // Weekly Tab
          AttendanceTabContent(
            tabIndex: 1,
            attendanceType: widget.type,
          ),
          // Monthly Tab
          AttendanceTabContent(
            tabIndex: 2,
            attendanceType: widget.type,
          ),
          // Yearly Tab
          AttendanceTabContent(
            tabIndex: 3,
            attendanceType: widget.type,
          ),
        ],
      ),
    );
  }
}