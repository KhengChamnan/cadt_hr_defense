import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/attendance/attendance_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import '../../../theme/app_theme.dart';
import '../../../services/attendance_service.dart';
import 'widgets/all_attendance_card.dart';

class AllScreen extends StatefulWidget {
  final int attendanceType; // Type of attendance (1: Normal, 2: Overtime, 3: Part Time)
  
  const AllScreen({
    super.key,
    required this.attendanceType,
  });

  @override
  State<AllScreen> createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  @override
  void initState() {
    super.initState();
    
    // Fetch attendance data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
      if (attendanceProvider.attendanceList == null) {
        attendanceProvider.getAttendanceList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: PalmSpacings.m),
          _buildAllAttendance(),
          // Add bottom padding for scrolling
          const SizedBox(height: PalmSpacings.xl),
        ],
      ),
    );
  }

  Widget _buildAllAttendance() {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final isLoading = attendanceProvider.attendanceList?.state == AsyncValueState.loading;
    
    // Generate fake data for skeleton loading
    final List<Map<String, String>> skeletonData = List.generate(10, (index) {
      final day = DateTime.now().subtract(Duration(days: index));
      return {
        'date': '${day.day}/${day.month}/${day.year}',
        'checkInTime': '09:00 AM',
        'checkOutTime': '05:00 PM',
        'status': index % 3 == 0 ? 'Early' : (index % 3 == 1 ? 'Late' : 'On Time'),
        'totalHours': '8h 0m',
      };
    });
    
    // Get all attendance data
    final allData = isLoading 
        ? skeletonData 
        : AttendanceService.getAllAttendanceCardData(
            attendanceProvider,
            attendanceType: widget.attendanceType,
          );
    
    // Removed horizontal padding to allow full width cards
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Reduced top spacing
        const SizedBox(height: PalmSpacings.s),
        
        // All attendance cards
        allData.isEmpty && !isLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: PalmSpacings.xl),
                  child: Text(
                    'No attendance records found',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              )
            : Column(
                children: allData.map((attendance) {
                  // Removed Padding wrapper to eliminate spacing between cards
                  return AllAttendanceCard(
                    checkInTime: attendance['checkInTime'],
                    checkOutTime: attendance['checkOutTime'],
                    status: attendance['status']!,
                    totalHours: attendance['totalHours']!,
                    date: attendance['date'],
                  );
                }).toList(),
              ),
      ],
    );
  }
}
