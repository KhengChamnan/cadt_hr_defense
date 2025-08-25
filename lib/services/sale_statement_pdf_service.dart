import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/sale_statement.dart';

/// Service class for handling PDF generation of sale statements.
/// Provides functionality to generate PDFs for sale data.
class SaleStatementPdfService {
  
  /// Generates PDF for sale statement
  /// Returns success status and file path or error message
  static Future<Map<String, dynamic>> generateSaleStatementPdf(
    Map<String, List<SaleStatementDetail>> saleDetails,
    SaleStatementMaster? saleMaster,
    String dateFrom,
    String dateTo,
  ) async {
    print("📄 SaleStatementPdfService: generateSaleStatementPdf() called");
    
    try {
      // Create PDF document
      final pdf = pw.Document();
      
      // Flatten sale details for processing
      final List<SaleStatementDetail> allSales = [];
      saleDetails.forEach((date, sales) {
        allSales.addAll(sales);
      });
      
      // Calculate totals
      double totalDirectAmount = double.tryParse(
        saleMaster?.amountDirect?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0'
      ) ?? 0;
      double totalIndirectAmount = double.tryParse(
        saleMaster?.amountIndirect?.replaceAll(RegExp(r'[^\d.]'), '') ?? '0'
      ) ?? 0;
      double totalAmount = totalDirectAmount + totalIndirectAmount;
      
      int directCount = int.tryParse(saleMaster?.countSellDirect ?? '0') ?? 0;
      int indirectCount = int.tryParse(saleMaster?.countSellIndirect ?? '0') ?? 0;
      
      // Sort sales by date (newest first)
      final sortedSales = List<SaleStatementDetail>.from(allSales);
      
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
                      'SALE STATEMENT',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Period: $dateFrom to $dateTo'),
                    pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}'),
                    pw.Text('Total Sales: ${allSales.length}'),
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
                      'Sale Summary',
                      style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 15),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Column(
                          children: [
                            pw.Text('Direct Sales', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${totalDirectAmount.toStringAsFixed(2)}', 
                              style: pw.TextStyle(fontSize: 16, color: PdfColors.blue)),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text('Indirect Sales', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${totalIndirectAmount.toStringAsFixed(2)}', 
                              style: pw.TextStyle(fontSize: 16, color: PdfColors.green)),
                          ],
                        ),
                        pw.Column(
                          children: [
                            pw.Text('Total Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text('\$${totalAmount.toStringAsFixed(2)}', 
                              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 20),
              
              // Sale Details Table
              if (allSales.isNotEmpty) ...[
                pw.Text(
                  'Sale Details',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2), // Date
                    1: const pw.FlexColumnWidth(4), // Description
                    2: const pw.FlexColumnWidth(2), // Amount
                  },
                  children: [
                    // Table Header
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
                      ],
                    ),
                    
                    // Table Data
                    ...sortedSales.map((sale) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(sale.date ?? 'N/A'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(sale.description ?? 'N/A'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(sale.amount ?? 'N/A'),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
              
              pw.SizedBox(height: 20),
              
              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.only(top: 20),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(width: 1)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Report Statistics:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text('• Total Transactions: ${allSales.length}'),
                    pw.Text('• Period: $dateFrom to $dateTo'),
                    pw.Text('• Generated on: ${DateTime.now().toString().split('.')[0]}'),
                  ],
                ),
              ),
            ];
          },
        ),
      );

      // Save PDF to device
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/sale_statement_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      
      // Save and show PDF using printing package
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      
      print("📄 SaleStatementPdfService: PDF generated successfully at ${file.path}");
      
      return {
        'success': true,
        'message': 'Sale statement PDF generated successfully',
        'filePath': file.path,
        'totalSales': allSales.length,
        'totalAmount': totalAmount,
        'dateRange': '$dateFrom to $dateTo',
      };
      
    } catch (e) {
      print("❌ SaleStatementPdfService: Error generating PDF - $e");
      return {
        'success': false,
        'message': 'Failed to generate PDF: $e',
      };
    }
  }
  
  /// Generates PDF for a specific date range of sales
  static Future<Map<String, dynamic>> generateSaleStatementPdfForDateRange(
    Map<String, List<SaleStatementDetail>> saleDetails,
    SaleStatementMaster? saleMaster,
    String dateFrom,
    String dateTo,
    int numberOfMonths,
  ) async {
    print("📄 SaleStatementPdfService: generateSaleStatementPdfForDateRange() called for $numberOfMonths months");
    
    try {
      // Filter sales by date range
      final now = DateTime.now();
      final cutoffDate = DateTime(now.year, now.month - numberOfMonths + 1, 1);
      
      final Map<String, List<SaleStatementDetail>> filteredSales = {};
      
      saleDetails.forEach((date, sales) {
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
      
      // Calculate filtered date from
      final filteredDateFrom = '${cutoffDate.year}-${cutoffDate.month.toString().padLeft(2, '0')}-01';
      
      return await generateSaleStatementPdf(filteredSales, saleMaster, filteredDateFrom, dateTo);
      
    } catch (e) {
      print("❌ SaleStatementPdfService: Error generating filtered PDF - $e");
      return {
        'success': false,
        'message': 'Failed to generate filtered PDF: $e',
      };
    }
  }
}
