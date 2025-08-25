import 'dart:async';
import 'package:palm_ecommerce_mobile_app_2/models/commission.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

/// Service that handles all commission-related operations:
/// - Providing mock commission master data (direct/indirect totals)
/// - Generating commission details grouped by date
/// - Creating detailed popup information for specific commissions
class CommissionService {
  static final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");

  /// Get mock commission master data for the specified date range
  static Future<CommissionMaster> fetchCommissionMaster({
    required String dateFrom,
    required String dateTo,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // More realistic commission totals following account service pattern
    return CommissionMaster(
      directCommission: "4,285.75",
      directBalanceCommission: "2,150.50",
      indirectCommission: "1,845.25",
      indirectBalanceCommission: "925.75",
    );
  }

  /// Generate mock commission details for the specified date range
  /// Returns a map of date strings to lists of commission details
  static Future<Map<String, List<CommissionDetail>>> fetchCommissionDetails({
    required String dateFrom,
    required String dateTo,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // 1 - Generate comprehensive sample commission data
    final List<CommissionDetail> commissionList = [
      // August 2025 - Recent commissions
      CommissionDetail(
        id: "C001",
        description: "Direct Sales Commission - Premium Package",
        amount: "450.00",
        date: DateTime.now().subtract(const Duration(days: 1)).toString(),
      ),
      CommissionDetail(
        id: "C002",
        description: "Team Leadership Bonus",
        amount: "275.50",
        date: DateTime.now().subtract(const Duration(days: 1)).toString(),
      ),
      CommissionDetail(
        id: "C003",
        description: "Referral Bonus - New VIP Client",
        amount: "185.25",
        date: DateTime.now().subtract(const Duration(days: 2)).toString(),
      ),
      CommissionDetail(
        id: "C004",
        description: "Monthly Performance Achievement",
        amount: "320.00",
        date: DateTime.now().subtract(const Duration(days: 2)).toString(),
      ),
      CommissionDetail(
        id: "C005",
        description: "Indirect Commission - Downline Sales",
        amount: "125.75",
        date: DateTime.now().subtract(const Duration(days: 3)).toString(),
      ),
      CommissionDetail(
        id: "C006",
        description: "Special Promotion Bonus",
        amount: "95.00",
        date: DateTime.now().subtract(const Duration(days: 3)).toString(),
      ),
      CommissionDetail(
        id: "C007",
        description: "Customer Retention Bonus",
        amount: "65.00",
        date: DateTime.now().subtract(const Duration(days: 4)).toString(),
      ),
      CommissionDetail(
        id: "C008",
        description: "Training Completion Bonus",
        amount: "150.00",
        date: DateTime.now().subtract(const Duration(days: 5)).toString(),
      ),
      
      // July 2025 - Previous month data
      CommissionDetail(
        id: "C009",
        description: "Monthly Target Achievement - July",
        amount: "520.00",
        date: DateTime.now().subtract(const Duration(days: 6)).toString(),
      ),
      CommissionDetail(
        id: "C010",
        description: "Direct Sales Commission - Corporate Deal",
        amount: "780.00",
        date: DateTime.now().subtract(const Duration(days: 7)).toString(),
      ),
      CommissionDetail(
        id: "C011",
        description: "Team Building Activity Bonus",
        amount: "85.50",
        date: DateTime.now().subtract(const Duration(days: 8)).toString(),
      ),
      CommissionDetail(
        id: "C012",
        description: "Quarterly Performance Bonus",
        amount: "1200.00",
        date: DateTime.now().subtract(const Duration(days: 9)).toString(),
      ),
      CommissionDetail(
        id: "C013",
        description: "Product Launch Participation",
        amount: "175.25",
        date: DateTime.now().subtract(const Duration(days: 10)).toString(),
      ),
      CommissionDetail(
        id: "C014",
        description: "Cross-selling Commission",
        amount: "245.75",
        date: DateTime.now().subtract(const Duration(days: 11)).toString(),
      ),
      CommissionDetail(
        id: "C015",
        description: "Customer Service Excellence Award",
        amount: "300.00",
        date: DateTime.now().subtract(const Duration(days: 12)).toString(),
      ),
      CommissionDetail(
        id: "C016",
        description: "Indirect Commission - Team Growth",
        amount: "165.50",
        date: DateTime.now().subtract(const Duration(days: 13)).toString(),
      ),
      CommissionDetail(
        id: "C017",
        description: "Innovation Suggestion Bonus",
        amount: "125.00",
        date: DateTime.now().subtract(const Duration(days: 14)).toString(),
      ),
      CommissionDetail(
        id: "C018",
        description: "Weekend Sales Achievement",
        amount: "195.25",
        date: DateTime.now().subtract(const Duration(days: 15)).toString(),
      ),
      
      // June 2025 - Historical data
      CommissionDetail(
        id: "C019",
        description: "Monthly Sales Target - June",
        amount: "485.00",
        date: DateTime.now().subtract(const Duration(days: 20)).toString(),
      ),
      CommissionDetail(
        id: "C020",
        description: "Client Retention Milestone",
        amount: "350.75",
        date: DateTime.now().subtract(const Duration(days: 22)).toString(),
      ),
      CommissionDetail(
        id: "C021",
        description: "Direct Sales Commission - Enterprise",
        amount: "650.00",
        date: DateTime.now().subtract(const Duration(days: 25)).toString(),
      ),
      CommissionDetail(
        id: "C022",
        description: "Training Program Completion",
        amount: "120.50",
        date: DateTime.now().subtract(const Duration(days: 28)).toString(),
      ),
      CommissionDetail(
        id: "C023",
        description: "Market Research Participation",
        amount: "75.00",
        date: DateTime.now().subtract(const Duration(days: 30)).toString(),
      ),
      CommissionDetail(
        id: "C024",
        description: "Indirect Commission - Regional Growth",
        amount: "285.25",
        date: DateTime.now().subtract(const Duration(days: 32)).toString(),
      ),
      
      // May 2025 - More historical data
      CommissionDetail(
        id: "C025",
        description: "Monthly Performance - May",
        amount: "420.00",
        date: DateTime.now().subtract(const Duration(days: 35)).toString(),
      ),
      CommissionDetail(
        id: "C026",
        description: "Special Event Commission",
        amount: "195.75",
        date: DateTime.now().subtract(const Duration(days: 38)).toString(),
      ),
      CommissionDetail(
        id: "C027",
        description: "Digital Marketing Success Bonus",
        amount: "155.50",
        date: DateTime.now().subtract(const Duration(days: 40)).toString(),
      ),
      CommissionDetail(
        id: "C028",
        description: "Partnership Development Bonus",
        amount: "385.00",
        date: DateTime.now().subtract(const Duration(days: 42)).toString(),
      ),
      CommissionDetail(
        id: "C029",
        description: "Customer Feedback Excellence",
        amount: "110.25",
        date: DateTime.now().subtract(const Duration(days: 45)).toString(),
      ),
      CommissionDetail(
        id: "C030",
        description: "Year-to-Date Achievement Bonus",
        amount: "850.00",
        date: DateTime.now().subtract(const Duration(days: 48)).toString(),
      ),
    ];

    // 2 - Group commissions by date
    final Map<String, List<CommissionDetail>> groupedCommissions = 
        commissionList.groupListsBy((commission) => 
            _dateFormat.format(DateTime.parse(commission.date ?? DateTime.now().toString())));

    return groupedCommissions;
  }

  /// Generate mock detailed popup information for a specific commission
  static Future<CommissionPopup> fetchCommissionPopup({
    required String commissionId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate different mock data based on commission ID
    // Following the account service pattern with realistic HR/commission data
    switch (commissionId) {
      case "C001":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "465.00",
          directFrom: "John Smith - Senior Manager",
          toMember: "Current User",
          fromCustomer: "ABC Premium Solutions Ltd.",
          remark: "ការលក់ផ្ទាល់ដោយសម្រេចគោលដៅខ្ពស់ - កម្រង់ Premium Package",
          amount: "450.00",
        );
      case "C002":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "290.00",
          directFrom: "Sarah Johnson - Team Lead",
          toMember: "Current User", 
          fromCustomer: "Team Leadership Department",
          remark: "ការដឹកនាំក្រុមដោយជោគជ័យ - ការលើកទឹកចិត្តសម្រាប់ការងារជាក្រុម",
          amount: "275.50",
        );
      case "C003":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "195.00",
          directFrom: "Michael Chen - Sales Director",
          toMember: "Current User",
          fromCustomer: "VIP Corporate Client",
          remark: "ការណែនាំអតិថិជន VIP ថ្មី - ការរួមចំណែកដ៏ល្អឥតខ្ចោះ",
          amount: "185.25",
        );
      case "C004":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "335.00",
          directFrom: "HR Department",
          toMember: "Current User",
          fromCustomer: "Monthly Performance Review",
          remark: "ការសម្រេចបាននូវគោលដៅប្រចាំខែ - ការអនុវត្តការងារប្រកបដោយប្រសិទ្ធភាព",
          amount: "320.00",
        );
      case "C005":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "135.00",
          directFrom: "Regional Team",
          toMember: "Current User",
          fromCustomer: "Downline Network Sales",
          remark: "ការលក់ដោយប្រយោល - ការរួមចំណែកពីបណ្តាញក្រុម",
          amount: "125.75",
        );
      case "C006":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "100.00",
          directFrom: "Marketing Department",
          toMember: "Current User",
          fromCustomer: "Special Campaign Promotion",
          remark: "ការចូលរួមក្នុងកម្មវិធីផ្សព្វផ្សាយពិសេស - ការលើកទឹកចិត្តពី Marketing",
          amount: "95.00",
        );
      case "C007":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "70.00",
          directFrom: "Customer Service Team",
          toMember: "Current User",
          fromCustomer: "Client Retention Program",
          remark: "ការរក្សាអតិថិជនបានយូរអង្វែង - សេវាកម្មអតិថិជនល្អឥតខ្ចោះ",
          amount: "65.00",
        );
      case "C008":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "160.00",
          directFrom: "Training Department",
          toMember: "Current User",
          fromCustomer: "Professional Development",
          remark: "ការបញ្ចប់វគ្គបណ្តុះបណ្តាលដោយជោគជ័យ - ការអភិវឌ្ឍន៍វិជ្ជាជីវៈ",
          amount: "150.00",
        );
      case "C009":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "545.00",
          directFrom: "Regional Manager",
          toMember: "Current User",
          fromCustomer: "July Monthly Assessment",
          remark: "ការសម្រេចបាននូវគោលដៅប្រចាំខែកក្កដា - ការលើកទឹកចិត្តពិសេស",
          amount: "520.00",
        );
      case "C010":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "820.00",
          directFrom: "Corporate Sales Team",
          toMember: "Current User",
          fromCustomer: "Fortune 500 Enterprise",
          remark: "ការលក់ផ្ទាល់ដល់ក្រុមហ៊ុនធំ - កិច្ចសន្យាអាជីវកម្មទំហំធំ",
          amount: "780.00",
        );
      case "C011":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "90.00",
          directFrom: "HR Activities Team",
          toMember: "Current User",
          fromCustomer: "Team Building Department",
          remark: "ការចូលរួមសកម្មភាពកសាងក្រុម - ការលើកកម្ពស់ស្មារតីក្រុម",
          amount: "85.50",
        );
      case "C012":
        return CommissionPopup(
          id: commissionId,
          originalAmount: "1260.00",
          directFrom: "Executive Management",
          toMember: "Current User",
          fromCustomer: "Quarterly Review Board",
          remark: "ការអនុវត្តការងារល្អឥតខ្ចោះក្នុងត្រីមាស - ការលើកទឹកចិត្តពីថ្នាក់ដឹកនាំ",
          amount: "1200.00",
        );
      default:
        return CommissionPopup(
          id: commissionId,
          originalAmount: "105.00",
          directFrom: "System Generated",
          toMember: "Current User",
          fromCustomer: "General Commission",
          remark: "ការទូទាត់រង្វាន់ទូទៅ - ការរួមចំណែកក្នុងការងារ",
          amount: "100.00",
        );
    }
  }

  /// Get sorted date keys from grouped commission details
  /// Returns dates in descending order (newest first)
  static List<String> getSortedDateKeys(Map<String, List<CommissionDetail>> groupedCommissions) {
    return groupedCommissions.keys.toList()
      ..sort((a, b) => b.compareTo(a));                     // Sort in descending order
  }

  /// Generate date range strings for commission filtering
  static Map<String, String> generateDateRange(int daysBack) {
    final DateTime now = DateTime.now();
    final DateTime fromDate = now.subtract(Duration(days: daysBack));
    
    return {
      'dateFrom': _dateFormat.format(fromDate),
      'dateTo': _dateFormat.format(now),
    };
  }
}
