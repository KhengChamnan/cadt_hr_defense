import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/commission.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'commission_list_tile.dart';

/// Widget that displays commission details in a clean, organized list format
class CommissionDetailList extends StatelessWidget {
  final Map<String, List<CommissionDetail>> commissionDetails;
  final List<String> sortedDateKeys;
  final bool isLoading;
  final Function(CommissionDetail) onCommissionTap;

  const CommissionDetailList({
    super.key,
    required this.commissionDetails,
    required this.sortedDateKeys,
    required this.isLoading,
    required this.onCommissionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sortedDateKeys.isEmpty) {
      return const _EmptyState();
    }

    return _CommissionListView(
      commissionDetails: commissionDetails,
      sortedDateKeys: sortedDateKeys,
      onCommissionTap: onCommissionTap,
    );
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No commission data available',
        style: PalmTextStyles.body.copyWith(
          color: PalmColors.textLight,
        ),
      ),
    );
  }
}

/// Main list view widget
class _CommissionListView extends StatelessWidget {
  final Map<String, List<CommissionDetail>> commissionDetails;
  final List<String> sortedDateKeys;
  final Function(CommissionDetail) onCommissionTap;

  const _CommissionListView({
    required this.commissionDetails,
    required this.sortedDateKeys,
    required this.onCommissionTap,
  });

  @override
  Widget build(BuildContext context) {
    final allCommissions = _flattenCommissions();
    
    return ListView.builder(
      shrinkWrap: true,
      itemCount: allCommissions.length,
      itemBuilder: (context, index) {
        final commissionItem = allCommissions[index];
        return CommissionListTile(
          commission: commissionItem.commission,
          dateKey: commissionItem.dateKey,
          onTap: () => onCommissionTap(commissionItem.commission),
        );
      },
    );
  }

  /// Flatten commissions into a simple list for easier handling
  List<_CommissionItem> _flattenCommissions() {
    final List<_CommissionItem> allCommissions = [];
    
    for (String dateKey in sortedDateKeys) {
      final List<CommissionDetail> dayCommissions = commissionDetails[dateKey] ?? [];
      for (CommissionDetail commission in dayCommissions) {
        allCommissions.add(_CommissionItem(
          commission: commission,
          dateKey: dateKey,
        ));
      }
    }
    
    return allCommissions;
  }
}

/// Data class to hold commission with its date key
class _CommissionItem {
  final CommissionDetail commission;
  final String dateKey;

  _CommissionItem({
    required this.commission,
    required this.dateKey,
  });
}