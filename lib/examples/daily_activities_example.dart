import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/daily_activities_screen.dart';

/// Example usage of DailyActivitiesScreen
/// 
/// To navigate to the daily activities screen, use:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => const DailyActivitiesScreen(),
///   ),
/// );
/// ```

class DailyActivitiesExample extends StatelessWidget {
  const DailyActivitiesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DailyActivitiesScreen(),
              ),
            );
          },
          child: const Text('Open Daily Activities'),
        ),
      ),
    );
  }
}
