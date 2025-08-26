import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_data.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/leave/leave_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/staff/staff_provder.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';
import 'widgets/pie_chart.dart';
import 'widgets/leave_list_tile.dart';

class LeaveOverviewScreen extends StatefulWidget {
  const LeaveOverviewScreen({super.key});

  @override
  State<LeaveOverviewScreen> createState() => _LeaveOverviewScreenState();
}

class _LeaveOverviewScreenState extends State<LeaveOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();

    // Add listener to handle tab changes (including swipe gestures)
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Tab is changing, scroll to top
        _scrollToTop(_tabController.index);
      }
    });

    // Load leave and staff data from providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload data when screen comes back into focus
    // This ensures fresh data is shown when returning from leave request screen
    _loadData();
  }

  /// Load leave and staff data from providers
  void _loadData() {
    final leaveProvider = Provider.of<LeaveProvider>(context, listen: false);
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    leaveProvider.getLeaveList();
    staffProvider.getStaffInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.white,
      appBar: AppBar(
        title: Text(
          'Leave History',
          style: PalmTextStyles.title.copyWith(color: Colors.white),
        ),
        backgroundColor: PalmColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer2<LeaveProvider, StaffProvider>(
        builder: (context, leaveProvider, staffProvider, child) {
          // Get leave data
          List<LeaveInfo> allLeaves = [];

          if (leaveProvider.leaveList?.state == AsyncValueState.success) {
            allLeaves = leaveProvider.leaveList!.data!;
          }

          // Filter leaves by status
          final pendingLeaves = allLeaves
              .where((leave) => leave.status?.toLowerCase() == 'pending')
              .toList();
          final approvedLeaves = allLeaves
              .where((leave) =>
                  leave.status?.toLowerCase() == 'approved' ||
                  leave.status?.toLowerCase() == 'supervisor_approved')
              .toList();
          final rejectedLeaves = allLeaves
              .where((leave) =>
                  leave.status?.toLowerCase() == 'rejected' ||
                  leave.status?.toLowerCase() == 'supervisor_rejected')
              .toList();

          return Column(
            children: [
              // Pie Chart Section - Shows leave balance from staff info
              Container(
                height: 240,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: PalmColors.backGroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LeavePieChart(
                  chartData:
                      staffProvider.staffInfo?.state == AsyncValueState.success
                          ? LeaveData.generateChartDataFromStaff(
                              staffProvider.staffInfo!.data)
                          : LeaveData.generateChartDataFromLeaves(
                              []), // fallback to empty leaves data
                ),
              ),

              // Tab Bar
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: PalmColors.primary,
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Pending'),
                    Tab(text: 'Approved'),
                    Tab(text: 'Rejected'),
                  ],
                ),
              ),

              // Tab Bar View
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // All Leaves
                    _buildLeaveListView(allLeaves),
                    // Pending Leaves
                    _buildLeaveListView(pendingLeaves),
                    // Approved Leaves
                    _buildLeaveListView(approvedLeaves),
                    // Rejected Leaves
                    _buildLeaveListView(rejectedLeaves),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Method to scroll to top based on tab index
  void _scrollToTop(int index) {
    // Use the main scroll controller to scroll to top
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Leave list view (without pie chart)
  Widget _buildLeaveListView(List<LeaveInfo> leaves) {
    return Consumer2<LeaveProvider, StaffProvider>(
      builder: (context, leaveProvider, staffProvider, child) {
        final isLoading =
            leaveProvider.leaveList?.state == AsyncValueState.loading;

        // Handle error state
        if (leaveProvider.leaveList?.state == AsyncValueState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading leave data',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _loadData();
            // Wait for the data to load
            while (leaveProvider.leaveList?.state == AsyncValueState.loading) {
              await Future.delayed(const Duration(milliseconds: 100));
            }
          },
          child: Skeletonizer(
            enabled: isLoading,
            effect: const ShimmerEffect(),
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8),
              children: [
                // Leave List Section - Shows filtered leaves based on tab
                if (leaves.isEmpty && !isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No leave requests found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // Use LeaveListTile for each leave item (show skeleton when loading)
                  ...(isLoading && leaves.isEmpty
                      ? List.generate(
                          3,
                          (index) => LeaveListTile(
                                leave:
                                    LeaveInfo(), // Empty leave info for skeleton
                              ))
                      : leaves
                          .map((leave) => LeaveListTile(
                                leave: leave,
                                // Remove custom onTap to use default dialog functionality
                              ))
                          .toList()),
              ],
            ),
          ),
        );
      },
    );
  }
}
