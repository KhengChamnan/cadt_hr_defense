import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/achievement/achievement_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/daily_activities_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/traning/training_overview_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

class ActivitieScreen extends StatelessWidget {
  const ActivitieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities', style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: PalmColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(PalmSpacings.m),
        child: Column(
          children: [
            const SizedBox(height: PalmSpacings.m),
            
            // Training
            ActivityListTile(
              title: 'Training',
              icon: Icons.school,
              onTap: () {
                // Navigate to Training Overview screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrainingOverviewScreen()),
                );
              },
            ),
            
            // Daily Activity
            ActivityListTile(
              title: 'Daily Activity',
              icon: Icons.today,
              onTap: () {
                // Navigate to Daily Activity screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DailyActivitiesScreen()),
                );
              },
            ),
            
            // Achievement
            ActivityListTile(
              title: 'Achievement',
              icon: Icons.emoji_events,
              onTap: () {
                // Navigate to Achievement screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AchievementScreen()),
                );
              },
            ),
            
            // Target Setting
            ActivityListTile(
              title: 'Target Setting',
              icon: Icons.track_changes,
              onTap: () {
                // Navigate to Target Setting screen
                print('Target Setting tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable widget for activity list items
/// - Displays an activity item with icon and title
/// - Includes a right arrow for navigation
/// - Matches the design pattern from ReportMenuItem
class ActivityListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ActivityListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 61,
        margin: const EdgeInsets.only(bottom: PalmSpacings.m),
        decoration: BoxDecoration(
          color: PalmColors.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m),
          child: Row(
            children: [
              // Activity icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: PalmSpacings.m),
              
              // Activity title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Right arrow icon
              const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}