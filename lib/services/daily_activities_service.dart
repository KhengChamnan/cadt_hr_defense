import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/daily_activies.dart';

/// Service for managing daily activities business logic
/// - Manages activity data operations
/// - Handles activity status changes
/// - Provides filtering and formatting utilities
class DailyActivitiesService {
  static final DailyActivitiesService _instance = DailyActivitiesService._internal();
  factory DailyActivitiesService() => _instance;
  DailyActivitiesService._internal();

  // Sample data - in real app, this would come from API/database
  List<DailyActivity> _activities = [
    DailyActivity(
      id: '1',
      activityId: '1',
      activityCategory: DailyActivity.activityCategories[0], // កាលប្រជុំប្រចាំសប្តាហ៍
      activityDescription: 'កាបជុំប្រចាំសប្តាហ៍',
      keyApi: 'MEETING',
      subApi: 'WEEKLY',
      fromDate: DateTime.now().subtract(const Duration(hours: 2)),
      toDate: DateTime.now().subtract(const Duration(hours: 1)),
      remark: 'ពិភាក្សាអំពីផែនការងារសប្តាហ៍បន្ទាប់',
      score: 85.5,
      employeeId: 'EMP001',
      createdAt: DateTime.now(),
      status: ActivityStatus.completed,
    ),
    DailyActivity(
      id: '2',
      activityId: '2',
      activityCategory: DailyActivity.activityCategories[8], // ចំណាចំពាក់ព័ន្ធជាមួយអតិថិជន
      activityDescription: 'ជួបអតិថិជន',
      keyApi: 'CLIENT',
      subApi: 'VISIT',
      fromDate: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      toDate: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
      remark: 'ការបង្ហាញផលិតផលថ្មី',
      photoPath: '/storage/activities/client_visit_001.jpg',
      location: ActivityLocation(
        latitude: 11.5564,
        longitude: 104.9282,
        address: 'Phnom Penh Center, Cambodia',
        clientName: 'Mr. Sok Dara',
        clientCompany: 'ABC Company Ltd.',
      ),
      score: 92.0,
      employeeId: 'EMP001',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: ActivityStatus.approved,
    ),
    DailyActivity(
      id: '3',
      activityId: '3',
      activityCategory: DailyActivity.activityCategories[5], // កាលធ្វើបទបង្ហាញ និង កាលរៀបចំឯកសារ
      activityDescription: 'បង្កើតរបាយការណ៍',
      keyApi: 'DOCUMENT',
      subApi: 'REPORT',
      fromDate: DateTime.now().subtract(const Duration(hours: 4)),
      toDate: DateTime.now().subtract(const Duration(hours: 2)),
      remark: 'របាយការណ៍ប្រចាំខែ',
      employeeId: 'EMP001',
      createdAt: DateTime.now(),
      status: ActivityStatus.inProgress,
    ),
  ];

  /// Get all activities
  List<DailyActivity> getAllActivities() {
    return List.unmodifiable(_activities);
  }

  /// Get today's activities only
  List<DailyActivity> getTodayActivities() {
    final today = DateTime.now();
    return _activities.where((activity) {
      return activity.createdAt.year == today.year &&
             activity.createdAt.month == today.month &&
             activity.createdAt.day == today.day;
    }).toList();
  }

