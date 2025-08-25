import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/commission.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/actions/palm_button.dart';

/// Widget that displays detailed commission information in a popup dialog:
/// - Commission description and details
/// - Download functionality for commission statement
class CommissionDetailPopup extends StatelessWidget {
  final CommissionPopup commissionPopup;
  final String description;

  const CommissionDetailPopup({
    super.key,
    required this.commissionPopup,
    required this.description,
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
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      description.isNotEmpty ? description : 'Commission Details',
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
        if (commissionPopup.directFrom != null && 
            commissionPopup.directFrom!.isNotEmpty &&
            !commissionPopup.directFrom!.toLowerCase().contains('system'))
          _buildTableRow('Direct From:', commissionPopup.directFrom!),
        if (commissionPopup.fromCustomer != null && 
            commissionPopup.fromCustomer!.isNotEmpty &&
            !commissionPopup.fromCustomer!.toLowerCase().contains('system') &&
            !commissionPopup.fromCustomer!.toLowerCase().contains('various') &&
            !commissionPopup.fromCustomer!.toLowerCase().contains('general'))
          _buildTableRow('From Customer:', commissionPopup.fromCustomer!),
        if (commissionPopup.remark != null && 
            commissionPopup.remark!.isNotEmpty &&
            !commissionPopup.remark!.toLowerCase().contains('system generated'))
          _buildTableRow('Remark:', commissionPopup.remark!),
        _buildTableRow('Amount:', '\$${commissionPopup.amount ?? '0'} USD', isAmount: true),
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

  Widget _buildActionButton(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: PalmSpacings.s),
        Expanded(
          child: PalmButton(
            text: 'Download PDF',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('PDF download will be implemented'),
                  backgroundColor: PalmColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PalmSpacings.xs),
                  ),
                ),
              );
            },
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
    required CommissionPopup commissionPopup,
    required String description,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CommissionDetailPopup(
        commissionPopup: commissionPopup,
        description: description,
      ),
    );
  }
}
