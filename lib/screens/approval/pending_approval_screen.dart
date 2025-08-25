import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/approval/approval_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/models/approval/approval_info.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/approval/approval_detail_screen.dart';
import '../../theme/app_theme.dart';

class PendingApprovalScreen extends StatefulWidget {
  final String title;
  const PendingApprovalScreen({super.key, required this.title});

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load approval dashboard data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApprovalProvider>().getApprovalDashboard();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title, 
          style: PalmTextStyles.title.copyWith(color: PalmColors.white),
        ),
        backgroundColor: PalmColors.primary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            width: double.infinity,
            color: PalmColors.primary,
            child: Consumer<ApprovalProvider>(
              builder: (context, approvalProvider, child) {
                final totalPending = approvalProvider.totalPendingCount;
                final managerPending = approvalProvider.managerPendingCount;
                final supervisorPending = approvalProvider.supervisorPendingCount;
                
                return TabBar(
                  controller: _tabController,
                  labelColor: PalmColors.white,
                  unselectedLabelColor: PalmColors.neutralLight,
                  indicatorColor: PalmColors.white,
                  indicatorWeight: 3,
                  labelStyle: PalmTextStyles.button.copyWith(fontWeight: FontWeight.w500),
                  unselectedLabelStyle: PalmTextStyles.button,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('All'),
                          if (totalPending > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: PalmColors.warning,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                totalPending.toString(),
                                style: PalmTextStyles.label.copyWith(
                                  color: PalmColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Manager'),
                          if (managerPending > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: PalmColors.danger,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                managerPending.toString(),
                                style: PalmTextStyles.label.copyWith(
                                  color: PalmColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Supervisor'),
                          if (supervisorPending > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: PalmColors.info,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                supervisorPending.toString(),
                                style: PalmTextStyles.label.copyWith(
                                  color: PalmColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
      body: Consumer<ApprovalProvider>(
        builder: (context, approvalProvider, child) {
          final approvalDashboard = approvalProvider.approvalDashboard;
          
          if (approvalDashboard == null) {
            return const Center(
              child: Text(
                'Tap refresh to load approval data',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          switch (approvalDashboard.state) {
            case AsyncValueState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case AsyncValueState.error:
              return _buildErrorState(
                approvalProvider.errorMessage ?? 'Unknown error occurred',
                () => approvalProvider.refreshApprovalDashboard(),
              );

            case AsyncValueState.success:
              final data = approvalDashboard.data!;
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildApprovalList([
                    ...data.managerPending.requests,
                    ...data.supervisorPending.requests,
                  ], 'All Pending Approvals'),
                  _buildApprovalList(
                    data.managerPending.requests,
                    'Manager Pending Approvals',
                  ),
                  _buildApprovalList(
                    data.supervisorPending.requests,
                    'Supervisor Pending Approvals',
                  ),
                ],
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ApprovalProvider>().refreshApprovalDashboard();
        },
        backgroundColor: PalmColors.primary,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(PalmSpacings.l),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: PalmColors.danger,
            ),
            SizedBox(height: PalmSpacings.m),
            Text(
              'Error loading approvals',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.danger,
              ),
            ),
            SizedBox(height: PalmSpacings.s),
            Text(
              error,
              textAlign: TextAlign.center,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.neutralDark,
              ),
            ),
            SizedBox(height: PalmSpacings.l),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: PalmColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildApprovalList(List<LeaveRequest> approvals, String emptyMessage) {
    if (approvals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: PalmColors.neutralLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No pending approvals',
              style: PalmTextStyles.title.copyWith(
                color: PalmColors.neutralLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All caught up!',
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.neutralLight,
              ),
            ),
          ],
        ),
      );
    }
    
    // Sort approvals by latest date/time first
    final sortedApprovals = _sortApprovalsByLatest(approvals);
    
    return RefreshIndicator(
      onRefresh: () => context.read<ApprovalProvider>().refreshApprovalDashboard(),
      child: ListView.builder(
        itemCount: sortedApprovals.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return ApprovalListTile(leaveRequest: sortedApprovals[index]);
        },
      ),
    );
  }

  /// Sort approvals by latest date/time first
  /// If same day, sort by latest hour
  List<LeaveRequest> _sortApprovalsByLatest(List<LeaveRequest> approvals) {
    final sortedList = List<LeaveRequest>.from(approvals);
    
    sortedList.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        
        // Sort in descending order (latest first)
        return dateB.compareTo(dateA);
      } catch (e) {
        // If parsing fails, maintain original order
        return 0;
      }
    });
    
    return sortedList;
  }
}

class ApprovalListTile extends StatelessWidget {
  final LeaveRequest leaveRequest;

  const ApprovalListTile({
    super.key,
    required this.leaveRequest,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to approval detail screen
        final result = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => ApprovalDetailScreen(
              leaveRequest: leaveRequest,
            ),
          ),
        );
        
        // If approval action was successful, show message and refresh
        if (result == true && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Approval action completed for ${leaveRequest.firstNameEng} ${leaveRequest.lastNameEng}'),
              duration: const Duration(seconds: 2),
              backgroundColor: PalmColors.success,
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.zero,
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            // Header section with date and status - full width
            Container(
              width: double.infinity,
              height: 31,
              decoration: BoxDecoration(
                color: PalmColors.primary.withOpacity(0.8),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Text(
                    _formatCreatedDate(),
                    style: PalmTextStyles.body.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 89,
                    height: 31,
                    decoration: BoxDecoration(
                      color: PalmColors.warning,
                    ),
                    child: Center(
                      child: Text(
                        'PENDING',
                        style: PalmTextStyles.button.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content section - full width with improved layout
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side - All data content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Employee name and leave type row
                        Row(
                          children: [
                            // Profile avatar - Leading (bigger)
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PalmColors.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  _getFirstLetter('${leaveRequest.firstNameEng} ${leaveRequest.lastNameEng}'),
                                  style: PalmTextStyles.label.copyWith(
                                    color: PalmColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Title - Employee name
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${leaveRequest.firstNameEng} ${leaveRequest.lastNameEng}',
                                    style: PalmTextStyles.body.copyWith(
                                      color: PalmColors.textNormal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),

                                ],
                              ),
                            ),
                            // Leave type badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: PalmColors.info.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                _capitalizeLeaveType(leaveRequest.leaveType),
                                style: PalmTextStyles.label.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Date range row
                        Row(
                          children: [
                            // Calendar icon - bigger
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PalmColors.primary.withOpacity(0.1),
                              ),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: PalmColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${_formatDate(leaveRequest.startDate)} - ${_formatDate(leaveRequest.endDate)}',
                                style: PalmTextStyles.body.copyWith(
                                  color: PalmColors.textLight,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            // Duration badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${leaveRequest.totalDays} day${int.parse(leaveRequest.totalDays) > 1 ? 's' : ''}',
                                style: PalmTextStyles.label.copyWith(
                                  color: PalmColors.textLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Reason row with bigger icon
                        Row(
                          children: [
                            // Reason icon - bigger
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PalmColors.warning.withOpacity(0.1),
                              ),
                              child: Icon(
                                Icons.subject_outlined,
                                size: 20,
                                color: PalmColors.warning,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                leaveRequest.reason,
                                style: PalmTextStyles.body.copyWith(
                                  color: PalmColors.textLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right side - Chevron icon (vertically centered)
                  const SizedBox(width: 12),
                  Icon(
                    Icons.chevron_right,
                    color: PalmColors.neutralLight,
                    size: 32,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to format created date (for header)
  String _formatCreatedDate() {
    try {
      final date = DateTime.parse(leaveRequest.createdAt);
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${date.day}/${months[date.month]}/${date.year}';
    } catch (e) {
      return leaveRequest.createdAt;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _capitalizeLeaveType(String leaveType) {
    return leaveType.split(' ')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  // Helper method to get first letter for avatar
  String _getFirstLetter(String name) {
    if (name.isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }
}
