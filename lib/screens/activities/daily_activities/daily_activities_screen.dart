import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/models/activities/daily_activies.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/widgets/daily_activity_list_tile.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/widgets/daily_activity_form_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/services/daily_activities_service.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/daily_activities_ui_utils.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Daily Activities Screen
/// - Displays daily activity records with tabs (Today/All Records)
/// - Allows adding new activities
/// - Provides filter functionality by date
class DailyActivitiesScreen extends StatefulWidget {
  const DailyActivitiesScreen({super.key});

  @override
  State<DailyActivitiesScreen> createState() => _DailyActivitiesScreenState();
}

class _DailyActivitiesScreenState extends State<DailyActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DailyActivitiesService _activitiesService;
  String _searchKeyword = '';
  DateTime? _filterDate;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _activitiesService = DailyActivitiesService();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Get today's activities
  List<DailyActivity> get todayActivities {
    List<DailyActivity> activities = _activitiesService.getTodayActivities();
    return _applyFilters(activities);
  }

  /// Get all activities  
  List<DailyActivity> get allActivities {
    List<DailyActivity> activities = _activitiesService.getAllActivities();
    return _applyFilters(activities);
  }

  /// Apply search and filter to activities
  List<DailyActivity> _applyFilters(List<DailyActivity> activities) {
    List<DailyActivity> filtered = activities;

    // Apply search filter
    if (_searchKeyword.isNotEmpty) {
      filtered = filtered.where((activity) =>
          activity.activityDescription.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
          activity.subApi.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
          activity.keyApi.toLowerCase().contains(_searchKeyword.toLowerCase())
      ).toList();
    }

    // Apply date filter
    if (_filterDate != null) {
      filtered = filtered.where((activity) =>
          activity.fromDate.year == _filterDate!.year &&
          activity.fromDate.month == _filterDate!.month &&
          activity.fromDate.day == _filterDate!.day
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daily Activities',
          style: TextStyle(color: PalmColors.white),
        ),
        backgroundColor: PalmColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PalmColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: PalmColors.white,
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: PalmColors.white,
            onPressed: () => _showFilterDialog(),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: PalmColors.white),
            onSelected: (value) {
              switch (value) {
                case 'statistics':
                  _showStatistics();
                  break;
                case 'add':
                  _navigateToAddActivity();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'statistics',
                child: Row(
                  children: [
                    Icon(Icons.analytics),
                    SizedBox(width: 8),
                    Text('Statistics'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'add',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add Activity'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.today),
              text: 'Today',
            ),
            Tab(
              icon: Icon(Icons.list_alt),
              text: 'All Records',
            ),
          ],
          indicatorColor: PalmColors.white,
          labelColor: PalmColors.white,
          unselectedLabelColor: PalmColors.white.withOpacity(0.7),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivitiesList(todayActivities, isToday: true),
          _buildActivitiesList(allActivities, isToday: false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddActivity(),
        backgroundColor: PalmColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Navigate to add activity screen
  void _navigateToAddActivity() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DailyActivityFormScreen(),
      ),
    ).then((result) {
      // Add the new activity to the list if one was created
      if (result != null && result is DailyActivity) {
        _activitiesService.addActivity(result);
        setState(() {}); // Refresh UI
        
        // Show success message using utility
        DailyActivitiesUIUtils.showSuccessMessage(
          context,
          'Activity "${result.activityDescription}" added successfully',
        );
      }
    });
  }

  /// Build activities list widget
  Widget _buildActivitiesList(List<DailyActivity> activities, {required bool isToday}) {
    if (activities.isEmpty) {
      return _buildEmptyState(isToday);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return DailyActivityListTile(
          activity: activity,
          onTap: () => _showActivityDetails(activity),
          onEdit: () => _editActivity(activity),
          onDelete: () => _deleteActivity(activity),
          onStatusChanged: (newStatus) => _changeActivityStatusQuick(activity, newStatus),
        );
      },
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(bool isToday) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isToday ? Icons.event_available : Icons.assignment_outlined,
              size: 80,
              color: PalmColors.textLight,
            ),
            const SizedBox(height: PalmSpacings.l),
            Text(
              isToday ? 'No Activities Today' : 'No Activities Yet',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.textNormal,
              ),
            ),
            const SizedBox(height: PalmSpacings.m),
            Text(
              isToday 
                ? 'You haven\'t logged any activities for today. Start tracking your daily work.'
                : 'Add your daily activities to keep track of your work progress and achievements.',
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PalmSpacings.xl),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddActivity(),
              icon: const Icon(Icons.add),
              label: const Text('Add Activity'),
              style: ElevatedButton.styleFrom(
                backgroundColor: PalmColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: PalmSpacings.l,
                  vertical: PalmSpacings.m,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show activity details dialog
  void _showActivityDetails(DailyActivity activity) {
    DailyActivitiesUIUtils.showActivityDetails(
      context, 
      activity, 
      _handleStatusChange,
    );
  }

  /// Handle activity status change
  void _handleStatusChange(DailyActivity activity, ActivityStatus newStatus) {
    if (activity.id == null) {
      DailyActivitiesUIUtils.showErrorMessage(
        context, 
        'Activity ID is missing',
      );
      return;
    }
    
    final success = _activitiesService.changeActivityStatus(activity.id!, newStatus);
    if (success) {
      setState(() {}); // Refresh UI
      DailyActivitiesUIUtils.showStatusChangeMessage(context, newStatus);
    } else {
      DailyActivitiesUIUtils.showErrorMessage(
        context, 
        'Failed to update activity status',
      );
    }
  }

  /// Edit activity record
  void _editActivity(DailyActivity activity) {
    // Check if activity can be edited
    if (!_activitiesService.canEditActivity(activity)) {
      DailyActivitiesUIUtils.showErrorMessage(
        context,
        'This activity cannot be edited as it has been approved or rejected',
      );
      return;
    }
    
    // TODO: Implement edit functionality
    // Navigate to DailyActivityFormScreen with pre-filled data
    DailyActivitiesUIUtils.showErrorMessage(
      context,
      'Edit functionality will be implemented',
    );
  }

  /// Delete activity record
  void _deleteActivity(DailyActivity activity) {
    // Check if activity can be deleted
    if (!_activitiesService.canDeleteActivity(activity)) {
      DailyActivitiesUIUtils.showErrorMessage(
        context,
        'This activity cannot be deleted as it has been approved',
      );
      return;
    }

    DailyActivitiesUIUtils.showDeleteConfirmation(
      context,
      activity,
      () => _performDelete(activity),
    );
  }

  /// Perform actual delete operation
  void _performDelete(DailyActivity activity) {
    if (activity.id == null) {
      DailyActivitiesUIUtils.showErrorMessage(
        context,
        'Activity ID is missing',
      );
      return;
    }

    final success = _activitiesService.deleteActivity(activity.id!);
    if (success) {
      setState(() {}); // Refresh UI
      DailyActivitiesUIUtils.showSuccessMessage(
        context,
        'Activity deleted successfully',
      );
    } else {
      DailyActivitiesUIUtils.showErrorMessage(
        context,
        'Failed to delete activity',
      );
    }
  }

  /// Quick status change from list tile (without confirmation)
  void _changeActivityStatusQuick(DailyActivity activity, ActivityStatus newStatus) {
    if (activity.id == null) {
      DailyActivitiesUIUtils.showErrorMessage(
        context, 
        'Activity ID is missing',
      );
      return;
    }
    
    final success = _activitiesService.changeActivityStatus(activity.id!, newStatus);
    if (success) {
      setState(() {}); // Refresh UI
      DailyActivitiesUIUtils.showStatusChangeMessage(context, newStatus);
    } else {
      DailyActivitiesUIUtils.showErrorMessage(
        context, 
        'Failed to update activity status',
      );
    }
  }

  /// Show search dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempKeyword = _searchKeyword;
        return AlertDialog(
          title: const Text('Search Activities'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter keywords...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              tempKeyword = value;
            },
            controller: TextEditingController(text: _searchKeyword),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchKeyword = tempKeyword;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? tempDate = _filterDate;
        return AlertDialog(
          title: const Text('Filter Activities'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Filter by Date'),
                subtitle: Text(
                  tempDate != null 
                    ? '${tempDate.day}/${tempDate.month}/${tempDate.year}'
                    : 'No date selected',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: tempDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    tempDate = date;
                    Navigator.of(context).pop();
                    _showFilterDialog(); // Refresh dialog
                  }
                },
              ),
              if (tempDate != null)
                TextButton(
                  onPressed: () {
                    tempDate = null;
                    Navigator.of(context).pop();
                    _showFilterDialog(); // Refresh dialog
                  },
                  child: const Text('Clear Date Filter'),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterDate = tempDate;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  /// Show statistics dialog
  void _showStatistics() {
    final stats = _getActivityStatistics();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Activity Statistics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('Total Activities:', '${stats['total']}'),
              _buildStatRow('Today\'s Activities:', '${stats['today']}'),
              _buildStatRow('This Week:', '${stats['thisWeek']}'),
              _buildStatRow('This Month:', '${stats['thisMonth']}'),
              const Divider(),
              _buildStatRow('Pending:', '${stats['pending']}'),
              _buildStatRow('Approved:', '${stats['approved']}'),
              _buildStatRow('Rejected:', '${stats['rejected']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Build statistics row
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Get activity statistics
  Map<String, int> _getActivityStatistics() {
    final allActivities = _activitiesService.getAllActivities();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);

    return {
      'total': allActivities.length,
      'today': allActivities.where((a) => 
          DateTime(a.fromDate.year, a.fromDate.month, a.fromDate.day) == today
      ).length,
      'thisWeek': allActivities.where((a) => 
          a.fromDate.isAfter(startOfWeek.subtract(const Duration(days: 1)))
      ).length,
      'thisMonth': allActivities.where((a) => 
          a.fromDate.isAfter(startOfMonth.subtract(const Duration(days: 1)))
      ).length,
      'pending': allActivities.where((a) => 
          a.status.toString().split('.').last == 'pending'
      ).length,
      'approved': allActivities.where((a) => 
          a.status.toString().split('.').last == 'approved'
      ).length,
      'rejected': allActivities.where((a) => 
          a.status.toString().split('.').last == 'rejected'
      ).length,
    };
  }
}
