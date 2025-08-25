import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/sale_statement.dart';
import '../../../services/sale_statement_service.dart';
import '../../../services/sale_statement_pdf_service.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/loading_widget.dart';
import 'widgets/sale_statement_header_card.dart';
import 'widgets/sale_statement_detail_list.dart';
import 'widgets/sale_statement_detail_popup.dart';

/// This screen allows users to:
/// - View sale statement summary with direct and indirect totals
/// - Browse detailed sale transactions grouped by date
/// - Filter sales by different time periods (7, 28, 90, 365 days, lifetime)
/// - View detailed information about specific sales in popup
class SaleStatementScreen extends StatefulWidget {
  @override
  _SaleStatementScreenState createState() => _SaleStatementScreenState();
}

class _SaleStatementScreenState extends State<SaleStatementScreen> {
  SaleStatementMaster? saleStatementMaster;
  Map<String, List<SaleStatementDetail>> saleStatementDetails = {};
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
    setState(() {
      dateFrom = dateFormat.format(DateTime.now().subtract(const Duration(days: 28)));
      dateTo = dateFormat.format(DateTime.now());
    });
    await _fetchSaleStatementData();
  }

  /// Fetch all sale statement data from service
  Future<void> _fetchSaleStatementData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // 1 - Fetch master and detail data concurrently
      final List<Future> futures = [
        SaleStatementService.fetchSaleStatementMaster(dateFrom: dateFrom, dateTo: dateTo),
        SaleStatementService.fetchSaleStatementDetails(dateFrom: dateFrom, dateTo: dateTo),
      ];

      final List results = await Future.wait(futures);

      setState(() {
        saleStatementMaster = results[0] as SaleStatementMaster;
        saleStatementDetails = results[1] as Map<String, List<SaleStatementDetail>>;
        sortedDateKeys = saleStatementDetails.keys.toList()..sort((a, b) => b.compareTo(a));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load sale statement data: $e'),
            backgroundColor: PalmColors.danger,
          ),
        );
      }
    }
  }

  /// Handle date filter selection
  void _onDateFilterSelected(String daysValue) {
    setState(() {
      dateFrom = dateFormat.format(
        DateTime.now().subtract(Duration(days: int.parse(daysValue)))
      );
      dateTo = dateFormat.format(DateTime.now());
    });
    _fetchSaleStatementData();
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
        _generateAllSalesPdf();
        break;
    }
  }

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

      // Filter sale data for specified months
      final filteredSales = _filterSalesByMonths(numberOfMonths);

      // Generate PDF using the sale PDF service
      final result = await SaleStatementPdfService.generateSaleStatementPdf(
        filteredSales,
        saleStatementMaster,
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

  /// Generate PDF for all sale data
  Future<void> _generateAllSalesPdf() async {
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
                  'Generating PDF for all sale data...',
                  style: PalmTextStyles.body,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

      // Generate PDF using all sale data
      final result = await SaleStatementPdfService.generateSaleStatementPdf(
        saleStatementDetails,
        saleStatementMaster,
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

  /// Filter sales by number of months
  Map<String, List<SaleStatementDetail>> _filterSalesByMonths(int numberOfMonths) {
    final now = DateTime.now();
    final cutoffDate = DateTime(now.year, now.month - numberOfMonths + 1, 1);
    
    final Map<String, List<SaleStatementDetail>> filteredSales = {};
    
    saleStatementDetails.forEach((date, sales) {
      try {
        final saleDate = DateTime.parse(date);
        if (saleDate.isAfter(cutoffDate) || saleDate.isAtSameMomentAs(cutoffDate)) {
          filteredSales[date] = sales;
        }
      } catch (e) {
        // Include sale if date parsing fails
        filteredSales[date] = sales;
      }
    });
    
    return filteredSales;
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
                    ? 'Sale report for last ${numberOfMonths} month${numberOfMonths > 1 ? 's' : ''} has been generated.'
                    : 'Complete sale report has been generated.',
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

  /// Handle sale detail tap to show popup
  void _onSaleDetailTap(SaleStatementDetail detail) async {
    try {
      final popup = await SaleStatementService.fetchSaleStatementPopup(saleId: detail.id ?? '');
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => SaleStatementDetailPopup(
            saleId: detail.id ?? '',
            popup: popup,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load sale details'),
          backgroundColor: PalmColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sale Statement"),
        backgroundColor: PalmColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter Sales',
            onSelected: _onDateFilterSelected,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: '7',
                child: ListTile(
                  leading: Icon(Icons.today),
                  title: Text('Last 7 Days'),
                  subtitle: Text('Recent sales'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: '28',
                child: ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('Last 28 Days'),
                  subtitle: Text('Monthly view'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: '90',
                child: ListTile(
                  leading: Icon(Icons.calendar_view_month),
                  title: Text('Last 90 Days'),
                  subtitle: Text('Quarterly view'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: '365',
                child: ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Last 365 Days'),
                  subtitle: Text('Yearly view'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: '1000',
                child: ListTile(
                  leading: Icon(Icons.all_inclusive),
                  title: Text('Lifetime'),
                  subtitle: Text('All sales data'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Sale Statement Options',
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
                  title: Text('All Sale Data'),
                  subtitle: Text('Generate PDF for all sales'),
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
                // 1 - Sale statement summary header cards
                SaleStatementHeaderCards(
                  saleMaster: saleStatementMaster,
                  isLoading: false, // Always false since we handle loading at screen level
                ),
                
                // 2 - Sale statement details list
                Expanded(
                  child: SaleStatementDetailList(
                    saleDetails: saleStatementDetails,
                    sortedDateKeys: sortedDateKeys,
                    isLoading: false, // Always false since we handle loading at screen level
                    onSaleTap: _onSaleDetailTap,
                  ),
                ),
              ],
            ),
    );
  }
}
