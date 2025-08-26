import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/models/approval/approval_info.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/approval/approval_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

import 'package:palm_ecommerce_mobile_app_2/screens/approval/widgets/approval_result_bottom_sheet.dart';
import 'package:palm_ecommerce_mobile_app_2/widgets/loading_widget.dart';

/// Approval detail screen that allows supervisors and managers to:
/// - Review leave request details
/// - View previous comments based on their role
/// - Add comments to the request
/// - Approve or reject the leave request
class ApprovalDetailScreen extends StatefulWidget {
  final LeaveRequest leaveRequest;

  const ApprovalDetailScreen({
    super.key,
    required this.leaveRequest,
  });

  @override
  State<ApprovalDetailScreen> createState() => _ApprovalDetailScreenState();
}

class _ApprovalDetailScreenState extends State<ApprovalDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  // Get the current approval role
  ApprovalRole get _currentRole =>
      ApprovalRole.fromString(widget.leaveRequest.approvalRole);

  // Check if current user is manager and can see supervisor comments
  bool get _canViewSupervisorComments => _currentRole == ApprovalRole.manager;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleApprove() async {
    if (_commentController.text.trim().isEmpty) {
      _showValidationError('Please add a comment before approving');
      return;
    }

    try {
      final success = await context.read<ApprovalProvider>().approveLeave(
            leaveId: int.parse(widget.leaveRequest.leaveId),
            comment: _commentController.text.trim(),
            role: _currentRole,
          );

      if (success) {
        // Show success bottom sheet
        await ApprovalResultBottomSheet.showSuccess(
          context,
          actionType: "approve",
          onDone: () {
            Navigator.of(context).pop(); // Close bottom sheet
            Navigator.of(context)
                .pop(true); // Return to approval list with success
          },
        );
      } else {
        // Show error bottom sheet
        await ApprovalResultBottomSheet.showError(
          context,
          message: 'Failed to approve leave request. Please try again.',
          actionType: "approve",
          onDone: () {
            Navigator.of(context).pop(); // Close bottom sheet
          },
        );
      }
    } catch (e) {
      print('Approval error: $e'); // Debug logging

      // Show error bottom sheet
      await ApprovalResultBottomSheet.showError(
        context,
        message: 'An error occurred: ${e.toString()}',
        actionType: "approve",
        onDone: () {
          Navigator.of(context).pop(); // Close bottom sheet
        },
      );
    }
  }

  Future<void> _handleReject() async {
    if (_commentController.text.trim().isEmpty) {
      _showValidationError('Please add a comment before rejecting');
      return;
    }

    try {
      final success = await context.read<ApprovalProvider>().rejectLeave(
            leaveId: int.parse(widget.leaveRequest.leaveId),
            comment: _commentController.text.trim(),
            role: _currentRole,
          );

      if (success) {
        // Show success bottom sheet
        await ApprovalResultBottomSheet.showSuccess(
          context,
          actionType: "reject",
          onDone: () {
            Navigator.of(context).pop(); // Close bottom sheet
            Navigator.of(context)
                .pop(true); // Return to approval list with success
          },
        );
      } else {
        // Show error bottom sheet
        await ApprovalResultBottomSheet.showError(
          context,
          message: 'Failed to reject leave request. Please try again.',
          actionType: "reject",
          onDone: () {
            Navigator.of(context).pop(); // Close bottom sheet
          },
        );
      }
    } catch (e) {
      print('Rejection error: $e'); // Debug logging

      // Show error bottom sheet
      await ApprovalResultBottomSheet.showError(
        context,
        message: 'An error occurred: ${e.toString()}',
        actionType: "reject",
        onDone: () {
          Navigator.of(context).pop(); // Close bottom sheet
        },
      );
    }
  }

  void _showValidationError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_outlined, color: PalmColors.white),
            const SizedBox(width: PalmSpacings.xs),
            Expanded(
              child: Text(
                message,
                style: PalmTextStyles.body.copyWith(
                  color: PalmColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: PalmColors.warning,
        duration: const Duration(milliseconds: 3000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.s),
        ),
        margin: const EdgeInsets.all(PalmSpacings.m),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalmColors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: PalmColors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Back',
            style: PalmTextStyles.body.copyWith(
              color: PalmColors.textLight,
            ),
          ),
        ),
        title: Text(
          'Approval Form',
          style: PalmTextStyles.title.copyWith(
            color: PalmColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leadingWidth: 80,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text field
          _commentFocusNode.unfocus();
        },
        child: Consumer<ApprovalProvider>(
          builder: (context, approvalProvider, child) {
            // Show full-screen loading when submitting action
            if (approvalProvider.isSubmittingAction) {
              return const LoadingWidget();
            }

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                left: PalmSpacings.m,
                right: PalmSpacings.m,
                top: PalmSpacings.m,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom + PalmSpacings.m,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLeaveInformationCard(),
                  const SizedBox(height: PalmSpacings.l),
                  _buildLeaveRequestDetailCard(),
                  const SizedBox(height: PalmSpacings.l),
                  _buildCommentSection(),
                  const SizedBox(height: PalmSpacings.xl),
                  _buildActionButtons(approvalProvider),
                  // Extra space for keyboard padding
                  const SizedBox(height: PalmSpacings.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeaveInformationCard() {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leave Information',
            style: PalmTextStyles.title.copyWith(
              color: PalmColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: PalmSpacings.m),
          _buildInfoRow(
              'Leave Type:',
              _capitalizeLeaveType(widget.leaveRequest.leaveType),
              Icons.category),
          _buildInfoRow('Start Date:',
              _formatDate(widget.leaveRequest.startDate), Icons.calendar_today),
          _buildInfoRow('End Date:', _formatDate(widget.leaveRequest.endDate),
              Icons.event),
          _buildInfoRow(
              'Total Days:',
              '${widget.leaveRequest.totalDays} day${int.parse(widget.leaveRequest.totalDays) > 1 ? 's' : ''}',
              Icons.today),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28, // Consistent icon width
                  child:
                      Icon(Icons.subject, color: PalmColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 85, // Consistent label width
                  child: Text(
                    'Reason:',
                    style: PalmTextStyles.body.copyWith(
                      color: PalmColors.textLight,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.leaveRequest.reason,
                    style: PalmTextStyles.body.copyWith(
                      color: PalmColors.textNormal,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestDetailCard() {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leave Request Detail',
            style: PalmTextStyles.title.copyWith(
              color: PalmColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: PalmSpacings.m),
          _buildRequestInfoRow(
            'Request By:',
            '${widget.leaveRequest.firstNameEng} ${widget.leaveRequest.lastNameEng}',
            Icons.person,
            iconColor: PalmColors.primary,
            showAvatar: true,
          ),
          _buildRequestInfoRow(
            'Request Date:',
            _formatDate(widget.leaveRequest.createdAt.split(' ')[0]),
            Icons.access_time,
            iconColor: PalmColors.primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 28, // Consistent icon width
                  child: Icon(Icons.info_outline,
                      color: PalmColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 85, // Consistent label width
                  child: Text(
                    'Status:',
                    style: PalmTextStyles.body.copyWith(
                      color: PalmColors.textLight,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildStatusBadge(),
                  ),
                ),
              ],
            ),
          ),
          if (_canViewSupervisorComments &&
              widget.leaveRequest.supervisorComment != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28, // Consistent icon width
                    child: Icon(Icons.comment,
                        color: PalmColors.warning, size: 20),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 85, // Consistent label width
                    child: Text(
                      '${_currentRole == ApprovalRole.manager ? 'Manager' : 'Supervisor'} Comment:',
                      style: PalmTextStyles.body.copyWith(
                        color: PalmColors.textLight,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.leaveRequest.supervisorComment!,
                      style: PalmTextStyles.body.copyWith(
                        color: PalmColors.textNormal,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_canViewSupervisorComments &&
              widget.leaveRequest.supervisorActionDate != null) ...[
            _buildRequestInfoRow(
              '${_currentRole == ApprovalRole.manager ? 'Manager' : 'Supervisor'} Action Date:',
              _formatDate(
                  widget.leaveRequest.supervisorActionDate!.split(' ')[0]),
              Icons.schedule,
              iconColor: PalmColors.success,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Comment',
          style: PalmTextStyles.title.copyWith(
            color: PalmColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: PalmSpacings.s),
        Container(
          constraints: const BoxConstraints(
            minHeight: 120,
          ),
          decoration: BoxDecoration(
            color: PalmColors.greyLight.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _commentController,
            focusNode: _commentFocusNode,
            maxLines: null,
            minLines: 5,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            scrollPadding: const EdgeInsets.all(20),
            onTap: () {
              // Ensure proper scrolling on iOS when tapping TextField
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_commentFocusNode.hasFocus) {
                  Scrollable.ensureVisible(
                    context,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              });
            },
            onSubmitted: (_) {
              // Dismiss keyboard when done is pressed
              _commentFocusNode.unfocus();
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(PalmSpacings.m),
              hintText: 'Type your comment here...',
              border: InputBorder.none,
              isCollapsed: false,
            ),
          ),
        ),
        if (_canViewSupervisorComments &&
            widget.leaveRequest.supervisorComment != null) ...[
          const SizedBox(height: PalmSpacings.m),
          Text(
            'Previous Comments',
            style: PalmTextStyles.title.copyWith(
              color: PalmColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: PalmSpacings.s),
          _buildPreviousComment(
            _currentRole == ApprovalRole.manager ? 'Manager' : 'Supervisor',
            widget.leaveRequest.supervisorComment!,
            widget.leaveRequest.supervisorActionDate!,
          ),
        ],
      ],
    );
  }

  Widget _buildPreviousComment(String role, String comment, String timestamp) {
    return Container(
      margin: const EdgeInsets.only(bottom: PalmSpacings.s),
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                role,
                style: PalmTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: PalmColors.primary,
                ),
              ),
              Text(
                _formatDate(timestamp.split(' ')[0]),
                style: PalmTextStyles.label.copyWith(
                  color: PalmColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment,
            style: PalmTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ApprovalProvider approvalProvider) {
    final isSubmitting = approvalProvider.isSubmittingAction;

    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            text: 'Reject',
            backgroundColor: PalmColors.danger,
            onPressed: isSubmitting ? null : _handleReject,
            icon: Icons.close,
          ),
        ),
        const SizedBox(width: PalmSpacings.m),
        Expanded(
          child: _buildActionButton(
            text: 'Approve',
            backgroundColor: PalmColors.success,
            onPressed: isSubmitting ? null : _handleApprove,
            icon: Icons.check,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color backgroundColor,
    required VoidCallback? onPressed,
    required IconData icon,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        icon: Icon(
          icon,
          size: 18,
        ),
        label: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 16, // Reduced from 24 to 16 for better mobile layout
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {bool isReason = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment:
            isReason ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 28, // Consistent icon width
            child: Icon(icon, color: PalmColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 85, // Consistent label width
            child: Text(
              label,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.textLight,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.textNormal,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: isReason ? 3 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? iconColor,
    bool showAvatar = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 28, // Consistent icon width
            child: Icon(icon, color: iconColor ?? PalmColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 85, // Consistent label width
            child: Text(
              label,
              style: PalmTextStyles.body.copyWith(
                color: PalmColors.textLight,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: PalmTextStyles.body.copyWith(
                      color: PalmColors.textNormal,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showAvatar) ...[
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: PalmColors.primary,
                    child: Text(
                      _getUserInitial(),
                      style: PalmTextStyles.body.copyWith(
                        color: PalmColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
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
    return leaveType
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  String _getStatusText() {
    switch (widget.leaveRequest.status.toLowerCase()) {
      case 'pending':
        // Change UI text based on current role
        if (_currentRole == ApprovalRole.supervisor) {
          return 'Pending Manager Approval';
        } else if (_currentRole == ApprovalRole.manager) {
          return 'Pending Dept Approved';
        }
        return 'Pending ${_currentRole.toString().toLowerCase()} approval';
      case 'supervisor_approved':
        return _currentRole == ApprovalRole.manager
            ? 'Manager Approved'
            : 'Supervisor Approved';
      case 'manager_approved':
        return 'Manager Approved';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return widget.leaveRequest.status;
    }
  }

  IconData _getStatusIcon() {
    switch (widget.leaveRequest.status.toLowerCase()) {
      case 'approved':
      case 'supervisor_approved':
      case 'manager_approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
      default:
        return Icons.access_time;
    }
  }

  Color _getStatusColor() {
    switch (widget.leaveRequest.status.toLowerCase()) {
      case 'approved':
      case 'supervisor_approved':
      case 'manager_approved':
        return PalmColors.success;
      case 'rejected':
        return PalmColors.danger;
      case 'pending':
      default:
        return PalmColors.warning;
    }
  }

  /// Get user initial for avatar
  String _getUserInitial() {
    final firstName = widget.leaveRequest.firstNameEng;
    if (firstName.trim().isNotEmpty) {
      return firstName.trim()[0].toUpperCase();
    }
    return 'U'; // Default fallback
  }

  /// Build status badge with appropriate color and styling
  Widget _buildStatusBadge() {
    final statusColor = _getStatusColor();
    final statusText = _getStatusText();
    final statusIcon = _getStatusIcon();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PalmSpacings.s,
        vertical: PalmSpacings.xxs,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              statusText,
              style: PalmTextStyles.label.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
