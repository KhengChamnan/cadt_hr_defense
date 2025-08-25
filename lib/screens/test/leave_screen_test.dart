// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:palm_ecommerce_mobile_app_2/data/dummydata/leave_info.dart';
// import 'package:palm_ecommerce_mobile_app_2/models/leaves/leaves.dart';
// import 'package:palm_ecommerce_mobile_app_2/providers/leave/leave_provider.dart';
// import 'package:palm_ecommerce_mobile_app_2/providers/profile_provider.dart';
// import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
// import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
// import 'package:palm_ecommerce_mobile_app_2/utils/notification_util.dart';
// import 'package:palm_ecommerce_mobile_app_2/widgets/actions/palm_button.dart';

// /// This screen allows users to:
// /// - Create and submit new leave requests
// /// - Fill in leave details using a form
// /// - Staff ID is automatically handled by the system
// class LeaveFormScreen extends StatefulWidget {
//   const LeaveFormScreen({super.key});

//   @override
//   State<LeaveFormScreen> createState() => _LeaveFormScreenState();
// }

// class _LeaveFormScreenState extends State<LeaveFormScreen> {
//   final _formKey = GlobalKey<FormState>();
  
//   // Form controllers
//   final TextEditingController _typeLeaveIdController = TextEditingController();
//   final TextEditingController _numberOfDayController = TextEditingController();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _startTimeController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   final TextEditingController _endTimeController = TextEditingController();
//   final TextEditingController _requestByController = TextEditingController();
//   final TextEditingController _certifierController = TextEditingController();
//   final TextEditingController _authorizerController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _inputterController = TextEditingController();
//   final TextEditingController _bookingDateController = TextEditingController();
//   final TextEditingController _numberOfHourController = TextEditingController();
//   final TextEditingController _numberOfMinuteController = TextEditingController();
//   final TextEditingController _stdWorkingPerDayController = TextEditingController();

//   // Form state
//   DateTime? _selectedStartDate;
//   DateTime? _selectedEndDate;
//   DateTime? _selectedBookingDate;
//   TimeOfDay? _selectedStartTime;
//   TimeOfDay? _selectedEndTime;
//   String _selectedLeaveType = leaveTypes[0]; // Using first leave type from dummy data

//   // Services and utilities
//   final NotificationUtil _notificationUtil = NotificationUtil();

//   /// Validate numeric input fields
//   String? _validateNumericField(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please enter $fieldName';
//     }
    
//     final parsed = int.tryParse(value.trim());
//     if (parsed == null) {
//       return '$fieldName must be a valid number';
//     }
    
//     if (parsed < 0) {
//       return '$fieldName must be a positive number';
//     }
    
//     return null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeFormDefaults();
//     _loadProfileData();
    
//     // Add listener to standard working hours field
//     _stdWorkingPerDayController.addListener(() {
//       _calculateTotalHoursAndMinutes();
//     });
//   }

//   /// Load profile data and update form fields
//   void _loadProfileData() {
//     final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    
//     // Fetch profile info if not already loaded
//     if (profileProvider.profileInfo == null) {
//       profileProvider.getProfileInfo();
//     }
//   }

//   @override
//   void dispose() {
//     _typeLeaveIdController.dispose();
//     _numberOfDayController.dispose();
//     _startDateController.dispose();
//     _startTimeController.dispose();
//     _endDateController.dispose();
//     _endTimeController.dispose();
//     _requestByController.dispose();
//     _certifierController.dispose();
//     _authorizerController.dispose();
//     _descriptionController.dispose();
//     _inputterController.dispose();
//     _bookingDateController.dispose();
//     _numberOfHourController.dispose();
//     _numberOfMinuteController.dispose();
//     _stdWorkingPerDayController.dispose();
//     super.dispose();
//   }

//   /// Initialize form with default values
//   void _initializeFormDefaults() {
//     _selectedStartDate = DateTime.now();
//     _selectedEndDate = DateTime.now().add(const Duration(days: 1));
//     _selectedBookingDate = DateTime.now();
//     _selectedStartTime = const TimeOfDay(hour: 8, minute: 0);
//     _selectedEndTime = const TimeOfDay(hour: 17, minute: 0);
    
