import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/app_menu_item.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/attendance/attendance_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/qr/scan.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A grid menu displaying attendance-related actions and overview sections
class AttendanceMenuGrid extends StatelessWidget {
  const AttendanceMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Actions Section
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
              
              MenuItemWidget(
                title: 'Over Time',
                icon: Icons.schedule,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanQRCode(typeId: 2),
                    ),
                  );
                },
              ),
              MenuItemWidget(
                title: 'Part Time',
                icon: Icons.schedule_send,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScanQRCode(typeId: 3),
                    ),
                  );
                },
              ),
              
            ],
          ),
          
          // Overview Section
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
              MenuItemWidget(
                title: 'Attendance History',
                icon: Icons.fact_check,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceScreen(type: 1),
                    ),
                  );
                },
              ),
              MenuItemWidget(
                title: 'Over Time History',
                icon: Icons.more_time,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceScreen(type: 2),
                    ),
                  );
                },
              ),
              MenuItemWidget(
                title: 'Part Time History',
                icon: Icons.timer_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceScreen(type: 3),
                    ),
                  );
                },
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}
