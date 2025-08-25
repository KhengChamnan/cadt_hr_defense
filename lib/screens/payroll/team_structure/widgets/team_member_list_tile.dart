import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/team/team_member.dart';
import '../../../../theme/app_theme.dart';

/// A list tile widget for displaying team member information in the team structure screen
/// 
/// This widget displays:
/// - Member profile picture
/// - Member name and position
/// - Number of team members under them
/// - Tap functionality for navigation to entity details
/// - Long press functionality for drilling down into team structure
class TeamMemberListTile extends StatelessWidget {
  /// The team member to display
  final TeamMember member;
  
  /// Callback when the tile is tapped (for entity details)
  final VoidCallback? onTap;
  
  /// Callback when the tile is long pressed (for drill down navigation)
  final VoidCallback? onLongPress;
  
  /// Whether to show the member count
  final bool showMemberCount;
  
  /// Creates a team member list tile widget
  const TeamMemberListTile({
    Key? key,
    required this.member,
    this.onTap,
    this.onLongPress,
    this.showMemberCount = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          vertical: PalmSpacings.xxs,
          horizontal: PalmSpacings.xs,
        ),
        decoration: const BoxDecoration(
          // Remove margin, padding, and border radius for seamless list
        ),
        child: Column(
          children: [
            // Header section with member name and status
            Container(
              width: double.infinity,
              height: 31,
              decoration: BoxDecoration(
                color: PalmColors.primary.withOpacity(0.8),
                // Remove border radius for flat design
              ),
              child: Row(
                children: [
                  const SizedBox(width: 18),
                  Text(
                    member.name,
                    style: PalmTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (member.hasChildren)
                    Container(
                      width: 89,
                      height: 31,
                      decoration: BoxDecoration(
                        color: PalmColors.success,
                        // Remove border radius for flat design
                      ),
                      child: Center(
                        child: Text(
                          'Team Lead',
                          style: PalmTextStyles.button.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                // Remove border radius for flat design
                border: Border.all(
                  color: PalmColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      imageUrl: member.displayProfilePicture,
                      placeholder: (context, url) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: PalmColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                            style: PalmTextStyles.body.copyWith(
                              color: PalmColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: PalmColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                            style: PalmTextStyles.body.copyWith(
                              color: PalmColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Member details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Position row
                        if (member.position != null)
                          Row(
                            children: [
                              // Position icon
                              Container(
                                width: 15,
                                height: 15,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: PalmColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Icon(
                                  Icons.work,
                                  size: 11,
                                  color: PalmColors.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'Position: ${member.position}',
                                  style: PalmTextStyles.label.copyWith(
                                    color: PalmColors.textLight,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        if (member.position != null) const SizedBox(height: 8),
                        // Department row
                        if (member.department != null)
                          Row(
                            children: [
                              // Department icon
                              Container(
                                width: 16,
                                height: 16,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: PalmColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Icon(
                                  Icons.business,
                                  size: 12,
                                  color: PalmColors.success,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  'Department: ${member.department}',
                                  style: PalmTextStyles.label.copyWith(
                                    color: PalmColors.textLight,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        if (member.department != null) const SizedBox(height: 8),
                        // Team members row
                        if (showMemberCount && member.hasChildren)
                          Row(
                            children: [
                              // Team icon
                              Container(
                                width: 18,
                                height: 18,
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: PalmColors.warning.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Icon(
                                  Icons.group,
                                  size: 12,
                                  color: PalmColors.warning,
                                ),
                              ),
                              const SizedBox(width: 13),
                              Expanded(
                                child: Text(
                                  'Team Members: ${member.children.length}',
                                  style: PalmTextStyles.label.copyWith(
                                    color: PalmColors.textLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: PalmColors.primary.withOpacity(0.1),
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
                                  '${member.children.length} members',
                                  style: PalmTextStyles.label.copyWith(
                                    color: PalmColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // Navigation arrow if has children
                  if (member.hasChildren) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: PalmColors.iconLight,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 