//     // Set default values
//     _typeLeaveIdController.text = 'LV001';
//     _numberOfDayController.text = '2';
//     _startDateController.text = _formatDate(_selectedStartDate!);
//     _startTimeController.text = _formatTime(_selectedStartTime!);
//     _endDateController.text = _formatDate(_selectedEndDate!);
//     _endTimeController.text = _formatTime(_selectedEndTime!);
//     // _requestByController will be set when profile loads
//     _certifierController.text = 'MANAGER01';
//     _authorizerController.text = 'HR001';
//     _descriptionController.text = 'Taking annual leave for vacation';
//     _inputterController.text = 'staff';
//     _bookingDateController.text = _formatDate(_selectedBookingDate!);
//     _stdWorkingPerDayController.text = '8';
    
//     // Calculate initial hours and minutes based on dates and times
//     _calculateTotalHoursAndMinutes();
//   }

//   /// Update form fields with profile data
//   void _updateFormWithProfile(String profileName) {
//     _requestByController.text = profileName;
//     _inputterController.text = profileName;
//   }

//   /// Format date for display
//   String _formatDate(DateTime date) {
//     return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
//   }

//   /// Format time for display
//   String _formatTime(TimeOfDay time) {
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
//   }

//   /// Show date picker
//   Future<void> _selectDate(BuildContext context, {required bool isStartDate, bool isBookingDate = false}) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isBookingDate 
//           ? _selectedBookingDate ?? DateTime.now()
//           : isStartDate 
//               ? _selectedStartDate ?? DateTime.now()
//               : _selectedEndDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
    
//     if (picked != null) {
//       setState(() {
//         if (isBookingDate) {
//           _selectedBookingDate = picked;
//           _bookingDateController.text = _formatDate(picked);
//         } else if (isStartDate) {
//           _selectedStartDate = picked;
//           _startDateController.text = _formatDate(picked);
//           _calculateDays();
//         } else {
//           _selectedEndDate = picked;
//           _endDateController.text = _formatDate(picked);
//           _calculateDays();
//         }
//       });
//     }
//   }

//   /// Show time picker
//   Future<void> _selectTime(BuildContext context, {required bool isStartTime}) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: isStartTime 
//           ? _selectedStartTime ?? const TimeOfDay(hour: 8, minute: 0)
//           : _selectedEndTime ?? const TimeOfDay(hour: 17, minute: 0),
//     );
    
//     if (picked != null) {
//       setState(() {
//         if (isStartTime) {
//           _selectedStartTime = picked;
//           _startTimeController.text = _formatTime(picked);
//         } else {
//           _selectedEndTime = picked;
//           _endTimeController.text = _formatTime(picked);
//         }
//         _calculateHours();
//       });
//     }
//   }

//   /// Calculate number of days automatically
//   void _calculateDays() {
//     if (_selectedStartDate != null && _selectedEndDate != null) {
//       final days = _selectedEndDate!.difference(_selectedStartDate!).inDays + 1;
//       _numberOfDayController.text = days.toString();
      
//       // Also calculate total hours and minutes based on leave duration
//       _calculateTotalHoursAndMinutes();
//     }
//   }

//   /// Calculate number of hours automatically based on daily time difference
//   void _calculateHours() {
//     if (_selectedStartTime != null && _selectedEndTime != null) {
//       final startMinutes = _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
//       final endMinutes = _selectedEndTime!.hour * 60 + _selectedEndTime!.minute;
//       final totalMinutes = endMinutes - startMinutes;
      
//       if (totalMinutes > 0) {
//         final hours = totalMinutes ~/ 60;
//         final minutes = totalMinutes % 60;
//         _numberOfHourController.text = hours.toString();
//         _numberOfMinuteController.text = minutes.toString();
//       }
      
//       // Also calculate total hours based on leave duration
//       _calculateTotalHoursAndMinutes();
//     }
//   }

