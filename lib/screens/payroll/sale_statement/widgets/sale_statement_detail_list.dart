import 'package:flutter/material.dart';
import '../../../../models/sale_statement.dart';
import '../../../../theme/app_theme.dart';
import 'sale_statement_list_tile.dart';

/// Widget that displays sale statement details in a clean, organized list format
class SaleStatementDetailList extends StatelessWidget {
  final Map<String, List<SaleStatementDetail>> saleDetails;
  final List<String> sortedDateKeys;
  final bool isLoading;
  final Function(SaleStatementDetail) onSaleTap;

  const SaleStatementDetailList({
    super.key,
    required this.saleDetails,
    required this.sortedDateKeys,
    required this.isLoading,
    required this.onSaleTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sortedDateKeys.isEmpty) {
      return const _EmptyState();
    }

    return _SaleListView(
      saleDetails: saleDetails,
      sortedDateKeys: sortedDateKeys,
      onSaleTap: onSaleTap,
    );
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: PalmColors.neutralLight,
            ),
            const SizedBox(height: PalmSpacings.m),
            Text(
              'No sales found',
              style: PalmTextStyles.subheading.copyWith(
                color: PalmColors.neutralLight,
              ),
            ),
            const SizedBox(height: PalmSpacings.s),
            Text(
              'Try adjusting the date filter',
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.neutralLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Main list view widget
class _SaleListView extends StatelessWidget {
  final Map<String, List<SaleStatementDetail>> saleDetails;
  final List<String> sortedDateKeys;
  final Function(SaleStatementDetail) onSaleTap;

  const _SaleListView({
    required this.saleDetails,
    required this.sortedDateKeys,
    required this.onSaleTap,
  });

  @override
  Widget build(BuildContext context) {
    final allSales = _flattenSales();
    
    return ListView.builder(
      shrinkWrap: true,
      itemCount: allSales.length,
      itemBuilder: (context, index) {
        final saleItem = allSales[index];
        return SaleStatementListTile(
          sale: saleItem.sale,
          dateKey: saleItem.dateKey,
          onTap: () => onSaleTap(saleItem.sale),
        );
      },
    );
  }

  /// Flatten sales into a simple list for easier handling
  List<_SaleItem> _flattenSales() {
    final List<_SaleItem> allSales = [];
    
    for (String dateKey in sortedDateKeys) {
      final List<SaleStatementDetail> daySales = saleDetails[dateKey] ?? [];
      for (SaleStatementDetail sale in daySales) {
        allSales.add(_SaleItem(
          sale: sale,
          dateKey: dateKey,
        ));
      }
    }
    
    return allSales;
  }
}

/// Data class to hold sale with its date key
class _SaleItem {
  final SaleStatementDetail sale;
  final String dateKey;

  _SaleItem({
    required this.sale,
    required this.dateKey,
  });
}
