import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:palm_ecommerce_mobile_app_2/models/attendance/attendance.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/attendance/attendance_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/routes.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/location_management.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/bottom_navigator.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/error_handler.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/auto_dismiss_dialog.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
    _initializeAttendance();
  }

  Future<void> _initializeAttendance() async {
    try {
      // Get location
      await _getLocationData();
      
      // Determine status (in/out) based on latest attendance record
      await _determineAttendanceStatus();
      
      // Initialize attendance data
      attendanceData = Attendance(
        attendanceDate: "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
        attendanceTime: "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
        inOut: _attendanceStatus,
        distant: address,
        workTypeId: widget.typeId,
        latitude: double.parse(latitude),
        longitude: double.parse(longitude),
      );

      // Process the attendance immediately
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
      // Fetch the latest attendance records
      await _attendanceProvider.getAttendanceList();
      
      if (_attendanceProvider.attendanceList?.state == AsyncValueState.success) {
        final attendances = _attendanceProvider.attendanceList?.data;
        
        if (attendances != null && attendances.isNotEmpty) {
          // Sort by date and time (descending) to get the latest record
          attendances.sort((a, b) {
            final dateComparison = (b.attendanceDate ?? '').compareTo(a.attendanceDate ?? '');
            if (dateComparison != 0) return dateComparison;
            return (b.attendanceTime ?? '').compareTo(a.attendanceTime ?? '');
          });
          
          // Get the latest record's status
          final latestStatus = attendances.first.inOut;
          
          // Set the current status as the opposite of the latest
          setState(() {
            _attendanceStatus = (latestStatus == 'in') ? 'out' : 'in';
          });
          
          return;
        }
      }
      
      // If no records found or error, default to 'in'
      setState(() {
        _attendanceStatus = 'in';
      });
    } catch (e) {
      // If error, default to 'in'
      setState(() {
        _attendanceStatus = 'in';
      });
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
      await _attendanceProvider.submitAttendance(attendanceData);

      if (_attendanceProvider.postAttendanceStatus?.state == AsyncValueState.success) {
        if (!mounted) return;

        _showSuccessDialog();

      } else if (_attendanceProvider.postAttendanceStatus?.state == AsyncValueState.error) {
        if (!mounted) return;

        final errorData = _attendanceProvider.postAttendanceStatus?.error;
        await ErrorHandler.handleError(
          context: context,
          errorData: errorData,
          duration: const Duration(seconds: 2),
        );
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Success!',
          style: PalmTextStyles.title.copyWith(
            color: _attendanceStatus == 'in' ? PalmColors.success : PalmColors.success,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _attendanceStatus == 'in' 
                ? 'Your check-in has been recorded.'
                : 'Your check-out has been recorded.',
              style: PalmTextStyles.body,
            ),
            SizedBox(height: PalmSpacings.m),
            Row(
              children: [
                Icon(
                  _attendanceStatus == 'in' ? Icons.login : Icons.logout,
                  color: _attendanceStatus == 'in' ? PalmColors.success : PalmColors.success,
                  size: PalmIcons.size,
                ),
                SizedBox(width: PalmSpacings.s / 2),
                Text(
                  _attendanceStatus == 'in' ? 'Check In' : 'Check Out',
                  style: PalmTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _attendanceStatus == 'in' ? PalmColors.success : PalmColors.success,
                  ),
                ),
              ],
            ),
            SizedBox(height: PalmSpacings.s / 2),
            Row(
              children: [
                Icon(Icons.calendar_today, color: PalmColors.neutralLight, size: PalmIcons.size - 2),
                SizedBox(width: PalmSpacings.s / 2),
                Text('Date: ${attendanceData.attendanceDate}', style: PalmTextStyles.label),
              ],
            ),
            SizedBox(height: PalmSpacings.s / 2),
            Row(
              children: [
                Icon(Icons.access_time, color: PalmColors.neutralLight, size: PalmIcons.size - 2),
                SizedBox(width: PalmSpacings.s / 2),
                Text('Time: ${attendanceData.attendanceTime}', style: PalmTextStyles.label),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PalmColors.primary,
              minimumSize: Size(double.infinity, PalmSpacings.xl),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius / 2),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              MyRouter.pushPageReplacement(context, const BottomNavBar());
            },
            child: Text(
              'OK',
              style: PalmTextStyles.button.copyWith(color: PalmColors.white),
            ),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _attendanceStatus == 'in' ? PalmColors.success : PalmColors.primary;
    
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
                      SpinKitCircle(color: PalmColors.primary, size: PalmSpacings.xl * 1.8),
                      SizedBox(height: PalmSpacings.m),
                      Text(
                        _attendanceStatus == 'in' ? 'Processing Check In...' : 'Processing Check Out...',
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
                          _attendanceStatus == 'in' ? Icons.login : Icons.logout,
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
                        padding: EdgeInsets.symmetric(horizontal: PalmSpacings.xl),
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
