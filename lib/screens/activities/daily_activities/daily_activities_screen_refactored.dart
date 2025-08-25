// import 'package:flutter/material.dart';
// import 'package:palm_ecommerce_mobile_app_2/models/activities/daily_activies.dart';
// import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/widgets/daily_activity_list_tile.dart';
// import 'package:palm_ecommerce_mobile_app_2/screens/activities/daily_activities/widgets/daily_activity_form_screen.dart';
// import 'package:palm_ecommerce_mobile_app_2/services/daily_activities_service.dart';
// import 'package:palm_ecommerce_mobile_app_2/utils/daily_activities_ui_utils.dart';
// import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

// /// Daily Activities Screen
// /// - Displays daily activity records with tabs (Today/All Records)
// /// - Allows adding new activities
// /// - Provides filter functionality by date
// class DailyActivitiesScreen extends StatefulWidget {
//   const DailyActivitiesScreen({super.key});

//   @override
//   State<DailyActivitiesScreen> createState() => _DailyActivitiesScreenState();
// }

// class _DailyActivitiesScreenState extends State<DailyActivitiesScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late DailyActivitiesService _activitiesService;
  
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _activitiesService = DailyActivitiesService();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   /// Get today's activities
//   List<DailyActivity> get todayActivities => _activitiesService.getTodayActivities();