  /// Get activities by date range
  List<DailyActivity> getActivitiesByDateRange(DateTime startDate, DateTime endDate) {
    return _activities.where((activity) {
      return activity.createdAt.isAfter(startDate) && 
             activity.createdAt.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  /// Add new activity
  void addActivity(DailyActivity activity) {
    _activities.insert(0, activity); // Add to beginning of list
  }

  /// Update existing activity
  bool updateActivity(DailyActivity updatedActivity) {
    final index = _activities.indexWhere((activity) => activity.id == updatedActivity.id);
    if (index != -1) {
      _activities[index] = updatedActivity;
      return true;
    }
    return false;
  }

  /// Delete activity by ID
  bool deleteActivity(String activityId) {
    final initialLength = _activities.length;
    _activities.removeWhere((activity) => activity.id == activityId);
    return _activities.length < initialLength;
  }

  /// Change activity status
  bool changeActivityStatus(String activityId, ActivityStatus newStatus) {
    final index = _activities.indexWhere((activity) => activity.id == activityId);
    if (index != -1) {
      final activity = _activities[index];
      _activities[index] = DailyActivity(
        id: activity.id,
        activityId: activity.activityId,
        activityCategory: activity.activityCategory,
        activityDescription: activity.activityDescription,
        keyApi: activity.keyApi,
        subApi: activity.subApi,
        fromDate: activity.fromDate,
        // Update toDate to current time when marking as completed
        toDate: newStatus == ActivityStatus.completed 
            ? DateTime.now() 
            : activity.toDate,
        remark: activity.remark,
        photoPath: activity.photoPath,
        location: activity.location,
        score: activity.score,
        employeeId: activity.employeeId,
        createdAt: activity.createdAt,
        updatedAt: DateTime.now(),
        status: newStatus,
      );
      return true;
    }
    return false;
  }

  /// Format duration between two dates
  String formatDuration(DateTime fromDate, DateTime toDate) {
    final duration = toDate.difference(fromDate);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Format activity duration (shows -- if not completed)
  String formatActivityDuration(DailyActivity activity) {
    // Show "--" for activities that are not completed yet
    if (activity.status != ActivityStatus.completed) {
      return '--';
    }
    
    return formatDuration(activity.fromDate, activity.toDate);
  }

  /// Get status display properties
  ActivityStatusInfo getStatusInfo(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.completed:
        return ActivityStatusInfo(
          displayName: 'Completed',
          color: const Color(0xFF4CAF50), // Green
          icon: Icons.check_circle,
        );
      case ActivityStatus.inProgress:
        return ActivityStatusInfo(
          displayName: 'In Progress',
          color: const Color(0xFFFF9800), // Orange
          icon: Icons.schedule,
        );
      case ActivityStatus.pending:
        return ActivityStatusInfo(
          displayName: 'Pending',
          color: const Color(0xFF9E9E9E), // Grey
          icon: Icons.pending,
        );
      case ActivityStatus.approved:
        return ActivityStatusInfo(
          displayName: 'Approved',
          color: const Color(0xFF2196F3), // Blue
          icon: Icons.verified,
        );
      case ActivityStatus.rejected:
        return ActivityStatusInfo(
          displayName: 'Rejected',
          color: const Color(0xFFF44336), // Red
          icon: Icons.cancel,
        );
      case ActivityStatus.cancelled:
        return ActivityStatusInfo(
          displayName: 'Cancelled',
          color: const Color(0xFF757575), // Dark Grey
          icon: Icons.cancel_outlined,
        );
    }
  }

  /// Check if activity can be edited
  bool canEditActivity(DailyActivity activity) {
    // Activities can only be edited if they are not approved or rejected
    return activity.status != ActivityStatus.approved && 
           activity.status != ActivityStatus.rejected;
  }

  /// Check if activity can be deleted
  bool canDeleteActivity(DailyActivity activity) {
    // Activities can only be deleted if they are not approved
    return activity.status != ActivityStatus.approved;
  }

  /// Get activity statistics
  ActivityStatistics getActivityStatistics() {
    final total = _activities.length;
    final completed = _activities.where((a) => a.status == ActivityStatus.completed).length;
    final inProgress = _activities.where((a) => a.status == ActivityStatus.inProgress).length;
    final pending = _activities.where((a) => a.status == ActivityStatus.pending).length;
    final approved = _activities.where((a) => a.status == ActivityStatus.approved).length;

    return ActivityStatistics(
      total: total,
      completed: completed,
      inProgress: inProgress,
      pending: pending,
      approved: approved,
    );
  }
}

/// Activity status information for UI display
class ActivityStatusInfo {
  final String displayName;
  final Color color;
  final IconData icon;

  ActivityStatusInfo({
    required this.displayName,
    required this.color,
    required this.icon,
  });
}

/// Activity statistics data class
class ActivityStatistics {
  final int total;
  final int completed;
  final int inProgress;
  final int pending;
  final int approved;

  ActivityStatistics({
    required this.total,
    required this.completed,
    required this.inProgress,
    required this.pending,
    required this.approved,
  });

  double get completionRate => total > 0 ? (completed / total) * 100 : 0.0;
}
