import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palm_ecommerce_mobile_app_2/models/commission.dart';
import 'package:palm_ecommerce_mobile_app_2/services/commission_service.dart';
import 'package:palm_ecommerce_mobile_app_2/services/commission_pdf_service.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/loading_widget.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/payroll/commission/widgets/commission_header_cards.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/payroll/commission/widgets/commission_detail_list.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/payroll/commission/widgets/commission_detail_popup.dart';

/// This screen allows users to:
/// - View commission summary with direct and indirect totals
/// - Browse commission details grouped by date
/// - Filter commissions by different time periods
/// - View detailed information for specific commissions
class PalmCommissionScreen extends StatefulWidget {
  const PalmCommissionScreen({super.key});

  @override
  State<PalmCommissionScreen> createState() => _PalmCommissionScreenState();
}

class _PalmCommissionScreenState extends State<PalmCommissionScreen> {
  CommissionMaster? commissionMaster;
  Map<String, List<CommissionDetail>> commissionDetails = {};
  List<String> sortedDateKeys = [];
  bool isLoading = true;
  String dateFrom = '';
  String dateTo = '';
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  /// Initialize screen data with default date range
  void _initializeData() async {
    final Map<String, String> dateRange = CommissionService.generateDateRange(28);
    setState(() {
      dateFrom = dateRange['dateFrom']!;
      dateTo = dateRange['dateTo']!;
    });
    await _fetchCommissionData();
  }

  /// Fetch all commission data from service
  Future<void> _fetchCommissionData() async {
    setState(() {
      isLoading = true;                               // Show loading indicator
    });

    try {
      // 1 - Fetch master and detail data concurrently
      final List<Future> futures = [
        CommissionService.fetchCommissionMaster(dateFrom: dateFrom, dateTo: dateTo),
        CommissionService.fetchCommissionDetails(dateFrom: dateFrom, dateTo: dateTo),
      ];

      final List results = await Future.wait(futures);

      setState(() {
        commissionMaster = results[0] as CommissionMaster;
        commissionDetails = results[1] as Map<String, List<CommissionDetail>>;
        sortedDateKeys = CommissionService.getSortedDateKeys(commissionDetails);
        isLoading = false;                            // Hide loading indicator
      });
    } catch (e) {
      setState(() {
        isLoading = false;                            // Hide loading indicator on error
      });
      
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load commission data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Handle menu selection from three-dot menu
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'pdf_1_month':
        _generatePdfForMonths(1);
        break;
      case 'pdf_2_months':
        _generatePdfForMonths(2);
        break;
      case 'pdf_3_months':
        _generatePdfForMonths(3);
        break;
      case 'pdf_all':
        _generateAllCommissionsPdf();
        break;
    }
  }



 
  


  /// Build PDF option tile
  
