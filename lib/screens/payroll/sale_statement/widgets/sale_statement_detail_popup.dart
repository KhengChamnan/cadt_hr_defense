import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../models/sale_statement.dart';
import '../../../../theme/app_theme.dart';

/// This popup widget displays detailed sale statement information containing:
/// - Transaction ID and parties involved
/// - Sale description and amount
/// - Download functionality for PDF generation
class SaleStatementDetailPopup extends StatelessWidget {
  final String saleId;
  final SaleStatementPopup popup;

  const SaleStatementDetailPopup({
    Key? key,
    required this.saleId,
    required this.popup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: PalmColors.secondary.withOpacity(0.2),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(PalmSpacings.radius),
                color: PalmColors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildContent(),
                  _buildActions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build popup header with description
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(PalmSpacings.m),
      child: Text(
        popup.remark ?? 'Sale Transaction Details',
        style: PalmTextStyles.body.copyWith(
          color: PalmColors.neutral,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build main content with transaction details
  Widget _buildContent() {
    return Column(
      children: [
        Divider(color: PalmColors.secondary, height: 2),
        _buildDetailTable(),
        Divider(color: PalmColors.secondary, height: 2),
      ],
    );
  }

  /// Build table with transaction details
  Widget _buildDetailTable() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _buildTableRow('ID:', saleId),
        _buildTableRow('Direct From:', popup.directFrom ?? ''),
        _buildTableRow('To Member:', popup.toMember ?? ''),
        _buildTableRow('From Customer:', popup.fromCustomer ?? ''),
        _buildTableRow('Remark:', popup.remark ?? ''),
        _buildAmountRow(),
      ],
    );
  }

  /// Build individual table row
  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(PalmSpacings.xs),
            child: Text(
              label,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.dark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(PalmSpacings.xs),
            child: Text(
              value,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.neutral,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  /// Build amount row with special styling
  TableRow _buildAmountRow() {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(PalmSpacings.xs),
            child: Text(
              'Amount:',
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.dark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(PalmSpacings.xs),
            child: Text(
              '${popup.originalAmount ?? '0'} USD',
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PalmSpacings.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () => _handleDownload(),
            icon: Icon(Icons.download, color: PalmColors.white),
            label: Text(
              'Download',
              style: PalmTextStyles.button.copyWith(
                color: PalmColors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: PalmColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: PalmTextStyles.button.copyWith(
                color: PalmColors.neutral,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle PDF download functionality
  void _handleDownload() {
    // TODO: Implement PDF generation service
    // This would call a PDF service similar to the original implementation
    print('Downloading PDF for sale $saleId');                    // Placeholder for now
  }
}
