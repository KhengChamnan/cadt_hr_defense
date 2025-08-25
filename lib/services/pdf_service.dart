import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../models/payroll/account/account_statement.dart';
import '../models/payroll/account/statement_detail.dart';

/// Service class for handling PDF generation of account statements.
/// Provides functionality to generate PDFs for monthly and all transactions.
class PdfService {
  
  /// Generates PDF for all transactions
  /// Returns success status and file path or error message
  static Future<Map<String, dynamic>> generateAllTransactionsPdf(
    List<AccountStatement> allStatements,
    String accountName,
    String accountNumber, {
    String? filePrefix, // Optional custom file prefix
  }) async {
    print("📄 PdfService: generateAllTransactionsPdf() called with ${allStatements.length} statements");
    
    try {
      // Create PDF document
      final pdf = pw.Document();
      
      // Calculate totals
      double totalCredits = 0;
      double totalDebits = 0;
      for (final statement in allStatements) {
        final amount = double.tryParse(statement.amount.replaceAll('+', '').replaceAll('-', '')) ?? 0;
        if (statement.amount.startsWith('+')) {
          totalCredits += amount;
        } else {
          totalDebits += amount;
        }
      }
      
      // Sort statements by date (newest first)
      final sortedStatements = List<AccountStatement>.from(allStatements);
      sortedStatements.sort((a, b) {
        final dateA = a.dateAsDateTime;
        final dateB = b.dateAsDateTime;
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA);
      });
      
      // Add page to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 20),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(width: 2)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'ACCOUNT STATEMENT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Account Name: $accountName'),
                    pw.Text('Account Number: $accountNumber'),
                    pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                    pw.Text('Total Transactions: ${allStatements.length}'),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Summary Section
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('Total Credits', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('\$${totalCredits.toStringAsFixed(2)}', style: const pw.TextStyle(color: PdfColors.green)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Total Debits', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('\$${totalDebits.toStringAsFixed(2)}', style: const pw.TextStyle(color: PdfColors.red)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Current Balance', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('\$${sortedStatements.isNotEmpty ? sortedStatements.first.balance : '0.00'}'),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Transactions Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Balance', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Note', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  // Data rows
                  ...sortedStatements.map((statement) {
                    final date = statement.dateAsDateTime;
                    final dateStr = date != null 
                        ? '${date.day}/${date.month}/${date.year}'
                        : 'N/A';
                    
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(dateStr, style: const pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(statement.transaction, style: const pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '\$${statement.amount}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              color: statement.amount.startsWith('+') ? PdfColors.green : PdfColors.red,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('\$${statement.balance}', style: const pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(statement.note.isEmpty ? '-' : statement.note, style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ];
          },
        ),
      );
      
      // Save PDF to device
      final fileName = '${filePrefix ?? 'All_Transactions'}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final bytes = await pdf.save();
      
      // Save to downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      
      print("📄 PdfService: All transactions PDF generated successfully: $fileName");
      
      return {
        'success': true,
        'message': 'All transactions PDF generated successfully',
        'fileName': fileName,
        'filePath': file.path,
        'totalTransactions': allStatements.length,
        'totalCredits': totalCredits.toStringAsFixed(2),
        'totalDebits': totalDebits.toStringAsFixed(2),
        'pdfBytes': bytes, // Include PDF bytes for preview
      };
    } catch (e) {
      print("❌ PdfService: Error generating all transactions PDF: $e");
      return {
        'success': false,
        'message': 'Failed to generate PDF for all transactions',
        'error': e.toString(),
      };
    }
  }

  /// Generates PDF for transactions in a specific month
  /// Returns success status and file path or error message
  static Future<Map<String, dynamic>> generateMonthlyTransactionsPdf(
    List<AccountStatement> monthlyStatements,
    String accountName,
    String accountNumber,
    String monthYear, // Format: "2025-08" or "August 2025"
  ) async {
    print("📄 PdfService: generateMonthlyTransactionsPdf() called for $monthYear with ${monthlyStatements.length} statements");
    
    try {
      // Create PDF document
      final pdf = pw.Document();
      
      // Calculate monthly totals
      double totalCredits = 0;
      double totalDebits = 0;
      for (final statement in monthlyStatements) {
        final amount = double.tryParse(statement.amount.replaceAll('+', '').replaceAll('-', '')) ?? 0;
        if (statement.amount.startsWith('+')) {
          totalCredits += amount;
        } else {
          totalDebits += amount;
        }
      }
      
      // Sort statements by date (newest first)
      final sortedStatements = List<AccountStatement>.from(monthlyStatements);
      sortedStatements.sort((a, b) {
        final dateA = a.dateAsDateTime;
        final dateB = b.dateAsDateTime;
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA);
      });
      
      final monthName = getMonthName(monthYear);
      
      // Add page to PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.only(bottom: 20),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(width: 2)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'MONTHLY ACCOUNT STATEMENT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Account Name: $accountName'),
                    pw.Text('Account Number: $accountNumber'),
                    pw.Text('Period: $monthName'),
                    pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                    pw.Text('Total Transactions: ${monthlyStatements.length}'),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Monthly Summary Section
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Monthly Summary - $monthName',
                      style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Column(
                          children: [
                            pw.Text('Credits', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${totalCredits.toStringAsFixed(2)}', style: const pw.TextStyle(color: PdfColors.green)),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text('Debits', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${totalDebits.toStringAsFixed(2)}', style: const pw.TextStyle(color: PdfColors.red)),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text('Net Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text(
                              '\$${(totalCredits - totalDebits).toStringAsFixed(2)}',
                              style: pw.TextStyle(
                                color: (totalCredits - totalDebits) >= 0 ? PdfColors.green : PdfColors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Transactions Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(2.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Header row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.blue300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Balance', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Note', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                      ),
                    ],
                  ),
                  // Data rows
                  ...sortedStatements.map((statement) {
                    final date = statement.dateAsDateTime;
                    final dateStr = date != null 
                        ? '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}'
                        : 'N/A';
                    
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(dateStr, style: const pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(statement.transaction, style: const pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            '\$${statement.amount}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: statement.amount.startsWith('+') ? PdfColors.green : PdfColors.red,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('\$${statement.balance}', style: const pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(statement.note.isEmpty ? '-' : statement.note, style: const pw.TextStyle(fontSize: 10)),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ];
          },
        ),
      );
      
      // Save PDF to device
      final fileName = 'Monthly_Transactions_${monthYear.replaceAll('-', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final bytes = await pdf.save();
      
      // Save to downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      
      print("📄 PdfService: Monthly transactions PDF generated successfully: $fileName");
      
      return {
        'success': true,
        'message': 'Monthly transactions PDF generated successfully',
        'fileName': fileName,
        'filePath': file.path,
        'monthYear': monthYear,
        'monthName': monthName,
        'totalTransactions': monthlyStatements.length,
        'totalCredits': totalCredits.toStringAsFixed(2),
        'totalDebits': totalDebits.toStringAsFixed(2),
        'netAmount': (totalCredits - totalDebits).toStringAsFixed(2),
        'pdfBytes': bytes, // Include PDF bytes for preview
      };
    } catch (e) {
      print("❌ PdfService: Error generating monthly transactions PDF: $e");
      return {
        'success': false,
        'message': 'Failed to generate PDF for monthly transactions',
        'error': e.toString(),
      };
    }
  }

  /// Gets the current month in YYYY-MM format
  static String getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  /// Gets friendly month name from YYYY-MM format
  static String getMonthName(String monthYear) {
    try {
      final parts = monthYear.split('-');
      if (parts.length != 2) return monthYear;
      
      final year = parts[0];
      final month = int.parse(parts[1]);
      
      const monthNames = [
        '', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      
      if (month >= 1 && month <= 12) {
        return '${monthNames[month]} $year';
      }
      
      return monthYear;
    } catch (e) {
      return monthYear;
    }
  }

  /// Filters statements by month (YYYY-MM format)
  static List<AccountStatement> filterStatementsByMonth(
    List<AccountStatement> allStatements,
    String monthYear,
  ) {
    return allStatements.where((statement) {
      try {
        final statementDate = statement.dateAsDateTime;
        if (statementDate == null) return false;
        
        final statementMonth = '${statementDate.year}-${statementDate.month.toString().padLeft(2, '0')}';
        return statementMonth == monthYear;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  /// Gets unique months from statements for selection
  static List<String> getAvailableMonths(List<AccountStatement> allStatements) {
    final months = <String>{};
    
    for (final statement in allStatements) {
      try {
        final statementDate = statement.dateAsDateTime;
        if (statementDate != null) {
          final monthYear = '${statementDate.year}-${statementDate.month.toString().padLeft(2, '0')}';
          months.add(monthYear);
        }
      } catch (e) {
        // Skip invalid dates
      }
    }
    
    final sortedMonths = months.toList();
    sortedMonths.sort((a, b) => b.compareTo(a)); // Newest first
    return sortedMonths;
  }

  /// Shows a dialog to select month for PDF generation
  static Future<String?> showMonthSelectionDialog(
    BuildContext context,
    List<String> availableMonths,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Month'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableMonths.length,
            itemBuilder: (context, index) {
              final month = availableMonths[index];
              final monthName = getMonthName(month);
              
              return ListTile(
                title: Text(monthName),
                subtitle: Text('Tap to generate PDF'),
                leading: const Icon(Icons.calendar_month),
                onTap: () => Navigator.of(context).pop(month),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  /// Generates PDF for a single transaction detail
  /// Returns success status and file path or error message
  static Future<Map<String, dynamic>> generateTransactionDetailPdf(
    String statementId,
    StatementDetail statementDetail,
    String accountName,
    String accountNumber,
  ) async {
    print("📄 PdfService: generateTransactionDetailPdf() called for transaction $statementId");
    
    try {
      // Create PDF document
      final pdf = pw.Document();
      
      // Add page to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.only(bottom: 20),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(width: 2)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'TRANSACTION DETAIL',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text('Account Name: $accountName'),
                      pw.Text('Account Number: $accountNumber'),
                      pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                    ],
                  ),
                ),
                
                pw.SizedBox(height: 30),
                
  
                
                pw.SizedBox(height: 30),
                
                // Transaction Details Table
                pw.Text(
                  'Transaction Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey400),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(3),
                  },
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Field',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(12),
                          child: pw.Text(
                            'Value',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    // Data rows
                    _buildDetailRow('Transaction ID', statementId),
                    _buildDetailRow('Amount', statementDetail.formattedAmount),
                    _buildDetailRow('Member ID', statementDetail.toMemberId),
                    _buildDetailRow('Remark', statementDetail.remark),
                    _buildDetailRow('Total Amount', '\$${statementDetail.formattedOriginalAmount} USD'),
                  ],
                ),
                
                pw.SizedBox(height: 30),
                
                // Footer
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    'This document contains confidential transaction information. Please keep it secure.',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey600,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      );
      
      // Save PDF to device
      final fileName = 'Transaction_Detail_${statementId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final bytes = await pdf.save();
      
      // Save to downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      
      print("📄 PdfService: Transaction detail PDF generated successfully: $fileName");
      
      return {
        'success': true,
        'message': 'Transaction detail PDF generated successfully',
        'fileName': fileName,
        'filePath': file.path,
        'transactionId': statementId,
        'pdfBytes': bytes, // Include PDF bytes for preview
      };
    } catch (e) {
      print("❌ PdfService: Error generating transaction detail PDF: $e");
      return {
        'success': false,
        'message': 'Failed to generate PDF for transaction detail',
        'error': e.toString(),
      };
    }
  }
  
  /// Helper method to build detail rows for transaction PDF
  static pw.TableRow _buildDetailRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(12),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(12),
          child: pw.Text(value),
        ),
      ],
    );
  }
  
  /// Shows the generated PDF in a preview dialog
  static Future<void> showPdfPreview(
    BuildContext context,
    Uint8List pdfBytes,
    String fileName,
  ) async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) => pdfBytes,
        name: fileName,
      );
    } catch (e) {
      print('Error showing PDF preview: $e');
      // Fallback: Show share dialog
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: fileName,
      );
    }
  }
}
