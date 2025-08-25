import 'package:flutter/material.dart';
import '../../../../models/sale_statement.dart';
import '../../../../theme/app_theme.dart';

/// A list tile widget for displaying sale statement details in the sale statement screen
/// 
/// This widget displays:
/// - Sale date header
/// - Sale description
/// - Sale amount
/// - Tap functionality for navigation to sale details
class SaleStatementListTile extends StatelessWidget {
  /// The sale detail to display
  final SaleStatementDetail sale;
  
  /// The date key for grouping sales by date
  final String dateKey;
  
  /// Callback when the tile is tapped
  final VoidCallback? onTap;
  
  /// Creates a sale statement list tile widget
  const SaleStatementListTile({
    Key? key,
    required this.sale,
    required this.dateKey,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _SaleHeader(dateKey: dateKey),
            _SaleContent(sale: sale),
          ],
        ),
      ),
    );
  }
}

/// Sale header widget
class _SaleHeader extends StatelessWidget {
  final String dateKey;

  const _SaleHeader({required this.dateKey});

  @override
  Widget build(BuildContext context) {
    final DateTime parsedDate = DateTime.parse(dateKey);
    final String formattedDate = '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    
    return Container(
      width: double.infinity,
      height: 31,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: PalmColors.primary.withOpacity(0.8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          Text(
            formattedDate,
            style: PalmTextStyles.body.copyWith(
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 18),
        ],
      ),
    );
  }
}

/// Sale content widget
class _SaleContent extends StatelessWidget {
  final SaleStatementDetail sale;

  const _SaleContent({required this.sale});

  @override
  Widget build(BuildContext context) {
    final String formattedAmount = '\$${sale.amount ?? '0'}';
    
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Description section
          Expanded(
            child: _DescriptionRow(description: sale.description),
          ),
          // Amount display at the end
          const SizedBox(width: 16),
          Text(
            formattedAmount,
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Description row widget
class _DescriptionRow extends StatelessWidget {
  final String? description;

  const _DescriptionRow({required this.description});

  @override
  Widget build(BuildContext context) {
    return _InfoRow(
      icon: Icons.receipt,
      iconColor: PalmColors.primary,
      backgroundColor: PalmColors.primary.withOpacity(0.1),
      text: description ?? 'No description',
      textStyle: PalmTextStyles.body.copyWith(
        color: PalmColors.textNormal,
        fontWeight: FontWeight.w600,
      ),
      maxLines: 2,
    );
  }
}

/// Reusable info row widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String text;
  final TextStyle textStyle;
  final int maxLines;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.text,
    required this.textStyle,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Icon(
            icon,
            size: 12,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            text,
            style: textStyle,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
