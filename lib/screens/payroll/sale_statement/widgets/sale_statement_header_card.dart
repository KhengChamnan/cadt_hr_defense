import 'package:flutter/material.dart';
import '../../../../models/sale_statement.dart';
import '../../../../theme/app_theme.dart';

/// Widget that displays sale statement summary cards:
/// - Direct sale total and count
/// - Indirect sale total and count
class SaleStatementHeaderCards extends StatelessWidget {
  final SaleStatementMaster? saleMaster;
  final bool isLoading;

  const SaleStatementHeaderCards({
    super.key,
    required this.saleMaster,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: PalmSpacings.s, vertical: PalmSpacings.xs),
      child: Row(
        children: [
          // 1 - Direct sale card
          Expanded(
            child: _buildSaleCard(
              title: 'Direct Sale',
              amount: saleMaster?.amountDirect ?? '0',
              count: saleMaster?.countSellDirect ?? '0',
              icon: Icons.trending_up,
              isLoading: isLoading,
            ),
          ),
          
          const SizedBox(width: PalmSpacings.s),
          
          // 2 - Indirect sale card
          Expanded(
            child: _buildSaleCard(
              title: 'Indirect Sale',
              amount: saleMaster?.amountIndirect ?? '0',
              count: saleMaster?.countSellIndirect ?? '0',
              icon: Icons.group,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual sale card widget
  Widget _buildSaleCard({
    required String title,
    required String amount,
    required String count,
    required IconData icon,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1 - Icon and title row
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: PalmSpacings.xs),
                    Expanded(
                      child: Text(
                        title,
                        style: PalmTextStyles.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: PalmSpacings.m),
                
                // 2 - Main amount
                Text(
                  '\$${amount}',
                  style: PalmTextStyles.heading.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                
                const SizedBox(height: PalmSpacings.xs),
                
                // 3 - Count information
                Text(
                  'Count: ${count}',
                  style: PalmTextStyles.label.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
    );
  }
}
