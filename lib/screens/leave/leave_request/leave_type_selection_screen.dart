import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/date_range_bottom_sheet.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/leave_selected_dates_header.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/leave_type_option_card.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/leave_reason_input.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/leave_approval_workflow.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/leave_success_bottom_sheet.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/leave_warning_bottom_sheet.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/leave/leave_request/widgets/leave_submit_button.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/staff/staff_provder.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/leave/leave_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/loading_widget.dart';
import 'package:palm_ecommerce_mobile_app_2/services/holiday_service.dart';

/// Leave type selection screen that appears after date selection
/// Shows available leave categories with hours/time information
class LeaveTypeSelectionScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const LeaveTypeSelectionScreen({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  State<LeaveTypeSelectionScreen> createState() =>
      _LeaveTypeSelectionScreenState();
}

class _LeaveTypeSelectionScreenState extends State<LeaveTypeSelectionScreen> {
  String? _selectedLeaveType;
  late DateTime _currentStartDate;
  late DateTime _currentEndDate;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentStartDate = widget.startDate;
    _currentEndDate = widget.endDate;
    _loadStaffData();
  }

  /// Load staff data for approval information
  void _loadStaffData() {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    // Fetch staff info if not already loaded
    if (staffProvider.staffInfo == null) {
      staffProvider.getStaffInfo();
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  /// Get supervisor name from staff provider
  String _getSupervisorName(StaffProvider staffProvider) {
    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final supervisor = staffProvider.staffInfo!.data!.supervisor;
      if (supervisor != null) {
        final firstName = supervisor.firstNameEng ?? '';
        final lastName = supervisor.lastNameEng ?? '';
        return '$firstName $lastName'.trim();
      }
    }
    return 'Loading...';
  }

  /// Get manager name from staff provider
  String _getManagerName(StaffProvider staffProvider) {
    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final manager = staffProvider.staffInfo!.data!.manager;
      if (manager != null) {
        final firstName = manager.firstNameEng ?? '';
        final lastName = manager.lastNameEng ?? '';
        return '$firstName $lastName'.trim();
      }
    }
    return 'Loading...';
  }

  /// Get leave balance for Annual leave (convert from hours to days)
  String _getAnnualLeaveBalance(StaffProvider staffProvider) {
    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final balance = staffProvider.staffInfo!.data!.balanceAnnually;
      if (balance != null && balance.isNotEmpty) {
        final balanceHours = double.tryParse(balance) ?? 0.0;
        // Convert hours to days (assuming 8 hours = 1 working day)
        final balanceDays = balanceHours / 8.0;
        return '${balanceDays.toStringAsFixed(1)} days remaining';
      }
    }
    return 'Loading balance...';
  }

  /// Get description for Sick leave (no balance limit)
  String _getSickLeaveDescription(StaffProvider staffProvider) {
    return 'Medical leave (no preset limit)';
  }

  /// Get description for Special leave (no balance limit)
  String _getSpecialLeaveDescription(StaffProvider staffProvider) {
    return 'Special circumstances leave (no preset limit)';
  }

  /// Check if the leave request would result in negative balance
  bool _wouldResultInNegativeBalance(StaffProvider staffProvider) {
    if (_selectedLeaveType != 'Annual') {
      // Sick and Special leave have no preset limits, so no negative balance check needed
      print('Leave type is $_selectedLeaveType - skipping balance check');
      return false;
    }

    // Get current annual leave balance in hours
    if (staffProvider.staffInfo?.state == AsyncValueState.success) {
      final balance = staffProvider.staffInfo!.data!.balanceAnnually;
      if (balance != null && balance.isNotEmpty) {
        final balanceHours = double.tryParse(balance) ?? 0.0;

        // Calculate requested leave days (working days only)
        final holidayAnalysis = HolidayService.analyzeRange(_currentStartDate, _currentEndDate);
        final requestedDays = holidayAnalysis.workingDays.toDouble();
        
        // Convert requested days to hours (8 hours = 1 working day)
        final requestedHours = requestedDays * 8.0;

        // Debug logging
        print('=== BALANCE VALIDATION DEBUG ===');
        print('Leave type: $_selectedLeaveType');
        print('Current balance: $balanceHours hours');
        print('Requested days: $requestedDays working days');
        print('Requested hours: $requestedHours hours');
        print('Remaining balance: ${balanceHours - requestedHours} hours');
        print('Would be negative: ${(balanceHours - requestedHours) < 0}');
        print('================================');

        // Check if request would result in negative balance (compare hours to hours)
        return (balanceHours - requestedHours) < 0;
      } else {
        print('Balance data not available: balance is null or empty');
      }
    } else {
      print('Staff info not loaded or not in success state');
    }

    // If we can't determine balance, assume it's safe
    return false;
  }

  /// Handle leave type selection
  void _onLeaveTypeSelected(String leaveType) {
    setState(() {
      _selectedLeaveType = leaveType;
    });
  }

  /// Handle date edit - reopen date range bottom sheet with animation
  Future<void> _onEditDates() async {
    final result = await DateRangeBottomSheet.showWithAnimation(
      context,
      initialStartDate: _currentStartDate,
      initialEndDate: _currentEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (result != null) {
      setState(() {
        _currentStartDate = result['startDate']!;
        _currentEndDate = result['endDate']!;
      });
    }
  }

  /// Handle continue button press
  Future<void> _onContinue() async {
    if (_selectedLeaveType != null) {
      // Check if reason is provided when submitting
      if (_reasonController.text.trim().isEmpty) {
        // Show snackbar to remind user to provide reason
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: PalmColors.white,
                  size: 20,
                ),
                const SizedBox(width: PalmSpacings.s),
                Text(
                  'Please provide a reason for your leave request',
                  style: PalmTextStyles.body.copyWith(
                    color: PalmColors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: PalmColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PalmSpacings.s),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Check if leave request would result in negative balance
      final staffProvider = Provider.of<StaffProvider>(context, listen: false);
      if (_wouldResultInNegativeBalance(staffProvider)) {
        // Show warning bottom sheet for negative balance
        _showWarningBottomSheet();
      } else {
        // Proceed with normal submission
        await _submitLeaveRequest();
      }
    }
  }

  /// Submit leave request using LeaveProvider
  Future<void> _submitLeaveRequest() async {
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);

    // Convert selected leave type to enum
    LeaveType leaveType;
    switch (_selectedLeaveType!.toLowerCase()) {
      case 'annual':
        leaveType = LeaveType.annual;
        break;
      case 'sick':
        leaveType = LeaveType.sick;
        break;
      case 'special':
        leaveType = LeaveType.special;
        break;
      default:
        leaveType = LeaveType.annual;
    }

    // Get holiday analysis for the selected date range
    final holidayAnalysis = HolidayService.analyzeRange(_currentStartDate, _currentEndDate);

    // Create submit leave request object
    final submitRequest = SubmitLeaveRequest(
      leaveType: leaveType,
      startDate: _currentStartDate
          .toIso8601String()
          .split('T')[0], // YYYY-MM-DD format
      endDate:
          _currentEndDate.toIso8601String().split('T')[0], // YYYY-MM-DD format
      reason: _reasonController.text.trim(),
    );

    // Log holiday analysis for debugging
    print('Leave request holiday analysis:');
    print('Total days: ${holidayAnalysis.totalDays}');
    print('Working days: ${holidayAnalysis.workingDays}');
    print('Holiday days: ${holidayAnalysis.holidayDays}');
    print('Holidays: ${holidayAnalysis.getHolidayNames()}');

    // Submit the request
    await leaveProvider.submitLeaveRequest(submitRequest);

    // Handle response
    if (mounted) {
      if (leaveProvider.submitLeaveStatus?.state == AsyncValueState.success) {
        // Clear the submit status to reset the provider state
        leaveProvider.clearSubmitStatus();

        // Show success bottom sheet modal
        if (mounted) {
          _showSuccessBottomSheet();
        }
      } else if (leaveProvider.submitLeaveStatus?.state ==
          AsyncValueState.error) {
        // Clear the submit status to reset the provider state
        leaveProvider.clearSubmitStatus();

        // Show error message
        final errorMessage =
            leaveProvider.submitLeaveStatus?.error?.toString() ??
                'Failed to submit leave request. Please try again.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_outlined,
                  color: PalmColors.white,
                  size: 20,
                ),
                const SizedBox(width: PalmSpacings.s),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: PalmTextStyles.body.copyWith(
                      color: PalmColors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: PalmColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PalmSpacings.s),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Show success bottom sheet modal
  void _showSuccessBottomSheet() {
    LeaveSuccessBottomSheet.show(
      context,
      onSoundsGood: () {
        Navigator.of(context).pop(); // Close bottom sheet
        Navigator.of(context)
            .popUntil((route) => route.isFirst); // Go back to main app
      },
    );
  }

  /// Show warning bottom sheet when leave request would result in negative balance
  void _showWarningBottomSheet() {
    LeaveWarningBottomSheet.show(
      context,
      onSendRequest: () {
        Navigator.of(context).pop(); // Close warning bottom sheet
        _submitLeaveRequest(); // Proceed with submission
      },
      onCancel: () {
        Navigator.of(context).pop(); // Close warning bottom sheet
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StaffProvider, LeaveProvider>(
      builder: (context, staffProvider, leaveProvider, child) {
        final canContinue = _selectedLeaveType != null &&
            _reasonController.text.trim().isNotEmpty;
        final isSubmitting =
            leaveProvider.submitLeaveStatus?.state == AsyncValueState.loading;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: PalmColors.white,
              appBar: AppBar(
                backgroundColor: PalmColors.white,
                elevation: 0,
                leading: TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: PalmTextStyles.body.copyWith(
                      color: isSubmitting
                          ? PalmColors.greyLight
                          : PalmColors.textLight,
                    ),
                  ),
                ),
                title: Text(
                  'New Request',
                  style: PalmTextStyles.title.copyWith(
                    color: PalmColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                centerTitle: true,
                leadingWidth: 80,
              ),
              body: Column(
                children: [
                  // Main content with single scroll view
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(PalmSpacings.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Selected dates header (now part of scroll content)
                          LeaveSelectedDatesHeader(
                            startDate: _currentStartDate,
                            endDate: _currentEndDate,
                            onEditTap: _onEditDates,
                          ),

                          const SizedBox(height: PalmSpacings.m),

                          // Section title
                          Text(
                            'SELECT LEAVE TYPE',
                            style: PalmTextStyles.label.copyWith(
                              color: PalmColors.textLight,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: PalmSpacings.m),

                          // Leave type options
                          LeaveTypeOptionCard(
                            title: 'Annual',
                            subtitle: _getAnnualLeaveBalance(staffProvider),
                            icon: Icons.beach_access,
                            iconColor: PalmColors.primary,
                            isSelected: _selectedLeaveType == 'Annual',
                            onTap: () => _onLeaveTypeSelected('Annual'),
                          ),
                          LeaveTypeOptionCard(
                            title: 'Sick',
                            subtitle: _getSickLeaveDescription(staffProvider),
                            icon: Icons.local_hospital,
                            iconColor: PalmColors.primary,
                            isSelected: _selectedLeaveType == 'Sick',
                            onTap: () => _onLeaveTypeSelected('Sick'),
                          ),
                          LeaveTypeOptionCard(
                            title: 'Special',
                            subtitle:
                                _getSpecialLeaveDescription(staffProvider),
                            icon: Icons.star,
                            iconColor: PalmColors.primary,
                            isSelected: _selectedLeaveType == 'Special',
                            onTap: () => _onLeaveTypeSelected('Special'),
                          ),

                          // Show reason input when leave type is selected
                          if (_selectedLeaveType != null) ...[
                            const SizedBox(height: PalmSpacings.xl),
                            LeaveReasonInput(
                              controller: _reasonController,
                              showValidationError: _selectedLeaveType != null &&
                                  _reasonController.text.trim().isEmpty,
                              onChanged: (value) {
                                setState(
                                    () {}); // Rebuild to update continue button state
                              },
                              onFieldSubmitted: () {
                                // Dismiss keyboard when user presses enter/done
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            const SizedBox(height: PalmSpacings.xl),
                            LeaveApprovalWorkflow(
                              supervisorName: _getSupervisorName(staffProvider),
                              managerName: _getManagerName(staffProvider),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Bottom continue button
                  LeaveSubmitButton(
                    canContinue: canContinue,
                    isSubmitting: isSubmitting,
                    hasSelectedLeaveType: _selectedLeaveType != null,
                    onPressed: _onContinue,
                  ),
                ],
              ),
            ),

            // Full screen loading overlay using your LoadingWidget
            if (isSubmitting)
              Container(
                color: PalmColors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const LoadingWidget(),
                      const SizedBox(height: PalmSpacings.l),
                      Text(
                        'Submitting your leave request...',
                        style: PalmTextStyles.body.copyWith(
                          color: PalmColors.textNormal,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
