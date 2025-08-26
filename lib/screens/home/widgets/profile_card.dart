import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/profile_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/asyncvalue.dart';
import 'package:palm_ecommerce_mobile_app_2/models/profile/profile.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;
  final double iconSize;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    required this.label,
    this.iconSize = 23,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: 'Inter',
                  fontSize: 8,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileProvider, AuthProvider>(
      builder: (context, profileProvider, authProvider, child) {
        final asyncValue = profileProvider.profileInfo;

        // Check if user is logged in first
        if (!authProvider.isLoggedIn) {
          return _buildSkeletonProfileCard();
        }

        // Handle initial null state
        if (asyncValue == null) {
          // Use safe loading method that checks auth state
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            print('🔄 ProfileCard: Triggering safe profile load...');

            // Wait for auth to be ready before loading
            final authReady = await authProvider.waitForAuth(
                timeout: const Duration(seconds: 3));
            if (authReady) {
              profileProvider.getProfileInfoSafe();
            } else {
              print('❌ ProfileCard: Auth not ready, showing skeleton');
            }
          });
          return _buildSkeletonProfileCard();
        }

        // Handle all three states based on AsyncValueState
        switch (asyncValue.state) {
          case AsyncValueState.loading:
            return _buildSkeletonProfileCard();
          case AsyncValueState.success:
            return _buildProfileCard(asyncValue.data!);
          case AsyncValueState.error:
            // If it's an auth error and we just logged in, try to reload
            if (asyncValue.error
                .toString()
                .contains('Authentication required')) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                print('🔄 ProfileCard: Auth error detected, retrying...');
                final authReady = await authProvider.waitForAuth(
                    timeout: const Duration(seconds: 2));
                if (authReady) {
                  profileProvider.getProfileInfoSafe();
                }
              });
              return _buildSkeletonProfileCard();
            }
            return _buildErrorProfileCard(asyncValue.error);
        }
      },
    );
  }

  // Helper functions to get manager and supervisor names from ProfileInfo
  String _getManagerName(ProfileInfo profile) {
    return profile.managerName ?? 'Not Assigned';
  }

  String _getSupervisorName(ProfileInfo profile) {
    return profile.supervisorName ?? 'Not Assigned';
  }

  Widget _buildSkeletonProfileCard() {
    // Create a fake profile for the skeleton
    final fakeProfile = ProfileInfo(
      profileId: '12345',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      position: 'Software Developer',
      department: 'IT Department',
      profileImage: '',
      gender: 'Male',
      dob: '1990-01-01',
      status: 'Active',
      memberSince: '2023-01-01',
    );

    return Skeletonizer(
      enabled: true,
      effect: const ShimmerEffect(),
      child: _buildProfileCard(fakeProfile),
    );
  }

  Widget _buildErrorProfileCard(Object? error) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2C5282),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Error loading profile: ${error.toString()}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(ProfileInfo profile) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2C5282),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        children: [
          // Top section with avatar and name
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar section
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Decorative circle behind avatar
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    // Avatar with border
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: profile.profileImage.isNotEmpty
                            ? Image.network(
                                profile.profileImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildProfileInitial(profile.name);
                                },
                              )
                            : _buildProfileInitial(profile.name),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // Name and position
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Not Specified',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            color: Colors.white30,
            thickness: 1,
            height: 1,
          ),

          // Info section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side with employee info
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Employee ID row
                      InfoRow(
                        icon: Icons.how_to_reg,
                        text: profile.profileId!,
                        label: 'ID',
                        iconSize: 14,
                      ),
                      const SizedBox(height: 8),

                      // Department row
                      InfoRow(
                        icon: Icons.business,
                        text: profile.department ?? 'Not Assigned',
                        label: 'Department',
                        iconSize: 14,
                      ),
                    ],
                  ),
                ),

                //middle size column
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InfoRow(
                        icon: Icons.supervisor_account,
                        text: _getManagerName(profile),
                        label: 'Head Of Dept',
                        iconSize: 14,
                      ),
                      const SizedBox(height: 8),
                      InfoRow(
                        icon: Icons.person,
                        text: _getSupervisorName(profile),
                        label: 'Manager',
                        iconSize: 14,
                      ),
                    ],
                  ),
                ),

                // Right column
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InfoRow(
                        icon: Icons.location_on,
                        text: profile.branchName ?? 'Not Assigned',
                        label: 'Branch',
                        iconSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInitial(String name) {
    final String initial =
        name.isNotEmpty ? name.trim().split(' ').first[0].toUpperCase() : '?';
    return Container(
      color: Colors.blueGrey[700],
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
