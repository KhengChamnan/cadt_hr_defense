import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/activitie_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/app_menu_item.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/attendance/attendance_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_overview/leave_overview_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/qr/scan.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A grid menu displaying the main app actions and overview sections
class HrMenuGrid extends StatelessWidget {
  const HrMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: PalmSpacings.m,
                top: PalmSpacings.m,
                bottom: PalmSpacings.s),
            child: Text(
              'Actions',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: PalmSpacings.m,
            mainAxisSpacing: PalmSpacings.m,
            padding: const EdgeInsets.all(PalmSpacings.m),
            children: [
              const MenuItemWidget(title: 'Part Time', icon: Icons.work),
              MenuItemWidget(
                  title: 'Over Time',
                  icon: Icons.access_time,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ScanQRCode(typeId: 2),
                      ),
                    );
                  }),
              // MenuItemWidget(
              //     title: 'Leave Request',
              //     icon: Icons.logout,
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => LeaveRequestScreen()),
              //       );
              //     }),
              const MenuItemWidget(title: 'Action', icon: Icons.play_arrow),
              const MenuItemWidget(title: 'Expense', icon: Icons.receipt_long),
              const MenuItemWidget(
                  title: 'Advance\nSalary', icon: Icons.payments),
              const MenuItemWidget(
                  title: 'Staff Loan', icon: Icons.account_balance),
              const MenuItemWidget(title: 'Payroll', icon: Icons.attach_money),
              const MenuItemWidget(
                  title: 'Complaint\nrequest', icon: Icons.support_agent),
              const MenuItemWidget(title: 'Meeting', icon: Icons.meeting_room),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PalmSpacings.m,
                top: PalmSpacings.m,
                bottom: PalmSpacings.s),
            child: Text(
              'Overview',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: PalmSpacings.m,
            mainAxisSpacing: PalmSpacings.m,
            padding: const EdgeInsets.all(PalmSpacings.m),
            children: [
              const MenuItemWidget(title: 'Approval', icon: Icons.approval),
              // MenuItemWidget(
              //     title: 'Leave',
              //     icon: Icons.logout,
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => LeaveOverviewScreen()),
              //       );
              //     }),
              MenuItemWidget(
                  title: 'Attendance',
                  icon: Icons.summarize,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AttendanceScreen(type: 1,)));
                  }),
              const MenuItemWidget(title: 'Part Time', icon: Icons.work),
              MenuItemWidget(
                  title: 'Over Time',
                  icon: Icons.access_time,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendanceScreen(type: 2),
                      ),
                    );
                  }),
                  MenuItemWidget(
                  title: 'Part Time',
                  icon: Icons.access_time,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AttendanceScreen(type: 3),
                      ),
                    );
                  }),
              MenuItemWidget(title: 'Activity', icon: Icons.play_arrow,
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActivitieScreen(),
                  ),
                );
              },),
              const MenuItemWidget(title: 'Expense', icon: Icons.receipt_long),
              const MenuItemWidget(
                  title: 'Advance\nSalary', icon: Icons.payments),
              const MenuItemWidget(
                  title: 'Staff Loan', icon: Icons.account_balance),
              const MenuItemWidget(title: 'KPI', icon: Icons.groups),
              const MenuItemWidget(
                  title: 'Performance', icon: Icons.trending_up),
              const MenuItemWidget(title: 'Team', icon: Icons.people),
              const MenuItemWidget(
                  title: 'Calandar', icon: Icons.calendar_month),
              const MenuItemWidget(title: 'My Task', icon: Icons.task),
              const MenuItemWidget(title: 'Meeting', icon: Icons.meeting_room),
            ],
          ),
        ],
      ),
    );
  }
}
