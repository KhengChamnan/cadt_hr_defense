import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../theme/app_theme.dart';
import '../../../../models/payroll/withdrawal_model.dart';

/// This widget displays the account balance header with account information.
/// Shows current balance, account name, and account number in a styled card.
class WithdrawalAccountBalanceCard extends StatelessWidget {
  final WithdrawalModel accountData;

  const WithdrawalAccountBalanceCard({
    super.key,
    required this.accountData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.l),
      margin: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.primary,
        borderRadius: BorderRadius.circular(PalmSpacings.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account information row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountData.accountName,
                    style: PalmTextStyles.body.copyWith(
                      color: PalmColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: PalmSpacings.xxs),
                  Text(
                    accountData.accountNo,
                    style: PalmTextStyles.label.copyWith(
                      color: PalmColors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: PalmSpacings.l),
          
          // Balance display
          Center(
            child: Column(
              children: [
                Text(
                  'CURRENT BALANCE',
                  style: PalmTextStyles.label.copyWith(
                    color: PalmColors.white.withOpacity(0.8),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: PalmSpacings.xs),
                Text(
                  NumberFormat('##0.00#').format(accountData.currentBalance),
                  style: PalmTextStyles.heading.copyWith(
                    color: PalmColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: PalmSpacings.xxs),
                Text(
                  'USD',
                  style: PalmTextStyles.label.copyWith(
                    color: PalmColors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