//   /// Calculate total hours and minutes based on leave duration
//   void _calculateTotalHoursAndMinutes() {
//     if (_selectedStartDate != null && _selectedEndDate != null && 
//         _selectedStartTime != null && _selectedEndTime != null) {
      
//       // Get standard working hours per day
//       final standardHours = int.tryParse(_stdWorkingPerDayController.text) ?? 8;
      
//       // Calculate total days
//       final totalDays = _selectedEndDate!.difference(_selectedStartDate!).inDays + 1;
      
//       // Calculate daily working minutes
//       final startMinutes = _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
//       final endMinutes = _selectedEndTime!.hour * 60 + _selectedEndTime!.minute;
//       final dailyWorkingMinutes = endMinutes - startMinutes;
      
//       if (dailyWorkingMinutes > 0) {
//         // Method 1: Calculate based on actual daily hours × number of days
//         final totalMinutes = dailyWorkingMinutes * totalDays;
        
//         // Method 2: Alternative - Calculate based on standard working hours × number of days
//         // final totalMinutes = standardHours * 60 * totalDays;
        
//         final hours = totalMinutes ~/ 60;
//         final minutes = totalMinutes % 60;
        
//         _numberOfHourController.text = hours.toString();
//         _numberOfMinuteController.text = minutes.toString();
//       } else {
//         // Fallback: Use standard working hours
//         final totalMinutes = standardHours * 60 * totalDays;
//         final hours = totalMinutes ~/ 60;
//         final minutes = totalMinutes % 60;
        
//         _numberOfHourController.text = hours.toString();
//         _numberOfMinuteController.text = minutes.toString();
//       }
//     }
//   }

//   /// Submit the leave request
//   Future<void> _submitLeaveRequest() async {
//     if (!_formKey.currentState!.validate()) {
//       _notificationUtil.showError(context, 'Please fill in all required fields');
//       return;
//     }

//     final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    
//     try {
//       // Helper function to safely parse string to int
//       int? safeParseInt(String value) {
//         final trimmed = value.trim();
//         if (trimmed.isEmpty) return null;
//         return int.tryParse(trimmed);
//       }

//       // Create Leave object with validated numeric values
//       final leave = Leave(
//         // staffId will be automatically set by the repository
//         typeLeaveId: _typeLeaveIdController.text,
//         numberOfDay: safeParseInt(_numberOfDayController.text),
//         startDate: _startDateController.text,
//         startTime: _startTimeController.text,
//         endDate: _endDateController.text,
//         endTime: _endTimeController.text,
//         requestBy: _requestByController.text,
//         certifier: _certifierController.text,
//         authorizer: _authorizerController.text,
//         description: _descriptionController.text,
//         inputter: _inputterController.text,
//         bookingDate: _bookingDateController.text,
//         numberOfHour: safeParseInt(_numberOfHourController.text),
//         numberOfMinute: safeParseInt(_numberOfMinuteController.text),
//         stdWorkingPerDay: safeParseInt(_stdWorkingPerDayController.text),
//       );

//       // Submit leave request
//       await leaveProvider.submitLeave(leave);
      
//       // Show success message
//       _notificationUtil.showSuccess(context, 'Leave request submitted successfully!');
      
//       // Navigate back or refresh data
      
//     } catch (e) {
//       // Show detailed error message
//       print('Error submitting leave: $e');
//       _notificationUtil.showError(context, 'Failed to submit leave request: ${e.toString()}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: PalmColors.white,
//       appBar: AppBar(
//         title: Text(
//           'Leave Request Form',
//           style: PalmTextStyles.title.copyWith(color: Colors.white),
//         ),
//         backgroundColor: PalmColors.primary,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Consumer2<LeaveProvider, ProfileProvider>(
//         builder: (context, leaveProvider, profileProvider, child) {
//           // Update form with profile data when available
//           if (profileProvider.profileInfo?.state == AsyncValueState.success) {
//             final profileName = profileProvider.profileInfo!.data!.name;
//             if (_requestByController.text.isEmpty || _requestByController.text == 'EMP001') {
//               _updateFormWithProfile(profileName);
//             }
//           }
          
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(PalmSpacings.m),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header note
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(PalmSpacings.m),
//                     decoration: BoxDecoration(
//                       color: PalmColors.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(PalmSpacings.radius),
//                       border: Border.all(color: PalmColors.primary.withOpacity(0.2)),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Leave Request Form',
//                           style: PalmTextStyles.title.copyWith(
//                             color: PalmColors.primary,
//                           ),
//                         ),
//                         const SizedBox(height: PalmSpacings.s),
//                         Text(
//                           'Note: Staff ID will be automatically filled from your profile.',
//                           style: PalmTextStyles.label.copyWith(
//                             color: PalmColors.textLight,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.l),
                  
