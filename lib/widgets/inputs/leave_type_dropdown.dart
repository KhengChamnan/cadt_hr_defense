import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A dropdown widget for selecting leave types
class LeaveTypeDropdown extends StatelessWidget {
  /// The currently selected leave type
  final String value;
  
  /// Callback when the selected leave type changes
  final ValueChanged<String> onChanged;
  
  /// Available leave types to choose from
  final List<String> leaveTypes;

  /// Creates a leave type dropdown widget
  const LeaveTypeDropdown({
    Key? key,
    required this.value,
    required this.onChanged,
    this.leaveTypes = const ['Casual Leave', 'Sick Leave', 'Annual Leave', 'Unpaid Leave'],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type of leave',
          style: PalmTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: leaveTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
} 