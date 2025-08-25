import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/team/team_member.dart';
import '../../../../theme/app_theme.dart';

/// A card widget for displaying team member information in the team structure screen
/// 
/// This widget displays:
/// - Member profile picture
/// - Member name and position
/// - Number of team members under them
/// - Tap functionality for navigation to entity details
/// - Long press functionality for drilling down into team structure
class TeamMemberCard extends StatelessWidget {
  /// The team member to display
  final TeamMember member;
  
  /// Callback when the card is tapped (for entity details)
  final VoidCallback? onTap;
  
  /// Callback when the card is long pressed (for drill down navigation)
  final VoidCallback? onLongPress;
  
  /// Whether to show the member count
  final bool showMemberCount;
  
  /// Creates a team member card widget
  const TeamMemberCard({
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
        padding: const EdgeInsets.all(PalmSpacings.m),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          color: PalmColors.primary.withOpacity(0.1),
          border: Border.all(
            color: PalmColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1 - Display profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                imageUrl: member.displayProfilePicture,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: PalmColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                      style: PalmTextStyles.body.copyWith(
                        color: PalmColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: PalmColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                      style: PalmTextStyles.body.copyWith(
                        color: PalmColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: PalmSpacings.xs),
            
            // 2 - Display member name
            Text(
              member.name,
              style: PalmTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: PalmColors.textNormal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // 3 - Display position if available
            if (member.position != null) ...[
              const SizedBox(height: PalmSpacings.xxs),
              Text(
                member.position!,
                style: PalmTextStyles.label.copyWith(
                  color: PalmColors.textLight,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            // 4 - Display member count if enabled and has children
            if (showMemberCount && member.hasChildren) ...[
              const SizedBox(height: PalmSpacings.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PalmSpacings.xs,
                  vertical: PalmSpacings.xxs,
                ),
                decoration: BoxDecoration(
                  color: PalmColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${member.children.length} Members',
                  style: PalmTextStyles.label.copyWith(
                    color: PalmColors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 