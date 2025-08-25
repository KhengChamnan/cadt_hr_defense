import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/commission.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Widget that displays commission summary cards:
/// - Direct commission total and balance
/// - Indirect commission total and balance
class CommissionHeaderCards extends StatelessWidget {
  final CommissionMaster? commissionMaster;
  final bool isLoading;

  const CommissionHeaderCards({
    super.key,
    required this.commissionMaster,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: PalmSpacings.s, vertical: PalmSpacings.xs),
      child: Row(
        children: [
          // 1 - Direct commission card
          Expanded(
            child: _buildCommissionCard(
              title: 'Direct Commission',
              amount: commissionMaster?.directCommission ?? '0',
              balance: commissionMaster?.directBalanceCommission ?? '0',
              icon: Icons.trending_up,
              isLoading: isLoading,
            ),
          ),
          
          const SizedBox(width: PalmSpacings.s),
          
          // 2 - Indirect commission card
          Expanded(
            child: _buildCommissionCard(
              title: 'Indirect Commission',
              amount: commissionMaster?.indirectCommission ?? '0',
              balance: commissionMaster?.indirectBalanceCommission ?? '0',
              icon: Icons.group,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual commission card widget
  Widget _buildCommissionCard({
    required String title,
    required String amount,
    required String balance,
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
                
                // 3 - Balance information
                Text(
                  'Balance: \$${balance}',
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