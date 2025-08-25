# Leave List Tile Widget

This directory contains the `LeaveListTile` widget that displays leave request information in a card-style format based on the Figma design.

## Files

- `leave_list_tile.dart` - The main widget component
- `leave_list_example.dart` - Example usage of the widget
- `leave_request.dart` (in model/leave/) - Data model for leave requests

## Features

- **Card-style design** with header and content sections
- **Status indicators** with color-coded badges
- **Approval workflow** showing certified by and approved by sections
- **Avatar support** for approvers
- **Responsive layout** that matches the Figma design
- **Tap handling** for navigation to details

## Usage

```dart
import 'package:palm_ecommerce_mobile_app_2/model/leave/leave_request.dart';
import 'widgets/leave_list_tile.dart';

// Create a leave request
final leaveRequest = LeaveRequest(
  id: '1',
  date: '6 Jun 2025',
  status: 'Pending',
  leaveType: 'Annual leave',
  reason: 'Have personal issues and busy with family...!',
  dateRange: 'Mon/23/6/2025 - Mon/23/6/2025',
  duration: '1 Days',
  certifiedBy: 'Denial',
  approvedBy: 'Caesar',
  certifiedStatus: 'Pending',
  approvedStatus: 'Pending',
  createdAt: DateTime.now(),
);

// Use the widget
LeaveListTile(
  leaveRequest: leaveRequest,
  onTap: () {
    // Handle tap
  },
)
```

## Design Elements

The widget follows the Figma design with:

- **Header section**: Blue background with date and status badge
- **Content section**: White background with leave details
- **Icons**: Calendar, category, and comment icons
- **Status badges**: Color-coded based on status (Pending, Approved, Rejected)
- **Avatar circles**: For approvers with shadow effects
- **Typography**: Roboto and Inter font families as specified

## Integration

The widget has been integrated into the `LeaveOverviewScreen` and will display in all tab views (All Leaves, Pending, Rejected, Cancelled) based on the filtered data.
