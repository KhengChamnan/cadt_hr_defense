import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/repository_factory.dart';
import 'package:palm_ecommerce_mobile_app_2/main.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/account_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/approval/approval_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/attendance/attendance_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/leave/leave_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/profile_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/settings_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/staff/staff_provder.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/team_provider.dart';
import 'package:provider/provider.dart';

class ProviderSetup extends StatelessWidget {
  final BuildContext? context;

  const ProviderSetup({
    super.key,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    // Get the repository factory instance
    final repositoryFactory = RepositoryFactory();

    return MultiProvider(
      providers: [
        // Repository Factory Provider
        Provider.value(
          value: repositoryFactory,
        ),

        // Authentication Provider
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            repository: repositoryFactory.getAuthRepository(),
          ),
        ),

        // Profile Provider
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(
            profileRepository: repositoryFactory.getProfileRepository(),
          ),
        ),

        //Attendance Provider
        ChangeNotifierProvider(
          create: (_) => AttendanceProvider(
            attendanceRepository: repositoryFactory.getAttendanceRepository(),
          ),
        ),

        //Staff Provider
        ChangeNotifierProvider(
          create: (_) => StaffProvider(
            staffRepository: repositoryFactory.getStaffRepository(),
          ),
        ),

        // Leave Provider
        ChangeNotifierProvider(
          create: (_) => LeaveProvider(
            leaveRepository: repositoryFactory.getLeaveRepository(),
          ),
        ),

        // Approval Provider
        ChangeNotifierProvider(
          create: (_) => ApprovalProvider(
            approvalRepository: repositoryFactory.getApprovalRepository(),
          ),
        ),

        // Settings Provider
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            settingRepository: repositoryFactory.getSettingsRepository(),
          ),
        ),

        // Team Provider
        ChangeNotifierProvider(
          create: (_) => TeamProvider(),
        ),

        // Account Provider
        ChangeNotifierProvider(
          create: (_) => AccountProvider(),
        ),
      ],
      child: const MyApp(),
    );
  }
}
