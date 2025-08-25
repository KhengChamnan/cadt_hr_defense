import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import '../models/commission.dart';

/// Service class for handling PDF generation of commission statements.
/// Provides functionality to generate PDFs for commission data.
class CommissionPdfService {
  
  /// Generates PDF for commission statement
  /// Returns success status and file path or error message
  static Future<Map<String, dynamic>> generateCommissionStatementPdf(
    Map<String, List<CommissionDetail>> commissionDetails,
    CommissionMaster? commissionMaster,
    String dateFrom,
    String dateTo,
  ) async {
    print("📄 CommissionPdfService: generateCommissionStatementPdf() called");
    
    try {
      // Create PDF document
      final pdf = pw.Document();
      
      // Flatten commission details for processing
      final List<CommissionDetail> allCommissions = [];
      commissionDetails.forEach((date, commissions) {
        allCommissions.addAll(commissions);
      });
      
      // Calculate totals
      double totalDirectCommission = double.tryParse(
        commissionMaster?.directCommission?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0'
      ) ?? 0;
      double totalIndirectCommission = double.tryParse(
        commissionMaster?.indirectCommission?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0'
      ) ?? 0;
      double totalBalance = double.tryParse(
        commissionMaster?.directBalanceCommission?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0'
      ) ?? 0;
      double indirectBalance = double.tryParse(
        commissionMaster?.indirectBalanceCommission?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0'
      ) ?? 0;
      
      // Sort commissions by date (newest first)
      final sortedCommissions = List<CommissionDetail>.from(allCommissions);
      // Note: Add date sorting logic here if needed
      
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
                      'COMMISSION STATEMENT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Period: $dateFrom to $dateTo'),
                    pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                    pw.Text('Total Commissions: ${allCommissions.length}'),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Summary Section
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'Commission Summary',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Column(
                          children: [
                            pw.Text('Direct Commission', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${totalDirectCommission.toStringAsFixed(2)}', 
                              style: pw.TextStyle(fontSize: 16, color: PdfColors.blue)),
                            pw.SizedBox(height: 5),
                            pw.Text('Balance: \$${totalBalance.toStringAsFixed(2)}', 
                              style: const pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text('Indirect Commission', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${totalIndirectCommission.toStringAsFixed(2)}', 
                              style: pw.TextStyle(fontSize: 16, color: PdfColors.green)),
                            pw.SizedBox(height: 5),
                            pw.Text('Balance: \$${indirectBalance.toStringAsFixed(2)}', 
                              style: const pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text('Total Commission', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${(totalDirectCommission + totalIndirectCommission).toStringAsFixed(2)}', 
                              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text('Total Balance: \$${(totalBalance + indirectBalance).toStringAsFixed(2)}', 
                              style: const pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Commission Details Table
              if (allCommissions.isNotEmpty) ...[
                pw.Text(
                  'Commission Details',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(3),
                    2: const pw.FlexColumnWidth(1.5),
                    3: const pw.FlexColumnWidth(1.5),
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
                          child: pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                        ),
                      ],
                    ),
                    // Data rows
                    ...sortedCommissions.map((commission) {
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(commission.date ?? 'N/A', style: const pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(commission.description ?? 'No description', style: const pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('\$${commission.amount ?? '0'}', style: const pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('Commission', style: const pw.TextStyle(fontSize: 10)),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ] else ...[
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  child: pw.Center(
                    child: pw.Text(
                      'No commission data available for the selected period.',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
                ),
              ],
              
              pw.SizedBox(height: 30),
              
              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  'This document contains confidential commission information. Please keep it secure.',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey600,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ];
          },
        ),
      );
      
      // Save PDF to device
      final fileName = 'Commission_Statement_${dateFrom}_to_${dateTo}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final bytes = await pdf.save();
      
      // Save to downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      
      print("📄 CommissionPdfService: Commission statement PDF generated successfully: $fileName");
      
      return {
        'success': true,
        'message': 'Commission statement PDF generated successfully',
        'fileName': fileName,
        'filePath': file.path,
        'dateRange': '$dateFrom to $dateTo',
        'totalCommissions': allCommissions.length,
        'directCommission': totalDirectCommission.toStringAsFixed(2),
        'indirectCommission': totalIndirectCommission.toStringAsFixed(2),
        'totalAmount': (totalDirectCommission + totalIndirectCommission).toStringAsFixed(2),
        'pdfBytes': bytes, // Include PDF bytes for preview
      };
    } catch (e) {
      print("❌ CommissionPdfService: Error generating commission statement PDF: $e");
      return {
        'success': false,
        'message': 'Failed to generate commission statement PDF',
        'error': e.toString(),
      };
    }
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
