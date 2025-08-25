import 'package:flutter/material.dart';
import '../screens/payroll/account/palm_account_screen.dart';

/// Example usage of the Palm Account Screen
/// 
/// This demonstrates how to navigate to and use the modernized account screen
/// that follows the Palm HR design system and coding conventions.
class AccountScreenExample extends StatelessWidget {
  const AccountScreenExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _navigateToAccount(context),
          child: const Text('View Account'),
        ),
      ),
    );
  }

  /// Navigate to the Palm Account Screen
  /// The AccountProvider is already registered in providers_setup.dart
  void _navigateToAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PalmAccountScreen(),
      ),
    );
  }
}

/// Example of how to integrate the account screen in your app routing
class AppRoutes {
  static const String account = '/account';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      account: (context) => const PalmAccountScreen(),
    };
  }
}

/// Example navigation helper
class NavigationHelper {
  static void goToAccount(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.account);
  }
}
