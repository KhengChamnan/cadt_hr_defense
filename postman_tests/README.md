# Laravel Leave API - Postman Tests Documentation

## Overview
This Postman collection provides comprehensive testing for the Laravel Leave API endpoints based on the Flutter app's `LaravelLeaveRepository` implementation.

## Test Structure

### 1. Authentication Tests
- **Login**: Authenticates user and stores Bearer token
- **Unauthorized Access**: Tests access without token
- **Invalid Token**: Tests access with invalid token

### 2. User Info Tests
- **Get User Info**: Retrieves user profile data including `staff_id`
- Validates the response structure matches what the Flutter app expects
- Automatically extracts and stores `staff_id` for leave requests

### 3. Leave Management Tests
- **Get All Leaves**: Retrieves all leave requests
- **Create Valid Leave**: Creates a valid leave request
- **Invalid Requests**: Tests various error scenarios
- **Edge Cases**: Tests boundary conditions

### 4. Edge Case Tests
- Zero-day leave requests (hour-based)
- Large data handling
- Invalid date ranges

## API Endpoints Tested

Based on your Flutter `LaravelLeaveRepository`:

```dart
// Endpoints from ApiEndpoints class
- POST /api/login                  // Authentication
- GET  /api/user-info             // Get user profile with staff_id
- GET  /api/leave_requests/       // Get all leaves
- POST /api/leave_requests/       // Create new leave request
```

## Request/Response Validation

### Authentication Flow
1. **Login Request**:
   ```json
   {
     "email": "test@example.com",
     "password": "password123"
   }
   ```

2. **Expected Response**:
   ```json
   {
     "token": "bearer_token_here",
     "user": { /* user data */ }
   }
   ```

### User Info Request
- **Headers**: `Authorization: Bearer {token}`
- **Expected Response Structure**:
   ```json
   {
     "data": {
       "profile_staff": {
         "staff_id": "STAFF001",
         "full_name": "John Doe",
         "email": "john@example.com",
         "position_id": "DEV001",
         "phone1": "+1234567890"
       }
     }
   }
   ```

### Leave Request Structure
Based on your `LeaveDto.toJson()` method:

```json
{
  "StaffID": "STAFF001",
  "TypeLeaveID": "1",
  "NumberOfDay": 2,
  "StartDate": "2025-07-20",
  "StartTime": "08:00:00",
  "EndDate": "2025-07-22",
  "EndTime": "17:00:00",
  "RequestBy": "STAFF001",
  "Certifier": "MANAGER001",
  "Authorizer": "HR001",
  "Description": "Annual vacation leave",
  "Inputter": "STAFF001",
  "BookingDate": "2025-07-17",
  "NumberOfHour": 16,
  "NumberOfMinute": 0,
  "StdWorkingPerDay": 8
}
```

## Test Scenarios

### Success Cases
1. **Valid Leave Request**: Complete request with all required fields
2. **Hour-based Leave**: Zero-day leave with specific hours
3. **Multiple Day Leave**: Extended vacation request

### Error Cases
1. **Missing Fields**: Request with incomplete data
2. **Invalid Dates**: End date before start date
3. **Authentication Errors**: Missing or invalid tokens
4. **Large Data**: Oversized description fields

### Repository Logic Validation
Tests validate the same logic as your Flutter repository:

```dart
// Success condition from your repository
if (responseData.containsKey('data') || responseData.containsKey('success')) {
  // Success - just return (void)
  return;
} else {
  // Backend returned 200 but it's actually an error
  throw Exception(responseData['message'] ?? 'Leave request failed');
}
```

## Environment Variables

### Required Setup
Update these in the Postman environment:

```json
{
  "base_url": "https://your-actual-api-domain.com",
  "auth_token": "",  // Auto-populated by login
  "staff_id": "",    // Auto-populated by user info
  "start_date": "",  // Auto-calculated
  "end_date": "",    // Auto-calculated
  "booking_date": "" // Auto-calculated
}
```

### Auto-Generated Variables
The collection automatically generates:
- Future dates for leave requests (7-9 days from now)
- Current date for booking
- Extracts staff_id from user info response

## Test Assertions

### Response Validation
Each test includes assertions for:
- **Status Codes**: Validates HTTP response codes
- **Response Structure**: Ensures expected JSON structure
- **Data Validation**: Checks required fields presence
- **Performance**: Response time thresholds
- **Content Type**: Validates JSON responses

### Authentication Flow
```javascript
// Token extraction and storage
if (jsonData.token) {
    pm.collectionVariables.set('auth_token', jsonData.token);
}

// Staff ID extraction
if (jsonData.data.profile_staff && jsonData.data.profile_staff.staff_id) {
    pm.collectionVariables.set('staff_id', jsonData.data.profile_staff.staff_id);
}
```

## Error Handling Tests

### Repository Error Patterns
Tests match your repository's error handling:

1. **Authentication Errors**:
   ```dart
   if (userToken == null || userToken.isEmpty) {
     throw Exception("Invalid or missing authentication token");
   }
   ```

2. **Response Validation**:
   ```dart
   if (response.statusCode == 200) {
     // Check for success indicators
   } else {
     throw Exception('HTTP Error: ${response.statusCode}');
   }
   ```

3. **Data Validation**:
   ```dart
   if (responseData.containsKey('data') && responseData['data'] is List) {
     return LeaveDto.parseLeaveList(responseData);
   }
   ```

## Running the Tests

### Prerequisites
1. Import both files into Postman:
   - `Laravel_Leave_API_Tests.postman_collection.json`
   - `Laravel_Leave_API_Environment.postman_environment.json`

2. Update environment variables:
   - Set `base_url` to your actual API domain
   - Ensure your API is running and accessible

### Test Execution Order
1. **Authentication** → Login (sets auth_token)
2. **User Info** → Get User Info (sets staff_id)
3. **Leave Management** → All leave operations
4. **Edge Cases** → Boundary testing

### Expected Results
- **Green Tests**: All assertions pass
- **Failed Tests**: Check API implementation
- **Performance**: Response times under thresholds

## Integration Notes

### Flutter App Compatibility
Tests ensure responses work with your Flutter DTOs:
- `UserDto.fromApiResponseForLeaves()`
- `LeaveDto.parseLeaveList()`
- `LeaveDto.toJson()`

### API Endpoint Consistency
All endpoints match your `ApiEndpoints` class:
- Authentication: `/api/login`
- User Info: `/api/user-info`
- Leaves: `/api/leave_requests/`

This test suite comprehensively validates your Laravel Leave API according to the exact patterns and expectations defined in your Flutter repository implementation.
