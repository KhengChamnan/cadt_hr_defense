import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/app_menu_item.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/approval/pending_approval_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_overview/leave_overview_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/date_range_bottom_sheet.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/leave_type_selection_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/animations_util.dart';

import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A grid menu displaying leave-related actions and overview sections
class LeaveMenuGrid extends StatelessWidget {
  const LeaveMenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My Leave Section (Personal Actions)
          Padding(
            padding: const EdgeInsets.only(
                left: PalmSpacings.m,
                top: PalmSpacings.m,
                bottom: PalmSpacings.s),
            child: Text(
              'My Leave',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PalmSpacings.m,
                right: PalmSpacings.m,
                bottom: PalmSpacings.s),
            child: Text(
              'Manage your personal leave requests',
              style: PalmTextStyles.caption.copyWith(
                color: PalmColors.textLight,
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
                title: 'Request Leave',
                icon: Icons.assignment_add,
                onTap: () async {
                  // Show date range bottom sheet
                  final result = await DateRangeBottomSheet.show(
                    context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  // If dates were selected, navigate to leave type selection screen
                  if (result != null) {
                    Navigator.push(
                      context,
                      AnimationUtils.createBottomToTopRoute(
                        LeaveTypeSelectionScreen(
                          startDate: result['startDate']!,
                          endDate: result['endDate']!,
                        ),
                      ),
                    );
                  }
                },
              ),
              MenuItemWidget(
                title: 'Leave History',
                icon: Icons.history,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaveOverviewScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          // Management Section (For Managers/HR)
          Padding(
            padding: const EdgeInsets.only(
                left: PalmSpacings.m,
                top: PalmSpacings.l,
                bottom: PalmSpacings.s),
            child: Text(
              'Management',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: PalmSpacings.m,
                right: PalmSpacings.m,
                bottom: PalmSpacings.s),
            child: Text(
              'Review and approve staff leave requests',
              style: PalmTextStyles.caption.copyWith(
                color: PalmColors.textLight,
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
                title: 'Pending Approvals',
                icon: Icons.pending_actions,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PendingApprovalScreen(title: 'Pending Approvals'),
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
