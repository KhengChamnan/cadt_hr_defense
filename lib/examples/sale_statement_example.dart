import 'package:flutter/material.dart';
import '../screens/payroll/sale_statement/sale_statement_screen.dart';

/// Example usage of the SaleStatementScreen
/// This shows how to navigate to the sale statement screen from other parts of the app
class SaleStatementExample {
  
  /// Navigate to sale statement screen from any context
  static void navigateToSaleStatement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaleStatementScreen(),
      ),
    );
  }

  /// Example button widget that opens sale statement
  static Widget buildSaleStatementButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => navigateToSaleStatement(context),
      icon: const Icon(Icons.receipt_long),
      label: const Text('View Sale Statement'),
    );
  }
}
