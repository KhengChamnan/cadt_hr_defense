import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../models/payroll/account/account_balance.dart';

/// Widget that displays account header information including
/// account name, number and current balance in a card format.
class AccountHeaderCard extends StatelessWidget {
  final AccountBalance accountBalance;

  const AccountHeaderCard({
    super.key,
    required this.accountBalance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(PalmSpacings.m),
      padding: const EdgeInsets.all(PalmSpacings.l),
      decoration: BoxDecoration(
        color: PalmColors.primary,
        borderRadius: BorderRadius.circular(PalmSpacings.radius),
        boxShadow: [
          BoxShadow(
            color: PalmColors.neutralLight.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountName(),
          const SizedBox(height: PalmSpacings.xs),
          _buildAccountNumber(),
          const SizedBox(height: PalmSpacings.l),
          _buildBalanceSection(),
        ],
      ),
    );
  }

  Widget _buildAccountName() {
    return Text(
      'Account Name: ${accountBalance.accountName}',
      style: PalmTextStyles.subheading.copyWith(
        color: PalmColors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildAccountNumber() {
    return Text(
      accountBalance.accountNo,
      style: PalmTextStyles.body.copyWith(
        color: PalmColors.white.withOpacity(0.8),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(PalmSpacings.s),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current Balance:',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.white,
            ),
          ),
          Text(
            '\$${accountBalance.currentBalanceAsDouble.toStringAsFixed(2)}',
            style: PalmTextStyles.heading.copyWith(
              color: PalmColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
