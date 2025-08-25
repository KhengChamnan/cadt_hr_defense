/// Model class for Payroll Account Report
/// - Contains report type and related information
class PayrollAccountReport {
  final String reportType;
  final String routeName;

  const PayrollAccountReport({
    required this.reportType,
    required this.routeName,
  });
}

/// List of available payroll account report types
class PayrollAccountReportTypes {
  static const String balance = 'Payroll Account Balance';
  static const String statement = 'Payroll Account Statement';
  static const String split = 'Payroll Split';
  static const String listToBank = 'Payroll List To Bank';
  static const String deposit = 'Payroll Deposit';
  static const String withdrawal = 'Personal Withdrawal';
}

/// Routes for payroll account report screens
class PayrollAccountReportRoutes {
  static const String balance = '/payroll-account/balance';
  static const String statement = '/payroll-account/statement';
  static const String split = '/payroll-account/split';
  static const String listToBank = '/payroll-account/list-to-bank';
  static const String deposit = '/payroll-account/deposit';
  static const String withdrawal = '/payroll-account/withdrawal';
}

/// List of all available payroll account reports
class PayrollAccountReports {
  static const List<PayrollAccountReport> reports = [
    PayrollAccountReport(
      reportType: PayrollAccountReportTypes.balance,
      routeName: PayrollAccountReportRoutes.balance,
    ),
    PayrollAccountReport(
      reportType: PayrollAccountReportTypes.statement,
      routeName: PayrollAccountReportRoutes.statement,
    ),
    PayrollAccountReport(
      reportType: PayrollAccountReportTypes.split,
      routeName: PayrollAccountReportRoutes.split,
    ),
    PayrollAccountReport(
      reportType: PayrollAccountReportTypes.listToBank,
      routeName: PayrollAccountReportRoutes.listToBank,
    ),
    PayrollAccountReport(
      reportType: PayrollAccountReportTypes.deposit,
      routeName: PayrollAccountReportRoutes.deposit,
    ),
    PayrollAccountReport(
      reportType: PayrollAccountReportTypes.withdrawal,
      routeName: PayrollAccountReportRoutes.withdrawal,
    ),
  ];
} 