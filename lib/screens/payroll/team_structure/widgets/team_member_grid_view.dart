import 'package:flutter/material.dart';
import '../../../../models/team/team_member.dart';
import '../../../../theme/app_theme.dart';
import 'team_member_card.dart';

/// Grid view widget for displaying team members in a card layout
/// 
/// This widget shows:
/// - Team members in a responsive grid
/// - Tap functionality for navigation to entity details
/// - Long press for drilling down to team members (if they have children)
/// - Responsive design for different screen sizes
class TeamMemberGridView extends StatelessWidget {
  /// List of team members to display
  final List<TeamMember> members;
  
  /// Callback when a member card is tapped (for entity details)
  final Function(TeamMember)? onMemberTap;
  
  /// Callback when a member card is long pressed (for drill down navigation)
  final Function(TeamMember)? onMemberLongPress;
  
  /// Creates a team member grid view widget
  const TeamMemberGridView({
    Key? key,
    required this.members,
    this.onMemberTap,
    this.onMemberLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PalmSpacings.m),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: PalmSpacings.m,
          mainAxisSpacing: PalmSpacings.m,
        ),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          return TeamMemberCard(
            member: member,
            onTap: () => onMemberTap?.call(member),
            onLongPress: member.hasChildren ? () => onMemberLongPress?.call(member) : null,
            showMemberCount: true,
          );
        },
      ),
    );
  }
} 