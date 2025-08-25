import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/app/widgets/app_menu_item.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/payroll/commission/palm_commission_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/payroll/account/palm_account_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/payroll/sale_statement/sale_statement_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import '../../payroll/withdrawal/withdrawal_screen.dart';

/// A grid menu displaying payroll-related actions and overview sections
class PayrollMenuGrid extends StatelessWidget {
  const PayrollMenuGrid({super.key});

  /// Navigates to the withdrawal screen.
  void _navigateToWithdrawal(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WithdrawalScreen(),
      ),
    );
  }

    /// Navigates to the withdrawal screen.
  void _navigateToAccount(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PalmAccountScreen(),
      ),
    );
  }

  void _navigateToCommission(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PalmCommissionScreen(),
      ),
    );
  }
  void _navigateToSaleStatement(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>  SaleStatementScreen(),
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
              // const MenuItemWidget(
              //   title: 'Expense\nClaim',
              //   icon: Icons.receipt_long,
              // ),
              MenuItemWidget(
                title: 'Withdrawal',
                icon: Icons.account_balance_wallet,
                onTap: () => _navigateToWithdrawal(context),
              ),
              
              // const MenuItemWidget(
              //   title: 'Staff Loan',
              //   icon: Icons.account_balance,
              // ),
              // const MenuItemWidget(
              //   title: 'Bonus\nRequest',
              //   icon: Icons.card_giftcard,
              // ),
              // const MenuItemWidget(
              //   title: 'Allowance\nRequest',
              //   icon: Icons.monetization_on,
              // ),
              // const MenuItemWidget(
              //   title: 'Tax\nDocuments',
              //   icon: Icons.description,
              // ),
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
                title: 'Account Balance',
                icon: Icons.account_balance,
                onTap: () {
                  _navigateToAccount(context);
                },
              ),
              MenuItemWidget(
                title: 'Commission',
                icon: Icons.attach_money,
                onTap: () {
                  _navigateToCommission(context);
                },
              ),
              MenuItemWidget(
                title: 'Sale\nStatement',
                icon: Icons.bar_chart,
                onTap: () => _navigateToSaleStatement(context),
              ),
              // const MenuItemWidget(
              //   title: 'Payroll',
              //   icon: Icons.attach_money,
              // ),
              // const MenuItemWidget(
              //   title: 'Salary\nSlip',
              //   icon: Icons.description,
              // ),
              // const MenuItemWidget(
              //   title: 'Expense\nReport',
              //   icon: Icons.receipt_long,
              // ),
              // const MenuItemWidget(
              //   title: 'Advance\nSalary',
              //   icon: Icons.payments,
              // ),
              // const MenuItemWidget(
              //   title: 'Staff Loan',
              //   icon: Icons.account_balance,
              // ),
              // const MenuItemWidget(
              //   title: 'Bonus\nHistory',
              //   icon: Icons.card_giftcard,
              // ),
              // const MenuItemWidget(
              //   title: 'Allowances',
              //   icon: Icons.monetization_on,
              // ),
              // const MenuItemWidget(
              //   title: 'Tax\nInformation',
              //   icon: Icons.account_balance_wallet,
              // ),
              // const MenuItemWidget(
              //   title: 'Deductions',
              //   icon: Icons.remove_circle,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