//                   // Leave Details Section
//                   Text(
//                     'Leave Details',
//                     style: PalmTextStyles.title,
//                   ),
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Leave Type Dropdown
//                   _buildDropdownField(
//                     label: 'Type of Leave',
//                     value: _selectedLeaveType,
//                     items: leaveTypes,
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedLeaveType = value!;
//                         _typeLeaveIdController.text = value == 'Annual Leave' ? 'LV001' : 'LV002';
//                       });
//                     },
//                     validator: (value) => value == null ? 'Please select leave type' : null,
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Number of Days
//                   _buildTextFormField(
//                     controller: _numberOfDayController,
//                     label: 'Number of Days',
//                     keyboardType: TextInputType.number,
//                     validator: (value) => _validateNumericField(value, 'number of days'),
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Start Date and Time
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDateField(
//                           controller: _startDateController,
//                           label: 'Start Date',
//                           onTap: () => _selectDate(context, isStartDate: true),
//                         ),
//                       ),
//                       const SizedBox(width: PalmSpacings.m),
//                       Expanded(
//                         child: _buildTimeField(
//                           controller: _startTimeController,
//                           label: 'Start Time',
//                           onTap: () => _selectTime(context, isStartTime: true),
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // End Date and Time
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildDateField(
//                           controller: _endDateController,
//                           label: 'End Date',
//                           onTap: () => _selectDate(context, isStartDate: false),
//                         ),
//                       ),
//                       const SizedBox(width: PalmSpacings.m),
//                       Expanded(
//                         child: _buildTimeField(
//                           controller: _endTimeController,
//                           label: 'End Time',
//                           onTap: () => _selectTime(context, isStartTime: false),
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Request By (Auto-filled from profile)
//                   Consumer<ProfileProvider>(
//                     builder: (context, profileProvider, child) {
//                       bool isLoading = false;
                      
//                       if (profileProvider.profileInfo?.state == AsyncValueState.loading) {
//                         isLoading = true;
//                       }
                      
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           _buildTextFormField(
//                             controller: _requestByController,
//                             label: 'Request By (Auto-filled from profile)',
//                             validator: (value) => value?.isEmpty ?? true ? 'Please enter requester name' : null,
//                           ),
//                           if (isLoading) 
//                             Padding(
//                               padding: const EdgeInsets.only(top: PalmSpacings.s),
//                               child: Text(
//                                 'Loading profile...',
//                                 style: PalmTextStyles.label.copyWith(
//                                   color: PalmColors.textLight,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Certifier
//                   _buildTextFormField(
//                     controller: _certifierController,
//                     label: 'Certifier',
//                     validator: (value) => value?.isEmpty ?? true ? 'Please enter certifier ID' : null,
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Authorizer
//                   _buildTextFormField(
//                     controller: _authorizerController,
//                     label: 'Authorizer',
//                     validator: (value) => value?.isEmpty ?? true ? 'Please enter authorizer ID' : null,
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Description
//                   _buildTextFormField(
//                     controller: _descriptionController,
//                     label: 'Description',
//                     maxLines: 3,
//                     validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Inputter
//                   _buildTextFormField(
//                     controller: _inputterController,
//                     label: 'Inputter',
//                     validator: (value) => value?.isEmpty ?? true ? 'Please enter inputter' : null,
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Booking Date
//                   _buildDateField(
//                     controller: _bookingDateController,
//                     label: 'Booking Date',
//                     onTap: () => _selectDate(context, isStartDate: false, isBookingDate: true),
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Working Hours Section
//                   Text(
//                     'Working Hours (Auto-calculated)',
//                     style: PalmTextStyles.title,
//                   ),
//                   const SizedBox(height: PalmSpacings.s),
//                   Text(
//                     'These values are automatically calculated based on your leave duration and daily working hours.',
//                     style: PalmTextStyles.label.copyWith(
//                       color: PalmColors.textLight,
//                     ),
//                   ),
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Number of Hours and Minutes
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildTextFormField(
//                           controller: _numberOfHourController,
//                           label: 'Total Hours',
//                           keyboardType: TextInputType.number,
//                           validator: (value) => _validateNumericField(value, 'total hours'),
//                         ),
//                       ),
//                       const SizedBox(width: PalmSpacings.m),
//                       Expanded(
//                         child: _buildTextFormField(
//                           controller: _numberOfMinuteController,
//                           label: 'Total Minutes',
//                           keyboardType: TextInputType.number,
//                           validator: (value) => _validateNumericField(value, 'total minutes'),
//                         ),
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.m),
                  
//                   // Standard Working Per Day
//                   _buildTextFormField(
//                     controller: _stdWorkingPerDayController,
//                     label: 'Standard Working Hours Per Day',
//                     keyboardType: TextInputType.number,
//                     validator: (value) => _validateNumericField(value, 'standard working hours'),
//                   ),
                  
//                   const SizedBox(height: PalmSpacings.xl),
                  
//                   // Submit Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: PalmButton(
//                       text: leaveProvider.postLeaveStatus?.state == AsyncValueState.loading
//                           ? 'Submitting...'
//                           : 'Submit Leave Request',
//                       onPressed: leaveProvider.postLeaveStatus?.state == AsyncValueState.loading
//                           ? null
//                           : _submitLeaveRequest,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   /// Build text form field
//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: PalmTextStyles.label,
//         ),
//         const SizedBox(height: PalmSpacings.s),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           maxLines: maxLines,
//           validator: validator,
//           decoration: InputDecoration(
//             hintText: 'Enter $label',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.greyLight),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.greyLight),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.primary),
//             ),
//             contentPadding: const EdgeInsets.all(PalmSpacings.m),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Build dropdown field
//   Widget _buildDropdownField({
//     required String label,
//     required String value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//     String? Function(String?)? validator,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: PalmTextStyles.label,
//         ),
//         const SizedBox(height: PalmSpacings.s),
//         DropdownButtonFormField<String>(
//           value: value,
//           onChanged: onChanged,
//           validator: validator,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.greyLight),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.greyLight),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.primary),
//             ),
//             contentPadding: const EdgeInsets.all(PalmSpacings.m),
//           ),
//           items: items.map((String item) {
//             return DropdownMenuItem<String>(
//               value: item,
//               child: Text(item),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   /// Build date field
//   Widget _buildDateField({
//     required TextEditingController controller,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: PalmTextStyles.label,
//         ),
//         const SizedBox(height: PalmSpacings.s),
//         TextFormField(
//           controller: controller,
//           readOnly: true,
//           onTap: onTap,
//           decoration: InputDecoration(
//             hintText: 'Select $label',
//             suffixIcon: Icon(Icons.calendar_today, color: PalmColors.primary),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.greyLight),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.greyLight),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.primary),
//             ),
//             contentPadding: const EdgeInsets.all(PalmSpacings.m),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Build time field
//   Widget _buildTimeField({
//     required TextEditingController controller,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: PalmTextStyles.label,
//         ),
//         const SizedBox(height: PalmSpacings.s),
//         TextFormField(
//           controller: controller,
//           readOnly: true,
//           onTap: onTap,
//           decoration: InputDecoration(
//             hintText: 'Select $label',
//             suffixIcon: Icon(Icons.access_time, color: PalmColors.primary),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.greyLight),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.greyLight),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(PalmSpacings.radius),
//               borderSide: BorderSide(color: PalmColors.primary),
//             ),
//             contentPadding: const EdgeInsets.all(PalmSpacings.m),
//           ),
//         ),
//       ],
//     );
//   }
// }
