import 'package:collection/collection.dart';
import '../models/payroll/account/account_balance.dart';
import '../models/payroll/account/account_statement.dart';
import '../models/payroll/account/statement_detail.dart';

/// Service class for handling account-related data operations.
/// Provides mock data for development purposes since API is not working yet.
class AccountService {
  
  /// Simulates API delay for realistic loading experience
  static Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  /// Fetches account balance information
  /// Returns mock data for development purposes
  static Future<AccountBalance> fetchAccountBalance() async {
    print("💰 AccountService: fetchAccountBalance() called");
    await _simulateDelay();
    
    final balance = const AccountBalance(
      accountName: 'Sok Bunethon Savings Account',
      accountNo: 'ACC123456789',
      currentBalance: '5250.75',
      status: '1',
    );
    
    print("💰 AccountService: Account balance fetched successfully");
    return balance;
  }

  /// Fetches account statement list
  /// Returns mock data with realistic transaction history
  static Future<List<AccountStatement>> fetchAccountStatements() async {
    print("📋 AccountService: fetchAccountStatements() called");
    await _simulateDelay();
    
    final statements = [
      // August 2025 - Recent transactions
      const AccountStatement(
        id: '1',
        amount: '-150.00',
        balance: '5250.75',
        date: '2025-08-04T10:30:00.000Z',
        note: 'Office Equipment',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '2',
        amount: '+2000.00',
        balance: '5400.75',
        date: '2025-08-04T09:15:00.000Z',
        note: 'Monthly Salary',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '3',
        amount: '-50.25',
        balance: '3400.75',
        date: '2025-08-03T16:45:00.000Z',
        note: 'Cash Withdrawal',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '4',
        amount: '-25.00',
        balance: '3451.00',
        date: '2025-08-03T14:20:00.000Z',
        note: 'Office Supplies',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '5',
        amount: '+500.00',
        balance: '3476.00',
        date: '2025-08-02T11:30:00.000Z',
        note: 'Overtime Payment',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '6',
        amount: '-75.50',
        balance: '2976.00',
        date: '2025-08-02T08:45:00.000Z',
        note: 'Transportation Allowance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '7',
        amount: '-120.00',
        balance: '3051.50',
        date: '2025-08-01T19:30:00.000Z',
        note: 'Business Travel',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '8',
        amount: '+100.00',
        balance: '3171.50',
        date: '2025-08-01T15:20:00.000Z',
        note: 'Performance Bonus',
        transaction: 'Credit Transaction',
      ),
      
      // July 2025 - Additional month data
      const AccountStatement(
        id: '9',
        amount: '+1800.00',
        balance: '3071.50',
        date: '2025-07-31T14:30:00.000Z',
        note: 'Monthly Salary',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '10',
        amount: '-200.00',
        balance: '1271.50',
        date: '2025-07-31T11:20:00.000Z',
        note: 'Uniform Allowance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '11',
        amount: '-85.75',
        balance: '1471.50',
        date: '2025-07-30T18:45:00.000Z',
        note: 'Meal Allowance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '12',
        amount: '-45.00',
        balance: '1557.25',
        date: '2025-07-30T12:30:00.000Z',
        note: 'Cash Withdrawal',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '13',
        amount: '+300.00',
        balance: '1602.25',
        date: '2025-07-29T16:15:00.000Z',
        note: 'Part-time Salary',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '14',
        amount: '-125.50',
        balance: '1302.25',
        date: '2025-07-29T09:30:00.000Z',
        note: 'Health Insurance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '15',
        amount: '-60.00',
        balance: '1427.75',
        date: '2025-07-28T19:20:00.000Z',
        note: 'Training Allowance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '16',
        amount: '-35.25',
        balance: '1487.75',
        date: '2025-07-28T14:10:00.000Z',
        note: 'Office Supplies',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '17',
        amount: '+250.00',
        balance: '1523.00',
        date: '2025-07-27T10:45:00.000Z',
        note: 'Performance Bonus',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '18',
        amount: '-90.00',
        balance: '1273.00',
        date: '2025-07-26T16:30:00.000Z',
        note: 'Business Travel',
        transaction: 'Debit Transaction',
      ),
      
      // June 2025 - Historical data
      const AccountStatement(
        id: '19',
        amount: '+1750.00',
        balance: '1363.00',
        date: '2025-06-30T15:00:00.000Z',
        note: 'Monthly Salary',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '20',
        amount: '-180.00',
        balance: '-387.00',
        date: '2025-06-29T13:45:00.000Z',
        note: 'Transportation Allowance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '21',
        amount: '-95.50',
        balance: '-207.00',
        date: '2025-06-28T11:30:00.000Z',
        note: 'Meal Allowance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '22',
        amount: '+400.00',
        balance: '-111.50',
        date: '2025-06-27T14:20:00.000Z',
        note: 'Overtime Payment',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '23',
        amount: '-155.75',
        balance: '-511.50',
        date: '2025-06-26T17:15:00.000Z',
        note: 'Health Insurance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '24',
        amount: '-70.25',
        balance: '-355.75',
        date: '2025-06-25T12:10:00.000Z',
        note: 'Cash Withdrawal',
        transaction: 'Debit Transaction',
      ),
      
      // May 2025 - More historical data
      const AccountStatement(
        id: '25',
        amount: '+1650.00',
        balance: '-285.50',
        date: '2025-05-31T16:30:00.000Z',
        note: 'Monthly Salary',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '26',
        amount: '-220.00',
        balance: '-1935.50',
        date: '2025-05-30T14:15:00.000Z',
        note: 'Uniform Allowance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '27',
        amount: '-115.75',
        balance: '-1715.50',
        date: '2025-05-29T10:45:00.000Z',
        note: 'Training Allowance',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '28',
        amount: '+350.00',
        balance: '-1599.75',
        date: '2025-05-28T13:30:00.000Z',
        note: 'Performance Bonus',
        transaction: 'Credit Transaction',
      ),
      const AccountStatement(
        id: '29',
        amount: '-80.50',
        balance: '-1949.75',
        date: '2025-05-27T16:20:00.000Z',
        note: 'Business Travel',
        transaction: 'Debit Transaction',
      ),
      const AccountStatement(
        id: '30',
        amount: '-65.00',
        balance: '-1869.25',
        date: '2025-05-26T11:10:00.000Z',
        note: 'Office Equipment',
        transaction: 'Debit Transaction',
      ),
    ];
    
    print("📋 AccountService: ${statements.length} statements fetched successfully");
    return statements;
  }

