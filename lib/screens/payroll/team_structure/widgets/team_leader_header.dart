import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/team/team_member.dart';
import '../../../../theme/app_theme.dart';

/// Header widget displaying the current team leader information
/// 
/// This widget shows:
/// - Team leader profile picture
/// - Name and position
/// - Number of direct reports
/// - Beautiful gradient background
class TeamLeaderHeader extends StatelessWidget {
  /// The team member to display as leader
  final TeamMember teamLeader;
  
  /// Creates a team leader header widget
  const TeamLeaderHeader({
    Key? key,
    required this.teamLeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(PalmSpacings.m),
      padding: const EdgeInsets.all(PalmSpacings.l),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PalmSpacings.radius),
        gradient: LinearGradient(
          colors: [
            PalmColors.primary,
            PalmColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: PalmColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1 - Display profile picture
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: CachedNetworkImage(
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              imageUrl: teamLeader.displayProfilePicture,
              placeholder: (context, url) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    teamLeader.name.isNotEmpty ? teamLeader.name[0].toUpperCase() : '?',
                    style: PalmTextStyles.title.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    teamLeader.name.isNotEmpty ? teamLeader.name[0].toUpperCase() : '?',
                    style: PalmTextStyles.title.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: PalmSpacings.m),
          
          // 2 - Display name
          Text(
            teamLeader.name,
            style: PalmTextStyles.title.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          
          // 3 - Display position if available
          if (teamLeader.position != null) ...[
            const SizedBox(height: PalmSpacings.xs),
            Text(
              teamLeader.position!,
              style: PalmTextStyles.body.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 