import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/approval/approval_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/approval/pending_approval_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

class PendingIcon extends StatelessWidget {
  const PendingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ApprovalProvider, AuthProvider>(
      builder: (context, approvalProvider, authProvider, child) {
        // Only show pending icon if user is logged in
        if (!authProvider.isLoggedIn) {
          return _buildEmptyPendingIcon(context);
        }

        // Trigger loading if approval data is null and auth is ready
        if (approvalProvider.approvalDashboard == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final authReady = await authProvider.waitForAuth(timeout: const Duration(seconds: 2));
            if (authReady) {
              approvalProvider.getApprovalDashboard();
            }
          });
          return _buildEmptyPendingIcon(context);
        }

        // Get pending count based on approval state
        int pendingCount = 0;
        if (approvalProvider.approvalDashboard?.state == AsyncValueState.success) {
          pendingCount = approvalProvider.totalPendingCount;
        }

        return _buildPendingIcon(context, pendingCount);
      },
    );
  }

  Widget _buildEmptyPendingIcon(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.pending_actions, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
      onPressed: () => _navigateToApprovals(context),
    );
  }

  Widget _buildPendingIcon(BuildContext context, int pendingCount) {
    return IconButton(
      icon: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
            
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Icon(Icons.pending_actions, color: Colors.white, size: 28),
            ),
          ),
          if (pendingCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                decoration: BoxDecoration(
                  color: PalmColors.danger,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  pendingCount > 99 ? '99+' : pendingCount.toString(),
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      onPressed: () => _navigateToApprovals(context),
    );
  }

  void _navigateToApprovals(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PendingApprovalScreen(
          title: 'Pending Approvals',
        ),
      ),
    ).then((_) {
      // Refresh approval data when returning from approval screen
      final approvalProvider = Provider.of<ApprovalProvider>(context, listen: false);
      approvalProvider.refreshApprovalDashboard();
    });
  }
} 
