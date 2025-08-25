import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/attendance_menu_grid.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/leave_menu_grid.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/personnel_menu_grid.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/payroll_menu_grid.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/simple_app_bar.dart';

class AppFeature extends StatefulWidget {
  const AppFeature({super.key});

  @override
  State<AppFeature> createState() => _AppFeatureState();
}

class _AppFeatureState extends State<AppFeature> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    // Set system UI overlay style to have black status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    
    return Scaffold(
      backgroundColor: PalmColors.white,
      body: Column(
        children: [
          SimpleAppBar(title: 'App'),
          Container(
            color: PalmColors.primary,
            child: TabBar(
              controller: _tabController,
              indicatorColor: PalmColors.white,
              labelColor: PalmColors.white,
              unselectedLabelColor: PalmColors.white.withOpacity(0.7),
              tabs: const [
                Tab(
                  icon: Icon(Icons.access_time),
                  text: 'Attendance',
                ),
                Tab(
                  icon: Icon(Icons.logout_outlined),
                  text: 'Leave',
                ),
                Tab(
                  icon: Icon(Icons.people),
                  text: 'Personnel',
                ),
                Tab(
                  icon: Icon(Icons.attach_money),
                  text: 'Payroll',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAttendanceTab(),
                _buildLeaveTab(),
                _buildPersonnelTab(),
                _buildPayrollTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// Build leave tab with actions and overview
  Widget _buildLeaveTab() {
    return const Padding(
      padding: EdgeInsets.all(PalmSpacings.m),
      child: LeaveMenuGrid(),
    );
  }


  /// Build attendance tab with actions and overview
  Widget _buildAttendanceTab() {
    return const Padding(
      padding: EdgeInsets.all(PalmSpacings.m),
      child: AttendanceMenuGrid(),
    );
  }

  /// Build personnel tab with actions and overview
  Widget _buildPersonnelTab() {
    return const Padding(
      padding: EdgeInsets.all(PalmSpacings.m),
      child: PersonnelMenuGrid(),
    );
  }

  /// Build payroll tab with actions and overview
  Widget _buildPayrollTab() {
    return const Padding(
      padding: EdgeInsets.all(PalmSpacings.m),
      child: PayrollMenuGrid(),
    );
  }
}





