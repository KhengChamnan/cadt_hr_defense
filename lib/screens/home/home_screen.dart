import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../widgets/display/app_bar/app_bart.dart';
import '../../providers/attendance/attendance_provider.dart';
import '../../providers/approval/approval_provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/asyncvalue.dart';
import 'widgets/profile_card.dart';
import 'widgets/attendance_pie_chart.dart';
import '../qr/scan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when home screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      
      // Wait for auth to be ready before loading data
      print('🔄 HomeScreen: Waiting for auth before loading data...');
      final authReady = await authProvider.waitForAuth(timeout: const Duration(seconds: 3));
      
      if (authReady && mounted) {
        // Load attendance and approval data
        context.read<AttendanceProvider>().getAttendanceList();
        context.read<ApprovalProvider>().getApprovalDashboard();
        print('✅ HomeScreen: Attendance and approval loading triggered after auth ready');
      } else {
        print('❌ HomeScreen: Auth not ready or widget unmounted, skipping data load');
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The Consumer in AttendancePieChart will automatically rebuild when provider changes
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final isLoading = attendanceProvider.attendanceList?.state == AsyncValueState.loading;
    
    return Scaffold(
      body: Skeletonizer(
        enabled: isLoading,
        effect: const ShimmerEffect(),
        child: Column(
          children: [
            const PalmAppBar(),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileCard(),
                    const SizedBox(height: 20),
                    const Expanded(
                      flex: 1,
                      child: AttendancePieChart(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScanQRCode(typeId: 1),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/qr_scanner.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}