import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../models/payroll/account/statement_detail.dart';
import '../../../../widgets/actions/palm_button.dart';

/// Dialog widget that displays detailed transaction information
/// with options to download PDF and formatted data display.
class AccountStatementDetailDialog extends StatelessWidget {
  final String statementId;
  final StatementDetail statementDetail;
  final VoidCallback onDownloadPdf;

  const AccountStatementDetailDialog({
    super.key,
    required this.statementId,
    required this.statementDetail,
    required this.onDownloadPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(PalmSpacings.l),
      child: Container(
        decoration: BoxDecoration(
          color: PalmColors.white,
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
        ),
        padding: const EdgeInsets.all(PalmSpacings.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: PalmSpacings.m),
            _buildDivider(),
            const SizedBox(height: PalmSpacings.m),
            _buildDetailsTable(),
            const SizedBox(height: PalmSpacings.l),
            _buildDivider(),
            const SizedBox(height: PalmSpacings.m),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      statementDetail.remark,
      style: PalmTextStyles.subheading.copyWith(
        color: PalmColors.textNormal,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        color: PalmColors.primary,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  Widget _buildDetailsTable() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      children: [
        _buildTableRow('Category:', statementDetail.toMemberId),
        _buildTableRow('Amount:', '\$${statementDetail.formattedAmount} USD', isAmount: true),
        _buildTableRow('Description:', statementDetail.remark),
        if (statementDetail.originalAmount != statementDetail.amount)
          _buildTableRow(
            'Original Amount:', 
            '\$${statementDetail.formattedOriginalAmount} USD',
            isAmount: true,
          ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value, {bool isAmount = false}) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: PalmSpacings.xs),
            child: Text(
              label,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.textNormal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: PalmSpacings.xs),
            child: Text(
              value,
              style: PalmTextStyles.body.copyWith(
                color: isAmount ? PalmColors.success : PalmColors.textLight,
                fontWeight: isAmount ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: isAmount ? 1 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return Row(
      children: [
        
        const SizedBox(width: PalmSpacings.s),
        Expanded(
          child: PalmButton(
            text: 'Download PDF',
            onPressed: onDownloadPdf,
            backgroundColor: PalmColors.primary,
            textColor: PalmColors.white,
            expandWidth: true,
          ),
        ),
      ],
    );
  }

  /// Static method to show the dialog
  static void show(
    BuildContext context, {
    required String statementId,
    required StatementDetail statementDetail,
    required VoidCallback onDownloadPdf,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AccountStatementDetailDialog(
        statementId: statementId,
        statementDetail: statementDetail,
        onDownloadPdf: () {
          Navigator.of(context).pop();                   // Close dialog first
          onDownloadPdf();                               // Then execute download
        },
      ),
    );
  }
}