//   /// Get all activities  
//   List<DailyActivity> get allActivities => _activitiesService.getAllActivities();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Daily Activities',
//           style: TextStyle(color: PalmColors.white),
//         ),
//         backgroundColor: PalmColors.primary,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: PalmColors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add, color: PalmColors.white),
//             onPressed: () => _navigateToAddActivity(),
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(
//               icon: Icon(Icons.today),
//               text: 'Today',
//             ),
//             Tab(
//               icon: Icon(Icons.list_alt),
//               text: 'All Records',
//             ),
//           ],
//           indicatorColor: PalmColors.white,
//           labelColor: PalmColors.white,
//           unselectedLabelColor: PalmColors.white.withOpacity(0.7),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildActivitiesList(todayActivities, isToday: true),
//           _buildActivitiesList(allActivities, isToday: false),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _navigateToAddActivity(),
//         backgroundColor: PalmColors.primary,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   /// Navigate to add activity screen
//   void _navigateToAddActivity() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const DailyActivityFormScreen(),
//       ),
//     ).then((result) {
//       // Add the new activity to the list if one was created
//       if (result != null && result is DailyActivity) {
//         _activitiesService.addActivity(result);
//         setState(() {}); // Refresh UI
        
//         // Show success message using utility
//         DailyActivitiesUIUtils.showSuccessMessage(
//           context,
//           'Activity "${result.activityDescription}" added successfully',
//         );
//       }
//     });
//   }

//   /// Build activities list widget
//   Widget _buildActivitiesList(List<DailyActivity> activities, {required bool isToday}) {
//     if (activities.isEmpty) {
//       return _buildEmptyState(isToday);
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(PalmSpacings.m),
//       itemCount: activities.length,
//       itemBuilder: (context, index) {
//         final activity = activities[index];
//         return DailyActivityListTile(
//           activity: activity,
//           onTap: () => _showActivityDetails(activity),
//           onEdit: () => _editActivity(activity),
//           onDelete: () => _deleteActivity(activity),
//           onStatusChanged: (newStatus) => _changeActivityStatusQuick(activity, newStatus),
//         );
//       },
//     );
//   }

//   /// Build empty state widget
//   Widget _buildEmptyState(bool isToday) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(PalmSpacings.l),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               isToday ? Icons.event_available : Icons.assignment_outlined,
//               size: 80,
//               color: PalmColors.textLight,
//             ),
//             const SizedBox(height: PalmSpacings.l),
//             Text(
//               isToday ? 'No Activities Today' : 'No Activities Yet',
//               style: PalmTextStyles.title.copyWith(
//                 color: PalmColors.textNormal,
//               ),
//             ),
//             const SizedBox(height: PalmSpacings.m),
//             Text(
//               isToday 
//                 ? 'You haven\'t logged any activities for today. Start tracking your daily work.'
//                 : 'Add your daily activities to keep track of your work progress and achievements.',
//               style: PalmTextStyles.body.copyWith(
//                 color: PalmColors.textLight,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: PalmSpacings.xl),
//             ElevatedButton.icon(
//               onPressed: () => _navigateToAddActivity(),
//               icon: const Icon(Icons.add),
//               label: const Text('Add Activity'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: PalmColors.primary,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: PalmSpacings.l,
//                   vertical: PalmSpacings.m,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Show activity details dialog
//   void _showActivityDetails(DailyActivity activity) {
//     DailyActivitiesUIUtils.showActivityDetails(
//       context, 
//       activity, 
//       _handleStatusChange,
//     );
//   }

//   /// Handle activity status change
//   void _handleStatusChange(DailyActivity activity, ActivityStatus newStatus) {
//     if (activity.id == null) {
//       DailyActivitiesUIUtils.showErrorMessage(
//         context, 
//         'Activity ID is missing',
//       );
//       return;
//     }
    
//     final success = _activitiesService.changeActivityStatus(activity.id!, newStatus);
//     if (success) {
//       setState(() {}); // Refresh UI
//       DailyActivitiesUIUtils.showStatusChangeMessage(context, newStatus);
//     } else {
//       DailyActivitiesUIUtils.showErrorMessage(
//         context, 
//         'Failed to update activity status',
//       );
//     }
//   }

//   /// Edit activity record
//   void _editActivity(DailyActivity activity) {
//     // Check if activity can be edited
//     if (!_activitiesService.canEditActivity(activity)) {
//       DailyActivitiesUIUtils.showErrorMessage(
//         context,
//         'This activity cannot be edited as it has been approved or rejected',
//       );
//       return;
//     }
    
//     // TODO: Implement edit functionality
//     // Navigate to DailyActivityFormScreen with pre-filled data
//     DailyActivitiesUIUtils.showErrorMessage(
//       context,
//       'Edit functionality will be implemented',
//     );
//   }

//   /// Delete activity record
//   void _deleteActivity(DailyActivity activity) {
//     // Check if activity can be deleted
//     if (!_activitiesService.canDeleteActivity(activity)) {
//       DailyActivitiesUIUtils.showErrorMessage(
//         context,
//         'This activity cannot be deleted as it has been approved',
//       );
//       return;
//     }

//     DailyActivitiesUIUtils.showDeleteConfirmation(
//       context,
//       activity,
//       () => _performDelete(activity),
//     );
//   }

//   /// Perform actual delete operation
//   void _performDelete(DailyActivity activity) {
//     if (activity.id == null) {
//       DailyActivitiesUIUtils.showErrorMessage(
//         context,
//         'Activity ID is missing',
//       );
//       return;
//     }

//     final success = _activitiesService.deleteActivity(activity.id!);
//     if (success) {
//       setState(() {}); // Refresh UI
//       DailyActivitiesUIUtils.showSuccessMessage(
//         context,
//         'Activity deleted successfully',
//       );
//     } else {
//       DailyActivitiesUIUtils.showErrorMessage(
//         context,
//         'Failed to delete activity',
//       );
//     }
//   }

//   /// Quick status change from list tile (without confirmation)
//   void _changeActivityStatusQuick(DailyActivity activity, ActivityStatus newStatus) {
//     if (activity.id == null) {
//       DailyActivitiesUIUtils.showErrorMessage(
//         context, 
//         'Activity ID is missing',
//       );
//       return;
//     }
    
//     final success = _activitiesService.changeActivityStatus(activity.id!, newStatus);
//     if (success) {
//       setState(() {}); // Refresh UI
//       DailyActivitiesUIUtils.showStatusChangeMessage(context, newStatus);
//     } else {
//       DailyActivitiesUIUtils.showErrorMessage(
//         context, 
//         'Failed to update activity status',
//       );
//     }
//   }
// }
