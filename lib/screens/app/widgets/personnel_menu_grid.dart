import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/app_menu_item.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/activitie_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/achievement/achievement_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/achievement/widgets/achievement_form_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/daily_activities_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/widgets/daily_activity_form_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/traning/training_overview_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/traning/widgets/request_traning_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/payroll/team_structure/team_structure_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/test/staff_info_test.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A grid menu displaying personnel-related actions and overview sections
class PersonnelMenuGrid extends StatelessWidget {
  const PersonnelMenuGrid({super.key});

  /// Navigate to training overview screen
  void _navigateToTraining(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrainingOverviewScreen(),
      ),
    );
  }

  /// Navigate to daily activities screen
  void _navigateToActivities(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DailyActivitiesScreen(),
      ),
    );
  }

  /// Navigate to achievements screen
  void _navigateToAchievements(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AchievementScreen(),
      ),
    );
  }

  /// Navigate to daily activity form screen
  void _navigateToDailyActivityForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DailyActivityFormScreen(),
      ),
    );
  }

  /// Navigate to achievement form screen
  void _navigateToAchievementForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AchievementFormScreen(),
      ),
    );
  }

  /// Navigate to training request form screen
  void _navigateToTrainingForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TrainingScreen(),
      ),
    );
  }
  void _navigateToStaff(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StaffInfoTestScreen(),
      ),
    );
  }

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
                title: 'Activity\nRequest',
                icon: Icons.assignment_add,
                onTap: () => _navigateToDailyActivityForm(context),
              ),
              MenuItemWidget(
                title: 'Achievement\nRequest',
                icon: Icons.emoji_events_outlined,
                onTap: () => _navigateToAchievementForm(context),
              ),
              MenuItemWidget(
                title: 'Training\nRequest',
                icon: Icons.library_add_outlined,
                onTap: () => _navigateToTrainingForm(context),
              ),
              MenuItemWidget(
                title: 'Staff',
                icon: Icons.person_add,
                onTap: () => _navigateToStaff(context),
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
                title: 'Training',
                icon: Icons.school,
                onTap: () => _navigateToTraining(context),
              ),
               MenuItemWidget(
                title: 'Activity',
                icon: Icons.timeline,
                onTap: () => _navigateToActivities(context),
              ),
               MenuItemWidget(
                title: 'Achievements',
                icon: Icons.emoji_events,
                onTap: () => _navigateToAchievements(context),
              ),
              MenuItemWidget(
                title: 'Team',
                icon: Icons.groups,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeamStructureScreen(),
                    ),
                  );
                },
              ),
              const MenuItemWidget(
                title: 'My Profile',
                icon: Icons.account_circle,
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}
