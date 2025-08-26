import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A widget that displays the approval workflow for leave requests
/// Shows supervisor and manager information in a structured format
class LeaveApprovalWorkflow extends StatelessWidget {
  final String supervisorName;
  final String managerName;

  const LeaveApprovalWorkflow({
    super.key,
    required this.supervisorName,
    required this.managerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PalmSpacings.m),
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radius),
        boxShadow: [
          BoxShadow(
            color: PalmColors.dark.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          _buildSectionHeader(),

          const SizedBox(height: PalmSpacings.m),

          // Info message
          _buildInfoMessage(),

          const SizedBox(height: PalmSpacings.m),

          // Supervisor approval
          _buildApprovalField(
            'Manager Review',
            supervisorName,
            'Will verify and certify your leave request',
            Icons.person_outline,
          ),

          const SizedBox(height: PalmSpacings.m),

          // Manager approval
          _buildApprovalField(
            'Head of Dept Approval',
            managerName,
            'Final approval and authorization',
            Icons.supervisor_account_outlined,
          ),
        ],
      ),
    );
  }

  /// Build section header with icon and title
  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(PalmSpacings.xs),
          decoration: BoxDecoration(
            color: PalmColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(PalmSpacings.xs),
          ),
          child: Icon(
            Icons.approval_outlined,
            color: PalmColors.primary,
            size: 16,
          ),
        ),
        const SizedBox(width: PalmSpacings.s),
        Text(
          'APPROVAL WORKFLOW',
          style: PalmTextStyles.label.copyWith(
            color: PalmColors.textLight,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  /// Build info message explaining the workflow
  Widget _buildInfoMessage() {
    return Text(
      'Your request will follow this approval sequence automatically.',
      style: PalmTextStyles.caption.copyWith(
        color: PalmColors.textLight,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  /// Build approval field showing person information
  Widget _buildApprovalField(
      String title, String personName, String description, IconData icon) {
    // Get first letter of person's name for avatar
    String avatarLetter =
        personName.isNotEmpty ? personName[0].toUpperCase() : '?';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          title,
          style: PalmTextStyles.label.copyWith(
            fontWeight: FontWeight.w500,
            color: PalmColors.textNormal,
          ),
        ),
        const SizedBox(height: PalmSpacings.xs),

        // Field container
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: PalmSpacings.m,
            vertical: PalmSpacings.s,
          ),
          decoration: BoxDecoration(
            color: PalmColors.greyLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(PalmSpacings.radius),
          ),
          child: Row(
            children: [
              // Avatar with first letter
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: PalmColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    avatarLetter,
                    style: PalmTextStyles.body.copyWith(
                      color: PalmColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: PalmSpacings.s),
              Expanded(
                child: Text(
                  personName,
                  style: PalmTextStyles.body.copyWith(
                    color: PalmColors.textNormal,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Helper text
        if (description.isNotEmpty) ...[
          const SizedBox(height: PalmSpacings.xs),
          Padding(
            padding: const EdgeInsets.only(left: PalmSpacings.m),
            child: Text(
              description,
              style: PalmTextStyles.caption.copyWith(
                color: PalmColors.textLight,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