  /// Generate PDF for specific number of months
  Future<void> _generatePdfForMonths(int numberOfMonths) async {
    try {
      // Show simple loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
          ),
          child: Container(
            padding: const EdgeInsets.all(PalmSpacings.xl),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(PalmSpacings.radius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: PalmColors.primary),
                const SizedBox(height: PalmSpacings.m),
                Text(
                  'Generating PDF for last ${numberOfMonths} month${numberOfMonths > 1 ? 's' : ''}...',
                  style: PalmTextStyles.body,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

      // Filter commission data for specified months
      final filteredCommissions = _filterCommissionsByMonths(numberOfMonths);

      // Generate PDF using the commission PDF service
      final result = await CommissionPdfService.generateCommissionStatementPdf(
        filteredCommissions,
        commissionMaster,
        _getFilteredDateFrom(numberOfMonths),
        dateTo,
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show result
      _showPdfResult(result, numberOfMonths);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Generate PDF for all commission data
  Future<void> _generateAllCommissionsPdf() async {
    try {
      // Show simple loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
          ),
          child: Container(
            padding: const EdgeInsets.all(PalmSpacings.xl),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(PalmSpacings.radius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: PalmColors.primary),
                const SizedBox(height: PalmSpacings.m),
                Text(
                  'Generating PDF for all commission data...',
                  style: PalmTextStyles.body,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

      // Generate PDF using all commission data
      final result = await CommissionPdfService.generateCommissionStatementPdf(
        commissionDetails,
        commissionMaster,
        dateFrom,
        dateTo,
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Show result
      _showPdfResult(result, null);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Filter commissions by number of months
  Map<String, List<CommissionDetail>> _filterCommissionsByMonths(int numberOfMonths) {
    final now = DateTime.now();
    final cutoffDate = DateTime(now.year, now.month - numberOfMonths + 1, 1);
    
    final Map<String, List<CommissionDetail>> filteredCommissions = {};
    
    commissionDetails.forEach((date, commissions) {
      try {
        final commissionDate = DateTime.parse(date);
        if (commissionDate.isAfter(cutoffDate) || commissionDate.isAtSameMomentAs(cutoffDate)) {
          filteredCommissions[date] = commissions;
        }
      } catch (e) {
        // Include commission if date parsing fails
        filteredCommissions[date] = commissions;
      }
    });
    
    return filteredCommissions;
  }

  /// Get filtered date from for specified months
  String _getFilteredDateFrom(int numberOfMonths) {
    final now = DateTime.now();
    final fromDate = DateTime(now.year, now.month - numberOfMonths + 1, 1);
    return DateFormat("yyyy-MM-dd").format(fromDate);
  }

  /// Show PDF generation result
  void _showPdfResult(Map<String, dynamic> result, int? numberOfMonths) {
    if (result['success'] == true) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
          ),
          child: Container(
            padding: const EdgeInsets.all(PalmSpacings.l),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(PalmSpacings.radius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: PalmColors.success,
                  size: 48,
                ),
                const SizedBox(height: PalmSpacings.m),
                Text(
                  'PDF Generated Successfully!',
                  style: PalmTextStyles.heading.copyWith(
                    color: PalmColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: PalmSpacings.s),
                Text(
                  numberOfMonths != null 
                    ? 'Commission report for last ${numberOfMonths} month${numberOfMonths > 1 ? 's' : ''} has been generated.'
                    : 'Complete commission report has been generated.',
                  style: PalmTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: PalmSpacings.l),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PalmColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(PalmSpacings.xs),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
          ),
          child: Container(
            padding: const EdgeInsets.all(PalmSpacings.l),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(PalmSpacings.radius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: PalmSpacings.m),
                Text(
                  'PDF Generation Failed',
                  style: PalmTextStyles.heading.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: PalmSpacings.s),
                Text(
                  result['message'] ?? 'An error occurred while generating the PDF.',
                  style: PalmTextStyles.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: PalmSpacings.l),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(PalmSpacings.xs),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// Build PDF info item
 
  /// Build detail row for PDF success dialog
  




  /// Handle commission detail tap to show popup
  void _onCommissionDetailTap(CommissionDetail detail) async {
    try {
      final CommissionPopup popup = await CommissionService.fetchCommissionPopup(
        commissionId: detail.id ?? '',
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CommissionDetailPopup(
            commissionPopup: popup,
            description: detail.description ?? '',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load commission details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Commission Statement"),
        backgroundColor: PalmColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Commission Statement Options',
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'pdf_1_month',
                child: ListTile(
                  leading: Icon(Icons.calendar_view_month),
                  title: Text('1 Month Report'),
                  subtitle: Text('Generate PDF for last month'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'pdf_2_months',
                child: ListTile(
                  leading: Icon(Icons.calendar_view_week),
                  title: Text('2 Months Report'),
                  subtitle: Text('Generate PDF for last 2 months'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'pdf_3_months',
                child: ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('3 Months Report'),
                  subtitle: Text('Generate PDF for last 3 months'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'pdf_all',
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('All Commission Data'),
                  subtitle: Text('Generate PDF for all commissions'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const LoadingWidget()
          : Column(
              children: [
                // 1 - Commission summary header cards
                CommissionHeaderCards(
                  commissionMaster: commissionMaster,
                  isLoading: false, // Always false since we handle loading at screen level
                ),
                
                // 2 - Commission details list
                Expanded(
                  child: CommissionDetailList(
                    commissionDetails: commissionDetails,
                    sortedDateKeys: sortedDateKeys,
                    isLoading: false, // Always false since we handle loading at screen level
                    onCommissionTap: _onCommissionDetailTap,
                  ),
                ),
              ],
            ),
    );
  }
}
