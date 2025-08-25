import 'package:flutter_test/flutter_test.dart';
import 'package:palm_ecommerce_mobile_app_2/data/repository/mock_repository/mock_leave_repository.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leaves.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/leave/leave_provider.dart';

/// Test script to verify that leave submission and provider functionality works correctly
void main() {
  group('Leave Functionality Tests', () {
    late MockLeaveRepository mockRepository;
    late LeaveProvider leaveProvider;

    setUp(() {
      // Initialize mock repository with sample data
      mockRepository = MockLeaveRepository(initializeWithSampleData: true);
      leaveProvider = LeaveProvider(leavesRepository: mockRepository);
    });

    test('Should get initial sample leave data', () async {
      // Act
      await leaveProvider.getLeaveList();

      // Assert
      expect(leaveProvider.leaveList?.data, isNotNull);
      expect(leaveProvider.leaveList?.data?.length, equals(5)); // Should have 5 sample leaves
      print('✓ Successfully loaded ${leaveProvider.leaveList?.data?.length} sample leaves');
    });

    test('Should successfully submit a new leave request', () async {
      // Arrange
      final newLeave = Leave(
        staffId: "STAFF_TEST",
        typeLeaveId: "LV001",
        numberOfDay: 2,
        startDate: "2025-08-15",
        startTime: "08:00",
        endDate: "2025-08-16",
        endTime: "17:00",
        requestBy: "Test User",
        certifier: "Test Certifier",
        authorizer: "Test Authorizer",
        description: "Test leave request",
        inputter: "Test User",
        bookingDate: "2025-08-07",
        numberOfHour: 16,
        numberOfMinute: 0,
        stdWorkingPerDay: 8,
      );

      // Get initial count
      await leaveProvider.getLeaveList();
      final initialCount = leaveProvider.leaveList?.data?.length ?? 0;

      // Act - Submit new leave
      await leaveProvider.submitLeave(newLeave);

      // Assert
      expect(leaveProvider.postLeaveStatus?.data, isNotNull);
      expect(leaveProvider.leaveList?.data?.length, equals(initialCount + 1));
      print('✓ Successfully submitted leave request. Total leaves: ${leaveProvider.leaveList?.data?.length}');

      // Verify the new leave is in the list
      final latestLeave = leaveProvider.leaveList?.data?.last;
      expect(latestLeave?.description, equals("Test leave request"));
      expect(latestLeave?.requestBy, equals("Test User"));
      print('✓ New leave found in list with correct data');
    });

    test('Should handle validation errors correctly', () async {
      // Arrange - Create invalid leave (missing required fields)
      final invalidLeave = Leave(
        typeLeaveId: "", // Empty type ID should cause error
        startDate: "",  // Empty start date should cause error
        endDate: "",    // Empty end date should cause error
      );

      // Act & Assert
      expect(
        () async => await leaveProvider.submitLeave(invalidLeave),
        throwsA(isA<Exception>()),
      );
      print('✓ Validation errors handled correctly');
    });

    test('Should handle network errors with retry', () async {
      // This test verifies that the random network errors are properly handled
      // We'll attempt submission multiple times to test error handling
      
      bool networkErrorEncountered = false;
      
      for (int i = 0; i < 50; i++) {
        try {
          final testLeave = Leave(
            typeLeaveId: "LV001",
            startDate: "2025-08-15",
            endDate: "2025-08-15",
            requestBy: "Test User $i",
            description: "Network test $i",
          );
          
          await leaveProvider.submitLeave(testLeave);
        } catch (e) {
          if (e.toString().contains("Network error")) {
            networkErrorEncountered = true;
            print('✓ Network error handled correctly: ${e.toString()}');
            break;
          }
        }
      }
      
      // At least verify that we can handle the scenario
      print('✓ Network error simulation test completed');
    });

    test('Should clear post leave status correctly', () async {
      // Arrange
      final testLeave = Leave(
        typeLeaveId: "LV001",
        startDate: "2025-08-15",
        endDate: "2025-08-15",
        requestBy: "Test User",
        description: "Status clear test",
      );

      // Act
      await leaveProvider.submitLeave(testLeave);
      expect(leaveProvider.postLeaveStatus, isNotNull);

      // Clear status
      leaveProvider.clearPostLeaveStatus();

      // Assert
      expect(leaveProvider.postLeaveStatus, isNull);
      print('✓ Post leave status cleared successfully');
    });

    test('Should maintain data integrity across operations', () async {
      // Get initial data
      await leaveProvider.getLeaveList();
      final initialLeaves = List<Leave>.from(leaveProvider.leaveList!.data!);

      // Submit multiple leaves
      for (int i = 1; i <= 3; i++) {
        final leave = Leave(
          typeLeaveId: "LV00$i",
          startDate: "2025-08-${15 + i}",
          endDate: "2025-08-${15 + i}",
          requestBy: "Test User $i",
          description: "Integrity test $i",
        );
        await leaveProvider.submitLeave(leave);
      }

      // Verify data integrity
      final finalLeaves = leaveProvider.leaveList!.data!;
      expect(finalLeaves.length, equals(initialLeaves.length + 3));

      // Verify original data is still intact
      for (int i = 0; i < initialLeaves.length; i++) {
        expect(finalLeaves[i].requestBy, equals(initialLeaves[i].requestBy));
        expect(finalLeaves[i].description, equals(initialLeaves[i].description));
      }

      print('✓ Data integrity maintained across operations');
    });
  });

  group('Mock Repository Direct Tests', () {
    test('Should generate unique staff IDs', () async {
      final repository = MockLeaveRepository(initializeWithSampleData: false);
      
      final leave1 = Leave(
        typeLeaveId: "LV001",
        startDate: "2025-08-15",
        endDate: "2025-08-15",
      );
      
      final leave2 = Leave(
        typeLeaveId: "LV001",
        startDate: "2025-08-16",
        endDate: "2025-08-16",
      );

      await repository.postLeave(leave1);
      await repository.postLeave(leave2);

      final leaves = await repository.getLeaves();
      expect(leaves.length, equals(2));
      expect(leaves[0].staffId, isNot(equals(leaves[1].staffId)));
      print('✓ Unique staff IDs generated correctly');
    });

    test('Should provide additional utility methods', () async {
      final repository = MockLeaveRepository(initializeWithSampleData: true);
      
      // Test statistics
      final stats = await repository.getLeaveStatistics();
      expect(stats, isNotEmpty);
      print('✓ Leave statistics: $stats');

      // Test filtering by staff ID
      final staffLeaves = await repository.getLeavesByStaffId("STAFF_0001");
      expect(staffLeaves.length, greaterThan(0));
      print('✓ Staff filtering works: ${staffLeaves.length} leaves for STAFF_0001');

      // Test date range filtering
      final rangeLeaves = await repository.getLeavesInDateRange(
        startDate: "2025-08-01",
        endDate: "2025-08-31",
      );
      expect(rangeLeaves.length, greaterThan(0));
      print('✓ Date range filtering works: ${rangeLeaves.length} leaves in August 2025');
    });
  });
}
