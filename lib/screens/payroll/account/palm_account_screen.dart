import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../providers/account_provider.dart';
import '../../../widgets/loading_widget.dart';
import '../../../models/payroll/account/account_statement.dart';
import '../../../services/pdf_service.dart';
import '../withdrawal/withdrawal_screen.dart';
import 'widgets/account_header_card.dart';
import 'widgets/account_statement_tile.dart';
import 'widgets/account_statement_detail_dialog.dart';

/// Account screen allows users to:
/// - View their account balance and details
/// - Browse through transaction history grouped by date
/// - View detailed transaction information in popup dialogs
/// - Download transaction details as PDF
class PalmAccountScreen extends StatefulWidget {
  const PalmAccountScreen({super.key});

  @override
  State<PalmAccountScreen> createState() => _PalmAccountScreenState();
}

class _PalmAccountScreenState extends State<PalmAccountScreen> {
  // Add a flag to track if any PDF operations are in progress
  bool _isPdfGenerationInProgress = false;
  
  // Add a flag to track if the widget is being disposed
  bool _isDisposing = false;

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  @override
  void dispose() {
    // Set disposal flag first
    _isDisposing = true;
    
    // Set flag to prevent further UI updates
    _isPdfGenerationInProgress = false;
    
    super.dispose();
  }

  /// 1 - Load account data using provider
  Future<void> _loadAccountData() async {
    if (!mounted || _isDisposing) return;
    
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    await accountProvider.loadAccountData();
  }

  /// 2 - Handle statement tap and show detail dialog
  Future<void> _onStatementTap(String statementId) async {
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    
    try {
      await accountProvider.getStatementDetail(statementId);
      
      if (mounted && accountProvider.statementDetail?.data != null) {
        AccountStatementDetailDialog.show(
          context,
          statementId: statementId,
          statementDetail: accountProvider.statementDetail!.data!,
          onDownloadPdf: () => _downloadStatementPdf(statementId, accountProvider.statementDetail!.data!),
        );
      }
    } catch (e) {
      print('Failed to load statement details: $e');
    }
  }