  /// Fetches statement detail for popup display
  /// Returns mock data based on statement ID
  static Future<StatementDetail> fetchStatementDetail(String statementId) async {
    print("📄 AccountService: fetchStatementDetail() called for ID: $statementId");
    await _simulateDelay();
    
    StatementDetail detail;
    
    // Company/HR payroll related financial data
    // originalAmount: Gross amount before deductions (taxes, insurance, etc.)
    // amount: Net amount after deductions
    // toMemberId: Company department or payroll category
    // remark: HR/Admin remarks about the transaction
    switch (statementId) {
      case '1':
        detail = const StatementDetail(
          originalAmount: '150.00',
          toMemberId: 'Company Equipment',
          remark: 'ទិញឧបករណ៍អេឡិចត្រូនិចសម្រាប់ការិយាល័យ - កុំព្យូទ័រកូន្លុះ',
          amount: '150.00',
        );
        break;
      case '2':
        detail = const StatementDetail(
          originalAmount: '2200.00',
          toMemberId: 'Monthly Salary',
          remark: 'ប្រាក់ខែសីហា ២០២៥ - ប្រាក់ខែមុនកាត់ពន្ធ',
          amount: '2000.00',
        );
        break;
      case '3':
        detail = const StatementDetail(
          originalAmount: '50.25',
          toMemberId: 'Cash Withdrawal',
          remark: 'ដកលុយសាច់ខែសីហា',
          amount: '50.25',
        );
        break;
      case '4':
        detail = const StatementDetail(
          originalAmount: '25.00',
          toMemberId: 'Office Supplies',
          remark: 'ការទិញគ្រឿងសរសេរនិងសម្ភារៈការិយាល័យ',
          amount: '25.00',
        );
        break;
      case '5':
        detail = const StatementDetail(
          originalAmount: '520.00',
          toMemberId: 'Overtime Payment',
          remark: 'ប្រាក់បន្ថែមម៉ោង - ការងារលើសម៉ោង',
          amount: '500.00',
        );
        break;
      case '6':
        detail = const StatementDetail(
          originalAmount: '75.50',
          toMemberId: 'Transportation Allowance',
          remark: 'ប្រាក់ជំនួយការធ្វើដំណើរ - សម្រាប់ការងារ',
          amount: '75.50',
        );
        break;
      case '7':
        detail = const StatementDetail(
          originalAmount: '120.00',
          toMemberId: 'Business Travel',
          remark: 'ចំណាយការធ្វើដំណើរសម្រាប់ប្រតិបត្តិការក្រុមហ៊ុន',
          amount: '120.00',
        );
        break;
      case '8':
        detail = const StatementDetail(
          originalAmount: '100.00',
          toMemberId: 'Performance Bonus',
          remark: 'ប្រាក់រង្វាន់ដោយសារតែការអនុវត្តការងារល្អ',
          amount: '100.00',
        );
        break;
      case '9':
        detail = const StatementDetail(
          originalAmount: '1980.00',
          toMemberId: 'Monthly Salary',
          remark: 'ប្រាក់ខែកក្កដា ២០២៥ - ប្រាក់ខែមុនកាត់ពន្ធ',
          amount: '1800.00',
        );
        break;
      case '10':
        detail = const StatementDetail(
          originalAmount: '200.00',
          toMemberId: 'Uniform Allowance',
          remark: 'ប្រាក់ជំនួយសម្រាប់ឯកសណ្ឋាន - ខោអាវការងារ',
          amount: '200.00',
        );
        break;
      case '11':
        detail = const StatementDetail(
          originalAmount: '85.75',
          toMemberId: 'Meal Allowance',
          remark: 'ប្រាក់ជំនួយអាហារ - អាហារថ្ងៃត្រង់សម្រាប់បុគ្គលិក',
          amount: '85.75',
        );
        break;
      case '12':
        detail = const StatementDetail(
          originalAmount: '45.00',
          toMemberId: 'Cash Withdrawal',
          remark: 'ដកលុយសាច់ខែកក្កដា',
          amount: '45.00',
        );
        break;
      case '13':
        detail = const StatementDetail(
          originalAmount: '312.00',
          toMemberId: 'Part-time Salary',
          remark: 'ប្រាក់ខែបុគ្គលិក Part-time - កាត់ពន្ធ',
          amount: '300.00',
        );
        break;
      case '14':
        detail = const StatementDetail(
          originalAmount: '125.50',
          toMemberId: 'Health Insurance',
          remark: 'ការធានារ៉ាប់រងសុខភាពសម្រាប់បុគ្គលិក',
          amount: '125.50',
        );
        break;
      case '15':
        detail = const StatementDetail(
          originalAmount: '60.00',
          toMemberId: 'Training Allowance',
          remark: 'ប្រាក់ជំនួយសម្រាប់ការបណ្តុះបណ្តាលបុគ្គលិក',
          amount: '60.00',
        );
        break;
      default:
        detail = const StatementDetail(
          originalAmount: '0.00',
          toMemberId: 'Unknown Department',
          remark: 'ព័ត៌មានលម្អិតអំពីប្រតិបត្តិការមិនមាន',
          amount: '0.00',
        );
    }
    
    print("📄 AccountService: Statement detail fetched successfully for ID: $statementId");
    return detail;
  }

  /// Groups account statements by date for display
  /// Returns a map with date as key and list of statements as value
  static Map<String, List<AccountStatement>> groupStatementsByDate(List<AccountStatement> statements) {
    return statements.groupListsBy((statement) => statement.dateForGrouping);
  }

  /// Gets sorted date keys for grouped statements (newest first)
  static List<String> getSortedDateKeys(Map<String, List<AccountStatement>> groupedStatements) {
    final dates = groupedStatements.keys.toList();
    dates.sort((a, b) => b.compareTo(a));     // Sort descending (newest first)
    return dates;
  }

  /// Validates if account is active and accessible
  static bool isAccountValid(AccountBalance account) {
    return account.isValid;
  }
}
