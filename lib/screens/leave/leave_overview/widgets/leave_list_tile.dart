import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:palm_ecommerce_mobile_app_2/models/leaves/leave_info.dart';

class LeaveListTile extends StatelessWidget {
  final LeaveInfo leave;
  final VoidCallback? onTap;

  const LeaveListTile({
    super.key,
    required this.leave,
    this.onTap,
  });

  // Helper method to format date
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
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
      return dateString;
    }
  }

  // Helper method to format created date (for header)
  String _formatCreatedDate() {
    return _formatDate(leave.createdAt);
  }

  // Helper method to get date range
  String _getDateRange() {
    return '${_formatDate(leave.startDate)} - ${_formatDate(leave.endDate)}';
  }

  // Helper method to get duration
  String _getDuration() {
    final days = int.tryParse(leave.totalDays ?? '0') ?? 0;
    return '$days day${days > 1 ? 's' : ''}';
  }

  // Helper method to get certified by name
  String _getCertifiedBy() {
    return leave.supervisorName ?? 'Not assigned';
  }

  // Helper method to get certified status
  String _getCertifiedStatus() {
    if (leave.supervisorActionDate != null &&
        leave.supervisorActionDate!.isNotEmpty) {
      final status = leave.status?.toLowerCase();
      if (status == 'supervisor_rejected') {
        return 'Rejected';
      } else if (status == 'approved' || status == 'supervisor_approved') {
        return 'Approved';
      } else if (status == 'rejected') {
        // If final status is rejected, could be supervisor or manager rejection
        // Check if manager has acted - if not, it was supervisor rejection
        if (leave.managerActionDate == null ||
            leave.managerActionDate!.isEmpty) {
          return 'Rejected';
        } else {
          return 'Approved'; // Supervisor approved, manager rejected
        }
      }
    }
    return 'Pending';
  }

  // Helper method to get approved by name
  String _getApprovedBy() {
    return leave.managerName ?? 'Not assigned';
  }

  // Helper method to get approved status
  String _getApprovedStatus() {
    final status = leave.status?.toLowerCase();

    // If supervisor rejected, manager never gets to review
    if (status == 'supervisor_rejected') {
      return 'N/A';
    }

    if (leave.managerActionDate != null &&
        leave.managerActionDate!.isNotEmpty) {
      if (status == 'approved') {
        return 'Approved';
      } else if (status == 'rejected') {
        return 'Rejected';
      }
    }

    // If supervisor hasn't approved yet, manager is still waiting
    if (status == 'pending') {
      return 'Pending';
    }

    // If supervisor approved but manager hasn't acted yet
    if (status == 'supervisor_approved') {
      return 'Pending';
    }

    return 'Pending';
  }

  // Helper method to get first letter for avatar
  String _getFirstLetter(String? name) {
    if (name == null || name.isEmpty) return '?';
    return name.trim()[0].toUpperCase();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return PalmColors.success;
      case 'rejected':
        return PalmColors.danger;
      case 'supervisor_approved':
        return PalmColors.warning; // Orange for intermediate approval
      case 'supervisor_rejected':
        return PalmColors.danger;
      case 'pending':
        return PalmColors.warning;
      default:
        return PalmColors.warning;
    }
  }

  // Helper method to get display text for status
  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'supervisor_approved':
        return 'MGR. APPROVED';
      case 'supervisor_rejected':
        return 'MGR. REJECTED';
      default:
        return status.toUpperCase();
    }
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        _getStatusDisplayText(status),
        style: PalmTextStyles.label.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildApprovalSection({
    required String title,
    required String name,
    required String status,
    String? dateString,
  }) {
    return Row(
      children: [
        // Avatar with first letter
        Container(
          width: 25,
          height: 25,
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
              _getFirstLetter(name),
              style: PalmTextStyles.label.copyWith(
                color: PalmColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 7),
        // Name
        Expanded(
          child: Text(
            '$title $name',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textNormal,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        // Date
        Text(
          dateString != null ? _formatDate(dateString) : '-',
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.textLight,
          ),
        ),
        const SizedBox(width: 8),
        // Status badge
        _buildStatusBadge(status),
      ],
    );
  }

  // Method to show full details as bottom sheet
  void _showLeaveDetailsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Bottom Sheet Header with drag handle
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: PalmColors.primary,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_note,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Leave Request Details',
                            style: PalmTextStyles.title.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Badge
                          Row(
                            children: [
                              Text(
                                'Status: ',
                                style: PalmTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: PalmColors.textNormal,
                                ),
                              ),
                              _buildStatusBadge(leave.status ?? 'pending'),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Leave Details
                          _buildDetailRow(
                            'Date Range',
                            _getDateRange(),
                            Icons.calendar_today,
                          ),
                          const SizedBox(height: 12),

                          _buildDetailRow(
                            'Duration',
                            _getDuration(),
                            Icons.schedule,
                          ),
                          const SizedBox(height: 12),

                          _buildDetailRow(
                            'Leave Type',
                            leave.leaveType?.value.toUpperCase() ?? 'Unknown',
                            Icons.category,
                          ),
                          const SizedBox(height: 12),

                          _buildDetailRow(
                            'Reason',
                            leave.reason ?? 'No reason provided',
                            Icons.comment,
                            isExpandable: true,
                          ),
                          const SizedBox(height: 20),

                          // Approval Workflow Section
                          Text(
                            'Approval Workflow',
                            style: PalmTextStyles.subheading.copyWith(
                              fontWeight: FontWeight.bold,
                              color: PalmColors.textNormal,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Certified by section
                          _buildApprovalSection(
                            title: 'Certified By:',
                            name: _getCertifiedBy(),
                            status: _getCertifiedStatus(),
                            dateString: leave.supervisorActionDate,
                          ),
                          const SizedBox(height: 12),

                          // Approved by section
                          _buildApprovalSection(
                            title: 'Approved By:',
                            name: _getApprovedBy(),
                            status: _getApprovedStatus(),
                            dateString: leave.managerActionDate,
                          ),

                          // Comments Section
                          if ((leave.supervisorComment != null &&
                                  leave.supervisorComment!.isNotEmpty) ||
                              (leave.managerComment != null &&
                                  leave.managerComment!.isNotEmpty)) ...[
                            const SizedBox(height: 20),
                            Text(
                              'Comments',
                              style: PalmTextStyles.subheading.copyWith(
                                fontWeight: FontWeight.bold,
                                color: PalmColors.textNormal,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Manager comment (previously supervisor comment)
                            if (leave.supervisorComment != null &&
                                leave.supervisorComment!.isNotEmpty)
                              _buildDetailRow(
                                'Manager Comment',
                                leave.supervisorComment!,
                                Icons.supervisor_account,
                                isExpandable: true,
                              ),
                            if (leave.supervisorComment != null &&
                                leave.supervisorComment!.isNotEmpty)
                              const SizedBox(height: 12),

                            // Head of Dept comment (previously manager comment)
                            if (leave.managerComment != null &&
                                leave.managerComment!.isNotEmpty)
                              _buildDetailRow(
                                'Head of Dept Comment',
                                leave.managerComment!,
                                Icons.manage_accounts,
                                isExpandable: true,
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper method to build detail rows in dialog
  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    bool isExpandable = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: PalmColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 16,
            color: PalmColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: PalmTextStyles.label.copyWith(
                  fontWeight: FontWeight.w600,
                  color: PalmColors.textNormal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: PalmTextStyles.body.copyWith(
                  color: PalmColors.textLight,
                ),
                maxLines: isExpandable ? null : 2,
                overflow: isExpandable ? null : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          _showLeaveDetailsDialog(context);
        }
      },
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            // Remove margin, padding, and border radius for seamless list
            ),
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              height: 31,
              decoration: BoxDecoration(
                color: PalmColors.primary.withOpacity(0.8),
                // Remove border radius for seamless connection
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      _formatCreatedDate(),
                      style: PalmTextStyles.body.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 89,
                      maxWidth: 140,
                    ),
                    height: 31,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(leave.status ?? 'pending'),
                      // Remove border radius for seamless connection
                    ),
                    child: Center(
                      child: Text(
                        _getStatusDisplayText(leave.status ?? 'pending'),
                        style: PalmTextStyles.button.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content section - simplified to show only essential data
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                // Remove border radius for seamless connection
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date range row
                  Row(
                    children: [
                      // Calendar icon
                      Container(
                        width: 15,
                        height: 15,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: PalmColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          size: 11,
                          color: PalmColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Date: ${_getDateRange()}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      // Duration badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
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
                          _getDuration(),
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Leave type row
                  Row(
                    children: [
                      // Leave type icon
                      Container(
                        width: 16,
                        height: 16,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: PalmColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Image.asset(
                          'assets/figma_icons/leave_icon.png',
                          width: 12,
                          height: 12,
                          color: PalmColors.success,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Type: ${leave.leaveType?.value.toUpperCase() ?? 'Unknown'}',
                          style: PalmTextStyles.label.copyWith(
                            color: PalmColors.textLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Reason row
                  Row(
                    children: [
                      // Reason icon
                      Container(
                        width: 18,
                        height: 18,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: PalmColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.comment,
                          size: 12,
                          color: PalmColors.warning,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          'Reason: ${leave.reason ?? 'No reason provided'}',
                          style: PalmTextStyles.label.copyWith(
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
          ],
        ),
      ),
    );
  }
}