  /// 3 - Handle PDF download action for individual transaction
  Future<void> _downloadStatementPdf(String statementId, dynamic statementDetail) async {
    if (!mounted || _isDisposing) return;
    
    // Prevent multiple concurrent PDF operations
    if (_isPdfGenerationInProgress) {
      print('PDF generation already in progress. Please wait...');
      return;
    }
    
    // Set operation in progress
    _isPdfGenerationInProgress = true;
    
    try {
      print('Generating PDF for transaction $statementId...');
      
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      final accountName = accountProvider.accountBalance?.data?.accountName ?? 'Unknown Account';
      final accountNumber = accountProvider.accountBalance?.data?.accountNo ?? 'Unknown';
      
      final result = await PdfService.generateTransactionDetailPdf(
        statementId,
        statementDetail,
        accountName,
        accountNumber,
      );
      
      // Always reset the progress flag
      _isPdfGenerationInProgress = false;
      
      // Check if widget is still mounted before showing result
      if (!mounted || _isDisposing) {
        print('PDF generation completed but widget was disposed. Not showing result.');
        return;
      }
      
      if (result['success'] == true) {
        print('Transaction PDF generated successfully! File: ${result['fileName']}');
        
        // Show PDF preview if bytes are available
        if (result['pdfBytes'] != null) {
          await PdfService.showPdfPreview(
            context,
            result['pdfBytes'],
            result['fileName'],
          );
        }
      } else {
        print('Failed to generate transaction PDF: ${result['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      // Always reset the progress flag
      _isPdfGenerationInProgress = false;
      
      // Check if widget is still mounted before logging error
      if (!mounted || _isDisposing) {
        print('PDF generation failed but widget was disposed. Not showing error.');
        return;
      }
      
      print('Failed to generate transaction PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildWithdrawalButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: PalmColors.primary,
      foregroundColor: PalmColors.white,
      title: Text(
        'Account',
        style: PalmTextStyles.subheading.copyWith(
          color: PalmColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        // Three-dot menu for PDF generation options
        Consumer<AccountProvider>(
          builder: (context, accountProvider, child) {
            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Account Statement Reports',
              // Disable menu during PDF generation or if no data
              enabled: !_isPdfGenerationInProgress && 
                       !accountProvider.isLoading && 
                       !accountProvider.hasError &&
                       accountProvider.isAccountValid &&
                       accountProvider.groupedStatements.isNotEmpty,
              onSelected: _handleMenuSelection,
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'pdf_1_month',
                  child: ListTile(
                    leading: Icon(Icons.calendar_view_month),
                    title: Text('1 Month Report'),
                    subtitle: Text('Generate PDF for current month'),
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
                    title: Text('All Transactions'),
                    subtitle: Text('Generate PDF for all transactions'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        // Show loading state
        if (accountProvider.isLoading) {
          return const LoadingWidget();
        }

        // Show error state
        if (accountProvider.hasError) {
          return _buildErrorView(accountProvider.errorMessage ?? 'Unknown error');
        }

        // Check if account is invalid
        if (!accountProvider.isAccountValid) {
          return _buildInvalidAccountView();
        }

        // Show main content
        return Container(
          color: PalmColors.backgroundAccent,
          child: Column(
            children: [
              if (accountProvider.accountBalance?.data != null)
                Container(
                  color: PalmColors.white,
                  child: Column(
                    children: [
                      AccountHeaderCard(accountBalance: accountProvider.accountBalance!.data!),
                      Container(
                        height: 8,
                        color: PalmColors.backgroundAccent,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _buildStatementsList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: PalmColors.danger,
          ),
          const SizedBox(height: PalmSpacings.m),
          Text(
            'Error Loading Account',
            style: PalmTextStyles.subheading.copyWith(
              color: PalmColors.textNormal,
            ),
          ),
          const SizedBox(height: PalmSpacings.s),
          Text(
            errorMessage,
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PalmSpacings.l),
          ElevatedButton(
            onPressed: _loadAccountData,
            style: ElevatedButton.styleFrom(
              backgroundColor: PalmColors.primary,
              foregroundColor: PalmColors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvalidAccountView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 64,
            color: PalmColors.neutralLight,
          ),
          const SizedBox(height: PalmSpacings.m),
          Text(
            'Account Not Valid',
            style: PalmTextStyles.subheading.copyWith(
              color: PalmColors.textLight,
            ),
          ),
          const SizedBox(height: PalmSpacings.s),
          Text(
            'Please contact support for assistance',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatementsList() {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        if (accountProvider.groupedStatements.isEmpty) {
          return _buildEmptyStatementsView();
        }

        // Flatten all statements from all dates into a single list
        final allStatements = <AccountStatement>[];
        for (final date in accountProvider.sortedDates) {
          allStatements.addAll(accountProvider.groupedStatements[date]!);
        }

        return Container(
          color: PalmColors.backgroundAccent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.xs),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: PalmSpacings.s),
              itemCount: allStatements.length,
              itemBuilder: (context, index) {
                final statement = allStatements[index];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: PalmSpacings.xs),
                  child: AccountStatementTile(
                    statement: statement,
                    onTap: () => _onStatementTap(statement.id),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyStatementsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: PalmColors.neutralLight,
          ),
          const SizedBox(height: PalmSpacings.m),
          Text(
            'No Transactions',
            style: PalmTextStyles.subheading.copyWith(
              color: PalmColors.textLight,
            ),
          ),
          const SizedBox(height: PalmSpacings.s),
          Text(
            'No transaction history available',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  /// 4 - Handle withdrawal button navigation
  void _navigateToWithdrawal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WithdrawalScreen(),
      ),
    );
  }

  /// 5 - Handle menu selection for PDF generation
  void _handleMenuSelection(String value) {
    // Check if widget is still mounted and not disposing
    if (!mounted || _isDisposing) return;
    
    // Prevent multiple concurrent PDF operations
    if (_isPdfGenerationInProgress) {
      print('PDF generation already in progress. Please wait...');
      return;
    }
    
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
        _generateAllTransactionsPdf();
        break;
    }
  }

  /// 6 - Generate PDF for specific number of months
  Future<void> _generatePdfForMonths(int numberOfMonths) async {
    // Check if widget is still mounted and not disposing
    if (!mounted || _isDisposing) return;
    
    // Set operation in progress
    _isPdfGenerationInProgress = true;
    
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    
    if (accountProvider.groupedStatements.isEmpty) {
      _isPdfGenerationInProgress = false;
      print('No transactions available to generate PDF');
      return;
    }

    try {
      // Check if widget is still mounted before proceeding
      if (!mounted || _isDisposing) {
        _isPdfGenerationInProgress = false;
        return;
      }
      
      // Flatten all statements from all dates into a single list
      final allStatements = <AccountStatement>[];
      for (final date in accountProvider.sortedDates) {
        allStatements.addAll(accountProvider.groupedStatements[date]!);
      }

      // Filter statements for the specified number of months
      final filteredStatements = _filterStatementsByMonths(allStatements, numberOfMonths);
      
      if (filteredStatements.isEmpty) {
        _isPdfGenerationInProgress = false;
        if (!mounted || _isDisposing) return;
        print('No transactions found for the last $numberOfMonths month${numberOfMonths > 1 ? 's' : ''}');
        return;
      }

      // Check if widget is still mounted before proceeding
      if (!mounted || _isDisposing) {
        _isPdfGenerationInProgress = false;
        return;
      }
      
      // Generate PDF silently
      final monthText = numberOfMonths == 1 ? '1 month' : '$numberOfMonths months';
      print('Generating PDF for last $monthText...');

      final accountName = accountProvider.accountBalance?.data?.accountName ?? 'Unknown Account';
      final accountNumber = accountProvider.accountBalance?.data?.accountNo ?? 'Unknown';

      // Create descriptive file prefix based on time period
      final now = DateTime.now();
      String filePrefix;
      if (numberOfMonths == 1) {
        // Current month: "Account_Statement_August_2025"
        const monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        filePrefix = 'Account_Statement_${monthNames[now.month]}_${now.year}';
      } else {
        // Multiple months: "Account_Statement_Last_2_Months_Aug_2025"
        const monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        filePrefix = 'Account_Statement_Last_${numberOfMonths}_Months_${monthNames[now.month]}_${now.year}';
      }

      final result = await PdfService.generateAllTransactionsPdf(
        filteredStatements,
        accountName,
        accountNumber,
        filePrefix: filePrefix,
      );

      // Always reset the progress flag
      _isPdfGenerationInProgress = false;

      // Check if widget is still mounted and not disposing before logging result
      if (!mounted || _isDisposing) {
        print('PDF generation completed but widget was disposed. Not showing result.');
        return;
      }

      if (result['success'] == true) {
        print('PDF generated successfully! Period: Last $monthText, File: ${result['fileName']}, Total transactions: ${result['totalTransactions']}');
        
        // Show PDF preview if bytes are available
        if (result['pdfBytes'] != null) {
          await PdfService.showPdfPreview(
            context,
            result['pdfBytes'],
            result['fileName'],
          );
        }
      } else {
        print('Failed to generate PDF: ${result['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      // Always reset the progress flag
      _isPdfGenerationInProgress = false;
      
      // Check if widget is still mounted before logging error
      if (!mounted || _isDisposing) {
        print('PDF generation failed but widget was disposed. Not showing error.');
        return;
      }
      
      print('Failed to generate PDF: $e');
    }
  }

  /// 7 - Filter statements by number of months from current date
  List<AccountStatement> _filterStatementsByMonths(List<AccountStatement> allStatements, int numberOfMonths) {
    final now = DateTime.now();
    final cutoffDate = DateTime(now.year, now.month - numberOfMonths + 1, 1);
    
    return allStatements.where((statement) {
      try {
        final statementDate = statement.dateAsDateTime;
        if (statementDate == null) return false;
        
        return statementDate.isAfter(cutoffDate) || statementDate.isAtSameMomentAs(cutoffDate);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// 8 - Generate PDF for all transactions
  Future<void> _generateAllTransactionsPdf() async {
    // Check if widget is still mounted and not disposing
    if (!mounted || _isDisposing) return;
    
    // Set operation in progress
    _isPdfGenerationInProgress = true;
    
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    
    if (accountProvider.groupedStatements.isEmpty) {
      _isPdfGenerationInProgress = false;
      print('No transactions available to generate PDF');
      return;
    }

    try {
      // Check if widget is still mounted before proceeding
      if (!mounted || _isDisposing) {
        _isPdfGenerationInProgress = false;
        return;
      }
      
      // Generate PDF silently
      print('Generating PDF for all transactions...');

      // Flatten all statements from all dates into a single list
      final allStatements = <AccountStatement>[];
      for (final date in accountProvider.sortedDates) {
        allStatements.addAll(accountProvider.groupedStatements[date]!);
      }

      final accountName = accountProvider.accountBalance?.data?.accountName ?? 'Unknown Account';
      final accountNumber = accountProvider.accountBalance?.data?.accountNo ?? 'Unknown';

      // Create descriptive file prefix for all transactions
      final now = DateTime.now();
      const monthNames = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final filePrefix = 'Account_Statement_All_Transactions_${monthNames[now.month]}_${now.year}';

      final result = await PdfService.generateAllTransactionsPdf(
        allStatements,
        accountName,
        accountNumber,
        filePrefix: filePrefix,
      );

      // Always reset the progress flag
      _isPdfGenerationInProgress = false;

      // Check if widget is still mounted and not disposing before logging result
      if (!mounted || _isDisposing) {
        print('PDF generation completed but widget was disposed. Not showing result.');
        return;
      }

      if (result['success'] == true) {
        print('PDF generated successfully! File: ${result['fileName']}, Total transactions: ${result['totalTransactions']}');
        
        // Show PDF preview if bytes are available
        if (result['pdfBytes'] != null) {
          await PdfService.showPdfPreview(
            context,
            result['pdfBytes'],
            result['fileName'],
          );
        }
      } else {
        print('Failed to generate PDF: ${result['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      // Always reset the progress flag
      _isPdfGenerationInProgress = false;
      
      // Check if widget is still mounted before logging error
      if (!mounted || _isDisposing) {
        print('PDF generation failed but widget was disposed. Not showing error.');
        return;
      }
      
      print('Failed to generate PDF: $e');
    }
  }

  /// Builds the sticky withdrawal button at the bottom
  Widget _buildWithdrawalButton() {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        // Don't show withdrawal button if loading, error, or invalid account
        if (accountProvider.isLoading || 
            accountProvider.hasError || 
            !accountProvider.isAccountValid) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(PalmSpacings.m),
          decoration: BoxDecoration(
            color: PalmColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _navigateToWithdrawal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PalmColors.primary,
                  foregroundColor: PalmColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(
                  Icons.account_balance_wallet,
                  size: 20,
                  color: PalmColors.white,
                ),
                label: Text(
                  'Withdraw Money',
                  style: PalmTextStyles.button.copyWith(
                    color: PalmColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
