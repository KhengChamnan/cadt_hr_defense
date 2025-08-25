import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_theme.dart';
import '../../../../models/payroll/account/account_statement.dart';

/// A list tile widget for displaying account statement information
/// 
/// This widget displays:
/// - Transaction type indicator with colored header
/// - Transaction details (note, type, date)
/// - Amount with proper formatting and color coding
/// - Balance information
/// - Tap functionality for viewing transaction details
class AccountStatementTile extends StatelessWidget {
  /// The account statement to display
  final AccountStatement statement;
  
  /// Callback when the tile is tapped (for statement details)
  final VoidCallback onTap;

  /// Creates an account statement list tile widget
  const AccountStatementTile({
    super.key,
    required this.statement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCredit = statement.amountAsDouble >= 0;
    final String formattedAmount = NumberFormat('#,##0.00').format(
      statement.amountAsDouble.abs(),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: PalmSpacings.xxs,
          horizontal: PalmSpacings.xs,
        ),
        decoration: const BoxDecoration(
          // Remove margin, padding, and border radius for seamless list
        ),
        child: Column(
          children: [
            // Header section with transaction type and amount
            Container(
              width: double.infinity,
              height: 31,
              decoration: BoxDecoration(
                color: isCredit 
                    ? PalmColors.success.withOpacity(0.8)
                    : PalmColors.danger.withOpacity(0.8),
                // Remove border radius for flat design
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Text(
                    isCredit ? 'Credit' : 'Debit',
                    style: PalmTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      // Remove border radius for flat design
                    ),
                    child: Text(
                      statement.dateForGrouping.isNotEmpty 
                          ? statement.dateForGrouping
                          : 'No Date',
                      style: PalmTextStyles.button.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            // Content section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                // Remove border radius for flat design
                border: Border.all(
                  color: isCredit 
                      ? PalmColors.success.withOpacity(0.2)
                      : PalmColors.danger.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  // Transaction details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Note/Description row
                        Row(
                          children: [
                            // Note icon
                            Container(
                              width: 15,
                              height: 15,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: PalmColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Icon(
                                Icons.description,
                                size: 11,
                                color: PalmColors.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                statement.note.isNotEmpty ? statement.note : '-',
                                style: PalmTextStyles.body.copyWith(
                                  color: PalmColors.textNormal,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Amount display at the end
                  const SizedBox(width: 16),
                  Text(
                    '${isCredit ? '+' : '-'}\$${formattedAmount}',
                    style: PalmTextStyles.body.copyWith(
                      color: isCredit ? PalmColors.success : PalmColors.danger,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
