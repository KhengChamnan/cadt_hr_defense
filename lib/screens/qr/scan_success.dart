import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/attendance/attendance_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/routes.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/location_management.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/bottom_navigator.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/error_handler.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/auto_dismiss_dialog.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/qr/widgets/attendance_success_bottom_sheet.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/qr/widgets/attendance_error_bottom_sheet.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/loading_widget.dart';

class ScanSuccess extends StatefulWidget {
  final int typeId;
  const ScanSuccess({super.key, required this.typeId});

  @override
  State<ScanSuccess> createState() => _ScanSuccessState();
}

class _ScanSuccessState extends State<ScanSuccess> {
  late Attendance attendanceData;
  late AttendanceProvider _attendanceProvider;
  bool _isLoading = true;
  String _attendanceStatus = 'in'; // Default status

  // Working hours configuration (in minutes from midnight)
  static const int workStartTime = 6 * 60; // 6:00 AM (allow 2 hours early)
  static const int workEndTime = 20 * 60; // 8:00 PM (allow late checkout)

  @override
  void initState() {
    super.initState();
    _attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    _initializeAttendance();
  }

  Future<void> _initializeAttendance() async {
    try {
      print('🚀 Starting attendance initialization...');

      // Get location
      print('📍 Getting location data...');
      await _getLocationData();
      print('📍 Location data obtained: $address');

      // Validate working hours
      print('⏰ Validating working hours...');
      if (!_isWithinWorkingHours()) {
        print('❌ Outside working hours, showing error');
        _showWorkingHoursError();
        return;
      }
      print('✅ Working hours validated');

      // Determine status (in/out) based on latest attendance record
      print('🔄 Determining attendance status...');
      await _determineAttendanceStatus();
      print('✅ Attendance status determined: $_attendanceStatus');

      // Initialize attendance data
      print('📋 Creating attendance data...');
      attendanceData = Attendance(
        attendanceDate:
            "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
        attendanceTime:
            "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
        inOut: _attendanceStatus,
        distant: address,
        workTypeId: widget.typeId,
        latitude: double.parse(latitude),
        longitude: double.parse(longitude),
      );
      print('✅ Attendance data created successfully');

      // Process the attendance immediately
      print('🚀 Submitting attendance to API...');
      await _submitAttendance();
    } catch (e) {
      if (mounted) {
        AutoDismissDialog.showError(
          context: context,
          title: 'Error',
          message: 'Failed to get location: $e',
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _determineAttendanceStatus() async {
    try {
      print('🔄 Fetching attendance list from API...');
      // Fetch the latest attendance records
      await _attendanceProvider.getAttendanceList();

      print(
          '📊 Attendance list state: ${_attendanceProvider.attendanceList?.state}');

      if (_attendanceProvider.attendanceList?.state ==
          AsyncValueState.success) {
        final attendances = _attendanceProvider.attendanceList?.data;

        if (attendances != null && attendances.isNotEmpty) {
          // Sort by date and time (descending) to get the latest record
          attendances.sort((a, b) {
            final dateComparison =
                (b.attendanceDate ?? '').compareTo(a.attendanceDate ?? '');
            if (dateComparison != 0) return dateComparison;
            return (b.attendanceTime ?? '').compareTo(a.attendanceTime ?? '');
          });

          // Get the latest record's status
          final latestStatus = attendances.first.inOut;
          print('📋 Latest attendance status: $latestStatus');

          // Set the current status as the opposite of the latest
          final newStatus = (latestStatus == 'in') ? 'out' : 'in';
          print('🔄 Setting new attendance status: $newStatus');

          if (mounted) {
            setState(() {
              _attendanceStatus = newStatus;
            });
          } else {
            print('⚠️ Widget not mounted, skipping setState');
          }

          return;
        }
      }

      // If no records found or error, default to 'in'
      print('📋 No attendance records found, defaulting to: in');
      if (mounted) {
        setState(() {
          _attendanceStatus = 'in';
        });
      } else {
        print('⚠️ Widget not mounted, skipping setState');
      }
    } catch (e) {
      // If error, default to 'in'
      print('❌ Error determining attendance status: $e');
      print('📋 Defaulting to: in');
      if (mounted) {
        setState(() {
          _attendanceStatus = 'in';
        });
      } else {
        print('⚠️ Widget not mounted, skipping setState');
      }
    }
  }

  Future<void> _getLocationData() async {
    Position position = await getGeoLocationPosition();
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    await getAddressFromLatLong(position);
  }

  Future<void> _submitAttendance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('📤 Calling attendance provider...');
      await _attendanceProvider.submitAttendance(attendanceData);

      print('📨 API response received');
      print('📊 Status: ${_attendanceProvider.postAttendanceStatus?.state}');

      if (_attendanceProvider.postAttendanceStatus?.state ==
          AsyncValueState.success) {
        if (!mounted) return;

        print('✅ Attendance submitted successfully!');
        _showSuccessDialog();
      } else if (_attendanceProvider.postAttendanceStatus?.state ==
          AsyncValueState.error) {
        if (!mounted) return;

        print('❌ Attendance submission failed');
        final errorData = _attendanceProvider.postAttendanceStatus?.error;
        print('❌ Error details: $errorData');

        await ErrorHandler.handleError(
          context: context,
          errorData: errorData,
          duration: const Duration(seconds: 2),
        );
      } else {
        print(
            '⚠️ Unexpected state: ${_attendanceProvider.postAttendanceStatus?.state}');
      }
    } catch (e) {
      if (!mounted) return;

      await AutoDismissDialog.showError(
        context: context,
        title: 'Error',
        message: e.toString(),
        duration: const Duration(seconds: 2),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    AttendanceSuccessBottomSheet.show(
      context,
      onBackToHome: () {
        Navigator.of(context).pop();
        MyRouter.pushPageReplacement(context, const BottomNavBar());
      },
      attendanceStatus: _attendanceStatus,
    );
  }

  String _getAttendanceTypeName() {
    switch (widget.typeId) {
      case 1:
        return "Regular";
      case 2:
        return "Over Time";
      case 3:
        return "Part Time";
      default:
        return "Unknown";
    }
  }

  /// Validates if current time is within allowed working hours
  bool _isWithinWorkingHours() {
    final now = DateTime.now();
    final currentTime =
        now.hour * 60 + now.minute; // Convert to minutes from midnight

    // Check if it's a weekend (Saturday = 6, Sunday = 7)
    bool isWeekend = now.weekday == 6 || now.weekday == 7;

    // For overtime type, allow weekend work
    if (widget.typeId == 2 && isWeekend) {
      return true;
    }

    // For regular and part-time, no work on weekends
    if (isWeekend && widget.typeId != 2) {
      return false;
    }

    // Check if within allowed working hours
    return currentTime >= workStartTime && currentTime <= workEndTime;
  }

  /// Shows error bottom sheet when trying to clock in/out outside working hours
  void _showWorkingHoursError() {
    final now = DateTime.now();
    final currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    String errorTitle;
    String errorMessage;

    // Check if it's weekend
    if (now.weekday == 6 || now.weekday == 7) {
      if (widget.typeId == 2) {
        errorTitle = "Weekend Overtime";
        errorMessage =
            "Weekend overtime attendance is allowed, but there may be special conditions. Please contact your supervisor for approval.";
      } else {
        errorTitle = "Weekend Not Allowed";
        errorMessage =
            "Attendance is not allowed on weekends for ${_getAttendanceTypeName()} work type. Regular work is Monday to Friday only.";
      }
    } else {
      // Weekday but outside hours
      final startHour = workStartTime ~/ 60;
      final startMinute = workStartTime % 60;
      final endHour = workEndTime ~/ 60;
      final endMinute = workEndTime % 60;

      if (now.hour < 6) {
        errorTitle = "Too Early";
        errorMessage =
            "Attendance is only allowed starting from ${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}. Please wait until the allowed time to clock in.";
      } else {
        errorTitle = "Too Late";
        errorMessage =
            "Attendance is only allowed until ${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}. The allowed time window has ended for today.";
      }
    }

    setState(() {
      _isLoading = false;
    });

    AttendanceErrorBottomSheet.show(
      context,
      errorTitle: errorTitle,
      errorMessage: errorMessage,
      currentTime: currentTime,
      workType: _getAttendanceTypeName(),
      onBackToHome: () {
        Navigator.of(context).pop(); // Close bottom sheet
        Navigator.of(context).pop(); // Navigate back to previous screen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor =
        PalmColors.primary; // Use consistent primary color

    return Scaffold(
      body: Stack(
        children: [
          // Background success visualization
          Container(
            width: double.infinity,
            height: double.infinity,
            color: statusColor.withOpacity(0.05),
          ),

          // Success content
          Center(
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoadingWidget(),
                      SizedBox(height: PalmSpacings.m),
                      Text(
                        'Processing...',
                        style: PalmTextStyles.body.copyWith(
                          color: PalmColors.primary,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success icon
                      Container(
                        padding: EdgeInsets.all(PalmSpacings.m),
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          _attendanceStatus == 'in'
                              ? Icons.login
                              : Icons.logout,
                          color: PalmColors.white,
                          size: PalmIcons.size * 3,
                        ),
                      ),
                      SizedBox(height: PalmSpacings.xl),
                      Text(
                        _attendanceStatus == 'in' ? 'Check In' : 'Check Out',
                        style: PalmTextStyles.heading.copyWith(
                          color: statusColor,
                        ),
                      ),
                      SizedBox(height: PalmSpacings.m),
                      Text(
                        'Attendance Type: ${_getAttendanceTypeName()}',
                        style: PalmTextStyles.body.copyWith(
                          color: PalmColors.textNormal,
                        ),
                      ),
                      SizedBox(height: PalmSpacings.s),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: PalmSpacings.xl),
                        child: Text(
                          'Location: ${address.length > 30 ? '${address.substring(0, 30)}...' : address}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
