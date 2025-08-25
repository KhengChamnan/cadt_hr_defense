import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/payroll/commission/commission.dart';

/// Example of how to use the new commission screen:
/// This shows how to navigate to the commission screen from your app
void navigateToCommissionScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PalmCommissionScreen(),
    ),
  );
}

/// Example usage in a menu or button:
class CommissionMenuExample extends StatelessWidget {
  const CommissionMenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => navigateToCommissionScreen(context),
      child: const Text('View Commission Statement'),
    );
  }
}
