# Leave Model API Integration Guide

## Summary of Changes

Your `Leave` model has been updated to handle manager and supervisor information properly for API integration. Instead of storing names, the model now stores their actual staff IDs, which is what your backend expects.

## Key Changes Made

### 1. Field Name Changes
- `certifier` → `certifierId` (stores supervisor's staff ID)
- `authorizer` → `authorizerId` (stores manager's staff ID)
- Names are still available through `certifierName` and `authorizerName`

### 2. New Helper Methods
- `supervisorId` - Gets supervisor's staff ID from staff relationship
- `managerId` - Gets manager's staff ID from staff relationship
- `certifierDisplayName` - Gets certifier name with fallback to staff relationship
- `authorizerDisplayName` - Gets authorizer name with fallback to staff relationship

### 3. New Factory Constructor
- `Leave.forRequest()` - Automatically assigns supervisor and manager IDs when creating leave requests

### 4. API Integration Methods
- `toJson()` - Converts leave to JSON for API requests
- `toJsonCompact()` - Converts to JSON with only non-null values

## How to Use for API Integration

### Creating a Leave Request

```dart
// Assuming you have staff info from your API endpoint
final leaveRequest = Leave.forRequest(
  staffId: staffInfo.staffId,
  staff: staffInfo, // This contains supervisor and manager info
  leaveId: "L${DateTime.now().millisecondsSinceEpoch}",
  leaveType: LeaveType.annual,
  numberOfDay: 3,
  startDate: DateTime(2025, 8, 10),
  endDate: DateTime(2025, 8, 12),
  description: "Family vacation",
  requestBy: staffInfo.staffId,
  requestDate: DateTime.now(),
);
```

### Posting to API

```dart
// Get clean JSON payload for API
final apiPayload = leaveRequest.toJsonCompact();

// POST to your backend
final response = await http.post(
  Uri.parse('your-api-endpoint/leaves'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode(apiPayload),
);
```

### API Payload Example

The `toJsonCompact()` method will generate:

```json
{
  "staff_id": "S001",
  "leave_type": "annual",
  "number_of_day": 3,
  "start_date": "2025-08-10T00:00:00.000",
  "end_date": "2025-08-12T00:00:00.000",
  "description": "Family vacation",
  "request_by": "S001",
  "request_date": "2025-08-07T10:30:00.000",
  "certifier_id": "S169",    // Supervisor ID from your API
  "authorizer_id": "S168",   // Manager ID from your API
  "std_working_per_day": 8,
  "remarks": "Pre-planned vacation"
}
```

## Data Flow

1. **Get User Info**: Call your API endpoint to get staff info including manager and supervisor details
2. **Parse Data**: Extract supervisor StaffID (S169) and manager StaffID (S168) from the response
3. **Create Leave**: Use `Leave.forRequest()` which automatically assigns the correct IDs
4. **Submit**: Use `toJsonCompact()` to get clean JSON for your API
5. **Backend Processing**: Your backend receives proper staff IDs instead of names

## Benefits

✅ **Backend Compatibility**: Sends staff IDs instead of names to your API  
✅ **Automatic Assignment**: Factory constructor handles supervisor/manager ID assignment  
✅ **Clean JSON**: Compact JSON method removes null fields  
✅ **UI Friendly**: Display names still available for user interface  
✅ **Type Safety**: Proper typing with null safety  
✅ **Relationship Aware**: Leverages staff relationships for data consistency  

## Migration Notes

If you have existing code that references the old field names:
- `leave.certifier` → `leave.certifierId`
- `leave.authorizer` → `leave.authorizerId`

For display purposes in UI:
- `leave.certifierDisplayName` (shows supervisor name)
- `leave.authorizerDisplayName` (shows manager name)

This approach ensures your frontend sends the correct data format that your backend expects while maintaining a clean, type-safe model structure.
