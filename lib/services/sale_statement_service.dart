import 'dart:async';
import 'package:intl/intl.dart';
import '../models/sale_statement.dart';

/// Service that handles all sale statement-related operations:
/// - Providing mock sale statement master data (direct/indirect totals)
/// - Generating sale details grouped by date
/// - Creating detailed popup information for specific sales
class SaleStatementService {
  static final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");

  /// Get mock sale statement master data for the specified date range
  static Future<SaleStatementMaster> fetchSaleStatementMaster({
    required String dateFrom,
    required String dateTo,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return SaleStatementMaster(
      countSellDirect: "45",
      countSellIndirect: "28",
      amountDirect: "12,850.75",
      amountIndirect: "8,425.50",
    );
  }

  /// Generate mock sale statement details for the specified date range
  /// Returns a map of date strings to lists of sale details
  static Future<Map<String, List<SaleStatementDetail>>> fetchSaleStatementDetails({
    required String dateFrom,
    required String dateTo,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // 1 - Generate comprehensive sample sale data
    final List<SaleStatementDetail> saleList = [
      // Recent sales
      SaleStatementDetail(
        id: "S001",
        description: "Premium Software Package - Enterprise License",
        amount: "850.00",
        date: DateTime.now().subtract(const Duration(days: 1)).toString(),
      ),
      SaleStatementDetail(
        id: "S002",
        description: "Monthly Subscription Renewal",
        amount: "299.99",
        date: DateTime.now().subtract(const Duration(days: 1)).toString(),
      ),
      SaleStatementDetail(
        id: "S003",
        description: "Consulting Services - Q3 Project",
        amount: "1,250.00",
        date: DateTime.now().subtract(const Duration(days: 2)).toString(),
      ),
      SaleStatementDetail(
        id: "S004",
        description: "Hardware Bundle - Workstation Setup",
        amount: "2,100.00",
        date: DateTime.now().subtract(const Duration(days: 2)).toString(),
      ),
      SaleStatementDetail(
        id: "S005",
        description: "Training Workshop - Team Development",
        amount: "675.50",
        date: DateTime.now().subtract(const Duration(days: 3)).toString(),
      ),
      SaleStatementDetail(
        id: "S006",
        description: "Cloud Storage Upgrade",
        amount: "149.99",
        date: DateTime.now().subtract(const Duration(days: 4)).toString(),
      ),
      SaleStatementDetail(
        id: "S007",
        description: "Security Audit Service",
        amount: "950.00",
        date: DateTime.now().subtract(const Duration(days: 5)).toString(),
      ),
      SaleStatementDetail(
        id: "S008",
        description: "Database Migration Service",
        amount: "1,800.00",
        date: DateTime.now().subtract(const Duration(days: 6)).toString(),
      ),
      SaleStatementDetail(
        id: "S009",
        description: "Mobile App Development",
        amount: "3,200.00",
        date: DateTime.now().subtract(const Duration(days: 7)).toString(),
      ),
      SaleStatementDetail(
        id: "S010",
        description: "Annual Support Contract",
        amount: "1,500.00",
        date: DateTime.now().subtract(const Duration(days: 8)).toString(),
      ),
    ];

    // 2 - Filter sales within date range
    final DateTime fromDate = DateTime.parse(dateFrom);
    final DateTime toDate = DateTime.parse(dateTo);
    
    final filteredSales = saleList.where((sale) {
      final saleDate = DateTime.parse(sale.date!);
      return saleDate.isAfter(fromDate.subtract(const Duration(days: 1))) &&
             saleDate.isBefore(toDate.add(const Duration(days: 1)));
    }).toList();

    // 3 - Group sales by date
    final Map<String, List<SaleStatementDetail>> groupedSales = {};
    for (final sale in filteredSales) {
      final dateKey = _dateFormat.format(DateTime.parse(sale.date!));
      if (groupedSales[dateKey] == null) {
        groupedSales[dateKey] = [];
      }
      groupedSales[dateKey]!.add(sale);
    }

    return groupedSales;
  }

  /// Get detailed popup information for a specific sale
  static Future<SaleStatementPopup> fetchSaleStatementPopup({
    required String saleId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock popup data based on sale ID
    return SaleStatementPopup(
      directFrom: "Palm Technologies Inc.",
      toMember: "John Doe (Manager)",
      fromCustomer: "TechCorp Solutions Ltd.",
      remark: "Enterprise software license purchase with premium support package. Includes 24/7 technical assistance and quarterly training sessions.",
      originalAmount: _getMockAmountForSale(saleId),
    );
  }

  /// Helper method to get mock amount based on sale ID
  static String _getMockAmountForSale(String saleId) {
    switch (saleId) {
      case "S001": return "850.00";
      case "S002": return "299.99";
      case "S003": return "1,250.00";
      case "S004": return "2,100.00";
      case "S005": return "675.50";
      case "S006": return "149.99";
      case "S007": return "950.00";
      case "S008": return "1,800.00";
      case "S009": return "3,200.00";
      case "S010": return "1,500.00";
      default: return "500.00";
    }
  }
}
